	MenuCallbackHandler.BotCarryBags_Logic_Callback_1 = function() 
		dofile("mods/Ask Bot to Carry the Bag/lua/MoveBagsLogic/All AI drop the bag.lua") 
	end 
	LuaModManager:AddKeybinding("AskBotDo_Key_1", callback(MenuCallbackHandler, MenuCallbackHandler, "BotCarryBags_Logic_Callback_1")) 
	MenuCallbackHandler.BotCarryBags_Logic_Callback_2 = function() 
		dofile("mods/Ask Bot to Carry the Bag/lua/MoveBagsLogic/All AI go to one of bags there.lua") 
	end 
	LuaModManager:AddKeybinding("AskBotDo_Key_2", callback(MenuCallbackHandler, MenuCallbackHandler, "BotCarryBags_Logic_Callback_2")) 
	MenuCallbackHandler.BotCarryBags_Logic_Callback_3 = function() 
		dofile("mods/Ask Bot to Carry the Bag/lua/MoveBagsLogic/All AI pick up near bag.lua") 
	end 
	LuaModManager:AddKeybinding("AskBotDo_Key_3", callback(MenuCallbackHandler, MenuCallbackHandler, "BotCarryBags_Logic_Callback_3")) 
	MenuCallbackHandler.BotCarryBags_Logic_Callback_4 = function() 
		dofile("mods/Ask Bot to Carry the Bag/lua/MoveBagsLogic/Move All bags to here.lua") 
	end 
	LuaModManager:AddKeybinding("AskBotDo_Key_4", callback(MenuCallbackHandler, MenuCallbackHandler, "BotCarryBags_Logic_Callback_4")) 
	MenuCallbackHandler.BotCarryBags_Logic_Callback_5 = function() 
		dofile("mods/Ask Bot to Carry the Bag/lua/MoveBagsLogic/Move All bags to my here.lua") 
	end 
	LuaModManager:AddKeybinding("AskBotDo_Key_5", callback(MenuCallbackHandler, MenuCallbackHandler, "BotCarryBags_Logic_Callback_5")) 
