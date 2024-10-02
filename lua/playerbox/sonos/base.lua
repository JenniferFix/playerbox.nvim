local BaseService = {}

function BaseService.request()
	-- print(found_curl)
	local curl_cmd = { "curl", "https://cat-fact.herokuapp.com/facts" }
	local opts = {
		text = true,
	}
	-- local ok, e = pcall(vim.system, curl_cmd, opts, finished)
	local ob = vim.system(curl_cmd, opts, finished)
	-- print(ok)
	-- vim.notify(vim.inspect(e))
end

return BaseService
