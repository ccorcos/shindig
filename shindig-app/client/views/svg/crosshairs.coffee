# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <svg width="30px" height="30px" viewBox="0 0 30 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
#     <!-- Generator: Sketch 3.3.3 (12072) - http://www.bohemiancoding.com/sketch -->
#     <title>location</title>
#     <desc>Created with Sketch.</desc>
#     <defs></defs>
#     <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" sketch:type="MSPage">
#         <g id="location" sketch:type="MSArtboardGroup" stroke="#000000" stroke-width="2">
#             <circle id="Oval-1" sketch:type="MSShapeGroup" cx="15" cy="15" r="8"></circle>
#             <path d="M15,10.5 L15,3.5" id="Line-Copy" stroke-linecap="round" sketch:type="MSShapeGroup"></path>
#             <path d="M15,26.5 L15,19.5" id="Line-Copy-2" stroke-linecap="round" sketch:type="MSShapeGroup"></path>
#             <path d="M19.5,15 L26.5,15" id="Line-Copy-3" stroke-linecap="round" sketch:type="MSShapeGroup"></path>
#             <path d="M3.5,15 L10.5,15" id="Line-Copy-4" stroke-linecap="round" sketch:type="MSShapeGroup"></path>
#         </g>
#     </g>
# </svg>


{svg, line, circle, path} = React.DOM

@Crosshairs = ReactUI.createView
  displayName: 'Crosshairs'
  mixins: [React.addons.PureRenderMixin]
  render: ->
    svg
      onClick: this.props.onClick
      className: ['crosshairs', @props.className].join(' ')
      viewBox: '0 0 30 30'
      strokeWidth: 2
      circle
        cx: 15
        cy: 15
        r: 8
      path
        d: "M15,10.5 L15,3.5"
      path
        d: "M15,26.5 L15,19.5"
      path
        d: "M19.5,15 L26.5,15"
      path
        d: "M3.5,15 L10.5,15"
