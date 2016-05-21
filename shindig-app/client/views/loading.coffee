@Loading = ReactUI.createView
  displayName: 'Loading'
  mixins: [React.addons.PureRenderMixin]
  render: ->
    div
      className: ['view loading', @props.className].join(' ')
      Spinner()
