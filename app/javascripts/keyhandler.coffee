#= require "vendor/all"
#= require "platform"
#= require_directory "./templates"

class KeyHandler extends Backbone.View

  # An object where key: key code, value: a "handler" object.
  handlers: {}

  # Set a callback function to run when 'keyCode' key is pressed. The
  # 'description' parameter is the on-screen text for the clickable key button.
  setFunctionKey: (keyCode, callback, description)=>
    handler =
      callback: callback
      description: description
      className: @classNameForKeyCode(keyCode)
    @handlers[keyCode] = handler
    @render if @rendered()

  onKeyDown: (e)=>
    result = @handlers[e.keyCode]?.callback() and e.preventDefault()
    if result == false and e.keyCode == VK_BACK
      Platform.exit()
    undefined

  toggleGraphicKey: (keyCode, visible) =>
    @$(".#{@classNameForKeyCode(keyCode)}").toggle visible

  updateKeys:->
    @$el.html ""
    @$el.html JST['templates/keyhandler_key'](@)
    for keyCode, handler of @handlers
      @$(".key.#{handler.className}").click handler.callback
    return

  render: =>
    @updateKeys()

  # Wheter the KeyHandler view is rendered or not.
  rendered: ->
    @$el.html() != ''

  classNameForKeyCode: (keyCode) ->
    switch (keyCode)
      when window.VK_BACK then "vk_back"
      when window.VK_RED then "vk_red"
      when window.VK_BLUE then "vk_blue"
      else "key_" + keyCode

# Exports
window.KeyHandler = KeyHandler