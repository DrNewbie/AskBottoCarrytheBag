_G.BotCarryBags = _G.BotCarryBags or {}

if not BotCarryBags then
	return
end

if BotCarryBags.settings.auto_pickup_bag ~= 1 then
	return
end

local _f_TeamAIBrain_update = TeamAIBrain.update

function TeamAIBrain:update(...)
	_f_TeamAIBrain_update(self, ...)
	if BotCarryBags.settings.auto_pickup_bag == 1 and not self:Get_Carray_Data() then
		local _Bags = BotCarryBags:Get_All_Bag_Unit_In_Sphere(self._unit:position(), 200)
		if _Bags and #_Bags >= 1 then
			for _, _bag_unit in pairs(_Bags) do
				if _bag_unit and alive(_bag_unit) and 
					(not _bag_unit:carry_data()._steal_SO_data or
					not alive(_bag_unit:carry_data()._steal_SO_data.thief)) then
					self:Set_Carray_Data(_bag_unit)
					break
				end
			end
		end
	end
end