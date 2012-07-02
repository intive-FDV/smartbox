#=mmmm require "vendor/jquery-min"
#Platforms: LG PHILIPS SAMSUNG OTHER?

#Detecting Platform

window.console?= {}
window.console.log ?= (m)->
  alert m

window.resolveURL = (url)->
  a = document.createElement('a');
  a.href = url;
  a.href;

class SamsungVideoPlayer
  _stateCodes:
    STOPPED   : 0
    PLAYING   : 1
    PAUSED    : 2
    CONNECTING: 3
    BUFFERING : 4
    FINISHED  : 5
    ERROR     : 6

  data: undefined
  plugin: undefined

  #Public prperties
  playTime: undefined
  playPosition: 0
  playState: 0

  setData:(videoUrl) =>
    @videoUrl = resolveURL videoUrl

  play: =>
    return if @playState == @_stateCodes.PLAYING
    if @playState == @_stateCodes.PAUSED
      @plugin.Resume()
      @setStatus @_stateCodes.PLAYING
    else if @playState == @_stateCodes.STOPPED
      @plugin.SetDisplayArea?(0, 0, 960, 540)
      @plugin.Play @videoUrl
      @setStatus @_stateCodes.PLAYING

  pause: =>
    return unless @playState == @_stateCodes.PLAYING
    @plugin.Pause()
    @setStatus @_stateCodes.PAUSED

  stop: =>
    return unless @playState != @_stateCodes.STOPPED
    @plugin.SetDisplayArea?(0, 0, 0, 0)
    @plugin.Stop()
    @setStatus @_stateCodes.STOPPED

  seek: (time) =>
    return unless @playState == @_stateCodes.PLAYING
    if time < 0
      @plugin.JumpBackward -1 * time
    else
      @plugin.JumpForward time

  setStatus: (statusCode) =>
    @playState = statusCode
    @onPlayStateChange()

  constructor: (pluginVideo) ->
    @plugin = pluginVideo
    #TODO REMOVE THIS SHIIT!!!!

    window.__video =
      setCurTime:(time) =>
        @playPosition = time
        if @playTime <= @playPosition
          @setStatus @_stateCodes.FINISHED
      setTotalTime: =>
        @playTime = @plugin.GetDuration()
      #        @onPlayStateChange()
      onBufferingStart: =>
        #        @sendStatus('onBufferingStart',arguments[0]);
        @preBufferingStatus =  @playState
        @setStatus @_stateCodes.BUFFERING

      onBufferingProgress:(percent) =>
        #        @sendStatus('onBufferingProgress',arguments[0]);
        null

      onBufferingComplete: =>
        @setStatus @preBufferingStatus
    #        @sendStatus('onBufferingComplete',arguments[0]);

    @plugin.OnCurrentPlayTime = 'window.__video.setCurTime'
    @plugin.OnStreamInfoReady = 'window.__video.setTotalTime'
    @plugin.OnBufferingStart = 'window.__video.onBufferingStart';
    @plugin.OnBufferingProgress = 'window.__video.onBufferingProgress';
    @plugin.OnBufferingComplete = 'window.__video.onBufferingComplete';

  onPlayStateChange: ->
    null


