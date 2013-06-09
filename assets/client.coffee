window.addEventListener 'load', ->


  generateRandomData = ->
    data = [0..200].map Math.random

    # smoothing
    for j in [0..3]
      for d,i in data[0...-1]
        data[i] = (data[i+1] + data[i])/2

    data = (Math.pow(d,1/6) for d in data)


  addRandomChart = (container) ->
    data = generateRandomData()

    width = 400
    height = 60

    svg = d3.select(container).append("svg")
      .attr {width,height}

    line = d3.svg.line()
      .x( (d,i) -> i * 2 )
      .y( (d) -> 100 - d * 100 )

    dots = svg.selectAll("path")
      .data([data])
      .enter()
        .append("path")
        .attr(
          d: line
          stroke: 'black'
          'stroke-width': 3
          'stroke-linejoin': 'round'
          fill: 'none'
        )


  addRandomChart("#one")
  addRandomChart("#two")
  addRandomChart("#three")

