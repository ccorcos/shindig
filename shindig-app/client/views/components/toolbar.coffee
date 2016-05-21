
@Toolbar = ReactUI.createView
  displayName: 'Toolbar'
  mixins: [
    React.addons.PureRenderMixin
    ReactUI.InstanceMixin
  ]
  propTypes:
    initialToolbarOpen: React.PropTypes.bool
    canToggleToolbar: React.PropTypes.bool
    renderRightButton:  React.PropTypes.func
    rows:  React.PropTypes.number.isRequired
  getDefaultProps: ->
    initialToolbarOpen: false
    canToggleToolbar: true
  getInitialState: ->
    U.defaults @props.instance.state,
      toolbarOpen: @props.initialToolbarOpen
  save: ->
    state: @state
  updateButton: ->
    if @props.canToggleToolbar
      if @state.toolbarOpen
        @props.renderRightButton? X {key: 'x', onClick: ReactUI.debounce(@toggle), className: 'abs pointer'}
      else
        @props.renderRightButton? Spyglass {key: 'spyglass', onClick: ReactUI.debounce(@toggle), className: 'abs pointer'}
    else
      @props.renderRightButton?()
  toggle: ->
    @setState
      toolbarOpen: not @state.toolbarOpen
      => @updateButton()
  componentWillMount: ->
    @updateButton()
  render: ->
    open = if (@state.toolbarOpen or not @props.canToggleToolbar) then "open open-#{@props.rows}" else ''
    div
      className: "toolbar #{open}"
      div
        className: "wrap-content col"
        @props.children
