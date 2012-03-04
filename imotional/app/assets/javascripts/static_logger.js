var Utils = {}
Utils.StaticLogger = { 
  collection: []
  ,log: function( key, value ) {
    key = key.replace(/\W/g, '_');
    if( !this.collection[ key ] ) {
      this.draw();
      this.div.append( "<div><div style='float: left; width: 60px; font-size:12px;font-weight:bold;'>" + key +"</div><div id='sl_key_" + key +"' style='margin-left: 85px; font-size: 12px'>" + value +"</div></div>" );
      this.collection[ key ] = true;
    } else {
      $("#sl_key_" + key ).html(value);
    }
  }
  
  ,draw: function( ) {
    if( !this.div || this.div.length == 0 ) {
      $( document.body ).append( "<div id='static_logger' style='position:fixed;right:10px;top:10px; width:300px; border: 2px solid black; background-color: white;height: 150px; overflow:auto'></div>" );
      this.div = $('#static_logger');
    }
  }
}
var sl = Utils.StaticLogger;


// sl.log = function() {};