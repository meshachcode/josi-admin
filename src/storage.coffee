# Description:
#   Inspect the data in redis easily
#
# Commands:
#   hubot show users - Display all users that hubot knows about
#   hubot show storage - Display the contents that are persisted in the brain


Util = require "util"

module.exports = (robot) ->
  robot.respond /show storage$/i, (msg) ->
    output = Util.inspect(robot.brain.data, false, 4)
    msg.send output

  robot.respond /clear storage$/i, (msg) ->
    msg.send "are you absolutely sure!?"
    msg.waitResponse (msg) ->
      if /yes/.test(msg.message.text)
        msg.send "okay..."
        robot.brain.data = {
          users: robot.brain.data.users
        }
        robot.logger.info robot.brain.data

  robot.respond /show users$/i, (msg) ->
    response = ""

    for own key, user of robot.brain.data.users
      response += "#{user.id} #{user.name}"
      response += " <#{user.email_address}>" if user.email_address
      response += "\n"

    msg.send response

