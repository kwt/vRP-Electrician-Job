RegisterNetEvent('vRPelectrician:payRepair') -- pay the player and check for job
AddEventHandler('vRPelectrician:payRepair', function(complete)
	local user_id = vRP.getUserId(source)
	local player = vRP.getUserSource(user_id)
	local money = math.random(elecjobcfg.payment.min, elecjobcfg.payment.max)
	if vRP.hasPermission(user_id, "player.phone") then
		if not complete then
			vRP.giveBankMoney(user_id, money)
			vRPclient.notify(player, {elecjobcfg.lang.finishedTask .. "" .. money})
		else
			vRPclient.notify(player, {'You have finished all required electrician jobs. You need to return to the office for more.'})
			TriggerClientEvent('noElectricianJob', source)
		end
	end
end)

RegisterNetEvent('vRP:STARTELECJOB') -- start the electrician job
AddEventHandler('vRP:STARTELECJOB', function()
	local source = source
	local user_id = vRP.getUserId(source)
	if vRP.hasPermission(user_id, "player.phone") then
		TriggerClientEvent('vRP:hasElectricianJob', source)
		vRPclient.notify(source, {elecjobcfg.lang.nextTask})
	end
end)