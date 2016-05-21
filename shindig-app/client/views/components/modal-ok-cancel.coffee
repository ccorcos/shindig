{a, h3} = React.DOM

@OkCancel = ReactUI.createView
  displayName: 'OkCancel'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    className: React.PropTypes.string
    title: React.PropTypes.string.isRequired
    okLabel: React.PropTypes.string
    cancelLabel: React.PropTypes.string
    onOk: React.PropTypes.func.isRequired
    onCancel: React.PropTypes.func.isRequired
  render: ->
    div 
      className: 'drawer ' + (@props.className or '')
      h3 {},
        @props.title
      button
        className:'btn ok'
        onClick: @props.onOk
        @props.okLabel
      a 
        className:'cancel pointer'
        onClick: @props.onCancel
        @props.cancelLabel
