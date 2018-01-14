-- Copyright © 2008-2018 Pioneer Developers. See AUTHORS.txt for details
-- Licensed under the terms of the GPL v3. See licenses/GPL-3.txt

local Engine = import('Engine')
local Game = import('Game')
local ui = import('pigui/pigui.lua')
local Vector = import('Vector')
local Color = import('Color')
local Lang = import("Lang")
local lc = Lang.GetResource("core");
local lui = Lang.GetResource("ui-core");
local utils = import("utils")
local Event = import("Event")

local player = nil
local pionillium = ui.fonts.pionillium
local pionicons = ui.fonts.pionicons
local colors = ui.theme.colors
local icons = ui.theme.icons

local iconSize = Vector(16,16)

local font = pionillium.medium
local width = 120 + 120 * (ui.screenWidth / 1200)
local height = math.max(iconSize.y, font.size) * 3

local function displayPlanetaryInfo()
	local player = Game.player
	local alt, vspd, latitude, longitude = player:GetGPS()
	if latitude and longitude and alt and vspd then
		ui.setNextWindowSize(Vector(width, height), "Always")
		ui.setNextWindowPos(Vector(ui.screenWidth - width, ui.screenHeight - height), "Always")
		ui.window("PlanetaryInfo", {"NoTitleBar", "NoResize", "NoFocusOnAppearing", "NoBringToFrontOnFocus"},
							function()
								ui.withFont(font.name, font.size, function()
															ui.columns(2, "", false)
															ui.icon(icons.altitude, iconSize, colors.reticuleCircle)
															ui.sameLine()
															local altitude,altitude_unit = ui.Format.Distance(alt)
															ui.text(altitude .. altitude_unit)
															ui.icon(icons.normal, iconSize, colors.reticuleCircle)
															ui.sameLine()
															local speed,speed_unit = ui.Format.Speed(vspd)
															ui.text(speed .. speed_unit)
															ui.nextColumn()
															ui.icon(icons.latitude, iconSize, colors.reticuleCircle)
															ui.sameLine()
															ui.text(ui.Format.Latitude(latitude))
															ui.icon(icons.longitude, iconSize, colors.reticuleCircle)
															ui.sameLine()
															ui.text(ui.Format.Longitude(longitude))
								end)
		end)
	end
end

local function displayOrbitalData()
	local player = Game.player
	local orbital_data = player:GetOrbitalData();
	ui.setNextWindowSize(Vector(width, height), "Always")
	ui.setNextWindowPos(Vector(ui.screenWidth - width, ui.screenHeight - height - height), "Always")
	ui.window("Orbital Info", {"NoTitleBar", "NoResize", "NoFocusOnAppearing", "NoBringToFrontOnFocus"},
		function()
			ui.withFont(font.name, font.size, function()
				ui.columns(2, "", false)
				local ecc, ecc_unit = ui.Format.Ecc(orbital_data.ecc)
				local apa, apa_unit = ui.Format.Distance(orbital_data.ApA)
				local pea, pea_unit = ui.Format.Distance(orbital_data.PeA)
				local per = ui.Format.Duration(orbital_data.Per)
				ui.text('ApA ' .. apa .. apa_unit)
				ui.text('PeA ' .. pea .. pea_unit)
				ui.nextColumn()
				ui.text('Ecc ' .. ecc )
				ui.text('Per ' .. per)
				-- ui.sameLine()
			end)
		end)
end
ui.registerModule("game", displayPlanetaryInfo)
ui.registerModule("game", displayOrbitalData)

return {}
