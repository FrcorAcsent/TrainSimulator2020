function Initialise ()
    Call("BeginUpdate")
end

DEBUG = true
Reserver = 0
panto = 0
airsw = 0
powersw = 0
Battery = 0
MCB = 0
gCSaspect = 0
PRIMARY_TEXT = 0
SECONDARY_TEXT = 0
ADRInfoFlashTime = 0
V_re_Mode = 0 -- 0 for Default 1 for Player 2 for Signal EMC 3 for ABS


Call("*:SetControlValue","TrainBrakeControl",0,1)
Call("*:SetControlValue","Reverser",0,0)
Call("*:SetControlValue","StartUp",0,-1)
Call( "*:SetControlValue", "PantographControl", 0, 0 )
--Call("swlit02:ActivateNode",0)
--Call("swlit04:ActivateNode",0)
Call("*:SetControlValue","Battery",0,0)
Call("*:SetControlValue","MCB",0,0)
Call("*:SetControlValue","Indicator_RED",0,2)
Call("*:SetControlValue","Indicator_GREEN",0,3)

function Update (Time)
    --Engine Start
    panto = Call("*:GetControlValue","PantographControl",0)
    Reserver = Call("*:GetControlValue","Reverser",0)
    airsw = Call("*:GetControlValue","AirSwitch",0)
    powersw = Call("*:GetControlValue","PowerSwitch",0)
    Battery = Call("*:GetControlValue","Battery",0)
    MCB = Call("*:GetControlValue","MCB",0)
    if MCB == 0 then
        Call( "*:SetControlValue", "battery", 0, 0 )
        Call( "*:SetControlValue", "Airswitch", 0, 0 )
        Call( "*:SetControlValue", "powerswitch", 0, 0 )
        Call( "*:SetControlValue", "PantographControl", 0, 0 )
        Call( "*:SetControlValue", "Startup", 0, -1 )
    elseif MCB ~= 1 then
        Call( "*:SetControlValue", "powerswitch", 0, 0 )
        Call( "*:SetControlValue", "Airswitch", 0, 0 )
        Call( "*:SetControlValue", "PantographControl", 0, 0 )
        Call( "*:SetControlValue", "Startup", 0, -1 )
    if battery == 0 then
        Call( "*:SetControlValue", "powerswitch", 0, 0 )
        Call( "*:SetControlValue", "Airswitch", 0, 0 )
        Call( "*:SetControlValue", "PantographControl", 0, 0 )
        Call( "*:SetControlValue", "Startup", 0, -1 )
    elseif battery ~= 1 then
        Call( "*:SetControlValue", "powerswitch", 0, 0 )
        Call( "*:SetControlValue", "PantographControl", 0, 0 )
        Call( "*:SetControlValue", "Startup", 0, -1 )
    if airsw == 0 then
        Call( "*:SetControlValue", "powerswitch", 0, 0 )
        Call( "*:SetControlValue", "PantographControl", 0, 0 )
        Call( "*:SetControlValue", "Startup", 0, -1 )
    elseif airsw ~= 1 then
        Call( "*:SetControlValue", "PantographControl", 0, 0 )
        Call( "*:SetControlValue", "Startup", 0, -1 )
    if powersw == 0 then
        Call( "*:SetControlValue", "PantographControl", 0, 0 )
        Call( "*:SetControlValue", "Startup", 0, -1 )
    elseif powersw ~= 1 then
        Call( "*:SetControlValue", "PantographControl", 0, 0 )
        Call( "*:SetControlValue", "Startup", 0, -1 )
    if panto == 0 then
        Call( "*:SetControlValue", "Startup", 0, -1 )
    else
        Call("*:SetControlValue","Indicator_RED",0,1)
        Call("*:SetControlValue","Indicator_GREEN",0,4)
        Call( "*:SetControlValue", "Startup", 0, 1 )
    end
