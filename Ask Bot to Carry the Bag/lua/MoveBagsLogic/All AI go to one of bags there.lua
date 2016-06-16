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
	local _Bags = BotCarryBags:Get_All_Bag_Unit()
	BotCarryBags.AI_Go_To_There = {}
	if _AIs and #_AIs >= 1 and _Bags and #_Bags >= 1 then
		local _bag = _Bags[math.random(#_Bags)] or nil
		if _bag then
			local _pos = _bag:position()
			for _, _ai_unit in pairs(_AIs) do
				if _ai_unit and alive(_ai_unit) then
					BotCarryBags:Ask_AI_Go_To_There(_ai_unit, _pos)
				end
			end
		end
	end
end

Running()