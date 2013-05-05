require.config
    paths:
        jquery: '../components/jquery/jquery',
        bootstrap: 'vendor/bootstrap'
        leaflet: "../components/leaflet/dist/leaflet"
        text: "../components/requirejs-text/text"
        async: "../components/async/lib/async"
        gmaps: "https://maps.googleapis.com/maps/api/js?key=AIzaSyCmJN58nGwCZcXNxFkpFPsE1PWUPf2V1u8&sensor=true"
        as : 'vendor/requirejs-async'
    shim:
        bootstrap:
            deps: ['jquery'],
            exports: 'jquery'
        "vendor/modestmaps":
            exports: "MM"
        "leaflet":
            exports:"L"
        "vendor/geo":
            exports: "Geo"
        "vendor/latlon":
            exports: "LatLon"
            deps: ["vendor/geo"]
        "gmaps":
            exports: "google"


require ['app', 'jquery', 'bootstrap'], (app, $) ->
    'use strict'

    console.log(app);
    console.log('Running jQuery %s', $().jquery);