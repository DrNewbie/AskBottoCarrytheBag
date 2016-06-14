if Network:is_client() then
	return
end

function TeamAIBrain:Get_Carray_Data()
	return self._current_logic or nil
end

local _f_TeamAIBrain_set_logic = TeamAIBrain.set_logic

function TeamAIBrain:set_logic(name, ...)
	_f_TeamAIBrain_set_logic(self, name, ...)
	if self._current_logic_name == "disabled" and self:Get_Carray_Data() then
		self:Drop_Carray()
	end
end

function TeamAIBrain:Set_Carray_Data(carry_data)
	self._carry_data = carry_data or nil
end

function TeamAIBrain:Get_Carray_Data()
	return self._carry_data or nil
end

function TeamAIBrain:Drop_Carray()
	if self._carry_data and self._carry_data ~= "" then
		local carry_data = tweak_data.carry[self._carry_data]
		if carry_data then
			local _carry_unit = managers.player:server_drop_carry(self._carry_data, carry_data.multiplier, true, false, 1, self._unit:position(), Rotation(0, 0, 0), Vector3(0, 0, 0), 0, nil, nil)
			for i = 1, 4 do
				local character_name = managers.criminals:character_name_by_panel_id(i)
				local _unit_by_name = managers.criminals:character_unit_by_name(character_name)
				if _unit_by_name and _unit_by_name == self._unit then
					local name = managers.localization:text("menu_" .. character_name)
					managers.hud:set_teammate_name(i, name)
					break
				end
			end
		end
	end
	self._carry_data = nil
end