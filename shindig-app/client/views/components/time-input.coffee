# As you're typing, we're parsing the date and displaying it in the prediction
# label. If its an invalid date, you cannot return, but if you blur, we'll set
# the date to right now. Otherwise, we'll set it to the prediction.

throttle = (f, ms) ->
  timer = null
  (arg) ->
    Meteor.clearTimeout(timer)
    timer = Meteor.setTimeout ->
      f(arg)
    , ms

@TimeInput = ReactUI.createView
  displayName: 'TimeInput'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    initialValue: React.PropTypes.number.isRequired
    onChange: React.PropTypes.func.isRequired
  getInitialState: ->
    time: S.toNextHalfHour(moment(@props.initialValue)).calendar()
    predict: ''
  setTimeNow: ->
    date = S.toNextHalfHour(moment())
    @setState
      time: date.calendar()
      predict: ''
    @props.onChange(date.valueOf())
  onKeyDown: (e) ->
    if e.key is "Tab" or e.key is "Enter"
      @onReturn(e)
  onReturn: (e) ->
    e.preventDefault()
    if @state.predict isnt 'invalid date'
      e.target.blur()
  onBlur: ->
    date = parseDate(@state.time)
    if date?.isValid?()
      date = S.toNextHalfHour(date)
      @setState
        time: date.calendar()
        predict: ''
      @props.onChange(date.valueOf())
    else
      @setTimeNow()
  setPredictDate: (string) ->
    date = parseDate(string)
    if date?.isValid?()
      date = S.toNextHalfHour(date)
      @setState
        predict: date.calendar()
    else
      @setState
        predict: 'invalid date'
  componentWillMount: ->
    @parseDate = throttle(@setPredictDate, 400)
  onChange: (e) ->
    string = e.target.value
    nextState = {time: string}
    if string is ''
      nextState.predict = S.toNextHalfHour(moment()).calendar()
    else
      @parseDate(string)
    @setState(nextState)
  render: ->
    div
      className: 'icon-input full row rel'
      div
        className: "icon"
        Clock
          className: 'pointer'
          onClick: @setTimeNow
      input
        className: 'full'
        value: @state.time
        onChange: @onChange
        onBlur: @onBlur
        onKeyDown: @onKeyDown
      div
        className: 'input-predict-wrap'
        div
          className: 'input-predict'
          @state.predict
