{a, h1} = React.DOM

@EventView = ReactUI.createView
  displayName: 'EventView'
  mixins: [React.addons.PureRenderMixin, ViewPropsMixin]
  propTypes:
    event: React.PropTypes.object
    loading: React.PropTypes.bool
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
      => Loading()
      => div
        className: 'event view'
        Scroll
          instance: @props.instance
          div
            className: 'pad'
            img
              className: 'cover'
              src: @props.event?.cover?.source
            h1
              className: 'title row pointer'
              link
                href: facebookLink(@props.event.id)
                @props.event.name
            div
              className: 'time row'
              Clock
                className: 'icon'
                # facebook sends a date like this: 2015-09-19T19:00:00-0700
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
            cond @props.event.ticket_uri,
              => link
                className: 'ticket row'
                href: @props.event.ticket_uri
                Ticket
                  className: 'icon'
                span
                  'Buy Tickets!'
            ShareLink
              text: "event/#{@props.event.id}"
            @props.event.hosts.map ({id}) =>
              MetaUserItem
                key:id
                userId:id
                push:@props.push
                className: 'row'
            div
              className: 'description row'
              @props.event.description

@MetaEvent = ReactUI.createView
  displayName: 'MetaEvent'
  mixins: [
    React.addons.PureRenderMixin
    ViewPropsMixin
    ViewMixin({clearRightButton:true})
  ]
  propTypes:
    eventId: React.PropTypes.string.isRequired
  render: ->
    ReactUI.Data
      query: {id: @props.eventId}
      store: facebook.event
      render: ({data, loading}) =>
        EventView R.merge @props,
          event: data
          loading: loading
