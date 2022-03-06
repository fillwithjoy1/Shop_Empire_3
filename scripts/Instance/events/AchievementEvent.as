package Instance.events
{
   import flash.events.Event;
   
   public class AchievementEvent extends Event
   {
      
      public static const UPDATE_HISTORY = "updateHistory";
       
      
      var _variable;
      
      public function AchievementEvent(param1:String, param2:* = null)
      {
         super(param1,true,true);
         this._variable = param2;
      }
      
      override public function clone() : Event
      {
         return new AchievementEvent(type,this._variable);
      }
      
      public function get variable() : *
      {
         return this._variable;
      }
   }
}
