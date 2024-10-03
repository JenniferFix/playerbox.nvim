local AVTransport = {}
local base = require("playerbox.sonos.base")
AVTransport.__index = AVTransport

function AVTransport:new(opts)
	opts = {
		name = "AVTransport",
		ip = opts.ip,
		port = opts.port or 1400,
		controlUrl = "/MediaRenderer/AVTransport/Control",
		eventSubUrl = "/MediaRenderer/AVTransport/Event",
		SCPDURL = "/xml/AVTransport1.xml",
	}
	setmetatable(opts, base:new(opts))
end

function AVTransport:Play()
	self:request()
end

return AVTransport
