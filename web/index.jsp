<%-- 
    Document   : index
    Created on : 09-may-2013, 22:33:26
    Author     : JMOF
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title></title>
        <style type="text/css" >

            .canvas {
                border-color: -moz-use-text-color;
                border-image: none;
                border-style: solid;
                border-width: 1px;
            }

            rect {
                fill-opacity: 0.8;
                stroke: black;
                stroke-opacity: 0.5;
            }   

            .domain {
                fill: none;
                stroke: black;
                stroke-width: 1px;
            }

            line {
                opacity: 1;
                stroke: black;
                stroke-width: 0.75;
            }
            .leyendas div {
                display: inline-block;
            }

            .cuadrosLeyendas
            {
                width: 10px;
                height: 10px;
                margin: 0px 10px;

            }
            #axes > .axis:not(:first-child) .tick text
            {
                visibility: hidden;
            }


            .dataSpiral {
                fill: none;
                stroke: #ee8d18;
                stroke-width: 30px;
                stroke-opacity: 0.8;
            }

            #axes circle
            {
                fill: none;
                stroke: #808080;
                stroke-dasharray: 3, 3;
                stroke-opacity: 0.8;
            }

            .linkLines
            {
                fill:none;
            }

        </style>

        <script src="d3.v3.js" ></script>


        <script src="index.js"></script>
        <script src="TimeLine.js"></script>
        <script src="Gantt.js"></script>
        <script src="Spiral.js"></script>
        <script src="Mat.js"></script>

    </head>
    <body>

        <script type="text/javascript">
//index init
            eventTypes = d3.nest()
                    .key(function(d) {
                return d.eventType;
            })
                    .rollup(function(d) {
                return d[0].eventType;
            })
                    .map(indexData);

