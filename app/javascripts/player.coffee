#= require "vendor/all"
#= require "dialog"
#= require "templates/player"
#= require "templates/player_controls"
#= require "utils"
#FullScreenPlayer

class Player
  _.extend Player.prototype, Backbone.Events
  checkInterval: 1000 #ms

  Video_Play_State:
    0: "stopped"
    1: "playing"
    2: "paused"
    3: "connecting"
    4: "buffering"
    5: "finished"
    6: "error"

  getVideoState: =>
    return @Video_Play_State[@videoObject.playState] if @videoObject?.playState?
    "stopped"

  checkStatus: =>
    currentStatus = @getVideoState()
    #return if currentStatus == @status
    log currentStatus
    @status = currentStatus
    @trigger "changeStatus"
    @trigger currentStatus

  play: =>
    @videoObject.play?(1)

  pause:=>
    @videoObject.pause()

  stop:=>
    @videoObject.stop()

  jumpForward: =>
    #Avanza 10 ms
    time_total= @videoObject?.playPosition + (10 * 1000) # in milliseconds
    if (time_total < @videoObject?.playTime)
      @videoObject?.seek(time_total)
    else
      @videoObject?.seek(@videoObject?.playTime)

  jumpBackward:=>
    #Retrocede 10ms
    time_total=@videoObject?.playPosition - (10 * 1000) # in milliseconds
    if (time_total > 0)
      @videoObject?.seek(time_total)
    else
      @videoObject?.seek(0)

  getDuration: =>
    duration = @videoObject?.playTime ? 0
    duration #in ms

  getCurrentPosition: => #TODO currentPosition o currentTime ??
    @videoObject?.playPosition ? 0 #in ms

  constructor: (videoUrl) ->
    @status = "stopped"
    @videoObject = Platform.getVideoInterface document.getElementById "video"
    return console.log  "No se encontro el plugin de video" unless @videoObject
    @videoObject.setData videoUrl
    @videoObject.onPlayStateChange = @checkStatus

class ControlBar extends Backbone.View
  ###control buttons:
    play
    pause
    ff
    rw
    exit
  ###
  className: "video-controls"
  autoHideTime: 5000 # 5 segs

  events:
    "focus button": "focused"
    "mouseenter button": "focusButton"
    "click .play" : "play"
    "click .pause": "pause"
    "click .ff"   : "ff"
    "click .rw"   : "rw"
    "click .exit" : "exit"


  focusButton:(e)=>
    e.preventDefault()
    e.target.focus()

  resetVideoStatus: ->
    @time =
      total: new Time(0)
      elapsed: new Time(0)
    @progressBar =
      indicator: @$(".progress-bar .progress-indicator")
      background:  @$(".progress-bar .background")
    @statusIndicator = @$(".status")

    return unless @progressBar.indicator? and @statusIndicator?
    @_updateProgressBar()
    @_showStatus()

  _showStatus: ->
    @statusIndicator.html "#{@time.elapsed.toString(@time.total)}/#{@time.total}"

  _updateProgressBar: ->
    maximo = parseInt @progressBar.background.css("width")
    if @time.total.getMiliseconds() != 0
      posicion = (@time.elapsed.getMiliseconds() / @time.total.getMiliseconds()) * maximo
    else
      posicion = 0
    @progressBar.indicator.css("width", posicion+"px")

  _updateVideoStatus:(timeOutTime) =>
    elapsed = @player.getCurrentPosition()
    @time.elapsed = new Time elapsed
    @_updateProgressBar()
    @_showStatus()

  initCheckVideoStatus: ->
    totalTime = @player.getDuration()
    @time.total = new Time totalTime
    @_updateVideoStatus()
    @timerVideoStatus = setInterval @_updateVideoStatus , 500

  stopCheckVideoStatus:=>
    clearInterval @timerVideoStatus

  activeBar: =>
    return true unless @_autohideActive
    @showBar()
    @_resetTimer()

  _resetTimer: ->
    return unless @_autohideActive
    clearTimeout @timer
    @timer = setTimeout @autoHide, @autoHideTime

  autoHideOn:->
    @_autohideActive = true
    @timer = setTimeout @autoHide, @autoHideTime

  autoHideOff:->
    @_autohideActive = false
    clearTimeout @timer
    @timer = undefined
    @showBar()

  autoHide:=>
    return
    return unless @isShowed
    @$el.fadeOut "slow"
    @isShowed = false

  showBar: =>
    return if @isShowed
    @isShowed = true
    @$el.fadeIn "fast"
    @mainButton.focus()

  finished: =>
    @stopCheckVideoStatus()
    @activeStop()

  activePlay:(e) =>
    @status.html "playing"
    @showBar()
    @mainButton.removeClass("play").addClass("pause")
    if @options.enabled
      @autoHideOn()
    @initCheckVideoStatus()

  activePause:(e) =>
    @stopCheckVideoStatus()
    @status.html "paused"
    @autoHideOff()
    @mainButton.removeClass("pause").addClass("play")

  activeStop: (e)=>
    @stopCheckVideoStatus()
    @status.html "stoped"
    @autoHideOff()
    @mainButton.removeClass("pause").addClass("play")

  showPlayButton:=>

  play: (e) =>
    @player.play()

  pause:(e) =>
    @player.pause()

  stop: (e) =>
    @player.stop()

  exit: (e) =>
    console.log "exit"
    e.stopPropagation() && e.preventDefault()
    @exitDialog()
    return true

  keyPressFF: =>
    @ff()
    @$(".ff").focus()

  keyPressRW: =>
    @rw()
    @$(".rw").focus()

  ff:(e)=>
    @player.jumpForward()

  rw:(e)=>
    @player.jumpBackward()

  _mapButtons: =>
    @focusables = @$("button:enabled")
