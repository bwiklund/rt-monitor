(function() {
  var Chart, generateRandomData, sock;

  sock = io.connect();

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

  Chart = (function() {
    function Chart(container) {
      var dots, height, width, yScale,
        _this = this;
      sock.on('ping', function(msg) {
        _this.data.push(msg.totalCpu);
        _this.data.shift();
        console.log(msg);
        return _this.update();
      });
      this.data = generateRandomData();
      width = 400;
      height = 60;
      yScale = d3.scale.linear().domain([0, 200]).range([height, 0]);
      this.svg = d3.select(container).append("svg").attr({
        width: width,
        height: height
      });
      this.line = d3.svg.line().x(function(d, i) {
        return i * 2;
      }).y(function(d) {
        return yScale(d);
      });
      this.update();
      dots = this.svg.selectAll("path").data([this.data]).enter().append("path").attr({
        d: this.line,
        stroke: 'black',
        'stroke-width': 3,
        'stroke-linejoin': 'round',
        fill: 'none'
      });
    }

    Chart.prototype.update = function() {
      return this.svg.selectAll("path").data([this.data]).attr({
        d: this.line
      });
    };

    return Chart;

  })();

  window.addEventListener('load', function() {
    return new Chart("#one");
  });

}).call(this);
