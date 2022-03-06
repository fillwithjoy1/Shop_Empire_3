package Instance.gameplay
{
   import Instance.SEMovieClip;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import Instance.property.Booth;
   import Instance.property.Building;
   import Instance.property.Elevator;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityStairs;
   import Instance.property.FacilityTerrace;
   import Instance.property.HalteWagon;
   import Instance.property.HumanStat;
   import Instance.property.InnEnterance;
   import Instance.property.InsideRestroom;
   import Instance.property.Wagon;
   import Instance.sprite.Animation;
   import Instance.ui.DialogBox;
   import Instance.ui.DialogTextBox;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Human extends SEMovieClip
   {
       
      
      public const MAX_VITALITY = 1000;
      
      var _destination;
      
      var _destinationTransport;
      
      var _floorTarget;
      
      var _floorPoint:Point;
      
      var _inside;
      
      var _movePoint:Point;
      
      var _baseHome:int;
      
      var _currentAnimation:String;
      
      var _stat:HumanStat;
      
      var _vitality:int;
      
      var _exp:int;
      
      var _fatigue:Boolean;
      
      var nextFrameQueue;
      
      var _floorStep;
      
      var _upperFloor;
      
      var _transportQueue:Array;
      
      var _world:World;
      
      var _model:String;
      
      var _inHome:Boolean;
      
      var _run:Boolean;
      
      var _mood:Number;
      
      var _passive:Boolean;
      
      var _dialogIconBox:DialogBox;
      
      var _dialogChatBox:DialogTextBox;
      
      var _relatedCritter;
      
      public function Human()
      {
         super();
         this._baseHome = Math.floor(Math.random() * 2) * 2 - 1;
         priority = 3;
         this.initStat();
         this._transportQueue = new Array();
         stop();
         this._dialogIconBox = new DialogIconBox();
         this._dialogIconBox.relation = this;
         this._dialogIconBox.yDistance = this.height + 5;
         this._dialogChatBox = new LegendDialogTextBox();
         this._dialogChatBox.relation = this;
         this._dialogChatBox.yDistance = this.height + 5;
         this._passive = false;
      }
      
      function initStat() : void
      {
         this._stat = new HumanStat();
         this._stat.speed = Math.floor(Math.random() * 100) + 1;
         this._stat.stamina = Math.floor(Math.random() * 100) + 1;
         this._stat.sight = Math.floor(Math.random() * 100) + 1;
         this._stat.hygine = Math.floor(Math.random() * 100) + 1;
         this._stat.entertain = Math.floor(Math.random() * 100) + 1;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.checkFloorStep();
         addListenerOf(this,Event.ENTER_FRAME,this.spriteCheck);
         addListenerOf(this,HumanEvent.UPDATE_BEHAVIOR,this.behavior);
         addListenerOf(this,HumanEvent.ENTER_THE_BUILDING,this.whenEnterTheBuilding);
         addListenerOf(this,HumanEvent.EXIT_THE_BUILDING,this.whenExitTheBuilding);
         addListenerOf(this,LoopEvent.ON_IDLE,this.animationCheck);
         addListenerOf(this,LoopEvent.ON_IDLE,this.movingCheck);
         addListenerOf(this._world,GameEvent.BUILDING_DESTROYED,this.buildingIsDestroyed);
         addListenerOf(this,HumanEvent.CHANGE_INSIDE,this.replaceInside);
         addListenerOf(this,HumanEvent.EXILE,this.whenExile);
      }
      
      function whenExile(param1:HumanEvent) : void
      {
         if(this._dialogIconBox.stage != null)
         {
            this._dialogIconBox.parent.removeChild(this._dialogIconBox);
         }
         if(this._dialogChatBox.stage != null)
         {
            this._dialogChatBox.parent.removeChild(this._dialogChatBox);
         }
      }
      
      function replaceInside(param1:HumanEvent) : void
      {
         this._inside = param1.tag;
      }
      
      function buildingIsDestroyed(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:* = param1.tag;
         if(_loc2_ == this._inside)
         {
            _loc3_ = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            if(_loc2_ is Elevator)
            {
               _loc2_.removePerson(this);
               _loc4_ = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(1,0)));
               this.x = _loc3_.x;
               this.y = _loc3_.y;
               if(_loc4_.x > _loc3_.x)
               {
                  this.scaleX = 1;
               }
               else
               {
                  this.scaleX = -1;
               }
               this._world.addHuman(this);
               this._inside = null;
            }
            else
            {
               dispatchEvent(new HumanEvent(HumanEvent.EXIT_THE_BUILDING,_loc2_));
            }
            if(this.onFloor == null)
            {
               _loc5_ = null;
               _loc6_ = Infinity;
               _loc7_ = 0;
               while(_loc7_ < this._world.floorList.length)
               {
                  _loc8_ = this._world.floorList[_loc7_];
                  if((_loc9_ = Math.abs(_loc8_.y - _loc3_.y)) < _loc6_)
                  {
                     if(_loc3_.x >= _loc8_.left && _loc3_.x <= _loc8_.right)
                     {
                        _loc5_ = _loc8_;
                        _loc6_ = _loc9_;
                     }
                  }
                  _loc7_++;
               }
               if(_loc5_ == null)
               {
                  _loc7_ = 0;
                  while(_loc7_ < this._world.basementFloorList.length)
                  {
                     if((_loc8_ = this._world.basementFloorList[_loc7_]) != this._world.topFloorBasement)
                     {
                        if((_loc9_ = Math.abs(_loc8_.y - _loc3_.y)) < _loc6_)
                        {
                           if(_loc3_.x >= _loc8_.left && _loc3_.x <= _loc8_.right)
                           {
                              _loc5_ = _loc8_;
                              _loc6_ = _loc9_;
                           }
                        }
                     }
                     _loc7_++;
                  }
               }
               if(_loc5_ != null)
               {
                  this.y = _loc5_.y;
                  this._floorStep = _loc5_;
               }
            }
         }
         if(_loc2_ == this._destination)
         {
            this._destination = null;
            this._movePoint = null;
            if(this._inside == null)
            {
               this._floorTarget = null;
               this._floorPoint = null;
               this._destinationTransport = null;
               this._transportQueue = new Array();
            }
         }
         if(this._transportQueue.indexOf(_loc2_) >= 0)
         {
            this._destinationTransport = null;
            this._transportQueue = new Array();
         }
      }
      
      function spriteCheck(param1:Event) : void
      {
         var _loc2_:* = undefined;
         if(numChildren > 0)
         {
            _loc2_ = this.getChildAt(0);
            if(_loc2_ != null)
            {
               if(Utility.hasLabel(_loc2_,this._model))
               {
                  _loc2_.gotoAndStop(this._model);
               }
            }
            dispatchEvent(new HumanEvent(HumanEvent.SPRITE_CORRECTION));
         }
      }
      
      function showDialogIconBox(param1:String, param2:String, param3:Number) : void
      {
         if(this._dialogChatBox.stage == null)
         {
            if(this._dialogIconBox.stage == null)
            {
               this._dialogIconBox.delay = param3;
               this._dialogIconBox.iconType = param1;
               this._dialogIconBox.iconSign = param2;
               this._world.legendContainer.addChild(this._dialogIconBox);
            }
         }
      }
      
      function showDialogConversationBox(param1:String, param2:Number) : void
      {
         if(param1.length > 0 && param1 != null)
         {
            if(this._dialogIconBox.stage != null)
            {
               this._world.legendContainer.removeChild(this._dialogIconBox);
            }
            if(this._dialogChatBox.stage == null)
            {
               this._dialogChatBox.delay = param2;
               this._dialogChatBox.text = param1;
               this._dialogChatBox.animate = false;
               this._world.conversationContainer.addChild(this._dialogChatBox);
               this.dispatchEvent(new GameEvent(GameEvent.ADD_CHAT_LOG,param1));
            }
         }
      }
      
      function checkFloorStep() : void
      {
         var _loc1_:* = undefined;
         if(this._world != null)
         {
            this._floorStep = this.onFloor;
            this._upperFloor = null;
            _loc1_ = this._world.floorList.indexOf(this._floorStep);
            if(_loc1_ in this._world.floorList)
            {
               if(_loc1_ + 1 in this._world.floorList)
               {
                  this._upperFloor = this._world.floorList[_loc1_ + 1];
               }
            }
            else
            {
               _loc1_ = this._world.basementFloorList.indexOf(this._floorStep);
               if(_loc1_ in this._world.basementFloorList)
               {
                  if(_loc1_ - 1 in this._world.basementFloorList)
                  {
                     this._upperFloor = this._world.basementFloorList[_loc1_ - 1];
                  }
               }
            }
         }
      }
      
      public function get insideMall() : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc1_:* = false;
         if(this._inside == null)
         {
            _loc2_ = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            if(this._world.getBasementFloorAt(_loc2_.y) == null)
            {
               _loc3_ = this._world.getFloorAt(_loc2_.y);
               if((_loc4_ = this._world.floorList.indexOf(_loc3_)) + 1 in this._world.floorList)
               {
                  _loc5_ = this._world.floorList[_loc4_ + 1];
                  if(_loc2_.x >= _loc5_.left && _loc2_.x <= _loc5_.right)
                  {
                     _loc1_ = true;
                  }
               }
            }
            else
            {
               _loc1_ = true;
            }
         }
         else
         {
            _loc1_ = true;
         }
         return _loc1_;
      }
      
      function behavior(param1:HumanEvent) : void
      {
         if(!this._passive)
         {
            if(!this._inHome)
            {
               this.destinationTargetCheck();
               this.differentFloorTargetCheck();
               this.insideBuildingCheck();
            }
            else
            {
               this.inHomeBehaviorCheck();
            }
         }
      }
      
      function insideBuildingCheck() : void
      {
         if(this._inside != null)
         {
            this.insideHalteCheck();
            this.insideStairsCheck();
            this.insideElevatorCheck();
            this.insideDungeonCheck();
            this.insideBoothCheck();
         }
         else if(this._destination == "exit")
         {
            this._destination = null;
         }
      }
      
      function insideDungeonCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this._inside == this._world.dungeon)
         {
            _loc1_ = this._floorTarget;
            if(this._world.basementFloorList.indexOf(this._floorTarget) < 0)
            {
               _loc1_ = this._world.floorList[0];
            }
            if(_loc1_ != null)
            {
               _loc2_ = (this.getSpeed() + this.runSpeed()) * 5;
               _loc3_ = Math.abs(_loc1_.y - this.y);
               if(_loc3_ - _loc2_ > 0)
               {
                  _loc4_ = _loc2_ / _loc3_;
                  this.y += _loc4_ * (_loc1_.y - this.y);
               }
               else
               {
                  this.y = _loc1_.y;
                  if((_loc5_ = this._world.getConnectionAt(this.y)) != null)
                  {
                     if(_loc5_.enableToEnter)
                     {
                        dispatchEvent(new HumanEvent(HumanEvent.EXIT_THE_BUILDING,_loc5_));
                     }
                     else if((_loc6_ = _loc5_.door) != null)
                     {
                        if(_loc6_.isClose)
                        {
                           _loc5_.openTheDoor();
                        }
                     }
                  }
               }
            }
         }
      }
      
      function insideBoothCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this._inside != null && this._inside != this._world.dungeon && !(this._inside is Wagon || this._inside is HalteWagon))
         {
            if(this._world.transportList.indexOf(this._inside) < 0 && !(this._inside is FacilityElevatorBody))
            {
               if(this._destination != null && this._destination != this._inside)
               {
                  _loc1_ = this._inside.enterancePosition;
                  _loc2_ = this.parent.globalToLocal(this._world.mainContainer.localToGlobal(_loc1_));
                  _loc3_ = Math.abs(_loc2_.x - this.x);
                  _loc4_ = this._inside.enteranceRange;
                  if(_loc3_ > _loc4_)
                  {
                     if(this._movePoint == null || this._movePoint.x < _loc2_.x - _loc4_ && this._movePoint.x > _loc2_.x + _loc4_ && this._movePoint.y != _loc2_.y)
                     {
                        this._movePoint = new Point(_loc2_.x,_loc2_.y);
                     }
                  }
                  else
                  {
                     this._movePoint = null;
                     _loc5_ = true;
                     if(!(this._inside is FacilityTerrace))
                     {
                        if(this._inside.employeeContainer != null && this._inside.employeeContainer.getChildByName(this.name) != null)
                        {
                           _loc5_ = false;
                        }
                     }
                     if(!_loc5_ || this._inside.enableToEnter)
                     {
                        dispatchEvent(new HumanEvent(HumanEvent.EXIT_THE_BUILDING,this._inside));
                     }
                     else if((_loc6_ = this._inside.door) != null)
                     {
                        if(_loc6_.isClose)
                        {
                           this._inside.openTheDoor();
                        }
                     }
                  }
               }
            }
         }
      }
      
      function insideHalteCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this._inside is HalteWagon)
         {
            _loc1_ = this._inside.currentWagon;
            if(_loc1_ == null || Math.abs(_loc1_.x - _loc1_.dropPosition.x) >= 30)
            {
               _loc2_ = this._inside.dropPointL;
               _loc3_ = this._inside.dropPointR;
               _loc4_ = Math.abs(this._inside.dropPointL.x - this.x);
               _loc5_ = Math.abs(this._inside.dropPointR.x - this.x);
               _loc6_ = null;
               if(_loc4_ > _loc5_)
               {
                  _loc6_ = _loc3_;
               }
               else if(_loc4_ < _loc5_)
               {
                  _loc6_ = _loc2_;
               }
               else
               {
                  _loc6_ = !!Calculate.chance(50) ? _loc2_ : _loc3_;
               }
               if((_loc7_ = Math.abs(_loc6_.x - this.x)) > 0)
               {
                  this._movePoint = _loc6_;
               }
               else
               {
                  this._inside.removePerson(this);
                  this._world.addHuman(this);
                  this._inside = null;
               }
            }
         }
      }
      
      function insideStairsCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this._inside is FacilityStairs)
         {
            if(this._movePoint == null)
            {
               if(this._floorTarget != null)
               {
                  _loc1_ = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
                  if(this._floorTarget.y < _loc1_.y)
                  {
                     _loc2_ = this._inside.upperEnterance;
                  }
                  else if(this._floorTarget.y > _loc1_.y)
                  {
                     _loc2_ = this._inside.lowerEnterance;
                  }
                  else
                  {
                     _loc2_ = this._inside.entrancePosition(this._floorTarget.y);
                  }
                  if(Math.abs(_loc2_.x - _loc1_.x) > 0)
                  {
                     this._movePoint = this._inside.globalToLocal(this._world.mainContainer.localToGlobal(_loc2_));
                  }
                  else
                  {
                     this._inside.correctPosition(this);
                     dispatchEvent(new HumanEvent(HumanEvent.EXIT_THE_BUILDING,this._inside));
                  }
               }
            }
         }
      }
      
      function insideElevatorCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this._inside is Elevator)
         {
            if(this._transportQueue.length > 0)
            {
               _loc1_ = this._transportQueue[0];
               if(this._inside.activeRoom != _loc1_)
               {
                  if(_loc1_ is FacilityElevatorBody)
                  {
                     this._inside.putTarget(_loc1_);
                  }
                  _loc2_ = this._inside.escapePassanger.indexOf(this);
                  if(_loc2_ >= 0)
                  {
                     this._inside.escapePassanger.splice(_loc2_,1);
                  }
               }
               else if(this._inside.escapePassanger.indexOf(this) < 0)
               {
                  this._inside.escapePassanger.push(this);
               }
               else if(_loc1_.enableToEnter)
               {
                  _loc3_ = this.parent.globalToLocal(this._world.mainContainer.localToGlobal(_loc1_.enterancePosition));
                  if((_loc4_ = Math.abs(_loc3_.x - this.x)) > 0)
                  {
                     if(this._movePoint == null || this._movePoint.x != _loc3_.x)
                     {
                        this._movePoint = new Point(_loc3_.x,_loc3_.y);
                     }
                  }
                  else
                  {
                     this._inside.removePerson(this);
                     dispatchEvent(new HumanEvent(HumanEvent.EXIT_THE_BUILDING,_loc1_));
                  }
               }
            }
         }
         if(this._inside is FacilityElevatorBody)
         {
            if((_loc5_ = this._inside.elevatorLink).passanger.indexOf(this) >= 0)
            {
               if((_loc4_ = Math.abs(this._inside.enterancePosition.x - this.x)) > 0)
               {
                  if(this._movePoint == null || this._movePoint.x != this._inside.enterancePosition.x)
                  {
                     this._movePoint = new Point(this._inside.enterancePosition.x,this._inside.enterancePosition.y);
                  }
               }
               else
               {
                  this._inside.removePerson(this);
                  if((_loc6_ = this._transportQueue.indexOf(this._inside)) in this._transportQueue)
                  {
                     this._transportQueue.splice(_loc6_,1);
                  }
                  dispatchEvent(new HumanEvent(HumanEvent.ENTER_THE_BUILDING,_loc5_));
               }
            }
            else if((_loc4_ = Math.abs(this._inside.enterancePosition.y - _loc5_.room.y)) > 0)
            {
               if(_loc5_.roomTarget.indexOf(this._inside) < 0)
               {
                  _loc5_.putTarget(this._inside);
               }
            }
            else if(_loc5_.roomTarget.length == 0)
            {
               _loc5_.putTarget(this._inside);
            }
         }
      }
      
      public function inSight(param1:*) : Boolean
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc2_:* = false;
         var _loc3_:* = this.getSight();
         var _loc4_:* = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc5_:*;
         var _loc6_:* = (_loc5_ = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(1,0)))).x > _loc4_.x ? 1 : -1;
         if(param1 is Building && !(param1 is FacilityStairs))
         {
            _loc7_ = param1.x - param1.width / 2;
            _loc8_ = param1.x + param1.width / 2;
            if(_loc7_ <= _loc4_.x && _loc4_.x <= _loc8_)
            {
               _loc2_ = true;
            }
            else if((_loc9_ = Math.min(Math.abs(_loc7_ - _loc4_.x),Math.abs(_loc8_ - _loc4_.x))) <= _loc3_)
            {
               if(_loc7_ > _loc4_.x)
               {
                  _loc2_ = _loc6_ > 0;
               }
               else if(_loc8_ < _loc4_.x)
               {
                  _loc2_ = _loc6_ < 0;
               }
            }
         }
         else if((_loc10_ = this._world.mainContainer.globalToLocal(param1.localToGlobal(new Point(0,0)))).x == _loc4_.x)
         {
            _loc2_ = true;
         }
         else if((_loc9_ = Math.abs(_loc10_.x - _loc4_.x)) <= _loc3_)
         {
            if(_loc10_.x > _loc4_.x)
            {
               _loc2_ = _loc6_ > 0;
            }
            else if(_loc10_.x < _loc4_.x)
            {
               _loc2_ = _loc6_ < 0;
            }
         }
         return _loc2_;
      }
      
      function inHomeBehaviorCheck() : void
      {
         if(this.visible)
         {
            this.visible = false;
         }
      }
      
      function whenEnterTheBuilding(param1:HumanEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this._world.dungeonConnection.indexOf(param1.tag) < 0)
         {
            this.currentAnimation = Animation.IDLE;
            this._inside = param1.tag;
            this._inside.addPerson(this);
            if(this._inside is FacilityElevatorBody)
            {
               _loc2_ = this._inside.elevatorLink;
               _loc3_ = Math.abs(_loc2_.room.y - this._inside.y);
               _loc4_ = Math.round((this._inside.enterancePosition.x + Math.round(Math.random() * 60) - 30) * 10) / 10;
               if(_loc3_ > 0)
               {
                  this._movePoint = new Point(_loc4_,this._inside.enterancePosition.y);
               }
               else
               {
                  _loc5_ = this._inside.queueLine.indexOf(this);
                  if(_loc2_.passanger.length - _loc2_.escapePassanger.length + _loc5_ >= _loc2_.capacityLimit)
                  {
                     this._movePoint = new Point(_loc4_,this._inside.enterancePosition.y);
                  }
               }
            }
            if(this._inside is Elevator)
            {
               _loc6_ = Math.round((Math.random() * 60 - 30) * 10) / 10;
               this._movePoint = new Point(_loc6_,0);
            }
            if(this._inside is Booth || this._inside is FacilityTerrace || this._inside is InsideRestroom)
            {
               if((_loc7_ = this._inside.door) != null)
               {
                  if(!_loc7_.isClose)
                  {
                     this._inside.closeTheDoor();
                  }
               }
            }
         }
         else
         {
            while(this._transportQueue.indexOf("connection") >= 0)
            {
               this._transportQueue.splice(this._transportQueue.indexOf("connection"),1);
            }
            param1.tag.closeTheDoor();
            this._inside = this._world.dungeon;
            this._world.dungeon.addChild(this);
         }
      }
      
      function whenExitTheBuilding(param1:HumanEvent) : void
      {
         var _loc6_:* = undefined;
         this._inside = null;
         var _loc2_:* = param1.tag;
         var _loc3_:* = this._transportQueue.indexOf(_loc2_);
         if(_loc3_ in this._transportQueue)
         {
            this._transportQueue.splice(_loc3_,1);
         }
         _loc2_.removePerson(this);
         var _loc4_:* = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc5_:* = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(1,0)));
         this.x = _loc4_.x;
         this.y = _loc4_.y;
         if(_loc5_.x > _loc4_.x)
         {
            this.scaleX = 1;
         }
         else
         {
            this.scaleX = -1;
         }
         if(_loc2_ is Booth || _loc2_ is InnEnterance || _loc2_ is InsideRestroom)
         {
            if((_loc6_ = _loc2_.door) != null)
            {
               if(!_loc6_.isClose)
               {
                  _loc2_.closeTheDoor();
               }
            }
         }
         this._world.addHuman(this);
      }
      
      function noTargetCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this._movePoint == null)
         {
            _loc1_ = null;
            if(this._upperFloor != null)
            {
               _loc1_ = this._upperFloor;
            }
            else if(this._floorStep != null)
            {
               _loc1_ = this._floorStep;
            }
            if(_loc1_ != null)
            {
               _loc2_ = Math.round((Math.random() * (_loc1_.right - _loc1_.left) + _loc1_.left) * 10) / 10;
               this._movePoint = new Point(_loc2_,this.y);
            }
         }
      }
      
      function boothSearchCheck() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc1_:* = this._world.getFloorAt(this._destination.y);
         if(_loc1_ == null)
         {
            _loc1_ = this._world.getBasementFloorAt(this._destination.y);
         }
         var _loc2_:* = this._destination.enterancePosition;
         var _loc3_:* = false;
         if(_loc1_ == this._floorStep)
         {
            if(this._inside == null)
            {
               _loc3_ = true;
               this._floorTarget = null;
               _loc4_ = Math.abs(this.x - _loc2_.x);
               _loc5_ = this._destination.enteranceRange;
               if(_loc4_ > _loc5_)
               {
                  if(this._movePoint == null || (this._movePoint.x < _loc2_.x - _loc5_ || this._movePoint.x > _loc2_.x + _loc5_ || this._movePoint.y != _loc2_.y))
                  {
                     this._movePoint = new Point(_loc2_.x,_loc2_.y);
                  }
               }
               else
               {
                  this._movePoint = null;
                  _loc6_ = true;
                  if(this is Shopkeeper && this._destination.employeeContainer != null)
                  {
                     _loc6_ = false;
                  }
                  if(!_loc6_ || this._destination.enableToEnter)
                  {
                     dispatchEvent(new HumanEvent(HumanEvent.ENTER_THE_BUILDING,this._destination));
                     this._destination = null;
                  }
                  else if((_loc7_ = this._destination.door) != null)
                  {
                     if(_loc7_.isClose)
                     {
                        this._destination.openTheDoor();
                     }
                  }
               }
               this._destinationTransport = null;
               this._transportQueue = new Array();
            }
         }
         if(!_loc3_)
         {
            if(this._floorTarget == null || this._floorTarget != _loc1_)
            {
               this._floorTarget = _loc1_;
               this._floorPoint = new Point(_loc2_.x,_loc2_.y);
               this._destinationTransport = null;
               this._transportQueue = new Array();
            }
         }
      }
      
      function destinationTargetCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this._destination != null)
         {
            if(this._destination is Booth || this._destination is FacilityTerrace)
            {
               this.boothSearchCheck();
            }
            else if(this._destination == "home" || this._destination == "runAway")
            {
               _loc1_ = this._baseHome < 0 ? this._world.mostLeft - 10 : this._world.mostRight + 10;
               _loc2_ = true;
               if(this._floorStep == this._world.floorList[0])
               {
                  if(this._inside == null)
                  {
                     this._floorTarget = null;
                     _loc3_ = Math.abs(this.x - _loc1_);
                     if(_loc3_ > 0)
                     {
                        if(this._movePoint == null || this._movePoint.x != _loc1_)
                        {
                           this._movePoint = new Point(_loc1_,this.y);
                        }
                     }
                     else
                     {
                        this._movePoint = null;
                        this._inHome = true;
                        this._destination = null;
                        this.additionalCheckWhenHome();
                     }
                     this._destinationTransport = null;
                     this._transportQueue = new Array();
                  }
                  else if(this._world.transportList.indexOf(this._inside) >= 0 || this._inside is FacilityElevatorBody || this._inside == this._world.dungeon)
                  {
                     _loc2_ = false;
                  }
               }
               else
               {
                  _loc2_ = false;
               }
               if(!_loc2_)
               {
                  if(this._floorTarget == null || this._floorTarget != this._world.floorList[0])
                  {
                     this._floorTarget = this._world.floorList[0];
                     this._floorPoint = new Point(_loc1_,this._floorTarget.y);
                     this._destinationTransport = null;
                     this._transportQueue = new Array();
                  }
               }
            }
         }
         else
         {
            this.inTransportCheck();
         }
      }
      
      function inTransportCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         if(this._floorTarget == null)
         {
            if(this._destination == null)
            {
               if(this._inside == this._world.dungeon)
               {
                  this._floorTarget = this._world.floorList[0];
               }
               else
               {
                  _loc1_ = new Array();
                  if(this._inside is FacilityStairs)
                  {
                     _loc2_ = this._inside.upperEnterance;
                     _loc3_ = this._inside.lowerEnterance;
                     _loc4_ = new Array();
                     _loc5_ = this._world.getFloorAt(_loc2_.y);
                     _loc6_ = this._world.getFloorAt(_loc3_.y);
                     if(this._world.floorList.indexOf(_loc5_) >= 0 && this._world.floorList.indexOf(_loc5_) < this._world.floorList.length - 1)
                     {
                        _loc1_.push(_loc5_);
                     }
                     if(this._world.floorList.indexOf(_loc6_) >= 0 && this._world.floorList.indexOf(_loc6_) < this._world.floorList.length - 1)
                     {
                        _loc1_.push(_loc6_);
                     }
                  }
                  else if(this._inside is Elevator)
                  {
                     _loc7_ = 0;
                     while(_loc7_ < this._inside.bodyList.length)
                     {
                        _loc8_ = this._inside.bodyList[_loc7_];
                        if((_loc9_ = this._world.getFloorAt(_loc8_)) != null)
                        {
                           _loc1_.push(_loc9_);
                        }
                        _loc7_++;
                     }
                  }
                  if(_loc1_.length > 0)
                  {
                     _loc10_ = Math.floor(Math.random() * _loc1_.length);
                     this._floorTarget = _loc1_[_loc10_];
                  }
               }
            }
         }
      }
      
      function additionalCheckWhenHome() : void
      {
      }
      
      function gotoBasementEnterance() : void
      {
      }
      
      function searchTransportWhenOutside() : void
      {
         if(this._floorTarget != null)
         {
            if(this._floorTarget != this._floorStep)
            {
               this._transportQueue = this.searchTransport();
               if(this._transportQueue.length == 0)
               {
                  this._floorTarget = null;
                  if(this._floorPoint != null)
                  {
                     this._floorPoint = null;
                  }
                  this.noTargetCheck();
               }
            }
            else
            {
               this._floorTarget = null;
               if(this._floorPoint != null)
               {
                  this._movePoint = this._floorPoint;
                  this._floorPoint = null;
               }
               this.noTargetCheck();
            }
         }
      }
      
      function searchTransportWhenInsideStair() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this._inside is FacilityStairs)
         {
            if(this._floorTarget != null)
            {
               this._movePoint = null;
               _loc1_ = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
               _loc2_ = this._floorTarget;
               if(_loc1_.y > this._floorTarget.y)
               {
                  _loc2_ = this._world.getFloorAt(this._inside.upperEnterance.y);
               }
               else
               {
                  _loc2_ = this._world.getFloorAt(this._inside.lowerEnterance.y);
               }
               _loc3_ = this.searchAvailableTransport(_loc2_,this._floorTarget,this._inside.entrancePosition(_loc2_.y),this._floorPoint);
               this._transportQueue = _loc3_.queue;
               this._transportQueue.unshift(this._inside);
            }
         }
      }
      
      function searchTransportWhenInsideElevator() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         if(this._inside is Elevator)
         {
            if(this._floorTarget != null)
            {
               _loc1_ = this._inside.escapePassanger.indexOf(this);
               if(!(_loc1_ in this._inside.escapePassanger))
               {
                  _loc2_ = this._inside.getBodyOf(this._floorTarget.y);
                  if(_loc2_ != null)
                  {
                     this._transportQueue = [_loc2_];
                  }
                  else
                  {
                     _loc3_ = this._inside.highestRoom;
                     _loc4_ = this._inside.lowestRoom;
                     _loc5_ = Math.abs(this._floorTarget.y - _loc4_.y);
                     _loc6_ = Math.abs(this._floorTarget.y - _loc3_.y);
                     _loc7_ = this._world.getFloorAt(_loc3_.y);
                     _loc8_ = _loc3_;
                     if(_loc5_ > _loc6_)
                     {
                        _loc7_ = this._world.getFloorAt(_loc4_.y);
                        _loc8_ = _loc4_;
                     }
                     if(this._floorPoint == null)
                     {
                        this._floorPoint = new Point(Math.random() * (this._floorTarget.right - this._floorTarget.left) + this._floorTarget.left,this._floorTarget.y);
                     }
                     _loc9_ = this.searchAvailableTransport(_loc7_,this._floorTarget,_loc8_.enterancePosition,this._floorPoint);
                     this._transportQueue = _loc9_.queue;
                     if(this._transportQueue.length > 0)
                     {
                        if(this._transportQueue[0] == _loc8_)
                        {
                           this._transportQueue.shift();
                        }
                        else
                        {
                           this._transportQueue.unshift(_loc8_);
                        }
                     }
                  }
               }
               else
               {
                  trace("mau keluar tapi ga jadi");
                  this._inside.escapePassanger.splice(_loc1_,1);
               }
            }
            else
            {
               while(this._transportQueue.length > 0)
               {
                  this._transportQueue.shift();
               }
            }
         }
      }
      
      function searchTransportWhenWaitingElevator() : void
      {
         if(this._inside is FacilityElevatorBody)
         {
            if(this._floorTarget != null)
            {
               this._transportQueue = this.searchTransport();
               if(!(this._transportQueue.length > 0 && this._transportQueue[0] == this._inside))
               {
                  this.cancelWaiting();
               }
            }
            else
            {
               this.cancelWaiting();
            }
         }
      }
      
      public function cancelWaiting() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this._inside is FacilityElevatorBody)
         {
            _loc1_ = this._inside.elevatorLink;
            _loc2_ = _loc1_.passanger.indexOf(this);
            if(_loc2_ in _loc1_.passanger)
            {
               _loc1_.passanger.splice(_loc2_,1);
            }
            _loc3_ = this._inside.queueLine.indexOf(this);
            if(_loc3_ in this._inside.queueLine)
            {
               this._inside.queueLine.splice(_loc3_,1);
            }
            this._inside.removePerson(this);
            this._inside = null;
         }
      }
      
      function walkToTransport() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this._inside == null)
         {
            if(this._destinationTransport == null)
            {
               _loc1_ = this._transportQueue[0];
               if(_loc1_ is FacilityStairs)
               {
                  this._movePoint = _loc1_.entrancePosition(this.y);
                  this._destinationTransport = _loc1_;
               }
               else if(_loc1_ is FacilityElevatorBody)
               {
                  this._movePoint = _loc1_.elevatorLink.entrancePosition(this.y);
                  this._destinationTransport = _loc1_;
               }
               else if(_loc1_ == "connection")
               {
                  _loc2_ = this._world.getConnectionAt(this._floorStep.y);
                  if(_loc2_ != null)
                  {
                     this._movePoint = _loc2_.enterancePosition;
                     this._destinationTransport = _loc2_;
                  }
               }
            }
            else if(this._movePoint == null)
            {
               _loc3_ = this._destinationTransport is FacilityStairs ? this._destinationTransport.entrancePosition(this.y) : this._destinationTransport.enterancePosition;
               if(_loc3_ != null)
               {
                  if(Math.abs(_loc3_.x - this.x) > 0)
                  {
                     this._movePoint = new Point(_loc3_.x,_loc3_.y);
                  }
                  else if(this._world.dungeonConnection.indexOf(this._destinationTransport) < 0)
                  {
                     dispatchEvent(new HumanEvent(HumanEvent.ENTER_THE_BUILDING,this._destinationTransport));
                     this._destinationTransport = null;
                  }
                  else if(this._destinationTransport.enableToEnter)
                  {
                     dispatchEvent(new HumanEvent(HumanEvent.ENTER_THE_BUILDING,this._destinationTransport));
                     this._destinationTransport = null;
                  }
                  else if((_loc4_ = this._destinationTransport.door) != null)
                  {
                     if(_loc4_.isClose)
                     {
                        this._destinationTransport.openTheDoor();
                     }
                  }
               }
            }
         }
      }
      
      function differentFloorTargetCheck() : void
      {
         if(this._transportQueue.length == 0)
         {
            if(this._inside == null)
            {
               this.searchTransportWhenOutside();
            }
            else if(this._world.transportList.indexOf(this._inside) >= 0)
            {
               this.searchTransportWhenInsideStair();
               this.searchTransportWhenInsideElevator();
            }
            else
            {
               this.searchTransportWhenWaitingElevator();
            }
         }
         else
         {
            this.walkToTransport();
         }
      }
      
      function animationCheck(param1:LoopEvent) : void
      {
         if(!this._passive)
         {
            if(this.nextFrameQueue != null)
            {
               if(this.nextFrameQueue is Number)
               {
                  this.gotoAndStop(this.nextFrameQueue);
               }
               else if(Utility.hasLabel(this,this.nextFrameQueue))
               {
                  this.gotoAndStop(this.nextFrameQueue);
               }
               this.nextFrameQueue = null;
            }
            else if(this._currentAnimation != null)
            {
               if(Utility.hasLabel(this,this._currentAnimation))
               {
                  if(this.currentFrameLabel != this._currentAnimation + "_end")
                  {
                     nextFrame();
                  }
                  else
                  {
                     gotoAndStop(this._currentAnimation);
                  }
               }
            }
         }
      }
      
      public function runSpeed() : Number
      {
         if(!this._run)
         {
            return 0;
         }
         return this._stat.countSpeed();
      }
      
      public function getSpeed() : Number
      {
         return this._stat.countSpeed();
      }
      
      public function getSight() : Number
      {
         return this._stat.countSight();
      }
      
      function movingCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(!this._passive)
         {
            if(this._movePoint != null)
            {
               if(this.currentAnimation != Animation.WALK)
               {
                  this.currentAnimation = Animation.WALK;
               }
               _loc2_ = this.getSpeed() + this.runSpeed();
               _loc3_ = Math.min(_loc2_,5);
               while(_loc2_ > 0)
               {
                  this.scaleX = this._movePoint.x > this.x ? Number(1) : (this._movePoint.x < this.x ? Number(-1) : Number(this.scaleX));
                  if((_loc4_ = Math.abs(this._movePoint.x - this.x)) - _loc3_ > 0)
                  {
                     _loc5_ = _loc3_ / _loc4_;
                     this.x += _loc5_ * (this._movePoint.x - this.x);
                     _loc2_ = Math.max(_loc2_ - _loc3_,0);
                     _loc3_ = Math.min(_loc2_,5);
                  }
                  else
                  {
                     this.x = this._movePoint.x;
                     this._movePoint = null;
                     this.currentAnimation = Animation.IDLE;
                     _loc2_ = 0;
                  }
               }
            }
         }
      }
      
      public function searchTransport() : Array
      {
         var _loc1_:* = new Array();
         var _loc2_:* = this.searchAvailableTransport(this._floorStep,this._floorTarget,new Point(this.x,this.y),this._floorPoint);
         return _loc2_.queue;
      }
      
      function searchAvailableTransport(param1:*, param2:*, param3:Point, param4:Point) : Object
      {
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         var _loc21_:Point = null;
         var _loc22_:* = undefined;
         var _loc23_:Point = null;
         var _loc24_:* = undefined;
         var _loc25_:* = undefined;
         var _loc26_:* = undefined;
         var _loc27_:* = undefined;
         var _loc28_:* = undefined;
         var _loc29_:* = undefined;
         var _loc30_:* = undefined;
         var _loc31_:* = undefined;
         var _loc32_:* = undefined;
         var _loc33_:* = undefined;
         var _loc34_:* = undefined;
         var _loc35_:* = undefined;
         var _loc36_:* = undefined;
         var _loc5_:*;
         (_loc5_ = new Object()).queue = new Array();
         _loc5_.cost = Infinity;
         var _loc6_:* = param1.y > param2.y;
         var _loc7_:* = new Array();
         var _loc8_:* = Math.max(param1.y,param2.y);
         var _loc9_:* = Math.min(param1.y,param2.y);
         var _loc10_:*;
         (_loc10_ = new Object()).cost = 0;
         _loc10_.target = param4;
         _loc10_.prev = null;
         if(this._world.basementFloorList.indexOf(param2) >= 0)
         {
            (_loc14_ = new Object()).cost = 0;
            _loc14_.target = "connection";
            _loc14_.prev = _loc10_;
            _loc10_ = _loc14_;
         }
         _loc7_.push(_loc10_);
         var _loc11_:* = 0;
         while(_loc11_ < this._world.transportList.length)
         {
            if((_loc15_ = this._world.transportList[_loc11_]) is FacilityStairs)
            {
               if(_loc15_.lowerEnterance.y <= _loc8_ && _loc15_.upperEnterance.y >= _loc9_)
               {
                  (_loc16_ = new Object()).cost = Infinity;
                  _loc16_.target = _loc15_;
                  _loc16_.prev = null;
                  _loc7_.push(_loc16_);
               }
            }
            else if(_loc15_ is Elevator)
            {
               _loc17_ = 0;
               while(_loc17_ < _loc15_.bodyList.length)
               {
                  if((_loc19_ = (_loc18_ = _loc15_.bodyList[_loc17_]).enterancePosition).y <= _loc8_ && _loc19_.y >= _loc9_)
                  {
                     (_loc16_ = new Object()).cost = Infinity;
                     _loc16_.target = _loc18_;
                     _loc16_.prev = null;
                     _loc7_.push(_loc16_);
                  }
                  _loc17_++;
               }
            }
            _loc11_++;
         }
         var _loc12_:*;
         (_loc12_ = new Object()).cost = Infinity;
         _loc12_.target = param3;
         _loc12_.prev = null;
         if(this._world.basementFloorList.indexOf(param1) >= 0)
         {
            (_loc20_ = new Object()).cost = Infinity;
            _loc20_.target = "connection";
            _loc12_.cost = 0;
            _loc12_.prev = _loc20_;
            _loc12_ = _loc20_;
         }
         _loc7_.push(_loc12_);
         _loc7_.sortOn("cost",Array.NUMERIC);
         var _loc13_:* = _loc7_.shift();
         while(_loc13_ != _loc12_ && _loc7_.length > 0)
         {
            _loc21_ = null;
            if(_loc13_.target is Point)
            {
               _loc21_ = _loc13_.target;
            }
            else if(_loc13_.target == "connection")
            {
               _loc21_ = this._world.connectionSurface.enterancePosition;
            }
            else if(_loc13_.target is FacilityStairs)
            {
               if(_loc6_)
               {
                  _loc21_ = _loc13_.target.lowerEnterance;
               }
               else
               {
                  _loc21_ = _loc13_.target.upperEnterance;
               }
            }
            else if(_loc13_.target is FacilityElevatorBody)
            {
               _loc21_ = _loc13_.target.enterancePosition;
            }
            _loc11_ = 0;
            while(_loc11_ < _loc7_.length)
            {
               _loc22_ = _loc7_[_loc11_];
               _loc23_ = null;
               _loc24_ = 0;
               if(_loc22_.target is Point)
               {
                  _loc23_ = _loc22_.target;
               }
               else if(_loc22_.target == "connection")
               {
                  _loc23_ = this._world.connectionSurface.enterancePosition;
               }
               else if(_loc22_.target is FacilityStairs)
               {
                  if(_loc6_)
                  {
                     _loc23_ = _loc22_.target.upperEnterance;
                  }
                  else
                  {
                     _loc23_ = _loc22_.target.lowerEnterance;
                  }
               }
               else if(_loc22_.target is FacilityElevatorBody)
               {
                  _loc23_ = _loc22_.target.enterancePosition;
                  _loc25_ = _loc22_.target.elevatorLink;
                  if(this._inside != _loc25_)
                  {
                     _loc26_ = _loc22_.target.queueLine.length * 2;
                     _loc27_ = this._world.mainContainer.globalToLocal(_loc25_.room.localToGlobal(new Point(0,0)));
                     _loc28_ = Math.abs(_loc27_.y - _loc22_.target.enterancePosition.y) * 2 + _loc25_.roomTarget.length * 2;
                     _loc29_ = 0;
                     while(_loc29_ < _loc25_.roomTarget.length)
                     {
                        if((_loc30_ = _loc25_.roomTarget[_loc29_]) != _loc22_.target)
                        {
                           _loc26_ += _loc30_.queueLine.length * 2;
                        }
                        _loc29_++;
                     }
                     _loc24_ += _loc26_ + _loc28_;
                  }
               }
               if(_loc13_.target is FacilityElevatorBody && _loc22_.target is FacilityElevatorBody)
               {
                  _loc31_ = _loc13_.target.elevatorLink;
                  _loc32_ = _loc22_.target.elevatorLink;
                  if(_loc31_ == _loc32_)
                  {
                     _loc33_ = Math.round(Math.abs(param1.y - _loc22_.target.enterancePosition.y));
                     _loc34_ = _loc13_.cost + _loc33_;
                     if(_loc22_.cost > _loc34_)
                     {
                        _loc22_.cost = _loc34_;
                        _loc22_.prev = _loc13_;
                     }
                  }
                  else if(_loc21_.y == _loc23_.y)
                  {
                     _loc35_ = Math.round(Math.abs(_loc21_.x - _loc23_.x) / 12) * 12;
                     _loc36_ = _loc13_.cost + _loc35_ + _loc24_;
                     if(_loc22_.cost > _loc36_)
                     {
                        _loc22_.cost = _loc36_;
                        _loc22_.prev = _loc13_;
                     }
                  }
               }
               else if(_loc21_.y == _loc23_.y)
               {
                  _loc35_ = Math.round(Math.abs(_loc21_.x - _loc23_.x) / 12) * 12;
                  _loc36_ = _loc13_.cost + _loc35_ + _loc24_;
                  if(_loc22_.cost > _loc36_)
                  {
                     _loc22_.cost = _loc36_;
                     _loc22_.prev = _loc13_;
                  }
               }
               _loc11_++;
            }
            _loc7_.sortOn("cost",Array.NUMERIC);
            _loc13_ = _loc7_.shift();
         }
         _loc5_.cost = _loc13_.cost;
         if(isFinite(_loc13_.cost))
         {
            while(_loc13_ != null)
            {
               if(_loc13_.target is FacilityStairs)
               {
                  _loc5_.queue.push(_loc13_.target);
               }
               else if(_loc13_.target is FacilityElevatorBody)
               {
                  _loc5_.queue.push(_loc13_.target);
               }
               else if(_loc13_.target == "connection")
               {
                  if(_loc5_.queue.indexOf("connection") < 0)
                  {
                     _loc5_.queue.push("connection");
                  }
               }
               _loc13_ = _loc13_.prev;
            }
         }
         return _loc5_;
      }
      
      public function get onFloor() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc1_:* = null;
         if(this._world != null)
         {
            _loc2_ = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc3_ = 0;
            while(_loc3_ < this._world.floorList.length)
            {
               if((_loc4_ = this._world.floorList[_loc3_]).y == _loc2_.y)
               {
                  _loc1_ = _loc4_;
                  break;
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < this._world.basementFloorList.length && _loc1_ == null)
            {
               if((_loc5_ = this._world.basementFloorList[_loc3_]).y == _loc2_.y)
               {
                  _loc1_ = _loc5_;
                  break;
               }
               _loc3_++;
            }
         }
         return _loc1_;
      }
      
      public function get floorStep() : *
      {
         return this._floorStep;
      }
      
      public function set movePoint(param1:Point) : void
      {
         this._movePoint = param1;
      }
      
      public function get movePoint() : Point
      {
         return this._movePoint;
      }
      
      public function set destination(param1:*) : void
      {
         this._destination = param1;
      }
      
      public function get destination() : *
      {
         return this._destination;
      }
      
      public function set baseHome(param1:*) : void
      {
         this._baseHome = param1;
      }
      
      public function get baseHome() : *
      {
         return this._baseHome;
      }
      
      public function set currentAnimation(param1:String) : void
      {
         this._currentAnimation = param1;
         this.nextFrameQueue = this._currentAnimation;
      }
      
      public function get currentAnimation() : String
      {
         return this._currentAnimation;
      }
      
      public function set stat(param1:HumanStat) : void
      {
         this._stat = param1;
      }
      
      public function get stat() : HumanStat
      {
         return this._stat;
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function set inside(param1:*) : void
      {
         this._inside = param1;
      }
      
      public function get inside() : *
      {
         return this._inside;
      }
      
      public function get transportQueue() : Array
      {
         return this._transportQueue;
      }
      
      public function set model(param1:String) : void
      {
         this._model = param1;
      }
      
      public function get model() : String
      {
         return this._model;
      }
      
      public function set inHome(param1:Boolean) : void
      {
         this._inHome = param1;
      }
      
      public function get inHome() : Boolean
      {
         return this._inHome;
      }
      
      public function set vitality(param1:int) : void
      {
         this._vitality = param1;
      }
      
      public function get vitality() : int
      {
         return this._vitality;
      }
      
      public function set exp(param1:int) : void
      {
         this._exp = param1;
      }
      
      public function get exp() : int
      {
         return this._exp;
      }
      
      public function set floorTarget(param1:*) : void
      {
         this._floorTarget = param1;
      }
      
      public function get floorTarget() : *
      {
         return this._floorTarget;
      }
      
      public function set floorPoint(param1:Point) : void
      {
         this._floorPoint = param1;
      }
      
      public function get floorPoint() : Point
      {
         return this._floorPoint;
      }
      
      public function gainMood(param1:Number) : void
      {
         var _loc2_:* = this._mood;
         var _loc3_:* = param1;
         var _loc4_:* = 1;
         if(_loc3_ > 0)
         {
            if("moodModifier" in this._world.upgradeModifier)
            {
               _loc4_ = 1 + this._world.upgradeModifier["moodModifier"];
            }
         }
         else if(_loc3_ < 0)
         {
            if("moodLossDecrement" in this._world.upgradeModifier)
            {
               _loc4_ = 1 - this._world.upgradeModifier["moodLossDecrement"];
            }
         }
         this._mood += _loc3_ * _loc4_;
         dispatchEvent(new HumanEvent(HumanEvent.MOOD_UPDATE,_loc2_));
         this._mood = Math.min(100,Math.max(0,this._mood));
      }
      
      public function set mood(param1:Number) : void
      {
         this._mood = param1;
      }
      
      public function get mood() : Number
      {
         return this._mood;
      }
      
      public function set passive(param1:Boolean) : void
      {
         this._passive = param1;
      }
      
      public function get passive() : Boolean
      {
         return this._passive;
      }
      
      public function get dialogIconBox() : *
      {
         return this._dialogIconBox;
      }
      
      public function set relatedCritter(param1:*) : void
      {
         this._relatedCritter = param1;
      }
      
      public function get relatedCritter() : *
      {
         return this._relatedCritter;
      }
      
      public function get characterName() : String
      {
         if(this._stat != null)
         {
            return this._stat.characterName;
         }
         return "-unnamed-";
      }
   }
}
