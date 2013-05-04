define ["leaflet", "subwaycolors","lineintersect"], (L, SubwayColors, lineIntersect) ->

    class RouteLayer extends L.Class
        lineWidth: 3
        constructor: (@routes) ->
            allPoints = []
            @routes.forEach (r) ->
                console.log r
                allPoints = allPoints.concat r.route.mappedShape
            @layerBounds = new L.LatLngBounds(allPoints)

        onAdd: (@map) =>
            @map.on "viewreset", @_reset
            @_reset()

        _reset: () =>
            if @drawCanvas then @drawCanvas.remove()
            @topLeft = @map.latLngToLayerPoint @layerBounds.getNorthWest()
            @topLeft.y -= @lineWidth
            @topLeft.x -= @lineWidth
            bottomRight = @map.latLngToLayerPoint @layerBounds.getSouthEast()
            
            width = bottomRight.x - @topLeft.x + (@lineWidth * 2)
            height = bottomRight.y - @topLeft.y + (@lineWidth * 2)


            @drawCanvas = $("<canvas/>")
            @drawCanvas.attr "width", width * 4
            @drawCanvas.attr "height", height * 4

            @drawCanvas.css
                width: width
                height: height

            @ctx = @drawCanvas[0].getContext("2d")

            $(@map.getPanes().overlayPane).append(@drawCanvas)

            L.DomUtil.setPosition(@drawCanvas[0], @topLeft)

            console.log @drawCanvas
            console.log "add", arguments
       
            
        drawRoutes: () =>

            toDraw = []

            for route in @routes
                distinctColors = []
                for r in route.routes
                    c = SubwayColors[r]
                    if distinctColors.indexOf(c) == -1 then distinctColors.push(c)

                for color in distinctColors
                    toDraw.push
                        shape: route.route.mappedShape
                        color: color


            toDraw.forEach (r) => @drawRoute(r)

        drawRoute: (route) =>
            @ctx.lineCap = "round"
            @ctx.lineJoin = "round"
            @ctx.strokeStyle = route.color
            @ctx.lineWidth = @lineWidth * 4

            offset = if route.color == "#2850AD" then 3 else 0
            console.log offset

            mappedPoints = route.shape.map (s) =>

                p = @map.latLngToLayerPoint(s)
                p.x = p.x - @topLeft.x + offset
                p.y = p.y - @topLeft.y + offset
                return p

            @ctx.beginPath()
            @ctx.moveTo(mappedPoints[0].x, mappedPoints[0].y)
            
            for point in mappedPoints[1..]
                @ctx.lineTo(point.x*4, point.y*4)

            @ctx.stroke()


