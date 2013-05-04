require.config
    paths:
        jquery: '../components/jquery/jquery',
        bootstrap: 'vendor/bootstrap'
        leaflet: "../components/leaflet/dist/leaflet"
        text: "../components/requirejs-text/text"
        async: "../components/async/lib/async"
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

require ['app', 'jquery', 'bootstrap'], (app, $) ->
    'use strict'

    console.log(app);
    console.log('Running jQuery %s', $().jquery);