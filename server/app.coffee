CONFIG = require './config'
http = require 'http'
express = require 'express'

app = express()
app.use express.static __dirname  + "./../public"
app.use express.logger()

httpServer = http.createServer(app) # attach express

hardwareMonitor = require('./hardwareMonitor')(httpServer)

httpServer.listen CONFIG.port
console.log "listening on #{CONFIG.port}"
