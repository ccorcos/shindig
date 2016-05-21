# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <svg width="30px" height="30px" viewBox="0 0 30 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
#     <!-- Generator: Sketch 3.3.3 (12072) - http://www.bohemiancoding.com/sketch -->
#     <title>down</title>
#     <desc>Created with Sketch.</desc>
#     <defs></defs>
#     <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" sketch:type="MSPage">
#         <g id="down" sketch:type="MSArtboardGroup" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
#             <path d="M11,4 L11,15" id="Line" sketch:type="MSShapeGroup"></path>
#             <path d="M19,4 L19,15" id="Line-Copy" sketch:type="MSShapeGroup"></path>
#             <path d="M15,26 L6,14" id="Line" sketch:type="MSShapeGroup"></path>
#             <path d="M15,26 L24,14" id="Line-Copy-2" sketch:type="MSShapeGroup"></path>
#         </g>
#     </g>
# </svg>

{svg, line, circle, path} = React.DOM

@Down = ReactUI.createView
  displayName: 'Down'
  mixins: [React.addons.PureRenderMixin]
  render: ->
    svg
      onClick: this.props.onClick
      className: ['down', @props.className].join(' ')
      viewBox: '0 0 30 30'
      strokeWidth: 2
      path
        d: "M11,4 L11,15"
      path
        d: "M19,4 L19,15"
      path
        d: "M15,26 L6,14"
      path
        d: "M15,26 L24,14"
