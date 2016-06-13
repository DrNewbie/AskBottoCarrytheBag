if Network:is_client() then
	return
end

function TeamAIBrain:Set_Carray_Data(carry_data)
	self._carry_data = carry_data or nil
end

function TeamAIBrain:Get_Carray_Data(carry_data)
	return self._carry_data or nil
end

function TeamAIBrain:Drop_Carray(carry_data)
	if self._carry_data and self._carry_data ~= "" then		
		local carry_data = tweak_data.carry[self._carry_data]
		if carry_data then
			local _carry_unit = managers.player:server_drop_carry(self._carry_data, carry_data.multiplier, true, false, 1, self._unit:position(), Rotation(0, 0, 0), Vector3(0, 0, 0), 0, nil, nil)
			_carry_unit:push(100, Vector3(0, 0, 0) * 600)
		end
	end
	self._carry_data = nil
end