stripHttp = (x) ->
  x.replace /https?:\/\/(www\.)?/,  ''

@ShareLink = ReactUI.createView
  displayName: 'ShareLink'
  propTypes:
    text: React.PropTypes.string
  getInitialState: ->
    message: stripHttp Meteor.absoluteUrl(@props.text)
  componentWillMount: ->
    @id = 'x'+Random.hexString(10)
  message: (text) ->
    @setState
      message: text
    Meteor.setTimeout =>
      @setState
        message: stripHttp Meteor.absoluteUrl(@props.text)
    , 2000
  componentDidMount: ->
    text = Meteor.absoluteUrl(@props.text)
    @clipboard = new Clipboard "##{@id}",
      text: => text
    @clipboard.on 'success', (e) =>
      @message 'link copied!'
    @clipboard.on 'error', (e) =>
      @setState
        message: Meteor.absoluteUrl(@props.text)
      , ->
        node = @refs.input.getDOMNode()
        node.setSelectionRange(0,text.length)
  resetLink: ->
    @setState
      message: stripHttp Meteor.absoluteUrl(@props.text)
  render: ->
    div
      id: @id
      className: 'share row'
      Share
        className: 'icon pointer'
      input
        className: 'message pointer'
        onBlur: @resetLink
        key: @state.message
        value: @state.message
        ref: 'input'
        onChange: (->)
        style:
          width: '100%'
          backgroundColor: 'inherit'
          paddingLeft: 0
