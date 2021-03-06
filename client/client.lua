---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by AtomiX.
--- DateTime: 2/5/2022 9:26 PM


local QBCore = exports['qbr-core']:GetCoreObject()

local isDead = false
local isInjured = false
local isHurt = false
local incacipated = false
local injureCount = 0

local status = false

local counter = 0
local icounter = 0
local hcounter = 0

Citizen.CreateThread(function()
    while true do
        local player = PlayerPedId()
        local health = GetEntityHealth(player)
        Wait(1500)
        if health <= 1 and not status and not isDead then
            status = true
            isInjured = true
            TriggerEvent('rprp_injury')
            print(Config.MaxInjureCount)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isDead then
            Citizen.Wait(0)
            QBCore.Functions.DrawText("Dead. You must wait  " .. counter .. " seconds till you wake up", 0.5, 0.8)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if incacipated then
            Citizen.Wait(0)
            QBCore.Functions.DrawText("Incacipated. You must wait  " .. icounter .. " seconds till you wake up", 0.5, 0.8)
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if isHurt and Config.CanHurtRun == false then
            Citizen.Wait(0)
            DisableControlAction(0,0x8FFC75D6)
            if IsPedRunning(PlayerPedId()) or IsPedJumping(PlayerPedId()) then
                SetPedToRagdoll(PlayerPedId(), 3000, 3000, 0, 0, 0, 0)
            end
        else
            Citizen.Wait(1000)
            EnableControlAction(0,0x8FFC75D6)
        end
    end
end)

RegisterNetEvent('rprp_injury')
AddEventHandler('rprp_injury', function()
    local player = PlayerPedId()
    local playerPos = GetEntityCoords(player, true)
    if injureCount >= tonumber(Config.MaxInjureCount) then
        status = false
        isDead = true
        Notify("You are dead", "error")
        TriggerEvent('rprp_dead')
    else
        incacipated = true
        icounter = Config.KnockoutTimer
        injureCount = injureCount + 1
        NetworkResurrectLocalPlayer(playerPos, true, true, false)
        SetEntityHealth(player, 25)
        hcounter = Config.InjureCounter
        isHurt = true
        TriggerEvent('hurt')
        Notify("You are injured. Injure count: " .. injureCount, "error")
        Citizen.Wait(0)
        if not HasAnimDictLoaded("amb_rest@world_human_sleep_ground@arm@male_b@idle_b") then
            RequestAnimDict("amb_rest@world_human_sleep_ground@arm@male_b@idle_b")
            while not HasAnimDictLoaded("amb_rest@world_human_sleep_ground@arm@male_b@idle_b") do
                Citizen.Wait(100)
                RequestAnimDict("amb_rest@world_human_sleep_ground@arm@male_b@idle_b")
            end
        end
        Wait(100)
        TaskPlayAnim(player, 'amb_rest@world_human_sleep_ground@arm@male_b@idle_b', 'idle_f', 8.0, 8.0, -1, 1, 0, 0, 0, 0)
        RemoveAnimDict("amb_rest@world_human_sleep_ground@arm@male_b@idle_b")
        while incacipated do
            Citizen.Wait(1000)
            icounter = icounter - 1
            if icounter == 0 then
                incacipated = false

                Notify("You are waking up", "success")
                Citizen.Wait(5000)
                if not HasAnimDictLoaded("amb_rest@world_human_sleep_ground@arm@player_temp@exit") then
                    RequestAnimDict("amb_rest@world_human_sleep_ground@arm@player_temp@exit")
                    while not HasAnimDictLoaded("amb_rest@world_human_sleep_ground@arm@player_temp@exit") do
                        Citizen.Wait(100)
                        RequestAnimDict("amb_rest@world_human_sleep_ground@arm@player_temp@exit")
                    end
                end
                Wait(100)
                TaskPlayAnim(player, 'amb_rest@world_human_sleep_ground@arm@player_temp@exit', 'exit_right', 8.0, 8.0, -1, 1, 0, 0, 0, 0)
                RemoveAnimDict("amb_rest@world_human_sleep_ground@arm@player_temp@exit")
                Citizen.Wait(9000)
                ClearPedTasks(player)
                status = false
            end

        end
    end


end)

RegisterNetEvent('hurt')
AddEventHandler('hurt', function()
    Citizen.InvokeNative(0x406CCF555B04FAD3, PlayerPedId(), 1, 0.95)
    while isHurt do
        Citizen.Wait(1000)
        hcounter = hcounter - 1
        if hcounter == 0 then
            isHurt = false
            Citizen.Wait(10)
            Citizen.InvokeNative(0x406CCF555B04FAD3, PlayerPedId(), 1, 0.0)
        end

    end

end)

