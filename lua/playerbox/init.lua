local socket = require("socket")
-- local inspect = require("inspect")
local sonos = require("playerbox.sonos")
local device_window = require("playerbox.device_window")

---@class Device

---@class PlayerBox
---@field activeDevice Device | nil
-- @field devices
local PlayerBox = {}

---@return PlayerBox
function PlayerBox.new()
	local self = setmetatable({
		devices = {},
		activeDevice = nil,
	}, PlayerBox)
	return self
end

---@param opts PlayerBoxOptions
function PlayerBox:setup(opts)
	self._discover()
end

function PlayerBox:show_list()
	--
end

PlayerBox._discover = function()
	local udp = socket.udp()

	local discover_packet = table.concat({
		"M-SEARCH * HTTP/1.1\r\n",
		"HOST: 239.255.255.250:1900\r\n",
		'MAN: "ssdp:discover"\r\n',
		"MX: 2\r\n",
		"ST: ",
		"urn:schemas-upnp-org:device:ZonePlayer:1",
		"\r\n",
		"\r\n",
	})

	udp:settimeout(10)

	local _, err = udp:sendto(discover_packet, "239.255.255.250", 1900)
	if err then
		print("failed to send discover packet")
	end
	-- wait for replay
	local discover_response, ip, _ = udp:receivefrom()
	if discover_response == nil then
		return 1
	end

	-- if we don't have the ip in the table add the new device
	if not PlayerBox.devices[ip] then
		PlayerBox.devices[ip] = sonos.new({ hostname = ip })
	end

	return PlayerBox.devices[ip]
end
-- M.setup = function(opts)
-- 	print("Options:", opts)
-- end

PlayerBox.info = function() end
PlayerBox.playpause = function() end

local device = PlayerBox.discover()
local err = device.Play()

--[[
lua require("playertest").
--]]

return PlayerBox.new()
