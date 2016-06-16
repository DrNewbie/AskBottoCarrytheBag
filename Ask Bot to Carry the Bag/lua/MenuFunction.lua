_G.BotCarryBags = _G.BotCarryBags or {}

BotCarryBags.options_menu = "BotCarryBags_menu"
BotCarryBags.ModPath = ModPath
BotCarryBags.SaveFile = BotCarryBags.SaveFile or SavePath .. "BotCarryBags.txt"
BotCarryBags.ModOptions = BotCarryBags.ModPath .. "menus/modoptions.txt"
BotCarryBags.settings = BotCarryBags.settings or {}
BotCarryBags.LogicPath = "mods/Ask Bot to Carry the Bag/lua/MoveBagsLogic/"
BotCarryBags.LogicMenu = {}
BotCarryBags.LogicSelect = 0

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
	MenuCallbackHandler.BotCarryBags_logic_button_callback = function(self, item)
		dofile(BotCarryBags.LogicPath .. "" .. item._priority)
	end
	for k, v in pairs(BotCarryBags.LogicMenu or {}) do
		MenuHelper:AddButton({
			id = "BotCarryBags_logic_button_callback",
			title = v,
			callback = "BotCarryBags_logic_button_callback",
			menu_id = BotCarryBags.options_menu,
			priority = v,
			localized = false
		})
	end
end)

Hooks:Add("MenuManagerBuildCustomMenus", "BotCarryBagsOptions", function(menu_manager, nodes)
	nodes[BotCarryBags.options_menu] = MenuHelper:BuildMenu( BotCarryBags.options_menu )
	MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu, BotCarryBags.options_menu, "BotCarryBags_menu_title", "BotCarryBags_menu_desc", 1 )
end)