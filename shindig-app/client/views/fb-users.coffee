@Facebook = ReactUI.createView
  displayName: 'Facebook'
  mixins: [
    React.addons.PureRenderMixin
    ReactUI.InstanceMixin
    ViewPropsMixin
    ViewMixin({clearRightButton:true})
  ]
  getInitialState: ->
    U.defaults @props.instance.state,
      tab: 'users'
      search: ''
  componentWillMount: ->
    @inputs = [{
      name: 'tab'
      component: SwitchInput
      props:
        initialValue: @state.tab
        values: ['users', 'pages']
    }, {
      name: 'search'
      component: SearchInput
      props:
        initialValue: @state.search
    }]
  save: ->
    state: @state
  onChange: (nextState) ->
    @setState(nextState)
  renderEmpty: ->
    span
      className: 'empty'
      'Sorry, no users...'
  render: ->
    store = facebook[@state.tab]
    div
      className: 'facebook view'
      Filters
        initialToolbarOpen: true
        canToggleToolbar: false
        renderRightButton: @props.renderRightButton
        instance: @childInstance('filters')
        onChange: @onChange
        inputs: @inputs
      div
        className: 'full rel'
        Transition
          transitionName: 'tabvc'
          MetaUserList
            key: @state.search + @state.tab
            className: 'abs'
            fbId: @props.fbId
            query: {query: @state.search}
            store: store
            instance: @childInstance(@state.tab + '-list')
            push: @props.push
            renderEmpty: @renderEmpty
            renderLoadMore: Down
