package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.modules.Calculate;
   import flash.events.Event;
   
   public class SpecialVisitor extends Visitor
   {
       
      
      var hourCome:int;
      
      var minuteCome:int;
      
      var _codeName:String;
      
      var _extraDescription:String;
      
      var _hasCome:Boolean;
      
      var maxMoodCome:Number;
      
      public function SpecialVisitor()
      {
         super();
         this.hourCome = -1;
         this.minuteCome = -1;
         _inHome = true;
         this._codeName = "";
         this._hasCome = false;
         this.maxMoodCome = 70;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
      }
      
      function generateConversation() : void
      {
         var _loc2_:* = undefined;
         _singleConversation = new Object();
         _singleConversation.transportProblem = [""];
         _singleConversation.cantGoHome = [""];
         _singleConversation.toilet = [""];
         _singleConversation.noToilet = new Array();
         var _loc1_:* = 0;
         while(_loc1_ < 4)
         {
            _singleConversation.noToilet.push([""]);
            _loc1_++;
         }
         _singleConversation.noTradingPost = [""];
         _singleConversation.tradingPost = [""];
         _singleConversation.goingHome = new Array();
         _loc1_ = 0;
         while(_loc1_ < 4)
         {
            _singleConversation.goingHome.push([""]);
            _loc1_++;
         }
         _singleConversation.booth = new Object();
         _loc1_ = 0;
         while(_loc1_ < BuildingData.BUILDING_LIST.length)
         {
            _loc2_ = BuildingData.BUILDING_LIST[_loc1_];
            _singleConversation.booth[_loc2_] = [""];
            _loc1_++;
         }
         _singleConversation.noDestination = [""];
      }
      
      override function whenExile(param1:HumanEvent) : void
      {
         super.whenExile(param1);
         this.hourCome = -1;
         this.minuteCome = -1;
      }
      
      function updateInHome(param1:GameEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(_inHome)
         {
            if(_mood < 50)
            {
               if(Calculate.chance(15))
               {
                  _mood += Math.random() * 2 + 1;
               }
            }
            if(this.hourCome >= 0 && this.minuteCome >= 0)
            {
               _loc2_ = param1.tag;
               if(_loc2_.hour == this.hourCome && _loc2_.minute == this.minuteCome)
               {
                  _loc3_ = 0;
                  if(_world.deepRain)
                  {
                     if(_world.weather <= 20)
                     {
                        _loc3_ = 50;
                     }
                     else
                     {
                        _loc3_ = 30;
                     }
                     _loc4_ = 1;
                     if("specialVisitorChance" in _world.upgradeModifier)
                     {
                        _loc4_ = 1 - _world.upgradeModifier["specialVisitorChance"];
                     }
                     _loc3_ *= _loc4_;
                  }
                  if(Calculate.chance(_loc3_))
                  {
                     this.hourCome = -1;
                     this.minuteCome = -1;
                  }
                  else
                  {
                     _baseHome = Math.floor(Math.random() * 2) * 2 - 1;
                     this.y = 0;
                     if(_baseHome < 0)
                     {
                        this.x = _world.mostLeft - 15;
                     }
                     else if(_baseHome > 0)
                     {
                        this.x = _world.mostRight + 15;
                     }
                     currentAnimation = "idle";
                     _run = false;
                     _restRoomPercentage = 0;
                     _restRoomTarget = null;
                     _destination = null;
                     _inHome = false;
                     _initMode = true;
                     _world.currentVisitorList.push(this);
                     _world.addHuman(this);
                     if(!this._hasCome)
                     {
                        this._hasCome = true;
                     }
                     dispatchEvent(new GameEvent(GameEvent.SPECIAL_VISITOR_COME));
                     this.showNotificationAppearance();
                  }
               }
            }
         }
      }
      
      function showNotificationAppearance() : void
      {
         _world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,characterName + " is coming"));
      }
      
      function moodCheck() : Boolean
      {
         var _loc1_:* = (_mood / 100 * this.maxMoodCome + 10) * (0.5 + _world.popularity / 100);
         var _loc2_:* = 1;
         if("specialVisitorChance" in _world.upgradeModifier)
         {
            _loc2_ = 1 + _world.upgradeModifier["specialVisitorChance"];
         }
         return Calculate.chance(_loc1_);
      }
      
      function favoriteUnlock(param1:Number) : Boolean
      {
         var _loc2_:* = _favoriteList.length;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < _favoriteList.length)
         {
            if(_favoriteList[_loc4_] == "(none)")
            {
               _loc3_ += 100 / _loc2_;
            }
            else if(_world.main.unlockedBuilding.indexOf(_favoriteList[_loc4_]) >= 0)
            {
               _loc3_ += 100 / _loc2_;
            }
            _loc4_++;
         }
         return _loc3_ >= param1;
      }
      
      public function loadStatus(param1:*) : void
      {
         this.hourCome = param1.hourCome;
         this.minuteCome = param1.minuteCome;
         _mood = param1.mood;
         _statification = param1.statification;
         this._hasCome = param1.hasCome;
      }
      
      public function saveStatus(param1:*) : void
      {
         param1.hourCome = this.hourCome;
         param1.minuteCome = this.minuteCome;
         param1.mood = _mood;
         param1.statification = _statification;
         param1.hasCome = this._hasCome;
      }
      
      override public function set world(param1:World) : void
      {
         if(_world != null)
         {
            _world.removeListenerOf(_world.main,GameEvent.GAME_UPDATE,this.updateInHome);
         }
         _world = param1;
         if(_world != null)
         {
            _world.addListenerOf(_world.main,GameEvent.GAME_UPDATE,this.updateInHome);
         }
      }
      
      public function get codeName() : String
      {
         return this._codeName;
      }
      
      public function get extraDescription() : String
      {
         return this._extraDescription;
      }
      
      public function set hasCome(param1:Boolean) : void
      {
         this._hasCome = param1;
      }
      
      public function get hasCome() : Boolean
      {
         return this._hasCome;
      }
   }
}
