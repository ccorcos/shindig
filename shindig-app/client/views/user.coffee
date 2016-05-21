@User = ReactUI.createView
  displayName: 'User'
  mixins: [
    React.addons.PureRenderMixin
    ViewPropsMixin
    ReactUI.InstanceMixin
    ViewMixin({clearRightButton:false})
  ]
  propTypes:
    userId: React.PropTypes.string.isRequired
  getInitialState: ->
    U.defaults @props.instance.state,
      time: S.nextHalfHourStamp()
      place: {name:'Anywhere'}
      search: ''
  componentWillMount: ->
    @inputs = [{
      name: 'time'
      component: TimeInput
      props:
        initialValue: @state.time
    },{
      name: 'place'
      component: PlaceInput
      props:
        initialValue: @state.place
    }, {
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
    query.domain = {user:@props.userId}
    if @state.popular
      query.sort = {popular: true}
    else
      query.sort = {time: true}
    query.filter = {}
    query.filter.time = @state.time
    if @state.search
      query.filter.name = @state.search
    if @state.place?.lat and @state.place?.lng
      query.filter.latlng = [@state.place.lat, @state.place.lng]
    return query
  renderHeader: ->
    MetaUserInfo
      fbId: @props.fbId
      userId: @props.userId
      renderModal: @props.renderModal
      push: @props.push
  renderEmpty: ->
    span
      className: 'empty'
      'Sorry, no events...'
  render: ->
    query = @makeQuery()
    div
      className: 'user view'
      Filters
        initialToolbarOpen: false
        canToggleToolbar: true
        renderRightButton: @props.renderRightButton
        instance: @childInstance('filters')
        onChange: @onChange
        inputs: @inputs
        rows: @inputs.length
      MetaEventList
        fbId: @props.fbId
        key: U.serialize(query)
        query: query
        store: Shindig.events
        instance: @childInstance('events-list')
        push: @props.push
        renderHeader: @renderHeader
        renderEmpty: @renderEmpty
        renderLoadMore: Down
