local client = {}

local found_curl, curl = pcall(require, "cURL.safe")

function client.go()
	print(found_curl)
end

return client
