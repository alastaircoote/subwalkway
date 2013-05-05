define ["leaflet", "subwaycolors","lineintersect"], (L, SubwayColors, lineIntersect) ->

    class RouteLayer extends L.Class
        lineWidth: 5
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

            $(@map.getPanes().overlayPane).append(@drawCanvas)

            L.DomUtil.setPosition(@drawCanvas, @topLeft)

            
        drawRoutes: () =>

            toDraw = []

            for route in @routes
                distinctColors = []
                for r in route.routes
                    c = SubwayColors[r]
                    if distinctColors.indexOf(c) == -1 then distinctColors.push(c)
                route.colors = distinctColors

                route.mappedShape = route.route.mappedShape.map (s, i) =>
                    p = @map.latLngToLayerPoint(s)
                    p.x = p.x - @topLeft.x# + offset
                    p.y = p.y - @topLeft.y# + offset
                    return p

                for color in distinctColors
                    toDraw.push
                        shape: route.route.mappedShape
                        color: color
                        mappedShape: route.mappedShape

                

            for route, iy in @routes

                offset = @lineWidth * iy
            
                if route.colors.length > 1

                    pattern = document.createElementNS "http://www.w3.org/2000/svg", "pattern"
                    pattern.setAttribute "height", @lineWidth
                    pattern.setAttribute "width", @lineWidth * route.colors.length
                    pattern.setAttribute "id", "r" + route.code
                    pattern.setAttribute "viewBox", "0 0 #{@lineWidth * route.colors.length} #{@lineWidth}"
                    pattern.setAttribute "patternUnits", "userSpaceOnUse"

                    for color, x in route.colors
                        rect = document.createElementNS "http://www.w3.org/2000/svg", "rect"
                        rect.setAttribute "x", @lineWidth * x
                        rect.setAttribute "y", 0
                        rect.setAttribute "width", @lineWidth
                        rect.setAttribute "height", @lineWidth
                        rect.setAttribute "fill", color
                        pattern.appendChild(rect)

                    @defs.appendChild(pattern)
                

                coords = route.mappedShape.map (s, i) =>
                    s.x + " " + s.y

                path = document.createElementNS "http://www.w3.org/2000/svg", "path"
                path.setAttribute "d", "M " + coords.join(" L ")
                path.setAttribute "stroke-width", @lineWidth
                path.setAttribute "stroke", "#999"
                #path.setAttribute "stroke-opacity", "0.7"
                #if route.colors.length == 1
                #    path.setAttribute "stroke", route.colors[0]
                #else
                #    path.setAttribute "stroke", "url(#r#{route.code})"
                path.setAttribute "fill", "none"
                path.setAttribute "stroke-linejoin", "round"
                #path.setAttribute "transform", "translate(#{offset}, #{offset})"
                #path.setAttribute "stroke-dasharray", [5,5*i].join(",")

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


