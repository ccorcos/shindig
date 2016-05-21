# ResponseTimes = {}
#
# pushOverflow = (item, list, n) ->
#   list.unshift(item)
#   while list.length > n
#     list.pop()

#
# mapObj Shindig.db, (name, fetch) ->
#   ResponseTimes[name] = []
#   Shindig.db[name] = ->
#     lap = stopwatch()
#     result = fetch.apply(null, arguments)
#     pushOverflow(lap(), ResponseTimes[name], 20)
#     return result
#
# @dbInfo = ->
#   size =
#     users: first Neo4j.query("MATCH (u:USER) RETURN count(u)")
#     events: first Neo4j.query("MATCH (e:EVENT) RETURN count(e)")
#     follows: first Neo4j.query("MATCH (:USER)-[f:FOLLOWS]->(:USER) RETURN count(f)")
#     hosts: first Neo4j.query("MATCH (:USER)-[h:HOSTS]->(:EVENT) RETURN count(h)")
#     stars: first Neo4j.query("MATCH (:USER)-[s:STARS]->(:EVENT) RETURN count(s)")
#   response = mapObj ResponseTimes, (k,v) -> R.mean(v)
#   return {size, response}


# Shindig.info.dbSize
# Shindig.speedTest.getUser()

avgTime = (n, func) ->
  R.mean [0...n].map ->
    lap = U.stopwatch()
    func()
    lap()

N = 10

time = Date.now()
latlng = [ 33.845439, -118.379374]
search = 're'
limit = 10
dt = 1000*60*60*4

permuteEventSearch = (getDomain) ->
  time: avgTime N, ->
    Neo4j.getEvents R.merge {domain: getDomain()},
      filter:
        time: time
      sort:
        time: true
      paging:
        limit: limit
  timePlace: avgTime N, ->
    Neo4j.getEvents R.merge {domain: getDomain()},
      filter:
        time: time
        latlng: latlng
      sort:
        time: true
      paging:
        limit: limit
  timeName: avgTime N, ->
    Neo4j.getEvents R.merge {domain: getDomain()},
      filter:
        time: time
        name: search
      sort:
        time: true
      paging:
        limit: limit
  timeNamePlace: avgTime N, ->
    Neo4j.getEvents R.merge {domain: getDomain()},
      filter:
        time: time
        latlng: latlng
        name: search
      sort:
        time: true
      paging:
        limit: limit
  popular: avgTime N, ->
    Neo4j.getEvents R.merge {domain: getDomain()},
      filter:
        time: time
      sort:
        popular: true
      paging:
        limit: limit
  popularPlace: avgTime N, ->
    Neo4j.getEvents R.merge {domain: getDomain()},
      filter:
        time: time
        latlng: latlng
      sort:
        popular: true
      paging:
        limit: limit
  popularName: avgTime N, ->
    Neo4j.getEvents R.merge {domain: getDomain()},
      filter:
        time: time
        name: search
      sort:
        popular: true
      paging:
        limit: limit
  popularNamePlace: avgTime N, ->
    Neo4j.getEvents R.merge {domain: getDomain()},
      filter:
        time: time
        name: search
        latlng: latlng
      sort:
        popular: true
      paging:
        limit: limit

permuseUserSearch = (getDomain) ->
  all: avgTime N, ->
    Neo4j.getUsers R.merge {domain: getDomain()},
      paging:
        limit: limit
  popular: avgTime N, ->
    Neo4j.getUsers R.merge {domain: getDomain()},
      paging:
        limit: limit
      sort:
        popular: true
  name: avgTime N, ->
    Neo4j.getUsers R.merge {domain: getDomain()},
      paging:
        limit: limit
      filter:
        name: search
  namePopular: avgTime N, ->
    Neo4j.getUsers R.merge {domain: getDomain()},
      paging:
        limit: limit
      filter:
        name: search
      sort:
        popular: true

