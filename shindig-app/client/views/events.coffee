
@Events = ReactUI.createView
  displayName: 'Events'
  mixins: [
    React.addons.PureRenderMixin
    ReactUI.InstanceMixin
    ViewPropsMixin
    ViewMixin({clearRightButton:false})
  ]
  getInitialState: ->
    U.defaults @props.instance.state,
      time: S.nextHalfHourStamp()
      place: {name:'Anywhere'}
      search: @props.initialValue or ''
      popular: false
      followNetwork: false
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
    }, [{
      name: 'popular'
      component: Checkbox
      props:
        initialValue: @state.popular
        className: 'full'
        label: 'Popular'
    }, {
      name: 'followNetwork'
      component: Checkbox
      props:
        initialValue: @state.followNetwork
        className: 'full'
        label: 'Feed'
    }]]
  save: ->
    state: @state
  onChange: (nextState) ->
    @setState(nextState)
  makeQuery: ->
    query = {}
    query.fbId = @props.fbId
    if @state.followNetwork
      query.domain = {feed:@props.fbId}
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
  renderEmpty: ->
    string = 'Sorry, no events...'
    # if @state.followNetwork
    #   string = 'Sorry, no events. Try unchecking "Feed".'
    span
      className: 'empty'
      string
  render: ->
    query = @makeQuery()
    div
      className: 'events view'
      Filters
        initialToolbarOpen: true
        canToggleToolbar: true
        renderRightButton: @props.renderRightButton
        instance: @childInstance('filters')
        onChange: @onChange
        inputs: @inputs
        rows: @inputs.length
      MetaEventList
        key: U.serialize(query)
        fbId: @props.fbId
        query: query
        store: Shindig.events
        instance: @childInstance('event-list')
        push: @props.push
        renderEmpty: @renderEmpty
        renderLoadMore: Down
