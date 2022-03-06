package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.CommandEvent;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class UI_Menu extends SEMovieClip
   {
       
      
      public var btnClose:SimpleButton;
      
      public var unsaveWarning:TextField;
      
      public var btnExit:SimpleButton;
      
      public var btnResume:SimpleButton;
      
      public var btnSave:SimpleButton;
      
      public var btnOption:SimpleButton;
      
      public function UI_Menu()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this.btnClose,MouseEvent.CLICK,this.resumeGame);
         addListenerOf(this.btnResume,MouseEvent.CLICK,this.resumeGame);
         addListenerOf(this.btnOption,MouseEvent.CLICK,this.enterOption);
         addListenerOf(this.btnSave,MouseEvent.CLICK,this.saveGame);
         addListenerOf(this.btnExit,MouseEvent.CLICK,this.exitGame);
      }
      
      function enterOption(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.ENTER_OPTION));
      }
      
      function resumeGame(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.RESUME_GAME));
      }
      
      function saveGame(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.SAVE_GAME));
      }
      
      function exitGame(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.EXIT_GAME));
      }
   }
}
