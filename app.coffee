CONFIG = require './config'
http = require 'http'
express = require 'express'
exec = require('child_process').exec
io = require 'socket.io'


app = express()
app.use express.static __dirname  + "/public"
app.use express.logger()

app.get "/api/stats", (req,res) ->
  exec "ps aux | awk '{print $3}'", (err, stdout, stderr) ->
    res.send 200, stdout

httpServer = http.createServer(app) # attach express
sio = io.listen httpServer # attach socket.io

sio.on 'connection', (sock) ->
  sock.emit 'ping', {hello:'world'} 

httpServer.listen CONFIG.port
console.log "listening on #{CONFIG.port}"
