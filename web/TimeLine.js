var TimeLine = {
    svgCanvas: {},
    print: function(data, indexData, parentDiv, dataMin, dataMax) {        

        var xRange = d3.time.scale()
                .domain([dataMin, dataMax])
                .range([leftPadding, width - rightPadding]);

        var xAxis = d3.svg.axis().scale(xRange).ticks(5);

        this.svgCanvas = parentDiv.select('.timeline')
                .append('svg')
                .attr('class', 'canvas')
                .attr("width", width)
                .attr("height", height)
                .append("g")
                .attr("transform", "translate(" + 0 + "," + (height - bottomPadding) + ")");

        this.svgCanvas.append("g")
                .attr("transform", "translate(0, " + (0) + ")")
                .attr("class", "timeline")
                .selectAll(".timeBox")
                .data(data)
                .enter()
                .append("rect")
                .attr("class", "timeBox")
                .attr("y", -20)
                .attr("x",
                function(d) {
                    return xRange(d.startTime)
                })
                .attr("height", 20)
                .attr("width",
                function(d) {
                    return xRange(d.endTime) - xRange(d.startTime)
                })
                .attr("fill", function(d) {
            return  locations[indexData[d.ID].localization]
        });

        var drawnXAxis = this.svgCanvas.append("g")
                .attr("id", "xaxis")
                .call(xAxis);

    }
}