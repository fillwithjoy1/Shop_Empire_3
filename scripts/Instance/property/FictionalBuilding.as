package Instance.property
{
   import Instance.events.GameEvent;
   import flash.events.Event;
   
   public class FictionalBuilding extends Booth
   {
       
      
      var _related;
      
      public function FictionalBuilding()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(this._related != null)
         {
            _capacity = this._related.capacity;
            _world = this._related.world;
            addListenerOf(this._related,GameEvent.BEFORE_DESTROY_CHECK,this.beforeRelatedDestroyed);
         }
         var _loc2_:* = this.getChildAt(0);
         if(_loc2_ != null)
         {
            _humanContainer.visible = false;
            _loc2_.addChild(_humanContainer);
         }
      }
      
      function beforeRelatedDestroyed(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._related)
         {
            dispatchEvent(new GameEvent(GameEvent.DESTROY));
         }
      }
      
      override public function removePerson(param1:*) : void
      {
         super.removePerson(param1);
         if(this._related != null)
         {
            this._related.removePerson(param1);
         }
      }
      
      public function set related(param1:*) : void
      {
         this._related = param1;
         if(this._related != null)
         {
            _capacity = this._related.capacity;
            _world = this._related.world;
         }
      }
      
      public function get related() : *
      {
         return this._related;
      }
      
      override public function get isBroken() : Boolean
      {
         if(this._related != null)
         {
            return this._related.isBroken;
         }
         return _isBroken;
      }
      
      override public function overload(param1:*) : Boolean
      {
         if(this._related is Booth)
         {
            return this._related.overload(param1);
         }
         return false;
      }
      
      override public function get isFull() : Boolean
      {
         if(this._related is Booth)
         {
            return this._related.isFull;
         }
         return false;
      }
   }
}
