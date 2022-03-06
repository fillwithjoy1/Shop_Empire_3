package Instance.property
{
   import Instance.SEMovieClip;
   import Instance.events.LoopEvent;
   import flash.events.Event;
   
   public class DoorSymbol extends SEMovieClip
   {
       
      
      var _isOpen:Boolean;
      
      var _isClose:Boolean;
      
      var _animateOpen:int;
      
      public function DoorSymbol()
      {
         super();
         stop();
         this._isOpen = currentFrame == totalFrames;
         this._isClose = currentFrame == 1;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
      }
      
      function OpenAnimate(param1:LoopEvent) : void
      {
         if(currentFrame < totalFrames)
         {
            nextFrame();
            this._isClose = false;
         }
         else
         {
            this._animateOpen = 0;
            this._isOpen = true;
            removeListenerOf(this,LoopEvent.ON_IDLE,this.OpenAnimate);
         }
      }
      
      function CloseAnimate(param1:Event) : void
      {
         if(currentFrame > 1)
         {
            prevFrame();
            this._isOpen = false;
         }
         else
         {
            this._animateOpen = 0;
            this._isClose = true;
            removeListenerOf(this,LoopEvent.ON_IDLE,this.CloseAnimate);
         }
      }
      
      public function closeTheDoor() : void
      {
         this._animateOpen = -1;
         removeListenerOf(this,LoopEvent.ON_IDLE,this.OpenAnimate);
         addListenerOf(this,LoopEvent.ON_IDLE,this.CloseAnimate);
      }
      
      public function openTheDoor() : void
      {
         this._animateOpen = 1;
         removeListenerOf(this,LoopEvent.ON_IDLE,this.CloseAnimate);
         addListenerOf(this,LoopEvent.ON_IDLE,this.OpenAnimate);
      }
      
      public function checkOpenClose() : void
      {
         this._isOpen = currentFrame == totalFrames;
         this._isClose = currentFrame == 1;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get isClose() : Boolean
      {
         return this._isClose;
      }
      
      public function get animateOpen() : int
      {
         return this._animateOpen;
      }
   }
}
