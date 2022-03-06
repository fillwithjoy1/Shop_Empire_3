package Instance.events
{
   import flash.events.Event;
   
   public class MissionEvent extends Event
   {
      
      public static const MISSION_SET = "MissionEvent_missionSet";
      
      public static const MISSION_SUCCESS = "MissionEvent_missionSuccess";
      
      public static const MISSION_CHANGE = "MissionEvent_missionChange";
      
      public static const SET_NEW_MISSION = "MissionEvent_setNewMission";
       
      
      public function MissionEvent(param1:String)
      {
         super(param1,true,true);
      }
      
      override public function clone() : Event
      {
         return new MissionEvent(type);
      }
   }
}
