# db benchmark
# sessions / hr
# stars / hr
# follows / hr

Meteor.methods Meteor.settings.public?.charts.reduce (acc={}, name) ->
  acc[name] = ->
    this.unblock()
    if Meteor.isServer
      if name of Neo4j
        Neo4j[name]()
      else
        console.warn "Neo4j.#{name} not found!"
  return acc
, {}
