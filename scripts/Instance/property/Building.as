package Instance.property
{
   import Instance.SEMovieClip;
   import Instance.constant.BuildingData;
   import Instance.events.AudioEvent;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.LoopEvent;
   import Instance.gameplay.StaffHandyman;
   import Instance.gameplay.World;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class Building extends SEMovieClip
   {
       
      
      const TO_NEXT_LEVEL = [500,1000];
      
      var _level:int;
      
      var _maxLevel:int;
      
      var _insideRegion;
      
      var _humanContainer:MovieClip;
      
      var _world:World;
      
      var _humanList:Array;
      
      var _enteranceRange:Number;
      
      var _brokenTreshold:Number;
      
      var _buildingHP:int;
      
      var _buildingMaxHP:int;
      
      var _buildingBaseHP:int;
      
      var _buildingIncrementHP:int;
      
      var _isBroken:Boolean;
      
      var _needRepair:Boolean;
      
      var _brokenClip:MovieClip;
      
      var _serveMode:String;
      
      var _upgradeMode:Boolean;
      
      var _upgradeState:Boolean;
      
      var _capacity:Number;
      
      var _destroyable:Boolean;
      
      var _buildingName:String;
      
      var _upgradeCost:int;
      
      var _relocateCost:int;
      
      var _exp:int;
      
      var _expCarry:int;
      
      var _alarmTrigger:Boolean;
      
      var _alarmSound;
      
      var _repairingSymbol:MovieClip;
      
      var _rWidth:Number;
      
      var lastTrigger:Boolean;
      
      var lastAppear:Boolean;
      
      var alarmFx:Number;
      
      var delayAfterOpen:int = 0;
      
      public function Building()
      {
         super();
         priority = 0;
         this._destroyable = true;
         this._humanContainer = new MovieClip();
         this._humanList = new Array();
         this._enteranceRange = 0;
         this._brokenTreshold = 70;
         this._isBroken = false;
         this._maxLevel = this.totalFrames;
         this._serveMode = BuildingData.getServeMode(BuildingData.returnClassTo(Utility.getClass(this)));
         this._upgradeMode = false;
         this._upgradeState = false;
         this._buildingName = "";
         this._exp = 0;
         this._expCarry = 0;
         this._rWidth = this.width;
         this._repairingSymbol = new InRepairProgressIcon();
         this._repairingSymbol.stop();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         this._capacity = BuildingData.getCapacity(this);
         super.Initialize(param1);
         stop();
         if(this._level > 0 && this._level <= this._maxLevel)
         {
            if(this.currentFrame != this._level)
            {
               this.gotoAndStop(this._level);
            }
         }
         this.buttonMode = !(this is InnEnterance);
         addListenerOf(this,MouseEvent.CLICK,this.buildingOnClick);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.updateBrokenCheck);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.openDoorCheck);
         addListenerOf(this,CommandEvent.UPGRADE_BUILD,this.upgradeBuilding);
         addListenerOf(this,LoopEvent.ON_IDLE,this.checkAnimateAlarm);
         addListenerOf(this,Event.ENTER_FRAME,this.checkAlarmSound);
         if(this._isBroken)
         {
            if(this._brokenClip != null)
            {
               if(this._brokenClip.stage == null)
               {
                  this._brokenClip.alpha = Math.min(1,Math.max(this.brokenLevel / this._brokenTreshold));
                  addChild(this._brokenClip);
               }
            }
         }
         this.initChildAnimation();
         this.setUpgradeCost();
      }
      
      function checkAlarmSound(param1:Event) : void
      {
         if(this._alarmSound != null)
         {
            if(this.lastAppear != this._world.main.menuAppear)
            {
               if(this._world.main.menuAppear)
               {
                  dispatchEvent(new AudioEvent(AudioEvent.PAUSE_AMBIENT,this._alarmSound));
               }
               else
               {
                  dispatchEvent(new AudioEvent(AudioEvent.RESUME_AMBIENT,this._alarmSound));
               }
            }
         }
         this.lastAppear = this._world.main.menuAppear;
      }
      
      override protected function Removed(param1:Event) : void
      {
         super.Removed(param1);
         if(this._repairingSymbol != null)
         {
            if(this._repairingSymbol.parent != null)
            {
               this._repairingSymbol.parent.removeChild(this._repairingSymbol);
            }
         }
      }
      
      function checkAnimateAlarm(param1:LoopEvent) : void
      {
         var _loc2_:ColorTransform = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(!this._upgradeMode)
         {
            if(this._alarmTrigger)
            {
               _loc2_ = this.transform.colorTransform;
               _loc3_ = _loc2_.greenMultiplier;
               _loc4_ = _loc2_.blueMultiplier;
               if(_loc3_ >= 1)
               {
                  this.alarmFx = -0.08;
               }
               else if(_loc3_ <= 0.6)
               {
                  this.alarmFx = 0.08;
               }
               else if(isNaN(this.alarmFx))
               {
                  this.alarmFx = -0.08;
               }
               _loc3_ = Math.max(0.6,Math.min(1,_loc3_ + this.alarmFx));
               _loc4_ = Math.max(0.6,Math.min(1,_loc4_ + this.alarmFx));
               _loc2_.greenMultiplier = _loc3_;
               _loc2_.blueMultiplier = _loc4_;
               this.transform.colorTransform = _loc2_;
            }
            else if(this.lastTrigger)
            {
               this.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
            }
         }
         this.lastTrigger = this._alarmTrigger;
         if(this._repairingSymbol != null)
         {
            if(this._world.legendContainer.getChildByName(this._repairingSymbol.name) != null)
            {
               if(this._repairingSymbol.currentFrame < this._repairingSymbol.totalFrames)
               {
                  this._repairingSymbol.nextFrame();
               }
               else
               {
                  this._repairingSymbol.gotoAndStop(1);
               }
            }
         }
      }
      
      function upgradeBuilding(param1:CommandEvent) : void
      {
         var _loc2_:* = this._world.main;
         if(_loc2_.isEnough(this._upgradeCost) || this is FacilityElevatorBody)
         {
            if(!this._upgradeMode)
            {
               if(this._level < this._maxLevel)
               {
                  this._upgradeMode = true;
                  this._upgradeState = true;
                  addListenerOf(this,LoopEvent.ON_IDLE,this.flashingAnimate);
                  this.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
                  dispatchEvent(new GameEvent(GameEvent.BECOMES_UPGRADE));
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
         var _loc7_:DoorSymbol = null;
         var _loc8_:DoorSymbol = null;
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
            this.beforeUpgradeCheck();
            _loc7_ = this.door;
            removeListenerOf(this,LoopEvent.ON_IDLE,this.flashingAnimate);
            ++this._level;
            this.gotoAndStop(this._level);
            this._upgradeState = false;
            if(_loc7_ != null)
            {
               if((_loc8_ = this.door) != null)
               {
                  _loc8_.gotoAndStop(_loc7_.currentFrame);
                  _loc8_.checkOpenClose();
                  if(_loc7_.animateOpen != 0)
                  {
                     if(_loc7_.animateOpen > 0)
                     {
                        _loc8_.openTheDoor();
                     }
                     else
                     {
                        _loc8_.closeTheDoor();
                     }
                  }
               }
            }
            this._exp = 0;
            this._expCarry = 0;
            this.afterUpgradeCheck();
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
      
      function beforeUpgradeCheck() : void
      {
      }
      
      function setUpgradeCost() : void
      {
         this._upgradeCost = BuildingData.getBuildingCost(BuildingData.returnClassTo(Utility.getClass(this)),this._level);
         this._relocateCost = BuildingData.getRelocateCost(this);
      }
      
      function afterUpgradeCheck() : void
      {
         this.removeChildAnimation();
         this._capacity = BuildingData.getCapacity(this);
         this.setUpgradeCost();
         if(this._brokenClip != null)
         {
            if(getChildByName(this._brokenClip.name))
            {
               setChildIndex(this._brokenClip,numChildren - 1);
            }
         }
         addListenerOf(this,LoopEvent.ON_IDLE,this.unflashingAnimate);
         this.initChildAnimation();
         dispatchEvent(new GameEvent(GameEvent.BUILDING_SUCCESSFULLY_UPGRADE));
      }
      
      function openDoorCheck(param1:GameEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(!(this is FacilityElevatorBody))
         {
            if(this.numChildren > 0)
            {
               _loc2_ = this.getChildAt(0);
               if(_loc2_ is MovieClip)
               {
                  _loc3_ = _loc2_.getChildByName("door") as DoorSymbol;
                  if(_loc3_ != null)
                  {
                     if(_loc3_.isOpen)
                     {
                        if(this.delayAfterOpen > 0)
                        {
                           --this.delayAfterOpen;
                        }
                        else
                        {
                           this.closeTheDoor();
                        }
                     }
                  }
               }
            }
         }
      }
      
      function removeChildAnimation() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.numChildren > 0)
         {
            _loc1_ = this.getChildAt(0);
            if(_loc1_ is MovieClip)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_.numChildren)
               {
                  _loc3_ = _loc1_.getChildAt(_loc2_);
                  if(_loc3_ is MovieClip && !(_loc3_ is SEMovieClip))
                  {
                     if(_loc3_.totalFrames > 0)
                     {
                        _loc3_.stop();
                        removeListenerOf(_loc3_,LoopEvent.ON_IDLE,this.animateChildren);
                     }
                  }
                  _loc2_++;
               }
            }
            if(this._brokenClip != null)
            {
               this._brokenClip.stop();
               removeListenerOf(this._brokenClip,LoopEvent.ON_IDLE,this.animateChildren);
               _loc2_ = 0;
               while(_loc2_ < this._brokenClip.numChildren)
               {
                  _loc3_ = this._brokenClip.getChildAt(_loc2_);
                  if(_loc3_ is MovieClip && !(_loc3_ is SEMovieClip))
                  {
                     if(_loc3_.totalFrames > 0)
                     {
                        _loc3_.stop();
                        removeListenerOf(_loc3_,LoopEvent.ON_IDLE,this.animateChildren);
                     }
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      function initChildAnimation() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.numChildren > 0)
         {
            _loc1_ = this.getChildAt(0);
            if(_loc1_ is MovieClip)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_.numChildren)
               {
                  _loc3_ = _loc1_.getChildAt(_loc2_);
                  if(_loc3_ is MovieClip && !(_loc3_ is SEMovieClip))
                  {
                     if(_loc3_.totalFrames > 0)
                     {
                        _loc3_.stop();
                        addListenerOf(_loc3_,LoopEvent.ON_IDLE,this.animateChildren);
                     }
                  }
                  _loc2_++;
               }
            }
            if(this._brokenClip != null)
            {
               this._brokenClip.stop();
               addListenerOf(this._brokenClip,LoopEvent.ON_IDLE,this.animateChildren);
               _loc2_ = 0;
               while(_loc2_ < this._brokenClip.numChildren)
               {
                  _loc3_ = this._brokenClip.getChildAt(_loc2_);
                  if(_loc3_ is MovieClip && !(_loc3_ is SEMovieClip))
                  {
                     if(_loc3_.totalFrames > 0)
                     {
                        _loc3_.stop();
                        addListenerOf(_loc3_,LoopEvent.ON_IDLE,this.animateChildren);
                     }
                  }
                  _loc2_++;
               }
            }
         }
      }
      
      function updateBrokenCheck(param1:GameEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc2_:* = false;
         if(!this._needRepair)
         {
            if(this.brokenLevel >= this._brokenTreshold)
            {
               this._needRepair = true;
            }
         }
         else if(this.brokenLevel <= 0)
         {
            this._needRepair = false;
            _loc2_ = true;
         }
         if(!this._isBroken)
         {
            if(this.brokenLevel >= 100)
            {
               this._isBroken = true;
               if(this._brokenClip != null)
               {
                  if(this._brokenClip.stage == null)
                  {
                     this._brokenClip.alpha = 1;
                     addChild(this._brokenClip);
                  }
               }
               dispatchEvent(new GameEvent(GameEvent.BUILDING_BROKEN));
            }
         }
         else if(this._brokenClip.stage != null)
         {
            if(this.brokenLevel > 0)
            {
               this._brokenClip.alpha = Math.min(1,Math.max(this.brokenLevel / this._brokenTreshold));
            }
            else
            {
               _loc2_ = true;
               this._isBroken = false;
               this._brokenClip.parent.removeChild(this._brokenClip);
            }
         }
         var _loc3_:* = false;
         var _loc4_:* = 0;
         while(_loc4_ < this._humanList.length)
         {
            if((_loc5_ = this._humanList[_loc4_]) is StaffHandyman)
            {
               if(_loc5_.doingJob && !_loc5_.recovery)
               {
                  _loc3_ = true;
                  break;
               }
            }
            _loc4_++;
         }
         if(_loc3_)
         {
            if(this._world.legendContainer.getChildByName(this._repairingSymbol.name) == null)
            {
               this._repairingSymbol.x = this.x;
               this._repairingSymbol.y = this.y - this.height / 2;
               this._world.legendContainer.addChild(this._repairingSymbol);
            }
         }
         else if(this._world.legendContainer.getChildByName(this._repairingSymbol.name) != null)
         {
            this._world.legendContainer.removeChild(this._repairingSymbol);
         }
         if(_loc2_)
         {
            this._world.main.updateHistory("repair");
            dispatchEvent(new GameEvent(GameEvent.BUILDING_REPAIRED));
         }
      }
      
      function animateChildren(param1:LoopEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.currentFrame < _loc2_.totalFrames)
         {
            _loc2_.nextFrame();
         }
         else
         {
            _loc2_.gotoAndStop(1);
         }
      }
      
      public function openTheDoor() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.numChildren > 0)
         {
            _loc1_ = this.getChildAt(0);
            _loc2_ = _loc1_.getChildByName("door") as DoorSymbol;
            if(_loc2_ != null)
            {
               _loc2_.openTheDoor();
               this.delayAfterOpen = 12;
            }
         }
      }
      
      public function closeTheDoor() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.numChildren > 0)
         {
            _loc1_ = this.getChildAt(0);
            _loc2_ = _loc1_.getChildByName("door") as DoorSymbol;
            if(_loc2_ != null)
            {
               _loc2_.closeTheDoor();
            }
         }
      }
      
      public function get door() : DoorSymbol
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = null;
         if(this.numChildren > 0)
         {
            _loc2_ = this.getChildAt(0);
            _loc3_ = _loc2_.getChildByName("door");
            if(_loc3_ != null)
            {
               _loc1_ = _loc3_ as DoorSymbol;
            }
         }
         return _loc1_;
      }
      
      function buildingOnClick(param1:MouseEvent) : void
      {
      }
      
      public function loadCondition(param1:*) : void
      {
         this._buildingHP = param1.buildingHP;
         this._isBroken = param1.isBroken;
         this._needRepair = param1.needRepair;
         if(this.currentFrame != this._level)
         {
            this.gotoAndStop(this._level);
         }
      }
      
      public function saveCondition(param1:*) : void
      {
         param1.buildingHP = this._buildingHP;
         param1.isBroken = this._isBroken;
         param1.needRepair = this._needRepair;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function addPerson(param1:*, param2:Boolean = false) : void
      {
         if(this._humanList.indexOf(param1) < 0)
         {
            this._humanList.push(param1);
         }
      }
      
      public function removePerson(param1:*) : void
      {
         var _loc2_:* = this._humanList.indexOf(param1);
         if(_loc2_ in this._humanList)
         {
            this._humanList.splice(_loc2_,1);
         }
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
      
      public function get enterancePosition() : Point
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.numChildren > 0)
         {
            _loc1_ = this.getChildAt(0);
            _loc2_ = _loc1_.getChildByName("door");
            if(_loc2_ != null)
            {
               _loc3_ = this._world.mainContainer.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
               _loc4_ = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
               return new Point(_loc3_.x,_loc4_.y);
            }
            if((_loc5_ = _loc1_.getChildByName("insideClip")) != null)
            {
               return this._world.mainContainer.globalToLocal(_loc5_.localToGlobal(new Point(0,0)));
            }
            return this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         }
         return this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
      }
      
      public function get openCloseProgress() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.numChildren > 0)
         {
            _loc1_ = this.getChildAt(0);
            _loc2_ = _loc1_.getChildByName("door") as DoorSymbol;
            if(_loc2_ != null)
            {
               return !_loc2_.isOpen && !_loc2_.isClose;
            }
            return false;
         }
         return false;
      }
      
      public function get enableToEnter() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.numChildren > 0)
         {
            _loc1_ = this.getChildAt(0);
            _loc2_ = _loc1_.getChildByName("door") as DoorSymbol;
            if(_loc2_ != null)
            {
               return _loc2_.isOpen;
            }
            return true;
         }
         return false;
      }
      
      public function get enteranceRange() : Number
      {
         return this._enteranceRange;
      }
      
      public function set brokenTreshold(param1:Number) : void
      {
         this._brokenTreshold = param1;
      }
      
      public function get brokenTreshold() : Number
      {
         return this._brokenTreshold;
      }
      
      public function get brokenLevel() : Number
      {
         return (1 - this._buildingHP / this._buildingMaxHP) * 100;
      }
      
      public function set buildingHP(param1:int) : void
      {
         this._buildingHP = Math.min(this._buildingMaxHP,Math.max(0,param1));
      }
      
      public function get buildingHP() : int
      {
         return this._buildingHP;
      }
      
      public function get needRepair() : Boolean
      {
         return this._needRepair;
      }
      
      public function get isBroken() : Boolean
      {
         return this._isBroken;
      }
      
      public function get insideRegion() : *
      {
         return this._insideRegion;
      }
      
      public function get humanContainer() : MovieClip
      {
         return this._humanContainer;
      }
      
      public function get serveMode() : String
      {
         return this._serveMode;
      }
      
      public function get humanList() : Array
      {
         return this._humanList;
      }
      
      public function get capacity() : Number
      {
         return this._capacity;
      }
      
      public function get maxLevel() : int
      {
         return this._maxLevel;
      }
      
      public function get destroyable() : Boolean
      {
         return this._destroyable;
      }
      
      public function get upgradeMode() : Boolean
      {
         return this._upgradeMode;
      }
      
      public function get upgradeState() : Boolean
      {
         return this._upgradeState;
      }
      
      public function set buildingName(param1:String) : void
      {
         this._buildingName = param1;
      }
      
      public function get buildingName() : String
      {
         return this._buildingName;
      }
      
      public function get upgradeCost() : Number
      {
         return this._upgradeCost;
      }
      
      public function get relocateCost() : Number
      {
         var _loc1_:* = 0;
         if("relocateDiscount" in this._world.upgradeModifier)
         {
            _loc1_ = 1 - this._world.upgradeModifier["relocateDiscount"];
         }
         return Math.round(this._relocateCost * _loc1_);
      }
      
      public function initExp(param1:Number) : void
      {
         this._exp = Math.floor(param1);
         this._expCarry = Math.ceil(param1 * 10) % 10;
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
      
      public function get numberPeople() : int
      {
         return this._humanList.length;
      }
      
      public function set alarmTrigger(param1:Boolean) : void
      {
         this._alarmTrigger = param1;
         if(this._alarmTrigger)
         {
            if(this._alarmSound == null)
            {
               this._alarmSound = new Object();
               this._alarmSound.sfx = SFX_Bell;
               this._alarmSound.loopPos = 312;
               dispatchEvent(new AudioEvent(AudioEvent.PLAY_AMBIENT,this._alarmSound));
            }
         }
         else if(this._alarmSound != null)
         {
            dispatchEvent(new AudioEvent(AudioEvent.STOP_AMBIENT,this._alarmSound));
            this._alarmSound = null;
         }
      }
      
      public function get alarmTrigger() : Boolean
      {
         return this._alarmTrigger;
      }
      
      public function get rWidth() : Number
      {
         return this._rWidth;
      }
   }
}
