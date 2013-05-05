define ["leaflet", "subwaycolors","lineintersect"], (L, SubwayColors, lineIntersect) ->

    class RouteLayer extends L.Class
        lineWidth: 5
        constructor: (@points) ->

            @layerBounds = new L.LatLngBounds(points)

        destroy: () ->
            $(@drawCanvas).remove()

        onAdd: (@map) =>
            @map.on "viewreset", @_reset
            @_reset()

        onRemove: (@map) =>
            console.log "removing"
            @container.remove()

        _reset: () =>
            if @drawCanvas then @drawCanvas.remove()
            @topLeft = @map.latLngToLayerPoint @layerBounds.getNorthWest()
            @topLeft.y -= @lineWidth
            @topLeft.x -= @lineWidth
            bottomRight = @map.latLngToLayerPoint @layerBounds.getSouthEast()
            
            width = bottomRight.x - @topLeft.x + (@lineWidth * 2)
            height = bottomRight.y - @topLeft.y + (@lineWidth * 2)


            @container = $("<div/>")
            $(@map.getPanes().overlayPane).append(@container)
            @drawCanvas = document.createElementNS("http://www.w3.org/2000/svg", "svg");
            $(@drawCanvas).attr "width", width
            $(@drawCanvas).attr "height", height

            @defs = document.createElementNS("http://www.w3.org/2000/svg", "defs");
            @drawCanvas.appendChild(@defs)


            $(@drawCanvas).css
                width: width
                height: height

            #@svg = @drawCanvas[0]

            #@ctx = @drawCanvas[0].getContext("2d")

            @container.append(@drawCanvas)

            L.DomUtil.setPosition(@drawCanvas, @topLeft)

            
        drawRoutes: (@routes) =>

            toDraw = []

            console.log "routes", @routes

            for route in @routes
               route.mappedShape = route.shape.map (s, i) =>
                    p = @map.latLngToLayerPoint(s)
                    p.x = p.x - @topLeft.x# + offset
                    p.y = p.y - @topLeft.y# + offset
                    return p

            

            

            for route in @routes

                coords = route.mappedShape.map (s, i) =>
                    s.x + " " + s.y

                path = document.createElementNS "http://www.w3.org/2000/svg", "path"
                path.setAttribute "d", "M " + coords.join(" L ")
                path.setAttribute "stroke-width", @lineWidth
                path.setAttribute "stroke", route.color
                #path.setAttribute "stroke-opacity", "0.7"
                #if route.colors.length == 1
                #    path.setAttribute "stroke", route.colors[0]
                #else
                #    path.setAttribute "stroke", "url(#r#{route.code})"
                path.setAttribute "fill", "none"
                path.setAttribute "stroke-linejoin", "round"
                #path.setAttribute "transform", "translate(#{offset}, #{offset})"
                #path.setAttribute "stroke-dasharray", [5,5*i].join(",")
                console.log path
                @drawCanvas.appendChild(path)


            #toDraw.forEach (r) => @drawRoute(r)

        drawRoute: (route) =>
            return

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


