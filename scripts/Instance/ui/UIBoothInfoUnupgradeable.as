package Instance.ui
{
   import Instance.Gameplay;
   import Instance.constant.BuildingData;
   import Instance.constant.ColorCode;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.modules.Utility;
   import Instance.property.Elevator;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class UIBoothInfoUnupgradeable extends UI_InfoDialog
   {
       
      
      public var relocateCostInfo:TextField;
      
      public var numberPeople:TextField;
      
      public var btnRelocate:SimpleButton;
      
      public var descriptionInfo:TextField;
      
      public var capacityIcon:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var buildIcon:MovieClip;
      
      public var bodyPartBottomLeft:MovieClip;
      
      public var btnDestroy:SimpleButton;
      
      public var bodyPartBottomRight:MovieClip;
      
      public var buildingHeader:TextField;
      
      public var bodyPartCenter:MovieClip;
      
      public var buildingName:TextField;
      
      public var bodyPartBottomCenter:MovieClip;
      
      public var bodyPartRight:MovieClip;
      
      public var bodyPartLeft:MovieClip;
      
      public var dragArea:MovieClip;
      
      public function UIBoothInfoUnupgradeable()
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
         super.Initialize(param1);
         if(_relation != null)
         {
            _loc2_ = BuildingData.returnClassTo(Utility.getClass(_relation));
            if(_loc2_ != null)
            {
               this.buildingHeader.text = _loc2_.toUpperCase();
               this.buildIcon.gotoAndStop(BuildingData.getIconOf(_loc2_));
               _loc3_ = _relation.world.terraceList.indexOf(_relation);
               if(_loc3_ in _relation.world.terraceList)
               {
                  this.buildingName.text = _loc2_ + " #" + (_loc3_ + 1);
               }
               if((_loc4_ = _relation.world.guardPostList.indexOf(_relation)) in _relation.world.guardPostList)
               {
                  this.buildingName.text = _loc2_ + " #" + (_loc4_ + 1);
               }
               this.descriptionInfo.text = BuildingData.getDescription(_loc2_);
               this.relocateCostInfo.text = "" + Utility.numberToMoney(_relation.relocateCost) + " G";
               this.checkAvailableUpgrade(_relation.world.main);
            }
            this.checkCapacity(_relation);
         }
         addListenerOf(this,Event.ENTER_FRAME,this.checkCondition);
         addListenerOf(this.btnDestroy,MouseEvent.CLICK,this.btnDestroyOnClick);
         addListenerOf(this.btnRelocate,MouseEvent.CLICK,this.btnRelocateOnClick);
         addListenerOf(stage,GameEvent.UPDATE_BUDGET,this.whenBudgetChange);
      }
      
      function whenBudgetChange(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ is Gameplay)
         {
            this.checkAvailableUpgrade(_loc2_);
         }
      }
      
      function checkAvailableUpgrade(param1:*) : void
      {
         if(param1.isEnough(_relation.relocateCost))
         {
            this.relocateCostInfo.textColor = 16777215;
         }
         else
         {
            this.relocateCostInfo.textColor = ColorCode.NEGATIVE_CASH_ANIMATION;
         }
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
         this.numberPeople.text = "" + param1.numberPeople + "" + _loc2_;
         this.capacityIcon.x = Math.round(this.numberPeople.x + this.numberPeople.width - this.numberPeople.textWidth) - 12;
      }
      
      function btnDestroyOnClick(param1:MouseEvent) : void
      {
         _relation.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_DESTROY));
      }
      
      function btnRelocateOnClick(param1:MouseEvent) : void
      {
         if(!(_relation is Elevator))
         {
            _relation.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_RELOCATE));
            btnCloseOnClick(param1);
         }
      }
   }
}
