if Network:is_client() then
	return
end

local _f_PlayerManager_server_drop_carry = PlayerManager.server_drop_carry

function PlayerManager:server_drop_carry(carry_id, ...)
	local _crosshair_unit,  _crosshair_distance = Get_Crosshair_Unit()
	local _carry_unit = _f_PlayerManager_server_drop_carry(self, carry_id, ...)
	if _crosshair_unit and alive(_crosshair_unit) and _crosshair_distance <= 500 and
		mvector3.distance(managers.player:player_unit():position(), _crosshair_unit:position()) <= 500 then
		for _, data in pairs(managers.groupai:state():all_AI_criminals() or {}) do
			if data.unit and alive(data.unit) and data.unit == _crosshair_unit then
				_carry_unit = Try_Send_Carry_To_There(_crosshair_unit, _carry_unit, carry_id)
				break
			end
		end
	end
	return _carry_unit
end

function Try_Send_Carry_To_There(crosshair_unit, carry_unit, carry_id)
	if crosshair_unit and crosshair_unit:brain() then
		crosshair_unit:brain():Drop_Carray()
		DelayedCalls:Add("DelayedModDeleteUnit" .. carry_id, 0.5, function()
			if carry_unit then
				crosshair_unit:brain():Set_Carray_Data(carry_unit)
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
	return nil, 0
end