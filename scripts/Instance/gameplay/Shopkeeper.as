package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.modules.Calculate;
   import Instance.property.BoothColloseum;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Shopkeeper extends Human
   {
       
      
      var _boothInAction;
      
      public function Shopkeeper()
      {
         super();
         _inHome = true;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         addListenerOf(_world,GameEvent.BEFORE_DESTROY_CHECK,this.checkBoothDestroyed);
         super.Initialize(param1);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.checkGameTime);
      }
      
      function checkBoothDestroyed(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._boothInAction)
         {
            if(_inside == _loc2_)
            {
               trace("lagi jaga diancurno");
               this.visible = true;
            }
            _destination = "home";
            this._boothInAction = null;
         }
      }
      
      function checkGameTime(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = param1.tag;
         if(_inHome)
         {
            if(this._boothInAction != null)
            {
               _loc3_ = 0;
               if(_loc2_.hour < 17)
               {
                  if(_loc2_.hour >= 10)
                  {
                     _loc3_ = 100;
                  }
                  else if(_loc2_.hour >= 9)
                  {
                     if(_loc2_.minute < 30)
                     {
                        _loc3_ = (_loc2_.minute + 60) / 90 * 100;
                     }
                     else
                     {
                        _loc3_ = 100;
                     }
                  }
                  else if(_loc2_.hour >= 8)
                  {
                     _loc3_ = (_loc2_.minute - 30) / 90 * 100;
                  }
               }
               if(Calculate.chance(_loc3_))
               {
                  _inHome = false;
                  this.visible = true;
               }
            }
         }
         else if(_destination == null)
         {
            if(_loc2_.hour >= 22 || _loc2_.hour < 8)
            {
               _loc4_ = true;
               if(this._boothInAction.serveMode != BuildingData.SERVICE)
               {
                  _loc4_ = this._boothInAction.visitorList.length == 0;
               }
               else if((_loc5_ = this._boothInAction.shopkeeperList.indexOf(this)) in this._boothInAction.visitorInService)
               {
                  _loc4_ = this._boothInAction.visitorInService[_loc5_] == null;
               }
               if(_loc4_)
               {
                  _destination = "home";
                  addListenerOf(this,HumanEvent.EXIT_THE_BUILDING,this.exitToHome);
               }
            }
         }
      }
      
      function exitToHome(param1:HumanEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.tag;
         if(_loc2_ == this._boothInAction)
         {
            _loc3_ = _loc2_.shopkeeperAbsense.indexOf(this);
            if(_loc3_ in _loc2_.shopkeeperAbsense)
            {
               _loc2_.shopkeeperAbsense.splice(_loc3_,1);
               if(_loc2_ is BoothColloseum)
               {
                  _loc2_.openCloseCheck();
               }
               else if(_loc2_.shopkeeperAbsense.length <= 0)
               {
                  _loc2_.open = false;
               }
            }
         }
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         if(!_inside && !_inHome && this._boothInAction != null)
         {
            if(_destination == null)
            {
               _destination = this._boothInAction;
            }
            if(_world.deepRain && _world.weather <= -20)
            {
               _run = !insideMall;
            }
            else
            {
               _run = false;
            }
         }
         super.behavior(param1);
      }
      
      override function inHomeBehaviorCheck() : void
      {
         var _loc1_:* = undefined;
         if(this._boothInAction != null)
         {
            super.inHomeBehaviorCheck();
         }
         else
         {
            _loc1_ = _world.humanList.indexOf(this);
            if(_loc1_ in _world.humanList)
            {
               _world.humanList.splice(_loc1_,1);
            }
            this.parent.removeChild(this);
         }
      }
      
      override function insideBoothCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(_inside != null)
         {
            if(_inside == this._boothInAction)
            {
               _loc1_ = _inside.shopkeeperList.indexOf(this);
               if(_loc1_ in _inside.employeeClipList && _loc1_ in _inside.employeeInPosition)
               {
                  if(_destination != null && _destination != _inside)
                  {
                     _inside.employeeInPosition[_loc1_] = false;
                     _inside.employeeClipList[_loc1_].visible = false;
                     this.visible = true;
                  }
                  else
                  {
                     _loc2_ = _inside.employeeClipList[_loc1_];
                     _loc3_ = Math.abs(this.x - _loc2_.x);
                     if(_loc3_ > 0)
                     {
                        _movePoint = new Point(_loc2_.x,_loc2_.y);
                     }
                     else
                     {
                        _inside.employeeInPosition[_loc1_] = true;
                        if(!(_inside is BoothColloseum))
                        {
                           _inside.employeeClipList[_loc1_].visible = true;
                        }
                        if(_inside.shopkeeperAbsense.indexOf(this) < 0)
                        {
                           _inside.shopkeeperAbsense.push(this);
                           if(_inside is BoothColloseum)
                           {
                              _inside.openCloseCheck();
                           }
                           else if(!_inside.open)
                           {
                              _inside.open = true;
                           }
                        }
                        this.visible = false;
                     }
                  }
               }
               else
               {
                  if(_inside.shopkeeperAbsense.indexOf(this) < 0)
                  {
                     _inside.shopkeeperAbsense.push(this);
                  }
                  if(!_inside.open)
                  {
                     _inside.open = true;
                  }
               }
            }
         }
         super.insideBoothCheck();
      }
      
      public function set boothInAction(param1:*) : void
      {
         this._boothInAction = param1;
      }
      
      public function get boothInAction() : *
      {
         return this._boothInAction;
      }
   }
}
