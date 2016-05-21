  * `Neo4j.getEvents`

 - by id

 MATCH (e:EVENT {id: '1442336736094604' })
 WITH DISTINCT e as events
 RETURN events.id

  enchmark: 0.005 s

  -by id with fields

MACH (e:EVENT {id: '1442336736094604' })
 WITH DISTINCT e as events
 OPTIONAL MATCH (u:USER)-[s:STARS]->(events)
 WITH events, count(s) as starCount
 OPTIONAL MATCH (:USER {id: '10205633768661272' })-[:FOLLOWS]->(u:USER)-[s:STARS]->(events)
 WITH events, starCount, count(s) as followedStarCount
 OPTIONAL MATCH (:USER {id: '10205633768661272' })-[s:STARS]->(events)
 WITH events, starCount, followedStarCount, count(s)>0 as starred
 RETURN events.id, starCount, followedStarCount, starred

  benchmark: 0.007 s

  - feed by time

  MATCH (:USER {id: '10205633768661272' })-[:FOLLOWS]->(:USER)-[s:HOSTS|STARS]->(e:EVENT)
 WITH DISTINCT e as events
 RETURN events.id
 ORDER BY events.start_time
 LIMIT 10

  benchmark: 0.015 s

  - feed by popular

  MATCH (:USER {id: '10205633768661272' })-[:FOLLOWS]->(:USER)-[s:HOSTS|STARS]->(e:EVENT)
 WHERE e.start_time > 1440564771147
 WITH DISTINCT e as events, count(s) AS edges
 WITH events, edges, (events.start_time - 1440564771147)/(1000*60*60) as dt
 WITH events, edges, dt, edges/(dt*1.0+1.0) + edges/6.0 as score
 RETURN events.id
 ORDER BY score DESC
 LIMIT 10

  benchmark: 0.013 s

  - feed with filters by time

  MATCH (:USER {id: '10205633768661272' })-[:FOLLOWS]->(:USER)-[s:HOSTS|STARS]->(e:EVENT)
 WHERE e.start_time > 1440564771147
   AND e.name =~ '(?i).*re.*'
   AND e.latitude < 34.845439
   AND e.latitude > 32.845439
   AND e.longitude < -117.379374
   AND e.longitude > -119.379374
 WITH DISTINCT e as events
 RETURN events.id
 ORDER BY events.start_time
 LIMIT 10

  benchmark: 0.009 s

  - feed with filters by popular

  MATCH (:USER {id: '10205633768661272' })-[:FOLLOWS]->(:USER)-[s:HOSTS|STARS]->(e:EVENT)
   AND e.latitude < 34.845439
 WHERE e.start_time > 1440564771147
   AND e.name =~ '(?i).*re.*'
   AND e.latitude > 32.845439
   AND e.longitude < -117.379374
   AND e.longitude > -119.379374
 WITH DISTINCT e as events, count(s) AS edges
 WITH events, edges, (events.start_time - 1440564771147)/(1000*60*60) as dt
 WITH events, edges, dt, edges/(dt*1.0+1.0) + edges/6.0 as score
 RETURN events.id
 ORDER BY score DESC
 LIMIT 10

  benchmark: 0.008 s

  - user events by time

  MATCH (:USER {id: '10205633768661272' })-[s:HOSTS|STARS]->(e:EVENT)
 WITH DISTINCT e as events
 RETURN events.id
 ORDER BY events.start_time
 LIMIT 10

  benchmark: 0.009 s

  - user events by popular

  MATCH (:USER {id: '10205633768661272' })-[s:HOSTS|STARS]->(e:EVENT)
 WHERE e.start_time > 1440564771147
 WITH DISTINCT e as events, count(s) AS edges
 WITH events, edges, (events.start_time - 1440564771147)/(1000*60*60) as dt
 WITH events, edges, dt, edges/(dt*1.0+1.0) + edges/6.0 as score
 RETURN events.id
 ORDER BY score DESC
 LIMIT 10

  benchmark: 0.008 s

  - user events with filters by time

  MATCH (:USER {id: '10205633768661272' })-[s:HOSTS|STARS]->(e:EVENT)
 WHERE e.start_time > 1440564771147
   AND e.name =~ '(?i).*re.*'
   AND e.latitude < 34.845439
   AND e.latitude > 32.845439
   AND e.longitude < -117.379374
   AND e.longitude > -119.379374
 WITH DISTINCT e as events
 RETURN events.id
 ORDER BY events.start_time
 LIMIT 10

  benchmark: 0.01 s

  - user events with filters by popular

  MATCH (:USER {id: '10205633768661272' })-[s:HOSTS|STARS]->(e:EVENT)
 WHERE e.start_time > 1440564771147
   AND e.name =~ '(?i).*re.*'
   AND e.latitude < 34.845439
   AND e.latitude > 32.845439
   AND e.longitude < -117.379374
   AND e.longitude > -119.379374
 WITH DISTINCT e as events, count(s) AS edges
 WITH events, edges, (events.start_time - 1440564771147)/(1000*60*60) as dt
 WITH events, edges, dt, edges/(dt*1.0+1.0) + edges/6.0 as score
 RETURN events.id
 ORDER BY score DESC
 LIMIT 10

  benchmark: 0.01 s

  - events with filters by time

  MATCH (e:EVENT)
 WHERE e.start_time > 1440564771147
   AND e.name =~ '(?i).*re.*'
   AND e.latitude < 34.845439
   AND e.latitude > 32.845439
   AND e.longitude < -117.379374
   AND e.longitude > -119.379374
 WITH DISTINCT e as events
 RETURN events.id
 ORDER BY events.start_time
 LIMIT 10

  benchmark: 0.007 s

  - events by popular

