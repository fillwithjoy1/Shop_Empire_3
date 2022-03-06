package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.ComboEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class DropDownList extends SEMovieClip
   {
       
      
      public var highlighted2:MovieClip;
      
      public var highlighted3:MovieClip;
      
      public var highlighted0:MovieClip;
      
      public var highlighted1:MovieClip;
      
      public var overred2:MovieClip;
      
      public var overred3:MovieClip;
      
      public var overred0:MovieClip;
      
      public var overred1:MovieClip;
      
      public var selectedMark:MovieClip;
      
      var highlightedList:Array;
      
      var overredList:Array;
      
      public function DropDownList()
      {
         super();
         this.highlightedList = new Array();
         var _loc1_:* = 0;
         while(getChildByName("highlighted" + _loc1_))
         {
            this.highlightedList.push(getChildByName("highlighted" + _loc1_));
            _loc1_++;
         }
         this.overredList = new Array();
         _loc1_ = 0;
         while(getChildByName("overred" + _loc1_))
         {
            this.overredList.push(getChildByName("overred" + _loc1_));
            _loc1_++;
         }
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         var _loc2_:* = 0;
         while(_loc2_ < this.highlightedList.length)
         {
            this.highlightedList[_loc2_].visible = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.overredList.length)
         {
            this.overredList[_loc2_].buttonMode = true;
            addListenerOf(this.overredList[_loc2_],MouseEvent.ROLL_OVER,this.overredItemOnOver);
            addListenerOf(this.overredList[_loc2_],MouseEvent.CLICK,this.overredItemOnClick);
            _loc2_++;
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
   }
}
