# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <svg width="30px" height="30px" viewBox="0 0 30 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
#     <!-- Generator: Sketch 3.3.3 (12072) - http://www.bohemiancoding.com/sketch -->
#     <title>share</title>
#     <desc>Created with Sketch.</desc>
#     <defs></defs>
#     <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" sketch:type="MSPage">
#         <g id="share" sketch:type="MSArtboardGroup" stroke="#000000">
#             <circle id="Oval-7" sketch:type="MSShapeGroup" cx="15" cy="15" r="11"></circle>
#             <ellipse id="Oval-8" sketch:type="MSShapeGroup" cx="15" cy="15" rx="5" ry="11"></ellipse>
#             <path d="M4.5,15 L25.5,15" id="Line" stroke-linecap="square" sketch:type="MSShapeGroup"></path>
#             <path d="M15,4.5 L15,25.5" id="Line" stroke-linecap="square" sketch:type="MSShapeGroup"></path>
#             <path d="M6.42852783,21.8842773 C6.42852783,21.8842773 9.17027187,20.0127884 15.0027466,20.0127884 C20.8352213,20.0127884 23.5769653,21.90802 23.5769653,21.90802" id="Path-19" sketch:type="MSShapeGroup"></path>
#             <path d="M6.4498291,8.11096191 C6.4498291,8.11096191 9.32159424,9.99871826 15.0126038,9.99871826 C20.7036133,9.99871826 23.5753784,8.12451172 23.5753784,8.12451172" id="Path-19" sketch:type="MSShapeGroup"></path>
#         </g>
#     </g>
# </svg>


{svg, line, ellipse, circle, path} = React.DOM

@Share = ReactUI.createView
  displayName: 'Share'
  mixins: [React.addons.PureRenderMixin]
  render: ->
    svg
      onClick: this.props.onClick
      className: ['share', @props.className].join(' ')
      viewBox: '0 0 30 30'
      strokeWidth: 1
      circle
        fill: 'none'
        cx: 15
        cy: 15
        r: 11
      ellipse
        fill: 'none'
        cx: 15
        cy: 15
        rx: 5
        ry: 11
      path
        fill: 'none'
        d: "M4.5,15 L25.5,15"
      path
        fill: 'none'
        d: "M15,4.5 L15,25.5"
      path
        fill: 'none'
        d: "M6.42852783,21.8842773 C6.42852783,21.8842773 9.17027187,20.0127884 15.0027466,20.0127884 C20.8352213,20.0127884 23.5769653,21.90802 23.5769653,21.90802"
      path
        fill: 'none'
        d: "M6.4498291,8.11096191 C6.4498291,8.11096191 9.32159424,9.99871826 15.0126038,9.99871826 C20.7036133,9.99871826 23.5753784,8.12451172 23.5753784,8.12451172"
