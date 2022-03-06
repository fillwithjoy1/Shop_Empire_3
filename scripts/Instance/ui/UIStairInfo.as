package Instance.ui
{
   import Instance.constant.BuildingData;
   import Instance.events.CommandEvent;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class UIStairInfo extends UI_InfoDialog
   {
       
      
      public var numberPeople:TextField;
      
      public var descriptionInfo:TextField;
      
      public var capacityIcon:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var buildIcon:MovieClip;
      
      public var bodyPartBottomLeft:MovieClip;
      
      public var connectionFloor:TextField;
      
      public var btnDestroy:SimpleButton;
      
      public var bodyPartBottomRight:MovieClip;
      
      public var bodyPartCenter:MovieClip;
      
      public var buildingName:TextField;
      
      public var bodyPartBottomCenter:MovieClip;
      
      public var bodyPartRight:MovieClip;
      
      public var bodyPartLeft:MovieClip;
      
      public var dragArea:MovieClip;
      
      public function UIStairInfo()
      {
         super();
         this.numberPeople.autoSize = TextFieldAutoSize.RIGHT;
         this.capacityIcon.gotoAndStop(1);
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.letterSpacing = -1;
         this.buildingName.defaultTextFormat = _loc1_;
         this.numberPeople.defaultTextFormat = _loc1_;
         this.descriptionInfo.defaultTextFormat = _loc1_;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         super.Initialize(param1);
         if(_relation != null)
         {
            _loc2_ = BuildingData.returnClassTo(Utility.getClass(_relation));
            if(_loc2_ != null)
            {
               this.buildIcon.gotoAndStop(BuildingData.getIconOf(_loc2_));
               if((_loc12_ = _relation.world.stairList.indexOf(_relation)) in _relation.world.stairList)
               {
                  this.buildingName.text = _loc2_ + " #" + (_loc12_ + 1);
               }
               this.descriptionInfo.text = BuildingData.getDescription(_loc2_);
            }
            this.checkCapacity(_relation);
            _loc3_ = _relation.lowerPosition;
            _loc4_ = _relation.upperPosition;
            _loc5_ = _relation.world.getFloorAt(_loc3_.y);
            _loc6_ = _relation.world.getFloorAt(_loc4_.y);
            _loc7_ = _relation.world.floorList.indexOf(_loc5_);
            _loc8_ = _relation.world.floorList.indexOf(_loc6_);
            _loc9_ = _loc7_ == 0 ? "Ground" : Utility.numberToOrdinal(_loc7_) + " floor";
            _loc10_ = _loc8_ == 0 ? "ground" : Utility.numberToOrdinal(_loc8_) + " floor";
            _loc11_ = _loc9_ + " to " + _loc10_;
            this.connectionFloor.text = _loc11_;
         }
         addListenerOf(this,Event.ENTER_FRAME,this.checkCondition);
         addListenerOf(this.btnDestroy,MouseEvent.CLICK,this.btnDestroyOnClick);
      }
      
      function checkCondition(param1:Event) : void
      {
         if(_relation != null)
         {
            this.checkCapacity(_relation);
         }
      }
      
      function checkCapacity(param1:*) : void
      {
         var _loc2_:* = "";
         _loc2_ = isFinite(param1.capacity) && !isNaN(param1.capacity) ? "/" + param1.capacity : "";
         this.numberPeople.text = "" + param1.humanList.length + "" + _loc2_;
         this.capacityIcon.x = Math.round(this.numberPeople.x + this.numberPeople.width - this.numberPeople.textWidth) - 12;
      }
      
      function btnDestroyOnClick(param1:MouseEvent) : void
      {
         _relation.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_DESTROY));
      }
   }
}
