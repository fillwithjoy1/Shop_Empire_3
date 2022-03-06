package Instance.gameplay
{
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
   import Instance.property.Floor;
   import Instance.property.HumanStat;
   import Instance.sprite.Animation;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Litter extends Human
   {
       
      
      var _currentTargetSabotage;
      
      var _guardInSight:Array;
      
      var _sabotageProgress:Boolean;
      
      var _sabotagePoint:Point;
      
      var _isCaught:Boolean;
      
      var _throwTrashCtr:int;
      
      var _successSabotage:int;
      
      var _failedSabotage:int;
      
      var _sabotageBuilding;
      
      var _progressDelay:int;
      
      var _cancelDelay:int;
      
      var _evidence:int;
      
      var _canHide:Boolean;
      
      var initMode:Boolean;
      
      public function Litter()
      {
         super();
         this._guardInSight = new Array();
         this._sabotageProgress = false;
         this._sabotagePoint = null;
         this._isCaught = false;
         this._throwTrashCtr = 0;
         this._successSabotage = 0;
         this._failedSabotage = 0;
         this._evidence = 0;
         this._progressDelay = 0;
         this.initMode = true;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(this.initMode)
         {
            this.initMode = false;
            this.searchGuard();
            this.searchTargetToSabotage();
         }
         addListenerOf(stage,GameEvent.BUILDING_BROKEN,this.checkBuildingAlreadyBroken);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.checkGameTime);
      }
      
      function checkBuildingAlreadyBroken(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(this._currentTargetSabotage == _loc2_)
         {
            if(this._sabotageBuilding != this._currentTargetSabotage)
            {
               if(_destination == this._currentTargetSabotage)
               {
                  _destination = null;
               }
               this._sabotagePoint = null;
               this._sabotageBuilding = null;
               this._currentTargetSabotage = null;
               this._evidence = 5;
            }
            else if(!this._sabotageProgress)
            {
               _destination = null;
               this._sabotagePoint = null;
               this._sabotageBuilding = null;
               this._currentTargetSabotage = null;
               this._evidence = 5;
            }
         }
      }
      
      function checkGameTime(param1:GameEvent) : void
      {
         var _loc2_:* = param1.tag;
         if(_destination != "home")
         {
            if(_loc2_.hour >= 22 || _loc2_.hour < 10)
            {
               this._sabotageProgress = false;
               this._sabotageBuilding = null;
               this._sabotagePoint = null;
               _destination = null;
               this._currentTargetSabotage = null;
               _destination = "home";
            }
         }
      }
      
      public function loadCondition(param1:*) : void
      {
         this._isCaught = param1.isCaught;
         this._successSabotage = param1.successSabotage;
         this._failedSabotage = param1.failedSabotage;
         this._evidence = param1.evidence;
         this._canHide = param1.canHide;
      }
      
      public function saveCondition(param1:*) : void
      {
         param1.isCaught = this._isCaught;
         param1.successSabotage = this._successSabotage;
         param1.failedSabotage = this._failedSabotage;
         param1.evidence = this._evidence;
         param1.canHide = this._canHide;
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
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         if(!this._isCaught)
         {
            if(this._evidence > 0)
            {
               --this._evidence;
            }
            else if(_inside == null && this._currentTargetSabotage == null && _destination == null)
            {
               this.searchTargetToSabotage();
            }
            this.checkGuardIsOutRange();
            this.searchGuard();
            super.behavior(param1);
         }
      }
      
      override function inHomeBehaviorCheck() : void
      {
         if(this.stage)
         {
            dispatchEvent(new HumanEvent(HumanEvent.EXILE));
            this.parent.removeChild(this);
         }
      }
      
      override function movingCheck(param1:LoopEvent) : void
      {
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
         super.movingCheck(param1);
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
                  if(!_loc6_.inSight(this))
                  {
                     if(!inSight(_loc6_) && _loc10_ >= getSight() * 0.5)
                     {
                        _loc1_.push(_loc6_);
                     }
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
      
      function checkSabotageFloor() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:Number = NaN;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         if(!this._isCaught)
         {
            if(this._currentTargetSabotage is Floor)
            {
               if(_floorStep != this._currentTargetSabotage)
               {
                  if(_floorTarget != this._currentTargetSabotage)
                  {
                     _floorTarget = this._currentTargetSabotage;
                     _loc1_ = _world.floorList.indexOf(this._currentTargetSabotage);
                     if(_loc1_ + 1 in _world.floorList)
                     {
                        _loc2_ = _world.floorList[_loc1_ + 1];
                        _loc3_ = Math.round((Math.random() * (_loc2_.right - _loc2_.left) + _loc2_.left) / 10) * 10;
                        _floorPoint = new Point(_loc3_,this._currentTargetSabotage.y);
                     }
                  }
               }
               else if(insideMall)
               {
                  _loc4_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
                  if(!this._sabotageProgress)
                  {
                     if(_movePoint == null && _floorPoint == null)
                     {
                        if((_loc5_ = this.getNumberGuardLookAtMe()) > 0)
                        {
                           if(this._cancelDelay > 0)
                           {
                              --this._cancelDelay;
                           }
                        }
                        if(this._cancelDelay > 0)
                        {
                           _loc6_ = 5 * _loc5_;
                           this._progressDelay = Math.max(_loc6_,this._progressDelay - 1);
                           if(this._progressDelay > 0)
                           {
                              if(Calculate.chance(20))
                              {
                                 this.scaleX *= -1;
                              }
                           }
                           else
                           {
                              _loc7_ = 0;
                              _loc8_ = 0;
                              while(_loc8_ < _world.trashList.length)
                              {
                                 _loc10_ = _world.trashList[_loc8_];
                                 if((_loc11_ = _world.getFloorAt(_loc10_.y)) == this._currentTargetSabotage)
                                 {
                                    if((_loc12_ = Math.abs(_loc4_.x - _loc10_.x)) <= 18)
                                    {
                                       _loc7_ += _loc10_.dirtyLevel / 100 * 80;
                                    }
                                 }
                                 _loc8_++;
                              }
                              _loc9_ = Math.max(0,Math.min(80,100 - _loc7_));
                              if(Calculate.chance(_loc9_))
                              {
                                 this._sabotageProgress = true;
                                 this._throwTrashCtr = 20;
                              }
                              else
                              {
                                 noTargetCheck();
                              }
                           }
                        }
                        else
                        {
                           this.finishSabotage(false);
                        }
                     }
                     else if(_floorPoint != null)
                     {
                        _floorPoint = null;
                     }
                  }
                  else if(this._throwTrashCtr > 0)
                  {
                     if(currentAnimation != "throwTrash")
                     {
                        currentAnimation = "throwTrash";
                     }
                     if((_loc13_ = _world.getFloorAt(_loc4_.y)) != null)
                     {
                        if(this._throwTrashCtr <= 15)
                        {
                           _loc14_ = Math.random() * 4 + 2;
                           _loc15_ = (Math.floor(Math.random() * 3) - 1) * 18;
                           _world.addTrash(_loc13_,_loc4_.x + _loc15_,_loc14_);
                        }
                     }
                     --this._throwTrashCtr;
                  }
                  else
                  {
                     this.finishSabotage();
                  }
               }
               else
               {
                  noTargetCheck();
               }
            }
         }
      }
      
      function getNumberGuardLookAtMe() : int
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc1_:* = 0;
         var _loc2_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc3_:* = 0;
         while(_loc3_ < this._guardInSight.length)
         {
            _loc4_ = this._guardInSight[_loc3_];
            _loc5_ = _world.mainContainer.globalToLocal(_loc4_.localToGlobal(new Point(0,0)));
            if(_loc4_.inside == null || _loc4_.inside is FacilityElevatorBody || _loc4_.inside is FacilityStairs)
            {
               if(_loc5_.y == _loc2_.y)
               {
                  _loc6_ = Math.abs(_loc5_.x - _loc2_.x);
                  if(_loc4_.inSight(this) || _loc6_ <= 30)
                  {
                     _loc1_++;
                  }
               }
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      function finishSabotage(param1:Boolean = true) : void
      {
         this._sabotageProgress = false;
         this._sabotageBuilding = null;
         this._sabotagePoint = null;
         _destination = null;
         this._currentTargetSabotage = null;
         if(currentAnimation != Animation.IDLE)
         {
            currentAnimation = Animation.IDLE;
         }
         if(param1)
         {
            this._evidence = 10;
            ++this._successSabotage;
         }
         else
         {
            this._evidence = 5;
            ++this._failedSabotage;
         }
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
      
      function searchTargetToSabotage() : void
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
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         if(_world != null)
         {
            if(Calculate.chance(Math.max(Math.min(100 - this._successSabotage * 20,100 - this._failedSabotage * 10),10)))
            {
               _loc1_ = new Array();
               _loc2_ = _world.brokableBuildingList.concat();
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  if(!(_loc7_ = _loc2_[_loc3_]).isBroken && !this.targetHasHandyman(_loc2_))
                  {
                     _loc8_ = 100 - _loc7_.brokenLevel;
                     if(Calculate.chance(_loc8_))
                     {
                        _loc1_.push(_loc7_);
                     }
                  }
                  _loc3_++;
               }
               _loc4_ = new Array();
               _loc5_ = new Array();
               _loc6_ = new Array();
               _loc3_ = 0;
               while(_loc3_ < _world.floorList.length)
               {
                  _loc9_ = _world.floorList[_loc3_];
                  if(_loc3_ + 1 in _world.floorList)
                  {
                     _loc10_ = _world.floorList[_loc3_ + 1];
                     _loc11_ = Math.ceil((_loc10_.left + _world.TRASH_GRID / 2) / _world.TRASH_GRID) * _world.TRASH_GRID;
                     _loc13_ = ((_loc12_ = Math.floor((_loc10_.right - _world.TRASH_GRID / 2) / _world.TRASH_GRID) * _world.TRASH_GRID) - _loc11_) / _world.TRASH_GRID;
                     _loc4_.push(10);
                     _loc5_.push(0);
                     _loc6_.push(0);
                  }
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < _world.trashList.length)
               {
                  _loc14_ = _world.trashList[_loc3_];
                  _loc15_ = _world.getFloorAt(_loc14_.y);
                  if((_loc16_ = _world.floorList.indexOf(_loc15_)) in _loc5_)
                  {
                     _loc5_[_loc16_] += _loc14_.dirtyLevel / 100;
                  }
                  _loc3_++;
               }
               _loc3_ = 0;
               while(_loc3_ < _loc6_.length)
               {
                  _loc6_[_loc3_] = (1 - _loc5_[_loc3_] / _loc4_[_loc3_]) * 100;
                  if(Calculate.chance(_loc6_[_loc3_]))
                  {
                     if(_loc3_ in _world.floorList)
                     {
                        _loc1_.push(_world.floorList[_loc3_]);
                     }
                  }
                  _loc3_++;
               }
               if(_loc1_.length > 0)
               {
                  this._cancelDelay = 30;
                  _loc17_ = Math.floor(Math.random() * _loc1_.length);
                  this._currentTargetSabotage = _loc1_[_loc17_];
                  if(this._currentTargetSabotage is Building)
                  {
                     _destination = this._currentTargetSabotage;
                  }
                  else
                  {
                     _destination = null;
                  }
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
      
      function targetHasHandyman(param1:*) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = false;
         if(param1 is Building)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.humanList.length)
            {
               if((_loc4_ = param1.humanList[_loc3_]) is StaffHandyman)
               {
                  _loc2_ = true;
                  break;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      override function boothSearchCheck() : void
      {
         var _loc4_:* = undefined;
         var _loc1_:* = _world.getFloorAt(_destination.y);
         var _loc2_:* = _world.mainContainer.globalToLocal(_destination.localToGlobal(new Point(0,0)));
         var _loc3_:* = false;
         if(_loc1_ == _floorStep)
         {
            _loc3_ = true;
            if(this._sabotageBuilding == null)
            {
               _floorTarget = null;
               if((_loc4_ = Math.abs(this.x - _loc2_.x)) > 0)
               {
                  if(_movePoint == null || (_movePoint.x != _loc2_.x || _movePoint.y != _loc2_.y))
                  {
                     _movePoint = new Point(_loc2_.x,_loc2_.y);
                  }
               }
               else
               {
                  _movePoint = null;
                  this._sabotageBuilding = _destination;
               }
               _destinationTransport = null;
               _transportQueue = new Array();
            }
         }
         if(!_loc3_)
         {
            if(_floorTarget == null || _floorTarget != _loc1_)
            {
               _floorTarget = _loc1_;
               _floorPoint = new Point(_loc2_.x,_loc2_.y);
               _destinationTransport = null;
               _transportQueue = new Array();
            }
         }
      }
      
      override function insideBuildingCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(!this._isCaught)
         {
            super.insideBuildingCheck();
            if(_inside == null)
            {
               if(this._sabotageBuilding != null)
               {
                  if(this._sabotageBuilding == this._currentTargetSabotage)
                  {
                     if(!this._sabotageProgress)
                     {
                        if(this._sabotagePoint == null)
                        {
                           if(this._currentTargetSabotage is Building)
                           {
                              _loc1_ = _world.mainContainer.globalToLocal(this._currentTargetSabotage.localToGlobal(new Point(0,0)));
                              _loc2_ = this._currentTargetSabotage.width - 48;
                              _loc1_.x += Math.round((Math.random() * _loc2_ - _loc2_ / 2) * 10) / 10;
                              _loc1_.x = Math.round(_loc1_.x * 10) / 10;
                              this._sabotagePoint = new Point(_loc1_.x,_loc1_.y);
                           }
                        }
                        else
                        {
                           _loc3_ = Math.abs(this.x - this._sabotagePoint.x);
                           if(_loc3_ > 0)
                           {
                              if(_movePoint == null || (_movePoint.x != this._sabotagePoint.x || _movePoint.y != this._sabotagePoint.y))
                              {
                                 _movePoint = new Point(this._sabotagePoint.x,this._sabotagePoint.y);
                              }
                           }
                           else
                           {
                              _movePoint = null;
                              if((_loc4_ = this.getNumberGuardLookAtMe()) > 0)
                              {
                                 if(this._cancelDelay > 0)
                                 {
                                    --this._cancelDelay;
                                 }
                              }
                              if(this._cancelDelay > 0)
                              {
                                 _loc5_ = 5 * _loc4_;
                                 this._progressDelay = Math.max(_loc5_,this._progressDelay - 1);
                                 if(this._progressDelay > 0)
                                 {
                                    if(Calculate.chance(20))
                                    {
                                       this.scaleX *= -1;
                                    }
                                 }
                                 else
                                 {
                                    this._sabotageProgress = true;
                                 }
                              }
                              else
                              {
                                 this.finishSabotage(false);
                              }
                           }
                        }
                     }
                     else
                     {
                        if(currentAnimation != "break")
                        {
                           currentAnimation = "break";
                        }
                        if(!this._currentTargetSabotage.isBroken && !this.targetHasHandyman(this._currentTargetSabotage))
                        {
                           _loc6_ = 1;
                           if("buildingToughness" in _world.upgradeModifier)
                           {
                              _loc6_ = 1 - _world.upgradeModifier["buildingToughness"];
                           }
                           _loc7_ = Math.min(1,Math.round((Math.random() * 5 + 5) * _loc6_));
                           this._currentTargetSabotage.buildingHP -= _loc7_;
                        }
                        else
                        {
                           this.finishSabotage();
                        }
                     }
                  }
               }
            }
         }
      }
      
      override function destinationTargetCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(!this._isCaught)
         {
            if(_inside == null)
            {
               if(this._sabotageBuilding == null)
               {
                  if(this._evidence > 0 && !this._sabotageProgress && this._currentTargetSabotage == null)
                  {
                     if(_movePoint == null)
                     {
                        if(_floorTarget == null)
                        {
                           if(Calculate.chance(30))
                           {
                              _floorTarget = _world.floorList[Math.floor(Math.random() * (_world.floorList.length - 1))];
                              _loc1_ = null;
                              _loc2_ = _world.floorList.indexOf(_floorTarget);
                              if(_loc2_ + 1 in _world.floorList)
                              {
                                 _loc1_ = _world.floorList[_loc2_ + 1];
                              }
                              else
                              {
                                 _loc1_ = _floorTarget;
                              }
                              if(_loc1_ != null)
                              {
                                 _loc3_ = Math.round((Math.random() * (_loc1_.right - _loc1_.left) + _loc1_.left) / 10) * 10;
                                 _floorPoint = new Point(_loc3_,_floorTarget.y);
                              }
                           }
                        }
                     }
                  }
                  else
                  {
                     this.checkSabotageFloor();
                  }
                  if(!this._sabotageProgress)
                  {
                     super.destinationTargetCheck();
                  }
               }
            }
            else
            {
               super.destinationTargetCheck();
            }
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
         this._sabotageProgress = false;
         this._sabotageBuilding = null;
         addListenerOf(this,LoopEvent.ON_IDLE,this.afterCaughtCheck);
      }
      
      function afterCaughtCheck(param1:LoopEvent) : void
      {
         if(currentAnimation == "arrested")
         {
            if(this.currentFrameLabel == "arrested_end")
            {
               currentAnimation = "vanish";
               addListenerOf(this,LoopEvent.ON_IDLE,this.vanishingCheck);
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
         var _loc1_:* = 10 + this._successSabotage * 5;
         if("bonusModifier" in _world.upgradeModifier)
         {
            _loc1_ = Math.round(_loc1_ * (1 + _world.upgradeModifier["bonusModifier"]));
         }
         dispatchEvent(new HumanEvent(HumanEvent.DROP_BONUS,_loc1_));
      }
      
      public function get evidence() : int
      {
         return this._evidence;
      }
      
      public function get sabotageProgress() : Boolean
      {
         return this._sabotageProgress;
      }
      
      public function get sabotageBuilding() : *
      {
         return this._sabotageBuilding;
      }
      
      public function set isCaught(param1:Boolean) : void
      {
         this._isCaught = param1;
      }
      
      public function get isCaught() : Boolean
      {
         return this._isCaught;
      }
      
      public function get guardInSight() : Array
      {
         return this._guardInSight;
      }
      
      public function get canHide() : Boolean
      {
         return this._canHide;
      }
   }
}
