package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.AchievementEvent;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.property.HumanStat;
   import Instance.sprite.Animation;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Gandalf extends SpecialVisitor
   {
      
      static const SEARCH_DESTINATION = [["Learn magic trick for parties.\nThis is new.."],["I wonder how Solon doing.."],["Wait.. that\'s..\nThranduel\'s brooch.."],["My water pot is broken."],["Need a medicine to cure my injury."],["Give me mana potion, please."],["Please enchant my staff to +15, son!"],["Pretty.."],["I need to wash my hair and beard.","Trim it and make it white color.\nI need to join Aragurn soon."],["I\'m a wizard.\nDidn\'t use these armor."],["White robe , please.\nI need new uniform"],["I\'m looking for AK-47..\nAhem, no. I mean Glamdrong sword."],["I can get some gold\nby selling spell here.."],["Um...Is that you Biurn?"],["I need horse.\nWhite one."],["I wonder what I need here.."],["A wizard needs a cart sometimes."],["This is delicious.\nYou shall pass!"],["looks fresh"],["This is delicious.\nYou shall pass!"],["This is delicious.\nYou shall pass!"],["This is delicious.\nYou shall pass!"],["I\'m thirsty.."],["Ah, cheers."],["I\'m thirsty.."],["This precise time for sleep."],["How long I didn\'t take bath.."],["This is good for my young spirit."],["I\'ll use my spell."],["Nice..You shall pass!"],["May I can get some bounty in there."]];
       
      
      var toRestore:Array;
      
      var _curingProgress:Boolean;
      
      public function Gandalf()
      {
         super();
         _model = "Gandalf";
         _codeName = "GANDALF";
         this.toRestore = new Array();
         this._curingProgress = false;
         _extraDescription = "He is immune from curse spell and enable to dispel from curse.";
      }
      
      override function initPurse() : void
      {
         _initialPurse = 900;
         _purse = _initialPurse;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,LoopEvent.ON_IDLE,this.cureCheck);
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.speed = 65;
         _stat.stamina = 65;
         _stat.sight = 90;
         _stat.hygine = 60;
         _stat.entertain = 50;
         _stat.characterName = "Goondolf";
         restRoomIncrementChance = 2 * ((100 - _stat.hygine) / 100) + 2;
      }
      
      override function setFavoriteList() : void
      {
         var _loc1_:* = new Array();
         _loc1_.push("Spa");
         _loc1_.push("Spa");
         _loc1_.push("Spa");
         _loc1_.push("Potion Shop");
         _loc1_.push("Potion Shop");
         _loc1_.push("Potion Shop");
         _loc1_.push("Gem Shop");
         _loc1_.push("Gem Shop");
         _loc1_.push("Book Store");
         _loc1_.push("(none)");
         sortFavorite(_loc1_);
      }
      
      function searchToRestore() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(!_passive && _inside == null)
         {
            _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc2_ = 0;
            while(_loc2_ < _world.humanList.length)
            {
               _loc3_ = _world.humanList[_loc2_];
               if(_world.wizardList.indexOf(_loc3_) < 0)
               {
                  if(_loc3_.relatedCritter != null)
                  {
                     _loc4_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
                     if(_loc1_.y == _loc4_.y)
                     {
                        if((_loc5_ = Math.abs(_loc1_.x - _loc4_.x)) <= 120)
                        {
                           this.toRestore.push(_loc3_);
                        }
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      function cureCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(!_passive)
         {
            if(_currentAnimation == "cure")
            {
               if(this.currentFrameLabel == "debuff")
               {
                  while(this.toRestore.length > 0)
                  {
                     _loc2_ = 0;
                     _loc3_ = this.toRestore.shift();
                     if(_loc3_.relatedCritter != null)
                     {
                        _loc3_.relatedCritter.debuff();
                        _loc2_++;
                     }
                  }
                  if(_loc2_ > 0)
                  {
                     if("cureVisitor" in _world.main.history)
                     {
                        _world.main.history["cureVisitor"] += _loc2_;
                     }
                     else
                     {
                        _world.main.history["cureVisitor"] = _loc2_;
                     }
                     trace("Yg sudah disembihkan Gandalf = " + _world.main.history["cureVisitor"]);
                     dispatchEvent(new AchievementEvent(AchievementEvent.UPDATE_HISTORY,"cureVisitor"));
                  }
               }
               if(this.currentFrameLabel == "cure_end")
               {
                  this._curingProgress = false;
                  currentAnimation = Animation.IDLE;
               }
            }
         }
      }
      
      override function movingCheck(param1:LoopEvent) : void
      {
         if(!this._curingProgress)
         {
            super.movingCheck(param1);
         }
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         this.searchToRestore();
         if(this.toRestore.length > 0)
         {
            this._curingProgress = true;
         }
         if(this._curingProgress)
         {
            if(!_passive)
            {
               if(_currentAnimation != "cure")
               {
                  currentAnimation = "cure";
               }
            }
         }
         else
         {
            super.behavior(param1);
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
         var _loc2_:* = undefined;
         super.generateConversation();
         _singleConversation.toilet = ["It is not despair. Just urgent situation"];
         _singleConversation.noToilet[0] = ["It is despair!"];
         _singleConversation.noToilet[1] = ["It is despair!"];
         _singleConversation.noToilet[2] = ["It is not despair. Just urgent situation"];
         _singleConversation.noToilet[3] = ["It is not despair. Just urgent situation"];
         _singleConversation.noTradingPost = ["If I brought more money."];
         _singleConversation.tradingPost = ["I\'ll trade this broken frying pan for gold."];
         _singleConversation.goingHome = new Array();
         _singleConversation.goingHome[0] = ["I shall pass!!"];
         _singleConversation.goingHome[1] = ["I shall pass!!"];
         _singleConversation.goingHome[2] = ["Ah, those dwarves is fighting.\nI forgot about them."];
         _singleConversation.goingHome[3] = ["Ah, those dwarves is fighting.\nI forgot about them."];
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
         _singleConversation.noDestination = ["A wizard is never late,\nnor is he early,\nhe arrives precisely when he means to.","The world is not in your books and maps. It\'s in this mall."];
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
