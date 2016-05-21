###
All publications have one argument thats an object!
###

AnyDb.publish 'events', (query) ->
  # query =
  #   domain:
  #     user: userId, feed: userId
  #   filter:
  #     time: ms
  #     name: 'party'
  #     latlng: [lat, lng]
  #   sort:
  #     time: true # popular: false
  #   paging:
  #     limit: 10
  #     skip: 20
  check query,
    domain: Match.Optional Match.OneOf(
      {user: String}
      {feed: String}
    )
    filter: Match.Optional
      time: Match.Optional Number
      name: Match.Optional String
      latlng: Match.Optional [Number]
    sort: Match.Optional Match.OneOf(
      {popular: Boolean}
      {time: Boolean}
    )
    fbId: String
    paging:
      limit: Number
      skip: Number
  query = R.clone(query)
  query.paging.limit += query.paging.skip
  delete query.paging.skip
  query.fields =
    starCount: true
    starred: query.fbId
    followedStarCount: query.fbId

  Meteor.defer ->
    if query.domain?.user and not Neo4j.userHasBeenCrawled(query.domain?.user)
      Crawl.userEvents(query.domain.user)
  Neo4j.getEvents(query)

AnyDb.publish 'event', ({eventId, fbId}) ->
  check eventId, String
  check fbId, String
  query =
    domain:
      id: eventId
    fields:
      starCount: true
      starred: fbId
      followedStarCount: fbId
  # need to crawl if the event doenst exist
  if Neo4j.eventExists(eventId)
    Neo4j.getEvents(query)
  else
    Crawl.event(eventId)
    Neo4j.getEvents(query)

AnyDb.publish 'users', (query) ->
  # userQuery =
  #   domain:
  #     follows: userId, followers:userId, stargazers:eventId, followedStargazers: {userId, eventId}
  #   filter:
  #     name: 'joe'
  #   sort:
  #     popular: true # name: true
  #   paging:
  #     limit: 10
  #     skip: 20

  check query,
    domain: Match.Optional Match.OneOf(
      {follows: String}
      {followers: String}
      {stargazers: String}
      {followedStargazers: {fbId:String, eventId:String}}
    )
    filter: Match.Optional
      name: Match.Optional String
    sort: Match.Optional Match.OneOf(
      {popular: Boolean}
      {name: Boolean}
    )
    fbId: String
    paging:
      limit: Number
      skip: Number
  query = R.clone(query)
  query.paging.limit += query.paging.skip
  delete query.paging.skip
  query.fields =
    followCount: true
    followerCount: true
    followed: query.fbId
    lastSync: true
  Neo4j.getUsers(query)

AnyDb.publish 'user', ({userId, fbId}) ->
  query =
    domain:
      id: userId
    fields:
      followCount: true
      followerCount: true
      followed: fbId
      lastSync: true
  # need to crawl if the user doenst exist
  users = Neo4j.getUsers(query)
  if users.length
    return users
  else
    Meteor.defer ->
      Crawl.makeUser(userId)
    return [{id: userId, followCount: 0, followerCount: 0, followed: false, lastSync: -1}]
