Package.describe({
  name: 'shindig:facebook',
  summary: 'Facebook for Shindig',
  version: '0.0.1',
  git: 'https://github.com/ccorcos/shindig'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  var packages = [
    'coffeescript',
    'accounts-facebook',
    'service-configuration',
    'http',
    'shindig:device'
  ];
  api.use(packages);
  api.imply(packages);
  api.addFiles([
    'globals.js',
    'facebook-init.coffee',
    'facebook-login.coffee',
    'facebook-api.coffee',
  ]);
  api.export(['facebook']);
});
