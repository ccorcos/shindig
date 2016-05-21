###
REMEMBER: (:USER)-[:FOLLOWS]->(:USER)-[:HOSTS|STARS]->(:EVENT)
MATCH (u:USER)-[f:FOLLOWS]->(p:USER)-[s:HOSTS|STARS]->(e:EVENT) RETURN *
###

Neo4j.queries = {}

RADIUS = 0.4

fieldOrder = (fieldObj={}, fields=[]) ->
  keys = []
  for field in fields
    if field of fieldObj
      keys.push field
  return keys

Neo4j.queries.getEvents = (query) ->
  # query =
  #   domain:
  #     id: eventId  # user: userId, feed: userId
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
  #     lastSync: true
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
    lines.push "MATCH (e:EVENT {id: #{S.str(id)} })"
  else if id = query.domain?.user
    lines.push "MATCH (:USER {id: #{S.str(id)} })-[s:HOSTS|STARS]->(e:EVENT)"
  else if id = query.domain?.feed
    lines.push "MATCH (:USER {id: #{S.str(id)} })-[:FOLLOWS]->(:USER)-[s:HOSTS|STARS]->(e:EVENT)"
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
    where.push "e.name =~ #{S.regex(name)}"
  if latlng = query.filter?.latlng
    [lat, lng] = latlng
    where.push "e.latitude < #{S.str(lat+RADIUS)}"
    where.push "e.latitude > #{S.str(lat-RADIUS)}"
    where.push "e.longitude < #{S.str(lng+RADIUS)}"
    where.push "e.longitude > #{S.str(lng-RADIUS)}"
  if dt = query.filter?.stale
    where.push "NOT has(e.lastSync) OR e.lastSync < timestamp()-#{S.str(dt)}"

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
      lines.push "WITH events, edges, dt, edges*edges/(dt*2.0+1.0) as score"
    else
      throw new Meteor.Error 21, "you must provide a time for popular sorting"

  fields = ['events.id']
  if query.fields?.name
    fields.push 'events.name'
  if query.fields?.lastSync
    fields.push 'events.lastSync'

  if query.fields?.starCount
    lines.push "OPTIONAL MATCH (u:USER)-[s:STARS]->(events)"
    if query.sort?.popular
      lines.push "WITH #{carry.join(', ')}, count(s) as starCount"
    else
      lines.push "WITH #{carry.join(', ')}, count(s) as starCount"
    carry.push 'starCount'
    fields.push 'starCount'

  if userId = query.fields?.followedStarCount
    lines.push "OPTIONAL MATCH (:USER {id: #{S.str(userId)} })-[:FOLLOWS]->(u:USER)-[s:STARS]->(events)"
    lines.push "WITH #{carry.join(', ')}, count(s) as followedStarCount"
    carry.push 'followedStarCount'
    fields.push 'followedStarCount'

  if userId = query.fields?.starred
    lines.push "OPTIONAL MATCH (:USER {id: #{S.str(userId)} })-[s:STARS]->(events)"
    lines.push "WITH #{carry.join(', ')}, count(s)>0 as starred"
    carry.push 'starred'
    fields.push 'starred'

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
    lines.push "SKIP #{S.str(skip)}"
  if limit = query.paging?.limit
    lines.push "LIMIT #{S.str(limit)}"

  return lines.join('\n')

Neo4j.getEvents = (query) ->
  fields = fieldOrder(query.fields, [
    'name',
    'lastSync',
    'starCount',
    'followedStarCount',
    'starred'
  ])
  keys = ['_id'].concat(fields)
  Neo4j.zip(keys, Neo4j.query(Neo4j.queries.getEvents(query)))

