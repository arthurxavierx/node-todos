#
moment = require 'moment'
colors = require 'colors'
path = require 'path'
fs = require 'fs'

Today = moment()


#
# Todo class
#
class Todo
  @all: []
  @file: path.join __dirname, '..', 'data', 'todos.json'

  # show TODOs list
  @show: ->
    # sort the list by name
    @all.sort (a, b) -> 
      return (a.name > b.name) if (a.type == b.type) 
      (a.type > b.type)
    # show the list
    console.log()

    for todo in @all
      console.log "\t#{todo}"
    #
    console.log "nothing to do".grey if @all.length < 1

    console.log()

  # remove TODOs from list
  @remove: (options) ->
    index = 0
    while index < @all.length
      todo = @all[index]
      if (options.name and todo.name.match(new RegExp(options.name, 'i'))) or 
      (options.date and todo.date.format("DD/MM/YYYY").match(options.date)) or 
      (options.done and todo.done)
        #
        delete @all[index]
        @all.splice(index, 1)
        index--
      index++

  # set TODOs as done
  @done: (options) ->
    @all.forEach (todo) =>
      if (options.name and todo.name.match(new RegExp(options.name, 'i'))) or 
      (options.date and todo.date.format("DD/MM/YYYY").match(options.date))
        #
        todo.done = true

  # save TODOs list to a JSON file
  @save: ->
    fs.writeFile @file, JSON.stringify(@all.map (e) -> e.toJSON()), (err) ->
      throw err if err

  @load: (callback) ->
    fs.readFile @file, (err, data) ->
      if !err
        list = JSON.parse data
        for todo in list
          new Todo(todo)

      callback()


  #
  constructor: (options = {}) ->
    @type = options.type

    if @type
      @name = options.name
    else
      # if todo is created by command-line, 
      # set type and name by splitting string in ':'
      [@type, @name] = options.name.split(':')
      if !@name
        # no type supplied
        @name = @type
        delete @type
    # trim name string
    @name = @name.trim()

    if options.date
      @date = moment options.date, "DD-MM-YYYY"

    @done = options.done or false

    # add TODO to the list
    Todo.all.push this

  # converts to a string
  toString: ->
    str = @name
    # if TODO has a type, add it to the string
    str = (if @type then "#{@type}: " else "") + str
    # mark the TODO as done or not
    symbol = (if @done then "✓ ".green else "✖ ".red)
    # add the date to the end of the string
    str += " - #{@date.format("DD/MM/YYYY")}" if @date

    # if the TODO is already done
    return symbol + str.strike.green if @done

    # if TODO has a date, add it to the string
    if @date
      return symbol + str.bold.red if @date.date() < Today.date()
      return symbol + str.bold.yellow if @date.date() == Today.date()

    # return the final string
    symbol + str

  toJSON: ->
    type: @type
    name: @name
    date: (if @date then @date.format("DD/MM/YYYY") else undefined)
    done: @done

module.exports = Todo
