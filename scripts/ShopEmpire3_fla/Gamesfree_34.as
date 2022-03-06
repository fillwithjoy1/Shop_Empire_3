package ShopEmpire3_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import greensock.TweenMax;
   
   public dynamic class Gamesfree_34 extends MovieClip
   {
       
      
      public var dragonIcon:MovieClip;
      
      public function Gamesfree_34()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function linkToGamesfree(param1:MouseEvent) : void
      {
         var _loc2_:* = root;
         _loc2_.linkToGamesfree();
      }
      
      public function removed(param1:Event) : void
      {
         this.dragonIcon.removeEventListener(MouseEvent.CLICK,this.linkToGamesfree);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      public function checkDragonIcon(param1:Event) : void
      {
         if(this.dragonIcon.currentFrame >= this.dragonIcon.totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,this.checkDragonIcon);
            TweenMax.to(this,0.4,{
               "tint":0,
               "onComplete":this.playTheGame
            });
         }
      }
      
      public function playTheGame() : void
      {
         var _loc1_:* = root;
         _loc1_.nextFrame();
      }
      
      function frame1() : *
      {
         this.buttonMode = true;
         this.dragonIcon.stop();
         addEventListener(MouseEvent.CLICK,this.linkToGamesfree);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         addEventListener(Event.ENTER_FRAME,this.checkDragonIcon);
         TweenMax.from(this,0.4,{
            "tint":0,
            "onComplete":this.dragonIcon.play
         });
      }
   }
}
