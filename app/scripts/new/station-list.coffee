define ["underscore","text!timetemplate","vendor/spin"], (_,timeTemplate,Spinner) ->
    class StationList
        constructor: () ->

            baseRadius = $(window).width() / 30

            $("body").on "touchend", () ->
                $("li.active").removeClass("active")



            new Spinner({
                  lines: 13, # The number of lines to draw
                  length: baseRadius / 1.5, # The length of each line
                  width: baseRadius / 3.2, # The line thickness
                  radius: baseRadius, # The radius of the inner circle
                  corners: 1, # Corner roundness (0..1)
                  rotate: 0, # The rotation offset
                  direction: 1, # 1: clockwise, -1: counterclockwise
                  color: '#fff', # #rgb or #rrggbb
                  speed: 1, # Rounds per second
                  trail: 60, # Afterglow percentage
                  shadow: false, # Whether to render a shadow
                  hwaccel: true, # Whether to use hardware acceleration
                  className: 'spinner', # The CSS class to assign to the spinner
                  zIndex: 2e9, # The z-index (defaults to 2000000000)
                  top: 'auto', # Top position relative to parent in px
                  left: 'auto' # Left position relative to parent in px
                }).spin($("#spin")[0])

            @template = _.template(timeTemplate)
            $("#astationList").on "touchstart", (e) ->
                e.stopPropagation()

            $("#astationList").on "touchmove", (e) ->
                e.stopPropagation()

        takeStationData: (stations, @mapInstance) =>
            $("#spinner").hide()
            
            nowMins = new Date().getHours() * 60
            nowMins += new Date().getMinutes()

            @times = []
            stations.forEach (s) =>
                s.times.forEach (t) =>
                    t.timeTillArrive = Math.ceil((t.time - s.route.legs[0].duration.value / 60) - nowMins)
                    t.station = s
                    @times.push t

            @times = @times.filter((f)-> f.timeTillArrive > 0)
            @times.sort (a,b) ->
                return a.timeTillArrive - b.timeTillArrive

            
            @processEntries @times

        processEntries: (times) ->
            root = $("<ul/>")
            root.css "height", $("#cardholder").height() - $("h1").outerHeight()
            for time in times
                root.append(@template(time))

            $("#stationList").append(root)

            self = @
            root.on "touchstart", "li", () ->
                $("li.active").removeClass("active")
                self.highlightRow($(this))

            root.on "scroll", () ->
                $(".glasspane").trigger "isScrolling"
                $("li.active").removeClass("active")


        highlightRow: (el,row) =>
            $(el).addClass "active"
            index = $(el).parent().children().index($(el))
            @mapInstance.mapRoute(@times[index])

            steps = @times[index].station.route.legs[0].steps
            els = steps.map (s,i) ->
                return $("<li>").html("<span class='num'>" + (i+1) + ".</span> " + s.instructions)

            $("#directions").html(els)



