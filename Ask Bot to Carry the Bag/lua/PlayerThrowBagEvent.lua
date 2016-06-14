if Network:is_client() then
	return
end

local _f_PlayerManager_server_drop_carry = PlayerManager.server_drop_carry

function PlayerManager:server_drop_carry(carry_id, ...)
	local _crosshair_unit,  _crosshair_distance = Get_Crosshair_Unit()
	local _carry_unit = _f_PlayerManager_server_drop_carry(self, carry_id, ...)
	local _Attach_ID = {	
		["f405409dadefb1e2"] = true,
		["fd9d02c72329dcb8"] = true,
		["74908299667b5201"] = true,
		["b4d6124811c84182"] = true,
		["297d2df5785ba35e"] = true,
		["c30631d12a441585"] = true,
		["7ec880912402df60"] = true,
		["a0a8249eba4905bf"] = true,
		["7dd63237e407f46a"] = true,
		["b4ae93e533d613ec"] = true,
		["e919d4de9a55b18f"] = true,
		["dcfbd9f29beba552"] = true,
		["067bc4329b12057c"] = true,
		["4104c20d71b3015b"] = true,
		["2b30249cd53d477b"] = true,
	}
	if _crosshair_unit and alive(_crosshair_unit) and 
		_Attach_ID[_crosshair_unit:name():key()] and 
		_crosshair_distance <= 500 and
		mvector3.distance(managers.player:player_unit():position(), _crosshair_unit:position()) <= 500 then
		_carry_unit = Try_Send_Carry_To_There(_crosshair_unit, _carry_unit, carry_id)
	end
	return _carry_unit
end

function Try_Send_Carry_To_There(crosshair_unit, carry_unit, carry_id)
	if crosshair_unit and crosshair_unit:brain() and 
		not crosshair_unit:brain():Get_Carray_Data() then
		DelayedCalls:Add("DelayedModDeleteUnit" .. carry_id, 0.5, function()
			if carry_unit then
				local carry_data = tweak_data.carry[carry_id] or nil
				if carry_data then
					crosshair_unit:character_damage():set_pickup(carry_id)
					carry_unit:set_slot(0)
					crosshair_unit:brain():Set_Carray_Data(carry_id)
					for i = 1, 4 do
						local character_name = managers.criminals:character_name_by_panel_id(i)
						local _unit_by_name = managers.criminals:character_unit_by_name(character_name)
						if _unit_by_name and _unit_by_name == crosshair_unit then
							local name = managers.localization:text("menu_" .. character_name) .. "[".. carry_id .."]"
							managers.hud:set_teammate_name(i, name)
							break
						end
					end
				end
			end
		end)
		return nil
	end
	return carry_unit
end

function Get_Crosshair_Unit()
	if not managers.player or not managers.player:player_unit() then
		return nil, 0
	end
	local camera = managers.player:player_unit():camera()
	local mvec_to = Vector3()
	local from_pos = camera:position()
	mvector3.set(mvec_to, camera:forward())
	mvector3.multiply(mvec_to, 20000)
	mvector3.add(mvec_to, from_pos)
	local col_ray = World:raycast("ray", from_pos, mvec_to, "slot_mask", managers.slot:get_mask("bullet_impact_targets"))
	if col_ray and col_ray.unit then
		return col_ray.unit, col_ray.distance
	end
end