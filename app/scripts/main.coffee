require.config
    paths:
        jquery: '../components/jquery/jquery',
        bootstrap: 'vendor/bootstrap'
        leaflet: "../components/leaflet/dist/leaflet"
        text: "../components/requirejs-text/text"
        async: "../components/async/lib/async"
        as : 'vendor/requirejs-async'
        underscore: "../components/underscore/underscore"
        timetemplate : "new/time-template.uhtml"
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

    setTimeout () ->
        window.scrollTo(0, 1)
    , 1000

    if $(window).height() == 356
        $("#cardholder").css "height", $(window).height() + 60

    baseSize = $(window).width()
    if baseSize > 600 
        baseSize = 600
        $("#cardholder").css
            "width": "600px"
            "left": "50%"
            "height": $(window).height() * 0.9
            "margin-top": -(($(window).height() * 0.9) / 2)
            "margin-left": "-300px"
            "top": "50%"

    $("body").css "font-size", baseSize / 50

    $("#cardholder").css "display", "block"