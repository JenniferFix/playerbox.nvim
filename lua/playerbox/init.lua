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
		vim.notify("Sending discovery")
		-- udp_send_handle:bind("0.0.0.0", 1900)

		udp_send_handle:recv_start(function(err, data, addr, flags)
			if err ~= nil then
				print(err)
				return
			end
			-- assert(not err, err)
			vim.notify(addr.ip .. ":" .. addr.port)
			vim.notify(data)
			udp_send_handle:close()
		end)
	end)
end

return M
