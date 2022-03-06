package Instance.events
{
   import flash.events.Event;
   
   public class CommandEvent extends Event
   {
      
      public static const BEGIN_BUILD = "CommandEvent_BeginBuild";
      
      public static const BEGIN_EXPAND = "CommandEvent_BeginExpand";
      
      public static const BEGIN_HIRE = "CommandEvent_BeginHire";
      
      public static const ON_HIRE = "CommandEvent_OnHire";
      
      public static const CONFIRM_EXPAND = "CommandEvent_ConfirmExpand";
      
      public static const FINISH_EXPAND = "CommandEvent_FinishExpand";
      
      public static const BEGIN_NEW_GAME = "CommandEvent_BeginNewGame";
      
      public static const BEGIN_LOAD_GAME = "CommandEvent_BeginLoadGame";
      
      public static const BEGIN_SCROLL = "CommandEvent_BeginScroll";
      
      public static const CANCEL_BUILD = "CommandEvent_CancelBuild";
      
      public static const DECIDE_BUILD = "CommandEvent_DecideBuild";
      
      public static const DECIDE_RELOCATE = "CommandEvent_DecideRelocate";
      
      public static const DECIDE_HIRE = "CommandEvent_DecideHire";
      
      public static const DECIDE_NAME = "CommandEvent_DecideName";
      
      public static const DECLINE_HIRE = "CommandEvent_DeclineHire";
      
      public static const BOOTH_ON_SELECT = "CommandEvent_BoothOnSelect";
      
      public static const ELEVATOR_ON_SELECT = "CommandEvent_ElevatorOnSelect";
      
      public static const HALTE_ON_SELECT = "CommandEvent_HalteOnSelect";
      
      public static const HUMAN_ON_SELECT = "CommandEvent_HumanOnSelect";
      
      public static const BEGIN_DESTROY = "CommandEvent_BeginDestroy";
      
      public static const BEGIN_UPGRADE = "CommandEvent_BeginUpgrade";
      
      public static const BEGIN_RELOCATE = "CommandEvent_BeginRelocate";
      
      public static const DESTROY_BUILD = "CommandEvent_DestroyBuild";
      
      public static const UPGRADE_BUILD = "CommandEvent_UpgradeBuild";
      
      public static const BEGIN_PROMOTE = "CommandEvent_BeginPromote";
      
      public static const BEGIN_FIRE = "CommandEvent_BeginFire";
      
      public static const PROMOTE_STAFF = "CommandEvent_PromoteStaff";
      
      public static const FIRE_STAFF = "CommandEvent_FireStaff";
      
      public static const DECLINE_STAFF = "CommandEvent_DeclineStaff";
      
      public static const NEED_CONFIRMATION = "CommandEvent_NeedConfirmation";
      
      public static const SHOW_HIRE_PANEL = "CommandEvent_ShowHirePanel";
      
      public static const SPEED_CHANGE = "CommandEvent_SpeedChange";
      
      public static const REFRESH_APPLICANT = "CommandEvent_RefreshApplicant";
      
      public static const PANEL_NEED_TO_CLOSE = "CommandEvent_PanelNeedToClose";
      
      public static const MENU_SETTING = "CommandEvent_MenuSetting";
      
      public static const SHOW_ACHIEVEMENT_PAGE = "CommandEvent_ShowAchievementPage";
      
      public static const SHOW_MANUAL = "CommandEvent_ShowManual";
      
      public static const RESUME_GAME = "CommandEvent_ResumeGame";
      
      public static const ENTER_OPTION = "CommandEvent_EnterOption";
      
      public static const EXIT_OPTION = "CommandEvent_ExitOption";
      
      public static const SAVE_GAME = "CommandEvent_SaveGame";
      
      public static const EXIT_GAME = "CommandEvent_ExitGame";
      
      public static const BACK_TO_MAIN_MENU = "CommandEvent_BackToMainMenu";
      
      public static const DELETE_SAVE_DATA = "CommandEvent_DeleteSaveData";
       
      
      var _tag;
      
      public function CommandEvent(param1:String, param2:* = null)
      {
         super(param1,true,true);
         this._tag = param2;
      }
      
      override public function clone() : Event
      {
         return new CommandEvent(type,this._tag);
      }
      
      public function get tag() : *
      {
         return this._tag;
      }
   }
}
