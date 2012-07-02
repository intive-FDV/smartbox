#= require "vendor/all"
#= require "platform"
#= require "listview"
#= require "stackview"
#= require "keyhandler"
#= require_directory "./templates"
#= require "player"

# Nettv's Key Constants for Browser
_.defaults window, Platform.keyCodes
class EmptyView extends Backbone.View
  render: =>
    @$el.html "ESTO ES UNA VISTA VACIA!!! <br /> De #{@options.text}"

#class PlayerTab extends PlayerView
window.createPlayer = ->
  player = new PlayerView videoUrl: "assets/video.mp4"
  window.player  = player
  App.navigateTo player

class PlayerTab extends Backbone.View
#  initialize:->
#    @options.videoUrl = "http://contenidos2.ciudad.com.ar/fme/2012/06/12/309eab9e39/china_suarez-309eab9e39-240p.mp4"
#    @options.videoUrl = "assets/video.mp4"
#    super
#    window.player = @
  events:
    'focus #focus-out' : 'exitFocus'

  exitFocus:(e) =>
    e.stopPropagation()
    @trigger "exitFocus"

  render:=>
    @$el.html "<button id='focus-out' style='width: 19px;height:19px;'></button>
      <button class='btn' id='focus-receptor' onclick='window.createPlayer();' style='nav-left:#focus-out;'

         >CREAR PLAYER</button>"
    $("#focus-receptor").focus()

    #createPlayer()

class AppView extends Backbone.View

  events:
    'keydown'        : 'onKeyDown'
    'click .tab'     : 'clickTab'
    'mouseenter .tab': 'focusTab'
    'focusin *'      : 'saveFocus'

  saveFocus: (e) ->
    log "focus"
    document.activeElement = e.target

#    'click input':'setKeyBoard'
#
#  setKeyBoard:(e)->
#    lgKb.focusIn e

  tabsInfo: [
    {className: 'home',   type: EmptyView, text: 'Vacio'}
    {className: 'player-tab', type: PlayerTab, text: 'Player'}
    {className: 'vacio2', type: EmptyView, text: 'No ha nada'}
    {className: 'vacio3', type: EmptyView, text: 'Prueba'}
    {className: 'vacio4', type: EmptyView, text: 'Otro vacio'}

  ]

  initialize: ->
    if document.activeElement
      @saveFocus = -> null
    @keyHandler = new KeyHandler()
    @keyHandler.setFunctionKey window.VK_BACK, @back, "Volver"

  goToHome: =>
    home = @$('.home')
    @selectTab home
    home.focus()

  render: =>
    @$el.append JST['templates/application'](tabs: @tabsInfo)
    @stackView = new StackView(el: @$('.main-panel'))
    @stackView.on 'change', @_updateBackButton
    @_updateBackButton()
    @keyHandler.render()
    @$(".controls").append @keyHandler.$el

  focusTab: (e)->
    e.stopPropagation()
    e.preventDefault()
    tab = e.currentTarget
    tab.focus()

  clickTab: (e) ->
    @selectTab $(e.currentTarget)

  focusSelectedTab: =>
    #Maybe the last selected tab can be asigned to a variable?
    @$(".tab.selected").focus()

  selectTab: ($tab) ->
    tabInfo = @tabsInfo[$tab.index(".tab")]

    # Actually opens the tab.
    @$('.tab.selected').removeClass 'selected'
    $tab.addClass 'selected'
    view = new tabInfo.type text: tabInfo.text
    view.on "exitFocus", @focusSelectedTab
    @stackView.reset view

  # Goes back to the previous view if there is any in the back-stack.
  # Returns whether it went back or not.
  back: =>
    nested = @stackView.size() > 1
    if nested
      @stackView.pop()
    else
      Platform.exit()
    nested

  # Navigates to a given view, stacking it on the back-stack.
  navigateTo: (view) ->
    view.on "exitFocus", @focusSelectedTab
    @stackView.push view

  onKeyDown: (e) =>
    @keyHandler.onKeyDown(e)

  _updateBackButton: =>
    @keyHandler.toggleGraphicKey VK_BACK, @stackView.size() > 1

App = new AppView el:'body'
window.initializeApp = ->
  # A singleton instance of the application.
  App.render()
  App.goToHome()

# Exports.
window.App = App
window.log ?= -> null
