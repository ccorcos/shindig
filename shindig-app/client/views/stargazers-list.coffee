@StargazersList = ReactUI.createView
  displayName: 'StargazersList'
  mixins: [
    React.addons.PureRenderMixin
    ViewPropsMixin
    ViewMixin({clearRightButton:false})
]
  propTypes:
    eventId: React.PropTypes.string.isRequired
  renderEmpty: ->
    span
      className: 'empty'
      "This event has no stargazers."
  render: ->
    SearchableUserList
      key: @props.eventId
      fbId: @props.fbId
      query:
        fbId: @props.fbId
        domain:
          stargazers: @props.eventId
        sort:
          popular: true
      store: Shindig.users
      instance: @props.instance
      className: 'stargazers-list view'
      push: @props.push
      renderRightButton: @props.renderRightButton
      renderEmpty: @renderEmpty
      renderLoadMore: Down

@FollowedStargazersList = ReactUI.createView
  displayName: 'FollowedStargazersList'
  mixins: [
    React.addons.PureRenderMixin
    ViewPropsMixin
    ViewMixin({clearRightButton:false})
  ]
  propTypes:
    eventId: React.PropTypes.string.isRequired
  renderEmpty: ->
    span
      className: 'empty'
      "None of the users you follow have starred this event."
  render: ->
    SearchableUserList
      key: @props.fbId+@props.eventId
      fbId: @props.fbId
      query:
        fbId: @props.fbId
        domain:
          followedStargazers:
            eventId: @props.eventId
            fbId: @props.fbId
        sort:
          popular: true
      store: Shindig.users
      instance: @props.instance
      className: '-list view'
      push: @props.push
      renderRightButton: @props.renderRightButton
      renderEmpty: @renderEmpty
      renderLoadMore: Down
