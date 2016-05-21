L = console.log.bind(console, '\n')

eventId = '1442336736094604'
fbId = '10205633768661272'
userId = '14226545351'
time = Date.now()
latlng = [ 33.845439, -118.379374]
search = 're'
limit = 10

# REPLACE ALL: ^[\w-:\.\(\)\?]+

Neo4j.logExamples = ->
  for key, func of Neo4j.examples
    func()
  return

Neo4j.benchmarkExamples = ->
  for key, func of Neo4j.examples
    func (cypher) ->
      L cypher
      lap = U.stopwatch()
      Neo4j.query(cypher)
      L 'benchmark:', lap(), 's'
  return

Neo4j.examples = {}
Neo4j.examples.getEvents = (Q=L) ->
  L '* `Neo4j.getEvents`'
  L '- by id'
  Q Neo4j.queries.getEvents
    domain:
      id: eventId
  L '- by id with fields'
  Q Neo4j.queries.getEvents
    domain:
      id: eventId
    fields:
      starCount: true
      starred: fbId
      followedStarCount: fbId
  L '- feed by time'
  Q Neo4j.queries.getEvents
    domain:
      feed: fbId
    sort:
      time: true
    paging:
      limit: limit
  L '- feed by popular'
  Q Neo4j.queries.getEvents
    domain:
      feed: fbId
    filter:
      time: time
    sort:
      popular: true
    paging:
      limit: limit
  L '- feed with filters by time'
  Q Neo4j.queries.getEvents
    domain:
      feed: fbId
    filter:
      name: search
      time: time
      latlng: latlng
    sort:
      time: true
    paging:
      limit: limit
  L '- feed with filters by popular'
  Q Neo4j.queries.getEvents
    domain:
      feed: fbId
    filter:
      name: search
      time: time
      latlng: latlng
    sort:
      popular: true
    paging:
      limit: limit
  L '- feed with filters and fields by popular'
  Q Neo4j.queries.getEvents
    domain:
      feed: fbId
    filter:
      name: search
      time: time
      latlng: latlng
    sort:
      popular: true
    paging:
      limit: limit
    fields:
      starCount: true
      starred: fbId
      followedStarCount: fbId
  L '- user events by time'
  Q Neo4j.queries.getEvents
    domain:
      user: fbId
    sort:
      time: true
    paging:
      limit: limit
  L '- user events by popular'
  Q Neo4j.queries.getEvents
    domain:
      user: fbId
    filter:
      time: time
    sort:
      popular: true
    paging:
      limit: limit
  L '- user events with filters by time'
  Q Neo4j.queries.getEvents
    domain:
      user: fbId
    filter:
      name: search
      time: time
      latlng: latlng
    sort:
      time: true
    paging:
      limit: limit
  L '- user events with filters by popular'
  Q Neo4j.queries.getEvents
    domain:
      user: fbId
    filter:
      name: search
      time: time
      latlng: latlng
    sort:
      popular: true
    paging:
      limit: limit
  L '- events with filters by time'
  Q Neo4j.queries.getEvents
    filter:
      name: search
      time: time
      latlng: latlng
    sort:
      time: true
    paging:
      limit: limit
  L '- events by popular'
  Q Neo4j.queries.getEvents
    filter:
      time: time
    sort:
      popular: true
    paging:
      limit: limit

Neo4j.examples.getUsers = (Q=L) ->
  L '* `Neo4j.getUsers`'
  L '- by id'
  Q Neo4j.queries.getUsers
    domain:
      id: userId
  L '- by id with fields'
  Q Neo4j.queries.getUsers
    domain:
      id: userId
    fields:
      followCount: true
      followerCount: true
      followed: fbId
  L '- follows by name'
  Q Neo4j.queries.getUsers
    domain:
      follows: userId
    sort:
      name: true
    paging:
      limit: limit
  L '- follows by popular'
  Q Neo4j.queries.getUsers
    domain:
      follows: userId
    sort:
      popular: true
    paging:
      limit: limit
  L '- followers with filters by popular'
  Q Neo4j.queries.getUsers
    domain:
      follows: userId
    filter:
      name: search
    sort:
      popular: true
    paging:
      limit: limit
  L '- stargazers'
  Q Neo4j.queries.getUsers
    domain:
      stargazers: eventId
    filter:
      name: search
    sort:
      popular: true
    paging:
      limit: limit
  L '- followedStargazers'
  Q Neo4j.queries.getUsers
    domain:
      followedStargazers: {fbId, eventId}
    sort:
      name: true
    paging:
      limit: limit
  L '- users by popular'
  Q Neo4j.queries.getUsers
    sort:
      popular: true
    paging:
      limit: limit
  L '- users with filters by popular'
  Q Neo4j.queries.getUsers
    domain:
      follows: userId
    filter:
      name: search
    sort:
      popular: true
    paging:
      limit: limit

Neo4j.examples.setUser = (Q=L) ->
  L '* `Neo4j.setUser`'
  Q Neo4j.queries.setUser({id: '1234', name: 'Joe', lastSync: 4321})

Neo4j.examples.setEvent = (Q=L) ->
  L '* `Neo4j.setEvent`'
  Q Neo4j.queries.setEvent
    id: '1234'
    hostIds: ['99', '88', '77']
    name: 'Party'
    lastSync: 4321
    start_time: 100
    end_time: 200
    latitude: 30.9
    longitude: -20.44

Neo4j.examples.setSession = (Q=L) ->
  L '* `Neo4j.setSession`'
  Q Neo4j.queries.setSession(fbId, 100, 200)

Neo4j.examples.setFollow = (Q=L) ->
  L '* `Neo4j.setFollow`'
  Q Neo4j.queries.setFollow(fbId, userId)

Neo4j.examples.setUnfollow = (Q=L) ->
  L '* `Neo4j.setUnfollow`'
  Q Neo4j.queries.setUnfollow(fbId, userId)

Neo4j.examples.setStar = (Q=L) ->
  L '* `Neo4j.setStar`'
  Q Neo4j.queries.setStar(fbId, eventId)

Neo4j.examples.setUnstar = (Q=L) ->
  L '* `Neo4j.setUnstar`'
  Q Neo4j.queries.setUnstar(fbId, eventId)
