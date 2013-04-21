fs = require 'fs'
coffee = require 'coffee-script'
uglify = require 'uglify-js'
{spawn, exec} = require 'child_process'

build = (options = {}) ->
  fs.readFile 'src/todos.coffee', 'utf8', (err, data) ->

    data = data.replace /@include '([^']+)'\n/g, (_, file) ->
      fs.readFileSync("src/#{file}.coffee", 'utf8')

    compiled = coffee.compile data
    compiled = uglify.minify(compiled, fromString: true).code if options.minify
    fs.writeFile 'bin/todos', """
      #!/usr/bin/env node
      #{compiled}
      """, (err) ->
        exec "chmod 744 bin/todos", (err) ->
          console.log "done."

install = ->
  exec "mv bin/todos /usr/bin", (err) ->
    console.log "done."

task 'minify', -> build(minify: true)
task 'build', -> build()
task 'install', -> install()
