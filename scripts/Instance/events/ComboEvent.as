package Instance.events
{
   import flash.events.Event;
   
   public class ComboEvent extends Event
   {
      
      public static const ON_SELECT = "ComboEvent_OnSelect";
      
      public static const ON_CHANGE = "ComboEvent_OnChange";
      
      public static const ON_SHOW_ITEM = "ComboEvent_OnShowItem";
       
      
      var _selected:int;
      
      public function ComboEvent(param1:String, param2:int = -1)
      {
         super(param1,true,true);
         this._selected = param2;
      }
      
      override public function clone() : Event
      {
         return new ComboEvent(type,this._selected);
      }
      
      public function get selected() : *
      {
         return this._selected;
      }
   }
}
