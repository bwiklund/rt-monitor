CONFIG = require './config'
exec = require('child_process').exec
io = require 'socket.io'


class HardwareMonitor

  constructor: (server) ->
    @sio = io.listen server, 
      log: process.env.NODE_ENV == 'development' # attach socket.io
    
    @recentPings = []
    @sio.on 'connection', (sock) =>
      sock.emit 'ping', ping for ping in @recentPings

    @updateStats()

  updateStats: ->
    exec "ps aux | awk '{print $3,$4}'", (err, stdout, stderr) =>
      usages = (stdout.split(/\n/)[1...-1]).map (row) -> 
        parts = row.split /\s/
        cpu: parts[0], memory: parts[1]

      totalCpu = memoryUsage = 0
      processCount = usages.length

      for usage in usages
        totalCpu += parseFloat(usage.cpu) 
        memoryUsage += parseFloat(usage.memory)

      randomData = Math.random() * Math.sin( new Date().getTime()/10000 ) * 100 + 100
      
      @addLatestPing {totalCpu,memoryUsage,processCount,randomData}

      setTimeout @updateStats.bind(@), CONFIG.updateInterval

  addLatestPing: (ping) ->
    @recentPings.push ping
    @recentPings = @recentPings[-200..]
    @sio.sockets.emit 'ping', ping


module.exports = (server) ->new HardwareMonitor server
