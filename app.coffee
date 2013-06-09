CONFIG = require './config'
express = require 'express'
exec = require('child_process').exec

app = express()
app.use express.static __dirname  + "/public"
app.use express.logger()

app.get "/api/stats", (req,res) ->
  exec "ps aux | awk '{print $3}'", (err, stdout, stderr) ->
    res.send 200, stdout

app.listen CONFIG.port
console.log "listening on #{CONFIG.port}"
