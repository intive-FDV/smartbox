#This file is only to allow compatibility with desktop browsers,
#and should not be included in the version for tv

#-------------------------------------------------------------------

#Used to simulate video function on emulator and opera browser
class DummyVideo
  _hardCodedPlayTime: 337000 # 00:05:37.0

  _stateCodes:
    STOPPED   : 0
    PLAYING   : 1
    PAUSED    : 2
    CONNECTING: 3
    BUFFERING : 4
    FINISHED  : 5
    ERROR     : 6

  _playVelocity: 0
  _playInterval: 100

  #Public prperties
  playTime: undefined
  playPosition: 0
  playState: 0
  _data: ""

  #private methods
  _playing: =>
    position = @playPosition + @_playVelocity * @_playInterval

    if position >= @playTime
      @playPosition = @playTime
      @_changePlayState @_stateCodes.FINISHED
      clearInterval @_playTimer
      return
    @playPosition = position


  _startPlaying: =>
    @playPosition = 0
    @_playing()
    @_playTimer = setInterval @_playing , @_playInterval
    if @_playVelocity == 0
      @_changePlayState @_stateCodes.PAUSED
    else
      @_changePlayState @_stateCodes.PLAYING

  _changePlayState: (newState) ->
    return if @playState == newState
    @playState = newState
    @onPlayStateChange()

  #Public methods
  seek: (time) =>
    @playPosition = time

  play: (velocity)=>
    if  @playState == @_stateCodes.FINISHED
      @_changePlayState @_stateCodes.STOPPED
    return if velocity == 0 and @playState == @_stateCodes.STOPPED
    @_playVelocity = velocity
    if velocity == 0
      return @_changePlayState @_stateCodes.PAUSED
    if @playState == @_stateCodes.STOPPED
      connecting = =>
        buffering= =>
          setTimeout @_startPlaying , 2000
          @_changePlayState  @_stateCodes.BUFFERING
        setTimeout buffering , 2000
        @_changePlayState  @_stateCodes.CONNECTING
      return setTimeout connecting , 1000
    return @_changePlayState @_stateCodes.PLAYING

  pause: =>
    @play 0

  stop: =>
    return unless @_playTimer?
    clearInterval @_playTimer
    @playPosition = 0
    @_changePlayState @_stateCodes.STOPED


  setData:(data)=>
    @_data = data


  onPlayStateChange: ->
    #This function can be overwriten to set a "listener" for status cahnges of the video object
    null

  constructor: ->
    @playTime = @_hardCodedPlayTime

#Log a message into a div for precarious debugging on the TV :)
#Assuming jQuery is defined or included
log = (message) ->
  $('#log').prepend "#{message} <br />"

logKeys = (e)->
    if e.keyCode == window.VK_GREEN
      $("#log").show()
    else if e.keyCode == window.VK_BLUE
      $("#log").hide()
    else if e.keyCode == window.VK_YELLOW
      $("#log").html ""

document.getElementsByTagName("body")[0].innerHTML += '<div id="log" style="visibility:visible;display:block;position:fixed;z-index:10000;float:right;top:0;right:0;max-width:50%;max-height:300px;background-color:rgba(0,0,0,0.7);color:#00a300;font-size:16px;overflow:hidden;"></div>'
document.getElementsByTagName("body")[0].onkeydown = logKeys

#EXPORTS
window.DummyVideo = DummyVideo
window.log = log