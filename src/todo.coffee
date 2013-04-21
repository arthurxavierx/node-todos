#
moment = require 'moment'
colors = require 'colors'
fs = require 'fs'

Today = moment()

#
# Todo class
#
class Todo
  @all: []

  # show TODOs list
  @show: ->
    # sort the list by name
    @all.sort (a, b) -> 
      return (a.name > b.name) if (a.type == b.type) 
      (a.type > b.type)
    # show the list
    for todo in @all
      console.log "#{todo}"
    #
    console.log "nothing to do".grey if @all.length < 1

  # remove TODOs from list
  @remove: (options) ->
    @all.forEach (todo, index) =>
      if (options.name and todo.name.match(options.name)) or 
      (options.date and todo.date.format("DD/MM/YYYY").match(options.date)) or 
      (options.done and todo.done)
        #
        delete @all[index]
        @all.splice(index, 1)

  # set TODOs as done
  @done: (options) ->
    @all.forEach (todo) =>
      if (options.name and todo.name.match(options.name)) or 
      (options.date and todo.date.format("DD/MM/YYYY").match(options.date))
        #
        todo.done = true

  # save TODOs list to a JSON file
  @save: ->
    fs.writeFile 'todos.json', JSON.stringify(@all.map (e) -> e.toJSON()), (err) ->
      throw err if err

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

    return str.strike.green if @done

    # if TODO has a date, add it to the string
    if @date
      str += " - #{@date.format("DD/MM/YYYY")}" 
      return str.underline.red if @date.date() < Today.date()
      return str.bold.yellow if @date.date() == Today.date()
    # return the string
    str

  toJSON: ->
    type: @type
    name: @name
    date: (if @date then @date.format("DD/MM/YYYY") else undefined)
    done: @done

module.exports = Todo
