package Instance.property
{
   import Instance.events.LoopEvent;
   import flash.events.Event;
   
   public class AnimalPoop extends Trash
   {
       
      
      public function AnimalPoop()
      {
         super();
         _dirtyLevel = 50;
         priority = 2;
         stop();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,LoopEvent.ON_IDLE,this.animationCheck);
      }
      
      function animationCheck(param1:LoopEvent) : void
      {
         if(this.currentFrame < this.totalFrames)
         {
            this.nextFrame();
         }
         else
         {
            this.gotoAndStop(1);
         }
      }
      
      override function checkDirtyLevel() : void
      {
         this.alpha = _dirtyLevel / 50;
      }
   }
}
