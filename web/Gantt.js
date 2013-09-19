var Gantt = {
    print: function(data, indexData) {
//http://www.jeromecukier.net/blog/2012/10/15/d3-tutorial-at-visweek-2012/
        var xRange = d3.time.scale()
                .domain([dataMin, dataMax])
                .range([leftPadding, width - rightPadding]);

        var xAxis = d3.svg.axis()
                .scale(xRange)
                .ticks(5)
                .tickSize(- (height - topPadding - bottomPadding));

//http://bl.ocks.org/mbostock/5628329
//http://bl.ocks.org/mbostock/1166403
        var yRange = d3.scale.ordinal()
                .domain(d3.keys(locations))
                .rangePoints([topPadding, height - bottomPadding], 1);
 //               .rangeRoundBands([topPadding, height - bottomPadding], 0.9);

        var yAxis = d3.svg.axis().scale(yRange).orient("left");

        var svg = d3.select('#timeline')
                .append('svg')
                .attr('class', 'canvas')
                .attr("width", width)
                .attr("height", height)
                .append("g");

        var drawnXAxis = svg.append("g")
                .attr("transform", "translate(" + 0 + ", " + (height - bottomPadding) + ")")
                .attr("id", "xaxis")
                .call(xAxis);

        var drawnYAxis = svg.append("g")
                .attr("transform", "translate(" + leftPadding + "," + 0 + ")")
                .attr("id", "yaxis")
                .call(yAxis);
        
        drawnXAxis.selectAll(".tick line")
                .style( "stroke", "grey")


        svg.append("g")
                .attr("transform", "translate(" + 0 + "," + 0 + ")")
                .attr("class", "timeline")
                .selectAll(".timeBox")
                .data(data)
                .enter()
                .append("rect")
                .attr("class", "timeBox")
                .attr("y", function(d) {
            return yRange(indexData[d.ID].localization) - blockHeight/2;
        })
                .attr("x",
                function(d) {
                    return xRange(d.startTime)
                })
//                .attr("height", yRange.rangeBand())
                .attr("height", blockHeight )
                .attr("width",
                function(d) {
                    return xRange(d.endTime) - xRange(d.startTime)
                })
                .attr("fill", function(d) {
            return  locations[indexData[d.ID].localization]
        });


    }
}
