@EventList = ReactUI.createView
  displayName: 'EventList'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    fbId: React.PropTypes.string.isRequired
    eventIds: React.PropTypes.array
    loading: React.PropTypes.bool
    loadMore: React.PropTypes.func
    instance: React.PropTypes.object.isRequired
    renderHeader: React.PropTypes.func
    renderFooter: React.PropTypes.func
    renderLoadMore: React.PropTypes.func
    renderEmpty: React.PropTypes.func
    push: React.PropTypes.func.isRequired
    className: React.PropTypes.string
  renderItem: (id) ->
    MetaEventItem
      key: id
      eventId: id
      push: @props.push
      fbId: @props.fbId
  render: ->
    ScrollList
      items: @props.eventIds
      loading: @props.loading
      loadMore: @props.loadMore
      instance: @props.instance
      renderHeader: @props.renderHeader
      renderFooter: @props.renderFooter
      renderEmpty: @props.renderEmpty
      renderLoadMore: @props.renderLoadMore
      className: 'event-list ' + (@props.className or '')
      renderItem: @renderItem


@MetaEventList = ReactUI.createView
  displayName: 'MetaEventList'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    fbId: React.PropTypes.string.isRequired
    query: React.PropTypes.any
    store: React.PropTypes.object.isRequired
    instance: React.PropTypes.object.isRequired
    renderHeader: React.PropTypes.func
    renderFooter: React.PropTypes.func
    className: React.PropTypes.string
    renderLoadMore: React.PropTypes.func
    renderEmpty: React.PropTypes.func
    push: React.PropTypes.func.isRequired
  renderList: ({data, loading, fetch}) ->
    # careful here, when the component mounts, we set the time to now.
    # do we can just let the previous subscription die and rely on this
    # one. Most event will carry over anyway.
    EventList
      fbId: @props.fbId
      eventIds: data?.map (event) -> event.id or event._id
      loading: loading
      loadMore: fetch
      instance: @props.instance
      renderHeader: @props.renderHeader
      renderFooter: @props.renderFooter
      renderEmpty: @props.renderEmpty
      renderLoadMore: @props.renderLoadMore
      className: @props.className
      push: @props.push
  renderEmptyCrawling: ->
    span
      className: 'empty'
      'Crawling events... Come back later.'
  renderUserEvents: ({data, loading, fetch}) ->
    if loading
      @renderList
        data: []
        loading: true
        fetch: undefined
    else if data?[0]?.lastSync <= 0
      EventList
        fbId: @props.fbId
        eventIds: []
        loading: false
        loadMore: undefined
        instance: @props.instance
        renderHeader: @props.renderHeader
        renderFooter: @props.renderFooter
        renderEmpty: @renderEmptyCrawling
        renderLoadMore: @props.renderLoadMore
        className: @props.className
        push: @props.push
    else
      @renderList(@eventsData)
  renderData: ({data, loading, fetch}) ->
    userId = @props.query.domain?.user
    if not userId
      return @renderList({data, loading, fetch})
    # if we're on a user page, we need to notify if the user is being crawled...
    @eventsData = {data, loading, fetch}
    ReactUI.Data
      key: @props.fbId+userId
      query:
        userId: userId
        fbId: @props.fbId
      store: Shindig.user
      render: @renderUserEvents
  render: ->
    ReactUI.Data
      key: @props.query
      query: @props.query
      store: @props.store
      render: @renderData
