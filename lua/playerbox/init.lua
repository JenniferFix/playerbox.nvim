local Sonos = require("playerbox.sonos")
local curl = require("playerbox.curl")
local M = {}

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

M.setup = function()
	--
end

function M.discover()
	local uv = vim.uv

	local udp_send_handle = uv.new_udp()

	udp_send_handle:send(discover_packet, "239.255.255.250", 1900, function(err)
		if err ~= nil then
			print(err)
			return
		end
		-- vim.notify("Sending discovery")
		-- udp_send_handle:bind("0.0.0.0", 1900)

		udp_send_handle:recv_start(function(err, data, addr, flags)
			if err ~= nil then
				print(err)
				return
			end
			-- assert(not err, err)
			local i = string.find(data, "Sonos")
			if i > 0 then
				print("Found Sonos device")
				M.active_device = Sonos:new({ hostname = addr.ip })
			end
			-- vim.notify(addr.ip .. ":" .. addr.port)

			udp_send_handle:close()
			-- need to verify it's a proper device and then set a new activedevice
		end)
	end)
end

function M.go()
	curl.go()
end

return M
