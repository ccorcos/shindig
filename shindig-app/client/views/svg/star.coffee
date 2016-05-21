# <?xml version="1.0" encoding="UTF-8" standalone="no"?>
# <svg width="30px" height="30px" viewBox="0 0 30 30" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:sketch="http://www.bohemiancoding.com/sketch/ns">
#     <!-- Generator: Sketch 3.3.3 (12072) - http://www.bohemiancoding.com/sketch -->
#     <title>star</title>
#     <desc>Created with Sketch.</desc>
#     <defs></defs>
#     <g id="Page-1" stroke="none" stroke-width="1" fill="none" fill-rule="evenodd" sketch:type="MSPage">
#         <g id="star" sketch:type="MSArtboardGroup" fill="#000000">
#             <polygon id="Star-1" sketch:type="MSShapeGroup" points="15 21.5699379 7.35879172 26.5172209 9.70267424 17.7212055 2.63626529 11.9827791 11.7260726 11.4938256 15 3 18.2739274 11.4938256 27.3637347 11.9827791 20.2973258 17.7212055 22.6412083 26.5172209 "></polygon>
#         </g>
#     </g>
# </svg>

{svg, line, circle, path, polygon} = React.DOM

@Star = ReactUI.createView
  displayName: 'Star'
  mixins: [React.addons.PureRenderMixin]
  render: ->
    svg
      onClick: this.props.onClick
      className: ['star', @props.className].join(' ')
      viewBox: '0 0 30 30'
      polygon
        points: "15 21.5699379 7.35879172 26.5172209 9.70267424 17.7212055 2.63626529 11.9827791 11.7260726 11.4938256 15 3 18.2739274 11.4938256 27.3637347 11.9827791 20.2973258 17.7212055 22.6412083 26.5172209 "
