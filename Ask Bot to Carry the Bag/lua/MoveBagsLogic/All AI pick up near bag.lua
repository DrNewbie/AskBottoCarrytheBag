--DO NOT REMOVE BELOW
if Network:is_client() then
	return
end

_G.BotCarryBags = _G.BotCarryBags or {}

if not BotCarryBags then
	return
end
--DO NOT REMOVE ABOVE

function Running()
	local _AIs = BotCarryBags:Get_All_AI_Unit()
	if _AIs and #_AIs >= 1 then
		for _, _ai_unit in pairs(_AIs) do
			if _ai_unit and alive(_ai_unit) then
				_ai_unit:brain():Drop_Carray()
				local _Bags = BotCarryBags:Get_All_Bag_Unit_In_Sphere(_ai_unit:position(), 400) or {}
				for _, _bag_unit in pairs(_Bags) do
					if _bag_unit and alive(_bag_unit) and BotCarryBags:Check_Bag_Can_Pickup(_bag_unit) then
						_ai_unit:brain():Set_Carray_Data(_bag_unit)
					end
				end
			end
		end
	end
end

Running()