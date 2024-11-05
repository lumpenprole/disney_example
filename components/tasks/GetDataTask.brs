sub init()
    m.top.functionName = "getData"
end sub

sub getData()
    finalData = CreateObject("roSGNode", "ContentNode")
    dataTransfer = CreateObject("roURLTransfer")
    dataTransfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    dataTransfer.AddHeader("X-Roku-Reserved-Dev-Id", "")
    dataTransfer.InitClientCertificates()
    dataTransfer.setUrl("https://cd-static.bamgrid.com/dp-117731241344/home.json")
    jsonData = ParseJson(dataTransfer.getToString())
    containers = jsonData.data.StandardCollection.containers
    for x = 0 to containers.count() - 1
        row = containers[x]
        rowContent = CreateObject("roSGNode", "ContentNode")
        rowContent.title = row.set.text.title.full.set.default.content
        itemCount = row.set.items?.count?()
        if itemCount <> invalid
            for y = 0 to itemCount - 1
                rowContent.appendChild(handleItem(row.set.items[y]))
            end for
        else
            rowRequest = CreateObject("roURLTransfer")
            refId = row.set.refId
            rowUrl = "https://cd-static.bamgrid.com/dp-117731241344/sets/"+ refId + ".json" 
            rowRequest.SetCertificatesFile("common:/certs/ca-bundle.crt")
            rowRequest.AddHeader("X-Roku-Reserved-Dev-Id", "")
            rowRequest.InitClientCertificates()
            rowRequest.setUrl(rowUrl)
            rowJson = ParseJson(rowRequest.getToString())
            if rowJson.data?.CuratedSet <> invalid
                rowItems = rowJson.data.CuratedSet.items
            else if rowJson.data.TrendingSet <> invalid
                rowItems = rowJson.data.TrendingSet.items
            end if
            for y = 0 to rowItems.count() - 1
                rowContent.appendChild(handleItem(rowItems[y]))
            end for 
        end if
        finalData.appendChild(rowContent)
    end for
    m.top.data = finalData
end sub

function handleItem(json) as object
    itemContent = CreateObject("roSGNode", "ContentNode")
    imageData = json.image.tile["1.78"]
    if json.type = "DmcVideo"
        itemContent.title = json.text.title.full.program.default.content
        itemContent.HDPosterUrl = imageData.program.default.url
    else if json.type = "StandardCollection"
        itemContent.title = json.text.title.full.collection.default.content
        itemContent.HDPosterUrl = imageData.default.default.url
    else
        itemContent.title = json.text.title.full.series.default.content
        itemContent.HDPosterUrl = imageData.series.default.url
    end if
    return itemContent
end function