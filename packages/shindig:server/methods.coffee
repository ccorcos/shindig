debug = (->)
if Meteor.settings.public?.log?.methods
  debug = console.log.bind(console, 'method')

truthy = Match.Where (b) -> b?

Meteor.methods
  follow: (followId) ->
    check(followId, String)
    check(@userId, truthy)
    userId = facebook.lookupFbId(@userId)
    debug 'follow', userId, '->', followId
    if Meteor.isServer
      Neo4j.setFollow(userId, followId)
    this.unblock()
    Update.follow(userId, followId)

  unfollow: (followId) ->
    check(followId, String)
    check(@userId, truthy)
    userId = facebook.lookupFbId(@userId)
    debug 'unfollow', userId, '-x', followId
    if Meteor.isServer
      Neo4j.setUnfollow(userId, followId)
    this.unblock()
    Update.unfollow(userId, followId)

  star: (eventId) ->
    check(eventId, String)
    check(@userId, truthy)
    userId = facebook.lookupFbId(@userId)
    check(userId, truthy)
    debug 'star', userId, '->', eventId
    if Meteor.isServer
      Neo4j.setStar(userId, eventId)
    this.unblock()
    Update.star(userId, eventId)

  unstar: (eventId) ->
    check(eventId, String)
    check(@userId, truthy)
    userId = facebook.lookupFbId(@userId)
    check(userId, truthy)
    debug 'unstar', userId, '-x', eventId
    if Meteor.isServer
      Neo4j.setUnstar(userId, eventId)
    this.unblock()
    Update.unstar(userId, eventId)
