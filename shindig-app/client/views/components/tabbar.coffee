pos = (i) ->
  if i is -1
    opacity: 0
  else
    value = "translate3d(#{i*100}%,0,0)"
    transform: value
    WebkitTransform: value
    MozTransform: value
    MsTransform: value

@TabBar = ReactUI.createView
  displayName: 'TabBar'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    currentTab: React.PropTypes.string.isRequired
    onSetTab: React.PropTypes.func.isRequired
    tabs: React.PropTypes.array.isRequired
    components: React.PropTypes.object
  renderTab: (name) ->
    classes = []
    classes.push "#{name}-tab tab"
    if @props.currentTab is name
      classes.push "selected"
    className = classes.join(' ')
    div
      key: name
      className: className
      onClick: => @props.onSetTab(name)
      @props.components?[name]?() or s.capitalize(name)
  render: ->
    i = @props.tabs.indexOf(@props.currentTab)
    div
      className: ["tabbar row", @props.className].join(' ')
      @props.tabs.map(@renderTab)
      div
        className: "highlight"
        style: R.merge pos(i),
          width: "#{100/@props.tabs.length}%"
        div
          className: "bar"

@TabBarMobile = ReactUI.createView
  displayName: 'TabBarMobile'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    currentTab: React.PropTypes.string.isRequired
    onSetTab: React.PropTypes.func.isRequired
  render: ->
    TabBar R.merge @props,
      className: 'tabbar-mobile'
      tabs: ['events', 'profile', 'users', 'facebook']
