sub init()
    m.itemImage = m.top.findNode("item_image")
    m.itemTitle = m.top.findNode("item_title")

    m.itemImage.failedBitmapUri = "pkg:/img/default_image.jpg"
end sub

sub handleData()
    data = m.top.itemContent
    'm.itemTitle.text = data.title
    m.itemImage.uri = data.HDPosterUrl
end sub

sub showFocus()
    scale = 1 + (m.top.focusPercent * 0.08)
    m.itemImage.scale = [scale, scale]
end sub