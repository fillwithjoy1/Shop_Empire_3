package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.modules.Calculate;
   import Instance.property.HumanStat;
   
   public class Flintstone extends SpecialVisitor
   {
      
      static const SEARCH_DESTINATION = [["I need newsrock magazine."],["I wonder what happen\n500,000 years later?"],["whoa! how much clams is this thing?"],["huh? why non from rocks?\nits broken easily.."],["what this? grass soup?"],["We need energy\nto search my precious"],["I need my caveman club polished"],["Whoa bright stuff.."],["this place cuts better\nthan my clams"],["I need stone helmet for baseball"],["I need mammoth robe\nfor winter"],["Stone club, or wood club.."],["What is this cooking?!"],["Dino? is there any dino?"],["Dino? is there any dino?"],["I need rock pillow\nas hard as my head"],["I need new tire for my car."],["I\'m hungry..."],["Is there any Bronto ribs"],["I\'m hungry..."],["I\'m hungry..."],["I need Bronto sirloin..."],["I\'m thirsty..."],["I\'m hungry..."],["I\'m thirsty"],["I\'ll go home tommorow.."],["Cleaning time!"],["Whatever is this,\nThis feels good!"],["Yahoo! Bowling time!"],["Sounds good!!"],["Can I use my bowling technique to fight?"]];
       
      
      public function Flintstone()
      {
         super();
         _model = "Flintstone";
         _codeName = "FLINTSTONE";
         _extraDescription = "Sometimes he drops a bundle of coin after see a performance.";
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.speed = 40;
         _stat.stamina = 55;
         _stat.sight = 45;
         _stat.hygine = 50;
         _stat.entertain = 90;
         _stat.characterName = "Flingstone";
         restRoomIncrementChance = 4 * ((100 - _stat.hygine) / 100) + 3;
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
         _singleConversation.toilet = ["Poop Poop Poop"];
         _singleConversation.noToilet[0] = ["Poop Poop Poop"];
         _singleConversation.noToilet[1] = ["Poop Poop Poop"];
         _singleConversation.noToilet[2] = ["Poop Poop Poop"];
         _singleConversation.noToilet[3] = ["Poop Poop Poop"];
         _singleConversation.noTradingPost = ["If I brought more money."];
         _singleConversation.tradingPost = ["I trade my clams with your gold."];
         _singleConversation.goingHome = new Array();
         _singleConversation.goingHome[0] = ["I\'m goin home, Wilmo"];
         _singleConversation.goingHome[1] = ["I\'m goin home, Wilmo"];
         _singleConversation.goingHome[2] = ["I\'m goin home, Wilmo"];
         _singleConversation.goingHome[3] = ["I\'m goin home, Wilmo"];
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
         _singleConversation.noDestination = ["Yabba Dabba Boo!"];
      }
      
      override function setFavoriteList() : void
      {
         var _loc1_:* = new Array();
         _loc1_.push("Bowling");
         _loc1_.push("Bowling");
         _loc1_.push("Bowling");
         _loc1_.push("Bowling");
         _loc1_.push("BBQ");
         _loc1_.push("BBQ");
         _loc1_.push("BBQ");
         _loc1_.push("Tavern");
         _loc1_.push("Butcher");
         _loc1_.push("(none)");
         sortFavorite(_loc1_);
      }
      
      override function initPurse() : void
      {
         _initialPurse = 1200;
         _purse = _initialPurse;
      }
      
      override function giveBonus() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = _mood / 100 * 80;
         if(Calculate.chance(_loc1_))
         {
            _loc2_ = Math.round(_purse * 0.01 * entertainerOnView.level);
            _loc3_ = Math.round(Math.random() * _loc2_);
            if(Calculate.chance(15))
            {
               _loc3_ += 250;
            }
            if(_purse >= _loc3_)
            {
               if(_loc3_ > 0)
               {
                  _purse -= _loc3_;
                  dispatchEvent(new HumanEvent(HumanEvent.DROP_BONUS,{
                     "amount":_loc3_,
                     "giveTo":entertainerOnView
                  }));
               }
            }
         }
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
                     hourCome = Math.floor(Math.random() * 4) + 11;
                     minuteCome = Math.floor(Math.random() * 60);
                  }
               }
            }
         }
         super.updateInHome(param1);
      }
   }
}
