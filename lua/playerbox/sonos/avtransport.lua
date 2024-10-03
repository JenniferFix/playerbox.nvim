local AVTransport = require("playerbox.sonos.base")
AVTransport.__index = AVTransport

function AVTransport:Play()
	self:request()
end

return AVTransport
