facebook.appId = Meteor.settings.public?.facebook?.app_id
facebook.permissions = Meteor.settings.public?.facebook?.permissions
if Meteor.isServer
  facebook.secret = Meteor.settings.facebook_secret
