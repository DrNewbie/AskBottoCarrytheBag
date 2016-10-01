if Network:is_client() then
	return
end

_G.BotCarryBags = _G.BotCarryBags or {}

if not BotCarryBags then
	return
end

if BotCarryBags.settings.fix_outside_bag ~= 1 then
	return
end

local _f_CarryData_update = CarryData.update

function CarryData:update(unit, t, dt)
	_f_CarryData_update(self, unit, t, dt)
	local _unit_list = BotCarryBags.Bags_Unit_Key or {}
	if BotCarryBags.settings.fix_outside_bag == 1 and t and self._unit and alive(self._unit) and 
		_unit_list[self._unit:name():key()] and BotCarryBags:Check_Bag_Can_Pickup(self._unit) then
		if managers.player:player_unit() and alive(managers.player:player_unit()) then
			local _p_z = managers.player:player_unit():position().z or 0
			local _b_z = self._unit:position().z or 0
			local _s_z = _p_z - _b_z
			_s_z = math.abs(math.floor(_s_z))
			if _s_z > 2500 then
				local _all_AI_criminals = managers.groupai:state():all_AI_criminals() or {}
				for _, data in pairs(_all_AI_criminals) do
					if data.unit and alive(data.unit) and data.unit ~= managers.player:player_unit() then
						BotCarryBags:Try_Send_Carry_To_There(data.unit, self._unit, _s_z)
						break
					end
				end
			end
		end
	end
end