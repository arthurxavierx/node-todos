program = require 'commander'
fs = require 'fs'

Todo = require './todo'

#
# setup commander
#
program
  .version('0.1.3')
  .option('-n, --name [name]', 'Set name')
  .option('-d, --date [date]', 'Set date')
  .option('-D, --done', 'Flag done TODOs')
  .option('-U, --undone', 'Flag undone TODOs')

#
# New TODO command
#
program
  .command('new')
  .description('Creates a new TODO and add it to the list')
  .action ->
    if program.name then new Todo(name: program.name, date: program.date)
    Todo.show()
    Todo.save()

#
# Remove TODOs command
#
program
  .command('remove')
  .description('Remove TODOs from the list')
  .action ->
    Todo.remove(name: program.name, date: program.date, done: program.done)
    Todo.show()
    Todo.save()

#
# Set TODOs as done
#
program
  .command('set')
  .description('Set TODOs as done/undone')
  .action (name) ->
    if !program.done and !program.undone
      console.log "Done/Undone flag not specified"
      return
    Todo.done(name: program.name, date: program.date, done: (program.done or !program.undone))
    Todo.show()
    Todo.save()

#
# Remove done TODOs
#
program
  .command('clean')
  .description('Remove done TODOs from the list')
  .action ->
    Todo.remove(done: true)
    Todo.show()
    Todo.save()

#
# Show TODOs command
#
program
  .command('*')
  .description('Show the TODOs list')
  .action Todo.show

#
# Load TODOs list from file
#
Todo.load ->
  #
  program
    .parse(process.argv)

  Todo.show() if process.argv.length <= 2
