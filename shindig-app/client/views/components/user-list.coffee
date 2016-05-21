@UserList = ReactUI.createView
  displayName: 'UserList'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    userIds: React.PropTypes.array
    loading: React.PropTypes.bool
    loadMore: React.PropTypes.func
    instance: React.PropTypes.object.isRequired
    renderHeader: React.PropTypes.func
    renderFooter: React.PropTypes.func
    push: React.PropTypes.func
    className: React.PropTypes.string
    renderLoadMore: React.PropTypes.func
    renderEmpty: React.PropTypes.func
  renderItem: (id) ->
    MetaUserItem
      key: id
      userId: id
      push: @props.push
  render: ->
    ScrollList
      items: @props.userIds
      loading: @props.loading
      loadMore: @props.loadMore
      instance: @props.instance
      renderHeader: @props.renderHeader
      renderFooter: @props.renderFooter
      renderEmpty: @props.renderEmpty
      renderLoadMore: @props.renderLoadMore
      className: 'user-list ' + (@props.className or '')
      renderItem: @renderItem

@MetaUserList = ReactUI.createView
  displayName: 'MetaUserList'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    query: React.PropTypes.any
    store: React.PropTypes.object.isRequired
    instance: React.PropTypes.object.isRequired
    renderHeader: React.PropTypes.func
    renderFooter: React.PropTypes.func
    className: React.PropTypes.string
    push: React.PropTypes.func
    renderLoadMore: React.PropTypes.func
    renderEmpty: React.PropTypes.func
  renderData: ({data, loading, fetch}) ->
    UserList
      userIds: data?.map (user) -> user.id or user._id
      loading: loading
      loadMore: fetch
      instance: @props.instance
      renderHeader: @props.renderHeader
      renderFooter: @props.renderFooter
      renderEmpty: @props.renderEmpty
      renderLoadMore: @props.renderLoadMore
      className: @props.className
      push: @props.push
  render: ->
    ReactUI.Data
      key: @props.query
      query: @props.query
      store: @props.store
      render: @renderData

@SearchableUserList = ReactUI.createView
  displayName: 'SearchableUserList'
  mixins: [
    React.addons.PureRenderMixin
    ReactUI.InstanceMixin
  ]
  propTypes:
    store: React.PropTypes.object.isRequired
    query: React.PropTypes.object
    renderRightButton: React.PropTypes.func.isRequired
    renderLoadMore: React.PropTypes.func
    renderEmpty: React.PropTypes.func
  getInitialState: ->
    U.defaults @props.instance.state,
      search: ''
  componentWillMount: ->
    @inputs = [{
      name: 'search'
      component: SearchInput
      props:
        initialValue: @state.search
    }]
  save: ->
    state: @state
  onChange: (nextState) ->
    @setState(nextState)
  makeQuery: ->
    query = R.clone(@props.query)
    if @state.search
      query.filter = {name: @state.search}
    return query
  render: ->
    query = @makeQuery()
    div
      className: 'events view'
      Filters
        initialToolbarOpen: false
        canToggleToolbar: true
        renderRightButton: @props.renderRightButton
        instance: @childInstance('filters')
        onChange: @onChange
        inputs: @inputs
        rows: @inputs.length
      MetaUserList
        key: U.serialize(query)
        fbId: @props.fbId
        query: query
        store: @props.store
        instance: @childInstance('user-list')
        push: @props.push
        renderEmpty: @props.renderEmpty
        renderLoadMore: @props.renderLoadMore
