---@class DeviceWindow
---@field buf_id number
---@field win_id number
---@field closing boolean
---@field _display table<string>
local DeviceWindow = {}
DeviceWindow.__index = DeviceWindow

---@return DeviceWindow
function DeviceWindow.new()
	local self = setmetatable({
		---
	}, DeviceWindow)
	return self
end

local function get_window_config()
	return {
		relative = "editor",
		anchor = "NW",
		row = 0,
		col = 10,
		width = 50,
		height = 4,
		border = "single",
		title = "",
	} --
end

local function close_window(win_id, buf_id)
	if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
		vim.api.nvim_win_close(win_id, true)
	end

	if buf_id ~= nil and vim.api.nvim_buf_is_valid(buf_id) then
		vim.api.nvim_buf_delete(buf_id, { force = true })
	end
end

local function create_window()
	local buf_id = vim.api.nvim_create_buf(false, true)
	local win_id = vim.api.nvim_open_win(buf_id, false, get_window_config())
	return buf_id, win_id
end

function DeviceWindow:show()
	---
end

function DeviceWindow:close()
	if self.buf_id ~= nil then
		self.closing = true
		close_window(self.win_id, self.buf_id)
		self.buf_id = nil
		self.win_id = nil
		self.closing = false
	end
end

function DeviceWindow:toggle()
	if self.win_id == nil then
		local buf_id, win_id = create_window()
		self.buf_id = buf_id
		self.win_id = win_id
	else
		self:close()
	end
end

return DeviceWindow.new()
