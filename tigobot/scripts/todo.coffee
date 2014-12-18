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

  getTodos = (person) ->
    return robot.brain.users()[person].todo

  setTodos = (person, todos) ->
    robot.brain.users()[person].todo = todos

  robot.hear /(TODO: |I NEED TO |\[ \] )(.*)$/i, (msg) ->
    person = msg.message.user.name
    thing = msg.match[2].trim()
    if not robot.brain.users()[person].todo
      robot.brain.users()[person].todo = []
    robot.brain.users()[person].todo.push thing
    msg.reply "You need to " + thing + ". " + msg.random(m_added)

  robot.hear /(\?)?TODO(\?)?$/i, (msg) ->
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
