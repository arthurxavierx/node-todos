fs = require 'fs'
coffee = require 'coffee-script'
uglify = require 'uglify-js'
{spawn, exec} = require 'child_process'

build = (options = {}) ->
  ###fs.readFile 'src/todos.coffee', 'utf8', (err, data) ->

    #data = data.replace /@include '([^']+)'\n/g, (_, file) ->
    #  fs.readFileSync("src/#{file}.coffee", 'utf8')

    compiled = coffee.compile data
    compiled = uglify.minify(compiled, fromString: true).code if options.minify
    fs.writeFile './bin/todos', compiled, (err) ->
      console.log "done."
      exec "chmod 744 ./bin/todos", (err) ->
        console.log "done."
  ###
  coffee = spawn 'coffee', [
    '-c'
    '-b'
    '-o'
    './lib'
    './src'
  ]
  coffee.stdout.pipe process.stdout
  coffee.stderr.pipe process.stderr
  coffee.on 'exit', (status) -> 
    console.log "done."

task 'minify', -> build(minify: true)
task 'build', -> build()
