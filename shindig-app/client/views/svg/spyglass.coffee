# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <svg width="30px" height="30px" viewBox="0 0 30 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
#     <!-- Generator: Sketch 3.3.3 (12072) - http://www.bohemiancoding.com/sketch -->
#     <title>spyglass</title>
#     <desc>Created with Sketch.</desc>
#     <defs></defs>
#     <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" sketch:type="MSPage">
#         <g id="spyglass" sketch:type="MSArtboardGroup" stroke="#000000">
#             <circle id="Oval-1" stroke-width="2" sketch:type="MSShapeGroup" cx="19.5" cy="10.5" r="7.5"></circle>
#             <path d="M4.5,25.5 L13.5,16.5" id="Line" stroke-width="3" stroke-linecap="square" sketch:type="MSShapeGroup"></path>
#         </g>
#     </g>
# </svg>

{svg, line, circle, path} = React.DOM

@Spyglass = ReactUI.createView
  displayName: 'Spyglass'
  mixins: [React.addons.PureRenderMixin]
  render: ->
    svg
      onClick: this.props.onClick
      className: ['spyglass', @props.className].join(' ')
      viewBox: '0 0 30 30'
      circle
        strokeWidth: 2
        cx: 19.5
        cy: 10.5
        r: 7.5
      path
        strokeWidth: 3
        d:"M4.5,25.5 L13.5,16.5"
