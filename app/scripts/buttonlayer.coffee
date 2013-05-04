define ["leaflet", "subwaycolors"], (L, SubwayColors) ->

    class ButtonLayer extends L.Class
        constructor: (@latlng, @colors) ->
            console.log @latlng

        onAdd: (@map) =>
            @map.on "viewreset", @_reset
            @_reset()

        _reset: () =>
            if @drawCanvas then @drawCanvas.remove()
            @point = @map.latLngToLayerPoint @latlng

            console.log @point

            diameter = @map.getZoom() * 3

            @point.x -= diameter/2
            @point.y -= diameter/2

            @drawCanvas = $("<canvas/>")
            @drawCanvas.attr "width", diameter * 4
            @drawCanvas.attr "height", diameter * 4

            @drawCanvas.css
                width: diameter
                height: diameter
                background: @colors[0]
                display:"block"
                position: "absolute"
                top:0
                left:0

            @ctx = @drawCanvas[0].getContext("2d")

            $(@map.getPanes().markerPane).append(@drawCanvas)

            L.DomUtil.setPosition(@drawCanvas[0], @point)
