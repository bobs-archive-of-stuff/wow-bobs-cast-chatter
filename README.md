Bob's Cast Chatter
=====================

A WoW addon that can randomly emote messages when casting spells to flavour shit up.

**Viva Moon Guard!**

![BCC](http://www.opsat.net/derpdex/wow/bcc/bcc.png)

The premise behind this you can define a list of custom emotes per spell, even multiple per spell. Each time a spell is cast one of the messages you define will be selected at random. Then, the chance that message will actually happen (which is a value you define when creating the message) will decide the message will really happen.

Type this command to see all the commands this addon has.

	/bcc

Typing a command like

	/bcc add

Will show you more information on how it works.

Example
---------------------

	/bcc add "Auto Shot" 100 emote "lets loose another arrow."

Now every time this hunter shoots an arrow, it will emote "Huntard lets loose another arrow." Don't actually do this though, that is annoying as hell. But if I see this in LFR I will laugh so hard, and buy you a beer when we get back to Orgrimmar.

Pick your cool spells, and use low chances:

	/bcc add "Explosive Shot" 2 emote "lets loose a firey arrow."
	/bcc add "Explosive Shot" 2 emote "lets loose a flaming arrow."

With this setup there is roughly only a 2% chance that you will emote anything at all when mashing Explosive Shot.

Idle Timer
---------------------

There is an idle timer that will allow your character to auto emote things
depending on how long it has been since you cast a spell. In dungeons/raids this defaults to every 2 minutes (give or take some RNG) to let people know just how bored you are with them wasting your time in LFR. This value gets multiplied while in the open world to be less spammy while out and about.

To define the idle emotes, you do the same thing as a spell emote, just with
the spell name of "idle timer"

	/bcc add "idle timer" 100 emote "bounces up and down."
	/bcc idle 4
	/bcc idleworldmult 3

This will make you bounce up and down every four minutes in instances, and every 12 minutes while in the open world.


Find Me In Game
---------------------

* Thundersteak-MoonGuard
* Dubsteak-MoonGuard
* Dethsteak-MoonGuard
* Treesteak-MoonGuard
* Rawrsteak-MoonGuard
* Totemsteak-MoonGuard
* Portabobby-MoonGuard
