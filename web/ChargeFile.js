function handleIndexSelect (evt)
{
    var files = evt.target.files; // FileList object

    var f = files[0];
        
    // files is a FileList of File objects. List some properties.
    //var output = [];
        
    //output.push('<li><strong>', escape(f.name), '</strong> (', f.type || 'n/a', ') - ',
    //    f.size, ' bytes, last modified: ',
    //    f.lastModifiedDate ? f.lastModifiedDate.toLocaleDateString() : 'n/a',
    //    '</li>');
                    
    reader = new FileReader();
    reader.onload = loadIndex; 
                    
    reader.readAsText(f);
        
                            
//document.getElementById('list').innerHTML = '<ul>' + output.join('') + '</ul>';
}


function handleDataSelect (evt)
{
    var files = evt.target.files; // FileList object

    // files is a FileList of File objects. List some properties.
    var output = [];
    for (var i = 0, f; f = files[i]; i++) {
        // output.push('<li><strong>', escape(f.name), '</strong> (', f.type || 'n/a', ') - ',
        //     f.size, ' bytes, last modified: ',
        //     f.lastModifiedDate ? f.lastModifiedDate.toLocaleDateString() : 'n/a',
        //     '</li>');
                    
        reader = new FileReader();
        reader.onload = loadData(f); 
                    
        reader.readAsText(f);
    

    }
                            
//document.getElementById('list').innerHTML = '<ul>' + output.join('') + '</ul>';
}

function loadIndex (event)
{
//    console.log(event.target);
//    console.log(reader);
                        
    indexData = d3.csv.parse(event.target.result);

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


    angle = d3.scale.ordinal().domain( d3.merge([d3.keys(locations), [""]]) ).rangePoints([0, 2 * Math.PI]);
    

    
    colorInterp = d3.scale.category10().domain(d3.keys(locations));
    
   
    d3.keys(locations).forEach(function(d){
        locations[d] = colorInterp(d);
    } );
    
    Aux.createColorForm();
    
}
            
function loadData (file)
{
    
    return function(event)
    {
        var thisData =d3.values( d3.csv.parse(event.target.result));
        
        thisData.forEach(function (d)
        {
            //console.log(typeof d.startTime);
            d.ID = parseInt(d.ID);
            d.startTime = new Date( d.startTime);
            d.duration = parseInt(d.duration);
        });
        
        var thisMin = d3.min(thisData, Aux.minAccessor);
        var thisMax = d3.max(thisData, Aux.maxAccessor);
        
        
        data[file.name] = {
            fileName: file.name,
            data : thisData,
            min : thisMin,
            max : thisMax,
            radius : d3.time.scale().domain([thisMin  , thisMax])
            .range([innerRadius, outerRadius])

        };

//        console.log(data);
        
        Aux.createLinks(data[file.name]);
        
        Pattern.paintPattern( data[file.name] );
    };
    
    
    
//console.log(event.target);
//console.log(reader);
//output.push("<li>"+ index +"</li>")             
}       
