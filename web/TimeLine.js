var TimeLine = {
    print: function(data, indexData) {

        var xRange = d3.time.scale()
                .domain([dataMin, dataMax])
                .range([leftPadding, width - rightPadding]);

        var xAxis = d3.svg.axis().scale(xRange).ticks(5);

        var svg = d3.select('#timeline')
                .append('svg')
                .attr('class', 'canvas')
                .attr("width", width)
                .attr("height", height)
                .append("g")
                .attr("transform", "translate(" + 0 + "," + (height - bottomPadding) + ")");

        svg.append("g")
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

        var drawnXAxis = svg.append("g")
                .attr("id", "xaxis")
                .call(xAxis);

    }
}