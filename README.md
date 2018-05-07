# VTX_Lua



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
