sock = io.connect()


generateRandomData = ->
  data = [0..200].map Math.random

  # smoothing
  for j in [0..3]
    for d,i in data[0...-1]
      data[i] = (data[i+1] + data[i])/2

  data = (Math.pow(d,1/6) for d in data)


class Chart
  constructor: (container) ->

    @data = []#generateRandomData()

    width = 400
    height = 60

    yScale = d3.scale.linear()
      .domain([0,200])
      .range([height,0])

    @svg = d3.select(container).append("svg")
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

  addPoint: (val) ->
    @data = @data[-200..]
    @data.push val
    @updateGraph()

  updateGraph: ->
    @svg.selectAll("path")
      .data([@data])
      .attr d: @line

window.addEventListener 'load', ->
  usage = new Chart("#one")
  memory = new Chart("#two")
  processes = new Chart("#three")

  sock.on 'ping', (msg) =>
    console.log msg
    usage.addPoint msg.totalCpu
    memory.addPoint msg.memoryUsage
    processes.addPoint msg.processCount
