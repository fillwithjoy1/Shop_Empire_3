package Instance.gameplay
{
   import Instance.events.GameEvent;
   import flash.display.MovieClip;
   
   public class MainContainer extends MovieClip
   {
       
      
      public function MainContainer()
      {
         super();
      }
      
      override public function set x(param1:Number) : void
      {
         super.x = param1;
         dispatchEvent(new GameEvent(GameEvent.POSITION_CHANGE));
      }
      
      override public function set y(param1:Number) : void
      {
         super.y = param1;
         dispatchEvent(new GameEvent(GameEvent.POSITION_CHANGE));
      }
   }
}
