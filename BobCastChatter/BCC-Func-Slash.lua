--[[
function BCC_OnSlashCommand(msg,box)
function BCC_OnSlashCommand_Casts(arg)
function BCC_OnSlashCommand_Add(arg)
function BCC_OnSlashCommand_Del(arg)
function BCC_OnSlashCommand_List(void)
function BCC_OnSlashCommand_Range(arg)
function BCC_OnSlashCommand_Idle(arg)
function BCC_OnSlashCommand_IdleWorldMult(arg)
--]]

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_OnSlashCommand(msg,box)
	local command, arg = msg:match("^(%S*)%s*(.-)$")

	if(command == "casts") then
		BCC_OnSlashCommand_Casts(arg)
	elseif(command == "add") then
		BCC_OnSlashCommand_Add(arg)
	elseif(command == "del") then
		BCC_OnSlashCommand_Del(arg)
	elseif(command == "list") then
		BCC_OnSlashCommand_List()
	elseif(command == "range") then
		BCC_OnSlashCommand_Range(arg)
	elseif(command == "idle") then
		BCC_OnSlashCommand_Idle(arg)
	elseif(command == "idleworldmult") then
		BCC_OnSlashCommand_IdleWorldMult(arg)
	elseif(command == "idledebug") then
		BCC_Print(BCC_IdleTimer.CurTime,BCC_IdleTimer.NextTime)
	else
		BCC_CPrint(
			"Bob's Cast Chatter.\n"..
			"Type these commands for more verbose information about how to "..
			"configure this addon.",
			1.0, 0.7, 0.0
		)

		BCC_CPrint("/bcc casts",1.0,0.5,0.0)
		BCC_CPrint("/bcc add",1.0,0.5,0.0)
		BCC_CPrint("/bcc del",1.0, 0.5, 0.0)
		BCC_CPrint("/bcc list",1.0,0.5,0.0)
		BCC_CPrint("/bcc range",1.0,0.5,0.0)
		BCC_CPrint("/bcc idle",1.0,0.5,0.0)
		BCC_CPrint("/bcc idleworldmult",1.0,0.5,0.0)
	end
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_OnSlashCommand_Casts(arg)
	if(arg == "") then
		BCC_CPrint(
			"USAGE: /bcc casts [on|off]\n"..
			"Display what spells are successfully casting. Useful for seeing "..
			"how often something is procing to decide if you want to bind an "..
			"emote to it.\n",
			1.0, 0.5, 0.0
		)
		return
	end

	if(arg == "on") then
		BCC_Print("showing spell casts")
		BCCDB.ShowSpellCasts = true
	else
		BCC_Print("hiding spell casts")
		BCCDB.ShowSpellCasts = false
	end
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_OnSlashCommand_Add(arg)
	local spell, chance, mtype, message = arg:match("^\"(.+)\" (%d+) (%w+) \"(.+)\"$")

	if(spell == nil) then
		BCC_CPrint(
			"USAGE: /bcc add \"<spell>\" <chance> <type> \"<message>\"\n"..
			"Add an emote to a spell. Multiple emotes can be added to a "..
			"spell and one will be selected at random to use. Quotes are "..
			"required. Spells are case sensitive. Chance should be a number "..
			"between 1 and 100. Type can be emote, party, instance_chat, "..
			"say, or yell.\n",
			1.0, 0.5, 0.0
		)
		return
	end

	BCC_Print("Adding " .. spell .. " (" .. chance .. "), " .. mtype .. ": " .. message)

	BCC_SpellMessage_Add(spell,chance,mtype:upper(),message)
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_OnSlashCommand_Del(arg)
	local spell,offset = arg:match("^\"(.+)\" (%d+)$")

	if(spell == nil) then
		BCC_CPrint(
			"USAGE: /bcc del \"<spell name>\" <num>\n"..
			"Delete an emote from a spell. Quotes are required. The number "..
			"can be found using the list command.\n",
			1.0, 0.5, 0.0
		)
		return
	end

	BCC_SpellMessage_Delete(spell,offset)
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_OnSlashCommand_List()
	BCC_CPrint(
		"Listing all current spell messages:",
		1.0,0.5,0.0
	)

	for spell,obj in pairs(BCCDB.Messages) do
		for key,msg in pairs(obj) do
			BCC_CPrint(
				msg.Spell.."["..key.."] "..
				msg.Type.."["..msg.Chance.."] "..
				msg.Text,
				1.0, 0.6, 0.9
			)
		end
	end

	BCC_CPrint(
		"End of spell messages.",
		1.0,0.5,0.0
	)
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_OnSlashCommand_Range(arg)
	if(arg == "") then
		BCC_CPrint(
			"USAGE: /bcc range <num> (currently: ".. BCCDB.UpperBound ..")\n"..
			"Set the upper bound for RNG. Default 100. This is used in the "..
			"with the Chance value of an emote to determine if it should "..
			"have a chance to happen. Making this larger without adjusting "..
			"your emotes will lower the chance they will happen, potentially "..
			"making them less spammy if this an issue for you.\n",
			1.0, 0.5, 0.0
		)
		return
	end

	BCC_CPrint(
		"Setting upper range bounds to ".. arg,
		1.0, 0.5, 0.0
	)

	BCCDB.UpperBound = tonumber(arg)
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_OnSlashCommand_Idle(arg)
	if(arg == "") then
		BCC_CPrint(
			"USAGE: /bcc idle <num> (currently: ".. BCCDB.IdleProc ..")\n"..
			"Set the number in minutes to how often the idle timer should "..
			"proc. This will be modified by RNG to make it a little less "..
			"clockwork, and a little more organic.\n",
			1.0, 0.5, 0.0
		)
		return
	end

	BCC_CPrint(
		"Setting new idle proc value to ".. arg,
		1.0, 0.5, 0.0
	)

	BCCDB.IdleProc = tonumber(arg)
	BCC_IdleTimer_Reset()
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_OnSlashCommand_IdleWorldMult(arg)
	if(arg == "") then
		BCC_CPrint(
			"USAGE: /bcc idleworldmult <num> (currently: ".. BCCDB.IdleWorldMult ..")\n"..
			"Set a multiplier for open world idle proc (vs in raids). "..
			"I like to be more annoying in raid groups that are wasting my "..
			"time than in the open world. Setting idle to 2 will cause idle "..
			"procs to happen every two minutes, and setting idleworldmult to "..
			"3 will cause it to proc every 6 minutes while not in an "..
			"instance.\n",
			1.0, 0.5, 0.0
		)
		return
	end

	BCC_CPrint(
		"Setting new idle world multiplier to ".. arg,
		1.0, 0.5, 0.5
	)

	BCCDB.IdleWorldMult = tonumber(arg)
	BCC_IdleTimer_Reset()
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

SLASH_BCC1 = "/bcc"
SlashCmdList["BCC"] = BCC_OnSlashCommand
