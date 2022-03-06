package Instance.ui
{
   import Instance.SEMovieClip;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   
   public class Credits extends SEMovieClip
   {
       
      
      public var scrollNote:MovieClip;
      
      public var gamesfreeBanner:SimpleButton;
      
      public var scrollNote2:MovieClip;
      
      public var lgBanner:SimpleButton;
      
      public var btnBack:SimpleButton;
      
      var creditsPos:Number;
      
      var delayToPlayCredits:int;
      
      public function Credits()
      {
         super();
         this.creditsPos = this.scrollNote.y;
         this.scrollNote2.y = this.scrollNote.y + this.scrollNote.height + 106;
         this.delayToPlayCredits = 0;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.delayToPlayCredits = 24;
         addListenerOf(this,Event.ENTER_FRAME,this.animateCredits);
      }
      
      function animateCredits(param1:Event) : void
      {
         if(this.delayToPlayCredits > 0)
         {
            --this.delayToPlayCredits;
         }
         else
         {
            if(this.scrollNote.y > this.creditsPos - this.scrollNote.height)
            {
               --this.scrollNote.y;
            }
            else
            {
               this.scrollNote.y = this.scrollNote2.y + this.scrollNote2.height + 106;
            }
            if(this.scrollNote2.y > this.creditsPos - this.scrollNote2.height)
            {
               --this.scrollNote2.y;
            }
            else
            {
               this.scrollNote2.y = this.scrollNote.y + this.scrollNote.height + 106;
            }
         }
      }
   }
}
