(function() {
  var Chart;

  Chart = (function() {
    function Chart(selector, units, yRange) {
      var dots, height, width, yScale;
      this.selector = selector;
      this.units = units != null ? units : "";
      this.yRange = yRange;
      this.data = [];
      width = 400;
      height = 63;
      yScale = d3.scale.linear().domain([0, this.yRange]).range([height, 0]);
      this.root = d3.select(this.selector, this.units);
      this.svg = this.root.append("svg").attr({
        width: width,
        height: height
      });
      this.line = d3.svg.line().x(function(d, i) {
        return i * 2;
      }).y(function(d) {
        return yScale(d);
      });
      dots = this.svg.selectAll("path").data([this.data]).enter().append("path").attr({
        d: this.line,
        stroke: 'black',
        'stroke-width': 3,
        'stroke-linejoin': 'round',
        fill: 'none'
      });
      this.updateGraph();
    }

    Chart.prototype.addPoint = function(val) {
      this.data.push(val);
      this.data = this.data.slice(-200);
      return this.updateGraph();
    };

    Chart.prototype.updateGraph = function() {
      var val;
      val = this.data.slice(-1)[0] || 0;
      this.root.select("h1").text(val.toFixed(0) + this.units);
      return this.svg.selectAll("path").data([this.data]).attr({
        d: this.line
      });
    };

    return Chart;

  })();

  window.addEventListener('load', function() {
    var memory, processes, randomData, sock, usage;
    sock = io.connect();
    usage = new Chart("#usage", "%", 200);
    memory = new Chart("#memory", "%", 100);
    processes = new Chart("#processes", "", 300);
    randomData = new Chart("#random", "", 300);
    return sock.on('ping', function(msg) {
      usage.addPoint(msg.totalCpu);
      memory.addPoint(msg.memoryUsage);
      processes.addPoint(msg.processCount);
      return randomData.addPoint(msg.randomData);
    });
  });

}).call(this);
