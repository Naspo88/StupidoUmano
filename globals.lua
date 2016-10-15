-- globals initiliaze
local M = {}

-- global variables
local margins = 5
local scale = 1.05
local timeInSecond = 600
local timeFont = "fonts\\Action_Man.ttf"

-- global functions
local function formatText (time, timeTxt)
	local function getLetter (t)
		if (t >= 3600) then
			return "h"
		elseif (t < 3600 and t >= 60) then
			return "m"
		else
			return "s"
		end
	end

	local k = getLetter(time)
	
	local h = math.floor(time / 3600)
	time = time - (h * 3600)
	local m = math.floor(time / 60)
	time = time - (m * 60)
	local s = time

	if (h == 0) then
		h = ""
	else
		h = h .. ":"
	end

	if ((m >= 10) or (m < 10 and m ~= 0 and h == "")) then
		m = m .. ":"
	elseif (m < 10 and h ~= "") then
		m = "0" .. m .. ":"
	else
		m = ""
	end

	if (s < 10) then
		s = "0" .. s
	end

	timeTxt.text = h .. m .. s .. k
end

local function getPosition (data)
	local offset = {
		top = data.top or 0,
		left = data.left or 0,
		bottom = data.bottom or 0,
		right = data.right or 0
	}

	local x = (display.contentWidth*data.x)+offset.right-offset.left
	local y = (display.contentHeight*data.y)+offset.top-offset.bottom
	return x, y
end

local function getDimension (w, h, percWith, margin)
	percWith = percWith or 100
	margin = margin or margins

	local maxWidth = (( display.contentWidth / 100 ) * percWith ) - margin*2
	local ratio = maxWidth / w
	local finalH = h * ratio

	return maxWidth, finalH
end

-- globals assign
M.margins = margins
M.scale = scale
M.timeInSecond = timeInSecond
M.timeFont = timeFont
M.formatText = formatText
M.getPosition = getPosition
M.getDimension = getDimension

return M