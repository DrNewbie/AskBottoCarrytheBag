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

Hooks:PostHook(CarryData, "update", "BotCarryBags_CarryData_update_fix_outside_bag", function(carr, ...)
	local _unit_list = BotCarryBags.Bags_Unit_Key or {}
	if BotCarryBags.settings.fix_outside_bag == 1 and t and carr._unit and alive(carr._unit) and 
		_unit_list[carr._unit:name():key()] and BotCarryBags:Check_Bag_Can_Pickup(carr._unit) then
		if managers.player:player_unit() and alive(managers.player:player_unit()) then
			local _p_z = managers.player:player_unit():position().z or 0
			local all_criminals = managers.groupai:state():all_char_criminals() or {}
			for u_key, u_data in pairs(all_criminals) do
				if u_data.unit and alive(u_data.unit) then
					_p_z = math.min(_p_z, u_data.unit:position().z)
				end
			end
			local _b_z = carr._unit:position().z or 0
			local _s_z = _p_z - _b_z
			_s_z = math.abs(math.floor(_s_z))
			if _s_z > 2000 then
				local _all_AI_criminals = managers.groupai:state():all_AI_criminals() or {}
				for _, data in pairs(_all_AI_criminals) do
					if data.unit and alive(data.unit) and data.unit ~= managers.player:player_unit() then
						BotCarryBags:Try_Send_Carry_To_There(data.unit, carr._unit, _s_z)
						break
					end
				end
			end
		end
	end
end )