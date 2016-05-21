Package.describe({
  name: 'shindig:lib',
  summary: 'Libraries for Shindig',
  version: '0.0.2',
  git: 'https://github.com/ccorcos/shindig'
});

Package.onUse(function(api) {
  api.versionsFrom('1.2');
  var mdgPackages = [
    'meteor',
    'webapp',
    'underscore',
    'ddp',
    // 'mobile-experience',
    'fastclick',
    'mobile-status-bar',

    'crosswalk',
    'mongo',
    'static-html',

    'tracker',
    'check',
    'random',

    'standard-minifiers',
    'hot-code-push',
    'coffeescript',
    'react-runtime',
    'stylus',
    'ecmascript',
    'es5-shim',
  ]

  // you must specify versions here or it meteor will defer to the minimum
  // possible version constraint -- very weird.
  var communityPackages = [
    'meteorhacks:sikka@1.0.1',
    'meteorhacks:kadira@2.23.0',
    'momentjs:moment@2.10.6'
  ]

  var myPackages = [
    'ccorcos:utils@0.0.3',
    'ccorcos:react-ui@0.1.0',
    'ccorcos:neo4j@0.1.1',
    'ccorcos:any-db@0.1.0',
    'ccorcos:any-store@0.0.1',
    'ccorcos:client-router@0.0.4',
    'ccorcos:date-parser@0.0.2',
    'shindig:facebook@0.0.1',
  ]

  var packages = mdgPackages.concat(communityPackages).concat(myPackages)

  api.use(packages);
  api.imply(packages);

  api.addFiles([
    'globals.js',
    'utils.coffee',
    'init.coffee',
    'moment-timezone.js',
  ]);

  api.addFiles([
    'clipboard.js'
  ], 'client')

  api.export(['Shindig', 'S', 'Crawl', 'Update']);

});

Cordova.depends({
  "cordova-plugin-geolocation": "1.0.1",
  "cordova-plugin-inappbrowser": "0.5.4"
});
