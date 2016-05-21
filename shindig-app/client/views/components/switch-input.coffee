
# verticle vs horizontal?
@SwitchInput = ReactUI.createView
  displayName: 'SwitchInput'
  propTypes:
    initialValue: React.PropTypes.string.isRequired
    values: React.PropTypes.array.isRequired
    onChange: React.PropTypes.func.isRequired
  getInitialState: ->
    {selected: @props.initialValue}
  setTab: (name) ->
    console.log name
    if name isnt @state.selected
      @setState
        selected: name
      @props.onChange(name)
  render: ->
    TabBar
      className: 'full'
      currentTab: @state.selected
      onSetTab: @setTab
      tabs: @props.values
