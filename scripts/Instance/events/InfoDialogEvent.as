package Instance.events
{
   import flash.events.Event;
   
   public class InfoDialogEvent extends Event
   {
      
      public static const BEGIN_DRAG = "InfoDialogEvent_BeginDrag";
      
      public static const END_DRAG = "InfoDialogEvent_EndDrag";
       
      
      public function InfoDialogEvent(param1:String)
      {
         super(param1,true,true);
      }
      
      override public function clone() : Event
      {
         return new InfoDialogEvent(type);
      }
   }
}