RegisterNetEvent('rprp_dead')
AddEventHandler('rprp_dead', function()
    local player = PlayerPedId()
    local playerPos = GetEntityCoords(player, true)
    counter = Config.Revive

    while isDead do
        Citizen.Wait(1000)
        counter = counter - 1

        if counter == 0 then
            NetworkResurrectLocalPlayer(playerPos, true, true, false)
            SetEntityHealth(player, 15)
            hcounter = Config.InjureCounter
            TriggerEvent('hurt')
            isHurt = true
            Citizen.Wait(0)
            if not HasAnimDictLoaded("amb_rest@world_human_sleep_ground@arm@male_b@idle_b") then
                RequestAnimDict("amb_rest@world_human_sleep_ground@arm@male_b@idle_b")
                while not HasAnimDictLoaded("amb_rest@world_human_sleep_ground@arm@male_b@idle_b") do
                    Citizen.Wait(100)
                    RequestAnimDict("amb_rest@world_human_sleep_ground@arm@male_b@idle_b")
                end
            end
            Wait(100)
            TaskPlayAnim(player, 'amb_rest@world_human_sleep_ground@arm@male_b@idle_b', 'idle_f', 8.0, 8.0, -1, 1, 0, 0, 0, 0)
            RemoveAnimDict("amb_rest@world_human_sleep_ground@arm@male_b@idle_b")

            Citizen.Wait(8000)
            if not HasAnimDictLoaded("amb_rest@world_human_sleep_ground@arm@player_temp@exit") then
                RequestAnimDict("amb_rest@world_human_sleep_ground@arm@player_temp@exit")
                while not HasAnimDictLoaded("amb_rest@world_human_sleep_ground@arm@player_temp@exit") do
                    Citizen.Wait(100)
                    RequestAnimDict("amb_rest@world_human_sleep_ground@arm@player_temp@exit")
                end
            end
            Wait(100)
            TaskPlayAnim(player, 'amb_rest@world_human_sleep_ground@arm@player_temp@exit', 'exit_right', 8.0, 8.0, -1, 1, 0, 0, 0, 0)
            RemoveAnimDict("amb_rest@world_human_sleep_ground@arm@player_temp@exit")
            Notify("You are waking up", "success")
            Citizen.Wait(5000)
            ClearPedTasks(player)
            isDead = false
            isInjured = false
            Citizen.Wait(50)
            counter = Config.Revive
            injureCount = 0
        end
    end
end)

RegisterNetEvent('rprp_revivedebug')
AddEventHandler('rprp_revivedebug', function()
    local player = PlayerPedId()
    local playerPos = GetEntityCoords(player, true)

    SetEntityMaxHealth(player, 200)
    SetEntityHealth(player, 200)
    NetworkResurrectLocalPlayer(playerPos, true, true, false)
    isDead = false
    isInjured = false
    injureCount = 0
end)

function Notify(text, style)
    if Config.AllowDebug then
        print("DEBUG: " .. text)
    end
    if Config.AllowNotify then
        QBCore.Functions.Notify(text, style)
    end
end

RegisterCommand("reviveme", function(src, args)
    if Config.ReviveDebug then
        TriggerEvent("rprp_revivedebug")
    else
        Notify("Command disabled.", "error")
    end
end)

RegisterCommand("tanim", function(src, args)
    local player = PlayerPedId()

    if not HasAnimDictLoaded("amb_rest@world_human_sleep_ground@arm@male_b@idle_b") then
        RequestAnimDict("amb_rest@world_human_sleep_ground@arm@male_b@idle_b")
        while not HasAnimDictLoaded("amb_rest@world_human_sleep_ground@arm@male_b@idle_b") do
            Citizen.Wait(100)
            RequestAnimDict("amb_rest@world_human_sleep_ground@arm@male_b@idle_b")
        end
    end
    Wait(100)
    TaskPlayAnim(player, 'amb_rest@world_human_sleep_ground@arm@male_b@idle_b', 'idle_f', 8.0, 8.0, -1, 1, 0, 0, 0, 0)
    RemoveAnimDict("amb_rest@world_human_sleep_ground@arm@male_b@idle_b")
end)

RegisterCommand("canim", function(src, args)
    local player = PlayerPedId()

    ClearPedTasks(player)
end)

