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

            .spiral .axis text {
                left: 19px;
                position: relative;
            }

            #draws > div > div {
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
        <script src="./js/FileHandler.js" ></script>
        <script src="TimeLine.js"></script>
        <script src="Gantt.js"></script>
        <script src="Spiral.js"></script>
        <script src="Mat.js"></script>


        <script type="text/javascript">

            function prepareButtons()
            {

                if (window.File && window.FileReader && window.FileList && window.Blob) {

                    $('#indexFile').change(FileHandler.handleIndexSelect);
                    $('#dataFiles').change(FileHandler.handleDataSelect);

                } else {
                    alert('The File APIs are not fully supported in this browser.');
                }
            }

            $(function() {
                Init.initConstants();

                prepareButtons();

            });


        </script>

    </head>
    <body>
        <div style="margin-bottom: 10px;margin-top: 10px;" >

            <div style="display:inline-block">
                <label for="indexFile"> Index File: </label>  
                <br />
                <label for="dataFiles"> Data File: </label> 

            </div>
            <div style="display:inline-block">

                <input type="file" id="indexFile" name="indexFiles[]" /> <br />
                <input type="file" id="dataFiles" name="dataFiles[]" multiple="multiple" />


                <br />

            </div>
        </div>

        <div id ="leyenda">
        </div>
        <div id="draws">
        </div>

    </body>
</html>
