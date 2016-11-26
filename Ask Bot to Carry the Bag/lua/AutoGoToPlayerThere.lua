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

Hooks:PostHook(TeamAIMovement, "init", "BotCarryBags_TeamAIMovement_init_auto_follow_player", function(tai, ...)
	tai._bot_carry_auto_follow_player_t = 0
end )

Hooks:PostHook(TeamAIMovement, "update", "BotCarryBags_TeamAIMovement_update_auto_follow_player", function(tai, unit, t, ...)
	if BotCarryBags.settings.auto_follow_player == 1 and tai._unit:brain():Get_Carray_Data() and t > tai._bot_carry_auto_follow_player_t then
		local _local_player = managers.player:local_player()
		local _My_Pos = alive(_local_player) and _local_player:position() or nil
		tai._bot_carry_auto_follow_player_t = t + 0.5
		if _My_Pos and mvector3.distance(tai._unit:position(), _My_Pos) > 400 then
			BotCarryBags:Ask_AI_Go_To_There(tai._unit, _My_Pos)
		end
	end
end )