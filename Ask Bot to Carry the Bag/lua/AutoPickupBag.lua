_G.BotCarryBags = _G.BotCarryBags or {}

if not BotCarryBags then
	return
end

if BotCarryBags.settings.auto_pickup_bag ~= 1 then
	return
end

local _f_TeamAIBrain_update = TeamAIBrain.update

local _run_delay = false

function TeamAIBrain:update(...)
	_f_TeamAIBrain_update(self, ...)
	if _run_delay then
		return
	end
	_run_delay = true
	if BotCarryBags.settings.auto_pickup_bag == 1 and not self:Get_Carray_Data() then
		local _Bags = BotCarryBags:Get_All_Bag_Unit_In_Sphere(self._unit:position(), 200)
		if _Bags and #_Bags >= 1 then
			for _, _bag_unit in pairs(_Bags) do
				if _bag_unit and alive(_bag_unit) and BotCarryBags:Check_Bag_Can_Pickup(_bag_unit) then
					self:Set_Carray_Data(_bag_unit)
					break
				end
			end
		end
	end
	if _run_delay then
		DelayedCalls:Add("DelayedMod_TeamAIBrain_update_" .. tostring(self._unit:key()), 1, function()
			_run_delay = false
		end)
	end
end