# Description:
#   Tests for Hubot.
#
# Commands:
#   hubot static - http url of localhost:8080/test
#   hubot test - OK
#   hubot reply - OK
#   hubot hubot rsvp - OK
#   hubot random - 1 or 2

module.exports = (robot) ->

  assert = require 'assert'

  robot.hear /static/i, (msg) ->
    msg.http('http://127.0.0.1/test').port(process.env.PORT or 8080)
      .get() (err, res, body) ->
        msg.chatty body

  robot.hear /test/i, (msg) ->
    msg.chatty "OK"

  robot.hear /reply/i, (msg) ->
    msg.reply "OK"

  robot.respond /rsvp/i, (msg) ->
    msg.chatty "responding"

  robot.hear /random/i, (msg) ->
    msg.chatty msg.random([1,2]).toString()

  robot.hear /http/i, (msg) ->
    msg.http('http://127.0.0.1').port(9001)
      .get() (err, res, body) ->
        msg.chatty body