package Instance.gameplay
{
   import Instance.events.HumanEvent;
   import Instance.modules.Calculate;
   import Instance.property.FacilityElevatorBody;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class StaffJanitor extends Staff
   {
       
      
      var _toClean;
      
      var canGain:Boolean = false;
      
      public function StaffJanitor()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         if(!_recovery)
         {
            if(this._toClean == null)
            {
               this.searchTarget();
               super.behavior(param1);
            }
            else
            {
               this.staminaCheck();
               this.cleaningCheck();
            }
         }
         else
         {
            recoveryCheck();
         }
      }
      
      override function staminaCheck() : void
      {
         var _loc1_:* = undefined;
         if(!_doingJob)
         {
            super.staminaCheck();
         }
         else
         {
            _loc1_ = staminaLossModifier * 10 / STAMINA_LV[_level - 1];
            if(lossCarry > 100)
            {
               _loc1_ += Math.floor(lossCarry / 100);
               lossCarry -= 100;
            }
            _vitality -= Math.floor(_loc1_);
            if(_vitality < 0)
            {
               _vitality = 0;
               lossCarry = 0;
            }
            else
            {
               lossCarry += Math.round(_loc1_ * 100) % 100;
            }
            checkDepletedVitality();
            dispatchEvent(new HumanEvent(HumanEvent.UPDATE_VITALITY));
         }
      }
      
      override function expBehavior(param1:HumanEvent) : void
      {
         super.expBehavior(param1);
         if(!(_inHome && !_skipWork) && _destination != "home")
         {
            if(_doingJob)
            {
               if(this.canGain)
               {
                  gainExp(1);
               }
               this.canGain = !this.canGain;
            }
         }
      }
      
      override function get inWorking() : Boolean
      {
         return _doingJob;
      }
      
      function cleaningCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this._toClean != null)
         {
            if(this._toClean.dirtyLevel > 0)
            {
               if(!_doingJob)
               {
                  _doingJob = true;
                  currentAnimation = "cleaning";
               }
               else
               {
                  if(!_recovery)
                  {
                     if(currentAnimation != "cleaning")
                     {
                        currentAnimation = "cleaning";
                     }
                  }
                  _loc1_ = (Math.random() * 1.5 + 1) * (_stat.hygine / 100 * 1.2) * _level / modTired;
                  _loc2_ = 1;
                  if("cleaningBonus" in _world.upgradeModifier)
                  {
                     _loc2_ = 1 + _world.upgradeModifier["cleaningBonus"];
                  }
                  this._toClean.dirtyLevel = Math.max(0,this._toClean.dirtyLevel - _loc1_ * _loc2_);
               }
            }
            else
            {
               currentAnimation = "idle";
               _doingJob = false;
               _loc3_ = _world.trashList.indexOf(this._toClean);
               if(_loc3_ in _world.trashList)
               {
                  _world.trashList.splice(_loc3_,1);
               }
               if((_loc4_ = _world.pupList.indexOf(this._toClean)) in _world.pupList)
               {
                  _world.pupList.splice(_loc4_,1);
               }
               if(this._toClean.stage != null)
               {
                  this._toClean.parent.removeChild(this._toClean);
               }
               this._toClean = null;
            }
         }
      }
      
      override function destinationTargetCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(_destination is Trash)
         {
            _loc1_ = _world.getFloorAt(_destination.y);
            _loc2_ = _world.mainContainer.globalToLocal(_destination.localToGlobal(new Point(0,0)));
            _loc3_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc4_ = true;
            if(_loc1_ == _floorStep)
            {
               if(_inside == null)
               {
                  _floorTarget = null;
                  if((_loc5_ = Math.abs(_loc2_.x - _loc3_.x)) > 0)
                  {
                     if(_movePoint == null || _movePoint.x != _loc2_.x)
                     {
                        _movePoint = new Point(_loc2_.x,_loc2_.y);
                     }
                  }
                  else
                  {
                     _movePoint = null;
                     this._toClean = _destination;
                     _destination = null;
                  }
                  _destinationTransport = null;
                  _transportQueue = new Array();
               }
               else if(_world.transportList.indexOf(_inside) >= 0 || _inside is FacilityElevatorBody)
               {
                  _loc4_ = false;
               }
            }
            else
            {
               _loc4_ = false;
            }
            if(!_loc4_)
            {
               if(_floorTarget == null || _floorTarget != _loc1_)
               {
                  _floorTarget = _loc1_;
                  _floorPoint = _loc2_;
                  _destinationTransport = null;
                  _transportQueue = new Array();
               }
            }
         }
         else
         {
            super.destinationTargetCheck();
         }
      }
      
      override function checkHomeWhenDoingJob() : void
      {
         _destination = "home";
         if(this._toClean != null)
         {
            if(this._toClean.cleaner == this)
            {
               this._toClean.cleaner = null;
            }
         }
         _doingJob = false;
         this._toClean = null;
         if(_salaryObject == this && !_fired)
         {
            dispatchEvent(new HumanEvent(HumanEvent.PAY_SALARY,_salaryObject));
         }
      }
      
      override function searchTarget() : void
      {
         if(_destination == null)
         {
            if(!_inside && !_inHome && !_doingJob)
            {
               _destination = this.searchTrash();
            }
         }
      }
      
      function searchTrash() : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = _world.trashList.concat(_world.pupList);
         var _loc3_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc4_:* = Infinity;
         var _loc5_:* = 0;
         while(_loc5_ < _loc2_.length)
         {
            if((_loc6_ = _loc2_[_loc5_]).y == _loc3_.y)
            {
               if(_loc6_.dirtyLevel >= 10)
               {
                  if(inSight(_loc6_))
                  {
                     if((_loc7_ = Math.abs(_loc6_.x - _loc3_.x)) < _loc4_)
                     {
                        if(_loc6_.cleaner != null && _loc6_.cleaner != this && (_loc6_.cleaner.destination == _loc6_ || _loc6_.cleaner.destination == null))
                        {
                           _loc8_ = _world.mainContainer.globalToLocal(_loc6_.cleaner.localToGlobal(new Point(0,0)));
                           _loc10_ = (_loc9_ = Math.abs(_loc6_.x - _loc8_.x)) / _loc6_.cleaner.getSpeed();
                           if((_loc11_ = _loc7_ / getSpeed()) < _loc10_)
                           {
                              _loc1_ = _loc6_;
                              _loc4_ = _loc7_;
                           }
                        }
                        else
                        {
                           _loc1_ = _loc6_;
                           _loc4_ = _loc7_;
                        }
                     }
                     else if(_loc7_ == _loc4_)
                     {
                        if(_loc6_.cleaner == null && Calculate.chance(50))
                        {
                           _loc1_ = _loc6_;
                           _loc4_ = _loc7_;
                        }
                     }
                  }
               }
            }
            _loc5_++;
         }
         if(_loc1_ != null)
         {
            if(_loc1_.cleaner != null)
            {
               if(_loc1_.cleaner.destination == _loc1_)
               {
                  _loc1_.cleaner.destination = null;
               }
            }
            _loc1_.cleaner = this;
         }
         return _loc1_;
      }
   }
}
