package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.constant.ConversationList;
   import Instance.events.GameEvent;
   import Instance.property.HumanStat;
   
   public class DaVinci extends SpecialVisitor
   {
      
      static const SEARCH_DESTINATION = [["I want to read Davinci code."],["I wonder what happen 500,000 years later?"],["beautifull objects"],["I need golden ratio based pot shape"],["Ah, Salad juice."],["I like healthy drink"],["I need material for\nGravity hidden blade project."],["pretty"],["I need to trim my beard"],["Robot armor sound interesting.."],["Nice coat.\nI need discount"],["Nice craft"],["Is this new sience?"],["Interesting creature..\nI want to draw it"],["Don\'t worry. I wont eat you."],["I need golden ratio based furniture."],["I need new tire for my cart."],["I\'m hungry..."],["ugh..."],["I\'m hungry..."],["I\'m hungry..."],["um no..."],["I\'m thirsty..."],["I\'m hungry..."],["I\'m thirsty"],["I can\'t resist this bedsmell."],["Clean body bring good sleep."],["This treatment is mistress of bath art."],["hmm calculating curve throw.."],["Sounds peacefull..."],["I\'ll just watch.."]];
       
      
      public function DaVinci()
      {
         super();
         _model = "Davinci";
         _codeName = "DAVINCI";
         _extraDescription = "He never drop garbage.";
      }
      
      override function initPurse() : void
      {
         _initialPurse = 1000;
         _purse = _initialPurse;
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.speed = 35;
         _stat.stamina = 45;
         _stat.sight = 85;
         _stat.hygine = 100;
         _stat.entertain = 75;
         _stat.characterName = "Leonardo Da Vince";
         restRoomIncrementChance = 2;
      }
      
      override function setFavoriteList() : void
      {
         var _loc1_:* = new Array();
         _loc1_.push("Furniture");
         _loc1_.push("Furniture");
         _loc1_.push("Furniture");
         _loc1_.push("Book Store");
         _loc1_.push("Book Store");
         _loc1_.push("Book Store");
         _loc1_.push("Music Hall");
         _loc1_.push("Music Hall");
         _loc1_.push("Livestock");
         _loc1_.push("(none)");
         sortFavorite(_loc1_);
      }
      
      override function hygineCheck() : void
      {
      }
      
      override public function initData() : void
      {
         this.setFavoriteList();
         _gender = 1;
         this.generateConversation();
      }
      
      override function generateConversation() : void
      {
         var _loc3_:* = undefined;
         super.generateConversation();
         _singleConversation.toilet = ConversationList.SEARCH_TOILET.concat();
         _singleConversation.noToilet = new Array();
         var _loc1_:* = 0;
         while(_loc1_ < ConversationList.NO_TOILET.length)
         {
            _singleConversation.noToilet[_loc1_] = ConversationList.NO_TOILET[_loc1_].concat();
            _loc1_++;
         }
         _singleConversation.noTradingPost = ["My money runs out."];
         _singleConversation.tradingPost = ["Trade my painting with gold."];
         _singleConversation.goingHome = new Array();
         _loc1_ = 0;
         while(_loc1_ < ConversationList.WANT_GO_HOME.length)
         {
            if(_loc1_ < 3)
            {
               _singleConversation.goingHome[_loc1_] = ConversationList.WANT_GO_HOME[_loc1_].concat();
            }
            else
            {
               _singleConversation.goingHome[_loc1_] = ["Well spent day brings happy sleep."];
            }
            _loc1_++;
         }
         _singleConversation.booth = new Object();
         var _loc2_:* = 0;
         while(_loc2_ < BuildingData.BUILDING_LIST.length)
         {
            if(_loc2_ in SEARCH_DESTINATION)
            {
               _loc3_ = BuildingData.BUILDING_LIST[_loc2_];
               _singleConversation.booth[_loc3_] = SEARCH_DESTINATION[_loc2_].concat();
            }
            _loc2_++;
         }
         _singleConversation.noDestination = ["I\'m looking for interesting stuff.."];
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
                     hourCome = Math.floor(Math.random() * 7) + 12;
                     minuteCome = Math.floor(Math.random() * 60);
                  }
               }
            }
         }
         super.updateInHome(param1);
      }
   }
}
