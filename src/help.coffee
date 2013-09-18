# Description: 
#   Generates help commands for Hubot.
#
# Commands:
#   hubot help - Displays all of the help commands that Hubot knows about.
#   hubot help <query> - Displays all help commands that match <query>.
#
# URLS:
#   /hubot/help
#
# Notes:
#   These commands are grabbed from comment blocks at the top of each file.

helpContents = (name, commands) ->

  """
<html>
  <head>
  <title>#{name} Help</title>
  <style type="text/css">
    body {
      background: #fefefe;
      color: #33336d;
      text-shadow: 0 1px 1px rgba(255, 255, 255, .5);
      font-family: Helvetica, Arial, sans-serif;
    }
    section {
      width: 500px;
      margin-left: auto;
      margin-right: auto;
    }
    h1 {
      margin: 20px;
      padding: 0;
      font-size: 3em;
      width: 100%;
      text-align: center;
    }
    .commands {
      font-size: 1.5em;
      line-height: 1.5em;
    }
    p {
      border-bottom: 1px solid #ededed;
      margin: 6px 0 0 0;
      padding-bottom: 5px;
    }
    p:last-child {
      border: 0;
    }
  </style>
  </head>
  <body>
    <section>
      <h1>#{name} Help</h1>
      <div class="commands">
        #{commands}
      </div>
    </section>
  </body>
</html>
  """

module.exports = (robot) ->
  robot.respond /help\s*(.*)?$/i, (msg) ->
    cmds = robot.helpCommands()

    if msg.match[1]
      cmds = cmds.filter (cmd) ->
        cmd.match new RegExp(msg.match[1], 'i')

      if cmds.length == 0
        msg.send "No available commands match #{msg.match[1]}"
        return
    emit = cmds.join "\n"

    unless robot.name.toLowerCase() is 'hubot'
      emit = emit.replace /hubot/ig, robot.name

    msg.send emit

  robot.router.get "/#{robot.name}/help", (req, res) ->
    cmds = robot.helpCommands().map (cmd) ->
      cmd.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;')

    emit = "<p>#{cmds.join '</p><p>'}</p>"

    emit = emit.replace /hubot/ig, "<b>#{robot.name}</b>"

    res.setHeader 'content-type', 'text/html'
    res.end helpContents robot.name, emit
