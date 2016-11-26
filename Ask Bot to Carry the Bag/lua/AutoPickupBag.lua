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

Hooks:PostHook(TeamAIMovement, "init", "BotCarryBags_TeamAIMovement_init_auto_pickup_bag", function(tai, ...)
	tai._bot_carry_auto_pickup_bag_t = 0
end )

Hooks:PostHook(TeamAIMovement, "update", "BotCarryBags_TeamAIMovement_update_auto_pickup_bag", function(tai, unit, t, ...)
	if t > tai._bot_carry_auto_pickup_bag_t and BotCarryBags.settings.auto_pickup_bag == 1 and not tai._unit:brain():Get_Carray_Data() then
		tai._bot_carry_auto_pickup_bag_t = t + 0.5
		local _Bags = BotCarryBags:Get_All_Bag_Unit_In_Sphere(tai._unit:position(), 400)
		if _Bags and #_Bags >= 1 then
			for _, _bag_unit in pairs(_Bags) do
				if _bag_unit and alive(_bag_unit) and BotCarryBags:Check_Bag_Can_Pickup(_bag_unit) then
					tai._unit:brain():Set_Carray_Data(_bag_unit)
					break
				end
			end
		end
	end
end )