

BCCDB = {}
local EventTable = { }

-- ////////////////////////////////////////////////////////////////////////// --

function BCC_Print(...)
	print("BCC: ", ...)
end

function BCC_ShouldWeDoIt(thresh)
	local value = math.random(BCCDB.LowBound,BCCDB.UpperBound)

	if(tonumber(thresh) >= value) then return true
	else return false end
end

function BCC_GetMessageParsed(source)
	local input = source.Text

	input = input:gsub("@target",UnitName("target"))
	input = input:gsub("@player",UnitName("player"))
	input = input:gsub("@spell",source.Spell)

	return input
end

function BCC_SendChatMessage(source)
	SendChatMessage(
		BCC_GetMessageParsed(source),
		source.Type,
		GetDefaultLanguage("player")
	)
end

function BCC_AddMessage(spell,chance,mtype,text)
	if(type(BCCDB.Messages[spell]) ~= "table") then
		BCCDB.Messages[spell] = {}
	end

	table.insert(BCCDB.Messages[spell],{
		Spell = spell,
		Chance = chance,
		Type = mtype:upper(),
		Text = text
	})
end

function BCC_DelMessage(spell,offset)
	BCC_Print("deleting",spell,offset)
	table.remove(BCCDB.Messages[spell],tonumber(offset))
end

function BCC_TrySpellChatter(spell)
	if(BCCDB.Messages[spell] == nil) then return end

	local size = table.maxn(BCCDB.Messages[spell])
	if(size == 0) then return end

	local msg = BCCDB.Messages[spell][math.random(1,size)]

	if(BCC_ShouldWeDoIt(msg.Chance)) then
		BCC_SendChatMessage(msg)
	end
end

-- ////////////////////////////////////////////////////////////////////////// --

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
	else
		BCC_Print("/bcc casts [on|off]")
		BCC_Print("Display what spells are successfully casting.")
		BCC_Print("")
		BCC_Print("/bcc add \"<spell name>\" <chance> <type> \"<message>\" ")
		BCC_Print("Add a spell to the list. Quotes required.")
		BCC_Print("Types: say, yell, emote, party, instance_chat")
		BCC_Print("")
		BCC_Print("/bcc del \"<spell name>\" <num>")
		BCC_Print("Delete a message from a spell in the list. Quotes required.")
		BCC_Print("")
		BCC_Print("/bcc list")
		BCC_Print("See all the spells that have messages added.")
		BCC_Print("")
		BCC_Print("/bcc range <num>")
		BCC_Print("Set the chance range from 1 to the specified number. Default 100. Increasing it will lower chance of messages and lowering it will increase the chance.")
	end
end

function BCC_OnSlashCommand_Casts(arg)
	if(arg == "on") then
		BCC_Print("showing spell casts")
		BCCDB.ShowSpellCasts = true
	else
		BCC_Print("hiding spell casts")
		BCCDB.ShowSpellCasts = false
	end
end

function BCC_OnSlashCommand_Add(arg)
	local spell, chance, mtype, message = arg:match("^\"(.+)\" (%d+) (%w+) \"(.+)\"$")
	if(spell == nil) then return end
	if(chance == nil) then return end
	if(mtype == nil) then return end
	if(message == nil) then return end

	BCC_Print("Adding " .. spell .. " (" .. chance .. "), " .. mtype .. ": " .. message)

	BCC_AddMessage(spell,chance,mtype:upper(),message)
end

function BCC_OnSlashCommand_Del(arg)
	local spell,offset = arg:match("^\"(.+)\" (%d+)$")
	BCC_DelMessage(spell,offset)
end

function BCC_OnSlashCommand_List()
	BCC_Print("Listing all current spell messages:")
	for spell,obj in pairs(BCCDB.Messages) do
		for key,msg in pairs(obj) do
			BCC_Print(msg.Spell.."["..key.."] "..msg.Type.."["..msg.Chance.."] "..msg.Text)
		end
	end
end

function BCC_OnSlashCommand_Range(arg)
	BCC_Print("Setting new upper range bound to " .. arg)
	BCCDB.UpperBound = tonumber(arg)
end

-- ////////////////////////////////////////////////////////////////////////// --

function BCC_OnInit()
	if(type(BCCDB) ~= "table") then BCCDB = {} end

	if(BCCDB.LowBound == nil) then BCCDB.LowBound = 1 end
	if(BCCDB.UpperBound == nil) then BCCDB.UpperBound = 100 end
	if(BCCDB.ShowSpellCasts == nil) then BCCDB.ShowSpellCasts = false end
	if(BCCDB.Messages == nil) then BCCDB.Messages = {} end
	if(type(BCCDB.Messages) ~= "table") then BCCDB.Messages = {} end

	BCCDB.Class = nil;
end

function BCC_OnEvent(self, event, ...)
	local Callback = EventTable[event]
	if(Callback == nil) then return end

	Callback(...)
end

function BCC_OnAddonLoaded()

end

function BCC_OnSpellCast(...)
	local unit, spell = ...
	if(unit ~= "player") then return end

	if(BCCDB.ShowSpellCasts == true) then
		print("BCC: " .. spell)
	end

	BCC_TrySpellChatter(spell)
end

-- ////////////////////////////////////////////////////////////////////////// --

EventTable["PLAYER_LOGIN"] = BCC_OnInit
EventTable["ADDON_LOADED"] = BCC_OnAddonLoaded
EventTable["UNIT_SPELLCAST_SUCCEEDED"] = BCC_OnSpellCast

SLASH_BCC1 = "/bcc"
SlashCmdList["BCC"] = BCC_OnSlashCommand

-- ////////////////////////////////////////////////////////////////////////// --

local Frame = CreateFrame("FRAME","BCCFrame")
Frame:RegisterEvent("PLAYER_LOGIN")
Frame:RegisterEvent("ADDON_LOADED")
Frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
Frame:SetScript("OnEvent",BCC_OnEvent)

