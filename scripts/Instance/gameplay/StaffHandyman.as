package Instance.gameplay
{
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.modules.Calculate;
   import Instance.property.Building;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class StaffHandyman extends Staff
   {
       
      
      const REPAIR_MOD = [1,3,6];
      
      var canGain:Boolean = false;
      
      public function StaffHandyman()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(_world,GameEvent.BEFORE_DESTROY_CHECK,this.beforeBuildingWasDestroyed);
      }
      
      function beforeBuildingWasDestroyed(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_inside == _loc2_)
         {
            if(_doingJob)
            {
               _doingJob = false;
            }
         }
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         if(!_recovery)
         {
            this.searchTarget();
            if(_destination is Building)
            {
               if(!_destination.needRepair)
               {
                  _destination = null;
               }
            }
            super.behavior(param1);
         }
         else
         {
            recoveryCheck();
         }
      }
      
      override function searchTarget() : void
      {
         if(_destination == null)
         {
            if(!_inside && !_inHome && !_doingJob)
            {
               _destination = this.searchBrokenBuilding();
            }
         }
      }
      
      override function insideBuildingCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         super.insideBuildingCheck();
         if(_inside != null)
         {
            if(_inside is Building)
            {
               if(_inside.needRepair)
               {
                  if(_destination == null || _destination == _inside)
                  {
                     _loc1_ = Math.abs(this.x);
                     if(_loc1_ > 0)
                     {
                        _movePoint = new Point(0,0);
                     }
                     else if(!_doingJob)
                     {
                        _doingJob = true;
                     }
                     else if(_inside.brokenLevel > 0)
                     {
                        _loc2_ = Math.min(1,(Math.random() * 5 + 1) * this.REPAIR_MOD[_level - 1] / modTired) * (!!_inside.isBroken ? 1 : 2);
                        _loc3_ = 1;
                        if("repairBonus" in _world.upgradeModifier)
                        {
                           _loc3_ = 1 + _world.upgradeModifier["repairBonus"];
                        }
                        _inside.buildingHP += _loc2_ * _loc3_;
                     }
                  }
               }
               else if(_doingJob)
               {
                  _destination = "exit";
                  _doingJob = false;
               }
            }
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
            _loc1_ = staminaLossModifier * (!!_inside.isBroken ? 25 : 15) / STAMINA_LV[_level - 1];
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
      
      override function checkHomeWhenDoingJob() : void
      {
         _destination = "home";
         _doingJob = false;
         if(_salaryObject == this && !_fired)
         {
            dispatchEvent(new HumanEvent(HumanEvent.PAY_SALARY,_salaryObject));
         }
      }
      
      function searchBrokenBuilding() : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = _world.brokableBuildingList;
         var _loc3_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc4_:* = Infinity;
         var _loc5_:* = 0;
         while(_loc5_ < _loc2_.length)
         {
            if((_loc6_ = _loc2_[_loc5_]).y == _loc3_.y)
            {
               if(_loc6_.needRepair)
               {
                  if(inSight(_loc6_))
                  {
                     if((_loc7_ = Math.abs(_loc6_.enterancePosition.x - _loc3_.x)) < _loc4_)
                     {
                        _loc1_ = _loc6_;
                        _loc4_ = _loc7_;
                     }
                     else if(_loc7_ == _loc4_)
                     {
                        if(Calculate.chance(50))
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
         return _loc1_;
      }
   }
}
