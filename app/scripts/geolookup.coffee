define ["config","vendor/latlon","leaflet","async"], (Config,LatLon,L, async) ->
    class GeoLocator
        stationList: null
        constructor: () ->

        getLocationToAccuracy: (metres, cb) =>

            success = (loc) =>
                if loc.coords.accuracy <= metres

                    navigator.geolocation.clearWatch @watch

                    if loc.coords.latitude > 41.237 || loc.coords.latitude < 40.528 || loc.coords.longitude <  -74.067 || loc.coords.longitude > -73.586
                        alert "Looks like you aren't in New York. But to demonstrate the app, we're going to pretend you are anyway."
                        return cb
                            coords:
                                latitude: 40.7328
                                longitude: -73.9921


                    cb(loc)
                    

            @watch = navigator.geolocation.watchPosition success

        loadStations: (cb) =>
            $.ajax
                url: Config.dataDomain + Config.stationsFile
                dataType: "json"
                success: (json) =>
                    @stationList = json
                    cb()

        lookupStations: (loc,cb) ->
            if !@stationList then return @loadStations () =>
                @lookupStations(loc,cb)

            radius = 0.7 # search 0.7km from source
            initialPoint = new LatLon(loc.coords.latitude, loc.coords.longitude)
            sw = initialPoint.destinationPoint(225, radius)
            ne = initialPoint.destinationPoint(45, radius)
            
            bounds = new L.LatLngBounds([sw.lat(), sw.lon()], [ne.lat(), ne.lon()])
                
            nearbyStations = @stationList.filter (s) ->
                return bounds.contains [parseFloat(s.lat), parseFloat(s.lng)]

            nearbyStations.forEach (s) ->
                if !s.entrances || s.entrances.length ==0
                    return s.nearestEntrance = [parseFloat(s.lat), parseFloat(s.lng)]
                s.entrances.sort (a,b) ->
                    return new LatLon(a[0],a[1]).distanceTo(initialPoint) - new LatLon(b[0], b[1]).distanceTo(initialPoint)
                s.nearestEntrance = [parseFloat(s.entrances[0][0]), parseFloat(s.entrances[0][1])]

            
            dayOfWeek = new Date().getDay()
            suffix = "WKD"
            if dayOfWeek == 0 then suffix = "SUN"
            else if dayOfWeek == 6 then suffix = "SAT"


            async.map nearbyStations, (station,cb) =>
                $.ajax
                    url: Config.dataDomain + Config.stopsDirectory + "/" + "#{station.code}_#{suffix}.json.gz"
                    dataType:"json"
                    success: (json) =>
                       
                        filteredTimes = @filterForCurrentTimes json, (filtered) ->
                            station.times = filtered
                            cb(null,station)
            , (err, array) =>
                @getUniqueRoutes(initialPoint, array, cb)

        filterForCurrentTimes: (stopList, cb) ->
            rightnowMinute = new Date().getHours() * 60
            rightnowMinute += new Date().getMinutes()

            returnArray = []

            for stop in stopList
                # It's before now
                if stop.time <= rightnowMinute then  continue
                returnArray.push stop
                if returnArray.length == 5 then break

            cb returnArray

        getUniqueRoutes: (loc, stations, cb) ->
            stations.forEach (s) ->
                routesServed = []
                for t in s.times
                    if routesServed.indexOf(t.route) == -1
                        routesServed.push(t.route)

                s.routes = routesServed

                s.distanceFromUser = loc.distanceTo new LatLon(parseFloat(s.lat), parseFloat(s.lng)) 
               
            
            stations.sort (a,b) ->
                return a.distanceFromUser - b.distanceFromUser

            routesAlreadyCounted = []
            finalStationList = []

            for station in stations
                for route in station.routes
                    if routesAlreadyCounted.indexOf(route) == -1
                        station.routes = station.routes.filter (r) ->
                            routesAlreadyCounted.indexOf(r) == -1
                            
                        finalStationList.push(station)
                        routesAlreadyCounted = routesAlreadyCounted.concat(station.routes)
                        break;

            cb(finalStationList)


