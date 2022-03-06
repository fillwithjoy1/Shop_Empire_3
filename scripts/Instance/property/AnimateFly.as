package Instance.property
{
   import Instance.SEMovieClip;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class AnimateFly extends SEMovieClip
   {
       
      
      public var lalat:MovieClip;
      
      public var flyArea:MovieClip;
      
      var flyPosTarget:Point;
      
      var interval:Number;
      
      public function AnimateFly()
      {
         super();
         this.lalat.x = Math.random() * this.flyArea.width - this.flyArea.width / 2;
         this.lalat.y = -(Math.random() * this.flyArea.height);
         this.lalat.stop();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,LoopEvent.ON_IDLE,this.animateFlyMovement);
      }
      
      function animateFlyMovement(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.lalat.currentFrame < this.lalat.totalFrames)
         {
            this.lalat.nextFrame();
         }
         else
         {
            this.lalat.gotoAndStop(1);
         }
         if(this.flyPosTarget == null)
         {
            _loc2_ = Math.random() * this.flyArea.width - this.flyArea.width / 2;
            _loc3_ = -(Math.random() * this.flyArea.height);
            this.flyPosTarget = new Point(_loc2_,_loc3_);
            _loc4_ = Calculate.countDistance(this.flyPosTarget,new Point(this.lalat.x,this.lalat.y));
            this.interval = _loc4_ / 3;
         }
         else if((_loc4_ = Calculate.countDistance(this.flyPosTarget,new Point(this.lalat.x,this.lalat.y))) - this.interval > 0)
         {
            _loc5_ = this.interval / _loc4_;
            this.lalat.x += _loc5_ * (this.flyPosTarget.x - this.lalat.x);
            this.lalat.y += _loc5_ * (this.flyPosTarget.y - this.lalat.y);
         }
         else
         {
            this.lalat.x = this.flyPosTarget.x;
            this.lalat.y = this.flyPosTarget.y;
            this.flyPosTarget = null;
         }
      }
   }
}
