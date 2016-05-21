@Checkbox = ReactUI.createView
  displayName: 'Checkbox'
  propTypes:
    initialValue: React.PropTypes.bool.isRequired
    onChange: React.PropTypes.func.isRequired
    label: React.PropTypes.string.isRequired
    className: React.PropTypes.string
  getInitialState: ->
    {checked: @props.initialValue}
  toggle: () ->
    bool = true
    if @state.checked
      bool = false
    @setState({checked: bool})
    @props.onChange(bool)
  render: ->
    checked = 'checked' if @state.checked
    div
      className: ["labeled-checkbox center", @props.className].join(' ')
      onClick: @toggle
      div
        className: 'wrapper'
        div
          className: ["checkbox inline pointer", checked].join(' ')
        span
          className: 'checkbox-label'
          @props.label