Platform = 
  keyCodes: #Based on LG's key codes
      VK_ENTER          : 13  
      VK_PAUSE          : 19  
      VK_PAGE_UP        : 33  
      VK_PAGE_DOWN      : 34  
      VK_LEFT           : 37  
      VK_UP             : 38  
      VK_RIGHT          : 39  
      VK_DOWN           : 40  
      
      VK_HID_BACK       : 8  
      VK_HID_HOME       : 36  
      VK_HID_END        : 35  
      VK_HID_INSERT     : 45  
      VK_HID_DEL        : 46  
      VK_HID_ESC        : 461  
      VK_HID_CTRL       : 17  
      VK_HID_ALT        : 18  
      
      VK_CAPS_LOCK      : 20  
      VK_SHIFT          : 16  
      VK_LANG_SEL       : 229  
      
      VK_0              : 48  
      VK_1              : 49  
      VK_2              : 50  
      VK_3              : 51  
      VK_4              : 52  
      VK_5              : 53  
      VK_6              : 54  
      VK_7              : 55  
      VK_8              : 56  
      VK_9              : 57  
      
      VK_NUMPAD_0       : 96  
      VK_NUMPAD_1       : 97  
      VK_NUMPAD_2       : 98  
      VK_NUMPAD_3       : 99  
      VK_NUMPAD_4       : 100  
      VK_NUMPAD_5       : 101  
      VK_NUMPAD_6       : 102  
      VK_NUMPAD_7       : 103  
      VK_NUMPAD_8       : 104  
      VK_NUMPAD_9       : 105  
      
      
      VK_GRAVE          : 192  
      VK_DASH           : 189  
      VK_EQUAL          : 187  
      VK_BACK_SLASH     : 220  
      VK_LEFT_BLACKET   : 219  
      VK_RIGHT_BLACKET  : 221  
      VK_SEMICOLON      : 186  
      VK_APOSTROPHE     : 222  
      VK_COMMA          : 188  
      VK_PERIOD         : 190  
      VK_SLASH          : 191  
      VK_SPACE_BAR      : 32  
      
      VK_A              : 65  
      VK_B              : 66  
      VK_C              : 67  
      VK_D              : 68  
      VK_E              : 69  
      VK_F              : 70  
      VK_G              : 71  
      VK_H              : 72  
      VK_I              : 73  
      VK_J              : 74  
      VK_K              : 75  
      VK_L              : 76  
      VK_M              : 77  
      VK_N              : 78  
      VK_O              : 79  
      VK_P              : 80  
      VK_Q              : 81  
      VK_R              : 82  
      VK_S              : 83  
      VK_T              : 84  
      VK_U              : 85  
      VK_V              : 86  
      VK_W              : 87  
      VK_X              : 88  
      VK_Y              : 89  
      VK_Z              : 90  
      
      VK_RED            : 403  
      VK_GREEN          : 404  
      VK_YELLOW         : 405  
      VK_BLUE           : 406  
      VK_REWIND         : 412  
      VK_STOP           : 413  
      VK_PLAY           : 415  
      VK_FAST_FWD       : 417  
      VK_INFO           : 457  
      VK_BACK           : 461  
  onLoad: -> null
  isLg: ->
    navigator.userAgent.search(/LG/i) > -1
  isSamsung: ->
    navigator.userAgent.search(/Maple/i) > -1  #version < 3.1
  isPhilips: ->
    navigator.userAgent.search(/Philips/i) > -1 || navigator.userAgent.search(/Nettv/i) > -1
  exit: -> null

  #Devuelve una interface de control de video a partir del objeto de video pasado
  getVideoInterface: (videoObject) ->
    videoObject.setData = (data) ->
       @data = data #this en este caso corresponde al objeto de video
    videoObject


#Is LG
if Platform.isLg()
  log "IS LG"
  Platform.exit = -> window.NetCastBack()

else if Platform.isPhilips()
  #In philips, the key names are defined (in window)
  log "is Philips/or Nettv"
  getVideoInterface: (videoObject) ->
    videoObject.setData = (data) ->
      @data = data #this en este caso corresponde al objeto de video
    videoObject.pause = ->
      @play(0) #this en este ca
    videoObject


else if Platform.isSamsung()
  log "is Samsung"
  console.log "is Samsung"

  widgetAPI= new Common.API.Widget()
  tvKey = new Common.API.TVKeyValue()

  #TODO Use the complete this key values
  Platform.keyCodes.VK_PLAY=     tvKey.KEY_PLAY
  Platform.keyCodes.VK_PAUSE=    tvKey.KEY_PAUSE
  Platform.keyCodes.VK_STOP=     tvKey.KEY_STOP
  Platform.keyCodes.VK_REWIND=   tvKey.KEY_RW
  Platform.keyCodes.VK_FAST_FWD= tvKey.KEY_FF

  Platform.keyCodes.VK_RED =     tvKey.KEY_RED
  Platform.keyCodes.VK_GREEN=    tvKey.KEY_GREEN
  Platform.keyCodes.VK_BLUE=     tvKey.KEY_BLUE
  Platform.keyCodes.VK_YELLOW=   tvKey.KEY_YELLOW

  Platform.keyCodes.VK_ENTER=    tvKey.KEY_ENTER

  Platform.keyCodes.VK_LEFT=     tvKey.KEY_LEFT
  Platform.keyCodes.VK_RIGHT=    tvKey.KEY_RIGHT
  Platform.keyCodes.VK_UP=       tvKey.KEY_UP
  Platform.keyCodes.VK_DOWN=     tvKey.KEY_DOWN

  Platform.keyCodes.VK_BACK=     tvKey.KEY_RETURN

  Platform.exit = ->
    $("#video")[0]?.Stop()
    widgetAPI.sendReturnEvent()

  Platform.onLoad = ->
    widgetAPI.sendReadyEvent()
  Platform.getVideoInterface= (videoObject) ->
