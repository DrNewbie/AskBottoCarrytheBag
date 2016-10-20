_G.BotCarryBags = _G.BotCarryBags or {}

if Network:is_client() then
	return
end

function BotCarryBags:Ask_AI_Go_To_There(unit, pos)
	if not self.AI_Go_To_There then
		self.AI_Go_To_There = {}
	end
	self.AI_Go_To_There[unit:name():key()] = {
		pos = pos
	}
	unit:brain():on_long_dis_interacted(5, managers.player:player_unit())
end

function BotCarryBags:Is_Ask_AI_Go_To_There(unit)
	if not self.AI_Go_To_There then
		return false
	else
		if self.AI_Go_To_There[unit:name():key()] and self.AI_Go_To_There[unit:name():key()].pos then
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
	local _unit_list = self.Bags_Unit_Key or {}
	local _unit = {}
	local _All_Unit = World:find_units_quick("all") or {}
	for _, data in pairs(_All_Unit) do
		if data and alive(data) and _unit_list[data:name():key()] then
			table.insert(_unit, data)
		end
	end  
	return _unit
end

BotCarryBags.Zipline_Protect_List = BotCarryBags.Zipline_Protect_List or {}
BotCarryBags.Zipline_Protect_List_tmp = BotCarryBags.Zipline_Protect_List_tmp or {}
function BotCarryBags:Zipline_Protect(bag_unit)
	if bag_unit and bag_unit:carry_data() then
		local _key = bag_unit:key()
		local _in_zipline = bag_unit:carry_data():is_attached_to_zipline_unit()
		if _in_zipline and Global.game_settings.level_id == "pbr" then
			self.Zipline_Protect_List_tmp[_key] = 0
			self.Zipline_Protect_List[_key] = true
			return true
		end
		if self.Zipline_Protect_List_tmp[_key] and self.Zipline_Protect_List_tmp[_key] > 0 then
			if self.Zipline_Protect_List_tmp[_key] < TimerManager:game():time() then
				self.Zipline_Protect_List[_key] = false
				self.Zipline_Protect_List_tmp[_key] = 0
			else
				return true
			end
		end
		if self.Zipline_Protect_List[_key] then
			return true
		elseif _in_zipline then
			self.Zipline_Protect_List[_key] = true
			return true
		end
		self.Zipline_Protect_List[_key] = false
		self.Zipline_Protect_List_tmp[_key] = 0
	end
	return false
end

function BotCarryBags:Check_Bag_Can_Pickup(bag_unit)
	if self:Zipline_Protect(bag_unit) then
		return false
	end
	if not bag_unit:carry_data()._steal_SO_data or not alive(bag_unit:carry_data()._steal_SO_data.thief) then
		return true
	end
	return false
end

function BotCarryBags:Get_All_Bag_Unit_In_Sphere(pos, area)
	local _unit_list = self.Bags_Unit_Key or {}
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
		dofile(self.LogicPath .. "" .. data.item)
	end
end