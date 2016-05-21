@FollowCount = ReactUI.createView
  displayName: 'FollowCount'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    data: React.PropTypes.object
    loading: React.PropTypes.bool
  render: ->
    unverified = (if @props.data?.unverified then 'unverified' else '')
    shortcut = (if @props.data?.shortcut then 'shortcut' else '')
    cond @props.loading and not @props.data?.shortcut,
      => span
        className: 'follow-count sub loading inline'
      => span
        className: ['follow-count inline', unverified, shortcut].join(' ')
        @props.data?.followCount

@FollowerCount = ReactUI.createView
  displayName: 'FollowerCount'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    data: React.PropTypes.object
    loading: React.PropTypes.bool
  render: ->
    unverified = (if @props.data?.unverified then 'unverified' else '')
    shortcut = (if @props.data?.shortcut then 'shortcut' else '')
    cond @props.loading and not @props.data?.shortcut,
      => span
        className: 'follower-count sub loading inline'
      => span
        className: ['follower-count inline', unverified, shortcut].join(' ')
        @props.data?.followerCount

@MetaFollowCount = ReactUI.createView
  displayName: 'MetaFollowCount'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    userId: React.PropTypes.string.isRequired
    fbId: React.PropTypes.string.isRequired
  renderData: ({data, loading}) ->
    FollowCount({data:data?[0], loading})
  render: ->
    ReactUI.Data
      key: @props.userId
      query:
        userId: @props.userId
        fbId: @props.fbId
      store: Shindig.user
      render: @renderData

@MetaFollowerCount = ReactUI.createView
  displayName: 'MetaFollowerCount'
  mixins: [React.addons.PureRenderMixin]
  propTypes:
    userId: React.PropTypes.string.isRequired
    fbId: React.PropTypes.string.isRequired
  renderData: ({data, loading}) ->
    FollowerCount({data:data?[0], loading})
  render: ->
    ReactUI.Data
      key: @props.userId
      query:
        userId: @props.userId
        fbId: @props.fbId
      store: Shindig.user
      render: @renderData