MATCH (:USER)-[s:HOSTS|STARS]->(e:EVENT)
WHERE e.start_time > 1440564771147
WITH DISTINCT e as events, count(s) AS edges
WITH events, edges, (events.start_time - 1440564771147)/(1000*60*60) as dt
WITH events, edges, dt, edges/(dt*1.0+1.0) + edges/6.0 as score
RETURN events.id
ORDER BY score DESC
LIMIT 10

  benchmark: 0.016 s

  * `Neo4j.getUsers`

  - by id

  MATCH (u:USER {id: '14226545351' })
 WITH DISTINCT u as users
 RETURN users.id

  benchmark: 0.004 s

  - by id with fields

MATCH (u:USER {id: '14226545351' })
WITH DISTINCT u as users
OPTIONAL MATCH (:USER)-[f:FOLLOWS]->(users)
WITH users, count(f) as followerCount
OPTIONAL MATCH (users)-[f:FOLLOWS]->(:USER)
WITH users, followerCount, count(f) as followCount
OPTIONAL MATCH (:USER {id: '10205633768661272' })-[f:FOLLOWS]->(users)
WITH users, followerCount, followCount, count(f)>0 as followed
RETURN users.id, followerCount, followCount, followed

  benchmark: 0.005 s

  - follows by name

  MATCH (:USER {id: '14226545351' })-[:FOLLOWS]->(u:USER)
 WITH DISTINCT u as users
 RETURN users.id
 ORDER BY users.name
 LIMIT 10

  benchmark: 0.005 s

  - follows by popular

  MATCH (:USER {id: '14226545351' })-[:FOLLOWS]->(u:USER)
 WITH DISTINCT u as users
 OPTIONAL MATCH (:USER)-[f:FOLLOWS]->(users)
 WITH users, count(f) as followerCount
 RETURN users.id
 ORDER BY followerCount DESC
 LIMIT 10

  benchmark: 0.004 s

  - followers with filters by popular

  MATCH (:USER {id: '14226545351' })-[:FOLLOWS]->(u:USER)
 WHERE u.name =~ '(?i).*re.*'
 WITH DISTINCT u as users
 OPTIONAL MATCH (:USER)-[f:FOLLOWS]->(users)
 WITH users, count(f) as followerCount
 RETURN users.id
 ORDER BY followerCount DESC
 LIMIT 10

  benchmark: 0.005 s

  - stargazers

  MATCH (u:USER)-[s:STARS]->(:EVENT {id: '1442336736094604' })
 WHERE u.name =~ '(?i).*re.*'
 WITH DISTINCT u as users
 OPTIONAL MATCH (:USER)-[f:FOLLOWS]->(users)
 WITH users, count(f) as followerCount
 RETURN users.id
 ORDER BY followerCount DESC
 LIMIT 10

  benchmark: 0.004 s

  - followedStargazers

  MATCH (:USER {id: '10205633768661272' })-[:FOLLOWS]->(u:USER)-[s:STARS]->(e:EVENT {id: '1442336736094604' })
 WITH DISTINCT u as users
 RETURN users.id
 ORDER BY users.name
 LIMIT 10

  benchmark: 0.01 s

  - users by popular

  MATCH (u:USER)
 WITH DISTINCT u as users
 OPTIONAL MATCH (:USER)-[f:FOLLOWS]->(users)
 WITH users, count(f) as followerCount
 RETURN users.id
 ORDER BY followerCount DESC
 LIMIT 10

  benchmark: 0.019 s

  - users with filters by popular

  MATCH (:USER {id: '14226545351' })-[:FOLLOWS]->(u:USER)
 WHERE u.name =~ '(?i).*re.*'
 WITH DISTINCT u as users
 OPTIONAL MATCH (:USER)-[f:FOLLOWS]->(users)
 WITH users, count(f) as followerCount
 RETURN users.id
 ORDER BY followerCount DESC
 LIMIT 10

  benchmark: 0.005 s

  * `Neo4j.setUser`

  MERGE (u:USER {id:'1234'})
 SET u += {name:'Joe', lastSync:4321}

  benchmark: 0.008 s

  * `Neo4j.setEvent`

  MERGE (e:EVENT {id: '1234'})
 SET e += {name:'Party', lastSync:4321, start_time:100, end_time:200, latitude:30.9, longitude:-20.44}
 WITH ['99','88','77'] AS hostIds, e
 OPTIONAL MATCH (u:USER)-[r:HOSTS]->(e)
 WHERE NOT u.id IN hostIds
 DELETE r
 WITH COLLECT(u.id) AS oldHostIds, hostIds, e
 WITH FILTER(id IN hostIds WHERE NOT id IN oldHostIds) AS newHostIds, e, oldHostIds
 FOREACH (hostId IN newHostIds |
     MERGE (host:USER {id:hostId})
     MERGE (host)-[:HOSTS]->(e)
 )

  benchmark: 0.01 s

  * `Neo4j.setSession`

  MERGE (u:USER {id:'10205633768661272'})
 CREATE (s:SESSION {start_time:100, end_time:200})
 MERGE (u)-[:LOGGED_IN]->(s)

  benchmark: 0.011 s

  * `Neo4j.setFollow`

  MERGE (u:USER {id:'10205633768661272'})
 MERGE (f:USER {id:'14226545351'})
 MERGE (u)-[:FOLLOWS {createdAt:timestamp()}]->(f)

  benchmark: 0.008 s

  * `Neo4j.setUnfollow`

  MATCH (:USER {id:'10205633768661272'})-[r:FOLLOWS]->(:USER {id:'14226545351'})
 DELETE r

  benchmark: 0.006 s

  * `Neo4j.setStar`

  MERGE (u:USER {id:'10205633768661272'})
  MERGE (e:EVENT {id:'1442336736094604'})
  MERGE (u)-[:STARS {createdAt:timestamp()}]->(e)

  benchmark: 0.006 s

  * `Neo4j.setUnstar`

  MATCH (:USER {id:'10205633768661272'})-[r:STARS]->(:EVENT {id:'1442336736094604'})
 DELETE r

  benchmark: 0.006 s
