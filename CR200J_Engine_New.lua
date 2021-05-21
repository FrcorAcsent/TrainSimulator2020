---***CR200J Engine Control***---
---===Power by Phantom===---
---***2021/01/27***---


function Initialise ()
    Call("BeginUpdate")
end

Battery = 0
PowerSw = 0
Panto = 0
MCB = 0
KeySw = 0
AirSw = 0
SignType = 0
SignMode = 0
--LED Number
A_Num1 = 0
A_Num2 = 0
A_Num3 = 0
A_Num4 = 0
A_Num5 = 0
A_Num6 = 0
A_Num7 = 0
A_Num8 = 0
A_Num9 = 0
A_Num0 = 0
A_Confirm = 0
A_Cancel = 0
A_Clean = 0
A_D_To_N1 = 0
A_N1_To_N2 = 0
A_N2_To_N3 = 0
A_N3_To_N4 = 0

--Panto

PantoType = 0


Set = "*:SetControlValue"
Get = "*:GetControlValue"
Add = "*:AddTime"
Call(Set,"EmergencyBrake",0,1)
Call(Set,"PantographControl",0,0)
Call(Set,"A_N1_00",0,1)
Call(Set,"Speed1",0,1)
Call(Set,"Speed10",0,1)
Call(Set,"Speed100",0,1)
Call(Set,"PantoControlSwitch",0,0)
Call(Set,"PantoChangeSwitch",0,0)
Call("*:ActivateNode","CabLights",0)

