package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.property.HumanStat;
   
   public class Bilbo extends SpecialVisitor
   {
      
      static const SEARCH_DESTINATION = [["Gentleman\'s Agreement..\nHuh, they sell agreemen templates."],["I wonder if I can go back home."],["Pretty..\nI can use my ring.."],["My plates and bottles is broken."],["Ah it\'s good stuff for me."],["Ah it\'s good stuff for me."],["My letter opener must be sharpened."],["Pretty..Is that Arkinstone?"],["I need to trim my foot hair.\nIt\'s tickles me."],["I\'m never use these thing.\nWell just trying on it\'s ok."],["I need a blanket."],["They\'re too big and heavy.\nMy letter opener fit me more."],["Bird lover spell crest.\n made by Rodagast.Woa"],["I wonder if smaug is here.."],["Hey, little."],["I need new plumbing.\nCan you go to the Shire?"],["Is there any Pony sized wagon?"],["I\'m very hungry..."],["looks tasty and fresh"],["I\'m hungry.."],["I\'m hungry.\nI want to make this when i\'m home."],["I\'m hungry.."],["I\'m thirsty.."],["I\'m hungry.."],["This a good place\nif i go with those dwarves."],["I\'m so sleepy."],["how long I didn\'t take bath.."],["I need to massage my big hairy feet"],["This ball too big for me."],["Nice.\nI\'m feelin like dancin"],["Me? No! No No No!."]];
       
      
      public function Bilbo()
      {
         super();
         _model = "Bilbo";
         _codeName = "BILBO";
         _extraDescription = "Nothing special with him except he moving very fast.";
      }
      
      override function initPurse() : void
      {
         _initialPurse = 700;
         _purse = _initialPurse;
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.speed = 240;
         _stat.stamina = 35;
         _stat.sight = 55;
         _stat.hygine = 45;
         _stat.entertain = 65;
         _stat.characterName = "Balbo Begins";
         restRoomIncrementChance = 3 * ((100 - _stat.hygine) / 100) + 4;
      }
      
      override function setFavoriteList() : void
      {
         var _loc1_:* = new Array();
         _loc1_.push("Soup");
         _loc1_.push("Soup");
         _loc1_.push("Soup");
         _loc1_.push("Jewellry");
         _loc1_.push("Jewellry");
         _loc1_.push("Jewellry");
         _loc1_.push("Gem Shop");
         _loc1_.push("Gem Shop");
         _loc1_.push("Eatery");
         _loc1_.push("(none)");
         sortFavorite(_loc1_);
      }
      
      override public function initData() : void
      {
         this.setFavoriteList();
         _gender = 1;
         this.generateConversation();
      }
      
      override function generateConversation() : void
      {
         var _loc2_:* = undefined;
         super.generateConversation();
         _singleConversation.toilet = ["I must hurry."];
         _singleConversation.noToilet[0] = ["No No No...\nAgain?"];
         _singleConversation.noToilet[1] = ["No No No...\nAgain?"];
         _singleConversation.noToilet[2] = ["No No No...\nAgain?"];
         _singleConversation.noToilet[3] = ["No No No...\nAgain?"];
         _singleConversation.noTradingPost = ["What is in my pocket? Nothing?"];
         _singleConversation.tradingPost = ["I\'ll trade this Arkinstone for gold.","What is in my pocket?"];
         _singleConversation.goingHome = new Array();
         _singleConversation.goingHome[0] = ["I\'m already late."];
         _singleConversation.goingHome[1] = ["I\'m already late."];
         _singleConversation.goingHome[2] = ["I\'m already late."];
         _singleConversation.goingHome[3] = ["I\'m already late."];
         _singleConversation.booth = new Object();
         var _loc1_:* = 0;
         while(_loc1_ < BuildingData.BUILDING_LIST.length)
         {
            if(_loc1_ in SEARCH_DESTINATION)
            {
               _loc2_ = BuildingData.BUILDING_LIST[_loc1_];
               _singleConversation.booth[_loc2_] = SEARCH_DESTINATION[_loc1_].concat();
            }
            _loc1_++;
         }
         _singleConversation.noDestination = ["I\'m going on an adventure!"];
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
                     hourCome = Math.floor(Math.random() * 5) + 12;
                     if(hourCome == 12)
                     {
                        minuteCome = 30 + Math.floor(Math.random() * 30);
                     }
                     else
                     {
                        minuteCome = Math.floor(Math.random() * 60);
                     }
                  }
               }
            }
         }
         super.updateInHome(param1);
      }
   }
}
