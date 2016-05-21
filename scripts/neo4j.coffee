###
REMEMBER: (:USER)-[:FOLLOWS]->(:USER)-[:HOSTS|STARS]->(:EVENT)

MATCH (u:USER)-[f:FOLLOWS]->(p:USER)-[s:HOSTS|STARS]->(e:EVENT) RETURN *

eventQuery =
  domain:
    id: userId  # user: userId, feed: userId
  filter:
    time: ms
    name: 'party'
    latlng: [lat, lng]
    stale: ms
  sort:
    popular: true  # time: true
  fields:
    id: true
    name: true
    starCount: true
    starred: userId
    followedStarCount: userId
  paging:
    limit: 10
    skip: 20

userQuery =
  domain:
    id: userId # follows: userId, followers:userId, stargazers:eventId, followedStargazers: {userId, eventId}
  filter:
    name: 'joe'
    stale: ms
  sort:
    popular: true
  fields
    id: true
    name: true
    followCount: true
    followerCount: true
    followed: userId
  paging:
    limit: 10
    skip: 20

actions:
  setUser(id,name, lastSync)
  setEvent(id, name, start_time, end_time, lat, lng, lastSync)
  setUserSession(id, start_time, end_time)
  setFollow(userId, followId)
  setUnfollow(userId, unfollowId)
  setStar(userId, eventId)
  setUnstar(userId, eventId)
###

isPlainObject = (x) ->
  Object.prototype.toString.apply(x) is '[object Object]'

isArray = (x) ->
  Object.prototype.toString.apply(x) is '[object Array]'

isString = (x) ->
  Object.prototype.toString.apply(x) is '[object String]'

str = (value) ->
  # turn an object into a string that plays well with
  # Cipher queries.
  if isArray(value)
    "[#{value.map(str).join(',')}]"
  else if isPlainObject(value)
    pairs = []
    for k,v of value
      pairs.push "#{k}:#{str(v)}"
    "{" + pairs.join(', ') + "}"
  else if isString(value)
    "'#{value.replace(/'/g, "\\'")}'"
  else if value is undefined
    null
  else
    "#{value}"

regex = (string) ->
  "'(?i).*#{string.replace(/'/g, "\\'").replace(/\//g, '\/')}.*'"


