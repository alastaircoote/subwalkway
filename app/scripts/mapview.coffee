define ["jquery", "leaflet","routelayer", "buttonlayer","subwaycolors"], ($, L, RouteLayer, ButtonLayer, SubwayColors) ->
    class MapView
        constructor: (@el) ->
            @el.parents(".side").first().css
                "display":"block"
                "visibility": "hidden"

            @map = L.map(@el[0],
                zoomControl: false
                attributionControl:false
                dragging:false
                touchZoom:false
            ).setView([40.7570, -73.9819], 11);

            @map.on "load", () ->
                @el.parents(".side").first().css
                    #"display":"none"
                    #"visibility": "visible"

            opts = {}
            if L.Browser.retina
                opts = {detectRetina:true,tileSize:128,zoomOffset:1}
            L.tileLayer('http://a.tiles.mapbox.com/v3/alastaircoote.map-xgyabfvz/{z}/{x}/{y}.png',opts).addTo(@map);

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
            zoom = @map.getBoundsZoom bounds

            @map.setView bounds.getCenter(), zoom
            #@map.fitBounds bounds

        drawRoutes: (routes) =>

            if @routeLayer then @map.removeLayer(@routeLayer)
            @routeLayer.destroy()

            #withLines = routes.filter((r) -> console.log r; r.route.legs.length > 0)

            routes.forEach (routeObj) ->
                console.log routeObj
                points = routeObj.route.overview_path.map (p) -> [p.lat(), p.lng()]
    
                points.push routeObj.nearestEntrance

                return routeObj.route.mappedShape = points



            @routeLayer = new RouteLayer(routes)
            @map.addLayer(@routeLayer)
            @routeLayer.drawRoutes()

        makeButtons: (stations) =>
            for station in stations
                distinctColors = []
                for r in station.routes
                    c = SubwayColors[r]
                    if distinctColors.indexOf(c) == -1 then distinctColors.push(c)

                buttonLayer = new ButtonLayer station.nearestEntrance, distinctColors
                @map.addLayer(buttonLayer)


