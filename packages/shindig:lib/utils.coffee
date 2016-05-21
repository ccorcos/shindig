if Meteor.isServer
  S.str = Neo4j.stringify
  S.regex = Neo4j.regexify


# for manipulating documents before publishing
S.fixId = (obj) ->
  obj._id = obj.id
  delete obj.id
  return obj
S.fixIds = (list) -> list.map(S.fixId)
S.idList = (list) -> list.map (_id) -> {_id}

S.getHosts = (event) ->
  R.uniqWith(R.prop('id'), [event.owner].concat(event.admins?.data or []))

S.sameDay = (start, end) ->
  a = start.clone()
  b = end.clone()
  a.format('MMMM DD YYYY') is b.format('MMMM DD YYYY')

S.sameEvening = (start, end) ->
  a = start.clone()
  b = end.clone()
  S.sameDay(start, end) or S.sameDay(a, b.subtract(4, 'hours'))

S.toNextHalfHour = (date) ->
  roundTo = 30 * 60 * 1000 # next half-hour
  moment(Math.ceil((date.valueOf() - 1000*60) / roundTo) * roundTo)

S.nextHalfHourStamp = ->
  S.toNextHalfHour(moment()).valueOf()

S.calendarRange = (start, end, timezone) ->
  str = "unknown date"
  start = moment(start)
  if timezone then start.tz(timezone)

  if end
    end = moment(end)
    if timezone then end.tz(timezone)

    if S.sameEvening(start, end)
      str = start.calendar()
      if start.format('a') is end.format('a')
        str = str.replace(start.format('a'), '')
      str += '-'+end.format('h:mma')
    else
      str = start.calendar() + ' - ' + end.calendar()
  else
    str = moment(start).calendar()

  if start.utcOffset() isnt moment().utcOffset()
    str += ' '
    str += start.format('z')

  return str
