--[[
global table BCC_IdleTimer
function BCC_IdleTimer_OnUpdate(time)
function BCC_IdleTimer_Reset(void)
function BCC_IdleTimer_Zero(void)
--]]

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

BCC_IdleTimer = {
	-- global variable for tracking player idle time.
	-- saved: no

	CurTime = 0,
	NextTime = 0
}

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_IdleTimer_OnUpdate(time)
	BCC_IdleTimer.CurTime = BCC_IdleTimer.CurTime + time

	if(BCC_IdleTimer.CurTime > BCC_IdleTimer.NextTime) then
		BCC_SpellMessage_OnSpellCast("idle timer")
		BCC_IdleTimer_Reset()
	end
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_IdleTimer_Reset()
	local mult

	-- be more spammy in an instance than in the open world to let people know
	-- that you are bored when they waste your time in instances.
	if(IsInInstance()) then mult = 1
	else mult = BCCDB.IdleWorldMult end

	BCC_IdleTimer.CurTime = 0
	BCC_IdleTimer.NextTime = math.random(
		(((BCCDB.IdleProc * mult)) * 60),
		(((BCCDB.IdleProc * mult) + 1) * 60)
	)
end

function BCC_IdleTimer_Zero()
	BCC_IdleTimer.CurTime = 0
end
