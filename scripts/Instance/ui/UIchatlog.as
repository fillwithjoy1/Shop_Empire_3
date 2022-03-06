package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.SliderBarEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   
   public class UIchatlog extends SEMovieClip
   {
       
      
      public var btnClose:SimpleButton;
      
      public var sliderBar:ChatLogSlideBar;
      
      var _chatLog:Array;
      
      var _chatContainer:MovieClip;
      
      var _maskContainer:MovieClip;
      
      public function UIchatlog()
      {
         super();
         this.sliderBar.slideMode = this.sliderBar.VERTICAL;
         this._maskContainer = new MovieClip();
         this._maskContainer.graphics.clear();
         this._maskContainer.graphics.beginFill(65280);
         this._maskContainer.graphics.drawRect(0,0,262,280);
         this._maskContainer.graphics.endFill();
         this._maskContainer.x = 8;
         this._maskContainer.y = 64;
         addChild(this._maskContainer);
         this._chatContainer = new MovieClip();
         this._chatContainer.y = 64;
         addChild(this._chatContainer);
         this._chatContainer.mask = this._maskContainer;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.updateChatLog();
         addListenerOf(this.sliderBar,SliderBarEvent.CHANGE_POSITION,this.scrollPage);
      }
      
      function scrollPage(param1:SliderBarEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(this._chatContainer.height > this._maskContainer.height)
         {
            _loc3_ = this._chatContainer.height - this._maskContainer.height;
            this._chatContainer.y = this._maskContainer.y - _loc3_ * _loc2_.getPosition();
         }
      }
      
      function updateChatLog() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         if(stage != null)
         {
            this._chatContainer.graphics.clear();
            while(this._chatContainer.numChildren > 0)
            {
               this._chatContainer.removeChildAt(0);
            }
            _loc1_ = 0;
            _loc2_ = 0;
            if(this._chatLog != null)
            {
               _loc3_ = 0;
               while(_loc3_ < this._chatLog.length)
               {
                  _loc4_ = this._chatLog[_loc3_];
                  _loc5_ = false;
                  if(_loc3_ - 1 in this._chatLog)
                  {
                     if((_loc7_ = this.chatLog[_loc3_ - 1]).dayTime != _loc4_.dayTime)
                     {
                        _loc5_ = true;
                     }
                  }
                  else
                  {
                     _loc5_ = true;
                  }
                  if(_loc5_)
                  {
                     (_loc8_ = new ChatLogNewDay()).dayInfo.text = "- DAY " + _loc4_.dayTime + " -";
                     _loc8_.x = 136.5;
                     _loc8_.y = (_loc3_ + 1 + _loc1_) * 40;
                     this._chatContainer.addChild(_loc8_);
                     _loc1_++;
                  }
                  _loc6_ = null;
                  if(_loc4_.modelPos == 0)
                  {
                     _loc6_ = new ChatLogList();
                  }
                  else
                  {
                     _loc6_ = new ChatLogReverse();
                  }
                  if(_loc6_ != null)
                  {
                     _loc6_.x = 136.5;
                     _loc6_.y = (_loc3_ + 1 + _loc1_) * 40;
                     _loc6_.characterName.text = _loc4_.speakerName;
                     _loc6_.modelClip.gotoAndStop(_loc4_.model);
                     _loc6_.timeInfo.text = _loc4_.timeInfo;
                     _loc6_.conversation.text = _loc4_.chatText;
                     this._chatContainer.addChild(_loc6_);
                  }
                  _loc2_ = (_loc3_ + 1 + _loc1_) * 40;
                  _loc3_++;
               }
            }
            this._chatContainer.graphics.beginFill(16777215,0);
            this._chatContainer.graphics.drawRect(0,0,262,_loc2_);
            this._chatContainer.graphics.endFill();
            this.sliderBar.enabled = this._chatContainer.height > this._maskContainer.height;
            this.sliderBar.slideIndicator.visible = this.sliderBar.enabled;
            this.sliderBar.slideArea.visible = this.sliderBar.enabled;
            if(this.sliderBar.enabled)
            {
               _loc9_ = this._chatContainer.height - this._maskContainer.height;
               this.sliderBar.setPosition((this._maskContainer.y - this._chatContainer.y) / _loc9_);
               this.sliderBar.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
            }
            else
            {
               this.sliderBar.setPosition(0);
               this.sliderBar.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
            }
         }
      }
      
      public function set chatLog(param1:Array) : void
      {
         this._chatLog = param1;
         this.updateChatLog();
      }
      
      public function get chatLog() : Array
      {
         return this._chatLog;
      }
   }
}
