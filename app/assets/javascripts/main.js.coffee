# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# OneTimeClickLink = React.createClass
# 	getInitialState: ->
# 		{clicked: false}
# 	linkClicked: (event) ->
# 		@setState(clicked: true)
# 	child: ->
# 		{
# 			false: React.DOM.a({href: "javascript:void(0)", onClick: @linkClicked}, "Click me"),
# 			true:  React.DOM.span({}, "You Clicked the Link")
# 		}[@state.clicked]
# 	render: ->
# 		React.DOM.div({id: "one-time-click-link"}, @child())

# $ ->
# 	oneTimeClickLink = React.createFactory(OneTimeClickLink)

# 	React.render(
# 		oneTimeClickLink(),
# 		document.body
# 	)

# 	element = React.createElement(OneTimeClickLink)

# 	virtualDomAfterClick = React.DOM.div(
# 		{id: "render-me-react-please"},
# 		React.DOM.span({}, "You clicked the link")
# 	)

# 	linkClicked = (event) ->
# 		React.render(
# 			virtualDomAfterClick,
# 			document.body
# 		)
# 		# console.log(event)
# 		# console.log(event.target)
# 		# alert("you clicked me")

# 	virtualDom = React.DOM.div(
# 		{id: "render-me-react-please"},
# 		React.DOM.a(
# 			{href: "javascript:void(0)", onClick: linkClicked},
# 			"Click Me"
# 		)
# 	)

# 	React.render(
# 		virtualDom,
# 		document.body
# 	)
		
	
#   React.render(
#     React.DOM.div({id: "render-me-react-please"}, "Hello world!"),
#     document.body
#   )