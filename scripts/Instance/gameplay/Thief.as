package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import Instance.property.Booth;
   import Instance.property.Elevator;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityStairs;
   import Instance.property.FacilityTradingPost;
   import Instance.property.FictionalBuilding;
   import Instance.property.HumanStat;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Thief extends Human
   {
       
      
      const MAX_SAFETY_TIME = 45;
      
      var _stolenTarget:Array;
      
      var _currentTargetSteal;
      
      var _stealTime:int;
      
      var _stealBountyTime:int;
      
      var _bountyLimit:int;
      
      var _bounty:int;
      
      var _boothBounty:int;
      
      var _isCaught:Boolean;
      
      var _stopVanish:Boolean;
      
      var _guardInSight:Array;
      
      var pursuer;
      
      var _safetyTime:int;
      
      var _hiding:Boolean;
      
      var _canHide:Boolean;
      
      var initMode:Boolean;
      
      var reachEdgeCtr:int = 0;
      
      public function Thief()
      {
         super();
         this._stolenTarget = new Array();
         this._stealTime = 30;
         this._isCaught = false;
         this._stopVanish = false;
         this._safetyTime = this.MAX_SAFETY_TIME;
         this._guardInSight = new Array();
         this._hiding = false;
         this.initMode = true;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(this.initMode)
         {
            this.initMode = false;
            this.searchGuard();
            if(_world.alarmTrigger)
            {
               if(this._guardInSight.length > 0)
               {
                  this._hiding = true;
               }
            }
            else
            {
               this._hiding = false;
            }
            this.searchTargetToRob();
         }
         if(this._isCaught)
         {
            if(_inside == null)
            {
               if(currentAnimation != "arrested" && currentAnimation != null)
               {
                  currentAnimation = "arrested";
               }
               addListenerOf(this,LoopEvent.ON_IDLE,this.afterCaughtCheck);
            }
         }
         addListenerOf(_world,GameEvent.BEFORE_DESTROY_CHECK,this.beforeBuildingWasDestroyed);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.checkGameTime);
         addListenerOf(_world,GameEvent.ALARM_TRIGGERED,this.whenAlarmTriggered);
      }
      
      function whenAlarmTriggered(param1:GameEvent) : void
      {
         this.visible = true;
      }
      
      public function loadCondition(param1:*) : void
      {
         this._stealTime = param1.stealTime;
         this._stealBountyTime = param1.stealBountyTime;
         this._bountyLimit = param1.bountyLimit;
         this._bounty = param1.bounty;
         this._boothBounty = param1.boothBounty;
         this._isCaught = param1.isCaught;
         this._safetyTime = param1.safetyTime;
         this._hiding = param1.hiding;
         this._canHide = param1.canHide;
      }
      
      public function saveCondition(param1:*) : void
      {
         param1.stealTime = this._stealTime;
         param1.stealBountyTime = this._stealBountyTime;
         param1.bountyLimit = this._bountyLimit;
         param1.bounty = this._bounty;
         param1.boothBounty = this._boothBounty;
         param1.isCaught = this._isCaught;
         param1.safetyTime = this._safetyTime;
         param1.hiding = this._hiding;
         param1.canHide = this._canHide;
      }
      
      function checkGameTime(param1:GameEvent) : void
      {
         var _loc2_:* = param1.tag;
         if(_destination != "home")
         {
            if(_loc2_.hour < 22 && _loc2_.hour >= 5)
            {
               _destination = "home";
               this._currentTargetSteal = null;
            }
         }
      }
      
      function beforeBuildingWasDestroyed(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._currentTargetSteal)
         {
            if(_inside == _loc2_)
            {
               if(!this._isCaught)
               {
                  this._bounty += this._boothBounty;
                  this._stolenTarget.push(this._currentTargetSteal);
                  this._currentTargetSteal = null;
               }
            }
         }
      }
      
      override function buildingIsDestroyed(param1:GameEvent) : void
      {
         super.buildingIsDestroyed(param1);
         var _loc2_:* = param1.tag;
         if(_inside != _loc2_)
         {
            this._currentTargetSteal = null;
            this.searchTargetToRob();
         }
      }
      
      function searchTargetToRob() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(_world != null)
         {
            if(_destination != "home")
            {
               if(Calculate.chance(Math.max(100 - this._stolenTarget.length * 20,10)))
               {
                  _loc1_ = _world.brokableBuildingList.concat();
                  _loc2_ = new Array();
                  _loc3_ = 0;
                  while(_loc3_ < _loc1_.length)
                  {
                     if(this._stolenTarget.indexOf(_loc1_[_loc3_]) < 0)
                     {
                        _loc2_.push(_loc1_[_loc3_]);
                     }
                     _loc3_++;
                  }
                  if(_loc2_.length > 0)
                  {
                     _loc4_ = Math.floor(Math.random() * _loc2_.length);
                     this._currentTargetSteal = _loc2_[_loc4_];
                     if(!_world.alarmTrigger)
                     {
                        _destination = this._currentTargetSteal;
                     }
                     this._stealTime = 30;
                     this._stealBountyTime = this._stealTime - 5;
                     this._boothBounty = 0;
                  }
                  else
                  {
                     _destination = "home";
                  }
               }
               else
               {
                  _destination = "home";
               }
            }
         }
      }
      
      override function initStat() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:* = 200;
         _loc1_ += Math.round(Math.random() * 100 - 50);
         _stat = new HumanStat();
         _stat.stamina = 1;
         _stat.speed = 1;
         _stat.hygine = 1;
         _stat.entertain = 1;
         _stat.sight = 1;
         _loc1_ -= 5;
         var _loc2_:Array = ["stamina","speed","sight"];
         Utility.shuffle(_loc2_);
         while(_loc1_ > 0)
         {
            _loc3_ = Math.floor(Math.random() * _loc2_.length);
            if(_stat[_loc2_[_loc3_]] < 100)
            {
               ++_stat[_loc2_[_loc3_]];
               _loc1_--;
            }
            else
            {
               _loc2_.splice(_loc3_,1);
            }
         }
         this._bountyLimit = 500 + 50 * _stat.stamina;
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         if(!this._isCaught)
         {
            this.checkGuardIsOutRange();
            this.searchGuard();
            this.pursuer = this.searchPursuer();
            if(this.pursuer == null)
            {
               if(!_world.alarmTrigger)
               {
                  if(this._currentTargetSteal != null)
                  {
                     if(_destination != this._currentTargetSteal)
                     {
                        _destination = this._currentTargetSteal;
                     }
                  }
                  else if(_destination != "home")
                  {
                     _destination = "home";
                  }
                  this._hiding = this._guardInSight.length > 0;
               }
               else
               {
                  this._hiding = false;
                  if(_inside != this._currentTargetSteal)
                  {
                     if(_destination != "home" && _destination != "runAway")
                     {
                        _destination = "runAway";
                     }
                  }
               }
            }
            else
            {
               this._hiding = false;
            }
            super.behavior(param1);
         }
      }
      
      function checkGuardIsOutRange() : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc1_:* = new Array();
         var _loc2_:* = new Array();
         var _loc3_:* = new Array();
         var _loc4_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc5_:* = 0;
         while(_loc5_ < this._guardInSight.length)
         {
            if((_loc6_ = this._guardInSight[_loc5_]).stage == null || _world.staffList.guard.indexOf(_loc6_) < 0 || _loc6_.inHome || _loc6_.destination == "home")
            {
               _loc3_.push(_loc6_);
            }
            else
            {
               _loc7_ = _world.mainContainer.globalToLocal(_loc6_.localToGlobal(new Point(0,0)));
               _loc8_ = Math.abs(_loc7_.y - _loc4_.y);
               _loc9_ = _loc6_.targetToCaught.indexOf(this) >= 0 ? 126 : 60;
               if(_loc8_ >= _loc9_)
               {
                  _loc1_.push(_loc6_);
               }
               else
               {
                  _loc10_ = Math.abs(_loc7_.x - _loc4_.x);
                  if(this._hiding)
                  {
                     if(!_loc6_.inSight(this))
                     {
                        if(!inSight(_loc6_) && _loc10_ >= getSight() * 0.5)
                        {
                           _loc1_.push(_loc6_);
                        }
                     }
                  }
                  else if(_loc10_ >= getSight() * 1.5)
                  {
                     _loc1_.push(_loc6_);
                  }
               }
               if(_loc6_.inside is Elevator)
               {
                  _loc2_.push(_loc6_);
               }
            }
            _loc5_++;
         }
         while(_loc3_.length > 0)
         {
            _loc6_ = _loc3_.pop();
            if((_loc11_ = this._guardInSight.indexOf(_loc6_)) >= 0)
            {
               this._guardInSight.splice(_loc11_,1);
            }
         }
         while(_loc1_.length > 0)
         {
            _loc6_ = _loc1_.pop();
            if((_loc11_ = this._guardInSight.indexOf(_loc6_)) >= 0)
            {
               this._guardInSight.splice(_loc11_,1);
            }
         }
         while(_loc2_.length > 0)
         {
            _loc6_ = _loc2_.pop();
            if((_loc11_ = this._guardInSight.indexOf(_loc6_)) >= 0)
            {
               this._guardInSight.splice(_loc11_,1);
            }
         }
      }
      
      override public function getSpeed() : Number
      {
         var _loc1_:* = super.getSpeed();
         if(this.hiding)
         {
            _loc1_ *= 0.5;
         }
         return _loc1_;
      }
      
      override function noTargetCheck() : void
      {
         if(this.pursuer != null)
         {
            super.noTargetCheck();
         }
      }
      
      function avoidTheTarget(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         if(_inside != null && !_inside is FacilityStairs)
         {
            if(_destination != null)
            {
               _destination = null;
            }
         }
         if(this.reachEdgeCtr > 0)
         {
            --this.reachEdgeCtr;
         }
         else
         {
            _loc2_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc3_ = _world.mainContainer.globalToLocal(param1.localToGlobal(new Point(0,0)));
            if(_inside == null)
            {
               if(Math.abs(_loc2_.y - _loc3_.y) < 10)
               {
                  if(param1.chaseTarget == this || param1.inSight(this))
                  {
                     _loc4_ = 0;
                     if(_loc2_.x < _loc3_.x)
                     {
                        _loc4_ = -1;
                     }
                     else if(_loc2_.x > _loc3_.x)
                     {
                        _loc4_ = 1;
                     }
                     if(_loc4_ != 0)
                     {
                        _loc5_ = (this.getSpeed() + runSpeed()) * _loc4_ * 5;
                        _loc6_ = new Point(_loc2_.x + _loc5_,_loc2_.y);
                        if((_loc7_ = _world.getFloorAt(_loc6_.y)) != null && _world.floorList.indexOf(_loc7_) > 0)
                        {
                           _loc8_ = 0;
                           if(_loc6_.x < _loc7_.left)
                           {
                              if((_loc8_ = Math.round(Math.abs(_loc2_.x - _loc7_.left))) > 0)
                              {
                                 _loc6_.x = _loc7_.left;
                              }
                              else
                              {
                                 this.reachEdgeCtr = 5;
                                 _loc6_.x = _loc2_.x - _loc5_;
                              }
                           }
                           else if(_loc6_.x > _loc7_.right)
                           {
                              if((_loc8_ = Math.round(Math.abs(_loc2_.x - _loc7_.right))) > 0)
                              {
                                 _loc6_.x = _loc7_.right;
                              }
                              else
                              {
                                 this.reachEdgeCtr = 5;
                                 _loc6_.x = _loc2_.x - _loc5_;
                              }
                           }
                        }
                        _movePoint = this.parent.globalToLocal(_world.mainContainer.localToGlobal(_loc6_));
                     }
                  }
                  else if(_floorTarget == null || _floorTarget == _floorStep)
                  {
                     if((_loc9_ = _world.floorList.indexOf(_floorStep)) >= 0)
                     {
                        _loc10_ = new Array();
                        if(_loc9_ + 1 in _world.floorList)
                        {
                           if(_loc9_ + 1 < _world.floorList.length - 1)
                           {
                              _loc10_.push(_world.floorList[_loc9_ + 1]);
                           }
                        }
                        if(_loc9_ - 1 in _world.floorList)
                        {
                           _loc10_.push(_world.floorList[_loc9_ - 1]);
                        }
                        if(_loc10_.length > 0)
                        {
                           Utility.shuffle(_loc10_);
                           _transportQueue = new Array();
                           _destinationTransport = null;
                           _floorTarget = _loc10_.shift();
                           _floorPoint = new Point();
                           _floorPoint.x = Math.random() * (_floorTarget.right - _floorTarget.left) + _floorTarget.left;
                           _floorPoint.y = _floorTarget.y;
                        }
                     }
                  }
               }
               else if(this._safetyTime > 0)
               {
                  --this._safetyTime;
               }
               else
               {
                  dispatchEvent(new HumanEvent(HumanEvent.ESCAPE_FROM_GUARD));
                  this._safetyTime = this.MAX_SAFETY_TIME;
               }
            }
            else if(_inside is FacilityStairs)
            {
               _loc11_ = (_inside as FacilityStairs).upperPosition;
               _loc12_ = _world.getFloorAt(_loc11_.y);
               _loc13_ = (_inside as FacilityStairs).lowerPosition;
               _loc14_ = _world.getFloorAt(_loc13_.y);
               if(param1.inside == null)
               {
                  if((_loc15_ = _inside.entrancePosition(_loc3_.y)) != null)
                  {
                     if((_loc16_ = _world.getFloorAt(_loc15_.y)).y <= _loc11_.y)
                     {
                        _floorTarget = _loc14_;
                     }
                     else if(_loc16_.y >= _loc13_.y)
                     {
                        _floorTarget = _loc12_;
                     }
                     _movePoint = null;
                     _destinationTransport = null;
                     if(_transportQueue.length != 1 || _transportQueue[0] != _inside)
                     {
                        _transportQueue = [_inside];
                     }
                     insideStairsCheck();
                     if(_inside == null)
                     {
                        if(onFloor == null)
                        {
                           throw new Error("malingnya bisa terbang.");
                        }
                     }
                  }
               }
               else if(param1.inside == _inside)
               {
                  _loc17_ = null;
                  _loc18_ = null;
                  _loc19_ = null;
                  if(param1.y < this.y)
                  {
                     _loc18_ = _loc14_;
                     _loc19_ = _loc12_;
                  }
                  else if(param1.y > this.y)
                  {
                     _loc18_ = _loc12_;
                     _loc19_ = _loc14_;
                  }
                  if(_loc18_ != null)
                  {
                     if(_floorTarget != _loc18_)
                     {
                        _floorTarget = _loc18_;
                        _floorStep = _loc19_;
                        _movePoint = null;
                        insideStairsCheck();
                        _destinationTransport = null;
                        if(_transportQueue.length > 1 && _transportQueue[0] != _inside)
                        {
                           _transportQueue = [_inside];
                        }
                     }
                  }
               }
            }
         }
      }
      
      override function movingCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         this._canHide = true;
         if(_world.watchdog != null)
         {
            if(_world.watchdog.targetToCaught.indexOf(this) >= 0)
            {
               if(_world.watchdog.inSight(this))
               {
                  this._canHide = false;
               }
            }
         }
         if(this._hiding && this.canHide)
         {
            if(this.alpha > 0.6)
            {
               this.alpha = Math.max(0.6,this.alpha - 0.08);
            }
         }
         else if(this.alpha < 1)
         {
            this.alpha = Math.min(1,this.alpha + 0.08);
         }
         if(!this._isCaught)
         {
            if(this.pursuer != null)
            {
               _run = true;
               this.avoidTheTarget(this.pursuer);
            }
            else
            {
               this.reachEdgeCtr = 0;
               if(_inside is FacilityStairs)
               {
                  if(_floorTarget == null)
                  {
                     _loc2_ = _inside.upperEnterance;
                     _loc3_ = _inside.lowerEnterance;
                     _loc4_ = new Array();
                     _loc5_ = _world.getFloorAt(_loc2_.y);
                     _loc6_ = _world.getFloorAt(_loc3_.y);
                     if(_world.floorList.indexOf(_loc5_) >= 0 && _world.floorList.indexOf(_loc5_) < _world.floorList.length - 1)
                     {
                        _loc4_.push(_loc5_);
                     }
                     if(_world.floorList.indexOf(_loc6_) >= 0 && _world.floorList.indexOf(_loc6_) < _world.floorList.length - 1)
                     {
                        _loc4_.push(_loc6_);
                     }
                     _floorTarget = _loc4_[Math.floor(Math.random() * _loc4_.length)];
                  }
               }
               _run = _world.alarmTrigger;
            }
            super.movingCheck(param1);
            if(this.pursuer != null)
            {
               if((_loc7_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point()))).x <= _world.mostLeft - 10 || _loc7_.x >= _world.mostRight + 10)
               {
                  if(this.stage)
                  {
                     this.successEscape();
                     dispatchEvent(new HumanEvent(HumanEvent.EXILE));
                     this.parent.removeChild(this);
                  }
               }
            }
         }
      }
      
      function searchPursuer() : *
      {
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         var _loc21_:* = undefined;
         var _loc22_:* = undefined;
         var _loc23_:* = undefined;
         var _loc24_:* = undefined;
         var _loc25_:* = undefined;
         var _loc26_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = Infinity;
         var _loc4_:* = Infinity;
         var _loc5_:* = false;
         var _loc6_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc7_:* = onFloor;
         var _loc8_:* = _world.floorList.indexOf(_loc7_);
         var _loc9_:* = 0;
         while(_loc9_ < this._guardInSight.length)
         {
            if((_loc10_ = this._guardInSight[_loc9_]).targetToCaught.indexOf(this) >= 0)
            {
               _loc11_ = _loc10_.onFloor;
               _loc12_ = _world.mainContainer.globalToLocal(_loc10_.localToGlobal(new Point(0,0)));
               _loc13_ = Infinity;
               _loc14_ = Infinity;
               if(_inside is FacilityStairs)
               {
                  if(_loc10_.inside == _inside)
                  {
                     _loc13_ = Math.abs(this.x - _loc10_.x);
                     _loc14_ = 0;
                  }
               }
               else if(_inside == null)
               {
                  if(_loc10_.inside == null || _loc10_.inside is FacilityElevatorBody)
                  {
                     if(_loc7_ == _loc11_)
                     {
                        _loc13_ = Math.abs(_loc6_.x - _loc12_.x);
                        _loc14_ = 0;
                     }
                     else
                     {
                        _loc16_ = _world.floorList.indexOf(_loc11_);
                        _loc14_ = Math.abs(_loc8_ - _loc16_);
                     }
                  }
                  else if(_loc10_.inside is FacilityStairs)
                  {
                     if((_loc18_ = (_loc17_ = _loc10_.inside).entrancePosition(_loc6_.y)) != null)
                     {
                        _loc14_ = 0;
                        _loc13_ = Math.abs(_loc6_.x - _loc18_.x) + Math.abs(_loc18_.x - _loc12_.x);
                     }
                     else
                     {
                        _loc19_ = _loc17_.upperEnterance;
                        _loc20_ = _loc17_.lowerEnterance;
                        _loc21_ = _world.mainContainer.globalToLocal(_loc17_.localToGlobal(_loc19_));
                        _loc22_ = _world.mainContainer.globalToLocal(_loc17_.localToGlobal(_loc20_));
                        _loc23_ = _world.getFloorAt(_loc21_.y);
                        _loc24_ = _world.getFloorAt(_loc21_.y);
                        _loc25_ = _world.floorList.indexOf(_loc23_);
                        _loc26_ = _world.floorList.indexOf(_loc24_);
                        _loc14_ = Math.min(Math.abs(_loc8_ - _loc25_),Math.abs(_loc8_ - _loc26_));
                     }
                  }
               }
               _loc15_ = false;
               if(_loc5_)
               {
                  if(_loc10_.chaseTarget != this)
                  {
                     _loc15_ = true;
                  }
               }
               else if(_loc10_.chaseTarget == this)
               {
                  _loc2_ = _loc10_;
                  _loc4_ = _loc14_;
                  _loc3_ = _loc13_;
                  _loc5_ = true;
                  _loc15_ = true;
               }
               if(!_loc15_)
               {
                  if(_loc14_ < _loc4_)
                  {
                     _loc2_ = _loc10_;
                     _loc4_ = _loc14_;
                     _loc3_ = _loc13_;
                  }
                  else if(_loc14_ == _loc4_)
                  {
                     if(_loc2_ == null)
                     {
                        _loc2_ = _loc10_;
                        _loc4_ = _loc14_;
                        _loc3_ = _loc13_;
                     }
                     else if(_loc13_ < _loc3_)
                     {
                        _loc2_ = _loc10_;
                        _loc3_ = _loc13_;
                        _loc4_ = _loc14_;
                     }
                  }
               }
            }
            _loc9_++;
         }
         return _loc2_;
      }
      
      function searchGuard() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(_inside == null || _inside is FacilityElevatorBody || _inside is FacilityStairs)
         {
            _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc2_ = 0;
            while(_loc2_ < _world.staffList.guard.length)
            {
               _loc3_ = _world.staffList.guard[_loc2_];
               if(!(_loc3_.inside is Booth || _loc3_.inside is Elevator || _loc3_.inHome || _loc3_.destination == "home"))
               {
                  if((_loc4_ = this._guardInSight.indexOf(_loc3_)) < 0)
                  {
                     _loc5_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
                     _loc6_ = false;
                     if(_inside is FacilityStairs)
                     {
                        if(_loc3_.inside == _inside)
                        {
                           _loc6_ = true;
                        }
                        else
                        {
                           _loc6_ = Math.abs(_loc5_.y - _loc1_.y) <= 60;
                        }
                     }
                     else if(_loc3_.inside == null || _loc3_.inside is FacilityElevatorBody)
                     {
                        _loc6_ = Math.abs(_loc5_.y - _loc1_.y) == 0;
                     }
                     else if(_loc3_.inside is FacilityStairs)
                     {
                        if((_loc7_ = _loc3_.inside.entrancePosition(_loc1_.y)) != null)
                        {
                           _loc6_ = Math.abs(_loc5_.y - _loc1_.y) <= 60;
                        }
                     }
                     if(inSight(_loc3_) && _loc6_)
                     {
                        this._guardInSight.push(_loc3_);
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      override function insideBuildingCheck() : void
      {
         if(!this._isCaught)
         {
            super.insideBuildingCheck();
            this.stealingProgress();
         }
      }
      
      override function differentFloorTargetCheck() : void
      {
         if(!this._isCaught)
         {
            super.differentFloorTargetCheck();
         }
      }
      
      function stealingProgress() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this._currentTargetSteal != null)
         {
            if(_inside != null && _inside == this._currentTargetSteal)
            {
               _loc1_ = _inside;
               if(_inside is FictionalBuilding)
               {
                  _loc1_ = _inside.related;
               }
               if(this._stealTime > 0 && !_world.alarmTrigger)
               {
                  --this._stealTime;
                  if(Calculate.chance(30))
                  {
                     _loc2_ = Math.floor(Math.random() * 3) - 1;
                     this._stealTime += _loc2_;
                     if(_loc2_ > 0)
                     {
                        _loc3_ = 1;
                        if("buildingToughness" in _world.upgradeModifier)
                        {
                           _loc3_ = 1 - _world.upgradeModifier["buildingToughness"];
                        }
                        if(Calculate.chance(15 * _loc3_))
                        {
                           _loc1_.buildingHP -= Math.round(Math.random() * 2 + 1);
                        }
                        _inside.dispatchEvent(new GameEvent(GameEvent.BECOMES_ROBBED,this));
                        this._boothBounty += Math.floor(Math.random() * 4 + 1) * this.getStolenBountyOf(_inside);
                     }
                  }
                  if(this._stealTime <= this._stealBountyTime)
                  {
                     if(Calculate.chance(15))
                     {
                        _loc1_.buildingHP -= Math.round(Math.random() * 2 + 1);
                     }
                     _inside.dispatchEvent(new GameEvent(GameEvent.BECOMES_ROBBED,this));
                     this._boothBounty += Math.floor(Math.random() * 4 + 1) * this.getStolenBountyOf(_inside);
                     this._stealBountyTime -= 5;
                  }
               }
               else
               {
                  this._boothBounty;
                  this._stolenTarget.push(this._currentTargetSteal);
                  this._currentTargetSteal = null;
                  _destination = "exit";
               }
            }
         }
      }
      
      override function whenEnterTheBuilding(param1:HumanEvent) : void
      {
         super.whenEnterTheBuilding(param1);
         var _loc2_:* = param1.tag;
         if(_loc2_ == this._currentTargetSteal)
         {
            this._hiding = false;
            this.visible = false;
         }
      }
      
      override function whenExitTheBuilding(param1:HumanEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         super.whenExitTheBuilding(param1);
         var _loc2_:* = param1.tag;
         this.visible = true;
         if(this._stolenTarget.indexOf(_loc2_) >= 0)
         {
            if(!this._isCaught)
            {
               if(Calculate.chance(this._stealTime / 30 * 100))
               {
                  _loc3_ = this._stolenTarget.indexOf(_loc2_);
                  this._stolenTarget.splice(_loc3_,1);
               }
               this._bounty += this._boothBounty;
               dispatchEvent(new HumanEvent(HumanEvent.STEAL_MONEY,this._boothBounty));
               this.searchTargetToRob();
            }
         }
         if(this.pursuer != null)
         {
            if(_loc2_ is FacilityStairs)
            {
               _loc4_ = new Array();
               _loc5_ = this.pursuer.onFloor;
               _loc6_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
               _loc7_ = 0;
               while(_loc7_ < _world.stairList.length)
               {
                  if((_loc8_ = _world.stairList[_loc7_]) != _loc2_)
                  {
                     if((_loc9_ = _loc8_.entrancePosition(_loc6_.y)) != null)
                     {
                        _loc10_ = (_loc8_ as FacilityStairs).upperPosition;
                        _loc11_ = _world.getFloorAt(_loc10_.y);
                        _loc12_ = (_loc8_ as FacilityStairs).lowerPosition;
                        _loc13_ = _world.getFloorAt(_loc12_.y);
                        _loc14_ = null;
                        _loc15_ = null;
                        if(_loc10_.y == _loc9_.y)
                        {
                           _loc14_ = _loc12_;
                           _loc15_ = _loc13_;
                        }
                        else
                        {
                           _loc14_ = _loc10_;
                           _loc15_ = _loc11_;
                        }
                        if(_loc14_ != null && _loc15_ != null)
                        {
                           _loc16_ = true;
                           if(_loc15_ == _loc5_)
                           {
                              _loc16_ = Calculate.chance(50);
                           }
                           if(_loc16_)
                           {
                              _loc4_.push({
                                 "transport":_loc8_,
                                 "exitFloor":_loc15_,
                                 "exitPoint":_loc14_
                              });
                           }
                        }
                     }
                  }
                  _loc7_++;
               }
               if(_loc4_.length > 0)
               {
                  _loc18_ = (_loc17_ = _loc4_[Math.floor(Math.random() * _loc4_.length)]).transport;
                  _transportQueue = [_loc18_];
                  _floorTarget = _loc17_.exitFloor;
                  _floorPoint = _loc17_.exitPoint;
                  _loc9_ = _loc18_.entrancePosition(_loc6_.y);
                  _movePoint = new Point(_loc9_.x,_loc9_.y);
               }
               else
               {
                  _floorPoint = null;
                  _loc19_ = 0;
                  if(Calculate.chance(50))
                  {
                     _movePoint = new Point(_floorStep.left,_floorStep.y);
                     _loc19_ = -1;
                  }
                  else
                  {
                     _movePoint = new Point(_floorStep.right,_floorStep.y);
                     _loc19_ = 1;
                  }
                  if(_world.floorList.indexOf(_floorStep) == 0)
                  {
                     _movePoint.x += 10 * _loc19_;
                  }
               }
            }
         }
      }
      
      function getStolenBountyOf(param1:*) : Number
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:* = 0;
         if(!(param1 is FacilityTradingPost))
         {
            _loc3_ = BuildingData.getServeMode(BuildingData.returnClassTo(Utility.getClass(param1)));
            _loc4_ = param1.priceList.concat();
            if(_loc3_ != BuildingData.SALE)
            {
               _loc5_ = 0;
               _loc6_ = 0;
               while(_loc6_ < _loc4_.length)
               {
                  _loc5_ += _loc4_;
                  _loc6_++;
               }
               _loc2_ = (_loc7_ = _loc5_ / _loc4_.length) / 5;
            }
            else
            {
               Utility.shuffle(_loc4_);
               _loc2_ = _loc4_.shift();
            }
         }
         else
         {
            _loc2_ = 25;
         }
         return Math.round(_loc2_ * (1 + 0.2 * _world.popularity / 10));
      }
      
      override function inHomeBehaviorCheck() : void
      {
         if(this.stage)
         {
            this.successEscape();
            dispatchEvent(new HumanEvent(HumanEvent.EXILE));
            this.parent.removeChild(this);
         }
      }
      
      function successEscape() : void
      {
         if(this._bounty > 0)
         {
            _world.main.updateHistory("escapeThief");
            trace("Maling yang berhasil lari = " + _world.main.history["escapeThief"]);
         }
      }
      
      public function caught() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _destination = null;
         _floorTarget = null;
         _movePoint = null;
         _transportQueue = new Array();
         _destinationTransport = null;
         this._isCaught = true;
         currentAnimation = "arrested";
         if(_inside is FacilityElevatorBody)
         {
            _inside.removePerson(this);
            _loc1_ = _inside.queueLine.indexOf(this);
            if(_loc1_ in _inside.queueLine)
            {
               _inside.queueLine.splice(_loc1_,1);
            }
            _loc2_ = _inside.elevatorLink;
            _loc3_ = _loc2_.passanger.indexOf(this);
            if(_loc3_ in _loc2_.passanger)
            {
               _loc2_.passanger.splice(_loc3_,1);
            }
         }
         this._hiding = false;
         this.alpha = 1;
         _inside = null;
         addListenerOf(this,LoopEvent.ON_IDLE,this.afterCaughtCheck);
      }
      
      function afterCaughtCheck(param1:LoopEvent) : void
      {
         if(currentAnimation == "arrested")
         {
            if(this.currentFrameLabel == "arrested_end")
            {
               if(!this._stopVanish)
               {
                  currentAnimation = "vanish";
                  addListenerOf(this,LoopEvent.ON_IDLE,this.vanishingCheck);
               }
               else
               {
                  currentAnimation = null;
               }
               removeListenerOf(this,LoopEvent.ON_IDLE,this.afterCaughtCheck);
            }
         }
      }
      
      public function vanish() : void
      {
         currentAnimation = "vanish";
         addListenerOf(this,LoopEvent.ON_IDLE,this.vanishingCheck);
      }
      
      function vanishingCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         if(currentAnimation == "vanish")
         {
            if(this.currentFrameLabel == "vanish_end")
            {
               currentAnimation = null;
               removeListenerOf(this,LoopEvent.ON_IDLE,this.vanishingCheck);
               _loc2_ = _world.humanList.indexOf(this);
               if(_loc2_ in _world.humanList)
               {
                  _world.humanList.splice(_loc2_,1);
               }
               if(this.stage != null)
               {
                  dispatchEvent(new HumanEvent(HumanEvent.EXILE));
                  this.dropBounty();
                  this.parent.removeChild(this);
               }
            }
         }
      }
      
      function dropBounty() : void
      {
         var _loc1_:* = Math.round(Math.max(this._bounty / 20,10));
         if("bonusModifier" in _world.upgradeModifier)
         {
            _loc1_ = Math.round(_loc1_ * (1 + _world.upgradeModifier["bonusModifier"]));
         }
         dispatchEvent(new HumanEvent(HumanEvent.RETURN_BOUNTY,this._bounty));
         dispatchEvent(new HumanEvent(HumanEvent.DROP_BONUS,_loc1_));
      }
      
      public function get hiding() : Boolean
      {
         return this._hiding;
      }
      
      public function set isCaught(param1:Boolean) : void
      {
         this._isCaught = param1;
         if(this._isCaught)
         {
            this._hiding = false;
            this.alpha = 1;
         }
      }
      
      public function get isCaught() : Boolean
      {
         return this._isCaught;
      }
      
      public function set stopVanish(param1:Boolean) : void
      {
         this._stopVanish = param1;
      }
      
      public function get bounty() : int
      {
         return this._bounty;
      }
      
      public function get guardInSight() : Array
      {
         return this._guardInSight;
      }
      
      public function get stopVanish() : Boolean
      {
         return this._stopVanish;
      }
      
      public function get canHide() : Boolean
      {
         return this._canHide;
      }
      
      public function get stolenTarget() : Array
      {
         return this._stolenTarget;
      }
      
      public function set currentTargetSteal(param1:*) : void
      {
         this._currentTargetSteal = param1;
      }
      
      public function get currentTargetSteal() : *
      {
         return this._currentTargetSteal;
      }
   }
}