function Update ( Time )
    KeySw = Call(Get,"KeySw",0)
    Panto = Call(Get,"PantographControl",0)
    Battery = Call(Get,"Battery",0)
    PowerSw = Call(Get,"PowerSw",0)
    MCB = Call(Get,"MCB",0)
    AirSw = Call(Get,"AirSw",0)
    Pcon = Call(Get,"PantoControlSwitch",0)
    Pcon2 = Call(Get,"PantoChangeSwitch",0)
    --if KeySw == 0 then
        --Call(Set,"EmergencyBrake",0,1)
        --Call(Set,"StartUp",0,-1)
    --elseif KeySw == 1 then
        --Call(Set,"EmergencyBrake",0,1)
        --Call(Set,"StartUp",0,-1)
        if Battery == 0 then
            Call(Set,"PowerSw",0,0)
            Call(Set,"AirSw",0,0)
            Call(Set,"EmergencyBrake",0,1)
            Call(Set,"StartUp",0,-1)
        elseif Battery == 1 then
            Call(Set,"EmergencyBrake",0,1)
            Call(Set,"StartUp",0,-1)
            if PowerSw == 0 then
                Call(Set,"AirSw",0,0)
                Call(Set,"EmergencyBrake",0,1)
                Call(Set,"StartUp",0,-1)
            elseif PowerSw == 1 then
                Call(Set,"EmergencyBrake",0,1)
                Call(Set,"StartUp",0,-1)
                if AirSw == 0 then
                    Call(Set,"PantographControl",0,0)
                    Call(Set,"EmergencyBrake",0,1)
                    Call(Set,"StartUp",0,-1)
                elseif AirSw == 1 then
                    Call(Set,"EmergencyBrake",0,0)
                    Call(Set,"MCB",0,0)
                    if Panto == 0 then
                        Call(Set,"MCB",0,0)
                        Call(Set,"StartUp",0,-1)
                    elseif Panto ~= 1 then
                        Call(Set,"StartUpInfo",0,2)
                        Call(Set,"StartUp",0,-1)
                        if MCB == 0 then
                            Call(Set,"StartUp",0,-1)
                        else
                            Call(Set,"StartUp",0,1)
                            --SysCall("ScenarioManager:ShowAlertMessageExt", "INFO" , "Engine On" , 3 )
                            --SysCall("ScenarioManager:ShowAlertMessageExt", "INFO" , "Speed Alert On" , 3 )
                        end
                    end
                end
            end
        --end
    end

    
    --Speed LED
    gSpeed = Call("*:GetControlValue", "SpeedometerKPH", 0)
    gSpeed2 = math.floor(gSpeed)
    --gSPdecimal = math.floor( math.mod( gSpeed2, 10 ))
    gUnits = math.floor( math.mod( gSpeed2, 10 ))
    gTens = math.floor( math.mod( gSpeed2/10, 10 ))
    gHundreds = math.floor( math.mod( gSpeed2/100, 10 ))
    gUnits1 = gUnits + 1
    gTens1 = gTens + 1
    gHundreds1 = gHundreds + 1
    -- Note: If RW adopts LUA 4 or higher, mod(a, b) becomes a % b
    Call("*:SetControlValue","Speed1",gUnits1)
    Call("*:SetControlValue","Speed10",gTens1)
    Call("*:SetControlValue","Speed100",gHundreds1)
    

    --Limit Speed
    trackLimit = Call("GetCurrentSpeedLimit")
    tl_Speed = trackLimit * 3.6
    tl_units = math.floor( math.mod( tl_Speed, 10 ))
    tl_Tens = math.floor( math.mod( tl_Speed/10, 10 ))
    tl_Hun = math.floor( math.mod( tl_Speed/100, 10 ))
    tl_units1 = tl_units + 1
    tl_Tens1 = tl_Tens + 1
    tl_Hun1 = tl_Hun + 1
    --Limit Speed LED
    Call("*:SetControlValue","SE_TL_1",tl_units1)
    Call("*:SetControlValue","SE_TL_10",tl_Tens1)
    Call("*:SetControlValue","SE_TL_100",tl_Hun1)

    --Next Limit Speed Distance.
    limitType, limit1, distance = Call( "GetNextSpeedLimit" )
    gDistance = distance
    gDistance2 = math.floor(distance)
    if gDistance2 >= 10000 then
        Call(Set,"Distance_1000",0,10)
        Call(Set,"Distance_100",0,10)
        Call(Set,"Distance_10",0,10)
        Call(Set,"Distance_1",0,10)
    else
        Dis_Sin= math.floor( math.mod( gDistance2, 10))
        Dis_Ten = math.floor( math.mod( gDistance2/10, 10 ))
        Dis_Hud = math.floor( math.mod( gDistance2/100, 10 ))
        Dis_Thu = math.floor( gDistance2/1000 )
        Dis_Hud1 = Dis_Hud + 1
        Dis_Ten1 = Dis_Ten + 1
        Dis_Thu1 = Dis_Thu + 1
        Dis_Sig1 = Dis_Sin + 1
        Call("*:SetControlValue","Distance_1000",0,Dis_Thu1)
        Call("*:SetControlValue","Distance_100",0,Dis_Hud1)
        Call("*:SetControlValue","Distance_10",0,Dis_Ten1)
        Call("*:SetControlValue","Distance_1",0,Dis_Sig1)
    end

    --Alert Speed Messege
    if gSpeed2 > tl_Speed then
        Call("*:SetControlValue","AlertMessege",0,1)
        if gSpeed2 - limit1 >= 50 then
            if gDistance2 <= 3000 then
                Call("*:SetControlValue","AlertMessege",0,2)
            else
                Call("*:SetControlValue","AlertMessege",0,0)
            end
        end
    else
        Call(Set,"AlertMessege",0,0)
    end

    --ATP Control
    TrackSpeedLimit = Call("GetCurrentSpeedLimit") * 3.6
    if Call(Get,"ATPControl",0) <= 0 then
        if Call(Get,"SpeedometerKPH",0) > TrackSpeedLimit then
            Call(Set,"TrainBrakeControl",0,0.51)
        else
            Call(Set,"TrainBrakeControl",0,Call(Get,"VirtualBrake",0))
        end
    end

    --Signal Swith And Pantograph Control
    if Call(Get,"SignSwith",0) >= 1 then
        SignMode = 1
    else
        SignMode = 0
    end

    --Pantograph Control 47 5-6 46 6-5  
    
    if Panto >= 0.5 then
        if Pcon2 < 0.7 then
            if (Call(Get,"SpeedometerKPH",0) > 5 and cnm == 2) then
                PantoControl(47)
            else
                PantoControl(23)
                cnm = 1
            end
        elseif Pcon2 > 0.8 then
            if (Call(Get,"SpeedometerKPH",0) > 5 and cnm == 1) then
                PantoControl(46)
            else
                PantoControl(13)
                cnm = 2
            end
        end
    else
        if Pcon2 > 0.8 then
            PantoControl(023)
        else
            PantoControl(03)
        end
    end

    --Cabin light control
    if Call(Get,"CabLights",0) >= 0.99 then
        Call("*:ActivateNode","CabLights",1)
    else
        Call("*:ActivateNode","CabLights",0)
    end

    --HeadLights In Tunnel.
    Tunnel = Call("GetIsInTunnel")
    HLSW = Call(Get,"Headlights",0)
    LightsMode = HLSW

    if Tunnel == 0 then
        TunnelMode = 0
    else
        TunnelMode = 1
    end

    if LightsMode == 0 then
        if TunnelMode == 1 then
            Call(Set,"Headlights",0,2)
        else
            Call(Set,"Headlights",0,0)
            LightsMode = 0
            TunnelMode = 0
        end
    else
        Call(Set,"Headlights",0,HLSW)
    end
