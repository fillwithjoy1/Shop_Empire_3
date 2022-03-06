package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.constant.ColorCode;
   import Instance.events.GameEvent;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class InformationPopUpBuilding extends SEMovieClip
   {
       
      
      public var priceInfo:TextField;
      
      public var bubbleBorder:MovieClip;
      
      public var priceSign:MovieClip;
      
      public var bubbleText:TextField;
      
      public var headerText:TextField;
      
      public var pointPart:MovieClip;
      
      var _text:String;
      
      var _header:String;
      
      var _price:int;
      
      public function InformationPopUpBuilding()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         this.bubbleText.autoSize = TextFieldAutoSize.LEFT;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.letterSpacing = -1;
         this.bubbleText.defaultTextFormat = _loc1_;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.updateText();
         addListenerOf(stage,GameEvent.UPDATE_BUDGET,this.checkCurrentBudget);
      }
      
      function checkCurrentBudget(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_.budget < this.price)
         {
            this.priceInfo.textColor = ColorCode.MINUS_CASH;
         }
         else
         {
            this.priceInfo.textColor = ColorCode.VALID_CASH;
         }
      }
      
      function updateText() : void
      {
         var bottomPos:* = undefined;
         if(this.stage != null)
         {
            this.bubbleText.x = -1;
            this.bubbleText.y = -7 - Math.round(this.bubbleText.height);
            this.headerText.x = -1;
            this.headerText.y = this.bubbleText.y - 2 - Math.round(this.headerText.height);
            this.priceInfo.y = this.headerText.y;
            this.priceSign.y = Math.round(this.priceInfo.y + this.priceInfo.height / 2) + 2;
            this.bubbleBorder.y = this.headerText.y - 5;
            bottomPos = this.bubbleBorder.globalToLocal(this.localToGlobal(new Point(0,-4)));
            with(this.bubbleBorder)
            {
               
               rightTopPart.x = bubbleText.x + bubbleText.width + 12 - rightTopPart.width;
               rightPart.x = bubbleText.x + bubbleText.width + 12 - rightPart.width;
               rightBottomPart.x = bubbleText.x + bubbleText.width + 12 - rightBottomPart.width;
               leftBottomPart.y = bottomPos.y - leftBottomPart.height;
               bottomPart.y = bottomPos.y - bottomPart.height;
               rightBottomPart.y = bottomPos.y - rightBottomPart.height;
               leftPart.height = Math.abs(leftBottomPart.y + leftBottomPart.height - 6 - 6);
               rightPart.height = Math.abs(rightBottomPart.y + rightBottomPart.height - 6 - 6);
               topPart.width = Math.abs(rightTopPart.x + rightTopPart.width - 6 - 6);
               bottomPart.width = Math.abs(rightBottomPart.x + rightBottomPart.width - 6 - 6);
               textPart.width = topPart.width;
               textPart.height = leftPart.height;
            }
         }
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         this.bubbleText.text = this._text;
         this.updateText();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set header(param1:String) : void
      {
         this._header = param1;
         this.headerText.text = this._header;
      }
      
      public function get header() : String
      {
         return this._header;
      }
      
      public function set price(param1:int) : void
      {
         this._price = param1;
         this.priceInfo.text = "" + Utility.numberToMoney(this._price) + " G";
      }
      
      public function get price() : int
      {
         return this._price;
      }
   }
}
