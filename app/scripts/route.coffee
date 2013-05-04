define ["config","async"], (Config, async) ->
    class Router
        @getRoute: (from, to,cb) ->
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

        @getMultipleRoutes: (from, toArray, cb) ->
            async.map toArray, (to, cbb) =>
                @getRoute from, [to.lat,to.lng], (json) ->
                    cbb null,
                        id: to.id
                        route: json.route

            , (err,results) =>
                cb(results)
