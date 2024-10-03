local BaseService = {}

function BaseService:new(opts)
	opts = {
		name = opts.name,
		ip = opts.ip,
		port = opts.port or 1400,
		controlUrl = opts.controlUrl,
		eventSubUrl = opts.eventSubUrl,
		SCPDURL = opts.SCPDURL,
	}
	setmetatable(opts, self)
	self.__index = self
	return opts
end

function BaseService:request(action, opts)
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
