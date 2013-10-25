
var FileHandler = {
    handleIndexSelect: function(evt)
    {
        var files = evt.target.files;

        var f = files[0];

        reader = new FileReader();
        reader.onload = FileHandler.loadIndex;

        reader.readAsText(f);

    },
    handleDataSelect: function(evt)
    {
        var files = evt.target.files;

        for (var i = 0, f; f = files[i]; i++) {

            reader = new FileReader();

            var canvasRoot = d3.select('#draws');
            reader.onload = FileHandler.loadData(f, canvasRoot);

            reader.readAsText(f);
        }

    },
    loadIndex: function(file)
    {
        indexData = d3.csv.parse(file.target.result);

        indexData = Init.prepareIndex(indexData);

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

    },
    loadData: function(file, canvasRoot)
    {
        return function(evt) {

            //creaing parent
            var parentDiv = canvasRoot
                    .append('div')
                    .attr('class', file.name);

            parentDiv.append('p')
                    .text(file.name);

            parentDiv.append('div')
                    .attr('class', 'timeline');
            parentDiv.append('div')
                    .attr('class', 'gantt');
            parentDiv.append('div')
                    .attr('class', 'spiral');
            parentDiv.append('div')
                    .attr('class', 'mat');

            var thisData = d3.values(d3.csv.parse(evt.target.result));

            thisData = Init.prepareData(thisData);

            console.log(thisData);

            dataMin = d3.min(thisData, function(d)
            {
                return d.startTime;
            });
            dataMax = d3.max(thisData, function(d)
            {
                return d.endTime;
            });

            TimeLine.print(thisData, indexData, parentDiv, dataMin, dataMax);
            Gantt.print(thisData, indexData, parentDiv, dataMin, dataMax);
            Spiral.print(thisData, indexData, parentDiv, dataMin, dataMax);
            Mat.print(thisData, indexData, parentDiv, dataMin, dataMax);


        };
    }



};