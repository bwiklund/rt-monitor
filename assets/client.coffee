class Chart
  constructor: (@selector,@units = "",@yRange) ->

    @data = []#generateRandomData()

    width = 400
    height = 60

    yScale = d3.scale.linear()
      .domain([0,@yRange])
      .range([height,0])

    @root = d3.select(@selector,@units)

    @svg = @root.append("svg")
      .attr {width,height}

    @line = d3.svg.line()
      .x( (d,i) -> i * 2 )
      .y( (d) -> yScale(d) )

    dots = @svg.selectAll("path")
      .data([@data])
      .enter()
        .append("path")
        .attr(
          d: @line
          stroke: 'black'
          'stroke-width': 3
          'stroke-linejoin': 'round'
          fill: 'none'
        )

    @updateGraph()

  addPoint: (val) ->
    @data.push val
    @data = @data[-200..]
    @updateGraph()

  updateGraph: ->
    val = @data[-1..][0] || 0
    @root.select("h1").text( val.toFixed(0) + @units)
    @svg.selectAll("path")
      .data([@data])
      .attr d: @line



window.addEventListener 'load', ->
  sock = io.connect()
  
  usage =      new Chart("#usage","%",200)
  memory =     new Chart("#memory","%",100)
  processes =  new Chart("#processes","",300)
  randomData = new Chart("#random","",300)

  sock.on 'ping', (msg) ->
    usage.addPoint      msg.totalCpu
    memory.addPoint     msg.memoryUsage
    processes.addPoint  msg.processCount
    randomData.addPoint msg.randomData
