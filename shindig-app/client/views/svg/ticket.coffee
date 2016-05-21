# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <svg width="30px" height="30px" viewBox="0 0 30 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
#     <!-- Generator: Sketch 3.3.3 (12072) - http://www.bohemiancoding.com/sketch -->
#     <title>ticket</title>
#     <desc>Created with Sketch.</desc>
#     <defs>
#         <path id="path-1" d="M5,8 L25,8 C25,9 26,10 27,10 L27,20 C26,20 25,21 25,22 L5,22 C5,21 4,20 3,20 L3,10 C4,10 5,9 5,8 Z"></path>
#     </defs>
#     <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" sketch:type="MSPage">
#         <g id="ticket" sketch:type="MSArtboardGroup">
#             <g id="Polygon-1">
#                 <use stroke="none" fill="#FFFFFF" fill-rule="evenodd" sketch:type="MSShapeGroup" xlink:href="#path-1"></use>
#                 <use stroke="#000000" stroke-width="1" stroke-linecap="round" stroke-linejoin="round" fill="none" xlink:href="#path-1"></use>
#             </g>
#             <rect id="Rectangle-1" fill="#000000" sketch:type="MSShapeGroup" x="8" y="11" width="14" height="8" rx="1"></rect>
#         </g>
#     </g>
# </svg>

{svg, line, circle, path, rect} = React.DOM

@Ticket = ReactUI.createView
  displayName: 'Ticket'
  mixins: [React.addons.PureRenderMixin]
  render: ->
    svg
      onClick: this.props.onClick
      className: ['ticket', @props.className].join(' ')
      viewBox: '0 0 30 30'
      strokeWidth: 1
      strokeLinecap: "round"
      strokeLinejoin: "round"
      path
        d: "M5,8 L25,8 C25,9 26,10 27,10 L27,20 C26,20 25,21 25,22 L5,22 C5,21 4,20 3,20 L3,10 C4,10 5,9 5,8 Z"
      rect
        x: 8
        y: 11
        width: 14
        height: 8
        rx: 1
