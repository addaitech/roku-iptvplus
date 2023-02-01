'Create an IPTV player and channel list from the playlist URL
m3u8Url = "https://raw.githubusercontent.com/Free-TV/IPTV/master/playlist.m3u8"

'Fetch the playlist from the URL
urlTransfer = CreateObject("roUrlTransfer")
urlTransfer.setUrl(m3u8Url)
playlist = urlTransfer.GetToString()

'Parse the playlist into an array of channels
channelLines = split(playlist, "\n")
channels = []
for i = 1 to UBound(channelLines)
    if channelLines[i][0] = "#" then
        continue
    end if
    channels.Push(channelLines[i])
end for

'Create a function to display the channel list
function displayChannelList()
    'Create a TextScreen to display the channel list
    text = CreateObject("roTextScreen")
    text.SetText("Channels:\n\n")
    for i = 1 to UBound(channels)
        text.AppendText(i + ". " + channels[i] + "\n")
    end for
    text.Show()

    'Listen for user input to select a channel
    while true
        'Get the user input
        input = wait(0, text.GetUserInput())

        'Check if the user selected a channel
        if input >= 1 and input <= UBound(channels) then
            'Play the selected channel
            text.Close()
            playChannel(channels[input-1], i-1)
            return
        'Check if the user wants to return to the video
        else if input = "back" then
            text.Close()
            return
        end if
    end while
end function

'Create a function to play a channel
function playChannel(channelUrl, channelIndex)
    'Create a VideoScreen to play the channel
    video = CreateObject("roVideoScreen")
    video.SetContent(channelUrl)
    video.Show()

    'Listen for user input to access the EPG or return to the channel list
    while true
        'Get the user input
        input = wait(0, video.GetUserInput())

        'Check if the user wants to access the EPG
        if input = "info" then
            video.Pause()
            displayEpg(channelIndex)
            video.Resume()
        'Check if the user wants to return to the channel list
        else if input = "back" then
            video.Close()
            displayChannelList()
            return
        end if
    end while
end function

'Fetch the EPG data from the URL
urlTransfer = CreateObject("roUrlTransfer")
urlTransfer.setUrl("http://example.com/epg.json")
epgJson = urlTransfer.GetToString()

'Parse the EPG data from JSON
epg = parseJson(epgJson)

'Create a function to display the EPG data
function displayEpg(channelIndex)
    'Extract the program information for the selected channel
    programs = epg.channels[channelIndex].programs

    'Create a TextScreen to display the program information
    text = CreateObject("roTextScreen")
    text.SetText("Programs:\n\n")
    for i = 1 to UBound(programs)
        text.AppendText(programs[i].title + ": " + programs[i].startTime + " to " + programs[i].endTime + "\n")
    end for
    text.Show()

    'Listen for user input to return to the video
    while true
        'Get the user input
        input = wait(0, text.GetUserInput())

        'Check if the user wants to return to the video
        if input = "back" then
            text.Close()
            return
        end if
    end while
end function

'Display the channel list to start
displayChannelList()
