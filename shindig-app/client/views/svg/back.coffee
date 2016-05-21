# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <svg width="30px" height="30px" viewBox="0 0 30 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
#     <!-- Generator: Sketch 3.3.3 (12072) - http://www.bohemiancoding.com/sketch -->
#     <title>back</title>
#     <desc>Created with Sketch.</desc>
#     <defs></defs>
#     <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" sketch:type="MSPage">
#         <g id="back" sketch:type="MSArtboardGroup" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
#             <path d="M18,24 L9,15" id="Line" sketch:type="MSShapeGroup"></path>
#             <path d="M9,15 L18,6" id="Line-Copy-2" sketch:type="MSShapeGroup"></path>
#         </g>
#     </g>
# </svg>

{svg, line, circle, path} = React.DOM

@Back = ReactUI.createView
  displayName: 'Back'
  mixins: [React.addons.PureRenderMixin]
  render: ->
    svg
      onClick: this.props.onClick
      className: ['back', @props.className].join(' ')
      viewBox: '0 0 30 30'
      strokeWidth: 2
      path
        d: "M18,24 L9,15"
      path
        d: "M9,15 L18,6"
