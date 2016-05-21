{a, h1} = React.DOM

@EventItem = ReactUI.createView
  displayName: 'EventItem'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    event: React.PropTypes.object
    loading: React.PropTypes.bool
    push: React.PropTypes.func.isRequired
  pushEvent: ->
    @props.push({
      path: "/event/#{@props.event.id}"
      name: "/event/:id"
      params: {id: @props.event.id}
    })
  pushStargazers: ->
    @props.push({
      name: '/event/:id/stargazers'
      path: '/event/'+@props.event.id+'/stargazers'
      params: {id:@props.event.id}
    })
  pushFollowedStargazers: ->
    @props.push({
      name: '/event/:id/followed-stargazers'
      path: '/event/'+@props.event.id+'/followed-stargazers'
      params: {id:@props.event.id}
    })
  render: ->
    cond @props.loading,
      => div
        key: 'loading'
        className: 'event-item fb loading'
      => div
        key: 'item'
        className: 'event-item col'
        img
          className: 'cover pointer'
          src: @props.event?.cover?.source
          onClick: ReactUI.debounce(@pushEvent)
        h1
          className: 'title row pointer'
          onClick: ReactUI.debounce(@pushEvent)
          @props.event?.name
        div
          className: 'time row'
          Clock
            className: 'icon'
            time: @props.event.start_time
          span
            className: 'time range'
            S.calendarRange(@props.event.start_time, @props.event.end_time, @props.event.timezone)
        cond @props.event.place,
          => link
            className: 'place row'
            href: googleMapsLink(getAddress(@props.event.place))
            Crosshairs
              className: 'icon'
            span
              className: 'place'
              placeName(@props.event.place)
        div
          className: 'star-info row'
          MetaStarButton
            fbId: @props.fbId
            eventId: @props.event.id
            className: 'icon'
          span
            className: 'stars'
            MetaStarCount
              fbId: @props.fbId
              eventId: @props.event.id
              onClick: @pushStargazers
            ' ( '
            MetaFollowedStarCount
              fbId: @props.fbId
              eventId: @props.event.id
              onClick: @pushFollowedStargazers
            ' )'
# {
#   "id": "911049402260190",
#   "name": "Gloria Trevi - Special Release Concert",
#   "start_time": "2015-08-21T19:30:00-0700",
#   "cover": {
#     "cover_id": "10152683604096439",
#     "offset_x": 0,
#     "offset_y": 6,
#     "source": "https://scontent.xx.fbcdn.net/hphotos-xfp1/t31.0-8/s720x720/11025838_10152683604096439_3008328947828065589_o.jpg",
#     "id": "10152683604096439"
#   },
#   "ticket_uri": "http://www.greektheatrela.com/events/event_details.php?id=3065",
#   "place": {
#     "name": "Greek Theatre L.A.",
#     "location": {
#       "city": "Los Angeles",
#       "country": "United States",
#       "latitude": 34.119486239717,
#       "longitude": -118.29607815139,
#       "state": "CA",
#       "street": "2700 North Vermont, In Griffith Park",
#       "zip": "90027"
#     },
#     "id": "47761106438"
#   },
#   "hosts": [{
#     "name": "Greek Theatre L.A.",
#     "category": "Concert Venue",
#     "category_list": [{
#       "id": "179943432047564",
#       "name": "Concert Venue"
#     }, {
#       "id": "209889829023118",
#       "name": "Landmark"
#     }],
#     "id": "47761106438"
#   }]
# }

@MetaEventItem = ReactUI.createView
  displayName: 'MetaEventItem'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    fbId: React.PropTypes.string.isRequired
    eventId: React.PropTypes.string.isRequired
    push: React.PropTypes.func.isRequired
  renderData: ({data, loading}) ->
    EventItem
      fbId: @props.fbId
      event: data
      loading: loading
      push: @props.push
  render: ->
    ReactUI.Data
      key: @props.eventId
      query: {id: @props.eventId}
      store: facebook.event
      render: @renderData
