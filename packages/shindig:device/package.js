Package.describe({
  name: 'shindig:device',
  summary: 'Device detection',
  version: '0.0.1',
  git: 'https://github.com/ccorcos/shindig'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use(['coffeescript']);
  api.addFiles([
    'globals.js',
    'device.coffee',
  ], 'client');
  api.export(['Device']);
});
