package Instance.events
{
   import flash.events.Event;
   
   public class LoopEvent extends Event
   {
      
      public static const ON_IDLE = "onIdle";
       
      
      public function LoopEvent(param1:String)
      {
         super(param1);
      }
      
      override public function clone() : Event
      {
         return new LoopEvent(type);
      }
   }
}
