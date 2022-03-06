package Instance.property
{
   import Instance.SEMovieClip;
   import Instance.constant.BuildingData;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.LoopEvent;
   import Instance.gameplay.World;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class Elevator extends SEMovieClip
   {
       
      
      const MOVE_SPEED = 6;
      
      const TO_NEXT_LEVEL = [500,1000];
      
      public const EXPAND_COST = [1000,1200,1500];
      
      var _bodyList:Array;
      
      var _room:MovieClip;
      
      var _humanContainer:MovieClip;
      
      var _bodyTarget:int;
      
      var _backCover:Array;
      
      var _level:int;
      
      var _world:World;
      
      var _roomTarget:Array;
      
      var _dirrectionRoom:int;
      
      var _activeRoom;
      
      var _capacityLimit:int;
      
      var _passanger:Array;
      
      var _escapePassanger:Array;
      
      var _delayToClose:int;
      
      var _canClick:Boolean;
      
      var _upgradeMode:Boolean;
      
      var _upgradeState:Boolean;
      
      var _maxLevel:int;
      
      var _upgradeCost:Number;
      
      var _exp:int;
      
      var _expCarry:int;
      
      public function Elevator()
      {
         super();
         this._bodyList = new Array();
         this._backCover = new Array();
         this._passanger = new Array();
         this._escapePassanger = new Array();
         this._room = new ElevatorRoom();
         this._humanContainer = new MovieClip();
         this._room.addChild(this._humanContainer);
         this._bodyTarget = 0;
         this._roomTarget = new Array();
         this._dirrectionRoom = 0;
         this._level = 1;
         this._capacityLimit = 10;
         this._delayToClose = 0;
         this._upgradeMode = false;
         this._upgradeState = false;
         this._maxLevel = 3;
         this._exp = 0;
         this._expCarry = 0;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.initElevator();
         this._room.stop();
         if(this._bodyTarget in this._bodyList)
         {
            this._room.y = this._bodyList[this._bodyTarget].y;
         }
         if(this._level > 0 && this._level <= totalFrames)
         {
            this._room.gotoAndStop(this._level);
         }
         this._capacityLimit = 10 + 5 * (this._level - 1);
         addListenerOf(this,LoopEvent.ON_IDLE,this.checkRoomMovement);
         addListenerOf(this,CommandEvent.UPGRADE_BUILD,this.upgradeBuilding);
         this.setUpgradeCost();
      }
      
      public function initExp(param1:Number) : void
      {
         this._exp = Math.floor(param1);
         this._expCarry = Math.ceil(param1 * 10) % 10;
      }
      
      function upgradeBuilding(param1:CommandEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = this._world.main;
         var _loc3_:* = BuildingData.getBuildingCost("Elevator",this._level);
         if(_loc2_.isEnough(this._upgradeCost) || this is FacilityElevatorBody)
         {
            if(!this._upgradeMode)
            {
               if(this._level < this._maxLevel)
               {
                  this._upgradeMode = true;
                  this._upgradeState = true;
                  _loc4_ = 0;
                  while(_loc4_ < this._bodyList.length)
                  {
                     this._bodyList[_loc4_].dispatchEvent(new CommandEvent(CommandEvent.UPGRADE_BUILD));
                     _loc4_++;
                  }
                  dispatchEvent(new GameEvent(GameEvent.BECOMES_UPGRADE));
                  addListenerOf(this,LoopEvent.ON_IDLE,this.flashingAnimate);
               }
            }
         }
         else
         {
            this._world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Not Enough Money"));
         }
      }
      
      function flashingAnimate(param1:LoopEvent) : void
      {
         var _loc2_:ColorTransform = this.transform.colorTransform;
         var _loc3_:* = _loc2_.redOffset;
         var _loc4_:* = _loc2_.greenOffset;
         var _loc5_:* = _loc2_.blueOffset;
         var _loc6_:* = false;
         if(_loc3_ + 32 < 255)
         {
            _loc3_ += 32;
            _loc4_ += 32;
            _loc5_ += 32;
         }
         else
         {
            _loc6_ = true;
            _loc3_ = 255;
            _loc4_ = 255;
            _loc5_ = 255;
         }
         _loc2_.redOffset = _loc3_;
         _loc2_.greenOffset = _loc4_;
         _loc2_.blueOffset = _loc5_;
         this.transform.colorTransform = _loc2_;
         if(_loc6_)
         {
            removeListenerOf(this,LoopEvent.ON_IDLE,this.flashingAnimate);
            ++this._level;
            this._room.gotoAndStop(this._level);
            this._room.setChildIndex(this._humanContainer,this._room.numChildren - 1);
            addListenerOf(this,LoopEvent.ON_IDLE,this.unflashingAnimate);
            this._upgradeState = false;
            this.setUpgradeCost();
            this._exp = 0;
            this._expCarry = 0;
            this._capacityLimit = 10 + 5 * (this._level - 1);
            dispatchEvent(new GameEvent(GameEvent.BUILDING_SUCCESSFULLY_UPGRADE));
         }
      }
      
      public function setUpgradeCost() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this._level in this.EXPAND_COST)
         {
            _loc1_ = BuildingData.getBuildingCost("Elevator",this._level);
            _loc2_ = this.EXPAND_COST[this._level] - this.EXPAND_COST[this._level - 1];
            _loc3_ = _loc1_ + _loc2_ * Math.max(0,this._bodyList.length - 2);
            this._upgradeCost = _loc3_;
         }
         else
         {
            this._upgradeCost = 0;
         }
      }
      
      function unflashingAnimate(param1:LoopEvent) : void
      {
         var _loc2_:ColorTransform = this.transform.colorTransform;
         var _loc3_:* = _loc2_.redOffset;
         var _loc4_:* = _loc2_.greenOffset;
         var _loc5_:* = _loc2_.blueOffset;
         if(_loc3_ - 32 > 0)
         {
            _loc3_ -= 32;
            _loc4_ -= 32;
            _loc5_ -= 32;
         }
         else
         {
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            removeListenerOf(this,LoopEvent.ON_IDLE,this.unflashingAnimate);
            this._upgradeMode = false;
         }
         _loc2_.redOffset = _loc3_;
         _loc2_.greenOffset = _loc4_;
         _loc2_.blueOffset = _loc5_;
         this.transform.colorTransform = _loc2_;
      }
      
      function checkRoomMovement(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(this._activeRoom == null)
         {
            if(this._roomTarget.length > 0)
            {
               _loc2_ = this.getNearestRoomTarget();
               _loc3_ = Math.abs(_loc2_.y - this._room.y);
               if(_loc3_ > 0)
               {
                  if(this._dirrectionRoom == 0)
                  {
                     if(this._room.y < _loc2_.y)
                     {
                        this._dirrectionRoom = -1;
                     }
                     else if(this._room.y > _loc2_.y)
                     {
                        this._dirrectionRoom = 1;
                     }
                  }
                  _loc4_ = 0;
                  if("elevatorSpeedBonus" in this._world.upgradeModifier)
                  {
                     _loc4_ = this._world.upgradeModifier["elevatorSpeedBonus"];
                  }
                  this._room.y -= this._dirrectionRoom * Math.min((this.MOVE_SPEED + _loc4_) * this._level,_loc3_);
                  this.gainExp(0.2);
               }
               else
               {
                  this._activeRoom = _loc2_;
                  this.bodyTarget = this._bodyList.indexOf(this._activeRoom);
                  this._activeRoom.openTheDoor();
                  this._delayToClose = 10;
               }
            }
         }
         else if(this._activeRoom.enableToEnter)
         {
            if(this._escapePassanger.length == 0)
            {
               _loc5_ = false;
               _loc6_ = 0;
               while(_loc6_ < this._passanger.length)
               {
                  if((_loc7_ = this._passanger[_loc6_]).inside != this)
                  {
                     _loc5_ = true;
                     break;
                  }
                  _loc6_++;
               }
               if(!_loc5_)
               {
                  if(this._delayToClose > 0)
                  {
                     --this._delayToClose;
                  }
                  else
                  {
                     if((_loc8_ = this._roomTarget.indexOf(this._activeRoom)) in this._roomTarget)
                     {
                        this._roomTarget.splice(_loc8_,1);
                     }
                     this._activeRoom.closeTheDoor();
                  }
               }
               else
               {
                  this._delayToClose = 10;
               }
            }
         }
         else if(!this._activeRoom.openCloseProgress)
         {
            this._activeRoom = null;
            if(this._roomTarget.length > 0)
            {
               _loc2_ = this.getNearestRoomTarget();
               if(_loc2_ == null)
               {
                  this._dirrectionRoom *= -1;
               }
            }
            else
            {
               this._dirrectionRoom = 0;
            }
         }
      }
      
      public function getNearestRoomTarget() : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = Infinity;
         var _loc3_:* = 0;
         while(_loc3_ < this._roomTarget.length)
         {
            _loc4_ = this._roomTarget[_loc3_];
            _loc5_ = false;
            if(this._dirrectionRoom == 0)
            {
               _loc5_ = true;
            }
            else
            {
               _loc5_ = this._dirrectionRoom == 0 || this._dirrectionRoom > 0 && _loc4_.y <= this._room.y || this._dirrectionRoom < 0 && _loc4_.y >= this._room.y;
            }
            if(_loc5_)
            {
               _loc6_ = Math.abs(_loc4_.y - this._room.y);
               if(_loc2_ > _loc6_)
               {
                  _loc1_ = _loc4_;
                  _loc2_ = _loc6_;
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      function removeCover() : void
      {
         var _loc1_:* = undefined;
         while(this._backCover.length > 0)
         {
            _loc1_ = this._backCover.shift();
            if(getChildByName(_loc1_.name))
            {
               removeChild(_loc1_);
            }
         }
         if(getChildByName(this._room.name))
         {
            removeChild(this._room);
         }
      }
      
      public function recreateElevator() : void
      {
         this.removeCover();
         this.initElevator();
         this.setUpgradeCost();
      }
      
      function initElevator() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:Sprite = null;
         var _loc4_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._bodyList.length)
         {
            _loc2_ = this._bodyList[_loc1_];
            _loc3_ = new Sprite();
            _loc3_.graphics.clear();
            _loc3_.graphics.beginFill(6710844);
            _loc3_.graphics.drawRect(-96 / 2,-72,96,72);
            _loc3_.graphics.endFill();
            _loc4_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
            _loc3_.y = _loc4_.y;
            this._backCover.push(_loc3_);
            addChild(_loc3_);
            _loc2_.level = this._level;
            _loc2_.elevatorLink = this;
            addListenerOf(_loc2_,MouseEvent.MOUSE_DOWN,this.toExpand);
            _loc1_++;
         }
         addChild(this._room);
      }
      
      function toExpand(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.BEGIN_EXPAND));
      }
      
      public function addPerson(param1:*, param2:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(!param2)
         {
            _loc3_ = this._humanContainer.globalToLocal(param1.localToGlobal(new Point(0,0)));
            _loc4_ = this._humanContainer.globalToLocal(param1.localToGlobal(new Point(1,0)));
            param1.x = _loc3_.x;
            param1.y = _loc3_.y;
            if(_loc4_.x > _loc3_.x)
            {
               param1.scaleX = 1;
            }
            else
            {
               param1.scaleX = -1;
            }
         }
         this._humanContainer.addChild(param1);
      }
      
      public function removePerson(param1:*) : void
      {
         var _loc2_:* = this._passanger.indexOf(param1);
         if(_loc2_ in this._passanger)
         {
            this._passanger.splice(_loc2_,1);
         }
         var _loc3_:* = this._escapePassanger.indexOf(param1);
         if(_loc3_ in this._escapePassanger)
         {
            this._escapePassanger.splice(_loc3_,1);
         }
      }
      
      public function destroyBody() : void
      {
         var _loc1_:* = undefined;
         while(this._bodyList.length > 0)
         {
            _loc1_ = this._bodyList.shift();
            _loc1_.dispatchEvent(new GameEvent(GameEvent.DESTROY));
         }
      }
      
      override protected function Removed(param1:Event) : void
      {
         super.Removed(param1);
         this.removeCover();
      }
      
      public function gainExp(param1:Number) : void
      {
         var _loc2_:* = undefined;
         if(this._level - 1 in this.TO_NEXT_LEVEL)
         {
            this._expCarry += Math.ceil(param1 * 10);
            if(this._expCarry >= 10)
            {
               _loc2_ = this.TO_NEXT_LEVEL[this._level - 1];
               this._exp = Math.min(this._exp + Math.floor(this._expCarry / 10),_loc2_);
               this._expCarry %= 10;
               dispatchEvent(new GameEvent(GameEvent.GAIN_EXPERIENCE));
            }
         }
      }
      
      public function get bodyList() : Array
      {
         return this._bodyList;
      }
      
      public function get highestRoom() : *
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         while(_loc2_ < this._bodyList.length)
         {
            if(_loc1_ == null)
            {
               _loc1_ = this._bodyList[_loc2_];
            }
            else if(this._bodyList[_loc2_].y < _loc1_.y)
            {
               _loc1_ = this._bodyList[_loc2_];
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function entrancePosition(param1:Number) : Point
      {
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         while(_loc3_ < this._bodyList.length)
         {
            if((_loc4_ = this._bodyList[_loc3_]).enterancePosition.y == param1)
            {
               _loc2_ = _loc4_.enterancePosition;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getBodyOf(param1:Number) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         while(_loc3_ < this._bodyList.length)
         {
            if((_loc4_ = this._bodyList[_loc3_]).y == param1)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function putTarget(param1:*) : void
      {
         if(this._roomTarget.indexOf(param1) < 0)
         {
            this._roomTarget.push(param1);
         }
      }
      
      public function get activeRoom() : *
      {
         return this._activeRoom;
      }
      
      public function get lowestRoom() : *
      {
         var _loc1_:* = null;
         var _loc2_:* = 0;
         while(_loc2_ < this._bodyList.length)
         {
            if(_loc1_ == null)
            {
               _loc1_ = this._bodyList[_loc2_];
            }
            else if(this._bodyList[_loc2_].y > _loc1_.y)
            {
               _loc1_ = this._bodyList[_loc2_];
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function set bodyTarget(param1:int) : void
      {
         this._bodyTarget = param1;
      }
      
      public function get bodyTarget() : int
      {
         return this._bodyTarget;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get room() : MovieClip
      {
         return this._room;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get roomTarget() : Array
      {
         return this._roomTarget;
      }
      
      public function get dirrectionRoom() : int
      {
         return this._dirrectionRoom;
      }
      
      public function get capacityLimit() : int
      {
         var _loc1_:* = 0;
         if(this._world != null)
         {
            if("elevatorCapacityBonus" in this._world.upgradeModifier)
            {
               _loc1_ = this._world.upgradeModifier["elevatorCapacityBonus"];
            }
         }
         return this._capacityLimit + _loc1_;
      }
      
      public function get passanger() : Array
      {
         return this._passanger;
      }
      
      public function get escapePassanger() : Array
      {
         return this._escapePassanger;
      }
      
      public function set canClick(param1:Boolean) : void
      {
         this._canClick = param1;
      }
      
      public function get canClick() : Boolean
      {
         return this._canClick;
      }
      
      public function get maxLevel() : int
      {
         return this._maxLevel;
      }
      
      public function get destroyable() : Boolean
      {
         return true;
      }
      
      public function get upgradeMode() : Boolean
      {
         return this._upgradeMode;
      }
      
      public function get upgradeState() : Boolean
      {
         return this._upgradeState;
      }
      
      public function get upgradeCost() : Number
      {
         return this._upgradeCost;
      }
      
      public function get relocateCost() : Number
      {
         return Infinity;
      }
      
      public function get exp() : int
      {
         return this._exp;
      }
      
      public function get expSave() : Number
      {
         return this._exp + this._expCarry / 10;
      }
      
      public function get expPercentage() : Number
      {
         var _loc1_:* = undefined;
         if(this._level < this._maxLevel)
         {
            if(this._level - 1 in this.TO_NEXT_LEVEL)
            {
               _loc1_ = this.TO_NEXT_LEVEL[this._level - 1];
               return this._exp / _loc1_;
            }
            return 1;
         }
         return 1;
      }
      
      public function get toNextLevel() : int
      {
         if(this._level < this._maxLevel)
         {
            if(this._level - 1 in this.TO_NEXT_LEVEL)
            {
               return this.TO_NEXT_LEVEL[this._level - 1];
            }
            return 0;
         }
         return 0;
      }
   }
}
