package Instance.property
{
   import Instance.events.CommandEvent;
   import Instance.events.LoopEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class FacilityStairs extends Building
   {
       
      
      public var upperPos:Point;
      
      public var lowerPos:Point;
      
      var _passangerList:Array;
      
      var _stairWidth:Number;
      
      public function FacilityStairs()
      {
         super();
         this._passangerList = new Array();
         this._stairWidth = this.width;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addChildAt(_humanContainer,0);
         this.upperPos = new Point();
         this.upperPos.x = -(this._stairWidth - 24) / 2;
         this.upperPos.y = -84;
         this.lowerPos = new Point();
         this.lowerPos.x = (this._stairWidth - 24) / 2;
         this.lowerPos.y = 0;
         _level = 1;
      }
      
      public function correctPosition(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.inside == this)
         {
            _loc2_ = this.lowerPos.x - this.upperPos.x;
            _loc3_ = this.lowerPos.y - this.upperPos.y;
            _loc4_ = (this.lowerPos.x - param1.x + 6) / _loc2_;
            param1.y = this.lowerPos.y - _loc3_ * _loc4_;
            if(param1.y > this.lowerPos.y)
            {
               param1.y = this.lowerPos.y;
            }
            else if(param1.y < this.upperPos.y)
            {
               param1.y = this.upperPos.y;
            }
         }
      }
      
      override function buildingOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.BOOTH_ON_SELECT));
      }
      
      public function get upperPosition() : Point
      {
         var _loc1_:* = null;
         if(_world != null)
         {
            _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(this.upperPos));
         }
         return _loc1_;
      }
      
      public function get lowerPosition() : Point
      {
         var _loc1_:* = null;
         if(_world != null)
         {
            _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(this.lowerPos));
         }
         return _loc1_;
      }
      
      public function get upperEnterance() : Point
      {
         var _loc1_:* = null;
         if(_world != null)
         {
            _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(this.upperPos.x - 6,this.upperPos.y)));
         }
         return _loc1_;
      }
      
      public function get lowerEnterance() : Point
      {
         var _loc1_:* = null;
         if(_world != null)
         {
            _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(this.lowerPos.x + 6,this.lowerPos.y)));
         }
         return _loc1_;
      }
      
      public function entrancePosition(param1:Number) : Point
      {
         var _loc2_:* = null;
         if(this.upperEnterance.y == param1)
         {
            _loc2_ = this.upperEnterance;
         }
         else if(this.lowerPosition.y == param1)
         {
            _loc2_ = this.lowerEnterance;
         }
         return _loc2_;
      }
      
      override public function addPerson(param1:*, param2:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         super.addPerson(param1);
         if(!param2)
         {
            _loc3_ = _humanContainer.globalToLocal(param1.localToGlobal(new Point(0,0)));
            _loc4_ = _humanContainer.globalToLocal(param1.localToGlobal(new Point(1,0)));
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
         _humanContainer.addChild(param1);
         addListenerOf(param1,LoopEvent.ON_IDLE,this.checkPosition);
      }
      
      override public function removePerson(param1:*) : void
      {
         removeListenerOf(param1,LoopEvent.ON_IDLE,this.checkPosition);
         super.removePerson(param1);
      }
      
      function checkPosition(param1:LoopEvent) : void
      {
         this.correctPosition(param1.currentTarget);
      }
      
      override public function get relocateCost() : Number
      {
         return Infinity;
      }
   }
}
