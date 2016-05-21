
React.initializeTouchEvents(true)
# Add listener to get :active pseudoselector working. hack
document.addEventListener("touchstart", (()->), false)
# also need cursor:pointer to work on mobile to touch click
@createView = (spec) -> React.createFactory(React.createClass(spec))
# We may want to override this at some point with a better version that is more reliable.
@Transition = React.createFactory(React.addons.CSSTransitionGroup)
# Global components
{@div, @span, @input, @img, @button, @svg} = React.DOM
# this makes your react code look beautiful
@cond = (condition, result, otherwise) -> if condition then result?() else otherwise?()

Meteor.startup ->
  React.render(App(), document.body)

App = createView
  displayName: 'App'
  render: ->
    div
      className: 'app'
      Meteor.settings.public?.charts.map (name) ->
        MetaTimeChart
          method: name
          key: name


MetaTimeChart = createView
  displayName: 'MetaTimeChart'
  getInitialState: -> {loading: true}
  componentWillMount: ->
    Meteor.call @props.method, (err, data) =>
      console.log data
      @setState({data, loading: false})
  render: ->
    if @state.loading
      div
        className: 'meta-chart'
        'loading...'
    else
      div
        className: 'meta-chart'
        TimeChart
          title: @props.method
          data: @state.data

TimeChart = createView
  displayName: 'TimeChart'
  componentDidMount: ->
    margin =
      top: 30
      right: 30
      bottom: 30
      left: 30
    width = 960 - (margin.left) - (margin.right)
    height = 500 - (margin.top) - (margin.bottom)
    parseDate = d3.time.format('%I:%M %p %a %Y').parse
    x = d3.time.scale().range([0, width])
    y = d3.scale.linear().range([height, 0])
    xAxis = d3.svg.axis().scale(x).orient('bottom')
    yAxis = d3.svg.axis().scale(y).orient('left')
    svg = d3.select(@refs['chart'].getDOMNode())
      .append('svg')
      .attr('viewBox', "0 0 #{width + margin.left + margin.right} #{height + margin.top + margin.bottom}")
      .append('g').attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

    line = d3.svg.line()
      .x((d) -> x(d.time))
      .y((d) -> y(d.count))

    data = @props.data.map ([time, count]) ->
      time: new Date(time)
      count: count or 0

    x.domain(d3.extent(data, (d) -> d.time))
    y.domain(d3.extent(data, (d) -> d.count))

    svg.append('g')
      .attr('class', 'x axis')
      .attr('transform', 'translate(0,' + height + ')').call(xAxis)
    svg.append('g')
      .attr('class', 'y axis')
      .call(yAxis).append('text')
      .attr('y', 6).attr('dy', '1em').attr('dx', '2em')
      .style('font-size', '2em')
      .style('font-weight', 'bold')
      .text(@props.title)
    svg.append('path').datum(data).attr('class', 'line').attr('d', line)
  render: ->
    div
      className: 'chart'
      ref: 'chart'
