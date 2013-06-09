class Chart
  constructor: (@selector,@units = "") ->

    @data = []#generateRandomData()

    width = 400
    height = 60

    yScale = d3.scale.linear()
      .domain([0,200])
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
    @data = @data[-200..]
    @data.push val
    @updateGraph()

  updateGraph: ->
    val = @data[-1..][0] || 0
    @root.select("h1").text( val.toFixed(0) + @units)
    @svg.selectAll("path")
      .data([@data])
      .attr d: @line



window.addEventListener 'load', ->
  sock = io.connect()
  
  usage =     new Chart("#one","%")
  memory =    new Chart("#two","%")
  processes = new Chart("#three")

  sock.on 'ping', (msg) =>
    console.log msg
    usage.addPoint     msg.totalCpu
    memory.addPoint    msg.memoryUsage
    processes.addPoint msg.processCount
