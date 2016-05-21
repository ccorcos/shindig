@UserItem = ReactUI.createView
  displayName: 'UserItem'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    user: React.PropTypes.object
    loading: React.PropTypes.bool
    push: React.PropTypes.func.isRequired
  pushUser: ->
    @props.push({
      path: "/user/#{@props.user?.id}"
      name: "/user/:id"
      params: {id: @props.user?.id}
    })
  render: ->
    cond @props.loading,
      => div
        key: 'loading'
        className: ['user-item fb loading', @props.className].join(' ')
      => div
        key: 'item'
        className: ['user-item pointer', @props.className].join(' ')
        onClick: ReactUI.debounce(@pushUser)
        div
          className: 'prof-pic'
          style:
            backgroundImage: "url(#{@props.user?.img})"
        div
          className: 'name'
          @props.user?.name

@MetaUserItem = ReactUI.createView
  displayName: 'MetaUserItem'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    userId: React.PropTypes.string.isRequired
    push: React.PropTypes.func.isRequired
  renderData: ({data, loading}) ->
    UserItem
      key: @props.userId
      user: data
      loading: loading
      push: @props.push
      className: @props.className
  render: ->
    ReactUI.Data
      key: @props.userId
      query: {id: @props.userId}
      store: facebook.user
      render: @renderData
