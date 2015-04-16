# Description:
#   Handy todo lists
#
# Commands:
#   todo: <thing> - add a thing to your todo list
#   todo? - get your todo list
#   how many things to do? - Count your todo list and get a motivational message.

module.exports = (robot) ->

  m_none = ["You must be an undergrad.", "Boring.", "Better write a book.", "Lucky sod.", "Learn a new language?", "I'm sure rhiaro could delegate something to you.", "Alright for some."]
  m_some = ["You'll be fine.", "Better get started.", "You'll be bored in no time.", "You can wrap that up in a day or two."]
  m_many = ["That's quite a lot.", "You should probably get started.", "Less of the Buzzfeed, more of the productivity, eh?", "Are you using Trello?", "Must work harder.", "Get on with it."]
  m_lots = ["Are you a grad student?", "Better get started then!", "No time like the present.", "Stop procrastinating!", "Get on with something!"]
  m_loads = ["Ouuucchhh", "There's just no way.", "You poor thing.", "You should quit now.", "Delegate to some wee undergrad?"]

  m_added = ["Gotcha.", "I've added that to your list.", "Just ask me if you forget."]

  m_bored = ["Bored? Don't forget you need to do ", "You're bored? You could always do ", "If you're not doing anything else, don't forget you need to ", "You can't be bored, you need to ", "Bored? On your todo list is "]

  getTodos = (person) ->
    return robot.brain.users()[person].todo

  setTodos = (person, todos) ->
    robot.brain.users()[person].todo = todos

  setTodo = (msg, thing) ->
    person = msg.message.user.name
    if not robot.brain.users()[person].todo
      robot.brain.users()[person].todo = []
    robot.brain.users()[person].todo.push thing
    "You need to " + thing + ". " + msg.random(m_added)

  bored = (msg) ->
    todos = getTodos msg.message.user.name
    if todos and todos.length > 0
      thing = msg.random todos
      b = msg.random m_bored
      b + thing
    else
      helpout msg

  helpout = (msg) ->
    person = msg.message.user.name
    poorSods = []
    for k, v of robot.brain.users()
      if k.name isnt person and robot.brain.users()[k].todo and robot.brain.users()[k].todo.length > 0
        poorSods.push v.name
    if poorSods.length > 0
      helpPerson = msg.random poorSods
      helpWith = msg.random robot.brain.users()[helpPerson].todo
      helpMessage = "You could help " + helpPerson + " with " + helpWith + ". You should. I've added it to your list for you."
      setTodo msg, "Help " + helpPerson + " with " + helpWith + "."
      helpMessage

  robot.hear /(TODO: |I NEED TO |\[ \] |I HAVE TO |I SHOULD )(.*)$/i, (msg) ->
    person = msg.message.user.name
    thing = msg.match[2].trim()
    setMessage = setTodo msg, thing
    msg.reply setMessage

  robot.hear /((\?)?TODO(\?)?|WHAT'?S ON MY LIST(\?)?|WHAT DO I NEED TO DO(\?)?)$/i, (msg) ->
    person = msg.message.user.name
    todos = getTodos person
    if not todos or todos.length == 0
      msg.reply "Nothing on your list! " + msg.random(m_none)
    else
      msg.reply "You need to do: " + todos.join(", ")

  robot.hear /SO MANY THINGS TO DO(\!)?|SO MUCH TO DO(\!)?|HOW MANY THINGS TO DO(\?)?$/i, (msg) ->

    todos = getTodos msg.message.user.name
    c = todos.length
    if c > 31
      m = msg.random m_loads
    else if c > 15
      m = msg.random m_lots
    else if c > 7
      m = msg.random m_many
    else if c > 0
      m = msg.random m_some
      probability = Math.random()
      if probability > 0.9
        help_message = helpout msg.message.user.name
        if help_message
          m = m + help_message
    else
      m = msg.random m_none

    msg.reply 'You have ' + c + ' things to do. ' + m

  robot.hear /(\[x\] |DONE: )(.*)$/i, (msg) ->
    person = msg.message.user.name
    thing = msg.match[2].trim()
    if thing.toLowerCase() is 'all' or thing.toLowerCase() is 'everything'
      setTodos person, []
      msg.reply "Waaayyyyy you did all the things!"
    else
      todos = getTodos person
      setTodos person, todos.filter (x) -> x isnt thing
      msg.reply "Nice work, you finished doing " + thing

  robot.hear /I'M BORED|I AM BORED|WHAT SHOULD I DO|SO BORED$/i, (msg) ->
    mess = bored msg
    if mess
      msg.reply mess
