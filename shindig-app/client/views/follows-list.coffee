@FollowsList = ReactUI.createView
  displayName: 'FollowsList'
  mixins: [
    React.addons.PureRenderMixin
    ViewPropsMixin
    ViewMixin({clearRightButton:false})
  ]
  propTypes:
    userId: React.PropTypes.string.isRequired
  renderEmpty: ->
    span
      className: 'empty'
      "This user doesn't follow anyone."
  render: ->
    SearchableUserList
      key: @props.userId
      fbId: @props.fbId
      query:
        fbId: @props.fbId
        domain:
          follows: @props.userId
        sort:
          popular: true
      store: Shindig.users
      instance: @props.instance
      className: 'follows-list view'
      push: @props.push
      renderRightButton: @props.renderRightButton
      renderEmpty: @renderEmpty
      renderLoadMore: Down

@FollowersList = ReactUI.createView
  displayName: 'FollowersList'
  mixins: [
    React.addons.PureRenderMixin
    ViewPropsMixin
    ViewMixin({clearRightButton:false})
  ]
  propTypes:
    userId: React.PropTypes.string.isRequired
  renderEmpty: ->
    span
      className: 'empty'
      "This user has no followers. :'("
  render: ->
    SearchableUserList
      key: @props.userId
      fbId: @props.fbId
      query:
        fbId: @props.fbId
        domain:
          followers: @props.userId
        sort:
          popular: true
      store: Shindig.users
      instance: @props.instance
      className: 'followers-list view'
      push: @props.push
      renderRightButton: @props.renderRightButton
      renderEmpty: @renderEmpty
      renderLoadMore: Down
