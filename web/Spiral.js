var Spiral = {
    numAxes : 8,
    svgCanvas : {},
    axes: '',
    print: function(data, indexData, parentDiv, dataMin, dataMax)
    {
        //http://csdt.rpi.edu/na/shoban/polar/polar.html

        var timeRange = d3.time.scale()
                .domain([dataMin, dataMax])
                .range([0, Math.floor(d3.min(drawableAreaWidthHeight) / 2)]);

        var axisAngle = d3.scale.linear()
                .domain( [0, this.numAxes])
                .range([0, 360]);

        var timeAxis = d3.svg.axis()
                .scale(timeRange)
                .ticks(numTicks);

        var theta = d3.scale.linear()
                .domain([0, Math.floor(d3.min(drawableAreaWidthHeight) / 2)])
                .range([0, 6 * Math.PI]);

        var spiralGenerator = d3.svg.line.radial()
                .interpolate('cardinal')
                .angle(theta)
                .radius(function(d) {
            return d;
        });

        this.svgCanvas = parentDiv.select('.spiral')
                .append('svg')
                .attr('class', 'canvas')
                .attr('width', width)
                .attr('height', height);

        this.svgCanvas = this.svgCanvas.append('g')
                .attr('transform', 'translate(' + drawableAreaCenters[0] + ',' + drawableAreaCenters[1] + ')');

        this.axes = this.svgCanvas.append('g')
                .attr('id', 'axes');

        this.axes.selectAll('.axis')
                .data(d3.range(0, this.numAxes))
                .enter()
                .append('g')
                .attr('class', 'axis')
                .attr("transform", function(d) {
            return "rotate(" + axisAngle(d) + " )";
        }).call(timeAxis);
        
        this.axes.selectAll('.circleTicks')
        .data(timeRange.ticks(numTicks))
        .enter()
        .append('circle')
        .attr('cx',0)
        .attr('cy', 0)
        .attr('r', timeRange);

        this.axes.selectAll('text')
                .attr('x', '18')
                .attr('y', '12');        

        this.svgCanvas.append('g')
                .attr('style', 'stroke-width:' + blockHeight + 'px;')
                .selectAll('.dataSpiral')
                .data(data)
                .enter()
                .append('path')
                .attr('style', function(d) {
            return 'stroke:' + locations[indexData[d.ID].localization] + ';';
        })
                .attr('class', function(d) {
            return 'dataSpiral ' + indexData[d.ID].localization;
        })
                .attr('d', function(d) {

            return spiralGenerator(d3.range(timeRange(d.startTime), timeRange(d.endTime)));
        });
    },
            
};

