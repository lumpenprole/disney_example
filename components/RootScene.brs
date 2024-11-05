sub init()
    m.mainRowList = m.top.findNode("main_row_list")
    getData()
end sub

sub getData()
    m.getDataTask = CreateObject("roSGNode", "GetDataTask")
    m.getDataTask.observeField("data", "handleData")
    m.getDataTask.control = "RUN"
end sub

sub handleData()
    rowListData = m.getDataTask.data
    m.mainRowList.content = rowListData
    m.mainRowList.setFocus(true)
end sub