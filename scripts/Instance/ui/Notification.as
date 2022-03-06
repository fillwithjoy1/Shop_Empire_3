package Instance.ui
{
   import Instance.events.GameEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class Notification extends MovieClip
   {
       
      
      public var noteInfo:TextField;
      
      public var notificationSymbol:MovieClip;
      
      const MIN_WIDTH = 119;
      
      const MIN_HEIGHT = 18;
      
      const SIDE_WIDTH = 4;
      
      const SIDE_HEIGHT = 5;
      
      const SYMBOL_WIDTH = 16;
      
      var _text:String;
      
      var borderContainer:MovieClip;
      
      var delayToDisappear:int;
      
      public function Notification()
      {
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.borderContainer = new MovieClip();
         this.noteInfo.autoSize = TextFieldAutoSize.CENTER;
         this.delayToDisappear = 36;
         addChildAt(this.borderContainer,0);
         addEventListener(Event.ADDED_TO_STAGE,this.Initialize);
      }
      
      function Initialize(param1:Event) : void
      {
         this.updateBorder();
         addEventListener(Event.ENTER_FRAME,this.countDownToDisappear);
         addEventListener(Event.REMOVED,this.removed);
      }
      
      function removed(param1:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.countDownToDisappear);
         removeEventListener(Event.REMOVED,this.removed);
      }
      
      function countDownToDisappear(param1:Event) : void
      {
         if(this.delayToDisappear > 0)
         {
            --this.delayToDisappear;
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.NOTIFICATION_END));
            removeEventListener(Event.ENTER_FRAME,this.countDownToDisappear);
         }
      }
      
      function updateBorder() : void
      {
         while(this.borderContainer.numChildren > 0)
         {
            this.borderContainer.removeChildAt(0);
         }
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.clear();
         _loc1_.graphics.beginBitmapFill(new NoteUpper());
         _loc1_.graphics.drawRect(0,0,this.MIN_WIDTH,this.SIDE_HEIGHT);
         _loc1_.graphics.endFill();
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.clear();
         _loc2_.graphics.beginBitmapFill(new NoteBottom());
         _loc2_.graphics.drawRect(0,0,this.MIN_WIDTH,this.SIDE_HEIGHT);
         _loc2_.graphics.endFill();
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.clear();
         _loc3_.graphics.beginBitmapFill(new NoteCenter());
         _loc3_.graphics.drawRect(0,0,this.MIN_WIDTH,this.MIN_HEIGHT - this.SIDE_HEIGHT * 2);
         _loc3_.graphics.endFill();
         var _loc4_:Sprite;
         (_loc4_ = new Sprite()).graphics.clear();
         _loc4_.graphics.beginBitmapFill(new NoteUpperCorner());
         _loc4_.graphics.drawRect(0,0,this.SIDE_WIDTH,this.SIDE_HEIGHT);
         _loc4_.graphics.endFill();
         var _loc5_:Sprite;
         (_loc5_ = new Sprite()).graphics.clear();
         _loc5_.graphics.beginBitmapFill(new NoteBottomCorner());
         _loc5_.graphics.drawRect(0,0,this.SIDE_WIDTH,this.SIDE_HEIGHT);
         _loc5_.graphics.endFill();
         var _loc6_:Sprite;
         (_loc6_ = new Sprite()).graphics.clear();
         _loc6_.graphics.beginBitmapFill(new NoteSide());
         _loc6_.graphics.drawRect(0,0,this.SIDE_WIDTH,this.MIN_HEIGHT - this.SIDE_HEIGHT * 2);
         _loc6_.graphics.endFill();
         var _loc7_:Sprite;
         (_loc7_ = new Sprite()).graphics.clear();
         _loc7_.graphics.beginBitmapFill(new NoteUpperCorner());
         _loc7_.graphics.drawRect(0,0,this.SIDE_WIDTH,this.SIDE_HEIGHT);
         _loc7_.graphics.endFill();
         var _loc8_:Sprite;
         (_loc8_ = new Sprite()).graphics.clear();
         _loc8_.graphics.beginBitmapFill(new NoteBottomCorner());
         _loc8_.graphics.drawRect(0,0,this.SIDE_WIDTH,this.SIDE_HEIGHT);
         _loc8_.graphics.endFill();
         var _loc9_:Sprite;
         (_loc9_ = new Sprite()).graphics.clear();
         _loc9_.graphics.beginBitmapFill(new NoteSide());
         _loc9_.graphics.drawRect(0,0,this.SIDE_WIDTH,this.MIN_HEIGHT - this.SIDE_HEIGHT * 2);
         _loc9_.graphics.endFill();
         _loc3_.width = Math.ceil(Math.max(this.noteInfo.width + this.SYMBOL_WIDTH / 2,this.MIN_WIDTH));
         _loc3_.height = Math.ceil(Math.max(this.noteInfo.height + 4,this.MIN_HEIGHT) - this.SIDE_HEIGHT * 2);
         _loc3_.x = -(_loc3_.width + this.SIDE_WIDTH);
         _loc3_.y = -(_loc3_.height + this.SIDE_HEIGHT);
         _loc1_.width = _loc3_.width;
         _loc1_.x = -(_loc1_.width + this.SIDE_WIDTH);
         _loc1_.y = _loc3_.y - _loc1_.height;
         _loc2_.width = _loc3_.width;
         _loc2_.x = -(_loc2_.width + this.SIDE_WIDTH);
         _loc2_.y = -_loc2_.height;
         _loc4_.x = _loc1_.x - _loc4_.width;
         _loc4_.y = _loc1_.y;
         _loc5_.x = _loc2_.x - _loc5_.width;
         _loc5_.y = _loc2_.y;
         _loc6_.height = _loc3_.height;
         _loc6_.x = _loc3_.x - _loc9_.width;
         _loc6_.y = _loc3_.y;
         _loc7_.scaleX = -1;
         _loc7_.y = _loc1_.y;
         _loc8_.scaleX = -1;
         _loc8_.y = _loc2_.y;
         _loc9_.height = _loc3_.height;
         _loc9_.scaleX = -1;
         _loc9_.y = _loc3_.y;
         this.notificationSymbol.x = _loc3_.x - this.SIDE_WIDTH - 5 + this.notificationSymbol.width / 2;
         this.notificationSymbol.y = _loc3_.y + _loc3_.height / 2;
         this.noteInfo.x = -(_loc3_.width - this.SYMBOL_WIDTH / 2) / 2 - this.noteInfo.width / 2;
         this.noteInfo.y = -((_loc3_.height + _loc1_.height + _loc2_.height) / 2) - this.noteInfo.height / 2;
         this.borderContainer.addChild(_loc4_);
         this.borderContainer.addChild(_loc5_);
         this.borderContainer.addChild(_loc6_);
         this.borderContainer.addChild(_loc7_);
         this.borderContainer.addChild(_loc8_);
         this.borderContainer.addChild(_loc9_);
         this.borderContainer.addChild(_loc2_);
         this.borderContainer.addChild(_loc1_);
         this.borderContainer.addChild(_loc3_);
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         this.noteInfo.text = this._text;
         this.updateBorder();
      }
      
      public function get text() : String
      {
         return this._text;
      }
   }
}
