package Instance.property
{
   import Instance.events.GameEvent;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class InsideRestroom extends Building
   {
       
      
      var _relatedRestroom;
      
      public function InsideRestroom()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(this._relatedRestroom != null)
         {
            _capacity = this._relatedRestroom.capacity;
            _world = this._relatedRestroom.world;
            addListenerOf(this._relatedRestroom,GameEvent.BEFORE_DESTROY_CHECK,this.beforeDestroyed);
         }
         var _loc2_:* = this.getChildAt(0);
         if(_loc2_ != null)
         {
            _humanContainer.visible = false;
            _loc2_.addChild(_humanContainer);
         }
      }
      
      function beforeDestroyed(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._relatedRestroom)
         {
            dispatchEvent(new GameEvent(GameEvent.DESTROY));
         }
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
      }
      
      public function overload(param1:*) : Boolean
      {
         return _humanList.indexOf(param1) >= _capacity;
      }
      
      public function get isFull() : Boolean
      {
         return _humanList.length >= _capacity;
      }
      
      public function set relatedRestroom(param1:*) : void
      {
         this._relatedRestroom = param1;
         if(this._relatedRestroom != null)
         {
            _capacity = this._relatedRestroom.capacity;
            _world = this._relatedRestroom.world;
         }
      }
      
      public function get relatedRestroom() : *
      {
         return this._relatedRestroom;
      }
   }
}
