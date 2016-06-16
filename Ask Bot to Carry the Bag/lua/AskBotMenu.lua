if Network:is_client() then
	return
end

_G.BotCarryBags = _G.BotCarryBags or {}

if not BotCarryBags then
	return
end

local menu_options = {}

for k, v in pairs(BotCarryBags.LogicMenu or {}) do
	menu_options[#menu_options+1] = {
		text = v,
		callback_func = callback(BotCarryBags, BotCarryBags, "Menu_Dofile", {item = v})
	}
end

menu_options[#menu_options+1] = { text = "[Cancel]", is_cancel_button = true }

local _dialog_data = {
	title = "Bot Carry MOD",
	text = "Choose what logic you want to run",
	button_list = menu_options,
	id = tostring(math.random(0,0xFFFFFFFF))
}

menu_options = {}

managers.system_menu:show(_dialog_data)