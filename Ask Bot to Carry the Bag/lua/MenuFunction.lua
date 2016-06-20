_G.BotCarryBags = _G.BotCarryBags or {}

BotCarryBags.options_menu = "BotCarryBags_menu"
BotCarryBags.ModPath = ModPath
BotCarryBags.SaveFile = BotCarryBags.SaveFile or SavePath .. "BotCarryBags.txt"
BotCarryBags.ModOptions = BotCarryBags.ModPath .. "menus/modoptions.txt"
BotCarryBags.settings = {
	shout_to_come_here = 1,
	shout_to_drop = 1,
	auto_pickup_bag = 0,
	lua_keybinds = 1,
}
BotCarryBags.LogicPath = "mods/Ask Bot to Carry the Bag/lua/MoveBagsLogic/"
BotCarryBags.LogicMenu = {}

function BotCarryBags:Reset()
	self.settings = {
		shout_to_come_here = 1,
		shout_to_drop = 1,
		auto_pickup_bag = 1,
		lua_keybinds = 1,
	}
	self:Save()
end

function BotCarryBags:Load()
	local file = io.open(self.SaveFile, "r")
	if file then
		for key, value in pairs(json.decode(file:read("*all"))) do
			self.settings[key] = value
		end
		file:close()
	else
		self:Reset()
	end
end

function BotCarryBags:Save()
	local file = io.open(self.SaveFile, "w+")
	if file then
		file:write(json.encode(self.settings))
		file:close()
	end
end

function BotCarryBags:Warning()
	local _dialog_data = {
		title = "Bot Carry MOD",
		text = "You need to reboot the game to apply this changing",
		button_list = {{ text = "[OK]", is_cancel_button = true }},
		id = tostring(math.random(0,0xFFFFFFFF))
	}
	managers.system_menu:show(_dialog_data)
end

BotCarryBags:Load()

Hooks:Add("LocalizationManagerPostInit", "BotCarryBags_loc", function(loc)
	LocalizationManager:add_localized_strings({
		["BotCarryBags_menu_title"] = "Bot Carry Bags",
		["BotCarryBags_menu_desc"] = "",
		["BotCarryBags_menu_shout_to_come_here_title"] = "Shout to Come Here",
		["BotCarryBags_menu_shout_to_come_here_desc"] = "Bot will go to your there when you shout to him and he has the bag.",
		["BotCarryBags_menu_auto_pickup_bag_title"] = "Auto Pickup Bag",
		["BotCarryBags_menu_auto_pickup_bag_desc"] = "Bot will pickup the bag if there is one around him.",
		["BotCarryBags_menu_lua_keybinds_title"] = "Keybinds for Logic",
		["BotCarryBags_menu_lua_keybinds_desc"] = "When this is ON, system will create keybinds to directly use logic.",
		["BotCarryBags_menu_shout_to_drop_title"] = "Shout to Drop",
		["BotCarryBags_menu_shout_to_drop_desc"] = "Bot will drop the bag when you shout to him",
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
	MenuCallbackHandler.BotCarryBags_shout_to_come_here_toggle_callback = function(self, item)
		if tostring(item:value()) == "on" then
			BotCarryBags.settings.shout_to_come_here = 1
		else
			BotCarryBags.settings.shout_to_come_here = 0
		end
		BotCarryBags:Save()
	end
	local _bool = BotCarryBags.settings.shout_to_come_here == 1 and true or false
	MenuHelper:AddToggle({
		id = "BotCarryBags_shout_to_come_here_toggle_callback",
		title = "BotCarryBags_menu_shout_to_come_here_title",
		desc = "BotCarryBags_menu_shout_to_come_here_desc",
		callback = "BotCarryBags_shout_to_come_here_toggle_callback",
		value = _bool,
		menu_id = BotCarryBags.options_menu,
	})
	MenuCallbackHandler.BotCarryBags_auto_pickup_bag_toggle_callback = function(self, item)
		if tostring(item:value()) == "on" then
			BotCarryBags.settings.auto_pickup_bag = 1
		else
			BotCarryBags.settings.auto_pickup_bag = 0
		end
		BotCarryBags:Save()
		BotCarryBags:Warning()
	end
	_bool = BotCarryBags.settings.auto_pickup_bag == 1 and true or false
	MenuHelper:AddToggle({
		id = "BotCarryBags_auto_pickup_bag_toggle_callback",
		title = "BotCarryBags_menu_auto_pickup_bag_title",
		desc = "BotCarryBags_menu_auto_pickup_bag_desc",
		callback = "BotCarryBags_auto_pickup_bag_toggle_callback",
		value = _bool,
		menu_id = BotCarryBags.options_menu,
	})
	MenuCallbackHandler.BotCarryBags_lua_keybinds_toggle_callback = function(self, item)
		if tostring(item:value()) == "on" then
			BotCarryBags.settings.lua_keybinds = 1
		else
			BotCarryBags.settings.lua_keybinds = 0
		end
		BotCarryBags:Save()
		BotCarryBags:Warning()
	end
	_bool = BotCarryBags.settings.lua_keybinds == 1 and true or false
	MenuHelper:AddToggle({
		id = "BotCarryBags_lua_keybinds_toggle_callback",
		title = "BotCarryBags_menu_lua_keybinds_title",
		desc = "BotCarryBags_menu_lua_keybinds_desc",
		callback = "BotCarryBags_lua_keybinds_toggle_callback",
		value = _bool,
		menu_id = BotCarryBags.options_menu,
	})
	MenuCallbackHandler.BotCarryBags_shout_to_drop_toggle_callback = function(self, item)
		if tostring(item:value()) == "on" then
			BotCarryBags.settings.shout_to_drop = 1
		else
			BotCarryBags.settings.shout_to_drop = 0
		end
		BotCarryBags:Save()
		BotCarryBags:Warning()
	end
	_bool = BotCarryBags.settings.shout_to_drop == 1 and true or false
	MenuHelper:AddToggle({
		id = "BotCarryBags_shout_to_drop_toggle_callback",
		title = "BotCarryBags_menu_shout_to_drop_title",
		desc = "BotCarryBags_menu_shout_to_drop_desc",
		callback = "BotCarryBags_shout_to_drop_toggle_callback",
		value = _bool,
		menu_id = BotCarryBags.options_menu,
	})
	if BotCarryBags.settings.lua_keybinds == 1 then
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
	end
end)
Hooks:Add("MenuManagerBuildCustomMenus", "BotCarryBagsOptions", function(menu_manager, nodes)
	nodes[BotCarryBags.options_menu] = MenuHelper:BuildMenu( BotCarryBags.options_menu )
	MenuHelper:AddMenuItem( MenuHelper.menus.lua_mod_options_menu, BotCarryBags.options_menu, "BotCarryBags_menu_title", "BotCarryBags_menu_desc", 1 )
end)
