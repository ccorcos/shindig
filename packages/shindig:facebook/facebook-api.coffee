GRAPH_URL = 'https://graph.facebook.com/v2.4'

# parse the facebook response to generate a proper Meteor.Error and return
# the actual JSON data of the response.
parseFbResponse = (callback) ->
  return (err, result) ->
    if err
      {type, code, message} = err.response?.data?.error or {}
      err = new Meteor.Error(type + ' ' + code?.toString(), message)
      callback(err, null)
    else
      callback(null, result.data or result.content)

# Accessing the FB api
fbApiAsync = (httpMethod, path, params={}, callback) ->
  # you can override the access token
  if not params.access_token
    params.access_token = facebook.getAccessToken()
  HTTP.call(httpMethod, GRAPH_URL + path, {params}, parseFbResponse(callback))

# Client must use the async api
if Meteor.isClient
  facebook.api = fbApiAsync

# Server can use the async api or use fibers.
# I'm not using asyncWrap because I want to generate a proper Meteor.Error
if Meteor.isServer
  Future = Npm.require('fibers/future')
  facebook.api = (httpMethod, path, params={}, callback) ->
    if callback
      fbApiAsync(httpMethod, path, params, callback)
    else
      fut = new Future()
      fbApiAsync httpMethod, path, params
      , Meteor.bindEnvironment (err, result) ->
          if err then fut.throw(err) else fut.return(result)
      return fut.wait()

###
EXAMPLES:

client no error:
facebook.api('get', '/me', {}, function(err, result) {
  if (err) {
    throw err
  } else {
    console.log(result)
  }
})

client with error:
facebook.api('get', '/asdfasdfa', {}, function(err, result) {
  if (err) {
    throw err
  } else {
    console.log(result)
  }
})

server no error:
facebook.api('get', '/10205633768661272')
facebook.api('get', '/10205633768661272', {}, function(err, result) {
  if (err) {
  throw err
  } else {
    console.log(result)
  }
})

server with error:
facebook.api('get', '/me')
facebook.api('get', '/me', {}, function(err, result) {
  if (err) {
  throw err
  } else {
    console.log(result)
  }
})
###
