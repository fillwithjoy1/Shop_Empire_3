package Instance.property
{
   import Instance.events.CommandEvent;
   import Instance.events.HumanEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class FacilityRestRoom extends Building
   {
       
      
      var pastMaleRoom;
      
      var pastFemaleRoom;
      
      public function FacilityRestRoom()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.maleRoom.relatedRestroom = this;
         this.femaleRoom.relatedRestroom = this;
      }
      
      override function beforeUpgradeCheck() : void
      {
         this.pastMaleRoom = this.maleRoom;
         this.pastFemaleRoom = this.femaleRoom;
      }
      
      override function afterUpgradeCheck() : void
      {
         var _loc2_:* = undefined;
         super.afterUpgradeCheck();
         var _loc1_:* = 0;
         while(_loc1_ < this.pastMaleRoom.humanList.length)
         {
            _loc2_ = this.pastMaleRoom.humanList[_loc1_];
            this.maleRoom.humanList.push(_loc2_);
            this.maleRoom.humanContainer.addChild(_loc2_);
            _loc2_.dispatchEvent(new HumanEvent(HumanEvent.CHANGE_INSIDE,this.maleRoom));
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.pastFemaleRoom.humanList.length)
         {
            _loc2_ = this.pastFemaleRoom.humanList[_loc1_];
            this.femaleRoom.humanList.push(_loc2_);
            this.femaleRoom.humanContainer.addChild(_loc2_);
            _loc2_.dispatchEvent(new HumanEvent(HumanEvent.CHANGE_INSIDE,this.femaleRoom));
            _loc1_++;
         }
         this.maleRoom.relatedRestroom = this;
         this.femaleRoom.relatedRestroom = this;
      }
      
      override function buildingOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.BOOTH_ON_SELECT));
      }
      
      public function get maleRoom() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = null;
         if(this.numChildren > 0)
         {
            _loc2_ = this.getChildAt(0);
            _loc3_ = _loc2_.getChildByName("maleRoom");
            if(_loc3_ != null)
            {
               _loc1_ = _loc3_ as InsideRestroom;
            }
         }
         return _loc1_;
      }
      
      public function get femaleRoom() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = null;
         if(this.numChildren > 0)
         {
            _loc2_ = this.getChildAt(0);
            _loc3_ = _loc2_.getChildByName("femaleRoom");
            if(_loc3_ != null)
            {
               _loc1_ = _loc3_ as InsideRestroom;
            }
         }
         return _loc1_;
      }
   }
}
