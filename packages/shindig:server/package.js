Package.describe({
  name: 'shindig:server',
  summary: 'Server interface for Shindig',
  version: '0.0.1',
  git: 'https://github.com/ccorcos/shindig'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');

  api.use(['shindig:lib']);
  api.imply(['shindig:lib']);

  api.addFiles(['latency.coffee'])

  api.addFiles([
    'neo4j/queries.coffee',
    'neo4j/examples.coffee',
    'neo4j/benchmark.coffee',
    'neo4j/seed.coffee',
    'analytics.coffee',
    'crawl.coffee',
    'publish.coffee',
  ], 'server');

  api.addFiles([
    'stores/fb-stores.coffee',
    'stores/sub-stores.coffee',
  ], 'client');

  api.addFiles([
    'update.coffee',
    'methods.coffee',
  ]);
});
