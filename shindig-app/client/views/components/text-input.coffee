# this is a controlled text input that handles blur/tab/return and clear

{svg, line} = React.DOM

svgX = ->
  svg
    viewBox: "0 0 20 20"
    className: 'x'
    line
      x1: 5
      y1: 5
      x2: 15
      y2: 15
    line
      x1: 15
      y1: 5
      x2: 5
      y2: 15


# this is a huge pain in the ass because blur happens before onClick

@TextInput = ReactUI.createView
  displayName: 'TextInput'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    value: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired
    onReturn: React.PropTypes.func.isRequired
    onClear: React.PropTypes.func
    className: React.PropTypes.string
    disabled: React.PropTypes.bool
  getInitialState: ->
    focused: false
  onKeyDown: (e) ->
    if e.key is "Tab" or e.key is "Enter"
      e.preventDefault()
      e.target.blur()
  onFocus: ->
    @setState({focused:true})
  onClear: (e) ->
    console.log "clear"
    @props.onClear()
  onBlur: (e) ->
    console.log "blur"
    @setState({focused:false})
    @props.onReturn(@props.value)
  onChange: (e) ->
    @props.onChange(e.target.value)
  render: ->
    showClear = @props.onClear and @state.focused and @props.value
    div
      className: ["text-input row rel", @props.className].join(" ")
      input
        ref: 'input'
        className: "full " + (if showClear then 'show-clear' else '')
        disabled: @props.disabled
        type: 'text'
        value: @props.value
        onChange: @onChange
        onKeyDown: @onKeyDown
        onBlur: @onBlur
        onFocus: @onFocus
      cond @props.onClear,
        => div
          className: "clear-wrapper " + (if showClear then 'show-clear' else '')
          onClick: @onClear
          div
            className: "clear row center"
            svgX()
