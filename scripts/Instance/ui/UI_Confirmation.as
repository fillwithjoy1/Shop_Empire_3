package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.AudioEvent;
   import Instance.events.MessageDialogEvent;
   import Instance.modules.Utility;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class UI_Confirmation extends SEMovieClip
   {
       
      
      public var noteText:TextField;
      
      public var btnYes:SimpleButton;
      
      public var btnNo:SimpleButton;
      
      var _toConfirm:String;
      
      public function UI_Confirmation()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this.btnYes,MouseEvent.CLICK,this.btnYesOnClick);
         addListenerOf(this.btnNo,MouseEvent.CLICK,this.btnNoOnClick);
      }
      
      function btnYesOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Select));
         dispatchEvent(new MessageDialogEvent(MessageDialogEvent.CHOSEN,MessageDialogEvent.CHOICE_YES));
      }
      
      function btnNoOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Unselect,1,0,54));
         dispatchEvent(new MessageDialogEvent(MessageDialogEvent.CHOSEN,MessageDialogEvent.CHOICE_NO));
      }
      
      public function set toConfirm(param1:String) : void
      {
         this._toConfirm = param1;
         if(Utility.hasLabel(this,this._toConfirm))
         {
            gotoAndStop(this._toConfirm);
         }
      }
      
      public function get toConfirm() : String
      {
         return this._toConfirm;
      }
   }
}
