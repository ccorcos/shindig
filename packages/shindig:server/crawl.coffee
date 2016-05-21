###
The first time a users page is visited, the UserEventsStore publication will
trigger the user to be fetched. This could cause an abnormally long loading time
because we fetch all events for that user into the future.

After that, we crawl all users and events that haven't synced in a while and
fetch them. We probably want to offload this onto another server...
###

debug = (->)
if Meteor.settings.public?.log?.crawl
  debug = console.log.bind(console, 'crawl')

CRAWL_INTERVAL_MS = 1000*60*60*Meteor.settings.crawl?.interval_hours or 0
SYNC_THRESHOLD_MS = 1000*60*60*Meteor.settings.crawl?.threshold_hours or 48

# returns {latitude, longitude} or undefined
getLocation = (fbEvent) ->
  # if no location, rely on owner location
  if fbEvent.place?.location?
    return fbEvent.place.location
  else
    return facebook.api('get', '/'+fbEvent.owner.id, {
      fields:'location{latitude,longitude}'
    }).location

transformEvent = (fbEvent) ->
  hosts = S.getHosts(fbEvent)
  event = R.pick(['id', 'name', 'start_time', 'end_time'], fbEvent)
  event.start_time = moment(event.start_time).valueOf() # convert to timestamp
  event.end_time = moment(event.end_time).valueOf() if event.end_time # convert to timestamp
  event = R.merge(event, getLocation(fbEvent))
  return {event, hosts}

eventFields = [
  'id'
  'name'
  'start_time'
  'end_time'
  'owner{id,name}'
  'admins{id,name}' # http://stackoverflow.com/questions/31825944/inconsistent-errors-using-limit-and-since-with-facebook-graph-api-v2-4
  'place{location{latitude,longitude}}'
].join(',')

pause = -> Meteor._sleepForMs(0)

throttleCrawl = (f) ->
  cache = {}
  (arg) ->
    key = U.serialize(arg)
    if cache[key]
      return
    else
      cache[key] = true
      U.delay 1000, -> delete cache[key]
      f(arg)

Crawl.makeUser = throttleCrawl U.faultTolerant (userId) ->
  user = facebook.api('get', '/'+userId, {fields:'id,name'})
  debug('make user', user.name)
  user.lastSync = -1
  Neo4j.setUser(user)
  AnyDb.refresh 'user', R.propEq('userId', userId)

Crawl.user = U.faultTolerant (userId) ->
  user = facebook.api('get', '/'+userId, {fields:'id,name'})
  debug('user', user.name)
  user.lastSync = U.timestamp()
  Neo4j.setUser(user)
  pause()
  Crawl.userEvents(userId)

Crawl.userIfStale = U.faultTolerant (userId) ->
  u = _.first Neo4j.getUsers
    domain:
      id: userId
    fields:
      lastSync: true
  if not u or not u.lastSync or u.lastSync < U.timestamp()-SYNC_THRESHOLD_MS
    pause()
    Crawl.user(userId)

Crawl.userEvents = U.faultTolerant (userId) ->
  # if we find a user access token, then use it. otherwise, use the app token.
  # however, we can't ask for privacy field with the app token because those
  # will necessarily be public, apparently
  events = null
  if accessToken = facebook.getUserAccessToken(userId)
    events = facebook.api('get', '/'+userId+'/events', {
      fields: 'id,type'
      limit: 1000
      since: U.unix()
      access_token: accessToken
    }).data.filter R.propEq('type', 'public')
  else
    events = facebook.api('get', '/'+userId+'/events', {
      fields: 'id'
      limit: 1000
      since: U.unix()
    }).data

  # set the sync value so we dont crawl twice at the same time
  user = {id: userId, lastSync: U.timestamp()}
  Neo4j.setUser(user)

  debug(events.length, 'user events')
  for {id} in events
    pause()
    Crawl.event(id)

  # when we're done, update the pubs
  Update.userEvents(userId)
  AnyDb.refresh 'user', R.propEq('userId', userId)

Crawl.event = U.faultTolerant (eventId) ->
  # if this event is already in the database,
  # then we dont need to worry about specific user tokens.
  {event, hosts} = transformEvent(facebook.api('get', '/'+eventId, {
    fields: eventFields
  }))
  debug('event', event.name)
  event.lastSync = U.timestamp()
  event.hostIds = hosts.map R.prop('id')
  Neo4j.setEvent(event)

Crawl.eventIfStale = U.faultTolerant (eventId) ->
  e = _.first Neo4j.getEvents
    domain:
      id: eventId
    fields:
      lastSync: true
  if not e or not e.lastSync or e.lastSync < U.timestamp()-SYNC_THRESHOLD_MS
    pause()
    Crawl.event(eventId)

Crawl.stale = ->
  pause()
  debug("start...")
  users = Neo4j.getUsers
    filter:
      stale: SYNC_THRESHOLD_MS
  userIds = users.map R.prop('_id')
  debug(userIds.length, 'users')
  for userId in userIds
    pause()
    Crawl.user(userId)
  pause()
  # shouldnt be any eventIds orphaned, but lets try and see
  events = Neo4j.getEvents
    filter:
      stale: SYNC_THRESHOLD_MS
  eventIds = events.map R.prop('_id')
  debug(eventIds.length, 'events')
  for eventId in eventIds
    pause()
    Crawl.event(eventId)
  pause()
  debug("...done")
  return

Meteor.startup ->
  if CRAWL_INTERVAL_MS > 0
    # dont block the app from starting up!
    Meteor.defer ->
      Crawl.stale()
      Meteor.setInterval(Crawl.stale, CRAWL_INTERVAL_MS)
