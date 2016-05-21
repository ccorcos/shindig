@Scroll = ReactUI.createView
  displayName: 'Scroll'
  mixins: [React.addons.PureRenderMixin, ReactUI.InstanceMixin]
  propTypes:
    className: React.PropTypes.string
    instance: React.PropTypes.object.isRequired
  componentDidMount: ->
    @getDOMNode().scrollTop = @props.instance.scrollTop || 0
  save: ->
    scrollTop: @getDOMNode().scrollTop
  render: ->
    div
      className: ['scroll', @props.className].join(' ')
      div
        className: 'wrap-content rel'
        @props.children