Neo4j.queries.getUsers = (query) ->
  # userQuery =
  #   domain:
  #     id: userId # follows: userId, followers:userId, stargazers:eventId, followedStargazers: {fbId, eventId}
  #   filter:
  #     name: 'joe'
  #     stale: ms
  #   sort:
  #     popular: true # name: true
  #   fields
  #     id: true
  #     name: true
  #     lastSync: true
  #     followCount: true
  #     followerCount: true
  #     followed: userId
  #   paging:
  #     limit: 10
  #     skip: 20

  lines = []

  # domain
  if id = query.domain?.id
    lines.push "MATCH (u:USER {id: #{S.str(id)} })"
  else if id = query.domain?.follows
    lines.push "MATCH (:USER {id: #{S.str(id)} })-[:FOLLOWS]->(u:USER)"
  else if id = query.domain?.followers
    lines.push "MATCH (u:USER)-[:FOLLOWS]->(:USER {id: #{S.str(id)} })"
  else if eventId = query.domain?.stargazers
    lines.push "MATCH (u:USER)-[s:STARS]->(:EVENT {id: #{S.str(eventId)} })"
  else if params = query.domain?.followedStargazers
    {fbId, eventId} = params
    lines.push "MATCH (:USER {id: #{S.str(fbId)} })-[:FOLLOWS]->(u:USER)-[s:STARS]->(e:EVENT {id: #{S.str(eventId)} })"
  else
    lines.push "MATCH (u:USER)"

  # filters
  where = []
  if name = query.filter?.name
    where.push "u.name =~ #{S.regex(name)}"
  if dt = query.filter?.stale
    where.push "NOT has(u.lastSync) OR u.lastSync < timestamp()-#{S.str(dt)}"
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
  if query.fields?.lastSync
    fields.push 'users.lastSync'
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
    lines.push "OPTIONAL MATCH (:USER {id: #{S.str(userId)} })-[f:FOLLOWS]->(users)"
    lines.push "WITH #{carry.join(', ')}, count(f)>0 as followed"
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
    lines.push "SKIP #{S.str(skip)}"
  if limit = query.paging?.limit
    lines.push "LIMIT #{S.str(limit)}"

  return lines.join('\n')

Neo4j.queries.userExists = (id) ->
  """
  MATCH (u:USER {id:#{S.str(id)}})
  RETURN u.id
  """
Neo4j.userExists = (id) ->
  Neo4j.query(Neo4j.queries.userExists(id)).length > 0

Neo4j.userHasBeenCrawled = (id) ->
  if user = Neo4j.getUsers({domain:{id}, fields:{lastSync:true}})?[0]
    if user.lastSync > 0
      return true
    else
      return false
  else
    Crawl.makeUser(id)
    return false


Neo4j.queries.eventExists = (id) ->
  """
  MATCH (e:EVENT {id:#{S.str(id)}})
  RETURN e.id
  """
Neo4j.eventExists = (id) ->
  Neo4j.query(Neo4j.queries.eventExists(id)).length > 0

Neo4j.getUsers = (query) ->
  fields = fieldOrder(query.fields, [
    'name',
    'lastSync',
    'followerCount',
    'followCount',
    'followed',
  ])
  keys = ['_id'].concat(fields)
  Neo4j.zip(keys, Neo4j.query(Neo4j.queries.getUsers(query)))

Neo4j.defineQuery 'setUser', (query) ->
  {id} = query
  fields = R.pick ['name', 'lastSync'], query
  """
  MERGE (u:USER {id:#{S.str(id)}})
  SET u += #{S.str(fields)}
  """

