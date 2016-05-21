###
This app is a classic tab-nav layout. The tabs are:
- feed: a list of events :HOSTS or :STARS by :USER that is :FOLLOWS by this user
- explore: a list of the most popular events
- profile: a list of all event :HOSTS or :STARS by this user
- search: search facebook users, pages, groups, events
###

@App = ReactUI.createView
  displayName: 'App'
  mixins: [
    React.addons.PureRenderMixin,
    ReactUI.InstanceMixin,
    ReactUI.AutorunMixin
  ]
  propTypes:
    # The initialRoute must contain a "tab" property
    initialRoute: React.PropTypes.object.isRequired
    instance: React.PropTypes.object.isRequired
  getInitialState: ->
    U.defaults @props.instance.state,
      currentTab: @props.initialRoute.tab
      waiting: true
      loading: false
      user: null
  save: ->
    state: R.pick(['currentTab'], this.state)
  componentWillMount: ->
    @logout =  ReactUI.debounce(@setLoggedOut)
    @RightButtonProxy = ReactUI.createProxy()
    @ModalProxy = ReactUI.createProxy()
    @LeftButtonProxy = ReactUI.createProxy ({pop, popFront}) =>
      if popFront
        @popFront = popFront
      else
        @popFront = undefined
      if pop
        Back
          # XXX func ref
          key: 'back'
          onClick: ReactUI.debounce(pop)
      else
        return
    @setTab = ReactUI.debounce (name) =>
      if @state.currentTab is name
        @popFront?()
      @setState
        currentTab: name

    # generate the tab buttons
    createTabButton = (name) ->
      name: name
      component: div
        onClick: -> setTab(name)
        name
    @tabButtons = [
      'events'
      'profile'
      'users'
      'facebook'
    ].map(createTabButton)
    # we want to show a loading screen if we havent resolved the logged in
    # user within 100 ms.
    cancel = ReactUI.hesitate 100, =>
      @setState
        loading: true
        waiting: false
    ReactUI.waitForUser (user) =>
      cancel()
      if user
        @setLoggedIn(user)
      else
        @setLoggedOut()
  setLoggedIn: (user) ->
    @setState
      user: user
      loading: false
      waiting: false
    # watch for the user to logout and any changes to the user object
    @autorun (c) =>
      user = Meteor.user()
      if user and not c.firstRun
        @setState({user})
      else if not user
        @setLoggedOut()
        c.stop()
  setLoggedOut: () ->
    @setState
      user:null
      loading: false
      waiting: false
  renderScene: (route, instance, push, pop, popFront) ->
    # render a scene within a nav controller
    # push will push a route to the nav controller
    {path, name, params} = route
    # current logged in user if
    fbId = facebook.getFbId(@state.user)
    props =
      fbId: fbId
      key: path
      push: push
      path: path
      instance: instance
      renderModal: @ModalProxy.render
      renderRightButton: @RightButtonProxy.render

    if name is '/'
      return Events(props)

    if name is '/profile'
      return User(R.merge({userId: fbId, onLogout: @logout}, props))

    if name is '/facebook'
      return Facebook(props)

    if name is '/users'
      return Users(props)

    if name is '/event/:id'
      return MetaEvent(R.merge({eventId: params.id}, props))

    if name is '/user/:id'
      return User(R.merge({userId: params.id}, props))

    if name is '/user/:id/follows'
      return FollowsList(R.merge({userId: params.id}, props))

    if name is '/user/:id/followers'
      return FollowersList(R.merge({userId: params.id}, props))

    if name is '/event/:id/stargazers'
      return StargazersList(R.merge({eventId: params.id}, props))

    if name is '/event/:id/followed-stargazers'
      return FollowedStargazersList(R.merge({eventId: params.id}, props))

    return (div {}, '404')
  renderTab: (tab, instance) ->

    props =
      instance: instance
      popProxy: @LeftButtonProxy
      renderScene: @renderScene

    if tab is 'events'
      return ReactUI.NavVC(R.merge(props, {
        key: 'events-tab'
        rootScene: {path: '/', name: '/'}
      }))

    if tab is 'profile'
      return ReactUI.NavVC(R.merge(props, {
        key: 'profile-tab'
        rootScene: {path: '/profile', name: '/profile'}
      }))

    if tab is 'users'
      return ReactUI.NavVC(R.merge(props, {
        key: 'users-tab'
        rootScene: {path: '/users', name: '/users'}
      }))

    if tab is 'facebook'
      return ReactUI.NavVC(R.merge(props, {
        key: 'facebook-tab'
        rootScene: {path: '/facebook', name: '/facebook'}
      }))

    if tab is 'hidden'
      return ReactUI.NavVC(R.merge(props, {
        key: 'hidden-tab'
        rootScene: @props.initialRoute
      }), 'hidden')

    console.warn("Unknown tab:", tab)
  render: ->
    if @state.waiting
      Layout
        bare: true
    else if @state.loading
      Layout
        bare: true
        Transition
          transitionName: 'content-transition'
          transitionAppear: true
          Loading
            key: 'loading'
    else if not @state.user
      Layout
        bare: true
        Transition
          transitionName: 'content-transition'
          transitionAppear: true
          Login
            key: 'login'
            setUser: @setLoggedIn
    else
      Layout
        currentTab: @state.currentTab
        modalProxy: @ModalProxy
        leftButtonProxy: @LeftButtonProxy
        rightButtonProxy: @RightButtonProxy
        onSetTab: @setTab
        tabButtons: @tabButtons
        Transition
          transitionName: 'content-transition'
          transitionAppear:true
          ReactUI.TabVC
            key: 'tab-vc'
            currentTab: @state.currentTab
            renderTab: @renderTab
            instance: @childInstance('tabvc')
