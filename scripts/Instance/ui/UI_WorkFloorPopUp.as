package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.ComboEvent;
   import Instance.events.SliderBarEvent;
   import Instance.gameplay.World;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class UI_WorkFloorPopUp extends SEMovieClip
   {
       
      
      public var scrollBar:WorkFloorPopUpSlideBar;
      
      public var template:TextField;
      
      public var selectedMark:MovieClip;
      
      var highlightedList:Array;
      
      var overredList:Array;
      
      var _world:World;
      
      var _floorRelated:Object;
      
      var itemContainer:MovieClip;
      
      var maskContainer:MovieClip;
      
      public function UI_WorkFloorPopUp()
      {
         super();
         this.highlightedList = new Array();
         this.overredList = new Array();
         this.template.parent.removeChild(this.template);
         this.itemContainer = new MovieClip();
         this.scrollBar.slideMode = this.scrollBar.VERTICAL;
         this.maskContainer = new MovieClip();
         this.maskContainer.x = 4;
         this.maskContainer.y = 4;
         this.maskContainer.graphics.clear();
         this.maskContainer.graphics.beginFill(65280,0.2);
         this.maskContainer.graphics.drawRect(0,0,84,68);
         this.maskContainer.graphics.endFill();
         addChild(this.itemContainer);
         addChild(this.maskContainer);
         this.itemContainer.mask = this.maskContainer;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         this.refreshView();
         super.Initialize(param1);
         addListenerOf(this.scrollBar,SliderBarEvent.CHANGE_POSITION,this.scrollPage);
      }
      
      function scrollPage(param1:SliderBarEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(this.itemContainer.height > this.maskContainer.height)
         {
            _loc3_ = this.itemContainer.height - this.maskContainer.height;
            this.itemContainer.y = this.maskContainer.y - _loc3_ * _loc2_.getPosition();
         }
      }
      
      public function refreshView() : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         while(this.highlightedList.length > 0)
         {
            this.highlightedList.shift();
         }
         while(this.overredList.length > 0)
         {
            _loc6_ = this.overredList.shift();
            removeListenerOf(_loc6_,MouseEvent.ROLL_OVER,this.overredItemOnOver);
            removeListenerOf(_loc6_,MouseEvent.CLICK,this.overredItemOnClick);
         }
         this.itemContainer.graphics.clear();
         while(this.itemContainer.numChildren > 0)
         {
            this.itemContainer.removeChildAt(0);
         }
         this.itemContainer.x = 4;
         this.itemContainer.y = 4;
         var _loc1_:* = new MovieClip();
         _loc1_.x = 0;
         _loc1_.y = 2;
         _loc1_.graphics.clear();
         _loc1_.graphics.beginFill(16764006);
         _loc1_.graphics.drawRect(0,0,84,15);
         this.itemContainer.addChild(_loc1_);
         this.highlightedList.push(_loc1_);
         var _loc2_:* = new TextField();
         _loc2_.defaultTextFormat = this.template.defaultTextFormat;
         _loc2_.embedFonts = true;
         _loc2_.selectable = false;
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.text = "All";
         _loc2_.multiline = false;
         _loc2_.x = 22;
         _loc2_.y = 3;
         this.itemContainer.addChild(_loc2_);
         var _loc3_:* = new MovieClip();
         _loc3_.x = 0;
         _loc3_.y = 2;
         _loc3_.graphics.clear();
         _loc3_.graphics.beginFill(16764006,0);
         _loc3_.graphics.drawRect(0,0,84,15);
         _loc3_.buttonMode = true;
         this.itemContainer.addChild(_loc3_);
         this.overredList.push(_loc3_);
         var _loc4_:* = 3 + 14;
         var _loc5_:* = 0;
         while(_loc5_ < this._world.floorList.length - 1)
         {
            _loc1_ = new MovieClip();
            _loc1_.x = 0;
            _loc1_.y = 2 + 14 * (_loc5_ + 1);
            _loc1_.graphics.clear();
            _loc1_.graphics.beginFill(16764006);
            _loc1_.graphics.drawRect(0,0,84,15);
            this.itemContainer.addChild(_loc1_);
            this.highlightedList.push(_loc1_);
            (_loc7_ = new TextField()).defaultTextFormat = this.template.defaultTextFormat;
            _loc7_.embedFonts = true;
            _loc7_.selectable = false;
            _loc7_.autoSize = TextFieldAutoSize.LEFT;
            if(_loc5_ == 0)
            {
               _loc7_.text = "Ground";
            }
            else
            {
               _loc7_.text = Utility.numberToOrdinal(_loc5_) + " Floor";
            }
            _loc7_.multiline = false;
            _loc7_.x = 22;
            _loc7_.y = 3 + (_loc5_ + 1) * 14;
            this.itemContainer.addChild(_loc7_);
            _loc3_ = new MovieClip();
            _loc3_.x = 0;
            _loc3_.y = 2 + (_loc5_ + 1) * 14;
            _loc3_.graphics.clear();
            _loc3_.graphics.beginFill(16764006,0);
            _loc3_.graphics.drawRect(0,0,84,15);
            _loc3_.buttonMode = true;
            this.itemContainer.addChild(_loc3_);
            this.overredList.push(_loc3_);
            _loc4_ += 14;
            _loc5_++;
         }
         _loc4_ += 3;
         this.itemContainer.graphics.beginFill(0,0);
         this.itemContainer.graphics.drawRect(0,0,84,_loc4_);
         this.itemContainer.graphics.endFill();
         this.selectedMark.x = 9;
         if(this._floorRelated == null)
         {
            this.selectedMark.y = this.highlightedList[0].y + this.highlightedList[0].height / 2;
         }
         else
         {
            _loc8_ = this._world.floorList.indexOf(this._floorRelated);
            this.selectedMark.y = this.highlightedList[_loc8_ + 1].y + this.highlightedList[_loc8_ + 1].height / 2;
         }
         this.itemContainer.addChild(this.selectedMark);
         this.scrollBar.enabled = this.itemContainer.height > this.maskContainer.height;
         this.scrollBar.slideIndicator.visible = this.scrollBar.enabled;
         this.scrollBar.slideArea.visible = this.scrollBar.enabled;
         if(this.scrollBar.enabled)
         {
            this.scrollBar.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         else
         {
            this.scrollBar.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
         }
         _loc5_ = 0;
         while(_loc5_ < this.highlightedList.length)
         {
            this.highlightedList[_loc5_].visible = false;
            this.itemContainer.setChildIndex(this.highlightedList[_loc5_],0);
            _loc5_++;
         }
         _loc5_ = 0;
         while(_loc5_ < this.overredList.length)
         {
            this.itemContainer.setChildIndex(this.overredList[_loc5_],this.itemContainer.numChildren - 1);
            this.overredList[_loc5_].buttonMode = true;
            addListenerOf(this.overredList[_loc5_],MouseEvent.ROLL_OVER,this.overredItemOnOver);
            addListenerOf(this.overredList[_loc5_],MouseEvent.CLICK,this.overredItemOnClick);
            _loc5_++;
         }
      }
      
      function overredItemOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this.overredList.indexOf(_loc2_);
         dispatchEvent(new ComboEvent(ComboEvent.ON_SELECT,_loc3_));
      }
      
      function overredItemOnOver(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this.overredList.indexOf(_loc2_);
         if(_loc3_ in this.highlightedList)
         {
            this.highlightedList[_loc3_].visible = true;
         }
         addListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.overredItemOnOut);
      }
      
      function overredItemOnOut(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this.overredList.indexOf(_loc2_);
         if(_loc3_ in this.highlightedList)
         {
            this.highlightedList[_loc3_].visible = false;
         }
         removeListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.overredItemOnOut);
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function set floorRelated(param1:Object) : void
      {
         this._floorRelated = param1;
      }
      
      public function get floorRelated() : Object
      {
         return this._floorRelated;
      }
   }
}
