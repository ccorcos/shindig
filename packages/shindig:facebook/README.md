# Facebook

Expects the following Meteor settings:

```json
{
  "facebook_secret": "xxx",
  "public": {
    "appId": "xxx",
    "permissions": ["xxx", "xxx", "xxx"]
  }
}
```

To get an API key, create an app [here](https://developers.facebook.com/apps/)/

## Documentation

- `facebook.appId`
- `facebook.permissions`
- `facebook.secret`
- `facebook.login(callback)`
- `facebook.logout(callback)`
- `facebook.userId()`
    Returns the facebook id of the current logged in user on the client.
- `facebook.getFbId(user)`
    Returns the facebook id given a user document from Mongo
- `facebook.lookupFbId(userId)`
    Returns the facebook id given a mongo userId
- `facebook.getAccessToken()`
    Return the current user's accessToken on the client and the app token
    on the server.
- `facebook.getUserAccessToken(fbId)`
    Attempts to get the user access token given a user's facebook id
- `facebook.api(httpMethod, path, params, callback)`
    Makes an HTTP request to the facebook graph api.
    path should be something like `/me/likes`.
    params can have an `access_token` field to override `getAccessToken()`.
    typically also has fields specified in params.
    callback is optional on the server and will wrap in a fiber.

## Tools

- Facebook Graph API Explorer
    https://developers.facebook.com/tools/explorer/1460018020982955/?method=GET&path=&version=v2.4
