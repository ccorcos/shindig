moment = require 'moment'

# a simple ranking algorithm

rank = (dt, stars) -> (stars*stars / (2*dt+1))

range = (start, stop, inc) ->
  list = []
  while start <= stop
    list.push(start)
    start += inc
  return list

flatten = (list) ->
  flat = []
  for item in list
    if Object.prototype.toString.apply(item) is '[object Array]'
      flat = flat.concat(flatten(item))
    else
      flat.push(item)
  return flat

# lets think about what we'd consider reasonable.
# [dt, stars] should equal some other [dt, stars]
inputs =  [[1, 100], [2, 100], [3, 100], [4, 100], [5, 100], [6, 100], [8, 100], [12,100], [24, 100]]
targets =  [[0, 95], [0, 90],  [0, 85],  [0, 80],  [0, 70],  [0, 60],  [0, 50],  [0, 40],  [0, 30]]

console.log 'comparing inputs to targets'
for i in [0...inputs.length]
  [dt, stars] = inputs[i]
  console.log rank(inputs[i][0], inputs[i][1]), rank(targets[i][0], targets[i][1])

console.log 'an example feed'
events = flatten range(0, 48, 1).map (dt) ->
  range(0, 100, 5).map (stars) ->
    {dt, stars, score: rank(dt, stars)}

sorted = events.sort (a,b) -> b.score - a.score

for i in [0...200]
  console.log sorted[i]
