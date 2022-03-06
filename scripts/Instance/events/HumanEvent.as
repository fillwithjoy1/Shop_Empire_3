package Instance.events
{
   import flash.events.Event;
   
   public class HumanEvent extends Event
   {
      
      public static const UPDATE_BEHAVIOR = "HumanEvent_UpdateBehavior";
      
      public static const ENTER_THE_BUILDING = "HumanEvent_Enter_The_Building";
      
      public static const EXIT_THE_BUILDING = "HumanEvent_Exit_The_Building";
      
      public static const CHANGE_DESTINATION = "HumanEvent_ChangeDestination";
      
      public static const CHANGE_INSIDE = "HumanEvent_ChangeInside";
      
      public static const UPDATE_VITALITY = "HumanEvent_UpdateVitality";
      
      public static const UPDATE_EXPERIENCE = "HumanEvent_UpdateExperience";
      
      public static const DROP_BONUS = "HumanEvent_DropBonus";
      
      public static const EXILE = "HumanEvent_Exile";
      
      public static const ESCAPE_FROM_GUARD = "HumanEvent_EscapeFromGuard";
      
      public static const SPENT_MONEY = "HumanEvent_SpentMoney";
      
      public static const RETURN_BOUNTY = "HumanEvent_ReturnBounty";
      
      public static const REFUND_MONEY = "HumanEvent_RefundMoney";
      
      public static const STEAL_MONEY = "HumanEvent_StealMoney";
      
      public static const MOOD_UPDATE = "HumanEvent_MoodUpdate";
      
      public static const END_CAST = "HumanEvent_EndCast";
      
      public static const BECOMES_PROMOTE = "HumanEvent_BecomesPromote";
      
      public static const BECOMES_FIRE = "HumanEvent_BecomesFire";
      
      public static const SPRITE_CORRECTION = "HumanEvent_SpriteCorrection";
      
      public static const PAY_SALARY = "HumanEvent_PaySallary";
      
      public static const SUCCESFULLY_PROMOTED = "HumanEvent_SuccesfullyPromoted";
      
      public static const CAST_SPELL = "HumanEvent_CastSpell";
      
      public static const COUNTER_SPELL = "HumanEvent_CounterSpell";
       
      
      var _tag;
      
      public function HumanEvent(param1:String, param2:* = null)
      {
         super(param1,true,true);
         this._tag = param2;
      }
      
      override public function clone() : Event
      {
         return new HumanEvent(type,this._tag);
      }
      
      public function get tag() : *
      {
         return this._tag;
      }
   }
}