getEvents = (query) ->
  # query =
  #   domain:
  #     id: userId  # user: userId, feed: userId
  #   filter:
  #     time: ms
  #     name: 'party'
  #     latlng: [lat, lng]
  #     stale: ms
  #   sort:
  #     time: true # popular: false
  #   fields:
  #     id: true
  #     name: true
  #     starCount: true
  #     starred: userId
  #     followedStarCount: userId
  #   paging:
  #     limit: 10
  #     skip: 20

  lines = []

  # domain
  if id = query.domain?.id
    if query.sort?.popular
      throw new Meteor.Error 21, "cant fetch a popular event by id"
    lines.push "MATCH (e:EVENT {id: #{str(id)} })"
  else if id = query.domain?.user
    lines.push "MATCH (:USER {id: #{str(id)} })-[s:HOSTS|STARS]->(e:EVENT)"
  else if id = query.domain?.feed
    lines.push "MATCH (:USER {id: #{str(id)} })-[:FOLLOWS]->(:USER)-[s:HOSTS|STARS]->(e:EVENT)"
  else
    if query.sort?.popular
      lines.push "MATCH (:USER)-[s:HOSTS|STARS]->(e:EVENT)"
    else
      lines.push "MATCH (e:EVENT)"

  # filters
  where = []
  if time = query.filter?.time
    where.push "e.start_time > #{time}"
  if name = query.filter?.name
    where.push "e.name =~ #{regex(name)}"
  if latlng = query.filter?.latlng
    [lat, lng] = latlng
    r = 1
    where.push "e.latitude < #{str(lat+r)}"
    where.push "e.latitude > #{str(lat-r)}"
    where.push "e.longitude < #{str(lng+r)}"
    where.push "e.longitude > #{str(lng-r)}"
  if dt = query.filter?.stale
    where.push "NOT has(e.lastSync) OR e.lastSync < timestamp()-#{str(dt)}"

  if where.length > 0
    [WHERE, AND...] = where
    lines.push "WHERE " + WHERE
    AND.map (line) -> lines.push "  AND " + line

  # with
  if query.sort?.popular
    lines.push "WITH DISTINCT e as events, count(s) AS edges"
  else
    lines.push "WITH DISTINCT e as events"

  carry = ['events']
  if query.sort?.popular
    if query.sort?.time
      throw new Meteor.Error 21, "you can only sort by time or popular, not both"
    if query.filter?.time
      carry.push 'score'
      lines.push "WITH events, edges, (events.start_time - #{query.filter.time})/(1000*60*60) as dt"
      lines.push "WITH events, edges, dt, edges/(dt*1.0+1.0) + edges/6.0 as score"
    else
      throw new Meteor.Error 21, "you must provide a time for popular sorting"

  fields = ['events.id']
  if query.fields?.name
    fields.push 'events.name'

  if query.fields?.starCount
    lines.push "OPTIONAL MATCH (u:USER)-[s:STARS]->(events)"
    if query.sort?.popular
      lines.push "WITH #{carry.join(', ')}, count(s) as starCount"
    else
      lines.push "WITH #{carry.join(', ')}, count(s) as starCount"
    carry.push 'starCount'
    fields.push 'starCount'

  if userId = query.fields?.followedStarCount
    lines.push "OPTIONAL MATCH (:USER {id: #{str(userId)} })-[s:STARS]->(events)"
    lines.push "WITH #{carry.join(', ')}, count(s) as starred"
    carry.push 'starred'
    fields.push 'starred'

  if userId = query.fields?.starred
    lines.push "OPTIONAL MATCH (:USER {id: #{str(userId)} })-[:FOLLOWS]->(u:USER)-[s:STARS]->(events)"
    lines.push "WITH #{carry.join(', ')}, count(s) as followedStarCount"
    carry.push 'followedStarCount'
    fields.push 'followedStarCount'

  # sort and return
  if query.sort?.time
    lines.push "RETURN #{fields.join(', ')}"
    lines.push "ORDER BY events.start_time"
  else if query.sort?.popular
    lines.push "RETURN #{fields.join(', ')}"
    lines.push "ORDER BY score DESC"
  else
    lines.push "RETURN #{fields.join(', ')}"

  if skip = query.paging?.skip
    lines.push "SKIP #{str(skip)}"
  if limit = query.paging?.limit
    lines.push "LIMIT #{str(limit)}"

  return lines.join('\n')


console.log "\n* get a specific event"
console.log getEvents
  domain:
    id: '1442336736094604'

console.log "\n* get a specific event with all the fields"
console.log getEvents
  domain:
    id: '1442336736094604'
  fields:
    name: true
    starCount: true
    starred: '10205633768661272'
    followedStarCount: '10205633768661272'

console.log "\n* get a users' hosted/starred events"
console.log getEvents
  domain:
    user: '120761677934984'
  filter:
    time: Date.now()
    name: 'mcgraw'
    latlng: [37.3833, -122.0167]
  sort:
    time: true
  paging:
    limit: 20

console.log "\n* get a users' popular follow-network events (feed)"
console.log getEvents
  domain:
    feed: '10205633768661272'
  filter:
    time: Date.now()
  sort:
    popular: true
  paging:
    limit: 20

console.log "\n* get the most popular events"
console.log getEvents
  filter:
    time: Date.now()
  sort:
    popular: true
  paging:
    limit: 20
  fields:
    name: true
    starCount: true
    starred: '10205633768661272'
    followedStarCount: '10205633768661272'


console.log "\n* get any stale events that need to be synced"
console.log getEvents
  filter:
    stale: 1000*60*60 # 1hr

console.log "\n* get a user feed"
console.log getEvents
  domain:
    feed: '10205633768661272'
  filter:
    time: Date.now()
    latlng: [37.3833, -122.0167]
  sort:
    time: true
  paging:
    limit: 20


console.log "\n* get a user's popular feed"
console.log getEvents
  domain:
    feed: '10205633768661272'
  filter:
    time: Date.now()
    latlng: [37.3833, -122.0167]
  sort:
    popular: true
  paging:
    limit: 20

console.log "\n* the most complicated query"
console.log getEvents
  domain:
    feed: '10205633768661272'
  filter:
    time: Date.now()
    name: 'concert'
    latlng: [37.3833, -122.0167]
  sort:
    popular: true
  paging:
    limit: 20
  fields:
    name: true
    starCount: true
    starred: '10205633768661272'
    followedStarCount: '10205633768661272'

