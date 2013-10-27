var Init = {
    initConstants: function()
    {
        dataMin = null;
        dataMax = null;

        width = 600;
        height = 600;

        numTicks = 6;

        svgPadding = 35;

        leftPadding = 70 + svgPadding;
        rightPadding = 0 + svgPadding;
        topPadding = 0 + svgPadding;
        bottomPadding = 5 + svgPadding;

        drawableAreaWidthHeight = [width - 2 * svgPadding, height - 2 * svgPadding];

        /*
         var drawableAreaCenters = drawableAreaWidthHeight.map(function(d){return d3.round(d/2)});
         
         drawableAreaCenters[0] += leftPadding;
         drawableAreaCenters[1] += topPadding;
         */
        drawableAreaCenters = [d3.round((width) / 2), d3.round((height) / 2)];

        tickSiz = 6;

        blockHeight = 20;
    },
    prepareIndex: function(indexData)
    {
        eventTypes = d3.nest()
                .key(function(d) {
                    return d.eventType;
                })
                .rollup(function(d) {
                    return d[0].eventType;
                })
                .map(indexData);

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
        
        return indexData;
    },
    prepareData: function(dat)
    {
        dat.forEach(function(d)
        {
//            console.log(d);
            //console.log(typeof d.startTime);
            d.startTime = new Date(d.startTime);
            d.endTime = new Date(d.startTime);
            d.duration = parseInt(d.duration);
            d.endTime.setSeconds(d.endTime.getSeconds() + d.duration );
            
            
            d.ID = parseInt(d.ID);
            
            
            //d.endTime.setMinutes(d.endTime.getMinutes() + d.duration);
            
            
//            console.log(d);
//            console.log(d.endTime.getSeconds());
//            console.log(d.duration);
            
        });

        dat.sort(function(a, b) {
            if (a.startTime < b.startTime)
            {
                return -1;
            }else if (a.startTime > b.startTime)
            {
                return 1;
            }else if (a.endTime < b.endTime)
            {
                return -1;
            } else if (a.endTime > b.endTime)
            {
                return 1;
            }
            else if (a.ID < b.ID)
            {
                return -1;
            }
            else if (a.ID > b.ID)
            {
                return 1;
            }
            
            return 0;
            
            
        });

        return dat;
    }


};

