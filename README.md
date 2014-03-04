Bob's Cast Chatter
=====================

A WoW addon that can randomly emote messages when casting spells to flavour shit up.

**Viva Moon Guard!**

The premise behind this you can define a list of custom emotes per spell, even multiple per spell. Each time a spell is cast one of the messages you define will be selected at random. Then, the chance that message will actually happen (which is a value you define when creating the message) will decide the message will really happen.

	/bcc add "<spell>" chance type "message"

Example
---------------------

	/bcc add "Auto Shot" 100 emote "lets loose another arrow."

Now every time this hunter shoots an arrow, it will emote "Huntard lets loose another arrow." Don't actually do this though, that is annoying as hell. But if I see this in LFR I will laugh so hard, and buy you a beer when we get back to Orgrimmar.

Pick your cool spells, and use low chances:

	/bcc add "Explosive Shot" 2 emote "lets loose a firey arrow."
	/bcc add "Explosive Shot" 2 emote "lets loose a flaming arrow."

With this setup there is roughly only a 2% chance that you will emote anything at all when mashing Explosive Shot - unlike this screenshot where I used 100% again to get the screenshot in before General chat spammed my screen.

![Huntarded Huntard is Huntarded](http://www.opsat.net/derpdex/wow/bcc/huntard-demo.png)

Idle Timer
---------------------

By default there is an idle timer which is reset every time you cast a spell, this timer procs at a random time within a 3 minute window around the value specified, which is defaulted at 5 minutes. The idle timer will perform the same chance calculations as the spell messages, and to define these you use "idle timer" as the spell name.

	/bcc add "idle timer" 100 emote "bounces up and down."
	/bcc idle 10


Find Me In Game
---------------------

* Thundersteak-MoonGuard
* Dubsteak-MoonGuard
* Dethsteak-MoonGuard
* Treesteak-MoonGuard
* Rawrsteak-MoonGuard
* Totemsteak-MoonGuard
* Portabobby-MoonGuard
