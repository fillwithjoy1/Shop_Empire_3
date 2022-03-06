package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.constant.ConversationList;
   import Instance.events.GameEvent;
   import Instance.modules.Calculate;
   import Instance.property.FictionalBuilding;
   import Instance.property.HumanStat;
   
   public class Hercules extends SpecialVisitor
   {
      
      static const SEARCH_DESTINATION = [["Hum..photos collection\nof Greek gods.. nice..","How to overcome woman hatred.\nI need this!."],["I wonder how long my\nstep mother mad at me","woman is hard to understand\nand so my step mother.\nwhy is she hates me so much?"],["Too shiny. Not match for my muscle"],["I didn\'t use any of\nthese in adventure"],["I need many of these.\n For Iolaos.."],["I need power booster."],["I need to enhance my club."],["Better Iolaos not see this shop."],["I need to trim my chesthair."],["I need lion helmet."],["Those amazons gonna stuck here\nif they pursue me.","Good, discount.\n its a good trap for those amazons."],["I need heavy barbaric style weapon."],["Can you send curse to my evil step mother?"],["Beautifull..\nOh, I can capture cerberus and sell here."],["Looks tasty.."],["Adventuring with carying a cozy bed..\nsounds troublesome."],["Sun Chariot wheel is broken.\nNeed to fix it before I return it."],["I\'m very hungry..."],["looks tasty and fresh"],["I\'m very hungry..."],["I\'m very hungry..."],["Its the protein I need."],["I\'m thirsty..."],["I\'m hungry..."],["I\'m thirsty.\n I hope there\'s no bar fight today."],["Once in a while..\nToo much sleep on the ground."],["How long I didn\'t take bath.."],["My muscle need massage sometimes."],["Looks like my throw gona\n break the bowling alley."],["Nice"],["It\'s gonna looks like\ncheating if I join."]];
       
      
      public function Hercules()
      {
         super();
         _model = "Hercules";
         _codeName = "HERCULES";
         _extraDescription = "He never broke the booth. Instead he help to repair it.";
         maxMoodCome = 60;
      }
      
      override function initPurse() : void
      {
         _initialPurse = 800;
         _purse = _initialPurse;
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.speed = 45;
         _stat.stamina = 100;
         _stat.sight = 65;
         _stat.hygine = 65;
         _stat.entertain = 50;
         _stat.characterName = "Herkulez";
         restRoomIncrementChance = 3 * ((100 - _stat.hygine) / 100) + 4;
      }
      
      override function setFavoriteList() : void
      {
         var _loc1_:* = new Array();
         _loc1_.push("Bath House");
         _loc1_.push("Bath House");
         _loc1_.push("Bath House");
         _loc1_.push("Weaponry");
         _loc1_.push("Weaponry");
         _loc1_.push("Weaponry");
         _loc1_.push("Blacksmith");
         _loc1_.push("Blacksmith");
         _loc1_.push("Witchcraft");
         _loc1_.push("(none)");
         sortFavorite(_loc1_);
      }
      
      override function brokenBoothCheck() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:* = _inside;
         if(_inside is FictionalBuilding)
         {
            _loc1_ = _inside.related;
         }
         if(_world.brokableBuildingList.indexOf(_loc1_) >= 0)
         {
            if(_visitTime > 5)
            {
               _loc2_ = _inside.serveMode;
               _loc3_ = 0;
               if(_loc2_ == BuildingData.SERVICE)
               {
                  if((_loc4_ = _loc1_.visitorInService.indexOf(this)) in _loc1_.serviceTimeList)
                  {
                     _loc3_ = 5;
                  }
                  else
                  {
                     _loc3_ = 15;
                  }
               }
               else
               {
                  _loc3_ = 10;
               }
               if(Calculate.chance(_loc3_))
               {
                  _loc1_.buildingHP += Math.round(Math.random() * 2 + 1);
               }
            }
         }
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
         _singleConversation.tradingPost = ["Would you trade this hydra head?.\nSorry it\'s messy."];
         _singleConversation.goingHome = new Array();
         _loc1_ = 0;
         while(_loc1_ < ConversationList.WANT_GO_HOME.length)
         {
            _singleConversation.goingHome[_loc1_] = ["Time to fight monster\nmy step mother send again."];
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
         _singleConversation.noDestination = ["Save place for a while"];
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
                     hourCome = Math.floor(Math.random() * 6) + 11;
                     minuteCome = Math.floor(Math.random() * 60);
                  }
               }
            }
         }
         super.updateInHome(param1);
      }
   }
}
