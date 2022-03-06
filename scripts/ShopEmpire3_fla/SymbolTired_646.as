package ShopEmpire3_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import greensock.TweenLite;
   
   public dynamic class SymbolTired_646 extends MovieClip
   {
       
      
      public var keringat3:MovieClip;
      
      public var keringat2:MovieClip;
      
      public var keringatArea:MovieClip;
      
      public var keringat1:MovieClip;
      
      public function SymbolTired_646()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      public function setKeringat(param1:MovieClip) : void
      {
         param1.x = Math.round(Math.random() * 13) - 6.5;
         param1.y = this.keringatArea.y;
         TweenLite.to(param1,Math.random() * 0.5 + 1,{
            "y":this.keringatArea.y + this.keringatArea.height,
            "onComplete":this.setKeringat,
            "onCompleteParams":[param1]
         });
      }
      
      public function removed(param1:Event) : void
      {
         TweenLite.killTweensOf(this.keringat1);
         TweenLite.killTweensOf(this.keringat2);
         TweenLite.killTweensOf(this.keringat3);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      function frame1() : *
      {
         this.setKeringat(this.keringat1);
         this.setKeringat(this.keringat2);
         this.setKeringat(this.keringat3);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
   }
}
