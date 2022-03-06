package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.AudioEvent;
   import Instance.events.CommandEvent;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import greensock.TweenLite;
   
   public class UI_InputName extends SEMovieClip
   {
       
      
      public var btnOK:SimpleButton;
      
      public var nameInfo:TextField;
      
      public var btnCancel:SimpleButton;
      
      var _text:String;
      
      var _slotIndex:int;
      
      public function UI_InputName()
      {
         super();
         this._text = "";
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.checkValidationName();
         this.nameInfo.setSelection(0,this.nameInfo.maxChars);
         stage.focus = this.nameInfo;
         addListenerOf(this.nameInfo,Event.CHANGE,this.updateText);
         TweenLite.from(this,0.4,{
            "scaleX":0,
            "scaleY":0,
            "onComplete":this.setupButton
         });
      }
      
      function updateText(param1:Event) : void
      {
         var _loc2_:* = param1.currentTarget;
         this._text = this.nameInfo.text;
         this.checkValidationName();
      }
      
      function checkValidationName() : void
      {
         if(this._text.length > 0)
         {
            this.btnOK.enabled = true;
            this.btnOK.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         else
         {
            this.btnOK.enabled = false;
            this.btnOK.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
         }
      }
      
      function setupButton() : void
      {
         addListenerOf(this.btnOK,MouseEvent.CLICK,this.btnOKOnClick);
         addListenerOf(this.btnCancel,MouseEvent.CLICK,this.btnCancelOnClick);
         addListenerOf(stage,KeyboardEvent.KEY_UP,this.keyUpCheck);
      }
      
      function keyUpCheck(param1:KeyboardEvent) : void
      {
         var _loc2_:* = param1.keyCode;
         if(_loc2_ == Keyboard.ENTER)
         {
            if(this.btnOK.enabled)
            {
               stage.focus = stage;
               dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Select));
               dispatchEvent(new CommandEvent(CommandEvent.DECIDE_NAME,this._text));
            }
         }
         else if(_loc2_ == Keyboard.ESCAPE)
         {
            if(this.btnCancel.enabled)
            {
               this.cancelToPlay();
            }
         }
      }
      
      function btnOKOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Select));
            dispatchEvent(new CommandEvent(CommandEvent.DECIDE_NAME,this._text));
         }
      }
      
      function btnCancelOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            this.cancelToPlay();
         }
      }
      
      function cancelToPlay() : void
      {
         dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Unselect,1,0,54));
         removeListenerOf(this.btnOK,MouseEvent.CLICK,this.btnOKOnClick);
         removeListenerOf(this.btnCancel,MouseEvent.CLICK,this.btnCancelOnClick);
         removeListenerOf(stage,KeyboardEvent.KEY_UP,this.keyUpCheck);
         TweenLite.to(this,0.4,{
            "scaleX":0,
            "scaleY":0,
            "onComplete":this.parent.removeChild,
            "onCompleteParams":[this]
         });
      }
      
      public function set slotIndex(param1:int) : void
      {
         this._slotIndex = param1;
      }
      
      public function get slotIndex() : int
      {
         return this._slotIndex;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         this.nameInfo.text = this._text;
      }
      
      public function get text() : String
      {
         return this._text;
      }
   }
}