// d3.keys(locations).forEach(function (d, i) { locations[d] = i; })

            locations = d3.nest()
                    .key(function(d) {
                return d.localization;
            })
                    .rollup(function(d) {
                return d[0].localization;
            })
                    .map(indexData);

            indexData = d3.nest()
                    .key(function(d) {
                return d.ID;
            })
                    .rollup(function(d) {
                return d[0];
            })
                    .map(indexData);

            colorInterp = d3.scale.category10().domain(d3.keys(locations));

            d3.keys(locations).forEach(function(d) {
                locations[d] = colorInterp(d);
            });

            function prepareData(dat)
            {
                dat.forEach(function(d)
                {
                    //console.log(typeof d.startTime);
                    d.ID = parseInt(d.ID);
                    d.startTime = new Date(d.startTime);
                    d.duration = parseInt(d.duration);
                    d.endTime = new Date(d.startTime);
                    d.endTime.setMinutes(d.endTime.getMinutes() + d.duration)
                });

                dat.sort(function(a, b) {
                    d3.ascending(a, b);
                });

                return dat;
            }

            var dataMin = null;
            var dataMax = null;

        </script>
        <script>


            var width = 600;
            var height = 600;

            var numTicks = 6;

            var svgPadding = 20;

            var leftPadding = 70 + svgPadding,
                    rightPadding = 0 + svgPadding,
                    topPadding = 0 + svgPadding,
                    bottomPadding = 5 + svgPadding;

            var drawableAreaWidthHeight = [width - 2 * svgPadding, height - 2 * svgPadding];

            /*
             var drawableAreaCenters = drawableAreaWidthHeight.map(function(d){return d3.round(d/2)});
             
             drawableAreaCenters[0] += leftPadding;
             drawableAreaCenters[1] += topPadding;
             */
            var drawableAreaCenters = [d3.round((width) / 2), d3.round((height) / 2)];


            var tickSiz = 6;

            var blockHeight = 20;

        </script>

        <script type="text/javascript" >
            var leyenda, leyendaTipos;
            //http://mbostock.github.io/d3/tutorial/bar-1.html
            window.onload = function() {

                leyenda = d3.select("#leyenda");

                leyenda.selectAll(".leyendas")
                        .data(d3.keys(locations))
                        .enter()
                        .append("div")
                        .attr("class", "leyendas")
                        .append("div")
                        .attr("class", "cuadrosLeyendas")
                        .attr("style", function(d) {
                    return "background:" + locations[d] + ";"
                });

                leyenda.selectAll(".leyendas")
                        .data(d3.keys(locations))
                        .append("div")
                        .attr("class", "textoLeyendas")


                        .text(function(d) {
                    return d;
                })
                        .attr("style", function(d) {
                    return "color:" + locations[d] + ";";
                });


                var data = [{startTime: new Date("2009-10-19T14:25:00"), duration: 19, ID: 5}
                    , {startTime: new Date("2009-10-19T14:25:00"), duration: 2, ID: 1}
                    , {startTime: new Date("2009-10-19T14:30:00"), duration: 7, ID: 2}
                    , {startTime: new Date("2009-10-19T14:35:00"), duration: 2, ID: 3}
                    , {startTime: new Date("2009-10-19T14:40:00"), duration: 2, ID: 4}
                    , {startTime: new Date("2009-10-19T14:45:00"), duration: 7, ID: 5}
                    , {startTime: new Date("2009-10-19T14:50:00"), duration: 2, ID: 6}
                    , {startTime: new Date("2009-10-19T14:55:00"), duration: 3, ID: 7}
                    , {startTime: new Date("2009-10-19T15:00:00"), duration: 2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:05:00"), duration: 5, ID: 1}
                    , {startTime: new Date("2009-10-19T15:10:00"), duration: 2, ID: 2}
                    , {startTime: new Date("2009-10-19T15:15:00"), duration: 2, ID: 3}
                    , {startTime: new Date("2009-10-19T15:20:00"), duration: 4, ID: 4}
                    , {startTime: new Date("2009-10-19T15:25:00"), duration: 2, ID: 5}
                    , {startTime: new Date("2009-10-19T15:30:00"), duration: 4, ID: 6}
                    , {startTime: new Date("2009-10-19T15:35:00"), duration: 2, ID: 7}
                    , {startTime: new Date("2009-10-19T15:40:00"), duration: 2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:45:00"), duration: 2, ID: 5}
                ];

                //data init

                data = prepareData(data);

                dataMin = d3.min(data, function(d)
                {
                    return d.startTime;
                });
                dataMax = d3.max(data, function(d)
                {
                    return d.endTime;
                });

                TimeLine.print(data, indexData);


                var data = [{startTime: new Date("2009-10-19T14:25:00"), duration: 19, ID: 5}
                    , {startTime: new Date("2009-10-19T14:25:00"), duration: 2, ID: 1}
                    , {startTime: new Date("2009-10-19T14:30:00"), duration: 7, ID: 2}
                    , {startTime: new Date("2009-10-19T14:35:00"), duration: 2, ID: 3}
                    , {startTime: new Date("2009-10-19T14:40:00"), duration: 2, ID: 4}
                    , {startTime: new Date("2009-10-19T14:45:00"), duration: 7, ID: 5}
                    , {startTime: new Date("2009-10-19T14:50:00"), duration: 2, ID: 6}
                    , {startTime: new Date("2009-10-19T14:55:00"), duration: 3, ID: 7}
                    , {startTime: new Date("2009-10-19T15:00:00"), duration: 2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:05:00"), duration: 5, ID: 1}
                    , {startTime: new Date("2009-10-19T15:10:00"), duration: 2, ID: 2}
                    , {startTime: new Date("2009-10-19T15:15:00"), duration: 2, ID: 3}
                    , {startTime: new Date("2009-10-19T15:20:00"), duration: 4, ID: 4}
                    , {startTime: new Date("2009-10-19T15:25:00"), duration: 2, ID: 5}
                    , {startTime: new Date("2009-10-19T15:30:00"), duration: 4, ID: 6}
                    , {startTime: new Date("2009-10-19T15:35:00"), duration: 2, ID: 7}
                    , {startTime: new Date("2009-10-19T15:40:00"), duration: 2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:45:00"), duration: 2, ID: 5}
                ];

                //data init

                data = prepareData(data);

                dataMin = d3.min(data, function(d)
                {
                    return d.startTime;
                });
                dataMax = d3.max(data, function(d)
                {
                    return d.endTime;
                });

                Gantt.print(data, indexData);


                var data = [{startTime: new Date("2009-10-19T14:25:00"), duration: 19, ID: 5}
                    , {startTime: new Date("2009-10-19T14:25:00"), duration: 2, ID: 1}
                    , {startTime: new Date("2009-10-19T14:30:00"), duration: 7, ID: 2}
                    , {startTime: new Date("2009-10-19T14:35:00"), duration: 2, ID: 3}
                    , {startTime: new Date("2009-10-19T14:40:00"), duration: 2, ID: 4}
                    , {startTime: new Date("2009-10-19T14:45:00"), duration: 7, ID: 5}
                    , {startTime: new Date("2009-10-19T14:50:00"), duration: 2, ID: 6}
                    , {startTime: new Date("2009-10-19T14:55:00"), duration: 3, ID: 7}
                    , {startTime: new Date("2009-10-19T15:00:00"), duration: 2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:05:00"), duration: 5, ID: 1}
                    , {startTime: new Date("2009-10-19T15:10:00"), duration: 2, ID: 2}
                    , {startTime: new Date("2009-10-19T15:15:00"), duration: 2, ID: 3}
                    , {startTime: new Date("2009-10-19T15:20:00"), duration: 4, ID: 4}
                    , {startTime: new Date("2009-10-19T15:25:00"), duration: 2, ID: 5}
                    , {startTime: new Date("2009-10-19T15:30:00"), duration: 4, ID: 6}
                    , {startTime: new Date("2009-10-19T15:35:00"), duration: 2, ID: 7}
                    , {startTime: new Date("2009-10-19T15:40:00"), duration: 2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:45:00"), duration: 2, ID: 5}
                ];

                //data init

                data = prepareData(data);

                dataMin = d3.min(data, function(d)
                {
                    return d.startTime;
                });
                dataMax = d3.max(data, function(d)
                {
                    return d.endTime;
                });

                Spiral.print(data, indexData);

                var data = [{startTime: new Date("2009-10-19T14:25:00"), duration: 19, ID: 5}
                    , {startTime: new Date("2009-10-19T14:25:00"), duration: 2, ID: 1}
                    , {startTime: new Date("2009-10-19T14:30:00"), duration: 7, ID: 2}
                    , {startTime: new Date("2009-10-19T14:35:00"), duration: 2, ID: 3}
                    , {startTime: new Date("2009-10-19T14:40:00"), duration: 2, ID: 4}
                    , {startTime: new Date("2009-10-19T14:45:00"), duration: 7, ID: 5}
                    , {startTime: new Date("2009-10-19T14:50:00"), duration: 2, ID: 6}
                    , {startTime: new Date("2009-10-19T14:55:00"), duration: 3, ID: 7}
                    , {startTime: new Date("2009-10-19T15:00:00"), duration: 2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:05:00"), duration: 5, ID: 1}
                    , {startTime: new Date("2009-10-19T15:10:00"), duration: 2, ID: 2}
                    , {startTime: new Date("2009-10-19T15:15:00"), duration: 2, ID: 3}
                    , {startTime: new Date("2009-10-19T15:20:00"), duration: 4, ID: 4}
                    , {startTime: new Date("2009-10-19T15:25:00"), duration: 2, ID: 5}
                    , {startTime: new Date("2009-10-19T15:30:00"), duration: 4, ID: 6}
                    , {startTime: new Date("2009-10-19T15:35:00"), duration: 2, ID: 7}
                    , {startTime: new Date("2009-10-19T15:40:00"), duration: 2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:45:00"), duration: 2, ID: 5}
                ];

                //data init

                data = prepareData(data);

                dataMin = d3.min(data, function(d)
                {
                    return d.startTime;
                });
                dataMax = d3.max(data, function(d)
                {
                    return d.endTime;
                });

                Mat.print(data, indexData);
            };

        </script>

        <div id ="leyenda">

        </div>
        <div id="timeline">
        </div>

        <div id="spiral">
        </div>

        <div id="mat">
        </div>


    </body>
</html>
