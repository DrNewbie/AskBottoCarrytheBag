_G.BotCarryBags = _G.BotCarryBags or {}

function BotCarryBags:Ask_AI_Go_To_There(unit, pos)
	if not BotCarryBags.AI_Go_To_There then
		BotCarryBags.AI_Go_To_There = {}
	end
	BotCarryBags.AI_Go_To_There[unit:name():key()] = {
		pos = pos
	}
	unit:brain():on_long_dis_interacted(5, managers.player:player_unit())
end

function BotCarryBags:Is_Ask_AI_Go_To_There(unit)
	if not BotCarryBags.AI_Go_To_There then
		return false
	else
		if BotCarryBags.AI_Go_To_There[unit:key()] and BotCarryBags.AI_Go_To_There[unit:key()].pos then
			return true
		end
	end
	return false
end

function BotCarryBags:Get_All_AI_Unit()
	local _unit = {}
	for _, data in pairs(managers.groupai:state():all_AI_criminals() or {}) do
		if data.unit and alive(data.unit) then
			table.insert(_unit, data.unit)
		end
	end
	return _unit
end

BotCarryBags.Bags_Unit_Key = {}
for _, name in pairs(CarryTweakData:get_carry_ids() or {}) do
	if tweak_data.carry[name].unit then
		local _key = Idstring(tweak_data.carry[name].unit):key()
		if not BotCarryBags.Bags_Unit_Key[_key] then
			BotCarryBags.Bags_Unit_Key[_key] = true
		end
	end
end
BotCarryBags.Bags_Unit_Key[Idstring("units/payday2/pickups/gen_pku_lootbag/gen_pku_lootbag"):key()] = true

function BotCarryBags:Get_All_Bag_Unit()
	local _unit_list = BotCarryBags.Bags_Unit_Key or {}
	local _unit = {}
	local _All_Unit = World:find_units_quick("all") or {}
	for _, data in pairs(_All_Unit) do
		if data and alive(data) and _unit_list[data:name():key()] then
			table.insert(_unit, data)
		end
	end  
	return _unit
end

function BotCarryBags:Get_All_Bag_Unit_In_Sphere(pos, area)
	local _unit_list = BotCarryBags.Bags_Unit_Key or {}
	local _unit = {}
	local _Unit_In_Sphere = World:find_units("sphere", pos, area) or {}
	for _, data in pairs(_Unit_In_Sphere) do
		if data and alive(data) and _unit_list[data:name():key()] then
			table.insert(_unit, data)
		end
	end  
	return _unit
end

function BotCarryBags:Menu_Dofile(data)
	if data and data.item then
		dofile(BotCarryBags.LogicPath .. "" .. data.item)
	end
end