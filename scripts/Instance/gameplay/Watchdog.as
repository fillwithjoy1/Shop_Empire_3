package Instance.gameplay
{
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import Instance.property.Booth;
   import Instance.property.Elevator;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityStairs;
   import Instance.property.HumanStat;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Watchdog extends Human
   {
       
      
      var _targetToCaught:Array;
      
      var _delayAfterSeeBandit:int;
      
      public function Watchdog()
      {
         super();
         this._targetToCaught = new Array();
         this._delayAfterSeeBandit = 0;
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.stamina = 50;
         _stat.hygine = 10;
         _stat.entertain = 10;
         _stat.sight = 20;
         _stat.speed = 45;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,LoopEvent.ON_IDLE,this.checkWhenLooping);
      }
      
      function checkWhenLooping(param1:LoopEvent) : void
      {
         if(_currentAnimation == "sit")
         {
            if(this.currentFrameLabel == "sit_end")
            {
               currentAnimation = null;
            }
         }
         if(_currentAnimation == "bark")
         {
            if(this.currentFrameLabel == "bark_sound_1" || this.currentFrameLabel == "bark_sound_2")
            {
               _world.main.onStackSFX.push(SFX_Bark);
               _world.main.onStackSFXSource.push(this);
            }
         }
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(_inside == null)
         {
            this.checkBanditIsOutRange();
            this.searchTarget();
            if(this._targetToCaught.length > 0)
            {
               this._delayAfterSeeBandit = 15;
               _movePoint = null;
               _loc2_ = this.getNearestTarget();
               if(_loc2_ != null)
               {
                  _loc3_ = _world.mainContainer.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
                  this.scaleX = _loc3_.x < this.x ? Number(-1) : (_loc3_.x > this.x ? Number(1) : Number(this.scaleX));
               }
               if(_currentAnimation != "bark")
               {
                  currentAnimation = "bark";
               }
            }
            else if(this._delayAfterSeeBandit > 0)
            {
               --this._delayAfterSeeBandit;
               if(_currentAnimation != "sit" && _currentAnimation != null)
               {
                  currentAnimation = "sit";
               }
            }
            else
            {
               super.behavior(param1);
            }
         }
         else
         {
            super.behavior(param1);
         }
      }
      
      function getNearestTarget() : *
      {
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
         var _loc20_:* = undefined;
         var _loc21_:* = undefined;
         var _loc22_:* = undefined;
         var _loc23_:* = undefined;
         var _loc24_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = Infinity;
         var _loc4_:* = Infinity;
         var _loc5_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc6_:* = onFloor;
         var _loc7_:* = _world.floorList.indexOf(_loc6_);
         var _loc8_:* = 0;
         while(_loc8_ < this._targetToCaught.length)
         {
            if(!(_loc9_ = this._targetToCaught[_loc8_]).isCaught)
            {
               _loc10_ = _loc9_.onFloor;
               _loc11_ = _world.mainContainer.globalToLocal(_loc9_.localToGlobal(new Point(0,0)));
               _loc12_ = Infinity;
               _loc13_ = Infinity;
               if(_inside == null)
               {
                  if(_loc9_.inside == null || _loc9_.inside is FacilityElevatorBody)
                  {
                     if(_loc6_ == _loc10_)
                     {
                        _loc12_ = Math.abs(_loc5_.x - _loc11_.x);
                        _loc13_ = 0;
                     }
                     else
                     {
                        _loc14_ = _world.floorList.indexOf(_loc10_);
                        _loc13_ = Math.abs(_loc7_ - _loc14_);
                     }
                  }
                  else if(_loc9_.inside is FacilityStairs)
                  {
                     if((_loc16_ = (_loc15_ = _loc9_.inside).entrancePosition(_loc5_.y)) != null)
                     {
                        _loc13_ = 0;
                        _loc12_ = Math.abs(_loc5_.x - _loc16_.x) + Math.abs(_loc16_.x - _loc11_.x);
                     }
                     else
                     {
                        _loc17_ = _loc15_.upperEnterance;
                        _loc18_ = _loc15_.lowerEnterance;
                        _loc19_ = _world.mainContainer.globalToLocal(_loc15_.localToGlobal(_loc17_));
                        _loc20_ = _world.mainContainer.globalToLocal(_loc15_.localToGlobal(_loc18_));
                        _loc21_ = _world.getFloorAt(_loc19_.y);
                        _loc22_ = _world.getFloorAt(_loc19_.y);
                        _loc23_ = _world.floorList.indexOf(_loc21_);
                        _loc24_ = _world.floorList.indexOf(_loc22_);
                        _loc13_ = Math.min(Math.abs(_loc7_ - _loc23_),Math.abs(_loc7_ - _loc24_));
                     }
                  }
               }
               if(_loc13_ < _loc4_)
               {
                  _loc2_ = _loc9_;
                  _loc4_ = _loc13_;
                  _loc3_ = _loc12_;
               }
               else if(_loc13_ == _loc3_)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = _loc9_;
                     _loc4_ = _loc13_;
                     _loc3_ = _loc12_;
                  }
                  else if(_loc12_ < _loc3_)
                  {
                     _loc2_ = _loc9_;
                     _loc3_ = _loc12_;
                     _loc4_ = _loc13_;
                  }
                  else if(_loc12_ == _loc3_)
                  {
                     if(Calculate.chance(50))
                     {
                        _loc2_ = _loc9_;
                        _loc3_ = _loc12_;
                        _loc4_ = _loc13_;
                     }
                  }
               }
            }
            _loc8_++;
         }
         return _loc2_;
      }
      
      function checkBanditIsOutRange() : void
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
         if(_destination != "home" && !_inHome)
         {
            _loc1_ = new Array();
            _loc2_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc3_ = 0;
            while(_loc3_ < this._targetToCaught.length)
            {
               if((_loc4_ = this._targetToCaught[_loc3_]).stage == null)
               {
                  _loc1_.push(_loc4_);
               }
               else if(_loc4_ is Thief && _world.thiefList.indexOf(_loc4_) < 0)
               {
                  _loc1_.push(_loc4_);
               }
               else if(_loc4_ is Litter && _world.litterList.indexOf(_loc4_) < 0)
               {
                  _loc1_.push(_loc4_);
               }
               else
               {
                  _loc5_ = _world.mainContainer.globalToLocal(_loc4_.localToGlobal(new Point(0,0)));
                  if((_loc6_ = Math.abs(_loc5_.y - _loc2_.y)) >= 60)
                  {
                     _loc1_.push(_loc4_);
                  }
                  else
                  {
                     _loc7_ = Math.abs(_loc5_.x - _loc2_.x);
                     _loc8_ = 1;
                     if(!inSight(_loc4_))
                     {
                        _loc8_ = 0.25;
                     }
                     if(_loc7_ >= getSight() * _loc8_)
                     {
                        _loc1_.push(_loc4_);
                     }
                  }
                  if(_loc4_.isCaught)
                  {
                     _loc1_.push(_loc4_);
                  }
                  else if(_loc4_.inside is Elevator)
                  {
                     _loc1_.push(_loc4_);
                  }
               }
               _loc3_++;
            }
            while(_loc1_.length > 0)
            {
               _loc4_ = _loc1_.pop();
               if((_loc9_ = this._targetToCaught.indexOf(_loc4_)) >= 0)
               {
                  this._targetToCaught.splice(_loc9_,1);
               }
            }
         }
         else
         {
            while(this._targetToCaught.length > 0)
            {
               this._targetToCaught.shift();
            }
         }
      }
      
      function searchTarget() : void
      {
         if(!_inHome && _destination != "home")
         {
            this.searchThiefTarget();
            this.searchSaboteurTarget();
         }
      }
      
      function searchThiefTarget() : void
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
            while(_loc2_ < _world.thiefList.length)
            {
               _loc3_ = _world.thiefList[_loc2_];
               if(!(_loc3_.inside is Booth || _loc3_.inside is Elevator || _loc3_.isCaught))
               {
                  if((_loc4_ = this._targetToCaught.indexOf(_loc3_)) < 0)
                  {
                     _loc5_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
                     _loc6_ = false;
                     if(_inside == null)
                     {
                        if(_loc3_.inside == null || _loc3_.inside is FacilityElevatorBody)
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
                     }
                     if(inSight(_loc3_) && _loc6_)
                     {
                        this._targetToCaught.push(_loc3_);
                        _loc3_.addListenerOf(_loc3_,HumanEvent.EXILE,this.thiefRemoved);
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      function thiefRemoved(param1:Event) : void
      {
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this._targetToCaught.indexOf(_loc2_);
         if(_loc3_ in this._targetToCaught)
         {
            this._targetToCaught.splice(_loc3_,1);
         }
         if(this._targetToCaught.length == 0)
         {
            _movePoint = null;
            if(!_inHome && _destination != "home")
            {
               noTargetCheck();
            }
         }
         _loc2_.removeListenerOf(_loc2_,HumanEvent.EXILE,this.thiefRemoved);
      }
      
      function searchSaboteurTarget() : void
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
            while(_loc2_ < _world.litterList.length)
            {
               _loc3_ = _world.litterList[_loc2_];
               if(!_loc3_.isCaught)
               {
                  if((_loc4_ = this._targetToCaught.indexOf(_loc3_)) < 0)
                  {
                     _loc5_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
                     _loc6_ = false;
                     if(_inside == null)
                     {
                        if(_loc3_.inside == null || _loc3_.inside is FacilityElevatorBody)
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
                     }
                     if(inSight(_loc3_) && _loc6_)
                     {
                        this._targetToCaught.push(_loc3_);
                        _loc3_.addListenerOf(_loc3_,HumanEvent.EXILE,this.thiefRemoved);
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      override function destinationTargetCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(_destination == null && !_inHome)
         {
            if(_movePoint == null)
            {
               if(_floorTarget == null)
               {
                  if(Calculate.chance(30))
                  {
                     _floorTarget = _world.floorList[Math.floor(Math.random() * (_world.floorList.length - 1))];
                  }
                  if(_floorTarget != null)
                  {
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
                        _loc3_ = Math.random() * (_loc1_.right - _loc1_.left) + _loc1_.left;
                        _floorPoint = new Point(_loc3_,_floorTarget.y);
                     }
                  }
                  else if(Calculate.chance(40))
                  {
                     if(_inside == null)
                     {
                        if((_loc4_ = onFloor) != null)
                        {
                           _loc1_ = null;
                           _loc2_ = _world.floorList.indexOf(_loc4_);
                           if(_loc2_ + 1 in _world.floorList)
                           {
                              _loc1_ = _world.floorList[_loc2_ + 1];
                           }
                           else
                           {
                              _loc1_ = _loc4_;
                           }
                           if(_loc1_ != null)
                           {
                              _loc3_ = Math.random() * (_loc1_.right - _loc1_.left) + _loc1_.left;
                              _movePoint = new Point(_loc3_,_loc4_.y);
                           }
                        }
                     }
                  }
               }
            }
         }
         super.destinationTargetCheck();
      }
      
      override function searchAvailableTransport(param1:*, param2:*, param3:Point, param4:Point) : Object
      {
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:Point = null;
         var _loc19_:* = undefined;
         var _loc20_:Point = null;
         var _loc21_:* = undefined;
         var _loc22_:* = undefined;
         var _loc23_:* = undefined;
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
         if(_world.basementFloorList.indexOf(param2) >= 0)
         {
            (_loc14_ = new Object()).cost = 0;
            _loc14_.target = "connection";
            _loc14_.prev = _loc10_;
            _loc10_ = _loc14_;
         }
         _loc7_.push(_loc10_);
         var _loc11_:* = 0;
         while(_loc11_ < _world.transportList.length)
         {
            if((_loc15_ = _world.transportList[_loc11_]) is FacilityStairs)
            {
               if(_loc15_.lowerEnterance.y <= _loc8_ && _loc15_.upperEnterance.y >= _loc9_)
               {
                  (_loc16_ = new Object()).cost = Infinity;
                  _loc16_.target = _loc15_;
                  _loc16_.prev = null;
                  _loc7_.push(_loc16_);
               }
            }
            _loc11_++;
         }
         var _loc12_:*;
         (_loc12_ = new Object()).cost = Infinity;
         _loc12_.target = param3;
         _loc12_.prev = null;
         if(_world.basementFloorList.indexOf(param1) >= 0)
         {
            (_loc17_ = new Object()).cost = Infinity;
            _loc17_.target = "connection";
            _loc12_.cost = 0;
            _loc12_.prev = _loc17_;
            _loc12_ = _loc17_;
         }
         _loc7_.push(_loc12_);
         _loc7_.sortOn("cost",Array.NUMERIC);
         var _loc13_:* = _loc7_.shift();
         while(_loc13_ != _loc12_ && _loc7_.length > 0)
         {
            _loc18_ = null;
            if(_loc13_.target is Point)
            {
               _loc18_ = _loc13_.target;
            }
            else if(_loc13_.target == "connection")
            {
               _loc18_ = _world.connectionSurface.enterancePosition;
            }
            else if(_loc13_.target is FacilityStairs)
            {
               if(_loc6_)
               {
                  _loc18_ = _loc13_.target.lowerEnterance;
               }
               else
               {
                  _loc18_ = _loc13_.target.upperEnterance;
               }
            }
            _loc11_ = 0;
            while(_loc11_ < _loc7_.length)
            {
               _loc19_ = _loc7_[_loc11_];
               _loc20_ = null;
               _loc21_ = 0;
               if(_loc19_.target is Point)
               {
                  _loc20_ = _loc19_.target;
               }
               else if(_loc19_.target == "connection")
               {
                  _loc20_ = _world.connectionSurface.enterancePosition;
               }
               else if(_loc19_.target is FacilityStairs)
               {
                  if(_loc6_)
                  {
                     _loc20_ = _loc19_.target.upperEnterance;
                  }
                  else
                  {
                     _loc20_ = _loc19_.target.lowerEnterance;
                  }
               }
               if(_loc18_.y == _loc20_.y)
               {
                  _loc22_ = Math.round(Math.abs(_loc18_.x - _loc20_.x) / 12) * 12;
                  _loc23_ = _loc13_.cost + _loc22_ + _loc21_;
                  if(_loc19_.cost > _loc23_)
                  {
                     _loc19_.cost = _loc23_;
                     _loc19_.prev = _loc13_;
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
      
      public function get targetToCaught() : Array
      {
         return this._targetToCaught;
      }
   }
}
