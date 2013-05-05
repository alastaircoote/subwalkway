define ["jquery", "subwaycolors"], ($,SubwayColors) ->
    class MapView
        constructor: (@el, center) ->
            return
            @el.parents(".side").first().css
                "display":"block"
                "visibility": "hidden"

            @map = L.map(@el[0],
                zoomControl: false
                attributionControl:false
                dragging:false
                touchZoom:false
            ).setView(center, 11);

            @el.parents(".side").first().css
                "display":""
                "visibility": ""

            opts = {}
            if L.Browser.retina
                opts = {detectRetina:true,tileSize:128,zoomOffset:1}
            L.tileLayer('http://a.tiles.mapbox.com/v3/alastaircoote.map-xgyabfvz/{z}/{x}/{y}.png',opts).addTo(@map);

        mapRoute: (r) =>

            points = r.station.route.overview_path.map (p) -> p.lat() + "," + p.lng()

            dimensions = 
                width: $("#mapDiv").width()
                height: $("#mapDiv").height()

            baseUrl = "http://maps.googleapis.com/maps/api/staticmap?"

            path = [
                "color:0x" + SubwayColors[r.route].substr(1)
                "weight:10"
            ]



            urlOpts = [
                "size=" + dimensions.width + "x" + dimensions.height
                "path=" + path.join("|") + "|" + points.join("|")
                "sensor=true"
                "style=saturation:-100|invert_lightness:true"
                #"key=AIzaSyCmJN58nGwCZcXNxFkpFPsE1PWUPf2V1u8"
                "scale=2"
            ]

            url = baseUrl + urlOpts.join("&")

            img = $("<img src='#{url}'/>")
            img.css dimensions

            $("#mapDiv").empty()
            $("#mapDiv").append(img)


            return
            if @routeLayer then @map.removeLayer(@routeLayer)

            zoomDone = () =>
                @map.off "zoomend", zoomDone
                @routeLayer = new RouteLayer(points)
                @map.addLayer(@routeLayer)
                @routeLayer.drawRoutes([{shape:points,color: SubwayColors[r.route]}])

            @map.on "zoomend", zoomDone
            
            points = r.station.route.overview_path.map (p) -> [p.lat(), p.lng()]
            pointsBounds = new L.LatLngBounds(points)
            zoom = @map.getBoundsZoom(new L.LatLngBounds(points))
            @map.setView pointsBounds.getCenter(),zoom

            
