_G.BotCarryBags = _G.BotCarryBags or {}

if Network:is_client() then
	return
end

if not BotCarryBags then
	return
end

if BotCarryBags.settings.auto_pickup_bag ~= 1 then
	return
end

local _f_TeamAIMovement_update = TeamAIMovement.init

function TeamAIMovement:init(...)
	_f_TeamAIMovement_update(self, ...)
	self._auto_pickup_bag_t = 0
end

local _f_TeamAIMovement_update = TeamAIMovement.update

function TeamAIMovement:update(unit, t, dt)
	_f_TeamAIMovement_update(self, unit, t, dt)
	if t > self._auto_pickup_bag_t and BotCarryBags.settings.auto_pickup_bag == 1 and not self._unit:brain():Get_Carray_Data() then
		self._auto_pickup_bag_t = t + 3
		local _Bags = BotCarryBags:Get_All_Bag_Unit_In_Sphere(self._unit:position(), 200)
		if _Bags and #_Bags >= 1 then
			for _, _bag_unit in pairs(_Bags) do
				if _bag_unit and alive(_bag_unit) and BotCarryBags:Check_Bag_Can_Pickup(_bag_unit) then
					self._unit:brain():Set_Carray_Data(_bag_unit)
					break
				end
			end
		end
	end
end