function init()
	? "[home_scene] init"

	m.top.backgroundURI = ""
	m.top.backgroundColor = "0xFFFFFFFF"
	fetch()
end function

sub fetch()
	m.downloadSubsTask = CreateObject("roSGNode", "WebFetcher")
	m.downloadSubsTask.observeField("content", "setContent")
	m.downloadSubsTask.control = "RUN"
end sub

sub setContent()
	' print m.downloadSubsTask.content
	paint(m.downloadSubsTask.content, {})
end sub