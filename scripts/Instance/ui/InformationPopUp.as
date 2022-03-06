package Instance.ui
{
   import Instance.SEMovieClip;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class InformationPopUp extends SEMovieClip
   {
       
      
      public var bubbleBorder:MovieClip;
      
      public var bubbleText:TextField;
      
      public var pointPart:MovieClip;
      
      var _text:String;
      
      public function InformationPopUp()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         this.bubbleText.autoSize = TextFieldAutoSize.LEFT;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.updateText();
      }
      
      function updateText() : void
      {
         var bottomPos:* = undefined;
         if(this.stage != null)
         {
            this.bubbleText.text = this._text;
            this.bubbleText.x = -1;
            this.bubbleText.y = -7 - Math.round(this.bubbleText.height);
            this.bubbleBorder.y = this.bubbleText.y - 5;
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
         this.updateText();
      }
      
      public function get text() : String
      {
         return this._text;
      }
   }
}
