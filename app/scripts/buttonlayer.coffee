define ["leaflet", "subwaycolors"], (L, SubwayColors) ->

    class ButtonLayer extends L.Class
        constructor: (@latlng, @colors) ->
       
        onAdd: (@map) =>
            @map.on "viewreset", @_reset
            @_reset()

        _reset: () =>
            if @drawCanvas then @drawCanvas.remove()
            @point = @map.latLngToLayerPoint @latlng

           
            diameter = @map.getZoom() * 2.5

            @point.x -= diameter/2
            @point.y -= diameter/2

            @drawCanvas = $("<canvas/>")
            @drawCanvas.attr "width", diameter * 4
            @drawCanvas.attr "height", diameter * 4

            zoomedDiameter = diameter * 4

            @drawCanvas.css
                width: diameter
                height: diameter
                display:"block"
                position: "absolute"
                top:0
                left:0

            @ctx = @drawCanvas[0].getContext("2d")

            $(@map.getPanes().markerPane).append(@drawCanvas)

            @ctx.beginPath()
            @ctx.arc(zoomedDiameter/2,zoomedDiameter/2,(zoomedDiameter/2)-4,0,360)
            @ctx.fillStyle = "rgba(0,0,0,0.5)"
            @ctx.strokeStyle = "#999"
            @ctx.fill()
            @ctx.lineWidth = 4
            @ctx.stroke()


            degreesEach = 360 / @colors.length
            for color,i in @colors
                @ctx.beginPath()
                @ctx.moveTo(zoomedDiameter/2,zoomedDiameter/2)
                @ctx.arc(zoomedDiameter/2,zoomedDiameter/2,zoomedDiameter/2 * 0.8,(degreesEach*i)* (Math.PI/180),(degreesEach*(i+1))* (Math.PI/180))
                @ctx.closePath()
                @ctx.fillStyle = color
                @ctx.fill()




            L.DomUtil.setPosition(@drawCanvas[0], @point)
