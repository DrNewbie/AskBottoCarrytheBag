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
			end
		end
	end
end

Running()