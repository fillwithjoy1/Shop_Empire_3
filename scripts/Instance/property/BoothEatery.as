package Instance.property
{
   import Instance.events.LoopEvent;
   import flash.events.Event;
   
   public class BoothEatery extends Booth
   {
       
      
      var _dotGroup:Array;
      
      public function BoothEatery()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,LoopEvent.ON_IDLE,this.checkPosition);
      }
      
      function correctPosition(param1:*) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         while(_loc4_ < this._dotGroup.length)
         {
            if((_loc5_ = this._dotGroup[_loc4_]).x <= param1.x)
            {
               if(_loc2_ == null)
               {
                  _loc2_ = _loc5_;
               }
               else
               {
                  _loc6_ = Math.abs(param1.x - _loc5_.x);
                  _loc7_ = Math.abs(param1.x - _loc2_.x);
                  if(_loc6_ < _loc7_)
                  {
                     _loc2_ = _loc5_;
                  }
               }
            }
            if(_loc5_.x >= param1.x)
            {
               if(_loc3_ == null)
               {
                  _loc3_ = _loc5_;
               }
               else
               {
                  _loc6_ = Math.abs(param1.x - _loc5_.x);
                  _loc7_ = Math.abs(param1.x - _loc3_.x);
                  if(_loc6_ < _loc7_)
                  {
                     _loc3_ = _loc5_;
                  }
               }
            }
            _loc4_++;
         }
         if(_loc2_ == null && _loc3_ != null)
         {
            param1.y = _loc3_.y;
         }
         else if(_loc2_ != null && _loc3_ == null)
         {
            param1.y = _loc2_.y;
         }
         else if(_loc2_ != null && _loc3_ != null)
         {
            _loc8_ = _loc3_.x - _loc2_.x;
            _loc9_ = _loc3_.y - _loc2_.y;
            _loc10_ = (_loc3_.x - param1.x) / _loc8_;
            param1.y = _loc3_.y - _loc9_ * _loc10_;
         }
         else
         {
            param1.y = 0;
         }
      }
      
      function checkPosition(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(_employeeContainer != null)
         {
            _loc2_ = 0;
            while(_loc2_ < _humanList.length)
            {
               _loc3_ = _humanList[_loc2_];
               if(_employeeContainer.getChildByName(_loc3_.name))
               {
                  this.correctPosition(_loc3_);
               }
               _loc2_++;
            }
         }
      }
      
      override function createHumanContainer() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         super.createHumanContainer();
         if(body != null)
         {
            this._dotGroup = new Array();
            _loc1_ = 0;
            while(body.getChildByName("dot" + _loc1_) != null)
            {
               _loc2_ = body.getChildByName("dot" + _loc1_);
               this._dotGroup.push(_loc2_);
               _loc2_.visible = false;
               _loc1_++;
            }
         }
      }
   }
}
