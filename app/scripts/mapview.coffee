define ["jquery", "leaflet","routelayer", "buttonlayer","subwaycolors"], ($, L, RouteLayer, ButtonLayer, SubwayColors) ->
    class MapView
        constructor: (@el) ->
            @map = L.map(@el[0],
                zoomControl: false
                attributionControl:false
                dragging:false
                touchZoom:false
                detectRetina: false
            ).setView([40.7570, -73.9819], 11);

            L.tileLayer('http://a.tiles.mapbox.com/v3/alastaircoote.map-xgyabfvz/{z}/{x}/{y}.png',{detectRetina:true}).addTo(@map);

            ###
            layer = new MM.TemplatedLayer('http://a.tiles.mapbox.com/v3/alastaircoote.map-xgyabfvz/{Z}/{X}/{Y}.png')
            map = new MM.Map(@el[0], layer)
            map.tileSize = new MM.Point(128,128)
            
            map.setZoom(11)
            map.setCenter(new MM.Location(40.7570, -73.9819))
            ###

        on: () =>
            @map.on(arguments...)

        off: () =>
            @map.off(arguments...)

        fitPoints: (points) =>
            bounds = new L.LatLngBounds points
            bounds.pad(10)
            console.log points,bounds

            @map.fitBounds bounds

        drawRoutes: (routes) =>

            if @routeLayer then @map.removeLayer(@routeLayer)

            withLines = routes.filter((r) -> console.log r; r.route.legs.length > 0)

            withLines.forEach (routeObj) ->

                points = routeObj.route.shape.shapePoints
                translated = []
                x = 0
                while x < points.length
                    translated.push [points[x], points[x+1]]
                    x = x+2
                return routeObj.route.mappedShape = translated

            @routeLayer = new RouteLayer(withLines)
            @map.addLayer(@routeLayer)
            @routeLayer.drawRoutes()

        makeButtons: (stations) =>
            for station in stations
                distinctColors = []
                for r in station.routes
                    c = SubwayColors[r]
                    if distinctColors.indexOf(c) == -1 then distinctColors.push(c)

                buttonLayer = new ButtonLayer [station.lat, station.lng], distinctColors
                @map.addLayer(buttonLayer)


