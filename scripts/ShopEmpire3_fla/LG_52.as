package ShopEmpire3_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import greensock.TweenMax;
   
   public dynamic class LG_52 extends MovieClip
   {
       
      
      public var lgSymbol:MovieClip;
      
      public function LG_52()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function linkToLG(param1:MouseEvent) : void
      {
         var _loc2_:* = root;
         _loc2_.linkToLG();
      }
      
      public function removed(param1:Event) : void
      {
         this.lgSymbol.removeEventListener(MouseEvent.CLICK,this.linkToLG);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      public function checkLGIcon(param1:Event) : void
      {
         if(this.lgSymbol.currentFrame >= this.lgSymbol.totalFrames)
         {
            removeEventListener(Event.ENTER_FRAME,this.checkLGIcon);
            TweenMax.to(this,1.4,{
               "tint":16777215,
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
         this.lgSymbol.stop();
         buttonMode = true;
         addEventListener(MouseEvent.CLICK,this.linkToLG);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         addEventListener(Event.ENTER_FRAME,this.checkLGIcon);
         TweenMax.from(this,0.4,{
            "tint":0,
            "onComplete":this.lgSymbol.play
         });
      }
   }
}
