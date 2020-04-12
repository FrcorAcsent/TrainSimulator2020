function Initialise ()
    Call("BeginUpdate")
end

Battery = 0
PowerSw = 0
Panto = 0
MCB = 0
KeySw = 0
AirSw = 0
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
Set = "*:SetControlValue"
Get = "*:GetControlValue"
Call(Set,"EmergencyBrake",0,1)
Call(Set,"PantographControl",0,0)
Call(Set,"A_N1_00",0,1)
Call(Set,"Speed1",0,1)
Call(Set,"Speed10",0,1)
Call(Set,"Speed100",0,1)
Call(Set,"NUM_D",0,2)
Call(Set,"NUM_N1",0,2)
Call(Set,"NUM_N2",0,1)
Call(Set,"NUM_N3",0,8)
Call(Set,"NUM_N4",0,6)

function Update ( Time )
    --Eninge Start 总控-->电池1档-->电源1档-->压缩机开-->受电弓升-->主断分-->启动
    KeySw = Call(Get,"KeySw",0)
    Panto = Call(Get,"PantographControl",0)
    Battery = Call(Get,"Battery",0)
    PowerSw = Call(Get,"PowerSw",0)
    MCB = Call(Get,"MCB",0)
    AirSw = Call(Get,"AirSw",0)
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

    --Custom Train Number
    --Num3 Num4 Need +1
    A0 = Call(Get,"A0",0)
    A1 = Call(Get,"A0",0)
    A2 = Call(Get,"A0",0)
    A3 = Call(Get,"A0",0)
    A4 = Call(Get,"A0",0)
    A5 = Call(Get,"A0",0)
    A6 = Call(Get,"A0",0)
    A7 = Call(Get,"A0",0)
    A8 = Call(Get,"A0",0)
    A9 = Call(Get,"A0",0)
    --Number Increase + 
    if A1 == 1 then
        if A_D_To_N1 == 1 then
            A_N1_To_N2 = 1
            A_Num1 = 1
            Call(Set,"A_Number_1",0,A_Num1)
            Call(Set,"NUM_N1",0,A_Num1)
        elseif A_N1_To_N2 == 1 then
            A_N2_To_N3 = 1
            A_Num1 = 1
            Call(Set,"A_Number_2",0,A_Num1)
            Call(Set,"NUM_N2",0,A_Num1)
        elseif A_N2_To_N3 == 1 then
            A_N3_To_N4 = 1
            A_Num1 = 1
            Call(Set,"A_Number_3",0,A_Num1)
            Call(Set,"NUM_N3",0,A_Num1)
        elseif A_N3_To_N4 == 1 then
            A_Num1 = 1
            Call(Set,"A_Number_4",0,A_Num1)
            Call(Set,"NUM_N4",0,A_Num1)
        else
            A_D_To_N1 = 1
            A_Num1 = 1
            Call(Set,"A_Number_D",0,A_Num1)
            Call(Set,"NUM_D",0,A_Num1)
        end
    end
    if A2 == 1 then
        if A_D_To_N1 == 1 then
            A_N1_To_N2 = 1
            A_Num2 = 2
            Call(Set,"A_Number_1",0,A_Num2)
            Call(Set,"NUM_N1",0,A_Num2)
        elseif A_N1_To_N2 == 1 then
            A_N2_To_N3 = 1
            A_Num2 = 2
            Call(Set,"A_Number_2",0,A_Num2)
            Call(Set,"NUM_N2",0,A_Num2)
        elseif A_N2_To_N3 == 1 then
            A_N3_To_N4 = 1
            A_Num2 = 2
            Call(Set,"A_Number_3",0,A_Num2)
            Call(Set,"NUM_N3",0,A_Num2)
        elseif A_N3_To_N4 == 1 then
            A_Num2 = 1
            Call(Set,"A_Number_4",0,A_Num2)
            Call(Set,"NUM_N4",0,A_Num2)
        else
            A_D_To_N1 = 1
            A_Num2 = 1
            Call(Set,"A_Number_D",0,A_Num2)
            Call(Set,"NUM_D",0,A_Num2)
        end
    end
    if  A3 == 1 then
        if A_D_To_N1 == 1 then
            A_N1_To_N2 = 1
            A_Num3 = 3
            Call(Set,"A_Number_1",0,A_Num3)
            Call(Set,"NUM_N1",0,A_Num3)
        elseif A_N1_To_N2 == 1 then
            A_N2_To_N3 = 1
            A_Num3 = 3
            Call(Set,"A_Number_2",0,A_Num3)
            Call(Set,"NUM_N2",0,A_Num3)
        elseif A_N2_To_N3 == 1 then
            A_N3_To_N4 = 1
            A_Num3 = 3
            Call(Set,"A_Number_3",0,A_Num3)
            Call(Set,"NUM_N3",0,A_Num3)
        elseif A_N3_To_N4 == 1 then
            A_Num3 = 3
            Call(Set,"A_Number_4",0,A_Num3)
            Call(Set,"NUM_N4",0,A_Num3)
        else
            A_D_To_N1 = 1
            A_Num3 = 3
            Call(Set,"A_Number_D",0,A_Num3)
            Call(Set,"NUM_D",0,A_Num3)
        end
    end
    --Cancel
    if  "A_Cancel" then
        Number_Cancel_Clean()
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

    --Auto Driver
    local Auto_D = Call("*:GetControlValue","AutoDriver",0)
    TBC = Call("*:GetControlValue","TrainBrakeControl",0)
    if Auto_D == 1 then
        --Call("*:SetControlValue","ADRInfo",0,0.5)
        AutoDriver_SpeedControl()
        if cabSigCode == 11 then --Green
            if TBC == 0 then
                local A_RESE = Call("*:GetControlValue","Reverser",0)
                local A_REGL = Call("*:GetControlValue","Regulator",0)
                if A_RESE == 0 then
                    Call("*:SetControlValue","Reverser",0,1)
                    Call("*:SetControlValue","Regulator",0,0.975)
                    AutoDriver_SpeedControl()
                else
                    Call("*:SetControlValue","Regulator",0,0.975)
                    AutoDriver_SpeedControl()
                end
            else
                AutoDriver_SpeedControl()
            end
        elseif cabSigCode == 10 then --GreenYellow
            if TBC == 0 then
                local A_RESE = Call("*:GetControlValue","Reverser",0)
                local A_REGL = Call("*:GetControlValue","Regulator",0)
                if A_RESE == 0 then
                    Call("*:SetControlValue","Reverser",0,1)
                    Call("*:SetControlValue","Regulator",0,0.865)
                    AutoDriver_SpeedControl()
                else
                    Call("*:SetControlValue","Regulator",0,0.865)
                    AutoDriver_SpeedControl()
                end
            else
                AutoDriver_SpeedControl()
            end
        elseif cabSigCode == 8 then --Yellow
            if TBC == 0 then
                local A_RESE = Call("*:GetControlValue","Reverser",0)
                local A_REGL = Call("*:GetControlValue","Regulator",0)
                if A_RESE == 0 then
                    Call("*:SetControlValue","Reverser",0,1)
                    Call("*:SetControlValue","Regulator",0,0.549)
                    AutoDriver_SpeedControl()
                else
                    Call("*:SetControlValue","Regulator",0,0.549)
                    AutoDriver_SpeedControl()
                end
            else
                AutoDriver_SpeedControl()
            end
        elseif 4.99 <= cabSigCode <= 6.01 then --Double Yellow
            if TBC == 0 then
                local A_RESE = Call("*:GetControlValue","Reverser",0)
                local A_REGL = Call("*:GetControlValue","Regulator",0)
                if A_RESE == 0 then
                    Call("*:SetControlValue","Reverser",0,1)
                    Call("*:SetControlValue","Regulator",0,0.432)
                    AutoDriver_SpeedControl()
                else
                    Call("*:SetControlValue","Regulator",0,0.432)
                    AutoDriver_SpeedControl()
                end
            else
                AutoDriver_SpeedControl()
            end
        elseif 6.99 <= cabSigCode <= 8.01 then
            if TBC == 0 then
                local A_RESE = Call("*:GetControlValue","Reverser",0)
                local A_REGL = Call("*:GetControlValue","Regulator",0)
                if A_RESE == 0 then
                    Call("*:SetControlValue","Reverser",0,1)
                    Call("*:SetControlValue","Regulator",0,0.315)
                    AutoDriver_SpeedControl()
                else
                    Call("*:SetControlValue","Regulator",0,0.315)
                    AutoDriver_SpeedControl()
                end
            else
                AutoDriver_SpeedControl()
            end
        elseif 2.99 <= cabSigCode <= 4.01 then
            if TBC == 0 then
                local A_RESE = Call("*:GetControlValue","Reverser",0)
                local A_REGL = Call("*:GetControlValue","Regulator",0)
                if A_RESE == 0 then
                    Call("*:SetControlValue","Reverser",0,1)
                    Call("*:SetControlValue","Regulator",0,0.231)
                    AutoDriver_SpeedControl()
                else
                    Call("*:SetControlValue","Regulator",0,0.231)
                    AutoDriver_SpeedControl()
                end
            else
                AutoDriver_SpeedControl()
            end
        elseif cabSigCode == 2 then
            if TBC == 0 then
                local A_RESE = Call("*:GetControlValue","Reverser",0)
                local A_REGL = Call("*:GetControlValue","Regulator",0)
                if A_RESE == 0 then
                    Call("*:SetControlValue","Reverser",0,1)
                    Call("*:SetControlValue","Regulator",0,0.231)
                    AutoDriver_SpeedControl()
                else
                    Call("*:SetControlValue","Regulator",0,0.231)
                    AutoDriver_SpeedControl()
                end
            else
                AutoDriver_SpeedControl()
            end
        end
    else
       --Call("*:SetControlValue","ADRInfo",0,0)
    end

    --Speed Control
    if Call(Get,"AutoSp",0) == 1 then
        local Speedo = Call(Get,"SpeedometerKPH",0)
        local C_Speedo = Call("GetCurrentSpeedLimit")
        C_Speedo1 = C_Speedo * 3.6
        if Speedo > C_Speedo1 then
            Call(Set,"TrainBrakeControl",0,0.556)
        else
            Call(Set,"TrainBrakeControl",0,0)
        end
    end
    
    --AFB Control
    local AFBSW = Call(Get,"AFBSwitch",0)
    local AFB_Speed = Call("*:GetControlValue","SpeedometerKPH",0)
    local AFC_Speed1 = Call("GetCurrentSpeedLimit")
    AFC_Speed = AFC_Speed1 * 3.6
    if AFBSW == 1 then
        if AFB_Speed > AFC_Speed then
            Call(Set,"Regulator",0,0)
            Call(Set,"TrainBrakeControl",0,0.556)
        else
            Call(Set,"Regulator",0,0.737)
            Call(Set,"TrainBrakeControl",0,0)
        end
    end
            
        
