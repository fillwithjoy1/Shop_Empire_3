package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.AudioEvent;
   import Instance.events.GameEvent;
   import Instance.property.HumanStat;
   
   public class Leonidas extends SpecialVisitor
   {
      
      static const SEARCH_DESTINATION = [["How to train your kids in Spartan way.\nGood book!"],["The oracle said our\npainted abs look fake!"],["For my queen!"],["For my queen!"],["I need to forge weapon for 300 people!"],["This is sparkling!"],["I need to trim my beard!"],["I need to come back with my shield!"],["I need 300 leather panty!"],["I need spear and sword for 300 soldiers!"],["Spartan didn\'t use magic!\nBut, those bat wing looks delicious.."],["I slay one of these when I was a kid!"],["Tasty things for spartaaans!"],["Bed for rest in Thermopylae battle..\nThat is madness!"],["We walk!\n But if it can seat 300 soldiers\nit\'s ok."],["This is tasty!"],["This is tasty!"],["This is tasty!"],["This is tasty!"],["Tonight, I dine in hell!!"],["Well, give me something to drink!"],["This is tasty!"],["300 vanilla Blended!"],["I\'m SLeepy!"],["Need bath in 300 Celcius dgree."],["Kneeling will be hard for me.\nLet\'s massage it for a while."],["Spartans! Prepare for glory!\nIn the alley.."],["This is nice!"],["Spartans never retreat! Spartans never surrender!"]];
       
      
      public function Leonidas()
      {
         super();
         _model = "Leonidas";
         _codeName = "LEONIDAS";
         _extraDescription = "He still shopping even the booth is broken.";
         maxMoodCome = 40;
      }
      
      override function initPurse() : void
      {
         _initialPurse = 800;
         _purse = _initialPurse;
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.speed = 55;
         _stat.stamina = 100;
         _stat.sight = 65;
         _stat.hygine = 40;
         _stat.entertain = 20;
         _stat.characterName = "Sparta";
         restRoomIncrementChance = 3 * ((100 - _stat.hygine) / 100) + 4;
      }
      
      override function setFavoriteList() : void
      {
         var _loc1_:* = new Array();
         _loc1_.push("Armory");
         _loc1_.push("Armory");
         _loc1_.push("Armory");
         _loc1_.push("Weaponry");
         _loc1_.push("Weaponry");
         _loc1_.push("Weaponry");
         _loc1_.push("BBQ");
         _loc1_.push("BBQ");
         _loc1_.push("Beastiary");
         _loc1_.push("(none)");
         sortFavorite(_loc1_);
      }
      
      override function showNotificationAppearance() : void
      {
         _world.dispatchEvent(new GameEvent(GameEvent.SHOW_MUTE_NOTIFICATION,characterName + " is coming"));
         _world.dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Sparta));
      }
      
      override function generateConversation() : void
      {
         var _loc2_:* = undefined;
         super.generateConversation();
         _singleConversation.toilet = ["I have to wash my hand\nfrom persians blood."];
         _singleConversation.noToilet = new Array();
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            _singleConversation.noToilet.push(["I have to wash my hand\nfrom persians blood."]);
            _loc1_++;
         }
         _singleConversation.noTradingPost = ["No Money. No Loot."];
         _singleConversation.tradingPost = ["This is Spartan gold!\n..trade it!"];
         _singleConversation.goingHome[0] = ["Today Sparta angry"];
         _singleConversation.goingHome[1] = ["Today Sparta unhappy"];
         _singleConversation.goingHome[2] = ["Today Sparta happy"];
         _singleConversation.goingHome[3] = ["Back to fight those persians."];
         _singleConversation.booth = new Object();
         _loc1_ = 0;
         while(_loc1_ < BuildingData.BUILDING_LIST.length)
         {
            _loc2_ = BuildingData.BUILDING_LIST[_loc1_];
            _singleConversation.booth[_loc2_] = [""];
            _loc1_++;
         }
         _singleConversation.noDestination = ["Today we shop in hell!!","This is SPARTA!!"];
      }
      
      override public function initData() : void
      {
         this.setFavoriteList();
         _gender = 1;
         this.generateConversation();
      }
      
      override function updateInHome(param1:GameEvent) : void
      {
         var _loc2_:* = undefined;
         if(_inHome)
         {
            if(favoriteUnlock(70))
            {
               _loc2_ = param1.tag;
               if(_loc2_.hour == 10 && _loc2_.minute == 0)
               {
                  if(moodCheck())
                  {
                     hourCome = Math.floor(Math.random() * 6) + 12;
                     minuteCome = Math.floor(Math.random() * 60);
                  }
               }
            }
         }
         super.updateInHome(param1);
      }
   }
}