getUsers = (query) ->
  # userQuery =
  #   domain:
  #     id: userId # follows: userId, followers:userId, stargazers:eventId, followedStargazers: {userId, eventId}
  #   filter:
  #     name: 'joe'
  #     stale: ms
  #   sort:
  #     popular: true # name: true
  #   fields
  #     id: true
  #     name: true
  #     followCount: true
  #     followerCount: true
  #     followed: userId
  #   paging:
  #     limit: 10
  #     skip: 20

  lines = []

  # domain
  if id = query.domain?.id
    lines.push "MATCH (u:USER {id: #{str(id)} })"
  else if id = query.domain?.follows
    lines.push "MATCH (:USER {id: #{str(id)} })-[:FOLLOWS]->(u:USER)"
  else if id = query.domain?.followers
    lines.push "MATCH (u:USER)-[:FOLLOWS]->(:USER {id: #{str(id)} })"
  else if eventId = query.domain?.stargazers
    lines.push "MATCH (u:USER)-[s:STARS]->(:EVENT {id: #{str(eventId)} })"
  else if params = query.domain?.followedStargazers
    {userId, eventId} = params
    lines.push "MATCH (:USER {id: #{str(userId)} })-[:FOLLOWS]->(u:USER)-[s:STARS]->(e:EVENT {id: #{str(eventId)} })"
  else
    lines.push "MATCH (u:USER)"

  # filters
  where = []
  if name = query.filter?.name
    where.push "u.name =~ #{regex(name)}"
  if dt = query.filter?.stale
    where.push "NOT has(u.lastSync) OR u.lastSync < timestamp()-#{str(dt)}"
  if where.length > 0
    [WHERE, AND...] = where
    lines.push "WHERE " + WHERE
    AND.map (line) -> lines.push "  AND " + line

  # with
  lines.push "WITH DISTINCT u as users"

  # sort and fields
  carry = ['users']
  fields = ['users.id']
  if query.fields?.name
    fields.push 'users.name'
  if query.sort?.popular or query.fields?.followerCount
    lines.push "OPTIONAL MATCH (:USER)-[f:FOLLOWS]->(users)"
    lines.push "WITH #{carry.join(', ')}, count(f) as followerCount"
    carry.push "followerCount"
  if query.fields?.followerCount
    fields.push ['followerCount']
  if query.fields?.followCount
    lines.push "OPTIONAL MATCH (users)-[f:FOLLOWS]->(:USER)"
    lines.push "WITH #{carry.join(', ')}, count(f) as followCount"
    carry.push "followCount"
    fields.push "followCount"
  if userId = query.fields?.followed
    lines.push "OPTIONAL MATCH (:USER {id: #{str(userId)} })-[f:FOLLOWS]->(users)"
    lines.push "WITH #{carry.join(', ')}, count(f) as followed"
    carry.push "followed"
    fields.push "followed"

  # sort and return
  if query.sort?.name
    lines.push "RETURN #{fields.join(', ')}"
    lines.push "ORDER BY users.name"
  else if query.sort?.popular
    lines.push "RETURN #{fields.join(', ')}"
    lines.push "ORDER BY followerCount DESC"
  else
    lines.push "RETURN #{fields.join(', ')}"

  if skip = query.paging?.skip
    lines.push "SKIP #{str(skip)}"
  if limit = query.paging?.limit
    lines.push "LIMIT #{str(limit)}"


  return lines.join('\n')


console.log "\n* get a specific user with fields"
console.log getUsers
  domain:
    id: '162023233843050'
  fields:
    name: true
    followCount: true
    followerCount: true
    followed: '10205633768661272'

console.log "\n* get a specific users by name"
console.log getUsers
  domain:
    id: '162023233843050'
  filter:
    name: 'chet'
  sort:
    name: true
  fields:
    name: true


console.log "\n* get a the most popular users"
console.log getUsers
  sort:
    popular: true
  fields:
    name: true
  paging:
    limit: 10

console.log "\n* get a user's followers"
console.log getUsers
  domain:
    followers: '162023233843050'
  sort:
    popular: true
  fields:
    name: true
    followCount: true
    followerCount: true
    followed: '10205633768661272'
  paging:
    limit: 10

console.log "\n* get a user's follows"
console.log getUsers
  domain:
    follows: '10205633768661272'
  sort:
    name: true
  filter:
    name: 'bimbo'
  fields:
    name: true
    followCount: true
    followerCount: true
    followed: '10205633768661272'
  paging:
    limit: 10
    skip: 0


