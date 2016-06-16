if Network:is_client() then
	return
end

_G.BotCarryBags = _G.BotCarryBags or {}

if not BotCarryBags then
	return
end

local _f_TeamAIBrain_set_logic = TeamAIBrain.set_logic

function TeamAIBrain:set_logic(name, ...)
	_f_TeamAIBrain_set_logic(self, name, ...)
	if self._current_logic_name == "disabled" and self:Get_Carray_Data() then
		self:Drop_Carray()
	end
end

function TeamAIBrain:Set_Carray_Data(carry_unit)
	self._carry_unit = carry_unit or nil
	carry_unit:carry_data():link_to(self._unit)
end

function TeamAIBrain:Get_Carray_Data()
	return self._carry_unit or nil
end

function TeamAIBrain:Drop_Carray()
	if self._carry_unit and alive(self._carry_unit) then
		self._carry_unit:carry_data():unlink()
	end
	self._carry_unit = nil
end

local _f_TeamAIBrain_search_for_path = TeamAIBrain.search_for_path

function TeamAIBrain:search_for_path(search_id, to_pos, ...)
	if self:Get_Carray_Data() then
		to_pos = managers.player:player_unit():position()
	end
	if BotCarryBags.AI_Go_To_There and BotCarryBags.AI_Go_To_There[self._unit:key()] then
		to_pos = BotCarryBags.AI_Go_To_There[self._unit:key()].pos
		BotCarryBags.AI_Go_To_There[self._unit:key()] = {}
	end
	return _f_TeamAIBrain_search_for_path(self, search_id, to_pos, ...)
end