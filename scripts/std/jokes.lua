--[[

  The jokes module introduces the following:
  -- sends random jokes to the client 
  
  TODO: add more jokes

]]--

local funFacts = {
   "[\f0PASTA-TIP\f7] Eat your carbs!"
  ,"[\f0PASTA-TIP\f7] Carbohydrates stimulate serotonine production: eat pasta and be happy!"
  ,"[\f0PASTA-TIP\f7] Feeling hungry? Get yourself some awesome pasta!"
  ,"[\f0PASTA-TIP\f7] Hey, is that a pasta cup? I'm eating that, see you later!"
  ,"[\f0PASTA-TIP\f7] I'm not saying pasta is good. Pasta is BEST."
  ,"[\f0PASTA-TIP\f7] Did you hear about the italian chef that died? They pasta way."
  ,"[\f0PASTA-TIP\f7] Where did the spaghetti go to dance? To the meat-ball."
  ,"[\f0PASTA-TIP\f7] If you ate pasta and antipasta at the same time would you still be hungry?"
  ,"[\f0PASTA-TIP\f7] The trouble with eating pasta is that five or six days later you're hungry again!"
  ,"[\f0PASTA-TIP\f7] Entered what I ate today into my new fitness app and it just sent an ambulance to my house."
  ,"[\f0PASTA-TIP\f7] Any salad can be a Caesar salad if you stab it enough."
  ,"[\f0PASTA-TIP\f7] I am on a seafood diet. Every time I see food, I eat it."
  ,"[\f0PASTA-TIP\f7] Pastaland runs on Tesseract, too! Go download the latest nightly build!"
  ,"[\f0PASTA-TIP\f7] Go check Pastaland on Tesseract, you never have enough pasta!"
  ,"[\f0PASTA-TIP\f7] I have pastad my italian cooking class! (FritzFokker)"  
  ,"[\f0PASTA-TIP\f7] The best condiment for pasta is more pasta! (Fritz_Fokker)"
  ,"[\f0PASTA-TIP\f7] What do you call an Italian hooker? A Pasta-tute. (Fritz_Fokker)"
  ,"[\f0PASTA-TIP\f7] I don't always watch movies, but when I do, it's a spaghetti western. (Fritz_Fokker)"
  ,"[\f0PASTA-TIP\f7] What do you call a fake noodle? An impasta!! (Bourbon)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] People say I talk too much... well I have something to say about that. (a_theory)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] I'd kill for a Nobel Peace Prize."  
  ,"[\f5FOOD-FOR-THOUGHT\f7] There is no 'me' in team. No, wait, yes there is!"
  ,"[\f5FOOD-FOR-THOUGHT\f7] I think it's wrong that only one company makes the game Monopoly."
  ,"[\f5FOOD-FOR-THOUGHT\f7] Have you ever tried to eat a clock? It's really time consuming."
  ,"[\f5FOOD-FOR-THOUGHT\f7] What kind of bees produce money? Showbiz!  (IdonRedcat)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] Birthdays are good for your health, studies show that people who have more birthdays live longer. (RedWolfe)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] If you try to fail, and succeed, which have you done?  (RedWolfe)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] I didn't know why the ball was growing bigger... then it hit me. (a_theory)" 
  ,"[\f5FOOD-FOR-THOUGHT\f7] Confucius say: balloon factory will go out of business if it can't keep up with inflation. (FritzFokker)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] Which kind of bees produce horrible jokes? Newbies. (Star)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] Toilet paper and copy paper are not interchangeable. Just ask my proctologist. (FritzFokker)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] I just love pressing F5. It is so refreshing. (FritzFokker)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] What is the difference between snowmen and snowwomen? Snowballs (FritzFokker)!"
  ,"[\f5FOOD-FOR-THOUGHT\f7] If 4 out of 5 people SUFFER from diarrhea, does that mean that one enjoys it? (FritzFokker)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] Math illiteracy affects 8 out of every 5 people (Pointblank)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] What do Cats eat in the Summer? Micecream (Bourbon)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] The taxi driver quit his job. He was tired of people talking behind his back (FritzFokker)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] What do you call an Øwl who can perform magic? Hoodini! (Øwl)"
  ,"[\f5FOOD-FOR-THOUGHT\f7] Would you like to hear a construction joke? Well... I'm still working on it... (Øwl)"
  ,"[\f4MOTIVATION\f7] Wow, I did it, I finallyfixedthismotherfuckingspacebar"
  ,"[\f4MOTIVATION\f7] Did you know that 5 of every 6 people enjoy Russian roulette? (Ao6 Scorpio)"
  ,"[\f4NERD\f7] Hmmm..... If you listen to a UNIX shell, can you hear the C? (FritzFokker)"
  ,"[\f3PRO-TIP\f7] Badass players use /texreduce 12"
  ,"[\f3PRO-TIP\f7] Badass players use /forceplayermodels 1"
  ,"[\f3PRO-TIP\f7] Badass players use /fullbrightmodels 200"
  ,"[\f3PRO-TIP\f7] Smart players use /showclientnum 1"
  ,"[\f3PRO-TIP\f7] So I ran out of toilet paper today... Goodbye socks! (RedWolfe)"
  ,"[\f6INFO\f7] Send your feedback at \f6www.pastaland.ovh\f7 but only if it's good."
  ,"[\f6INFO\f7] Confirm your celibacy at \f6www.pastaland.ovh"
  ,"[\f6INFO\f7] I don't always spam a forum, but when I do, it's on \f6www.pastaland.ovh\f7."
  ,"[\f6INFO\f7] ... bla bla bla bla bla \f6www.pastaland.ovh\f7 bla bla bla bla bla... "
  ,"[\f6INFO\f7] Ask for new features at \f6www.pastaland.ovh\f7. We do anything for money. Well, almost anything."
  ,"[\f6INFO\f7] Come to \f6www.pastaland.ovh\f7. We have cookies!"
  ,"[\f6INFO\f7] If you are a real Sauerbraten aficionado, go visit \f6www.sauerworld.org"
  ,"[\f6INFO\f7] Don't forget to give a try to \f6Tesseract\f7, the Sauerbraten evolution!"
  ,"[\f6INFO\f7] Did you know that Pastaland runs on \f6Tessearct\f7, too?"
  ,"[\f6INFO\f7] Did you know that you can voice chat with your team using \f6Discord\f7?"
  ,"[\f6INFO\f7] Go check out Pastaland voice and text chat on \f6Discord\f7. Now. I mean it."
  ,"[\f6INFO\f7] Brand new voice and text chat for Pastaland on \f6Discord\f7. See instructions on Pastaland.ovh."
  ,"[\f6INFO\f7] Did you know that Pastaland.ovh forum has a new section on \f6Tesseract\f7??"
  ,"[\f6INFO\f7] Fancy some new graphics? Go try the latest \f6Tesseract\f7 nightly build, we have Pastaland there, too!"
  ,"[\f6INFO\f7] Make your pc happy, try the latest \f6Tesseract\f7. We have a Pastaland server there, too!"
}

local function randomFact()
    --math.randomseed(os.time())
    return funFacts[math.random(#funFacts)]
end

spaghetti.later(21000, function()
  return server.sendservmsg(randomFact());
end, true)
