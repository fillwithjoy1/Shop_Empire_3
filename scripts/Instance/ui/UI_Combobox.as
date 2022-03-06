package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.ComboEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class UI_Combobox extends SEMovieClip
   {
       
      
      public var comboText:TextField;
      
      public var btnDropDown:dropdowntoggle;
      
      var _text:String;
      
      var tabToSelect;
      
      var _maxLine:uint;
      
      var _comboItem:Array;
      
      var itemListContainer:MovieClip;
      
      var _selected:int;
      
      public function UI_Combobox()
      {
         var _loc2_:* = undefined;
         super();
         var _loc1_:* = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            if(_loc2_ is DropDownList)
            {
               this.tabToSelect = _loc2_;
               break;
            }
            _loc1_++;
         }
         this._maxLine = 5;
         this._selected = -1;
         this._comboItem = new Array();
         this.itemListContainer = new MovieClip();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.hideDropDown();
         if(this.tabToSelect != null)
         {
            addListenerOf(this.tabToSelect,ComboEvent.ON_SELECT,this.itemSelected);
         }
         addListenerOf(this.btnDropDown,MouseEvent.CLICK,this.btnDropDownOnClick);
      }
      
      function itemSelected(param1:ComboEvent) : void
      {
         var _loc2_:* = param1.selected;
         if(_loc2_ in this._comboItem)
         {
            this._text = this._comboItem[_loc2_];
            this.comboText.text = this._text;
         }
         this.btnDropDown.isActive = false;
         if(this.tabToSelect != null)
         {
            if(getChildByName(this.tabToSelect.name))
            {
               removeChild(this.tabToSelect);
            }
         }
         dispatchEvent(new ComboEvent(ComboEvent.ON_CHANGE,_loc2_));
      }
      
      function btnDropDownOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(this.tabToSelect != null)
         {
            if(!_loc2_.isActive)
            {
               addChild(this.tabToSelect);
               dispatchEvent(new ComboEvent(ComboEvent.ON_SHOW_ITEM));
            }
            else
            {
               removeChild(this.tabToSelect);
            }
         }
      }
      
      public function addItem(param1:String) : void
      {
         this._comboItem.push(param1);
      }
      
      public function removeItemAt(param1:int) : void
      {
         if(param1 in this._comboItem)
         {
            this._comboItem.splice(param1,1);
         }
      }
      
      public function removeItem(param1:String, param2:int = 0) : void
      {
         var _loc3_:* = this._comboItem.indexOf(param1,param2);
         this.removeItemAt(_loc3_);
      }
      
      public function hideDropDown() : void
      {
         if(this.tabToSelect != null)
         {
            if(getChildByName(this.tabToSelect.name))
            {
               removeChild(this.tabToSelect);
            }
            this.btnDropDown.isActive = false;
         }
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         this.comboText.text = this._text;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function get comboItem() : Array
      {
         return this._comboItem;
      }
   }
}
