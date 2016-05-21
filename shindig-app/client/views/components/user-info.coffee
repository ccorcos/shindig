
@UserInfo = ReactUI.createView
  displayName: 'UserInfo'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    fbId: React.PropTypes.string.isRequired
    user: React.PropTypes.object
    loading: React.PropTypes.bool
    renderModal: React.PropTypes.func.isRequired
    push: React.PropTypes.func.isRequired
  pushFollows: ->
    @props.push({
      name: '/user/:id/follows'
      path: '/user/'+@props.user?.id+'/follows'
      params: {id:@props.user?.id}
    })
  pushFollowers: ->
    @props.push({
      name: '/user/:id/followers'
      path: '/user/'+@props.user?.id+'/followers'
      params: {id:@props.user?.id}
    })
  logout: ->
    Meteor.logout()
    # logoutHook()
  render: ->
    cond @props.loading,
      => div
        key: 'loading'
        className: 'user-info col fb loading'
      => div
        className: 'user-info col'
        div
          className: 'prof-pic'
          style:
            backgroundImage: "url(#{@props.user?.img})"
        div
          className: 'name',
          link
            href: facebookLink(@props.user.id)
            @props.user.name
        div
          className: 'follow-info row'
          div
            className: 'inner'
            cond @props.user?.id isnt @props.fbId,
              => div
                className: 'inline'
                MetaFollowButton
                  fbId: @props.fbId
                  userId: @props.user?.id
                  renderModal: @props.renderModal
              => div
                className: 'btn muted inline pointer'
                onClick: @logout
                "LOGOUT"
            div
              className:'inline pointer'
              onClick: @pushFollows
              'Following: '
              MetaFollowCount({userId:@props.user?.id, fbId: @props.fbId})
            div
              className:'inline pointer'
              onClick: @pushFollowers
              ' Followers: '
              MetaFollowerCount({userId:@props.user?.id, fbId: @props.fbId})


@MetaUserInfo = ReactUI.createView
  displayName: 'MetaUserInfo'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    fbId: React.PropTypes.string.isRequired
    userId: React.PropTypes.string.isRequired
    renderModal: React.PropTypes.func.isRequired
    push: React.PropTypes.func.isRequired
  renderData: ({data, loading}) ->
    UserInfo
      fbId: @props.fbId
      user: data
      loading: loading
      renderModal: @props.renderModal
      push: @props.push
  render: ->
    ReactUI.Data
      key: @props.userId
      query: {id: @props.userId}
      store: facebook.user
      render: @renderData
