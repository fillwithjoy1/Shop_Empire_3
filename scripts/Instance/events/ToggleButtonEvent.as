package Instance.events
{
   import flash.events.Event;
   
   public class ToggleButtonEvent extends Event
   {
      
      public static const ACTIVATE = "doActivate";
      
      public static const DEACTIVATE = "doDeactivate";
      
      public static const FORCE_ACTIVATE = "forceActivate";
      
      public static const FORCE_DEACTIVATE = "forceDeactivate";
       
      
      public function ToggleButtonEvent(param1:String)
      {
         super(param1,true,true);
      }
      
      override public function clone() : Event
      {
         return new ToggleButtonEvent(type);
      }
   }
}
