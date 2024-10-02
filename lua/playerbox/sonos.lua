local SonosDevice = {}
SonosDevice.__index = SonosDevice

function SonosDevice.new(host)
	local self = setmetatable({
		ip = host,
	}, SonosDevice)
	return self
end

function SonosDevice:play()
	--
end

function SonosDevice:pause()
	--
end

return SonosDevice
