if Network:is_client() then
	return
end

local _f_GroupAIStateBase_on_player_criminal_death = GroupAIStateBase.on_player_criminal_death

function GroupAIStateBase:on_player_criminal_death(peer_id)
	_f_GroupAIStateBase_on_player_criminal_death(self, peer_id)
	if peer_id == 1 then
		for _, data in pairs(self:all_AI_criminals()) do
			if data.unit and alive(data.unit) then
				data.unit:brain():Drop_Carray()
			end
		end
	end
end
