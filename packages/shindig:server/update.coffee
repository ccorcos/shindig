refreshFollow = (fbId, followId)->
  AnyDb.refresh 'users', R.converge(R.or,
    R.pathEq(['domain', 'followers'], followId)
    R.pathEq(['domain', 'follows'], fbId)
  )
  AnyDb.refresh 'events', R.pathEq(['domain', 'feed'], fbId)
  AnyDb.refresh 'user', R.converge(R.or,
    R.propEq('userId', followId)
    R.propEq('userId', fbId)
  )

updateFollow = (fbId, followId) ->
  Shindig.user.update(
    R.converge(R.and,
      R.propEq('userId', followId)
      R.propEq('fbId', fbId)
    )
    U.updateWhere(
      R.propEq('_id', followId)
      R.evolve({followerCount: R.inc, followed: R.T, unverified: R.T})
    )
  )
  Shindig.user.update(
    R.pathEq('userId', fbId)
    U.updateWhere(
      R.propEq('_id', fbId)
      R.evolve({followCount: R.inc, unverified: R.T})
    )
  )

updateUnfollow = (fbId, followId) ->
  Shindig.user.update(
    R.converge(R.and,
      R.propEq('userId', followId)
      R.propEq('fbId', fbId)
    )
    U.updateWhere(
      R.propEq('_id', followId)
      R.evolve({followerCount: R.dec, followed: R.F, unverified: R.T})
    )
  )
  Shindig.user.update(
    R.pathEq('userId', fbId)
    U.updateWhere(
      R.propEq('_id', fbId)
      R.evolve({followCount: R.dec, unverified: R.T})
    )
  )
  Shindig.users.update(
    R.pathEq(['domain', 'followers'], followId)
    R.reject(R.propEq('_id', fbId))
  )
  Shindig.users.update(
    R.pathEq(['domain', 'follows'], fbId)
    R.reject(R.propEq('_id', followId))
  )

Update.follow = (fbId, followId) ->
  if Meteor.isServer
    refreshFollow(fbId, followId)
  if Meteor.isClient
    updateFollow(fbId, followId)

Update.unfollow = (fbId, followId) ->
  if Meteor.isServer
    refreshFollow(fbId, followId)
  if Meteor.isClient
    updateUnfollow(fbId, followId)

refreshStar = (fbId, eventId)->
  # AnyDb.refresh 'events', R.pathEq(['domain', 'feed'], fbId)
  AnyDb.refresh 'events', R.pathEq(['domain', 'user'], fbId)
  AnyDb.refresh 'users', R.pathEq(['domain', 'stargazers'], eventId)
  AnyDb.refresh 'event', R.propEq('eventId', eventId)
  # get this users followers, update followed starcount for this event.

updateStar = (fbId, eventId) ->
  Shindig.event.update(
    R.converge(R.and,
      R.propEq('eventId', eventId)
      R.propEq('fbId', fbId)
    )
    U.updateWhere(
      R.propEq('_id', eventId)
      R.evolve({starCount: R.inc, starred: R.T, unverified: R.T})
    )
  )

updateUnstar = (fbId, eventId) ->
  Shindig.event.update(
    R.converge(R.and,
      R.propEq('eventId', eventId)
      R.propEq('fbId', fbId)
    )
    U.updateWhere(
      R.propEq('_id', eventId)
      R.evolve({starCount: R.dec, starred: R.F, unverified: R.T})
    )
  )
  Shindig.events.update(
    R.pathEq(['domain', 'stargazers'], eventId)
    R.reject(R.propEq('_id', fbId))
  )

Update.star = (fbId, eventId) ->
  if Meteor.isServer
    refreshStar(fbId, eventId)
  if Meteor.isClient
    updateStar(fbId, eventId)

Update.unstar = (fbId, eventId) ->
  if Meteor.isServer
    refreshStar(fbId, eventId)
  if Meteor.isClient
    updateUnstar(fbId, eventId)


Update.userEvents = (userId) ->
  if Meteor.isServer
    AnyDb.refresh 'events', R.pathEq(['domain', 'user'], userId)
