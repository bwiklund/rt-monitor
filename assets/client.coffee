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
    sock.on 'ping', (msg) =>
      @data.push msg.totalCpu
      @data.shift()
      console.log msg
      @update()

    @data = generateRandomData()

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

    @update()

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

  update: ->
    @svg.selectAll("path")
      .data([@data])
      .attr d: @line

window.addEventListener 'load', ->
  new Chart("#one")

