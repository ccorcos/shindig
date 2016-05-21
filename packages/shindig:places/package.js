Package.describe({
  name: 'shindig:places',
  summary: 'Places for Shindig',
  version: '0.0.1',
  git: 'https://github.com/ccorcos/shindig'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use(['coffeescript']);
  api.addFiles(['places.coffee', 'globals.js'], 'client');
  api.export(['Places'], 'client');
});
