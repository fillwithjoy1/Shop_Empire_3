package Instance.events
{
   import flash.events.Event;
   
   public class MessageDialogEvent extends Event
   {
      
      public static const CHOSEN = "chosen";
      
      public static const CHOICE_YES = "choiceYes";
      
      public static const CHOICE_NO = "choiceNo";
       
      
      var _choice:String;
      
      public function MessageDialogEvent(param1:String, param2:String = "choiceNo")
      {
         super(param1);
         this._choice = param2;
      }
      
      override public function clone() : Event
      {
         return new MessageDialogEvent(type,this._choice);
      }
      
      public function get choice() : String
      {
         return this._choice;
      }
   }
}
