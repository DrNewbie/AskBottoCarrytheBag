_G.BotCarryBags = _G.BotCarryBags or {}

if Network:is_client() then
	return
end

if not BotCarryBags then
	return
end

Hooks:PostHook(TeamAIMovement, "init", "BotCarryBags_TeamAIMovement_init_bot_carry_target_pos", function(tai, ...)
	tai._bot_carry_target_pos = Vector3()
end )

Hooks:PostHook(TeamAIMovement, "_upd_location", "BotCarryBags_TeamAIMovement_upd_location", function(tai, ...)
	if tai._bot_carry_target_pos ~= Vector3() then
		if mvector3.distance(tai._unit:position(), tai._bot_carry_target_pos) <= 100 then
			tai:set_should_stay(true)
			tai._bot_carry_target_pos = Vector3()
		end
	end
end )

function TeamAIMovement:Set_Bot_Carry_Target_Pos(pos)
	self._bot_carry_target_pos = pos
end

function TeamAIMovement:Is_Bot_Carry_Target_Pos(pos)
	if self._bot_carry_target_pos == Vector3() then
		return false
	else
		return true
	end
end