Neo4j.speedTests = {}
Neo4j.speedTests.getEvents = ->
  userIds = Neo4j.query "MATCH (u:USER) RETURN u.id ORDER BY size(()-->(u)) DESC LIMIT 20"
  randomUserId = -> Random.choice(userIds)
  eventIds = Neo4j.query "MATCH (e:EVENT) RETURN e.id ORDER BY size(()-->(e)) DESC LIMIT 20"
  randomEventId = -> Random.choice(eventIds)

  id:
    id: avgTime N, ->
      Neo4j.getEvents
        domain:
          id: randomEventId()
    starCount: avgTime N, ->
      Neo4j.getEvents
        domain:
          id: randomEventId()
        fields:
          starCount: true
    starred: avgTime N, ->
      fbId = randomUserId()
      Neo4j.getEvents
        domain:
          id: randomEventId()
        fields:
          starred: fbId
    followedStarCount: avgTime N, ->
      fbId = randomUserId()
      Neo4j.getEvents
        domain:
          id: randomEventId()
        fields:
          followedStarCount: fbId
    allFields: avgTime N, ->
      fbId = randomUserId()
      Neo4j.getEvents
        domain:
          id: randomEventId()
        fields:
          starCount: true
          starred: fbId
          followedStarCount: fbId
  feed: permuteEventSearch -> feed: randomUserId()
  user: permuteEventSearch -> user: randomUserId()
  all: permuteEventSearch -> {}
  stale: avgTime N, ->
    Neo4j.getEvents
      filter:
        stale: dt

Neo4j.speedTests.getUsers = ->
  userIds = Neo4j.query "MATCH (u:USER) RETURN u.id ORDER BY size(()-->(u)) DESC LIMIT 20"
  randomUserId = -> Random.choice(userIds)
  eventIds = Neo4j.query "MATCH (e:EVENT) RETURN e.id ORDER BY size(()-->(e)) DESC LIMIT 20"
  randomEventId = -> Random.choice(eventIds)

  time = Date.now()
  latlng = [ 33.845439, -118.379374]
  search = 're'
  limit = 10

  id:
    id: avgTime N, ->
      Neo4j.getUsers
        domain:
          id: randomUserId()
    followCount: avgTime N, ->
      Neo4j.getUsers
        domain:
          id: randomUserId()
        fields:
          followCount: true
    followerCount: avgTime N, ->
      Neo4j.getUsers
        domain:
          id: randomUserId()
        fields:
          followerCount: true
    followed: avgTime N, ->
      Neo4j.getUsers
        domain:
          id: randomUserId()
        fields:
          followed: randomUserId()
    allFields: avgTime N, ->
      Neo4j.getUsers
        domain:
          id: randomUserId()
        fields:
          followCount: true
          followerCount: true
          followed: randomUserId()
  all: permuseUserSearch -> {}
  follows: permuseUserSearch -> {follows: randomUserId()}
  followers: permuseUserSearch -> {followers: randomUserId()}
  stargazers: permuseUserSearch -> {stargazers: randomEventId()}
  followedStargazers: permuseUserSearch -> {followedStargazers: {fbId: randomUserId(), eventId: randomEventId()}}
  stale: avgTime N, ->
    Neo4j.getUsers
      filter:
        stale: dt

Neo4j.speedTests.stats = ->
  getSessionsPerHour: avgTime N, Neo4j.getSessionsPerHour
  getStarsPerHour: avgTime N, Neo4j.getStarsPerHour
  getFollowsPerHour: avgTime N, Neo4j.getFollowsPerHour
  
Neo4j.benchmark = ->
  R.mapObj(R.call, Neo4j.speedTests)

#   userExists: [Function],
#   eventExists: [Function],
#   setUser: [Function],
#   setEvent: [Function],
#   setSession: [Function],
#   setFollow: [Function],
#   setUnfollow: [Function],
#   setStar: [Function],
#   setUnstar: [Function] }
