#Return an object like:
#{ hours:
#  minutes:
#  seconds:
# }
class Time

  constructor:(timeInMiliseconds)->
    @totalMiliSeconds = timeInMiliseconds

  getMiliseconds: =>
    return @totalMiliSeconds

  #returns time with fotmat: hh:mm:ss
  toString: (guide) =>
    @string ||= @generateFormattedTime guide

  # Return seconds as H:MM:SS or M:SS
  # Supplying a guide (in seconds) will include enough leading zeros to cover
  # the length of the guide
  generateFormattedTime: (guide) ->
    seconds = @totalMiliSeconds / 1000
    guide ||= seconds # Default to using seconds as guide
    s = Math.floor(seconds % 60)
    m = Math.floor(seconds / 60 % 60)
    h = Math.floor(seconds / 3600)
    gm = Math.floor(guide / 60 % 60)
    gh = Math.floor(guide / 3600)

    # Check if we need to show hours
    h = if h > 0 || gh > 0 then h + ":" else ""

    # If hours are showing, we may need to add a leading zero.
    # Always show at least one digit of minutes.
    m = if (h || gm >= 10) && m < 10
      "0" + m + ":"
    else
      m + ":"

    # Check if leading zero is need for seconds
    s = "0" + s if s < 10

    return h + m + s

Date::humanizedString = ->
    now  = new Date()
    diff = Number(now) - Number(@)

    SECOND = 1000
    MINUTE = 60 * SECOND
    HOUR = 60 * MINUTE
    # If date is today show time interval.
    if diff < 24 * HOUR
      if diff < HOUR
        'hace unos minutos'
      else
        "hace #{Math.floor(diff / HOUR)} horas"
    else
      "#{@getDate()}/#{@getMonth() + 1}/#{@getFullYear()}"

# EXPORTS
window.Time = Time
