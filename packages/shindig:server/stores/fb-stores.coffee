
transformUserResult = (result) ->
  name: result.name
  id: result.id
  img: result.picture.data.url

fetchFriends = (limit, offset, done) ->
  facebook.api 'get', "/me/friends", {
    fields: 'name,picture{url}'
    limit: limit
    offset: offset
  }, U.throwIfErr(done)

searchUsers = (query, limit, offset, done) ->
  facebook.api 'get', "/search", {
    fields: 'name,picture{url}'
    type: 'user'
    q: query
    limit: limit
    offset: offset
  }, U.throwIfErr(done)

fetchLikes = (limit, offset, done) ->
  facebook.api 'get', "/me/likes", {
    fields: 'name,picture{url}'
    limit: limit
    offset: offset
  }, U.throwIfErr(done)

searchPages = (query, limit, offset, done) ->
  facebook.api 'get', "/search", {
    fields: 'name,picture{url}'
    type: 'page'
    q: query
    limit: limit
    offset: offset
  }, U.throwIfErr(done)

fetchName = (userId, done) ->
  facebook.api 'get', "/#{userId}", {
    fields: 'id,name'
  }, U.throwIfErr ({id, name}) -> done({id, name})

fetchLargePic = (userId, done) ->
  facebook.api 'get', "/#{userId}/picture", {
    type: 'large'
    fields:'url'
    redirect: false
  }, U.throwIfErr ({data}) -> done({img: data.url})

eventDetailFields= [
  'id'
  'name'
  'description'
  'start_time'
  'end_time'
  'timezone'
  'cover'
  'ticket_uri'
  'place'
  'owner'
  'admins{id,name}'
].join(',')

fetchEvent = (eventId, callback) ->
  facebook.api 'get', "/#{eventId}", {fields:eventDetailFields}, U.throwIfErr (event) ->
    event.hosts = S.getHosts(event)
    delete event.admins
    delete event.owner
    callback(event)

UserOptions =
  limit: Meteor.settings.public?.user_list_paging_limit
  minutes: Meteor.settings.public?.http_cache_minutes

facebook.users = AnyStore.createHTTPListStore 'facebook.users', UserOptions, ({query, paging:{limit, skip}}, callback) ->
  done = ({data}) -> callback(data.map(transformUserResult))
  if query
    searchUsers(query, limit, skip, done)
  else
    fetchFriends(limit, skip, done)

facebook.pages = AnyStore.createHTTPListStore 'facebook.pages', UserOptions, ({query, paging:{limit, skip}}, callback) ->
    done = ({data}) -> callback(data.map(transformUserResult))
    if query
      searchPages(query, limit, skip, done)
    else
      fetchLikes(limit, skip, done)

facebook.user = AnyStore.createHTTPStore 'facebook.user', UserOptions, ({id}, callback) ->
  done = U.combine(2, callback)
  fetchName(id, done)
  fetchLargePic(id, done)

EventOptions =
  limit: Meteor.settings.public?.event_list_paging_limit
  minutes: Meteor.settings.public?.http_cache_minutes

facebook.event = AnyStore.createHTTPStore 'fbEvents', EventOptions, ({id}, callback) ->
  fetchEvent(id, callback)
