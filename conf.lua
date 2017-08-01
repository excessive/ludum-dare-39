
io.stdout:setvbuf("no")
local path = love.filesystem.getRequirePath()
path = path .. ";libs/?.lua"
path = path .. ";libs/?/init.lua"
love.filesystem.setRequirePath(path)

require "love.math"
require "love.system"
require "love.window"

local function split(str, sep)
	local patternescape = function(str)
		return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", "%%%1")
	end
	local function array(...)
		local t = {}
		for x in ... do t[#t + 1] = x end
		return t
	end
	if not sep then
		return lume.array(str:gmatch("([%S]+)"))
	else
		assert(sep ~= "", "empty separator")
		local psep = patternescape(sep)
		return array((str..sep):gmatch("(.-)("..psep..")"))
	end
end

local flags = {
	hidpi = true,
	width = 1920,
	height = 1080
}

if love.system.getOS() == "Linux" then
	local f         = io.popen("gsettings get org.gnome.desktop.interface scaling-factor")
	local _scale    = split(f:read() or "it's 1", " ")
	local dpi_scale = _scale[2] and tonumber(_scale[2]) or 1.0

	if dpi_scale >= 0.5 then
		flags.width  = flags.width  * dpi_scale
		flags.height = flags.height * dpi_scale

		love.window.toPixels = function(v)
			return v * dpi_scale
		end

		love.window.getPixelScale = function()
			return dpi_scale
		end
	end
end

function love.conf(t)
	-- t.window = false
	-- t.modules.audio = false
	-- t.modules.sound = false
	t.modules.physics = false
	-- do return end
	t.window.title  = "PEW PEW PRINCESS LD39"
	t.window.width  = flags.width
	t.window.height = flags.height
	t.window.msaa   = 0
	t.window.hidpi  = flags.hidpi
	-- t.window.vsync  = false
	t.window.resizable = true
	t.gammacorrect  = true
end
