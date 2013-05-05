define ["config","async"], (Config, async) ->

    gmapsLoaded = false

    class Router
        
        @loadGmaps: (cb) ->
            console.log "loading"
            window.gMapsComplete = () ->
                window.gMapsComplete = null
                console.log "LOADED"
                gmapsLoaded = true
                cb()
            $.ajax
                url: "https://maps.googleapis.com/maps/api/js?key=AIzaSyCmJN58nGwCZcXNxFkpFPsE1PWUPf2V1u8&sensor=true&callback=gMapsComplete"
                dataType:"script"
                cache:true


        @getRoute: (from, to,cb) ->
           
            console.log "direction"
            directionsService = new google.maps.DirectionsService();
            opts = 
                origin: "#{from[0]},#{from[1]}"
                destination: "#{to[0]}, #{to[1]}"
                travelMode: google.maps.TravelMode.WALKING

            directionsService.route opts, (result,status) ->
                cb result

            ###
            opts =
                key: Config.mapquestKey
                from: "#{from[0]},#{from[1]}"
                to: "#{to[0]}, #{to[1]}"
                #doReverseGeocode: false
                routeType: "pedestrian"
                shapeFormat: "raw"
                generalize: 0

            optsMapped = Object.keys(opts).map (k) ->
                k + "=" + opts[k]

            url = "http://open.mapquestapi.com/directions/v1/route?" + optsMapped.join("&")
            $.ajax
                url: url
                dataType: "jsonp"
                success: (json) ->
                    console.log json
                    cb json
            ###
        @getMultipleRoutes: (from, toArray, cb) ->

            if !gmapsLoaded
                return @loadGmaps () =>
                    @getMultipleRoutes from, toArray, cb

            async.map toArray, (to, cbb) =>
                @getRoute from, [to.lat,to.lng], (json) ->
                    console.log "id", to.id
                    cbb null,
                        id: to.id
                        route: json.routes[0]

            , (err,results) =>
                cb(results)
