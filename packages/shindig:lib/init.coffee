if Meteor.isServer
  Neo4j.queries = {}
  Neo4j.defineQuery = (name, func) ->
    Neo4j.queries[name] = func
    Neo4j[name] = -> Neo4j.query func.apply(null, arguments)

if format = Meteor.settings.public?.calendar_format
  moment.locale 'en', {calendar: format}
