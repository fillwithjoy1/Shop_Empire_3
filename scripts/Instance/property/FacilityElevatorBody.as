package Instance.property
{
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FacilityElevatorBody extends Building
   {
       
      
      var _elevatorLink:Elevator;
      
      var _queueLine:Array;
      
      public function FacilityElevatorBody()
      {
         super();
         this._queueLine = new Array();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.checkQueue);
      }
      
      override function buildingOnClick(param1:MouseEvent) : void
      {
         if(this._elevatorLink != null)
         {
            if(this._elevatorLink.canClick)
            {
               this._elevatorLink.dispatchEvent(new CommandEvent(CommandEvent.ELEVATOR_ON_SELECT));
            }
         }
      }
      
      function checkQueue(param1:GameEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this._elevatorLink.escapePassanger.length == 0)
         {
            _loc2_ = this.getChildAt(0);
            _loc3_ = _loc2_.getChildByName("door");
            if(_loc3_ != null)
            {
               if(_loc3_.isOpen)
               {
                  while(this._queueLine.length > 0 && this._elevatorLink.passanger.length < this._elevatorLink.capacityLimit)
                  {
                     _loc4_ = this._queueLine.shift();
                     if(this._elevatorLink.passanger.indexOf(_loc4_) < 0)
                     {
                        this._elevatorLink.passanger.push(_loc4_);
                     }
                  }
                  if(this._elevatorLink.passanger.length >= this._elevatorLink.capacityLimit)
                  {
                     trace("limit overload");
                  }
               }
            }
         }
      }
      
      public function set elevatorLink(param1:Elevator) : void
      {
         this._elevatorLink = param1;
      }
      
      public function get elevatorLink() : Elevator
      {
         return this._elevatorLink;
      }
      
      override public function addPerson(param1:*, param2:Boolean = false) : void
      {
         super.addPerson(param1);
         if(this._queueLine.indexOf(param1) < 0)
         {
            this._queueLine.push(param1);
         }
         this._elevatorLink.putTarget(this);
      }
      
      public function get queueLine() : Array
      {
         return this._queueLine;
      }
   }
}
