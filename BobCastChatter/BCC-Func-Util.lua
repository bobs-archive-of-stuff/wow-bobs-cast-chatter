--[[
function BCC_Print(...)
function BCC_CPrint(...)

function BCC_BuildConfig(void)

function BCC_SpellMessage_OnSpellCast(spell)
function BCC_SpellMessage_Add(spell, chance, type, text)
function BCC_SpellMessage_Delete(spell, offset)
function BCC_SpellMessage_ParseText(msgobj)
function BCC_SpellMessage_Select(void)
function BCC_SpellMessage_Try(msgobj)
function BCC_SpellMessage_Send(msgobj)
--]]

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_Print(...)
	print("BCC: ", ...)
end

function BCC_CPrint(msg,r,g,b)
	DEFAULT_CHAT_FRAME:AddMessage('BCC> '..msg,r,g,b);
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_BuildConfig()
	--[[
	handle building the BCCDB options table. this is done as a builder so that
	if we ever need to migrate options due to a structure change we can handle
	that and preserve as much of the previous settings as possible.

	note this happens after saved variables are loaded, so it needs to test
	for each thing that may matter.
	--]]

	if(type(BCCDB) ~= "table") then BCCDB = {} end
	if(BCCDB.LowBound == nil) then BCCDB.LowBound = 1 end
	if(BCCDB.UpperBound == nil) then BCCDB.UpperBound = 100 end
	if(BCCDB.ShowSpellCasts == nil) then BCCDB.ShowSpellCasts = false end
	if(BCCDB.Messages == nil) then BCCDB.Messages = {} end
	if(type(BCCDB.Messages) ~= "table") then BCCDB.Messages = {} end

	if(BCCDB.IdleProc == nil) then BCCDB.IdleProc = 2 end
	if(BCCDB.IdleWorldMult == nil) then BCCDB.IdleWorldMult = 3 end
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_SpellMessage_OnSpellCast(spell)
	local msg = BCC_SpellMessage_Select(spell)
	if(msg == nil) then return end

	if(BCC_SpellMessage_ShouldTry(msg)) then
		BCC_SpellMessage_Send(msg)
	end
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_SpellMessage_Add(spell,chance,mtype,text)
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

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_SpellMessage_Delete(spell,offset)
	offset = tonumber(offset)

	if(BCCDB.Messages[spell] == nil) then return end
	if(BCCDB.Messages[spell][offset] == nil) then return end

	BCC_Print("deleting",spell,offset)
	table.remove(BCCDB.Messages[spell],offset)
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_SpellMessage_ParseText(source)
	-- expects: spell message object
	-- returns: string

	-- parse any tokens in the given message and return the translated string
	-- for use by the printer.

	local input = source.Text

	if(UnitName("target") ~= nil) then
		input = input:gsub("@target",UnitName("target"))
	end

	if(UnitName("pet") ~= nil) then
		input = input:gsub("@pet",UnitName("pet"))
	end

	input = input:gsub("@player",UnitName("player"))
	input = input:gsub("@spell",source.Spell)

	return input
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_SpellMessage_Select(spell)
	-- returns: spell message object | nil

	-- if spell not found in message book.
	if(BCCDB.Messages[spell] == nil) then return end

	-- if no messages defined in spell.
	local size = table.maxn(BCCDB.Messages[spell])
	if(size == 0) then return end

	-- return message
	return BCCDB.Messages[spell][math.random(1,size)]
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_SpellMessage_ShouldTry(msg)
	-- expects: spell message object
	-- returns: boolean

	--[[
	looking at the specified message, decide if we should send it to the chat
	based on the chance it should occur and the over all structure of the
	message.
	--]]

	-- if the message is somehow broken, skip it.
	if(msg.Text == nil) then
		return false
	end

	-- should RNG even let us proc a message?
	local value = math.random(BCCDB.LowBound,BCCDB.UpperBound);
	if(tonumber(msg.Chance) < value) then
		return false
	end

	-- if the message contained a pet reference but there is no pet, then skip
	-- this message all together because it would look dumb.
	if(msg.Text:find("@pet") and (not UnitName("pet"))) then
		return false
	end

	-- same for if the message has a target token but there is no current
	-- target to target.
	if(msg.Text:find("@target") and (not UnitName("target"))) then
		return false
	end

	-- else go ahead and send it.
	return true
end

-- /////////////////////////////////////////////////////////////////////////////
-- /////////////////////////////////////////////////////////////////////////////

function BCC_SpellMessage_Send(source)
	-- expects: spell message object.

	SendChatMessage(
		BCC_SpellMessage_ParseText(source),
		source.Type,
		PlayerLang
	)
end
