@StarButton = ReactUI.createView
  displayName: 'StarButton'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    eventId: React.PropTypes.string.isRequired
    data: React.PropTypes.object
    loading: React.PropTypes.bool
    className: React.PropTypes.string
  star: ->
    unless @props.loading or @props.data?.unverified
      Meteor.call('star', @props.eventId)
  unstar: ->
    unless @props.loading or @props.data?.unverified
      Meteor.call('unstar', @props.eventId)
  render: ->
    unverified = (if @props.data?.unverified then 'unverified' else '')
    shortcut = (if @props.data?.shortcut then 'shortcut' else '')
    cond @props.loading and not @props.data?.shortcut,
      => div
        className: @props.className
        Star
          className: 'sub loading loading'
      => cond @props.data?.starred,
        => div
          className: ["pointer", @props.className].join(' ')
          onClick: ReactUI.debounce(@unstar)
          Star
            className: ['starred', unverified, shortcut].join(' ')
        => div
          className: ["pointer", @props.className].join(' ')
          onClick: ReactUI.debounce(@star)
          Star
            className: [unverified, shortcut].join(' ')

@MetaStarButton = ReactUI.createView
  displayName: 'MetaStarButton'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    fbId: React.PropTypes.string.isRequired
    eventId: React.PropTypes.string.isRequired
    className: React.PropTypes.string
  renderData: ({data, loading}) ->
    StarButton
      eventId: @props.eventId
      data: data?[0]
      loading: loading
      className: @props.className

  render: ->
    ReactUI.Data
      key: @props.fbId+@props.eventId
      query: {fbId:@props.fbId, eventId:@props.eventId}
      store: Shindig.event
      render: @renderData
