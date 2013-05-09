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


    iconColors = [
        "blue"
        "brown"
        "darkgrey"
        "red"
        "green"
        "lgreen"
        "orange"
        "purple"
        "gray"
        "yellow"
    ]

    perColor = 1 / (iconColors.length-1)

    r = Math.random()

    index = Math.floor(r / perColor)


    $("head").append $("<link>",
        rel: "apple-touch-icon-precomposed"
        sizes: "114x114"
        href:"images/appicons/icon_114_#{iconColors[index]}.png"
    )



###
define ["jquery", "mapview", "geolookup","route"], ($, MapView, GeoLookup,Router) ->
    



    
    map = new MapView $("#mapDiv")


    geo = new GeoLookup()
    geo.getLocationToAccuracy 150, (loc) ->
        geo.lookupStations loc, (stations) ->

            pointsToRoute = stations.map (s) ->
                return {lat: s.nearestEntrance[0], lng: s.nearestEntrance[1], id: s.code}

            Router.getMultipleRoutes [loc.coords.latitude, loc.coords.longitude], pointsToRoute, (routes) ->
               stations.forEach (s) ->
                    s.route = routes.filter((r) -> r.id == s.code)[0].route

                doDraw = () ->
                    map.off "zoomend", doDraw
                    map.drawRoutes(stations)
                    map.makeButtons(stations)

                map.on "zoomend", doDraw
                map.fitPoints stations.map (s) -> [s.nearestEntrance]
###

