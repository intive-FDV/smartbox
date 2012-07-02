#= require "vendor/all"
#= require "templates/dialog_yes_no"
#= require "templates/dialog_info"


#TODO check events triggered
class Dialog extends Backbone.View
  events: {}
  _defaultsEvents:
    "click .dialog-background" : "focusSelected"
    "keydown"                  : "handleKey"
    "mouseenter button.option"      : "onMouseenterOption"
    "focus .option"            : "onFocusOption"
    "focus input"              : "onFocusInput"
    "keydown input"            : "onKeyPressInput"
    "click .option.cancel"     : "onCancel"

  className: "dialog"
  keyHandler: {}

  onKeyPressInput: (e) =>
    e.stopPropagation()
    if e.keyCode == window.VK_BACK
      e.stopPropagation()
    else if e.keyCode == window.VK_ENTER
      @$("button.default").focus()

  onFocusInput: (e)=>
    @setCursor e.target

  setCursor: (inputElemnt) ->
    #Set the cursor at end of line (if not, the value shows selected and causes some problems to edit)
    lastPos = inputElemnt.value.length
    inputElemnt.setSelectionRange(lastPos,lastPos)

  show: () =>
    $("body .dialog").remove() #Removes any other dialog on the screen
    $("body").append @$el
    @render()

  onCancel: =>
    @remove()
    @trigger "canceled"

  onAccept: =>
    @remove()
    @trigger "accepted"

  focusSelected:=> #Evito que se vaya el foco al app al clickear en el background
    @$(".focused").focus()

  onFocusOption:(e) =>
    focused = @$(".focused")
    return if focused[0] == e.target
    focused.removeClass("focused")
    $(e.target).addClass("focused")

  onMouseenterOption: (e) ->
    e.target.focus()

  handleKey: (e) =>
    e.stopPropagation()
    if @keyHandler[e.keyCode]?
      e.preventDefault()
      @keyHandler[e.keyCode](e)

  _turn:(e) =>
    e.preventDefault()
    next = @$(".option.focused").next(".option")[0] ? @$(".option:first")
    next.focus()

  _setKeyHandler: ->
    @keyHandler[9]        = @_turn # 9 is tab key!
    @keyHandler[VK_BACK] = @onCancel

  initialize: ->
    _.defaults @events, @_defaultsEvents
    @_setKeyHandler()

class YesNoDialog extends Dialog
  events:
    "click .yes"               : "onAccept"
    "click .no"                : "onCancel"

  render: (options)=>
    params =
      question: ""
      acceptText: "Si"
      rejectText: "No"
    _.extend params, options
    @$el.html JST["templates/dialog_yes_no"] params
    @focusSelected()

class InfoDialog extends Dialog
  events:
    "click .ok"               : "onAccept"

  onCancel: => @onAccept()

  render: (options)=>
    params =
      info: ""
      acceptText: "Ok"
    _.extend params, @options, options
    @$el.html JST["templates/dialog_info"] params
    @focusSelected()


# Exports
window.YesNoDialog    = YesNoDialog
window.InfoDialog     = InfoDialog
