@StarCount = ReactUI.createView
  displayName: 'StarCount'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    data: React.PropTypes.object
    loading: React.PropTypes.bool
    className: React.PropTypes.string
    name: React.PropTypes.string.isRequired
  render: ->
    unverified = (if @props.data?.unverified then 'unverified' else '')
    shortcut = (if @props.data?.shortcut then 'shortcut' else '')
    cond @props.loading and not @props.data?.shortcut,
      => span
        className: ['star-count inline sub loading', @props.className].join(' ')
      => span
        className: ['star-count inline sub', unverified, shortcut, @props.className].join(' ')
        onClick: @props.onClick
        @props.data?[@props.name]


@MetaStarCount = ReactUI.createView
  displayName: 'MetaStarCount'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    fbId: React.PropTypes.string.isRequired
    eventId: React.PropTypes.string.isRequired
    className: React.PropTypes.string
  renderData: ({data, loading}) ->
    StarCount
      data: data?[0]
      loading: loading
      className: 'star-count'
      name:'starCount'
      onClick: @props.onClick
  render: ->
    ReactUI.Data
      key: @props.eventId
      query: {fbId:@props.fbId, eventId:@props.eventId}
      store: Shindig.event
      render: @renderData

@MetaFollowedStarCount = ReactUI.createView
  displayName: 'MetaFollowedStarCount'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    fbId: React.PropTypes.string.isRequired
    eventId: React.PropTypes.string.isRequired
    className: React.PropTypes.string
  renderData: ({data, loading}) ->
    StarCount
      data: data?[0]
      loading: loading
      className: 'common-star-count'
      name:'followedStarCount'
      onClick: @props.onClick
  render: ->
    ReactUI.Data
      key: @props.fbId
      query: {fbId:@props.fbId, eventId:@props.eventId}
      store: Shindig.event
      render: @renderData
