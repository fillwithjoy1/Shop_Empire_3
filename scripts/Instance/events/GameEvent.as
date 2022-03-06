package Instance.events
{
   import flash.events.Event;
   
   public class GameEvent extends Event
   {
      
      public static const GAME_UPDATE = "GameEvent_GameUpdate";
      
      public static const POSITION_CHANGE = "GameEvent_PositionUpdate";
      
      public static const RUN_BUILD_PROGRESS = "GameEvent_RunBuildProgress";
      
      public static const FINISH_BUILD_PROGRESS = "GameEvent_FinishBuildProgress";
      
      public static const FINISH_HIRE_PROGRESS = "GameEvent_FinishHireProgress";
      
      public static const HIRE_STAFF = "GameEvent_HireStaff";
      
      public static const BUILDING_CREATED = "GameEvent_BuildingCreated";
      
      public static const BUILDING_DESTROYED = "GameEvent_BuildingDestroyed";
      
      public static const BUILDING_BROKEN = "GameEvent_BuildingBroken";
      
      public static const BUILDING_REPAIRED = "GameEvent_BuildingRepaired";
      
      public static const DESTROY = "GameEvent_Destroy";
      
      public static const FIRE = "GameEvent_Fire";
      
      public static const BEFORE_DESTROY_CHECK = "GameEvent_BeforeDestroyCheck";
      
      public static const BONUS_GAIN = "GameEvent_BonusGain";
      
      public static const BONUS_TAKEN = "GameEvent_BonusTaken";
      
      public static const UPDATE_BUDGET = "GameEvent_UpdateBudget";
      
      public static const UPDATE_POPULARITY = "GameEvent_UpdatePopularity";
      
      public static const NEW_APPLICANT = "GameEvent_NewApplicant";
      
      public static const LOST_APPLICANT = "GameEvent_LostApplicant";
      
      public static const NOTIFICATION_END = "GameEvent_NotificationEnd";
      
      public static const SHOW_NOTIFICATION = "GameEvent_ShowNotification";
      
      public static const SHOW_MUTE_NOTIFICATION = "GameEvent_ShowMuteNotification";
      
      public static const HUMAN_ADDED = "GameEvent_HumanAdded";
      
      public static const BECOMES_UPGRADE = "GameEvent_BecomesUpgrade";
      
      public static const BUILDING_SUCCESSFULLY_UPGRADE = "GameEvent_BuildingSuccessfullyUpgrade";
      
      public static const PURCHASE_UPGRADE = "GameEvent_PurchaseUpgrade";
      
      public static const AFTER_UPGRADE_PURCHASED = "GameEvent_AfterUpgradePurchased";
      
      public static const LOST_HUMAN_FOCUS = "GameEvent_LostHumanFocus";
      
      public static const GAIN_EXPERIENCE = "GameEvent_GainExperience";
      
      public static const VISITOR_VISIT = "GameEvent_VisitorVisit";
      
      public static const BECOMES_ROBBED = "GameEvent_BecomesRobbed";
      
      public static const ALARM_TRIGGERED = "GameEvent_AlarmTriggered";
      
      public static const ALARM_STOPPED = "GameEvent_AlarmStopped";
      
      public static const SHOW_REPORT = "GameEvent_ShowReport";
      
      public static const ADD_CHAT_LOG = "GameEvent_AddChatLog";
      
      public static const ARRESTED = "GameEvent_Arrested";
      
      public static const SPECIAL_VISITOR_COME = "GameEvent_SpecialVisitorCome";
      
      public static const UNLOCK_NEW_BUILDING = "GameEvent_UnlockNewBuilding";
      
      public static const UNLOCK_NEW_UPGRADE = "GameEvent_UnlockNewUpgrade";
      
      public static const SAVE_GAME_DATA = "GameEvent_SaveGameData";
       
      
      var _tag;
      
      public function GameEvent(param1:String, param2:* = null)
      {
         super(param1,true,true);
         this._tag = param2;
      }
      
      override public function clone() : Event
      {
         return new GameEvent(type,this._tag);
      }
      
      public function get tag() : *
      {
         return this._tag;
      }
   }
}
