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
   result, state, distance, proState = Call("GetNextRestrictiveSignal",0,0,10000)
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
    --AWS Set

    --Signal Emc
    if SignType == 7 then
        if gThu3 == 0 then
            if gHud3 <= 5 then
                Call("*:SetControlValue","EmergencyBrake",0,1)
            end
        end
    end
    
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