end

--RISC_SV_CTCS2 CHINA SIGNAL
function OnCustomSignalMessage( NewCode )
    if SignMode == 0 then
        cabSigCode = NewCode + 1 
        Call( "*:SetControlValue", "CabSign", 0,cabSigCode)
        Call( "*:SetControlValue", "CabSigSound",0,cabSigCode)
    end
    if SignMode == 1 then
        SigValue1 = string.sub(NewCode,4,4)
        SignType = tonumber( SigValue1 )
        if SignType == 0 then
            Call("*:SetControlValue","CabSign",0,1) --S_NON 
            Call( "*:SetControlValue", "CabSigSound",0,20)
        elseif SignType == 1 then
            Call("*:SetControlValue","CabSign",0,11) --S_GRE350
            Call( "*:SetControlValue", "CabSigSound",0,20)
        elseif SignType == 2 then
            Call("*:SetControlValue","CabSign",0,11) --S_GRE300
            Call( "*:SetControlValue", "CabSigSound",0,20)
        elseif SignType == 3 then
            Call("*:SetControlValue","CabSign",0,10) --S_GRE230(GREYE)
            Call( "*:SetControlValue", "CabSigSound",0,20)
        elseif SignType == 4 then
            Call("*:SetControlValue","CabSign",0,9) --S_YE160
            Call( "*:SetControlValue", "CabSigSound",0,20)
        elseif SignType == 5 then
            Call("*:SetControlValue","CabSign",0,7) --S_YE90 (YE2)
            Call( "*:SetControlValue", "CabSigSound",0,20)
        elseif SignType == 6 then
            Call("*:SetControlValue","CabSign",0,6) --S_YE45 (DYE)
            Call( "*:SetControlValue", "CabSigSound",0,20)
        elseif SignType == 7 then
            Call("*:SetControlValue","CabSign",0,2) --S_RED
            Call( "*:SetControlValue", "CabSigSound",0,20)
        end
    end
end

function PantoControl (ControlCode)
    if ControlCode == 13 then --13 for 5.5m CTCS2 (Engine key)
            Call(Add,"Rear_panto_5",0.003)
    elseif ControlCode == 23 then --23 for 6m RISC Signal (Engine Key)
            Call(Add,"Rear_panto_6",0.003)
    elseif ControlCode == 45 then --self-adaption
        if SignType >= 1 then
            Call(Add,"Rear_panto_6",-0.003)
            Call(Add,"Rear_panto_6_to_5",0.003)
        elseif cabSigCode >= 1 then
            Call(Add,"Rear_panto_5",-0.003)
            Call(Add,"Rear_panto_5_to_6",0.003)
        end
    elseif ControlCode == 46 then
        Call(Add,"Rear_panto_6",-0.003)
        Call(Add,"Rear_panto_6_to_5",0.003)
    elseif ControlCode == 47 then
        Call(Add,"Rear_panto_5",-0.003)
        Call(Add,"Rear_panto_5_to_6",0.003)
    elseif ControlCode == 03 then
        Call(Add,"Rear_panto_6",-0.003)
    elseif ControlCode == 023 then
        Call(Add,"Readr_panto_5",-0.003)
    end

end


function OnControlValueChange ( name, index, value )
    Call( "*:SetControlValue", name, index, value )
end