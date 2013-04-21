#
# Todo class
#
class Todo
  @all: []

  @show: ->
    @all.sort (a, b) -> 
      return (a.name > b.name) if (a.type == b.type) 
      (a.type > b.type)
    for todo in @all
      console.log "#{todo}"
    console.log "nothing to do".grey if @all.length < 1

  @remove: (options) ->
    @all.forEach (todo, index) =>
      if (options.name and todo.name.match(options.name)) or 
      (options.date and todo.date.format("DD/MM/YYYY").match(options.date)) or 
      (options.done and todo.done)
        delete @all[index]
        @all.splice(index, 1)

  @done: (options) ->
    @all.forEach (todo) =>
      if (options.name and todo.name.match(options.name)) or (options.date and todo.date.format("DD/MM/YYYY").match(options.date))
        todo.done = true

  @save: ->
    fs.writeFile 'todos.json', JSON.stringify(@all.map (e) -> e.toJSON()), (err) ->
      throw err if err

  #
  constructor: (options = {}) ->
    @type = options.type

    if @type
      @name = options.name
    else
      [@type, @name] = options.name.split(':')
      @name = if @name then @name.trim() else @type

    if options.date
      @date = moment options.date, "DD-MM-YYYY"

    @done = options.done or false
    @name = @name.trim()

    # add TODO to the list
    Todo.all.push this

  # converts to a string
  toString: ->
    str = "#{@type}: #{@name}"
    return str.strike.green if @done
    if @date
      str += " - #{@date.format("DD/MM/YYYY")}" 
      return str.underline.red if @date.date() < Today.date()
      return str.bold.yellow if @date.date() == Today.date()
    str

  toJSON: ->
    type: @type
    name: @name
    date: @date.format("DD/MM/YYYY")
    done: @done
