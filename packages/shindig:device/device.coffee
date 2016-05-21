
# todo
# - windows, safari, chrome, firefox
# - mobile, desktop, blackberry, windows phone

match = (regex) -> regex.test(navigator.userAgent)
any = (args...) ->
  for arg in args
    if Device[arg]() then return true
  return false

Device.iPhone  = -> match /iPhone/i
Device.iPod    = -> match /iPod/i
Device.iPad    = -> match /iPad/i
Device.iOS     = -> any 'iPhone', 'iPad', 'iPod'
Device.Android = -> match /Android/i
Device.Kindle  = -> match /Kindle/i
Device.Mac     = -> match /Macintosh/i
Device.Linux   = -> match /Linux/i

# Device.Firefox
Device.Safari  = -> match(/Safari/i) and not match(/Chrome/i)
Device.Chrome = -> match /Chrome/i
#
# Device.mobile
# Device.desktop
# Device.tablet