console.log "\n* get an events stargazers"
console.log getUsers
  domain:
    stargazers: '832210133540886'
  sort:
    popular: true
  filter:
    name: 'chet'
  fields:
    name: true

console.log "\n* get an events followed stargazers"
console.log getUsers
  domain:
    followedStargazers:
      eventId: '832210133540886'
      userId: '10205633768661272'
  sort:
    popular: true
  fields:
    name: true


console.log "\n* get stale users that need to sync"
console.log getUsers
  filter:
    stale: true
  paging:
    limit: 100


console.log "\n* the most complicated query"
console.log getUsers
  domain:
    followedStargazers:
      eventId: '832210133540886'
      userId: '10205633768661272'
  filter:
    name: 'joe'
  sort:
    popular: true
  fields:
    name: true
    followCount: true
    followerCount: true
    followed: '10205633768661272'
  paging:
    limit: 10
    skip: 20

###

setUser(id,name, lastSync)
setEvent(id, name, start_time, end_time, lat, lng, lastSync)
setUserSession(id, start_time, end_time)
setFollow(userId, followId)
setUnfollow(userId, unfollowId)
setStar(userId, eventId)
setUnstar(userId, eventId)

###

setUser = (id, name, lastSync) ->
  fields = {name, lastSync}
  """
  MERGE (u:USER {id:#{str(id)}})
  SET u += #{str(fields)}
  """

console.log "\n* set a user"
console.log setUser('1234', 'Joe Schmo', 1234)

setEvent = (id, name, start_time, end_time, lat, lng, hostIds, lastSync) ->
  fields = {name, start_time, end_time, lat, lng, lastSync}
  """
  MERGE (e:EVENT {id: #{str(id)}})
  SET e += #{str(fields)}
  WITH #{str(hostIds)} AS hostIds, e
  OPTIONAL MATCH (u:USER)-[r:HOSTS]->(e)
  WHERE NOT u.id IN hostIds
  DELETE r
  WITH COLLECT(u.id) AS oldHostIds, hostIds, e
  WITH FILTER(id IN hostIds WHERE NOT id IN oldHostIds) AS newHostIds, e, oldHostIds
  FOREACH (hostId IN newHostIds |
      MERGE (host:USER {id:hostId})
      MERGE (host)-[:HOSTS]->(e)
  )
  """

console.log "\n* set a event"
console.log setEvent('1235', 'party at chets place', 1234, 2234, 0, 1, ['1222', '2222'], 1234)

setSession = (userId, start_time, end_time) ->
  """
  MERGE (u:USER {id:#{str(userId)}})
  CREATE (s:SESSION {start_time:#{str(start_time)}, end_time:#{str(end_time)}})
  MERGE (u)-[:LOGGED_IN]->(s)
  """

console.log "\n* set a session"
console.log setSession('1235', 2345, 3456)

setFollow = (userId, followId) ->
  """
  MERGE (u:USER {id:#{str(userId)}})
  MERGE (f:USER {id:#{str(followId)}})
  MERGE (u)-[:FOLLOWS {createdAt:timestamp()}]->(f)
  """

console.log "\n* set a follow"
console.log setFollow('1235', '2345')

setUnfollow = (userId, unfollowId) ->
  """
  MATCH (:USER {id:#{str(userId)}})-[r:FOLLOWS]->(:USER {id:#{str(unfollowId)}})
  DELETE r
  """

console.log "\n* set an unfollow"
console.log setUnfollow('1235', '2345')


setStar = (userId, eventId) ->
  """
  MERGE (u:USER {id:#{str(userId)}})
  MERGE (e:EVENT {id:#{str(eventId)}})
  MERGE (u)-[:STARS {createdAt:timestamp()}]->(e)
  """

console.log "\n* set a star"
console.log setStar('1235', '2345')


setUnstar = (userId, eventId) ->
  """
  MATCH (:USER {id:#{str(userId)}})-[r:STARS]->(:EVENT {id:#{str(eventId)}})
  DELETE r
  """

console.log "\n* set an unstar"
console.log setUnstar('1235', '2345')

# dispatch setFollow: {userId, followId}
# dispatch setUnfollow: {userId, followId}
# dispatch setStar: {userId, eventId}
# dispatch setUnstar: {userId, eventId}

cypher = {
  getUsers
  getEvents
  setUser
  setEvent
  setSession
  setFollow
  setUnfollow
  setStar
  setUnstar
}
