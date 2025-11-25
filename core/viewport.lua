local math = math
local floor = math.floor

local viewport = {
	scale = 1,
	offset_x = 0,
	offset_y = 0,
	width = 0,
	height = 0,
}

local BATCH

function viewport.init(batch, width, height)
	BATCH = batch
	viewport.width = width
	viewport.height = height
end

function viewport:resize(w, h)
	if not w or not h or w <= 0 or h <= 0 then
		self.scale = 1
		self.offset_x = 0
		self.offset_y = 0
		return
	end

	local scale = math.min(w / self.width, h / self.height)
	if scale <= 0 then
		scale = 1
	end

	self.scale = scale
	local scaled_w = self.width * scale
	local scaled_h = self.height * scale
	self.offset_x = floor((w - scaled_w) * 0.5)
	self.offset_y = floor((h - scaled_h) * 0.5)
end

function viewport:begin_draw()
	BATCH:layer(self.scale, self.offset_x, self.offset_y)
end

function viewport:end_draw()
	BATCH:layer()
end

function viewport:screen_to_world(x, y)
	local scale = self.scale
	if scale <= 0 then
		scale = 1
	end
	local wx = (x - self.offset_x) / scale
	local wy = (y - self.offset_y) / scale
	return wx, wy
end

return viewport
