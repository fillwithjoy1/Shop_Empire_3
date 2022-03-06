package Instance.property
{
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.gameplay.StaffGuard;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class FacilityGuardPost extends Building
   {
       
      
      var _guardTakeCare:StaffGuard;
      
      var _guardInPosition:Boolean;
      
      public function FacilityGuardPost()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(this._guardTakeCare != null)
         {
            this._guardTakeCare.transform.colorTransform = new ColorTransform(1,0.82,0,1,0,0,0,0);
         }
         addListenerOf(this,GameEvent.BEFORE_DESTROY_CHECK,this.destroyedCheck);
         addListenerOf(stage,GameEvent.BUILDING_CREATED,this.relocateCheck);
      }
      
      function relocateCheck(param1:GameEvent) : void
      {
         var _loc2_:* = param1.tag;
         if(_loc2_ == this)
         {
            if(this._guardTakeCare != null)
            {
               if(this._guardInPosition)
               {
                  this._guardTakeCare.x = this.x;
                  this._guardTakeCare.y = this.y;
               }
            }
         }
      }
      
      function destroyedCheck(param1:GameEvent) : void
      {
         if(this._guardTakeCare != null)
         {
            this._guardTakeCare.guardPost = null;
            this._guardTakeCare.dispatchEvent(new CommandEvent(CommandEvent.FIRE_STAFF));
         }
      }
      
      override function buildingOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.BOOTH_ON_SELECT));
      }
      
      override public function loadCondition(param1:*) : void
      {
         super.loadCondition(param1);
         this._guardInPosition = param1.guardInPosition;
      }
      
      override public function saveCondition(param1:*) : void
      {
         super.saveCondition(param1);
         param1.guardInPosition = this._guardInPosition;
      }
      
      public function createSpecialGuard(param1:*) : void
      {
         var _loc2_:* = new StaffGuard();
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.world = _world;
         _loc2_.level = 3;
         var _loc3_:HumanStat = new HumanStat();
         _loc3_.stamina = 50;
         _loc3_.hygine = 50;
         _loc3_.entertain = 50;
         _loc3_.sight = 50;
         _loc3_.speed = 50;
         _loc2_.stat = _loc3_;
         _loc2_.workTime.workStart = 9;
         _loc2_.workTime.workEnd = 5;
         _loc2_.guardPost = this;
         _loc2_.basicPayment = 0;
         _loc2_.transform.colorTransform = new ColorTransform(1,0.82,0,1,0,0,0,0);
         this._guardTakeCare = _loc2_;
         this._guardInPosition = true;
         _world.staffList.guard.push(_loc2_);
         _world.staffList.unshown.push(_loc2_);
         _world.addHuman(_loc2_);
      }
      
      public function set guardTakeCare(param1:StaffGuard) : void
      {
         this._guardTakeCare = param1;
      }
      
      public function get guardTakeCare() : StaffGuard
      {
         return this._guardTakeCare;
      }
      
      public function set guardInPosition(param1:Boolean) : void
      {
         this._guardInPosition = param1;
      }
      
      public function get guardInPosition() : Boolean
      {
         return this._guardInPosition;
      }
      
      override public function get numberPeople() : int
      {
         if(this._guardInPosition)
         {
            return 1;
         }
         return 0;
      }
   }
}
