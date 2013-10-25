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
            
            

            .gantt .xaxis text {
                position: relative;
                top: 5px;
            }
            
            
            .mat .axis text {
                left: 8px;
                position: relative;
                top: 6px;
            }

            #draws div {
                display: inline-block;
            }

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

            text{
                font-size: 12px;
            }

        </style>

        <script src="./js/libs/jquery/jquery.js" ></script>
        <script src="./js/libs/d3/d3.js" ></script>


        <script src="./js/init.js" ></script>
        <script src="index.js"></script>
        <script src="TimeLine.js"></script>
        <script src="Gantt.js"></script>
        <script src="Spiral.js"></script>
        <script src="Mat.js"></script>

    </head>
    <body>
        <div id ="leyenda">

        </div>
        <div id="draws">
            <div class="timeline">
            </div>

            <div class="gantt">
            </div>

            <div class="spiral">
            </div>

            <div class="mat">
            </div>
        </div>



        <script type="text/javascript">

            $(function() {


                Init.initConstants();

                //indexData is in index.js
                indexData = Init.prepareIndex(indexData);

                draw();

            });


        </script>








        <script type="text/javascript" >

            function draw() {
                var leyenda, leyendaTipos;
                //http://mbostock.github.io/d3/tutorial/bar-1.html

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


                var data = [{startTime: new Date("2009-10-19T14:25:00"), duration: 60 *19, ID: 5}
                    , {startTime: new Date("2009-10-19T14:25:00"), duration: 60 *2, ID: 1}
                    , {startTime: new Date("2009-10-19T14:30:00"), duration: 60 *7, ID: 2}
                    , {startTime: new Date("2009-10-19T14:35:00"), duration: 60 *2, ID: 3}
                    , {startTime: new Date("2009-10-19T14:40:00"), duration: 60 *2, ID: 4}
                    , {startTime: new Date("2009-10-19T14:45:00"), duration: 60 *7, ID: 5}
                    , {startTime: new Date("2009-10-19T14:50:00"), duration: 60 *2, ID: 6}
                    , {startTime: new Date("2009-10-19T14:55:00"), duration: 60 *3, ID: 7}
                    , {startTime: new Date("2009-10-19T15:00:00"), duration: 60 *2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:05:00"), duration: 60 *5, ID: 1}
                    , {startTime: new Date("2009-10-19T15:10:00"), duration: 60 *2, ID: 2}
                    , {startTime: new Date("2009-10-19T15:15:00"), duration: 60 *2, ID: 3}
                    , {startTime: new Date("2009-10-19T15:20:00"), duration: 60 *4, ID: 4}
                    , {startTime: new Date("2009-10-19T15:25:00"), duration: 60 *2, ID: 5}
                    , {startTime: new Date("2009-10-19T15:30:00"), duration: 60 *4, ID: 6}
                    , {startTime: new Date("2009-10-19T15:35:00"), duration: 60 *2, ID: 7}
                    , {startTime: new Date("2009-10-19T15:40:00"), duration: 60 *2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:45:00"), duration: 60 *2, ID: 5}
                ];

                //data init

                data = Init.prepareData(data);

                dataMin = d3.min(data, function(d)
                {
                    return d.startTime;
                });
                dataMax = d3.max(data, function(d)
                {
                    return d.endTime;
                });

                var parentDiv = d3.select('#draws');

                TimeLine.print(data, indexData, parentDiv, dataMin, dataMax);


                var data = [{startTime: new Date("2009-10-19T14:25:00"), duration: 60 *19, ID: 5}
                    , {startTime: new Date("2009-10-19T14:25:00"), duration: 60 *2, ID: 1}
                    , {startTime: new Date("2009-10-19T14:30:00"), duration: 60 *7, ID: 2}
                    , {startTime: new Date("2009-10-19T14:35:00"), duration: 60 *2, ID: 3}
                    , {startTime: new Date("2009-10-19T14:40:00"), duration: 60 *2, ID: 4}
                    , {startTime: new Date("2009-10-19T14:45:00"), duration: 60 *7, ID: 5}
                    , {startTime: new Date("2009-10-19T14:50:00"), duration: 60 *2, ID: 6}
                    , {startTime: new Date("2009-10-19T14:55:00"), duration: 60 *3, ID: 7}
                    , {startTime: new Date("2009-10-19T15:00:00"), duration: 60 *2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:05:00"), duration: 60 *5, ID: 1}
                    , {startTime: new Date("2009-10-19T15:10:00"), duration: 60 *2, ID: 2}
                    , {startTime: new Date("2009-10-19T15:15:00"), duration: 60 *2, ID: 3}
                    , {startTime: new Date("2009-10-19T15:20:00"), duration: 60 *4, ID: 4}
                    , {startTime: new Date("2009-10-19T15:25:00"), duration: 60 *2, ID: 5}
                    , {startTime: new Date("2009-10-19T15:30:00"), duration: 60 *4, ID: 6}
                    , {startTime: new Date("2009-10-19T15:35:00"), duration: 60 *2, ID: 7}
                    , {startTime: new Date("2009-10-19T15:40:00"), duration: 60 *2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:45:00"), duration: 60 *2, ID: 5}
                ];

                //data init

                data = Init.prepareData(data);

                dataMin = d3.min(data, function(d)
                {
                    return d.startTime;
                });
                dataMax = d3.max(data, function(d)
                {
                    return d.endTime;
                });

                Gantt.print(data, indexData, parentDiv, dataMin, dataMax);


                var data = [{startTime: new Date("2009-10-19T14:25:00"), duration: 60 *19, ID: 5}
                    , {startTime: new Date("2009-10-19T14:25:00"), duration: 60 *2, ID: 1}
                    , {startTime: new Date("2009-10-19T14:30:00"), duration: 60 *7, ID: 2}
                    , {startTime: new Date("2009-10-19T14:35:00"), duration: 60 *2, ID: 3}
                    , {startTime: new Date("2009-10-19T14:40:00"), duration: 60 *2, ID: 4}
                    , {startTime: new Date("2009-10-19T14:45:00"), duration: 60 *7, ID: 5}
                    , {startTime: new Date("2009-10-19T14:50:00"), duration: 60 *2, ID: 6}
                    , {startTime: new Date("2009-10-19T14:55:00"), duration: 60 *3, ID: 7}
                    , {startTime: new Date("2009-10-19T15:00:00"), duration: 60 *2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:05:00"), duration: 60 *5, ID: 1}
                    , {startTime: new Date("2009-10-19T15:10:00"), duration: 60 *2, ID: 2}
                    , {startTime: new Date("2009-10-19T15:15:00"), duration: 60 *2, ID: 3}
                    , {startTime: new Date("2009-10-19T15:20:00"), duration: 60 *4, ID: 4}
                    , {startTime: new Date("2009-10-19T15:25:00"), duration: 60 *2, ID: 5}
                    , {startTime: new Date("2009-10-19T15:30:00"), duration: 60 *4, ID: 6}
                    , {startTime: new Date("2009-10-19T15:35:00"), duration: 60 *2, ID: 7}
                    , {startTime: new Date("2009-10-19T15:40:00"), duration: 60 *2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:45:00"), duration: 60 *2, ID: 5}
                ];

                //data init

                data = Init.prepareData(data);

                dataMin = d3.min(data, function(d)
                {
                    return d.startTime;
                });
                dataMax = d3.max(data, function(d)
                {
                    return d.endTime;
                });

                Spiral.print(data, indexData, parentDiv, dataMin, dataMax);

                var data = [{startTime: new Date("2009-10-19T14:25:00"), duration: 60 *19, ID: 5}
                    , {startTime: new Date("2009-10-19T14:25:00"), duration: 60 *2, ID: 1}
                    , {startTime: new Date("2009-10-19T14:30:00"), duration: 60 *7, ID: 2}
                    , {startTime: new Date("2009-10-19T14:35:00"), duration: 60 *2, ID: 3}
                    , {startTime: new Date("2009-10-19T14:40:00"), duration: 60 *2, ID: 4}
                    , {startTime: new Date("2009-10-19T14:45:00"), duration: 60 *7, ID: 5}
                    , {startTime: new Date("2009-10-19T14:50:00"), duration: 60 *2, ID: 6}
                    , {startTime: new Date("2009-10-19T14:55:00"), duration: 60 *3, ID: 7}
                    , {startTime: new Date("2009-10-19T15:00:00"), duration: 60 *2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:05:00"), duration: 60 *5, ID: 1}
                    , {startTime: new Date("2009-10-19T15:10:00"), duration: 60 *2, ID: 2}
                    , {startTime: new Date("2009-10-19T15:15:00"), duration: 60 *2, ID: 3}
                    , {startTime: new Date("2009-10-19T15:20:00"), duration: 60 *4, ID: 4}
                    , {startTime: new Date("2009-10-19T15:25:00"), duration: 60 *2, ID: 5}
                    , {startTime: new Date("2009-10-19T15:30:00"), duration: 60 *4, ID: 6}
                    , {startTime: new Date("2009-10-19T15:35:00"), duration: 60 *2, ID: 7}
                    , {startTime: new Date("2009-10-19T15:40:00"), duration: 60 *2, ID: 8}
                    , {startTime: new Date("2009-10-19T15:45:00"), duration: 60 *2, ID: 5}
                ];

                //data init

                data = Init.prepareData(data);

                dataMin = d3.min(data, function(d)
                {
                    return d.startTime;
                });
                dataMax = d3.max(data, function(d)
                {
                    return d.endTime;
                });

                Mat.print(data, indexData, parentDiv, dataMin, dataMax);

            }
        </script>



    </body>
</html>
