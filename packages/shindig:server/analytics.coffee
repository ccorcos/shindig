# debug = console.log.bind(console, 'session')
debug = (->)

Accounts.onLogin ({user, connection}) ->
  userId = user._id
  start_time = U.timestamp()
  debug('start', userId, start_time)
  connection.onClose ->
    end_time = U.timestamp()
    debug('stop', userId, end_time)
    Meteor.defer ->
      Neo4j.setSession(userId, start_time, end_time)
