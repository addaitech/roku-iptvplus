playlistUrl = "https://raw.githubusercontent.com/Free-TV/IPTV/master/playlist.m3u8"
channelList = []
currentChannelIndex = 0

sub init()
    m.top.backgroundURI = "pkg:/images/rsgde_bg_hd.jpg"
    m.video = m.top.findNode("video")
    m.video.observeField("state", "stateChanged")
    m.guide = m.top.findNode("guide")
    m.guide.text = "Today's TV Guide: \n\n" + getGuideText()

    playList = createObject("roUrlTransfer")
    playList.setUrl(playlistUrl)
    playlistData = playList.GetToString()

    channelList = parseChannels(playlistData)
    currentChannelIndex = 0
    stateChanged()
end

sub stateChanged()
    if m.video.state = "ready"
        m.video.stream = createObject("roUrlTransfer")
        m.video.stream.setUrl(channelList[currentChannelIndex])
        m.video.control = "play"
    end if
end

sub changeChannel(direction)
    if direction = "next"
        currentChannelIndex = (currentChannelIndex + 1) mod length(channelList)
    else
        currentChannelIndex = (currentChannelIndex - 1 + length(channelList)) mod length(channelList)
    end if
    m.video.control = "stop"
    m.video.stream = createObject("roUrlTransfer")
    m.video.stream.setUrl(channelList[currentChannelIndex])
    m.video.control = "play"
end

sub getGuideText()
    guideText = "6:00 AM - Morning News\n"
    guideText = guideText + "7:00 AM - Cartoons\n"
    guideText = guideText + "9:00 AM - Documentary\n"
    guideText = guideText + "12:00 PM - Soap Opera\n"
    guideText = guideText + "1:00 PM - Cooking Show\n"
    guideText = guideText + "5:00 PM - Sports\n"
    guideText = guideText + "7:00 PM - Prime-time dramas\n"
    guideText = guideText + "10:00 PM - Late Night Talk Show\n"
    return guideText
end

sub parseChannels(playlistData)
    channels = split(playlistData, "\n")
    result = []
    for each in channels
        if startsWith(each, "#")
            continue
        end if
        result.push(each)
    end for
    return result
end

