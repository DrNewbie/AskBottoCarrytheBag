_G.BotCarryBags = _G.BotCarryBags or {}

if Network:is_client() then
	return
end

if not BotCarryBags then
	return
end

if BotCarryBags.settings.auto_follow_player ~= 1 then
	return
end

Hooks:PostHook(TeamAIMovement, "init", "BotCarryBags_TeamAIMovement_init", function(tai, ...)
	tai._bot_carry_auto_follow_player_t = 0
end )

Hooks:PostHook(TeamAIMovement, "update", "BotCarryBags_TeamAIMovement_update", function(tai, ...)
	if BotCarryBags.settings.auto_follow_player == 1 and tai._unit:brain():Get_Carray_Data() and t > tai._bot_carry_auto_follow_player_t then
		tai._bot_carry_auto_follow_player_t = t + 0.5
		tai._unit:brain():on_long_dis_interacted(5, managers.player:player_unit())		
	end
end )