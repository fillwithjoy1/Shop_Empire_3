package Instance.ui
{
   import fl.motion.easing.Back;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import greensock.TweenLite;
   
   public class UI_FlyingText extends MovieClip
   {
       
      
      public var inputText:TextField;
      
      var _charList:Array;
      
      var _text:String;
      
      var _textColor:int;
      
      public function UI_FlyingText()
      {
         this._charList = new Array();
         super();
         this._text = "";
         this._textColor = this.inputText.textColor;
         this.inputText.autoSize = TextFieldAutoSize.LEFT;
         removeChild(this.inputText);
      }
      
      public function animateText() : void
      {
         var _loc1_:* = 0.5;
         var _loc2_:* = 0;
         while(_loc2_ < this._charList.length)
         {
            _loc1_ += _loc2_ == 0 ? 0.5 : 0.1;
            TweenLite.to(this._charList[_loc2_],0.5,{
               "y":this._charList[_loc2_].y - 20,
               "delay":0.1 * _loc2_,
               "ease":Back.easeOut
            });
            _loc2_++;
         }
         TweenLite.to(this,0.5,{
            "alpha":0,
            "delay":_loc1_,
            "onComplete":this.removeMe
         });
      }
      
      function removeMe() : void
      {
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function set text(param1:String) : void
      {
         var _loc4_:Rectangle = null;
         var _loc5_:TextField = null;
         this._text = param1;
         this.inputText.text = this._text;
         var _loc2_:TextFormat = this.inputText.defaultTextFormat;
         addChild(this.inputText);
         _loc2_.align = TextFormatAlign.LEFT;
         var _loc3_:* = 0;
         while(_loc3_ < this.inputText.text.length)
         {
            if((_loc4_ = this.inputText.getCharBoundaries(_loc3_)) != null)
            {
               (_loc5_ = new TextField()).defaultTextFormat = _loc2_;
               _loc5_.text = this.inputText.text.charAt(_loc3_);
               _loc5_.x = _loc4_.x + this.inputText.x - 2;
               _loc5_.y = _loc4_.y + this.inputText.y - 2;
               _loc5_.filters = this.inputText.filters;
               _loc5_.selectable = false;
               _loc5_.textColor = this.inputText.textColor;
               _loc5_.embedFonts = true;
               addChild(_loc5_);
               this._charList.push(_loc5_);
            }
            _loc3_++;
         }
         removeChild(this.inputText);
      }
      
      override public function get width() : Number
      {
         return this.inputText.textWidth;
      }
      
      public function set textColor(param1:int) : void
      {
         this._textColor = param1;
         this.inputText.textColor = this._textColor;
         var _loc2_:* = 0;
         while(_loc2_ < this._charList.length)
         {
            this._charList[_loc2_].textColor = this._textColor;
            _loc2_++;
         }
      }
      
      public function get textColor() : int
      {
         return this._textColor;
      }
      
      public function get charList() : Array
      {
         return this._charList;
      }
   }
}