end

--RISC CHINA SIGNAL
function OnCustomSignalMessage( NewCode )
	cabSigCode = NewCode + 1
	Call( "*:SetControlValue", "CabSign", 0, cabSigCode )
end


--Custom Train Number's Function
function Number_Cancel_Clean ()
    Call(Set,"NUM_D",0,1)
    Call(Set,"NUM_N1",0,1)
    Call(Set,"NUM_N2",0,1)
    Call(Set,"NUM_N3",0,0)
    Call(Set,"NUM_N4",0,0)
    Call(Set,"A_Number_D",0,1)
    Call(Set,"A_Number_1",0,1)
    Call(Set,"A_Number_2",0,1)
    Call(Set,"A_Number_3",0,1)
    Call(Set,"A_Number_4",0,1)
    A_D_To_N1 = 0
    A_N1_To_N2 = 0
    A_N2_To_N3 = 0
    A_N3_To_N4 = 0
end

function AutoDriver_SpeedControl ()
    local AD_Speed = Call("*:GetControlValue","SpeedometerKPH",0)
    local C_Speed1 = Call("GetCurrentSpeedLimit")
    C_Speed = C_Speed1 * 3.6
    --Track Limit Control
    if AD_Speed > C_Speed then
        Call("*:SetControlValue","TrainBrakeControl",0,0.751)
    elseif cabSigCode == 11 then
            if AD_Speed > 160 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 160 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.975)
            end
        elseif cabSigCode == 10 then
            if AD_Speed > 160 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 160 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.865)
            end
        elseif cabSigCode == 8 then
            if AD_Speed > 120 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 120 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.549)
            end
        elseif 4.99 <= cabSigCode <= 6.01 then
            if AD_Speed > 50 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 50 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.432)
            end
        elseif 6.99 <= cabSigCode <= 8.01 then
            if AD_Speed > 80 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 80 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.315)
            end
        elseif 2.99 <= cabSigCode <= 4.01 then
            local result, state, distance4, proState = Call( "GetNextRestrictiveSignal" )
            distance5 = math.floor(distance4)
            if distance2 <= 500 then
                Call("*:SetControlValue","TrainBrakeControl",0,0.729)
                if AD_Speed <= 30 then
                    Call("*:SetControlValue","TrainBrakeControl",0,0)
                end
            elseif distance2 <= 200 then
                Call("*:SetControlValue","TrainBrakeControl",0,0.729)
                if AD_Speed <= 15 then
                    Call("*:SetControlValue","TrainBrakeControl",0,0)
                end
            elseif distance2 <= 100 then
                Call("*:SetControlValue","TrainBrakeControl",0,0.729)
                if AD_Speed <= 8.5 then
                    Call("*:SetControlValue","TrainBrakeControl",0,0)
                end
            elseif distance2 <= 50 then
                Call("*:SetControlValue","TrainBrakeControl",0,0.729)
                if AD_Speed <= 5.5 then
                    Call("*:SetControlValue","TrainBrakeControl",0,0)
                end
            elseif distance2 <= 20 then
                Call("*:SetControlValue","TrainBrakeControl",0,0.729)
                if AD_Speed == 0 then
                    Call("*:SetControlValue","TrainBrakeControl",0,0)
                end
            end
        elseif cabSigCode == 2 then
            local result, state, distance3, proState = Call( "GetNextRestrictiveSignal" )
            distance2 = math.floor(distance3)
            if distance2 <= 500 then
                Call("*:SetControlValue","TrainBrakeControl",0,0.729)
                if AD_Speed <= 30 then
                    Call("*:SetControlValue","TrainBrakeControl",0,0)
                end
            elseif distance2 <= 200 then
                Call("*:SetControlValue","TrainBrakeControl",0,0.729)
                if AD_Speed <= 15 then
                    Call("*:SetControlValue","TrainBrakeControl",0,0)
                end
            elseif distance2 <= 100 then
                Call("*:SetControlValue","TrainBrakeControl",0,0.729)
                if AD_Speed <= 8.5 then
                    Call("*:SetControlValue","TrainBrakeControl",0,0)
                end
            elseif distance2 <= 50 then
                Call("*:SetControlValue","TrainBrakeControl",0,0.729)
                if AD_Speed <= 5.5 then
                    Call("*:SetControlValue","TrainBrakeControl",0,0)
                end
            elseif distance2 <= 20 then
                Call("*:SetControlValue","TrainBrakeControl",0,0.729)
                if AD_Speed == 0 then
                    Call("*:SetControlValue","TrainBrakeControl",0,0)
                end
            end
    else
        Call("*:SetControlValue","TrainBrakeControl",0,0)
    end
    --Signal Control
    
end


function OnControlValueChange ( name, index, value )
    Call( "*:SetControlValue", name, index, value )
end