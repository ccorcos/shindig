if Meteor.isServer
  ServiceConfiguration.configurations.upsert
    service: 'facebook'
  , $set:
      appId: facebook.appId,
      secret: facebook.secret

# facebook login / logout
# There are two types of login styles "popup" and "redirect"
# - popup is good for the web
# - redirect is good for cordova / mobile
# When using "popup" style, then loginWithFacebook(options, callback)
# callback works. When using "redirect", you must use the
# Accounts.onLogin(callback) and Accounts.onLoginFailure(callback)
# callbacks

loginStyle = ->
  if Device.iOS() or Device.Safari() or Device.Android()
    return 'redirect'
  else
    return 'popup'

if Meteor.isClient
  facebook.login = (callback) ->
    done = U.timeoutCallback(60*1000, callback)
    Meteor.loginWithFacebook
      requestPermissions: facebook.permissions
      loginStyle: loginStyle()
    , (err) -> done(Meteor.user(), err)

  facebook.logout = (callback) ->
    Meteor.logout (err) ->
      if err then callback?(null, err) else callback?()

  facebook.userId = () ->
    Meteor.user()?.services?.facebook?.id

facebook.getFbId = (user) ->
  user?.services?.facebook?.id

facebook.lookupFbId = (userId) ->
  Meteor.users.findOne(userId)?.services?.facebook?.id

if Meteor.isServer
  # create a facebook id index
  Meteor.users._ensureIndex({'services.facebook.id': 1}, {unique: true})
  Meteor.users._ensureIndex({'services.facebook.id': 1, 'services.facebook.expiresAt': 1})

  # publish some appropiate facebook fields
  Meteor.publish null, ->
    Meteor.users.find
      _id: this.userId
    , fields:
        'services.facebook.accessToken': 1
        'services.facebook.id': 1
        'services.facebook.name': 1

# if Meteor.isServer
#   # whitelisting and blacklisting users for your platform
#   whiteListed = (user) ->
#     # throw new Meteor.Error(403, "This user has not been whitelisted")
#     return true
#   blackListed = (user) ->
#     # throw new Meteor.Error(403, "This user has not been blacklisted")
#     return false
#   Accounts.validateNewUser (user) ->
#     # console.log("validateNewUser", JSON.stringify(user))
#     return whiteListed(user) and not blackListed(user)
#   Accounts.validateLoginAttempt (attempt) ->
#     # console.log("validateLoginAttempt", JSON.stringify(attempt))
#     return whiteListed(attempt.user) and not blackListed(attempt.user)

# Facebook API integration
facebook.getAccessToken = ->
  if Meteor.isClient
    user = Meteor.user()
    if Meteor.loggingIn() and not user
      throw Meteor.Error(10, "You can't get the user access token while the " +
        "user is still logging in.")
    else if not user
      throw Meteor.Error(11, "You can't get the user access token until the " +
        "user has logged in.")
    else
      return user.services.facebook.accessToken

  if Meteor.isServer
    return facebook.appId + '|' + facebook.secret

if Meteor.isServer
  facebook.getUserAccessToken = (fbId) ->
    Meteor.users.findOne({
      'services.facebook.id':fbId
      'services.facebook.expiresAt': {
        $gt: U.timestamp()
      }
    })?.services?.facebook?.accessToken
