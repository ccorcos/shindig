###
The goal here is to create a responsive layout for the app demonstrated here:
http://codepen.io/ccorcos/pen/jPzNpP
###

NavBarSmall = ReactUI.createView
  displayName: 'NavBarSmall'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    leftButtonProxy: React.PropTypes.func
    rightButtonProxy: React.PropTypes.func
  render: ->
    div
      className:'navbar small rel'
      div
        className: 'navbar-inner row abs'
        div
          className:'left rel'
          @props.leftButtonProxy?({
            className:'abs center'
            transitionName:'nav-left'
          })
        div
          className:'title full rel center'
          div {},
            # "Shindig"
            Logo()
        div
          className:'right rel'
          @props.rightButtonProxy?({
            className:'abs center'
            transitionName:'nav-right'
          })

NavBarLarge = ReactUI.createView
  displayName: 'NavBarLarge'
  mixins: [React.addons.PureRenderMixin]
  render: ->
    div
      className: 'navbar large rel'
      div
        className: 'navbar-inner row abs'
        div
          className: 'title row full'
          Logo
            onClick: => @props.onSetTab('events')
        div
          className: 'tabbar-wrapper rel'
          @props.children


Gutter = ReactUI.createView
  displayName: 'Gutter'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    className: React.PropTypes.string
  render: ->
    div
      className: 'gutter large full rel'
      div
        className: @props.className
        @props.children

@Layout = ReactUI.createView
  displayName: 'Layout'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    currentTab: React.PropTypes.string
    modalProxy: React.PropTypes.func
    leftButtonProxy: React.PropTypes.func
    rightButtonProxy: React.PropTypes.func
    onSetTab: React.PropTypes.func
    tabButtons: React.PropTypes.array
    bare: React.PropTypes.bool
  componentWillMount: ->
    @BackdropProxy = ReactUI.createProxy (x) ->
      if x
        div
          className: 'backdrop abs'
      else
        return
  render: ->
    div
      className: 'layout abs col'
      NavBarSmall
        leftButtonProxy: @props.leftButtonProxy
        rightButtonProxy: @props.rightButtonProxy
      NavBarLarge
        onSetTab: @props.onSetTab
        Transition
          transitionName: 'large-tabbar-transition'
          transitionAppear: true
          cond not @props.bare,
            => TabBarMobile
              key: 'tabbar'
              currentTab: @props.currentTab
              onSetTab: @props.onSetTab
      div
        className: 'layout-inner full col rel'
        div
          className: 'content full rel'
          @props.children
        div
          className: 'left-gutter large'
          div
            className: 'inner-gutter rel'
            div
              className: 'left rel'
              @props.leftButtonProxy?({
                className:'abs center', transitionName:'nav-left'
              })
        div
          className: 'right-gutter large'
          div
            className: 'inner-gutter rel'
            div
              className: 'right rel'
              @props.rightButtonProxy?({
                className:'abs center'
                transitionName:'nav-right'
              })
      div
        className: 'small tabbar-wrapper rel'
        Transition
          transitionName: 'small-tabbar-transition'
          transitionAppear: true
          cond not @props.bare,
            => TabBarMobile
              key: 'tabbar'
              currentTab: @props.currentTab
              onSetTab: @props.onSetTab
      div
        className: 'responsive-modals'
        div
          className: 'modal'
          @BackdropProxy
            transitionName: 'modal-backdrop'
            transitionAppear: true
          @props.modalProxy?({
            renderProxy: @BackdropProxy.render
            transitionName: 'modal'
            transitionAppear: true
          })
