
@SearchInput = ReactUI.createView
  displayName: 'SearchInput'
  propTypes:
    initialValue: React.PropTypes.string
    onChange: React.PropTypes.func.isRequired
  getInitialState: ->
    {value: @props.initialValue or ''}
  onChange: (e) ->
    @setState({value: e.target.value})
  onBlur: ->
    @props.onChange(@state.value)
  onKeyDown: (e) ->
    if e.key is "Tab" or e.key is "Enter"
      e.preventDefault()
      e.target.blur()
  render: ->
    div
      className: 'icon-input full row rel'
      div
        className: "icon"
        Spyglass()
      input
        value: @state.value
        placeholder: 'Search'
        className: 'full'
        onChange: @onChange
        onBlur: @onBlur
        onKeyDown: @onKeyDown
