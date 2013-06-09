CONFIG = require './config'
express = require 'express'

app = express()
app.use express.static __dirname  + "/public"
app.use express.logger()

app.get "/api/stats", (req,res) ->
  res.send "hi"

app.listen CONFIG.port
console.log "listening on #{CONFIG.port}"
