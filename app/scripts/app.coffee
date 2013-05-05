define ["jquery","new/station-list","new/card","geolookup","route","subwaycolors","new/mapview"],
($, StationList,RotateCard,GeoLookup,Router,Colors, MapView) ->
    new RotateCard($(".glasspane"))

    station = new StationList()
    geo = new GeoLookup()
    geo.getLocationToAccuracy 150, (loc) ->
        geo.lookupStations loc, (stations) ->

            map = new MapView($("#mapDiv"), [loc.coords.latitude, loc.coords.longitude])

            pointsToRoute = stations.map (s) ->
                return {lat: s.nearestEntrance[0], lng: s.nearestEntrance[1], id: s.code}

            Router.getMultipleRoutes [loc.coords.latitude, loc.coords.longitude], pointsToRoute, (routes) ->
                stations.forEach (s) ->
                    s.route = routes.filter((r) -> r.id == s.code)[0].route

                station.takeStationData(stations, map)

                



###
define ["jquery", "mapview", "geolookup","route"], ($, MapView, GeoLookup,Router) ->
    



    
    map = new MapView $("#mapDiv")


    geo = new GeoLookup()
    geo.getLocationToAccuracy 150, (loc) ->
        geo.lookupStations loc, (stations) ->

            pointsToRoute = stations.map (s) ->
                return {lat: s.nearestEntrance[0], lng: s.nearestEntrance[1], id: s.code}

            Router.getMultipleRoutes [loc.coords.latitude, loc.coords.longitude], pointsToRoute, (routes) ->
                console.log routes
                stations.forEach (s) ->
                    s.route = routes.filter((r) -> r.id == s.code)[0].route

                doDraw = () ->
                    map.off "zoomend", doDraw
                    map.drawRoutes(stations)
                    map.makeButtons(stations)

                map.on "zoomend", doDraw
                console.log stations.map (s) -> [s.nearestEntrance]
                map.fitPoints stations.map (s) -> [s.nearestEntrance]
###

