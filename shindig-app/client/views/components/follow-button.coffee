@FollowButton = ReactUI.createView
  displayName: 'FollowButton'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    fbId: React.PropTypes.string.isRequired
    user: React.PropTypes.object
    data: React.PropTypes.object
    loading: React.PropTypes.bool
    renderModal: React.PropTypes.func.isRequired
    className: React.PropTypes.string
  follow: ->
    unless @props.loading or @props.data?.unverified
      Meteor.call('follow', @props.user.id)
  unfollow: ->
    if not @props.loading and @props.data and not @props.data.unverified
      @props.renderModal OkCancel
        key: 'modal'
        title: "Would you like to unfollow #{@props.user.name}?"
        okLabel: "Yes, please."
        cancelLabel: "Whoopsy daisy."
        onOk: =>
          Meteor.call('unfollow', @props.user.id)
          @props.renderModal()
        onCancel: =>
          @props.renderModal()
  render: ->
    unverified = (if @props.data?.unverified then 'unverified' else '')
    shortcut = (if @props.data?.shortcut then 'shortcut' else '')
    cond @props.loading and not @props.data?.shortcut,
      => div
        className: 'follow-button inline sub loading'
      => cond @props.data?.followed,
        => div
          className: ['btn muted follow-button inline pointer unfollow', unverified, shortcut].join(' ')
          onClick: ReactUI.debounce(@unfollow)
          'UNFOLLOW'
        => div
          className: ['btn follow-button inline pointer follow ', unverified, shortcut].join(' ')
          onClick: ReactUI.debounce(@follow)
          'FOLLOW'

@MetaFollowButton = ReactUI.createView
  displayName: 'MetaFollowButton'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    fbId: React.PropTypes.string.isRequired
    userId: React.PropTypes.string.isRequired
    renderModal: React.PropTypes.func.isRequired
    className: React.PropTypes.string
  renderFacebookUserData: ({data, loading}) ->
    @user = data
    @userLoading = loading
    ReactUI.Data
      key: @props.fbId+@props.userId
      query:
        userId: @props.userId
        fbId: @props.fbId
      store: Shindig.user
      render: @renderShindigUserData
  renderShindigUserData: ({data, loading}) ->
    FollowButton
      fbId: @props.fbId
      user: @user
      data: data?[0]
      loading: loading or @userLoading
      renderModal: @props.renderModal
      className: @props.className
  render: ->
    ReactUI.Data
      key: @props.userId
      query: {id: @props.userId}
      store: facebook.user
      render: @renderFacebookUserData
