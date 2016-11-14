--DO NOT REMOVE BELOW
if Network:is_client() then
	return
end

_G.BotCarryBags = _G.BotCarryBags or {}

if not BotCarryBags then
	return
end
--DO NOT REMOVE ABOVE

if BotCarryBags.Only_One_Run and BotCarryBags.Only_One_Run == 1 then
	return
end

local _My_Pos = managers.player:player_unit():position()

local _End_Time = math.floor(TimerManager:game():time()) + 15

function Running()
	if not BotCarryBags or not managers.player or not managers.player:player_unit() then
		return
	end
	local _AIs = BotCarryBags:Get_All_AI_Unit()
	local _Bags = BotCarryBags:Get_All_Bag_Unit()
	local _bag = nil
	local _Run = 0
	if _Bags and #_Bags >= 1 then
		if _AIs and #_AIs >= 1 then
			for _, _ai_unit in pairs(_AIs) do
				if _ai_unit and alive(_ai_unit) then
					if not BotCarryBags:Is_Ask_AI_Go_To_There(_ai_unit) then
						if _ai_unit:brain():Get_Carray_Data() then
							if mvector3.distance(_ai_unit:position(), _My_Pos) <= 200 then							
								DelayedCalls:Add("DelayedModMoveBagsLoop_Drop_" .. tostring(_ai_unit:key()), 0.2, function()
									_ai_unit:brain():Drop_Carray()
								end)
							else
								BotCarryBags:Ask_AI_Go_To_There(_ai_unit, _My_Pos)
								_Run = _Run + 1
							end
						else
							for _, _bag_unit in pairs(_Bags) do
								if _bag_unit and alive(_bag_unit) and BotCarryBags:Check_Bag_Can_Pickup(_bag_unit) then
									if mvector3.distance(_ai_unit:position(), _My_Pos) > 200 then
										if mvector3.distance(_ai_unit:position(), _bag_unit:position()) <= 300 then
											_ai_unit:brain():Set_Carray_Data(_bag_unit)
										else
											BotCarryBags:Ask_AI_Go_To_There(_ai_unit, _bag_unit:position())
										end
									end
									_Run = _Run + 1
								end
							end
						end
					else
						_Run = _Run + 1
					end
				end
			end
		end
	end
	if _Run > 0 then
		DelayedCalls:Add("DelayedModMoveBagsLoop", 0.5, function()
			if BotCarryBags.Forced_End == 0 and _End_Time > math.floor(TimerManager:game():time()) then
				Running()
			end
		end)
	else
		_My_Pos = nil
		BotCarryBags.Only_One_Run = 0
		DelayedCalls:Remove("DelayedModMoveBagsLoop")
	end
end

BotCarryBags.Forced_End = 0
BotCarryBags.Only_One_Run = 1
Running()