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
	local uv = vim.uv
	local udp_send_handle = uv.new_udp()
	udp_send_handle:send(discover_packet, "239.255.255.250", 1400, function(err)
		if err ~= nil then
			print(err)
		end
		-- vim.notify("sending")
	end)
	local udp_receive_handle = uv.new_udp()
	udp_receive_handle:bind("0.0.0.0", 1400)
	udp_receive_handle:recv_start(function(err)
		assert(not err, err)
		udp_receive_handle:recv_start(function(err, data, add, flags)
			assert(not err, err)
			print(data)
		end)
	end)
end

function M.discover()
	--
	print("hello")
end

return M
