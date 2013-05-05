require.config
    paths:
        jquery: '../components/jquery/jquery',
        bootstrap: 'vendor/bootstrap'
        leaflet: "../components/leaflet/dist/leaflet"
        text: "../components/requirejs-text/text"
        async: "../components/async/lib/async"
        as : 'vendor/requirejs-async'
        underscore: "../components/underscore/underscore"
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
        "underscore":
            exports: "_"
        "vendor/spin":
            exports: "Spinner"


require ['app', 'jquery', 'bootstrap'], (app, $) ->
    'use strict'

    $("h1").on "touchstart", (e) -> 
        e.stopPropagation()
        window.location.reload()

    $("body").css "font-size", $(window).width() / 50

    $("#cardholder").css "display", "block"