#    @focusables = @$("a")
    @mainButton = @$(".main-btn")
    @status = @$(".status")
    @lastFocused = 0

  render: =>
    @$el.html JST['templates/player_controls'] enabled: @options.enabled
    @resetVideoStatus()
    @isShowed = true
    @_mapButtons()
    if @options.enabled
      @mainButton.focus()
    else
      @focusables[0].focus()

  focused: (e)=>
    focused = @focusables.index e.currentTarget
    return if focused == @lastFocused
    @focusables.eq(@lastFocused).removeClass("focused")
    @focusables.eq(focused).addClass("focused")
    @lastFocused = focused

  focusNextControl: =>
    return true unless @isShowed
#    log $("*:focus").attr("class")
    @focusables[(@lastFocused + 1) % @focusables.length].focus()
    true

  focusPrevControl: =>
    return true unless @isShowed
    @focusables.get((@lastFocused - 1) % @focusables.length).focus()
    true

  handleKey: (e) =>
    @activeBar()
    if @keyHandler[e.keyCode]
      e.stopPropagation()
      @keyHandler[e.keyCode] e

  captureKeyEnter:(e)=>
    e.preventDefault() && e.stopPropagation()
    return true unless @isShowed
    @focusables[@lastFocused].click()
    true

  _initializeKeyHandler: ->
    @keyHandler = {}
    @keyHandler[VK_BACK]    = @exit

    @keyHandler[VK_ENTER]   = @captureKeyEnter
    @keyHandler[VK_LEFT]    = @focusPrevControl
    @keyHandler[VK_RIGHT]    = @focusNextControl
    @keyHandler[9]          = @focusNextControl #TabKey

    return unless @options.enabled

    @keyHandler[VK_PLAY]    = @play
    @keyHandler[VK_PAUSE]   = @pause
    @keyHandler[VK_STOP]    = @stop
    @keyHandler[VK_FAST_FWD]= @keyPressFF
    @keyHandler[VK_REWIND]  = @keyPressRW


    @keyHandler[VK_UP]      = @activeBar
    @keyHandler[VK_DOWN]    = @activeBar

  initialize: ->
    @player = @options.player
    @exitDialog = @options.exitDialog

    @player.on "playing", @activePlay
    @player.on "stopped", @activeStop
    @player.on "paused", @activePause
    @player.on "finished", @finished
    @_autohideActive = false
    @_initializeKeyHandler()

