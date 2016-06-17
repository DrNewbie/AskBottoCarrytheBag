_G.BotCarryBags = _G.BotCarryBags or {}

BotCarryBags.options_menu = "BotCarryBags_menu"
BotCarryBags.ModPath = ModPath
BotCarryBags.SaveFile = BotCarryBags.SaveFile or SavePath .. "BotCarryBags.txt"
BotCarryBags.ModOptions = BotCarryBags.ModPath .. "menus/modoptions.txt"
BotCarryBags.settings = BotCarryBags.settings or {}
BotCarryBags.LogicPath = "mods/Ask Bot to Carry the Bag/lua/MoveBagsLogic/"
BotCarryBags.LogicMenu = {}

Hooks:Add("LocalizationManagerPostInit", "BotCarryBags_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["BotCarryBags_menu_title"] = "Bot Carry Bags",
		["BotCarryBags_menu_desc"] = "",
	})
end)

if file.GetFiles(BotCarryBags.LogicPath) then
	for _, path in pairs(file.GetFiles(BotCarryBags.LogicPath)) do
		table.insert(BotCarryBags.LogicMenu, tostring(path))
	end
end

Hooks:Add("MenuManagerSetupCustomMenus", "BotCarryBagsOptions", function( menu_manager, nodes )
	MenuHelper:NewMenu( BotCarryBags.options_menu )
end)

Hooks:Add("MenuManagerPopulateCustomMenus", "BotCarryBagsOptions", function( menu_manager, nodes )
	local file = io.open("mods/Ask Bot to Carry the Bag/lua/Keybinds_Functions.lua", "w")
	if file then
		for k, v in pairs(BotCarryBags.LogicMenu or {}) do
			local _id = "AskBotDo_Key_" .. k
			local key = LuaModManager:GetPlayerKeybind(_id) or ("f" .. k)
			MenuHelper:AddKeybinding({
				id = _id,
				title = v,
				connection_name = _id,
				button = key,
				binding = key,
				menu_id = BotCarryBags.options_menu,
				localized = false,
			})
			local _callback_name = "BotCarryBags_Logic_Callback_" .. k
			file:write("	MenuCallbackHandler.".. _callback_name .." = function() \n")
			file:write("		dofile(\"".. BotCarryBags.LogicPath .. v .."\") \n")
			file:write("	end \n")
			file:write("	LuaModManager:AddKeybinding(\"".. _id .."\", callback(MenuCallbackHandler, MenuCallbackHandler, \"".. _callback_name .."\")) \n")
		end
		file:close()
		dofile("mods/Ask Bot to Carry the Bag/lua/Keybinds_Functions.lua")
	end
end)
Hooks:Add("MenuManagerBuildCustomMenus", "BotCarryBagsOptions", function(menu_manager, nodes)
	nodes[BotCarryBags.options_menu] = MenuHelper:BuildMenu( BotCarryBags.options_menu )
	MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu, BotCarryBags.options_menu, "BotCarryBags_menu_title", "BotCarryBags_menu_desc", 1 )
end)