--Original script by wkochFPV, https://github.com/betaflight/betaflight/issues/3094, https://github.com/betaflight/betaflight/files/1017219/VTXprog.zip

-- I wanted to have this feature also. My LUA script takes care of this.

--Requirements:
--Same as for betaflight-tx-lua-scripts (OpenTX 2.2 compiled with LUA support, smartport telemetry connected to fc, unify pro connected to fc,, betaflight 3.1.x). My code is derived from these scripts.
--Unlocked Unify Pro, if more than 25mW desired.

--How to:

--Install betaflight-tx-lua-scripts as usual (my script only needs the file /SCRIPTS/BF/msp_sp.lua from the package located in /SCRIPTS/BF)
--Install my script VTXprog.lua in /SCRIPTS/MIXES
--In model menu of your taranis go to LUA-scripts page and enable VTXprog.lua and configure as follows:
--Enter your desired band: 1="A", 2="B", 3="E", 4="F", 5="R" (unify pro!)
--Enter your desired channel: 1,2,3…
--Select “global variable 1” (GV1, or another free global variable) as input for TxPower
--Now configure any switch to adjust GV1 to the desired power level: 0=pit mode, 1=25mW, 2=200mW … (use special functions menu, select ‘adjust GV1’ as action, enter desired value). Use e.g. 0 for your switch neutral position, 1 for switch up, 2 for switch down, if you would like to select 25mw or 200mw based on switch position.
--Now you can:
--Configure vtx in betaflight once to OPmodel “race” >> vtx starts in pit mode.
--Power up your model and your taranis, put swich in neutral position, vtx is in pit mode.
--Move you switch to change GV1 from 0 to 1 (or whatever you desire).
--Script will automatically set band, channel, selected power and turn off pit mode -> vtx starts transmission
--File “eng.wav” will be played as confirmation. (REMOVED)
--If you change your model battery, you can leave your taranis powered on, move switch back to neutral position (GV1->0) and then to the desired power level, the change will trigger the script to reprogram your vtx / start transmission again.

--Without any warranty!!!! Hope this helps. Thank to the developers of betaflight-tx-lua-scripts for providing the necessary code to accomplish this task!


-- define inputs
local INPUTS =
    {
        { "TxPower", SOURCE},                -- store requested TxPower in global variable, e.g. GV1
        { "TxBand", VALUE, 1, 5, 1 },
		{ "TxChannel", VALUE, 1, 8, 1 }
    }

-- Variables to store parameters last programmed to vtx
local lastPower = 0
local lastBand = 0
local lastChannel = 0

local MSP_VTX_SET_CONFIG = 89
local firstrun = 1

-- Returns payload to send to fc
local function VTXconfig(TxPower, TxBand, TxChannel)
   local channel = (TxBand-1)*8 + TxChannel-1
   return { bit32.band(channel,0xFF), bit32.rshift(channel,8), TxPower, 0 }  -- last 0 disables PIT mode
end
	
local function run(TxPower, TxBand, TxChannel)
    
	-- ignore any settings on first run of the script, send only further changes to vtx
	if firstrun == 1 then
		lastPower = TxPower
		lastBand = TxBand
		lastChannel = TxChannel
		firstrun = 0
	end
	
	if (lastPower ~= TxPower) or (lastBand ~= TxBand) or (lastChannel ~= TxChannel) then
		
		if TxPower > 0 then
			mspSendRequest(MSP_VTX_SET_CONFIG,VTXconfig(TxPower, TxBand, TxChannel))
		end
		
		lastPower = TxPower
		lastBand = TxBand
		lastChannel = TxChannel
	end
	
	mspProcessTxQ()
	
    return
end

return {input=INPUTS, run=run}
