@List = ReactUI.createView
  displayName: 'List'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    items: React.PropTypes.array
    loading: React.PropTypes.bool
    loadMore: React.PropTypes.func
    renderItem: React.PropTypes.func.isRequired
    renderLoadMore: React.PropTypes.func
    renderEmpty: React.PropTypes.func
    className: React.PropTypes.string
  render: ->
    div
      className: 'list pad col ' + (@props.className or '')
      @props.items?.map(@props.renderItem)
      cond @props.loading,
        => div
          className: 'load-more'
          Spinner()
        => cond @props.loadMore,
          => div
            className: 'load-more pointer'
            onClick: ReactUI.debounce(@props.loadMore)
            @props.renderLoadMore?() or 'LOAD MORE'
          => cond @props.items?.length is 0,
            => div
              className: 'empty-list'
              @props.renderEmpty?() or 'No results'

@ScrollList = ReactUI.createView
  displayName: 'ScrollList'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    items: React.PropTypes.array
    loading: React.PropTypes.bool
    loadMore: React.PropTypes.func
    renderItem: React.PropTypes.func.isRequired
    instance: React.PropTypes.object.isRequired
    renderHeader: React.PropTypes.func
    renderFooter: React.PropTypes.func
    className: React.PropTypes.string
    renderLoadMore: React.PropTypes.func
    renderEmpty: React.PropTypes.func
  render: ->
    Scroll
      className: 'list-view col ' + (@props.className or '')
      instance: @props.instance
      @props.renderHeader?()
      List
        items: @props.items
        loading: @props.loading
        loadMore: @props.loadMore
        renderItem: @props.renderItem
        renderLoadMore: @props.renderLoadMore
        renderEmpty: @props.renderEmpty
      @props.renderFooter?()
