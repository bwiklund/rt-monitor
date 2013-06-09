CONFIG = require './config'
http = require 'http'
express = require 'express'
exec = require('child_process').exec
io = require 'socket.io'


app = express()
app.use express.static __dirname  + "/public"
app.use express.logger()

httpServer = http.createServer(app) # attach express
sio = io.listen httpServer # attach socket.io

recentPings = []

sio.on 'connection', (sock) ->
  sock.emit 'ping', ping for ping in recentPings

updateStats = ->
  # this isn't as precise or clean as it could be,
  # but good enough for a demo. something like this:
  # http://linux.die.net/man/1/sar
  # would be better
  exec "ps aux | awk '{print $3,$4}'", (err, stdout, stderr) ->
    usages = (stdout.split(/\n/)[1...-1]).map (row) -> 
      parts = row.split /\s/
      cpu: parts[0], memory: parts[1]

    totalCpu = memoryUsage = 0
    processCount = usages.length

    # tally up cpu and mem
    for usage in usages
      totalCpu += parseFloat(usage.cpu) 
      memoryUsage += parseFloat(usage.memory)

    ping = {totalCpu,memoryUsage,processCount}
    
    # save so we can fill the charts for new connections,
    # but only the last X pings
    recentPings.push ping
    recentPings = recentPings[-200..]

    sio.sockets.emit 'ping', ping
    setTimeout updateStats, CONFIG.updateInterval

updateStats()

httpServer.listen CONFIG.port
console.log "listening on #{CONFIG.port}"
