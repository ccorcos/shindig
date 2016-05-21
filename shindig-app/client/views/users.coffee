
@Users = ReactUI.createView
  displayName: 'Users'
  mixins: [
    React.addons.PureRenderMixin
    ReactUI.InstanceMixin
    ViewPropsMixin
    ViewMixin({clearRightButton:true})
  ]
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
    query = {}
    query.fbId = @props.fbId
    query.sort = {popular: true}
    if @state.search
      query.filter = {name: @state.search}
    return query
  renderEmpty: ->
    span
      className: 'empty'
      'Sorry, no users...'
  render: ->
    query = @makeQuery()
    div
      className: 'users view'
      Filters
        initialToolbarOpen: true
        canToggleToolbar: false
        renderRightButton: @props.renderRightButton
        instance: @childInstance('filters')
        onChange: @onChange
        inputs: @inputs
      MetaUserList
        fbId: @props.fbId
        key: U.serialize(query)
        query: query
        store: Shindig.users
        instance: @childInstance('users-list')
        push: @props.push
        renderEmpty: @renderEmpty
        renderLoadMore: Down
