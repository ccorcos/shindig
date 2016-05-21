# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <svg width="30px" height="30px" viewBox="0 0 30 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
#     <!-- Generator: Sketch 3.3.3 (12072) - http://www.bohemiancoding.com/sketch -->
#     <title>clock</title>
#     <desc>Created with Sketch.</desc>
#     <defs></defs>
#     <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" sketch:type="MSPage">
#         <g id="clock" sketch:type="MSArtboardGroup" stroke="#000000" stroke-width="2">
#             <circle id="Oval-1" sketch:type="MSShapeGroup" cx="15" cy="15" r="12"></circle>
#             <path d="M15,14.5 L15,6" id="Line" stroke-linecap="round" sketch:type="MSShapeGroup"></path>
#             <path d="M15,14.5 L15,7.5" id="Line-Copy" stroke-linecap="round" sketch:type="MSShapeGroup"></path>
#         </g>
#     </g>
# </svg>

{svg, line, circle, path} = React.DOM

@Clock = ReactUI.createView
  displayName: 'Clock'
  mixins: [React.addons.PureRenderMixin]
  render: ->
    time = moment(@props.time)
    minDeg = time.minutes() / 60.0 * 360.0
    hrDeg = (time.hours() % 12) / 12.0 * 360.0
    svg
      onClick: this.props.onClick
      className: ['clock', @props.className].join(' ')
      viewBox: '0 0 30 30'
      strokeWidth: 2
      circle
        cx: 15
        cy: 15
        r: 12
      path
        # minute hand
        d: "M15,14.5 L15,6"
        style:
          transformOrigin: "100% 100%"
          transform: "rotate(#{minDeg}deg)"
      path
        # hour hand
        d: "M15,14.5 L15,7.5"
        style:
          transformOrigin: "100% 100%"
          transform: "rotate(#{hrDeg}deg)"
