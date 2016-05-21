@Login = ReactUI.createView
  displayName: 'Login'
  mixins: [
    React.addons.PureRenderMixin
    # ViewMixin({clearRightButton:true})
  ]
  propTypes:
    setUser: React.PropTypes.func.isRequired
  getInitialState: ->
    {error: null, loading: false}
  componentWillMount: ->
    @login = ReactUI.debounce =>
      Tracker.afterFlush =>
        cancel = ReactUI.hesitate 100,
          => @setState({loading: true}) unless Meteor.isCordova
        facebook.login (user, err) =>
          cancel()
          if err
            @setState({error:err.reason, loading: false})
          else
            @props.setUser(user)
  render: ->
    div
      className:'login view'
      Transition
        transitionName:'login-loading'
        transitionAppear:true
        cond @state.loading,
          => div
            className: 'spinner-wrapper'
            key: 'loading'
            Spinner()
          => div
            className: 'login-wrapper'
            key: 'login-form'
            div
              className: 'login-inner'
              "Please login with",
              img
                src:'/images/facebook.png',
                className:'facebook'
                onClick: @login
            div
              className: 'error-wrapper'
              Transition
                transitionName:'login-error'
                transitionAppear:true
                cond @state.error,
                  => div
                    key: @state.error
                    className:'error'
                    @state.error
