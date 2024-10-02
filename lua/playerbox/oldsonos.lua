---@class SonosDevice
---@field hostname string
---@field port integer
local SonosDevice = {}
SonosDevice.__index = SonosDevice
--
-- Urls
SonosDevice.avControlURL = "/MediaRenderer/AVTransport/Control"
-- this.eventSubURL = '/MediaRenderer/AVTransport/Event'
-- this.SCPDURL = '/xml/AVTransport1.xml'

function SonosDevice:new(opts)
	opts = opts or {}
	SonosDevice.serviceName = "AVTransport"
	SonosDevice.hostname = opts.hostname or ""
	SonosDevice.port = opts.port or 1400

	local sonosdevice = setmetatable({
		hostname = opts.hostname or "",
		port = opts.port or 1400,
	}, self)
	return sonosdevice
end

local soapWrap = function(body)
	return '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">'
		.. "<s:Body>"
		.. body
		.. "</s:Body>"
		.. "</s:Envelope>"
end

function SonosDevice:request(item, action, opts)
	opts = opts or {}
	-- craft an http request for the given action
	--const messageAction = `"urn:schemas-upnp-org:service:${this.name}:1#${action}"`
	local url = "http://" .. SonosDevice.hostname .. ":" .. SonosDevice.port .. ":" .. SonosDevice.avControlURL
	--local action = '"urn:schemas-upnp-org:service:' .. SonosDevice.serviceName .. ":1#" .. action .. '"'
	local actionString = string.format('"urn:schemas-upnp-org:service:%s:1#%s"', SonosDevice.serviceName, action)
	-- let messageBody = `<u:${action} xmlns:u="urn:schemas-upnp-org:service:${this.name}:1">`
	local messageBody = string.format("<u:%s %s:1>", action, SonosDevice.serviceName)

	for k, v in pairs(opts) do
		-- messageBody += `<${key}>${variables[key]}</${key}>`
		messageBody = messageBody .. string.format("<%s>%s</%s>", k, v, k)
	end

	--messageBody += `</u:${action}>`
	messageBody = messageBody .. "</u:" .. action .. ">"
	local responsebody = {}
	local response, responsecode, responseheaders, responsestatus = http.request({
		url = url,
		method = "POST",
		source = ltn12.source.string(soapWrap(messageBody)),
		sink = ltn12.sink.table(responsebody),
	})
	print(responsebody)
	print(response)
	print(responsecode)
	print(responseheaders)
	print(responsestatus)
end

function SonosDevice:Play()
	self.request(self, "Play", {
		["InstanceId"] = 0,
		["Speed"] = 1,
	})
end

return SonosDevice
