--[[
Bob's Cast Chatter.
This addon allows you to proc emotes by chance when spells are cast, as well
as by chance by an idle timer.

For more details, see the Github repository:
https://github.com/bobmajdakjr/wow-bobs-cast-chatter/blob/master/README.md
--]]

--[[
global table BCCDB
function BCC_OnEvent(self, event, ...)
function BCC_OnEvent_Init(void)
function BCC_OnEvent_SpellCast(...)
function BCC_OnUpdate(self, time)
--]]

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

BCCDB = {
	-- global variable for addon configuration.
	-- saved: yes
	-- built by: BCC_BuildConfig()
}

-- /////////////////////////////////////////////////////////////////////////////
-- //// EVENT HANDLERS /////////////////////////////////////////////////////////

function BCC_OnEvent(self, event, ...)
	--[[
	performs actions based on specific events.
	--]]

	if(event == "UNIT_SPELLCAST_SUCCEEDED") then
		BCC_OnEvent_SpellCast(...)
	elseif(event == "PLAYER_LOGIN") then
		BCC_OnEvent_Init(...)
	end
end

function BCC_OnUpdate(self, time)
	--[[
	handles when the client tells our addon it can update itself. probably
	happens between each frame. used as a rough timer.
	--]]

	BCC_IdleTimer_OnUpdate(time)
end

function BCC_OnEvent_Init()
	BCC_BuildConfig()
	BCC_IdleTimer_Reset()
end

function BCC_OnEvent_SpellCast(...)
	--[[
	handles when spells are cast.
	we only care about spells the player has cast.
	also resets the idle timer.
	--]]

	local unit, spell = ...
	if(unit ~= "player") then return end

	if(BCCDB.ShowSpellCasts == true) then
		print("BCC: " .. spell)
	end

	BCC_IdleTimer_Zero()
	BCC_SpellMessage_OnSpellCast(spell)
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

local Frame = CreateFrame("FRAME","BCCFrame")
Frame:RegisterEvent("PLAYER_LOGIN")
Frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
Frame:SetScript("OnEvent",BCC_OnEvent)
Frame:SetScript("OnUpdate",BCC_OnUpdate)

