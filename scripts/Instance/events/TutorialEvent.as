package Instance.events
{
   import flash.events.Event;
   
   public class TutorialEvent extends Event
   {
      
      public static const RUN_TUTORIAL = "TutorialEvent_RunTutorial";
      
      public static const TUTORIAL_SKIP = "TutorialEvent_TutorialSkip";
      
      public static const TUTORIAL_SKIP_ALL = "TutorialEvent_TutorialSkipAll";
       
      
      public function TutorialEvent(param1:String)
      {
         super(param1,true,true);
      }
      
      override public function clone() : Event
      {
         return new TutorialEvent(type);
      }
   }
}