#    window.videoObject = videoObject
#    videoObject.setData = (data) ->
#      console.log data
#      window.datas = resolveURL data #this en este caso corresponde al objeto de video
#    videoObject.play = ->
#      console.log window.datas
#      window.videoObject.SetDisplayArea?(0, 0, 960, 540)
#      window.videoObject.Play window.datas
#    videoObject

    new SamsungVideoPlayer videoObject


else #in case of a browser, sets some needed keys to numeric keys
  log "is otra cosa :P"
  Platform.keyCodes.VK_PLAY=     49  #number 1
  Platform.keyCodes.VK_PAUSE=    50  #number 2
  Platform.keyCodes.VK_STOP=     51  #number 3
  Platform.keyCodes.VK_REWIND=   52  #4
  Platform.keyCodes.VK_FAST_FWD= 53  #5

  Platform.keyCodes.VK_RED =     55 #7
  Platform.keyCodes.VK_GREEN=    56 #8
  Platform.keyCodes.VK_BLUE=     57 #9
  Platform.keyCodes.VK_YELLOW=   48 #0

  Platform.keyCodes.VK_BACK =    8 #Backspace

  Platform.getVideoInterface= (videoObject) ->
    videoObject.setData = (data) ->
      @src = data #this en este caso corresponde al objeto de video
    videoObject
    new DummyVideo()
  Platform.exit = ->
    history.back()

#window.addEventHandler= (obj, eventName, handler)->
#  if document.attachEvent
#    obj.attachEvent("on" + eventName, handler);
#  else if document.addEventListener
#    obj.addEventListener(eventName, handler, false);
#

initNavigator = ->
#  if true or document.activeElement == undefined
#    onFocus = (e)->
#      #    log "a focused element"
#      #    console.log e
#      document.activeElement2 = e.target
##      $(".focuseado").removeClass("focuseado")
##      $(document.activeElement2).addClass("focuseado")
#    #  console.log e.target
#    #    a= []
#    #    for i of e
#    #      a.push(i)
#    #      console.log e[i] == undefined
#    #    console.log a.join ' '
#    #      log $(e.target).attr("class")
#    #         log e.target.className
#    document.body.addEventListener("focus", onFocus, true);

  navigate = (direction) ->
    try
      activeElement = document.activeElement
#      return false unless activeElement
      attrStyles = activeElement.attributes.style
#      return false unless attrStyles
      styles = attrStyles.value.split(';')
      navValue = styles.filter((elem)->
        return elem.search("nav-#{direction}:") > -1
      )[0]
#      return false unless navValue
      nextElement = navValue.split(':')[1]
      nextElement = nextElement.replace(/#/,'')
      document.getElementById(nextElement).focus()
    catch error
#      console.log error
      return false
    true

  keyHandler = []
  keyHandler[Platform.keyCodes.VK_LEFT]  = ->
    log 'l'
    navigate 'left'
  keyHandler[Platform.keyCodes.VK_RIGHT] = ->
    log 'r'
    navigate 'right'
  keyHandler[Platform.keyCodes.VK_UP]    = ->
    log 'u'
    navigate 'up'
  keyHandler[Platform.keyCodes.VK_DOWN]  = ->
    log 'd'
    navigate 'down'
  keyHandler[Platform.keyCodes.VK_ENTER] = ->
    document.activeElement.click()
    true

  keypressed = (e)->
    if keyHandler[e.keyCode] and keyHandler[e.keyCode]()
      e.stopPropagation()
      e.preventDefault()


  window.addEventListener("keydown", keypressed, true);
#  addEventHandler(document.body, "keydown", keypressed)

window.addEventListener("load", initNavigator, false);

#exports
window.Platform = Platform



