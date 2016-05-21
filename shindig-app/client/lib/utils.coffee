# Global components
{@div, @span, @input, @img, @button} = React.DOM
# We may want to override this at some point with a better version that is more reliable.
@Transition = React.createFactory(React.addons.CSSTransitionGroup)
# this makes your react code look beautiful
@cond = (condition, result, otherwise) -> if condition then result?() else otherwise?()

@getAddress = (place) ->
  if place?.location
    {street, city, state, zip} = place.location
    return [street,city, state].filter((x) -> x?).join(',')
  else
    return null

@googleMapsLink = (address) ->
  if address then 'https://www.google.com/maps/place/' + address.replace(/\ /g, '+')

@facebookLink = (id) ->
  if id then "https://facebook.com/#{id}"

@ViewPropsMixin =
  propTypes:
    fbId: React.PropTypes.string.isRequired
    push: React.PropTypes.func.isRequired
    path: React.PropTypes.string.isRequired
    instance: React.PropTypes.object.isRequired
    renderModal: React.PropTypes.func.isRequired
    renderRightButton: React.PropTypes.func.isRequired

@ViewMixin = ({clearRightButton}) ->
  propTypes:
    fbId: React.PropTypes.string.isRequired
    push: React.PropTypes.func.isRequired
    path: React.PropTypes.string.isRequired
    instance: React.PropTypes.object.isRequired
    renderModal: React.PropTypes.func.isRequired
    renderRightButton: React.PropTypes.func.isRequired
  componentWillMount: ->
    if clearRightButton then @props.renderRightButton(false)
    Router.go(@props.path)

@link = (args...) ->
  if args[0].href
    if Meteor.isCordova
      if args[0].className
        args[0].className = args[0].className + ' pointer'
      else
        args[0].className = 'pointer'
      href = args[0].href
      args[0].href = ""
      args[0].onClick = -> cordova.InAppBrowser.open(href, '_blank')
      React.DOM.a.apply(React.DOM, args)
    else
      args[0] = R.merge({target:'_blank'}, args[0])
      React.DOM.a.apply(React.DOM, args)
  else
    React.DOM.span.apply(React.DOM, args)

@placeName = (place) ->
  s = place.name
  if city = place.location?.city
    s += ', ' + city
  else if neighborhood = place.location?.neighborhood
    s += ', ' + neighborhood
  return s