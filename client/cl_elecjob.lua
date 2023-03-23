local task = {x = nil, y = nil, z = nil}
local hasMission = false
local hasElectricianJob = false

taskDone = false
isRepairing = false
taskFailed = false
jobsCompleted = 0
requiredJobCount = nil
local complete = false

Citizen.CreateThread(function() -- main thread for getting coordinates and starting the job, also, used for task evaluation
  while true do
    Citizen.Wait(0)
    if hasElectricianJob == true then
      ped = PlayerPedId()
      px, py, pz = table.unpack(GetEntityCoords(ped))
      if hasMission == true then
        local distanceToTask = GetDistanceBetweenCoords(px, py, pz, task.x, task.y, task.z, true) -- check for distance between the player and the task
        if distanceToTask < 40 then
          DrawMarker(1, task.x, task.y, task.z-2, 0, 0, 0, 0, 0, 0, 2.2001, 2.2001, 4.001, 120, 255, 120, 100, 0, 0, 0, 1, 0, 0, 0)
          if distanceToTask < 1.5 and isRepairing == false then
            DrawText3D(task.x, task.y, task.z+0.5, elecjobcfg.lang.beginRepair, 255)
            if IsControlJustPressed(1, 51) then
              TriggerEvent('vRPelectrician:startJob') -- start the repair
              isRepairing = true
            end
          end
        end
      end
    end
    if taskDone == true and taskFailed == false then -- task finished successfully
      taskDone = false
      jobsCompleted = jobsCompleted + 1
      FinishTask()
    end
    if taskDone == false and taskFailed == true then -- task failed
      taskFailed = false
      taskDone = false
      FailedTask()
    end
  end
end)

RegisterNetEvent('vRPelectrician:startJob') -- begin the repair action
AddEventHandler('vRPelectrician:startJob', function()
  PlayRepairAnim()
  taskDone = true
end)

RegisterNetEvent('vRP:hasElectricianJob') -- check if the player has the job set in elecjobcfg.lua, line 6
AddEventHandler('vRP:hasElectricianJob', function()
    hasElectricianJob = true
    requiredJobCount = math.random(elecjobcfg.jobCount.minJobs, elecjobcfg.jobCount.maxJobs)
    NextTask()
end)

RegisterNetEvent('noElectricianJob') -- remove all tasks/blips if the player switches jobs
AddEventHandler('noElectricianJob', function()
    hasElectricianJob = false
    DeleteWaypoint()
    hasMission = false
    isRepairing = false
    taskDone = false
    taskFailed = false
end)

function PlayRepairAnim() -- start repair animation
  TaskStartScenarioInPlace(ped, "WORLD_HUMAN_WELDING", 0, true)
  FreezeEntityPosition(ped, true)
  Wait(elecjobcfg.repairTime)
  ClearPedTasks(ped)
end

function FailedTask() -- task failed, onto the next one
  DeleteWaypoint()
  hasMission = false
  isRepairing = false
  taskFailed = false
  FreezeEntityPosition(ped, false)
  NextTask()
end

function FinishTask() -- task finished, pay the player and onto the next one
  DeleteWaypoint()
  hasMission = false
  isRepairing = false
  taskDone = false
  if jobsCompleted == requiredJobCount then
    complete = true
  end
  TriggerServerEvent('vRPelectrician:payRepair', complete)
  FreezeEntityPosition(ped, false)
  if not complete then
    tvRP.notify('You have completed '..jobsCompleted..'/'..requiredJobCount..' electrician jobs.')
    NextTask()
  end
end

function NextTask() -- get new coordinates and assign the mission to the player
  if hasMission then else
    Citizen.Wait(5000)
    local location = elecjobcfg.locations[math.random(#elecjobcfg.locations)]
    task.x = location[1]
    task.y = location[2]
    task.z = location[3]
    hasMission = true
    MissionBlip(task.x, task.y, task.z)
    notify(elecjobcfg.lang.nextTask)
  end
end

function MissionBlip(x, y, z) -- create the task blip
  taskBlip = AddBlipForCoord(x, y, z)
  SetBlipSprite(taskBlip, 402)
  SetBlipDisplay(taskBlip, 4)
  SetBlipRoute(taskBlip, true)
  SetBlipScale(taskBlip, 0.9)
  SetBlipColour(taskBlip, 5)
  SetBlipAsShortRange(taskBlip, false)
end

function DeleteWaypoint() -- remove the player blip
  if DoesBlipExist(taskBlip) then
    RemoveBlip(taskBlip)
    taskBlip = nil
  end
end

function DrawText3D(x,y,z, text, alpha) -- draw text in 3D, pretty common function
  local onScreen,_x,_y=World3dToScreen2d(x,y,z)
  local px,py,pz=table.unpack(GetGameplayCamCoords())
  
  if onScreen then
      SetTextScale(0.5, 0.5)
      SetTextFont(4)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, alpha)
      SetTextDropshadow(0, 0, 0, 0, alpha)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      SetDrawOrigin(x,y,z, 0)
      DrawText(0.0, 0.0)
      ClearDrawOrigin()
  end
end


Citizen.CreateThread(function() 
  local coords = elecjobcfg.joblocation
  local Blip = AddBlipForCoord(coords)
  SetBlipSprite(Blip, 402)
  SetBlipDisplay(Blip, 2)
  SetBlipScale(Blip, 0.7)
  SetBlipColour(Blip, 5)
  SetBlipAsShortRange(Blip, true)
  AddTextEntry("MAPBLIP", 'Electrician Job')
  BeginTextCommandSetBlipName("MAPBLIP")
  EndTextCommandSetBlipName(Blip)
  while true do
    if isInArea(coords, 100.0) then 
      DrawMarker(27, coords.x, coords.y, coords.z-0.98, 0, 0, 0, 0, 0, 0, 0.8, 0.8, 0.8, 230, 0, 0, 150, 0, 0, 0, 0, 0, 0, 0)
    end
    if isInArea(coords, 2.4) then
      if not hasElectricianJob then
        alert('Press ~INPUT_CONTEXT~ to start electrician job.')
        if IsControlJustPressed(0, 51) then
          TriggerServerEvent("vRP:STARTELECJOB")
        end
      else
        alert('Press ~INPUT_CONTEXT~ to end electrician job.')
        if IsControlJustPressed(0, 51) then
          TriggerEvent("noElectricianJob")
          tvRP.notify('You have ended your electrician job.')
        end
      end
    end
    Citizen.Wait(0)
  end
end) 

function alert(msg) 
  SetTextComponentFormat("STRING")
  AddTextComponentString(msg)
  DisplayHelpTextFromStringLabel(0,0,1,-1)
end


