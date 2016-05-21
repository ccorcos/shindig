INPUT_THROTTLE_MS = Meteor.settings.public?.input_throttle_ms or 0

roundCoords = ({lat, lng}) ->
  # nearest = 0.1
  lat: Math.round(lat*10)/10
  lng: Math.round(lng*10)/10

# When you press enter on the location, we'll search for the city. If we can't
# find it, display: could not find 'blAH' and set to anywhere.
@PlaceInput = ReactUI.createView
  displayName: 'PlaceInput'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    initialValue: React.PropTypes.object
    onChange: React.PropTypes.func.isRequired
  getDefaultProps: ->
    initialValue: {name: ''}
  getInitialState: ->
    name: @props.initialValue?.name
    predict: ''
  componentWillMount: ->
    @searchCity = U.throttle(INPUT_THROTTLE_MS, Places.searchCity)
  onKeyDown: (e) ->
    if e.key is "Tab" or e.key is "Enter"
      @onReturn(e)
  onReturn: (e) ->
    e.preventDefault()
    e.target.blur()
  onBlur: ->
    @setState
      predict: 'loading...'
    query = @state.name
    if query is '' or query.toLowerCase() is 'anywhere'
      @setState
        name: 'Anywhere'
        predict: ''
      @props.onChange({name:'Anywhere'})
    else
      @searchCity query, ({name, lat, lng}={}) =>
        if name
          {lat, lng} = roundCoords({lat, lng})
          @setState
            name: name
            predict: ''
          @props.onChange({name, lat, lng})
        else
          @setState
            name: 'Anywhere'
            predict: "'#{query}' not found"
          @props.onChange({name:'Anywhere'})
  setCurrentLocation: ->
    @setState
      name: ''
      predict: 'resolving location...'
    Places.currentCity ({name, lat, lng}={}) =>
      if name
        {lat, lng} = roundCoords({lat, lng})
        @setState
          name: name
          predict: ''
        @props.onChange({name, lat, lng})
      else
        @setState
          name: 'Anywhere'
          predict: "current location not found"
        @props.onChange({name:'Anywhere'})
  onChange: (e) ->
    name = e.target.value
    if name is ''
      @setState({name, predict:'Anywhere'})
    else
      @setState({name})
  render: ->
    div
      className: 'icon-input full row rel'
      div
        className: "icon"
        Crosshairs
          className: 'pointer'
          onClick: @setCurrentLocation
      input
        className: 'full'
        value: @state.name
        disabled: true if @state.predict is "resolving location..."
        onChange: @onChange
        onBlur: @onBlur
        onKeyDown: @onKeyDown
      div
        className: 'input-predict-wrap'
        div
          className: 'input-predict'
          @state.predict
