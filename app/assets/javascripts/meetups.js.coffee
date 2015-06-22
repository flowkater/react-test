# # Place all the behaviors and hooks related to the matching controller here.
# # All this logic will automatically be available in application.js.
# # You can use CoffeeScript in this file: http://coffeescript.org/

DOM = React.DOM

FormInputWithLabel = React.createClass
	getDefaultProps: ->
		elementType: "input"		
		inputType: "text"
	displayName: "FormInputWithLabel"

	tagType: ->
		{
			"input": @props.inputType,
			"textarea": null
		}[@props.elementType]

	render: ->
		DOM.div
			className: "form-group"
			DOM.label
				htmlFor: @props.id
				className: "col-lg-2 control-label"
				@props.labelText
			DOM.div
				className: classNames('col-lg-10': true, 'has-warning': @props.warning)
				@warning()
				DOM[@props.elementType]
					className: "form-control"
					placeholder: @props.placeholder
					id: @props.id
					type: "text"
					value: @props.value 
					onChange: @props.onChange
					type: @tagType()
	warning: ->
		return null unless @props.warning
		DOM.label
			className: "control-label"
			htmlFor: @props.id
			@props.warning


formInputWithLabel = React.createFactory(FormInputWithLabel)

DateWithLabel = React.createClass
	getDefaultProps: ->
		date: new Date()

	onYearChange: (event) ->
		newDate = new Date(
			event.target.value,
			@props.date.getMonth(),
			@props.date.getDate()
		)
		@props.onChange(newDate)

	onMonthChange: (event) ->
		newDate = new Date(
			@props.date.getFullYear(),
			event.target.value,
			@props.date.getDate()
		)
		@props.onChange(newDate)

	onDateChange: (event) ->
		newDate = new Date(
			@props.date.getFullYear(),
			@props.date.getMonth(),
			event.target.value
		)
		@props.onChange(newDate)

	monthName: (monthNumberStartingFromZero) ->
		[
			"January", "February", "March", "April", "May", "June", "July",
			"August", "September", "October", "November", "December"
		][monthNumberStartingFromZero]

	dayName: (date) ->
		dayNameStartingWithSundayZero = new Date(
			@props.date.getFullYear(),
			@props.date.getMonth(),
			date
		).getDay()
		[
			"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
		][dayNameStartingWithSundayZero]

	render: ->
		DOM.div
			className: "form-group"
			DOM.label
				className: "col-lg-2 control-label"
				"Date"
			DOM.div
				className: "col-lg-2"
				DOM.select
					className: "form-control"
					onChange: @onYearChange
					value: @props.date.getFullYear()
					DOM.option(value: year, key: year, year) for year in [2015..2020]
			DOM.div
				className:"col-lg-3"
				DOM.select
					className: "form-control"
					onChange: @onMonthChange
					value: @props.date.getMonth()
					DOM.option(value: month, key: month, "#{month + 1} - #{@monthName(month)}") for month in [0..11]
			DOM.div
				className:"col-lg-2"
				onChange: @onDateChange
				DOM.select
					className: "form-control"
					value: @props.date.getDate()
					DOM.option(value: date, key: date, "#{date}-#{@dayName(date)}") for date in [1..31]
 
dateWithLabel = React.createFactory(DateWithLabel)

FormInputWithLabelAndReset = React.createClass
	displayName: "FormInputWithLabelAndReset"
	render: ->
		DOM.div
			className: "form-group"
			DOM.label
				htmlFor: @props.id
				className: "col-lg-2 control-label"
				@props.labelText
			DOM.div
				className: "col-lg-8"
				DOM.div
					className: "input-group"
					DOM.input
						className: "form-control"
						placeholder: @props.placeholder
						id: @props.id
						value: @props.value
						onChange: (event) =>
							@props.onChange(event.target.value)
					DOM.span
						className: "input-group-btn"
						DOM.button
							onClick: () =>
								@props.onChange(null)
							className: "btn btn-default"
							type: "button"
							DOM.i
								className: "fa fa-magic"
						DOM.button
							onClick: () =>
								@props.onChange("")
							className: "btn btn-default"
							type: "button"
							DOM.i
								className: "fa fa-times-circle"


formInputWithLabelAndReset = React.createFactory(FormInputWithLabelAndReset)

CreateNewMeetupForm = React.createClass
	displayName: "CreateNewMeetupForm"
	getInitialState: ->
		{
			meetup: {
				title: "",
				description: "",
				date: new Date(),
				seoText: null,
				warnings: {
					title: null
				}	
			}
		}

	monthName: (monthNumberStartingFromZero) ->
		[
			"January", "February", "March", "April", "May", "June", "July",
			"August", "September", "October", "November", "December"
		][monthNumberStartingFromZero]

	dateChanged: (newDate) ->
		@state.meetup.date = newDate
		@forceUpdate()

	fieldChanged: (fieldName, event) ->
		@state.meetup[fieldName] = event.target.value
		@validateField(fieldName)
		@forceUpdate

	validateField: (fieldName, value) ->
		validator = {
			title: (text) ->
				if /\s/.test(text) then null else "Cannot be blank"
		}[fieldName]
		return unless validator
		@state.meetup.warnings[fieldName] = validator( @state.meetup[fieldName] )

	seoChanged: (seoText) ->
		@state.meetup.seoText = seoText
		@forceUpdate

	computeDefaultSeoText: () ->
		words = @state.meetup.title.split(/\s+/)
		words.push(@monthName(@state.meetup.date.getMonth()))
		words.push(@state.meetup.date.getFullYear().toString())
		words.filter( (string) -> string.trim().length > 0).join("-").toLowerCase()

	validateAll:() ->
		for field in ['title']
			@validateField(field)

	formSubmitted: (event) ->
		@validateAll
		@forceUpdate

		for own key of @state.meetup
			return if @state.meetup.warnings[key]

		$.ajax
			url: "/meetups.json",
			type: "POST",
			dataType: "JSON",
			contentType: "application/json",
			processData: false,
			data: JSON.stringify({meetup: {
				title: @state.meetup.title
				description: @state.meetup.description
				date: [
					@state.meetup.date.getFullYear(),
					@state.meetup.date.getMonth() + 1,
					@state.meetup.date.getDate()
				].join("-")
				seo: @state.seoText || @computeDefaultSeoText()
			}})

	render: ->
		DOM.form
			onSubmit: @formSubmitted
			className: "form-horizontal"
			DOM.fieldset null,
				DOM.legend null, "New Meetup"

				formInputWithLabel
					id: "title"
					value: @state.meetup.title
					onChange: @fieldChanged.bind(null, "title")
					placeholder: "Meetup title"
					labelText: "Title"
					warning: @state.meetup.warnings.title

				formInputWithLabel
					id: "description"
					value: @state.meetup.description
					onChange: @fieldChanged.bind(null, "description")
					placeholder: "Meetup description"
					labelText: "Description"
					inputType: "textarea"

				dateWithLabel
					onChange: @dateChanged
					date: @state.meetup.date

				formInputWithLabelAndReset
					id: "seo"
					value: if @state.meetup.seoText? then @state.meetup.seoText else @computeDefaultSeoText()
					onChange: @seoChanged
					placeholder: "SEO text"
					labelText: "seo"

				DOM.div
					className: "form-group"
					DOM.div
						className: "col-lg-10 col-lg-offset-2"
						DOM.button
							type: "submit"
							className: "btn btn-primary"
							"Save"

createNewMeetupForm = React.createFactory(CreateNewMeetupForm)

$ ->
  React.render(
    createNewMeetupForm(),
    document.getElementById("CreateNewMeetup")
  )