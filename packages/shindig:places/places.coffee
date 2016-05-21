once = (f) ->
  called = false
  (args...) ->
    unless called
      called = true
      f.apply(this, args)

@Places = Places = {}

Meteor.startup ->
  apiKey = Meteor.settings.public?.google_browser_api_key
  Places.init(apiKey)

Places.init = once (apiKey) ->
  key = if apiKey then "key=#{apiKey}" else "v=3.exp"
  unless apiKey
    console.warn "Using Google without an API key: v=3.exp"
  script = document.createElement('script')
  script.type = 'text/javascript'
  script.src = "https://maps.googleapis.com/maps/api/js?#{key}&libraries=places&callback=Places.onLoad"
  document.body.appendChild(script)

Places.onLoad = once ->
  Places.autocomplete = new google.maps.places.AutocompleteService()
  Places.geocoder = new google.maps.Geocoder()
  Places.places = new google.maps.places.PlacesService(document.createElement('div'))

alertUnlessOk = (f) ->
  (results, status) ->
      # if status isnt "OK"
      #   alert(status)
      f(results)

# Uses getPlacePredictions to return an array of place predictions.
# https://developers.google.com/maps/documentation/javascript/places-autocomplete
# Ex: Places.searchPlaces {input:'los angeles', types:['(cities)']}, (results) ->
Places.searchPlaces = (options, callback) ->
  Places.autocomplete.getPlacePredictions(options, alertUnlessOk(callback))

# Get details about a specific place
# Ex: Places.fetchPlaceDetails result.place_id, (details) ->
Places.fetchPlaceDetails = (placeId, callback) ->
  Places.places.getDetails({placeId}, alertUnlessOk(callback))

# Search for city information
# Ex: Places.searchCity 'los angles', ({name: "Los Angeles, CA", lat, lng}) ->
Places.searchCity = (query, callback) ->
  Places.searchPlaces {input:query, types:['(cities)']}, ([result]=[]) ->
    if result
      Places.fetchPlaceDetails result.place_id, (details) ->
        name = details.formatted_address.replace(', USA', '')
        lat = details.geometry.location.lat()
        lng = details.geometry.location.lng()
        callback({name, lat, lng})
    else
      callback(result)

# Get google place for lat lng
# Ex: Places.geocode latitude, longitude, ([result]) ->
Places.geocode = (lat, lng, callback) ->
  latLng = new google.maps.LatLng(lat, lng)
  Places.geocoder.geocode({latLng}, alertUnlessOk(callback))

# Places.currentCoords = (callback) ->
#   if navigator.geolocation
#     navigator.geolocation.getCurrentPosition (position) ->
#       callback
#         lat: position.coords.latitude
#         lng: position.coords.longitude
#   else
#     callback()

Places.currentCity = (callback) ->
  if navigator.geolocation
    success = (position) ->
      # Get city name from google
      lat = position.coords.latitude
      lng = position.coords.longitude
      Places.geocode lat, lng, ([result]=[]) ->
        if result
          name = result.address_components[3].long_name + ', ' + result.address_components[5].short_name
          callback({name, lat, lng})
        else
          callback()

    failure = ->
      callback()

    options =
      timeout: 1000*20 # wait 10 second unless failure
      maximumAge: 1000*1 # current position is saved for 1 second

    navigator.geolocation.getCurrentPosition(success, failure, options)
  else
    callback()
