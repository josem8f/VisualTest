var Mat = {
    innerRadius: 15,
    svgCanvas: {},
    axes: {},
    timeAxis: {},
    timeRange: {},
    createLinks: function(data)
    {
        var links = [];

        for (i = 1; i < data.length; i++)
        {
            var antecessor = i - 1;

            var local1 = indexData[  data[antecessor].ID ].localization;
            var local2 = indexData[ data[ i ].ID ].localization;

            while (local1 == local2 && i < data.length)
            {
                antecessor = data[antecessor].endTime > data[i].endTime ? antecessor : i;

                i++;

                local2 = indexData[ data[ i].ID ].localization;
            }

            if (i == data.length && local1 == local2)
            {
                break;
            }
            
            var link = {
                startRadius: data[antecessor].endTime,
                endRadius: data[i].startTime,
                startAngle: local1,
                endAngle: local2,
                linkColor: local1
            };

            links.push(link);
        }

        return links;
    },
    pathLinks: function(d)
    {        
        var timeRange = d3.time.scale()
                .domain([dataMin, dataMax])
                .range([Mat.innerRadius, Math.floor(d3.min(drawableAreaWidthHeight) / 2)]);


        var angle = d3.scale.ordinal()
                .domain(d3.merge([d3.keys(locations), [""]]))
                .rangePoints([0, 2 * Math.PI]);

        var stretch = 25;

        var startAngle = angle(d.startAngle);
        var endAngle = angle(d.endAngle);

        var startRadius = timeRange(d.startRadius);
        var endRadius = timeRange(d.endRadius);

        if (endAngle < startAngle)
        {
            x = endAngle;
            endAngle = startAngle;
            startAngle = x;

            startRadius = timeRange(d.endRadius);
 
            endRadius = timeRange(d.startRadius);
        }

        if (endAngle - startAngle > Math.PI)
            startAngle += 2 * Math.PI;

        controlAngle1 = startAngle + (endAngle - startAngle) / 3;
        controlAngle2 = endAngle - (endAngle - startAngle) / 3

        controlRadius1 = startRadius + stretch;
        controlRadius2 = endRadius + stretch;

        var path = "M ";
        path += Math.cos(startAngle) * startRadius + ", " + Math.sin(startAngle) * startRadius + " ";
        path += " C ";
        path += Math.cos(controlAngle1) * controlRadius1 + ", " + Math.sin(controlAngle1) * controlRadius1 + " ";
        path += Math.cos(controlAngle2) * controlRadius2 + ", " + Math.sin(controlAngle2) * controlRadius2 + " ";
        path += Math.cos(endAngle) * endRadius + ", " + Math.sin(endAngle) * endRadius + " ";

        return path;
    },
    print: function(data, indexData, parentDiv, dataMin, dataMax)
    {

        this.timeRange = d3.time.scale()
                .domain([dataMin, dataMax])
                .range([this.innerRadius, Math.floor(d3.min(drawableAreaWidthHeight) / 2)]);

        this.timeAxis = d3.svg.axis()
                .outerTickSize(0)
                .scale(this.timeRange)
                .ticks(numTicks);

        var angle = d3.scale.ordinal()
                .domain(d3.merge([d3.keys(locations), [""]]))
                .rangePoints([0, 360]);

        this.svgCanvas = parentDiv.select('#mat')
                .append('svg')
                .attr('class', 'canvas')
                .attr('width', width)
                .attr('height', height);

        this.svgCanvas = this.svgCanvas.append('g')
                .attr('transform', 'translate(' + drawableAreaCenters[0] + ',' + drawableAreaCenters[1] + ')');

        this.axes = this.svgCanvas.append('g')
                .attr('id', 'axes');

        this.axes.selectAll('.axis')
                .data(d3.keys(locations))
                .enter()
                .append('g')
                .attr('class', 'axis')
                .attr("transform", function(d) {
            return "rotate(" + angle(d) + " )";
        }).call(this.timeAxis);


        this.axes.append('circle')
                .attr('r', this.innerRadius)
                .attr('style', 'stroke: black;stroke-dasharray: none; stroke-opacity:1;');


        var linkLines = this.svgCanvas.append('g')
                .attr('id', 'linkLines');

        links = this.createLinks(data);

        linkLines.selectAll('.linkLines')
                .data(links)
                .enter()
                .append('path')
                .attr('class', 'linkLines')
                .attr('stroke', function(d) {
            return locations[d.linkColor];
        })
                .attr('d', this.pathLinks);

        var intervals = this.svgCanvas.append('g')
                .attr('id', 'intervals');


        intervals.selectAll(".interval")
                .data(data)
                .enter()
                .append("rect")
                .attr("class", "interval")
                .attr("x", function(timeRange) {
            return function(d)
            {
                return timeRange(d.startTime);
            }
        }(this.timeRange))
                .attr("y", -blockHeight / 2)
                .attr("width", function(timeRange) {
            return function(d)
            {
                return timeRange(d.endTime) - timeRange(d.startTime);
            }
        }(this.timeRange))
                .attr("height", blockHeight)
                .attr("fill", function(d) {
            return locations[indexData[d.ID].localization];
        })
                .attr("transform", function(d) {
            return "rotate(" + angle(indexData[d.ID].localization) + " )";
        });




    },
};