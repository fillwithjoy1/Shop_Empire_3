package Instance.events
{
   import flash.events.Event;
   
   public class SliderBarEvent extends Event
   {
      
      public static const CHANGE_POSITION = "changePosition";
       
      
      public function SliderBarEvent(param1:String)
      {
         super(param1,true,true);
      }
      
      override public function clone() : Event
      {
         return new SliderBarEvent(type);
      }
   }
}
