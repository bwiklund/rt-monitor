(function() {
  window.addEventListener('load', function() {
    var addRandomChart, generateRandomData, sock;
    sock = io.connect();
    sock.on('ping', function(msg) {
      return console.log(msg);
    });
    generateRandomData = function() {
      var d, data, i, j, _i, _j, _k, _len, _ref, _results;
      data = (function() {
        _results = [];
        for (_i = 0; _i <= 200; _i++){ _results.push(_i); }
        return _results;
      }).apply(this).map(Math.random);
      for (j = _j = 0; _j <= 3; j = ++_j) {
        _ref = data.slice(0, -1);
        for (i = _k = 0, _len = _ref.length; _k < _len; i = ++_k) {
          d = _ref[i];
          data[i] = (data[i + 1] + data[i]) / 2;
        }
      }
      return data = (function() {
        var _l, _len1, _results1;
        _results1 = [];
        for (_l = 0, _len1 = data.length; _l < _len1; _l++) {
          d = data[_l];
          _results1.push(Math.pow(d, 1 / 6));
        }
        return _results1;
      })();
    };
    addRandomChart = function(container) {
      var data, dots, height, line, svg, width;
      data = generateRandomData();
      width = 400;
      height = 60;
      svg = d3.select(container).append("svg").attr({
        width: width,
        height: height
      });
      line = d3.svg.line().x(function(d, i) {
        return i * 2;
      }).y(function(d) {
        return 100 - d * 100;
      });
      return dots = svg.selectAll("path").data([data]).enter().append("path").attr({
        d: line,
        stroke: 'black',
        'stroke-width': 3,
        'stroke-linejoin': 'round',
        fill: 'none'
      });
    };
    addRandomChart("#one");
    addRandomChart("#two");
    return addRandomChart("#three");
  });

}).call(this);