end
end    
end
end
   --CheCi Panel

   --DisTanCe Panel
   limitType, limit1, distance = Call( "GetNextSpeedLimit" )
   gDistance = distance
   gDistance2 = math.floor(distance)
   if gDistance2 >= 10000 then
    Call("*:SetControlValue","TargetDistanceDigits1000",0,9.1)
    Call("*:SetControlValue","TargetDistanceDigits100",0,9.1)
    Call("*:SetControlValue","TargetDistanceDigits10",0,9.1)
    Call("*:SetControlValue","TargetDistanceDigits1",0,9.1)
   else
    gSin3= math.floor( math.mod( gDistance2, 10))
    gTens3 = math.floor( math.mod( gDistance2/10, 10 ))
    gHud3 = math.floor( math.mod( gDistance2/100, 10 ))
    gThu3 = math.floor( gDistance2/1000 )
    Call("*:SetControlValue","TargetDistanceDigits1000",0,gThu3)
    Call("*:SetControlValue","TargetDistanceDigits100",0,gHud3)
    Call("*:SetControlValue","TargetDistanceDigits10",0,gTens3)
    Call("*:SetControlValue","TargetDistanceDigits1",0,gSin3)
    end
    
    --Anto Driver
    local Auto_D = Call("*:GetControlValue","AutoCab",0)
    TBC = Call("*:GetControlValue","TrainBrakeControl",0)
    if Auto_D == 1 then
        Call("*:SetControlValue","ADRInfo",0,0.5)
        AutoDriver_SpeedControl()
        if SignType == 1 then
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
        elseif SignType == 2 then
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
        elseif SignType == 3 then
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
        elseif SignType == 4 then
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
        elseif SignType == 5 then
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
        elseif SignType == 6 then
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
        elseif SignType == 7 then
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
        Call("*:SetControlValue","ADRInfo",0,0)
    end

    
    
    --AWS Set

 

    --Speed Control
    gSpeed = Call("*:GetControlValue","SpeedometerKPH",0)
    gSpeed2 = math.floor(gSpeed)
    cSpeed = Call("GetCurrentSpeedLimit")
    TrackSpeedLimit = cSpeed * 3.6
    if gSpeed2 > TrackSpeedLimit then
        Cha = gSpeed2 - TrackSpeedLimit
        if Cha >= 10 then
            Call("*:SetControlValue","TrainBrakeControl",0,0.381)
        end
    end

    --Handle Control
    Regulator = Call("*:GetControlValue","Regulator",0)
    V_Regulator = Call("*:GetControlValue","VirtualRegulator",0)
    if V_re_Mode == 0 then
        if V_Regulator > 0.001 then
            V_re_Mode = 1
        end
    elseif V_re_Mode == 1 then
        if Regulator > V_Regulator then
            if Regulator - V_Regulator >= 0.05 then
                Call("*:SetControlValue","VirtualRegulator",0,Regulator)
            end
        else
            if V_Regulator - Regulator >= 0.05 then
                Call("*:SetControlValue","Regulator",0,V_Regulator)
            end
        end
    elseif V_re_Mode == 2 then
        if SignType < 7 then
            V_re_Mode = 1
        end
    end --ABS Developing...

end

function AutoDriver_SpeedControl ()
    AD_Speed = Call("*:GetControlValue","SpeedometerKPH",0)
    C_Speed1 = Call("GetCurrentSpeedLimit")
    C_Speed = C_Speed1 * 3.6
    --Track Limit Control
    if AD_Speed > C_Speed then
        Call("*:SetControlValue","TrainBrakeControl",0,0.751)
    elseif SignType == 1 then
            if AD_Speed > 350 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 350 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.975)
            end
        elseif SignType == 2 then
            if AD_Speed > 300 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 300 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.865)
            end
        elseif SignType == 3 then
            if AD_Speed > 230 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 230 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.549)
            end
        elseif SignType == 4 then
            if AD_Speed > 160 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 160 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.432)
            end
        elseif SignType == 5 then
            if AD_Speed > 90 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 90 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.315)
            end
        elseif SignType == 6 then
            if AD_Speed > 45 then
                Call("*:SetControlValue","Regulator",0,0)
                Call("*:SetControlValue","TrainBrakeControl",0,0.751)
            elseif AD_Speed <= 45 then
                Call("*:SetControlValue","TrainBrakeControl",0,0)
                Call("*:SetControlValue","Regulator",0,0.231)
            end
        elseif SignType == 7 then
            local result, state, distance2, proState = Call( "GetNextRestrictiveSignal" )
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

--CTCS Signal

function OnCustomSignalMessage( SigValue )
    SigValue1 = string.sub(SigValue,4,4)
    SignType = tonumber( SigValue1 )
    --Call("*:SetControlValue","CabSign",0,SignType)
    if SignType == 0 then
        Call("*:SetControlValue","CabSign",0,11)
    elseif SignType == 1 then
        Call("*:SetControlValue","CabSign",0,22)
    elseif SignType == 2 then
        Call("*:SetControlValue","CabSign",0,66)
    elseif SignType == 3 then
        Call("*:SetControlValue","CabSign",0,77)
    elseif SignType == 4 then
        Call("*:SetControlValue","CabSign",0,33)
    elseif SignType == 5 then
        Call("*:SetControlValue","CabSign",0,44)
    elseif SignType == 6 then
        Call("*:SetControlValue","CabSign",0,79)
    elseif SignType == 7 then
        Call("*:SetControlValue","CabSign",0,55)
    end
end

        function DebugPrint( message )
	if (DEBUG) then
		Print( message )
    end
end
function OnControlValueChange ( name, index, value )
    Call( "*:SetControlValue", name, index, value )
end