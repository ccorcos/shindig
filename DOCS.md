# Documentation

- digital ocean droplet

[LINK]

- ssh shindig-app

ssh root@[IP]

- ssh shindig-stats

ssh root@[IP]

- password

[PASS]

- service statuses

service --status-all

- neo4j browser

[IP]:7474

- neo4j statuses

service neo4j-service status
service neo4j-service start
service neo4j-service restart
service neo4j-service stop

- neo4j conf

vim /var/lib/neo4j/conf/neo4j-server.properties

- check neo4j connection

curl --user neo4j:[PASSWORD] http://[IP]:7474/db/data/

- neo4j_url

http://neo4j:[PASSWORD]@[IP]:7474/db/data/

- neo4j data

/var/lib/neo4j/data/graph.db

- mongo statuses

service mongod status
service mongod start
service mongod restart
service mongod stop

- mongo shell

mongo --host [IP] --port 27017 -u mongo -p [PASSWORD] shindig-app

- mongo conf

vim /etc/mongod.conf

- mup commands

mup logs -g
mup logs -n 100
mup deploy

- server commands

start shindig-app
stop shindig-app
tail -f /var/log/upstart/shindig-app.log
> /var/log/upstart/shindig-app.log


[sikka]: https://github.com/meteorhacks/sikka
[sikka dev]: https://www.google.com/recaptcha/admin#site?setup
[sikka prod]: https://www.google.com/recaptcha/admin#site?setup
[dns]: https://domains.google.com/registrar#chp=d,z&d=findashindig.com&z=a
[kadira docs]: https://github.com/meteorhacks/kadira
[kadira dev]: https://ui.kadira.io/apps/dashboard/overview
[kadira prod]: https://ui.kadira.io/apps/dashboard/overview
[facebook docs]: https://developers.facebook.com/docs/graph-api/reference
[facebook graph explorer]: https://developers.facebook.com/tools/explorer
[facebook prod]: https://developers.facebook.com/apps/dashboard/
[facebook dev]: https://developers.facebook.com/apps/dashboard/
[google maps keys]: https://console.developers.google.com/project/events-979/apiui/credential
[google maps docs]: https://developers.google.com/maps/documentation/javascript/reference?hl=en
[google analytics]: https://analytics.google.com/analytics/web/#report/visitors-overview/
[heap analytics]: https://heapanalytics.com/app/event

- Using Google Domains for DNS
  - [findashindig.com config][dns]
- [sikka] for rate-limiting and DDOS protection.
  - Google reCaptcha accounts
    - [shindig-app-dev][sikka dev]
    - [shindig-app-prod][sikka prod]
- [kadira][kadira docs] for performance monitoring
  - [shindig-app-dev][kadira dev]
  - [shindig-app-prod][kadira prod]
- Facebook Graph API ([docs][facebook docs]) ([graph explorer][facebook graph explorer])
  - [shindig-dev][facebook dev]
  - [shindig-prod][facebook prod]
- Google Maps API ([docs][google maps docs])
  - [dev and prod browser keys][google maps keys]
- Analytics
  - [google analytics]
  - [heap analytics]

- deploy

mup setup
mup deploy

- backing up neo4j

```sh
ssh root@[IP]


stop shindig-app
service neo4j-service stop

cp -r /var/lib/neo4j/data ~/backup

service neo4j-service start
start shindig-app

scp root@[IP]:~/backup ~/shindig-backups/2015-10-15/
```

- to update ios

(bump the version in mobile config)
build
open the xcode project
Product > Archive
upload to app store
go to itunes connect

- to update android

make sure ~/.keystore is the same as the one here
don't lose this or you cant update the App. password is shindig

this is how I made the keystore
keytool -genkey -alias shindig -keyalg RSA -keysize 2048 -validity 10000

(bump the version in mobile config)
build
cd build/v0.2.1/android/

jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 project/build/outputs/apk/android-armv7-release-unsigned.apk shindig

~/.meteor/android_bundle/android-sdk/build-tools/21.0.0/zipalign 4 ~/Code/meteor/shindig/build/v0.2.1/android/project/build/outputs/apk/android-armv7-release-unsigned.apk ~/Code/meteor/shindig/build/v0.2.1/android/production.apk
