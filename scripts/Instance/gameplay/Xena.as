package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.modules.Calculate;
   import Instance.property.HumanStat;
   import flash.geom.Point;
   
   public class Xena extends SpecialVisitor
   {
      
      static const SEARCH_DESTINATION = [["Muscular woman\'s charm.\n Geez.. I\'ll read it a bit."],["I wonder how Solon doing.."],["Pretty.."],["My water pot is broken."],["Gobriel gonna like this."],["I need many power booster for Gobriel."],["I need to sharpen my chakram, sword and whip.\nUh no. Not the whip."],["Pretty.."],["I need to trim my hair.\nCutting with chakram make it messy"],["Gobriel said I should try chainmail...\nNah. That\'d just attract a kinkier group."],["Ah, discount.\n This gonna be a battlefield."],["Maybe a frying pan?\nI like to be creative in a fight."],["I need spell of mighty for gabriel.\nOr spell of cooking.."],["Centaur..Is there any centaur?"],["Hey, little  Food."],["I need new frying pan.\nI throw it to some warlord yesterday."],["Is there wagon for battlefield?"],["I\'m very hungry..."],["looks tasty and fresh"],["I\'m hungry.."],["I\'m hungry.."],["I\'m hungry.."],["I\'m thirsty.."],["I\'m hungry.."],["I\'m thirsty.."],["Yawn. I\'m so sleepy."],["how long I didn\'t take bath.."],["As a warrior princess\n I need to keep beauty."],["I\'ll throw my chakram in the alley."],["Nice"],["May I can get some bounty in there."]];
       
      
      var delayToMoodIncrease = 0;
      
      public function Xena()
      {
         super();
         _model = "Xena";
         _codeName = "XENA";
         _extraDescription = "She might increase normal people\'s mood that passed by her.";
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         super.behavior(param1);
         if(!_passive)
         {
            if(this.delayToMoodIncrease > 0)
            {
               --this.delayToMoodIncrease;
            }
            else if(_inside == null)
            {
               _loc2_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
               _loc3_ = 0;
               while(_loc3_ < _world.currentVisitorList.length)
               {
                  if(Calculate.chance(25))
                  {
                     if((_loc4_ = _world.currentVisitorList[_loc3_]).inside == null)
                     {
                        if(_world.specialVisitorList.indexOf(this) < 0)
                        {
                           _loc5_ = _world.mainContainer.globalToLocal(_loc4_.localToGlobal(new Point(0,0)));
                           if(_loc2_.y == _loc5_.y)
                           {
                              if((_loc6_ = Math.abs(_loc2_.x - _loc5_.x)) <= 25)
                              {
                                 _loc7_ = Math.random() * 5 + 5;
                                 _loc4_.gainMood(_loc7_);
                              }
                           }
                        }
                     }
                  }
                  _loc3_++;
               }
               this.delayToMoodIncrease = 15;
            }
         }
      }
      
      override function initPurse() : void
      {
         _initialPurse = 850;
         _purse = _initialPurse;
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.speed = 45;
         _stat.stamina = 75;
         _stat.sight = 60;
         _stat.hygine = 75;
         _stat.entertain = 65;
         _stat.characterName = "Warrior Princess";
         restRoomIncrementChance = 2 * ((100 - _stat.hygine) / 100) + 2;
      }
      
      override function setFavoriteList() : void
      {
         var _loc1_:* = new Array();
         _loc1_.push("Brewery");
         _loc1_.push("Brewery");
         _loc1_.push("Brewery");
         _loc1_.push("Armory");
         _loc1_.push("Armory");
         _loc1_.push("Armory");
         _loc1_.push("BBQ");
         _loc1_.push("BBQ");
         _loc1_.push("Barbershop");
         _loc1_.push("(none)");
         sortFavorite(_loc1_);
      }
      
      override public function initData() : void
      {
         this.setFavoriteList();
         _gender = -1;
         this.generateConversation();
      }
      
      override function generateConversation() : void
      {
         var _loc2_:* = undefined;
         super.generateConversation();
         _singleConversation.toilet = ["It\'s fine. Just hold a bit."];
         _singleConversation.noToilet[0] = ["Just hold a bit. When reach home it\'s okay."];
         _singleConversation.noToilet[1] = ["Just hold a bit. When reach home it\'s okay."];
         _singleConversation.noToilet[2] = ["Just hold a bit. When reach home it\'s okay."];
         _singleConversation.noToilet[3] = ["Just hold a bit. When reach home it\'s okay."];
         _singleConversation.noTradingPost = ["If I brought more money."];
         _singleConversation.tradingPost = ["I\'ll trade this broken frying pan for gold."];
         _singleConversation.goingHome = new Array();
         _singleConversation.goingHome[0] = ["Ah, I forget about Gobriel.\n She\'s waiting for me."];
         _singleConversation.goingHome[1] = ["Ah, I forget about Gobriel.\n She\'s waiting for me."];
         _singleConversation.goingHome[2] = ["I\'ll tell Gobriel about this mall."];
         _singleConversation.goingHome[3] = ["I\'ll tell Gobriel about this mall."];
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
         _singleConversation.noDestination = ["Entertaining place for warrior princess."];
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
