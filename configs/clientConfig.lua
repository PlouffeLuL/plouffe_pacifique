Pac = {}
TriggerServerEvent("plouffe_pacifique:sendConfig")

RegisterNetEvent("plouffe_pacifique:getConfig",function(list)
	if not list then
		while true do
			Pac = nil
		end
	else
		for k,v in pairs(list) do
			Pac[k] = v
		end

		Pac:Start()
	end
end)