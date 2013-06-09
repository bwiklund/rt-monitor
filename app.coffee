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

sio.on 'connection', (sock) ->
  # todo: fill history in

updateStats = ->
  # this isn't as precise or clean as it could be,
  # but good enough for a demo.
  exec "ps aux | awk '{print $3}'", (err, stdout, stderr) ->
    usages = (stdout.split(/\n/)[1..])
    totalCpu = 0
    totalCpu += ~~usage for usage in usages
    ping = {totalCpu}
    sio.sockets.emit 'ping', ping
    setTimeout updateStats, 1000

updateStats()

httpServer.listen CONFIG.port
console.log "listening on #{CONFIG.port}"
