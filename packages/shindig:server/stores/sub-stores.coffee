UserOptions =
  limit: Meteor.settings.public?.user_list_paging_limit
  minutes: Meteor.settings.public?.sub_cache_minutes

EventOptions =
  limit: Meteor.settings.public?.event_list_paging_limit
  minutes: Meteor.settings.public?.sub_cache_minutes

Shindig.events = AnyStore.createSubListStore 'events', EventOptions
Shindig.users = AnyStore.createSubListStore 'users', UserOptions
Shindig.event = AnyStore.createSubStore 'event', EventOptions, ({eventId, fbId}) ->
  [AnyDb.findDoc(eventId)]
Shindig.user = AnyStore.createSubStore 'user', UserOptions, ({userId, fbId}) ->
  [AnyDb.findDoc(userId)]