Neo4j.defineQuery 'setEvent', (query) ->
  {id, hostIds} = query
  fields = R.pick ['name', 'start_time', 'end_time', 'latitude', 'longitude', 'lastSync'], query
  """
  MERGE (e:EVENT {id: #{S.str(id)}})
  SET e += #{S.str(fields)}
  WITH #{S.str(hostIds)} AS hostIds, e
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

Neo4j.defineQuery 'setSession', (userId, start_time, end_time) ->
  """
  MERGE (u:USER {id:#{S.str(userId)}})
  CREATE (s:SESSION {start_time:#{S.str(start_time)}, end_time:#{S.str(end_time)}})
  MERGE (u)-[:LOGGED_IN]->(s)
  """

Neo4j.defineQuery 'setFollow', (userId, followId) ->
  """
  MERGE (u:USER {id:#{S.str(userId)}})
  MERGE (f:USER {id:#{S.str(followId)}})
  MERGE (u)-[r:FOLLOWS]->(f)
  ON CREATE SET r.createdAt=timestamp()
  """

Neo4j.defineQuery 'setUnfollow', (userId, unfollowId) ->
  """
  MATCH (:USER {id:#{S.str(userId)}})-[r:FOLLOWS]->(:USER {id:#{S.str(unfollowId)}})
  DELETE r
  """

Neo4j.defineQuery 'setStar', (userId, eventId) ->
  """
  MERGE (u:USER {id:#{S.str(userId)}})
  MERGE (e:EVENT {id:#{S.str(eventId)}})
  MERGE (u)-[s:STARS]->(e)
  ON CREATE SET s.createdAt=timestamp()
  """

Neo4j.defineQuery 'setUnstar', (userId, eventId) ->
  """
  MATCH (:USER {id:#{S.str(userId)}})-[r:STARS]->(:EVENT {id:#{S.str(eventId)}})
  DELETE r
  """

Neo4j.defineQuery 'deleteUser', (userId) ->
  """
  MATCH (u:USER {id:#{S.str(userId)}})
  OPTIONAL MATCH (u)-[:HOSTS]->(e:EVENT)
  OPTIONAL MATCH (u)-[h]-()
  OPTIONAL MATCH (e)-[r]-()
  DELETE u,e,r,h
  """

Neo4j.defineQuery "cleanUp",  ->
  """
  MATCH (x)
  WHERE size((x)--())=0
  DELETE x
  """

























timeFill = (begin, end, step, data=[]) ->
  check(begin, Number)
  check(end, Number)
  check(step, Number)
  if end < begin
    return data
  data = R.clone(data)
  if data.length is 0
    t = begin
    while t <= end
      data.push [t, 0]
      t += step
    return data
  t = data[0][0]
  # back fill data
  while true
    t -= step
    if t > begin
      data.unshift([t, 0])
    else
      break
  # forward fill
  i = 0
  t = data[i][0]
  while t <= end
    i++
    t += step
    if data[i]?[0] > t or data.length <= i
      data.splice(i,0,[t,0])
  return data


# 1 hour step for 3 days
STEP = 1000*60*60
RANGE = 1000*60*60*24*3

Neo4j.queries.getSessionsPerHour = (begin, end, step) ->
  """
  WITH #{S.str(begin)} AS begin,
       #{S.str(end)} AS end,
       #{step} as step
  MATCH (n:SESSION)
  WHERE n.start_time > begin
    AND n.start_time < end
  WITH round(n.start_time / step) as time, count(*) as n, step
  RETURN time*step, n
  ORDER by time
  """

Neo4j.getSessionsPerHour = ->
  end = U.timestamp()
  begin = end - RANGE
  result = Neo4j.query(Neo4j.queries.getSessionsPerHour(begin, end, STEP))
  timeFill(begin, end, STEP, result)

Neo4j.queries.getStarsPerHour = (begin, end, step) ->
  """
    WITH #{S.str(begin)} AS begin,
         #{S.str(end)} AS end,
         #{STEP} as step
    START r=rel(*)
    WHERE type(r) = "STARS"
      AND r.createdAt > begin
      AND r.createdAt < end
    WITH round(r.createdAt / step) as time, count(*) as n, step
    RETURN time*step, n
    ORDER by time
  """

Neo4j.getStarsPerHour = ->
  end = U.timestamp()
  begin = end - RANGE
  result = Neo4j.query(Neo4j.queries.getStarsPerHour(begin, end, STEP))
  timeFill(begin, end, STEP, result)

Neo4j.queries.getFollowsPerHour = (begin, end, step) ->
  """
    WITH #{S.str(begin)} AS begin,
         #{S.str(end)} AS end,
         #{STEP} as step
    START r=rel(*)
    WHERE type(r) = "FOLLOWS"
      AND r.createdAt > begin
      AND r.createdAt < end
    WITH round(r.createdAt / step) as time, count(*) as n, step
    RETURN time*step, n
    ORDER by time
  """

Neo4j.getFollowsPerHour = ->
  end = U.timestamp()
  begin = end - RANGE
  result = Neo4j.query(Neo4j.queries.getFollowsPerHour(begin, end, STEP))
  timeFill(begin, end, STEP, result)
