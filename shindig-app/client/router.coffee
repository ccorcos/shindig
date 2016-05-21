###
A route looks something like this:

route =
  name: '/user/:id'
  path: '/user/234r234fced'
  params: {}
  queryParams: {}
  hash: ''

We have one entry point to this program starting with
the url. After that the views are managed within the
view controllers and urls just follow along.
###


start = do ->
  called = false
  (f) ->
    unless called
      called = true
      f()

defineRoute = (name, tab) ->
  Router.route name, (initialRoute) ->
    start ->
      initialRoute.tab = tab
      React.render(App({initialRoute, instance: ReactUI.instance}), document.body)

defineRoute '/', 'events'
defineRoute '/profile', 'profile'
defineRoute '/users', 'users'
defineRoute '/facebook', 'facebook'
defineRoute '/user/:id', 'hidden'
defineRoute '/user/:id/follows', 'hidden'
defineRoute '/user/:id/followers', 'hidden'
defineRoute '/event/:id', 'hidden'
defineRoute '/event/:id/stargazers', 'hidden'
defineRoute '/event/:id/followed-stargazers', 'hidden'

Router.route '/playground', -> start -> React.render(Playground(), document.body)

# Capture the 404 last (the order matters!)
defineRoute '*', "hidden"
