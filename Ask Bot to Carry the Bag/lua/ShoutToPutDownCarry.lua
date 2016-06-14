if Network:is_client() then
	return
end

local _f_PlayerStandard_get_intimidation_action = PlayerStandard._get_intimidation_action

function PlayerStandard:_get_intimidation_action(prime_target, ...)
	local voice_type, plural, prime_target = _f_PlayerStandard_get_intimidation_action(self, prime_target, ...)
	if (voice_type == "come" or voice_type == "boost") and prime_target and prime_target.unit_type == 2 then
		if prime_target.unit and prime_target.unit:brain() and prime_target.unit:brain():Get_Carray_Data() then
			if mvector3.distance(self._unit:position(), prime_target.unit:position()) <= 500 then
				prime_target.unit:brain():Drop_Carray()
			end
		end
	end
	return voice_type, plural, prime_target
end