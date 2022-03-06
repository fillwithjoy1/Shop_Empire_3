package Instance.ui
{
   import Instance.events.GameEvent;
   import Instance.events.LoopEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class DialogTextBox extends DialogBox
   {
       
      
      public var textPart:MovieClip;
      
      public var rightPart:MovieClip;
      
      public var bottomPart:MovieClip;
      
      public var leftBottomPart:MovieClip;
      
      public var leftPart:MovieClip;
      
      public var topPart:MovieClip;
      
      public var rightTopPart:MovieClip;
      
      public var legendText:TextField;
      
      public var rightBottomPart:MovieClip;
      
      public var leftTopPart:MovieClip;
      
      public var pointPart:MovieClip;
      
      var _text:String;
      
      var _animate:Boolean;
      
      var currentLength:int;
      
      public function DialogTextBox()
      {
         super();
         this._text = "";
         this._animate = false;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.legendText.autoSize = TextFieldAutoSize.CENTER;
         this.legendText.mouseEnabled = false;
         if(this._animate)
         {
            this.currentLength = 0;
            this.legendText.text = "";
            addListenerOf(this,LoopEvent.ON_IDLE,this.AppearText);
         }
         else
         {
            this.legendText.text = this._text;
            this.correctTextSize();
         }
      }
      
      function AppearText(param1:LoopEvent) : void
      {
         if(this.legendText.text.length < this._text.length)
         {
            this.legendText.text = this._text.substr(0,this.currentLength);
            this.correctTextSize();
            ++this.currentLength;
         }
         else
         {
            removeListenerOf(this,LoopEvent.ON_IDLE,this.AppearText);
         }
      }
      
      function correctTextSize() : void
      {
         this.legendText.x = -this.legendText.width / 2;
         this.legendText.y = -this.legendText.height - 6;
         this.textPart.x = this.legendText.x;
         this.textPart.y = this.legendText.y;
         this.textPart.width = this.legendText.width;
         this.textPart.height = this.legendText.height;
         this.topPart.x = this.legendText.x;
         this.topPart.y = this.legendText.y - 5;
         this.topPart.width = this.legendText.width;
         this.bottomPart.x = this.legendText.x;
         this.bottomPart.width = this.legendText.width;
         this.leftPart.x = this.legendText.x - 5;
         this.leftPart.y = this.legendText.y;
         this.leftPart.height = this.legendText.height;
         this.rightPart.x = this.legendText.x + this.legendText.width - (this.rightPart.width - 5);
         this.rightPart.y = this.legendText.y;
         this.rightPart.height = this.legendText.height;
         this.leftTopPart.x = this.leftPart.x;
         this.leftTopPart.y = this.topPart.y;
         this.leftBottomPart.x = this.leftPart.x;
         this.rightTopPart.x = this.legendText.x + this.legendText.width - 1;
         this.rightTopPart.y = this.topPart.y;
         this.rightBottomPart.x = this.legendText.x + this.legendText.width - 1;
      }
      
      override function tick(param1:GameEvent) : void
      {
         if(this.legendText.text.length >= this._text.length)
         {
            super.tick(param1);
         }
      }
      
      public function set animate(param1:Boolean) : void
      {
         this._animate = param1;
      }
      
      public function get animate() : Boolean
      {
         return this._animate;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         if(!this._animate)
         {
            this.legendText.text = this._text;
         }
         else if(this.parent != null)
         {
            this.currentLength = 0;
            this.legendText.text = "";
            addListenerOf(this,Event.ENTER_FRAME,this.AppearText);
         }
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function getShownText() : String
      {
         return this.legendText.text;
      }
   }
}
