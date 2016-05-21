if Meteor.isClient
  SIM_DELAY_CLIENT = Meteor.settings.public?.simulate_client_delay_ms or 0
  if SIM_DELAY_CLIENT > 0
    fbApi = facebook.api.bind(facebook)
    facebook.api = (httpMethod, path, params={}, callback) ->
      fbApi httpMethod, path, params, (err, result) ->
        Meteor.setTimeout(callback.bind(null, err, result), SIM_DELAY_CLIENT)

if Meteor.isServer
  SIM_DELAY_SERVER = Meteor.settings.public?.simulate_server_delay_ms or 0
  if SIM_DELAY_SERVER > 0
    query = Neo4j.query.bind(Neo4j)
    Neo4j.query = (string, params) ->
      Meteor._sleepForMs(SIM_DELAY_SERVER)
      query(string, params)
