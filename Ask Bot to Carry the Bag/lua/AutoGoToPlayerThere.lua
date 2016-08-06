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

local _f_TeamAIMovement_update = CopMovement.init

function CopMovement:init(...)
	_f_TeamAIMovement_update(self, ...)
	self._auto_follow_player_t = 0
end

local _f_TeamAIMovement_update = TeamAIMovement.update

function TeamAIMovement:update(unit, t, dt)
	_f_TeamAIMovement_update(self, unit, t, dt)
	if BotCarryBags.settings.auto_follow_player == 1 and self._unit:brain():Get_Carray_Data() and t > self._auto_follow_player_t then
		self._auto_follow_player_t = t + 0.5
		self._unit:brain():on_long_dis_interacted(5, managers.player:player_unit())		
	end
end