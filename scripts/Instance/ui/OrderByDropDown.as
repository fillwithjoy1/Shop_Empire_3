package Instance.ui
{
   import Instance.events.SliderBarEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class OrderByDropDown extends DropDownList
   {
       
      
      public var scrollBar:OrderBySlideBar;
      
      public var template:TextField;
      
      public var maskContainer:MovieClip;
      
      var itemContainer:MovieClip;
      
      var bottomLine;
      
      public function OrderByDropDown()
      {
         super();
         this.template.parent.removeChild(this.template);
         this.itemContainer = new MovieClip();
         addChild(this.itemContainer);
         this.itemContainer.mask = this.maskContainer;
         this.scrollBar.slideMode = this.scrollBar.VERTICAL;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         var _loc2_:* = this.parent;
         this.createItemFrom(_loc2_);
         addListenerOf(this.scrollBar,SliderBarEvent.CHANGE_POSITION,this.scrollPage);
         this.scrollBar.setPosition(this.scrollBar.getPosition());
      }
      
      function scrollPage(param1:SliderBarEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(this.bottomLine - 2 > this.maskContainer.height)
         {
            _loc3_ = this.bottomLine - this.maskContainer.height;
            this.itemContainer.y = this.maskContainer.y - _loc3_ * _loc2_.getPosition() - 1;
         }
      }
      
      function createItemFrom(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         this.removePreviousItem();
         this.bottomLine = 0;
         var _loc2_:UI_Combobox = param1 as UI_Combobox;
         if(_loc2_ != null)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.comboItem.length)
            {
               (_loc4_ = new MovieClip()).x = 0;
               _loc4_.y = _loc3_ * 10;
               _loc4_.graphics.clear();
               _loc4_.graphics.beginFill(16764006);
               _loc4_.graphics.drawRect(0,0,84,10);
               this.itemContainer.addChild(_loc4_);
               highlightedList.push(_loc4_);
               (_loc5_ = new TextField()).defaultTextFormat = this.template.defaultTextFormat;
               _loc5_.embedFonts = true;
               _loc5_.selectable = false;
               _loc5_.autoSize = TextFieldAutoSize.LEFT;
               _loc5_.text = _loc2_.comboItem[_loc3_];
               _loc5_.multiline = false;
               _loc5_.x = 1;
               _loc5_.y = _loc3_ * 10;
               this.itemContainer.addChild(_loc5_);
               (_loc6_ = new MovieClip()).x = 0;
               _loc6_.y = _loc3_ * 10;
               _loc6_.graphics.clear();
               _loc6_.graphics.beginFill(16764006,0);
               _loc6_.graphics.drawRect(0,0,84,10);
               _loc6_.buttonMode = true;
               this.itemContainer.addChild(_loc6_);
               overredList.push(_loc6_);
               this.bottomLine += 10;
               _loc3_++;
            }
         }
         this.itemContainer.graphics.beginFill(0,0);
         this.itemContainer.graphics.drawRect(0,0,72,this.bottomLine);
         this.itemContainer.graphics.endFill();
         this.scrollBar.visible = this.itemContainer.height > this.maskContainer.height;
         _loc3_ = 0;
         while(_loc3_ < highlightedList.length)
         {
            highlightedList[_loc3_].visible = false;
            this.itemContainer.setChildIndex(highlightedList[_loc3_],0);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < overredList.length)
         {
            this.itemContainer.setChildIndex(overredList[_loc3_],this.itemContainer.numChildren - 1);
            overredList[_loc3_].buttonMode = true;
            addListenerOf(overredList[_loc3_],MouseEvent.ROLL_OVER,overredItemOnOver);
            addListenerOf(overredList[_loc3_],MouseEvent.CLICK,overredItemOnClick);
            _loc3_++;
         }
      }
      
      function removePreviousItem() : void
      {
         var _loc1_:* = undefined;
         while(highlightedList.length > 0)
         {
            highlightedList.shift();
         }
         while(overredList.length > 0)
         {
            _loc1_ = overredList.shift();
            removeListenerOf(_loc1_,MouseEvent.ROLL_OVER,overredItemOnOver);
            removeListenerOf(_loc1_,MouseEvent.CLICK,overredItemOnClick);
         }
         this.itemContainer.graphics.clear();
         while(this.itemContainer.numChildren > 0)
         {
            this.itemContainer.removeChildAt(0);
         }
      }
   }
}
