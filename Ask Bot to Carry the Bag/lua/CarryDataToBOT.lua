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
	if self:Get_Carray_Data() then
		self:Drop_Carray()
	end
	self._carry_unit = carry_unit or nil
	carry_unit:carry_data():link_to(self._unit)
	carry_unit:carry_data()._steal_SO_data = {thief = self._unit}
end

function TeamAIBrain:Get_Carray_Data()
	return self._carry_unit or nil
end

function TeamAIBrain:Drop_Carray()
	if self._carry_unit and alive(self._carry_unit) then
		self._carry_unit:carry_data():unlink()
		self._carry_unit:carry_data()._steal_SO_data = {thief = nil}
	end
	self._carry_unit = nil
end

function path_change(them, to_pos)
	if them:Get_Carray_Data() and BotCarryBags.settings.shout_to_come_here == 1 then
		to_pos = managers.player:player_unit():position()
	end
	if BotCarryBags.AI_Go_To_There then
		local _id = them._unit:name():key()
		if BotCarryBags.AI_Go_To_There[_id] and BotCarryBags.AI_Go_To_There[_id].pos then
			to_pos = BotCarryBags.AI_Go_To_There[_id].pos
			BotCarryBags.AI_Go_To_There[_id] = {}
		end
	end
	return to_pos
end

local _f_TeamAIBrain_search_for_path = TeamAIBrain.search_for_path

function TeamAIBrain:search_for_path(search_id, to_pos, ...)
	to_pos = path_change(self, to_pos)
	return _f_TeamAIBrain_search_for_path(self, search_id, to_pos, ...)
end

local _f_TeamAIBrain_search_for_path_from_pos = TeamAIBrain.search_for_path_from_pos

function TeamAIBrain:search_for_path_from_pos(search_id, from_pos, to_pos, ...)
	to_pos = path_change(self, to_pos)
	return _f_TeamAIBrain_search_for_path_from_pos(self, search_id, from_pos, to_pos, ...)
end