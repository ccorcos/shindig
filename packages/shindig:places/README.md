# Places

This package uses Google Maps API to goecode and reverse-geocode.

Expects the following Meteor settings:

```json
{
  "public": {
    "google_browser_api_key": "xxx",
  }
}
```

To get an API key, create a project [here](https://console.developers.google.com/project).
Then in "APIs & auth / APIs", enable "Google Maps JavaScript API v3".
Then in "APIs & auth / Credentials", create a "browser" API key.

Without an API key, this package resorts to `v=3.exp` which will allow you
to use google maps in development.

Right now this package only works on the client.

## Documentation

- `Places.searchPlaces`
    Uses `autocomplete.getPlacePredictions` to return an array of place predictions ([docs](https://developers.google.com/maps/documentation/javascript/places-autocomplete)).
    ```coffee
    Places.searchPlaces {input:'los angeles', types:['(cities)']}, (results) ->
    ```

- `Places.fetchPlaceDetails`
    Uses `place.getDetails` to lookup details about a place given a placeId ([docs](https://developers.google.com/maps/documentation/javascript/places)).
    ```coffee
    Places.fetchPlaceDetails place_id, (details) ->
    ```

- `Places.searchCity`
    Searched for a city using a combination of `searchPlaces` and `fetchPlaceDetails`.
    ```coffee
    Places.searchCity 'los angles', ({name: "Los Angeles, CA", lat, lng}) ->
    ```

- `Places.geocode`
    Uses `.geocoder.goecode` to get a place for a set of coordinates
    ([docs](https://developers.google.com/maps/documentation/javascript/geocoding)).
    ```coffee
    Places.geocode latitude, longitude, ([result]) ->
    ```

- `Places.currentCity`
    Uses `navigator.geolocation.getCurrentPosition` and `Places.geocode` to lookup
    a current location.
    ```coffee
    Places.currentCity ({name, lat, lng}) ->
    ```