class ExitDialog extends YesNoDialog

  render: =>
    super question: "¿Quieres salir del reproductor?"

class FinishedDialog extends YesNoDialog

  render: =>
    super acceptText: "Ver de nuevo" , rejectText: "Salir"

class PlayerView extends Backbone.View
  className: "player"

  defaultOptions:
    controlsEnabled: true
    onFinished: @finishedDialog

  events:
    "keydown"         : "handleKey"
    "mousemove"       : "mouseMove"
    "click .player-background": "returnFocus"
    "click div"       : "returnFocus"

  returnFocus: (e) =>
    @$(".video-controls .focused")[0].focus()

  mouseMove: (e)=>
    @controlBar.activeBar()

  handleKey: (e) =>
    e.preventDefault()
    @controlBar.handleKey e

  hideSpinner: =>
    return unless @spinnerShowed
    @$(".spinner").css("display","none")
    @spinnerShowed = false
    @player.off "changeStatus", @hideSpinner

  showSpinner:(spinnerText) =>
    return if @spinnerShowed && @currentSpinnerText == spinnerText
    @$(".spinner").css("display","block").html(spinnerText)
    @currentSpinnerText = spinnerText
    @_hideBackgroundIcon()
    @spinnerShowed = true
    @player.on "changeStatus", @hideSpinner


  finishedDialog: =>
#    @player.stop()
    @player.play()
    return
    @_showBackgroundIcon()
    salir = =>
      App.back()
    verDeNuevo  = =>
      @player.play()
      @$(".main-btn").focus()
#    dialog = new FinishedDialog()
#    dialog.on "accepted", verDeNuevo
#    dialog.on "canceled", salir
#    dialog.show()
    salir()

  exitDialog: =>
    wasStopped = @player.getVideoState() == "stopped"
    @player.pause() unless wasStopped
    salir = =>
      @player.stop()
      App.back()
    continuar = =>
      @player.play() unless wasStopped
      @$(".main-btn").focus()
#    dialog = new ExitDialog()
#    dialog.on "accepted", salir
#    dialog.on "canceled", continuar
#    dialog.show()

    salir()

  _hideBackgroundIcon:=>
    return unless @iconHiden != true # @iconHide == false or @iconHide == undefined
    @$(".player-background").removeClass("icon")
    @iconHiden = true

  _showBackgroundIcon:=>
    return unless @iconHiden != false # @iconHide == true or @iconHide == undefined
    @$(".player-background").addClass("icon")
    @iconHiden = false

  setEventListeners: ->
    buffering = =>
      @showSpinner "Cargando..."

    connecting= =>
      @showSpinner "Conectando..."
    @player.on "buffering", buffering
    @player.on "connecting", connecting
    @player.on "playing", @_hideBackgroundIcon
    @player.on "paused", @_showBackgroundIcon

    onFinished = @options.onFinished ? @finishedDialog
    @player.on "finished", onFinished

  enableControls: ->
    @options.controlsEnabled = true

  reset:(options) ->
    _.extend @options, @defaultOptions, options
    @render() if @rendered

  remove:->
    super
    $("body").removeClass "playing"

  render: =>
    @rendered = true
    @$el.html JST['templates/player']()
    @spinnerShowed = false
    @background = @$(".player-background")
    @iconHiden = undefined
    log @options.videoUrl
    @player = new Player @options.videoUrl

    @controlBar = new ControlBar
        player: @player
        exitDialog: @exitDialog
        enabled: @options.controlsEnabled
    @setEventListeners()
    @$el.append @controlBar.$el
    @controlBar.render()
    $("body").addClass "playing"
    @player.play()
    @

  initialize: ->
    _.defaults @options, @defaultOptions

# Exports:
window.PlayerView = PlayerView
window.Player = Player