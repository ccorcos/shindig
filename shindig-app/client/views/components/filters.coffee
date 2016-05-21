@Filters = ReactUI.createView
  displayName: 'Filters'
  mixins: [
    React.addons.PureRenderMixin
    ReactUI.InstanceMixin
  ]
  propTypes:
    initialToolbarOpen: React.PropTypes.bool
    canToggleToolbar: React.PropTypes.bool
    renderRightButton: React.PropTypes.func.isRequired
    onChange: React.PropTypes.func.isRequired
    inputs: React.PropTypes.array.isRequired
  getInitialState: ->
    # inputs: [{
    #   component: TimeInput
    #   initialValue: ''
    #   name:
    # }]
    state = {}
    @props.inputs.map (input) ->
      if _.isArray(input)
        input.map ({name, props}) ->
          state[name] = props.initialValue
      else
        {name, props} = input
        state[name] = props.initialValue
    return state
  save: ->
    state: @state
  update: (name, value) ->
    if @isMounted()
      nextState = {}
      nextState[name] = value
      @setState nextState, => @props.onChange(@state)
  render: ->
    Toolbar
      initialToolbarOpen: @props.initialToolbarOpen
      canToggleToolbar: @props.canToggleToolbar
      instance: @childInstance('toolbar')
      renderRightButton: @props.renderRightButton
      rows: @props.inputs.length
      @props.inputs.map (input, i) =>
        div
          key: i
          className: 'filter-row rel row'
          do =>
            if _.isArray(input)
              input.map ({component, name, props}, i) =>
                component R.merge props,
                  key: i
                  # XXX func ref
                  onChange: (value) => @update(name, value)
            else
              {component, props, name} = input
              component R.merge props,
                # XXX func ref
                onChange: (value) => @update(name, value)
