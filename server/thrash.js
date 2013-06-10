var thrash = function(){
  var uselessData = [];
  for( var i = 0; i < 10000000; i++ ){
    uselessData.push( Math.random() );
  }
  setTimeout(thrash,1000);
}

thrash()

