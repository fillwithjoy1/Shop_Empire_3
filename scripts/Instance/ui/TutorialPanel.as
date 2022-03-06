package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.TutorialEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class TutorialPanel extends SEMovieClip
   {
       
      
      public var tutorialGirl:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var bubbleText:TutorialBaloonText;
      
      var _text:String;
      
      var _tutorDelay:int;
      
      var _paused:Boolean;
      
      public function TutorialPanel()
      {
         super();
         this._paused = false;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.bubbleText.visible = false;
         addListenerOf(this,MouseEvent.CLICK,this.whenThisClicked);
         addListenerOf(this,Event.ENTER_FRAME,this.animateTutorialGirl);
      }
      
      function animateTutorialGirl(param1:Event) : void
      {
         if(!this._paused)
         {
            if(this.bubbleText.visible)
            {
               if(!this.bubbleText.completed)
               {
                  if(this.tutorialGirl.mouth.currentFrameLabel == "idle")
                  {
                     this.tutorialGirl.mouth.gotoAndStop("speak");
                  }
                  else if(this.tutorialGirl.mouth.currentFrameLabel != "speak_end")
                  {
                     this.tutorialGirl.mouth.nextFrame();
                  }
                  else
                  {
                     this.tutorialGirl.mouth.gotoAndStop("speak");
                  }
               }
               else if(this.tutorialGirl.mouth.currentFrameLabel != "idle")
               {
                  this.tutorialGirl.mouth.gotoAndStop("idle");
               }
            }
            else if(this.tutorialGirl.mouth.currentFrameLabel != "idle")
            {
               this.tutorialGirl.mouth.gotoAndStop("idle");
            }
         }
      }
      
      function whenThisClicked(param1:MouseEvent) : void
      {
         if(param1.target != this.btnClose)
         {
            if(!this.bubbleText.completed)
            {
               this.bubbleText.forceSkip();
            }
            else
            {
               dispatchEvent(new TutorialEvent(TutorialEvent.TUTORIAL_SKIP));
               removeListenerOf(this,Event.ENTER_FRAME,this.vanishCountdown);
            }
         }
         else
         {
            dispatchEvent(new TutorialEvent(TutorialEvent.TUTORIAL_SKIP_ALL));
         }
      }
      
      function updateBorder() : void
      {
         if(this.stage != null)
         {
            if(this._text != null)
            {
               this.bubbleText.text = this._text;
            }
         }
      }
      
      public function clearText() : void
      {
         this.bubbleText.clearText();
      }
      
      public function showText() : void
      {
         this.bubbleText.visible = true;
         this.bubbleText.animated = true;
         this.updateBorder();
         if(this.bubbleText.animated)
         {
            this.countdownToVanish();
         }
         else
         {
            removeListenerOf(this,Event.ENTER_FRAME,this.vanishCountdown);
         }
      }
      
      public function pauseTutor() : void
      {
         this._paused = true;
         this.bubbleText.pauseAnimation();
      }
      
      public function resumeTutor() : void
      {
         this._paused = false;
         this.bubbleText.resumeAnimation();
      }
      
      function countdownToVanish() : void
      {
         removeListenerOf(this,Event.ENTER_FRAME,this.vanishCountdown);
         if(this._tutorDelay > 0)
         {
            addListenerOf(this,Event.ENTER_FRAME,this.vanishCountdown);
         }
      }
      
      function vanishCountdown(param1:Event) : void
      {
         if(this.bubbleText.completed)
         {
            if(!this._paused)
            {
               if(this._tutorDelay > 0)
               {
                  --this._tutorDelay;
               }
               else
               {
                  dispatchEvent(new TutorialEvent(TutorialEvent.TUTORIAL_SKIP));
                  removeListenerOf(this,Event.ENTER_FRAME,this.vanishCountdown);
               }
            }
         }
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set tutorDelay(param1:int) : void
      {
         this._tutorDelay = param1;
      }
      
      public function get tutorDelay() : int
      {
         return this._tutorDelay;
      }
   }
}
