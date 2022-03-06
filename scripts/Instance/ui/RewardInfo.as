package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.CommandEvent;
   import Instance.events.MissionEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import greensock.TweenLite;
   import greensock.TweenMax;
   
   public class RewardInfo extends SEMovieClip
   {
       
      
      public var rewardInfo:TextField;
      
      var _charList:Array;
      
      var _incomingCharList:Array;
      
      var _onRemoveChar:Array;
      
      public function RewardInfo()
      {
         this._charList = new Array();
         this._incomingCharList = new Array();
         this._onRemoveChar = new Array();
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.rewardInfo.visible = false;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.letterSpacing = 0.5;
         this.rewardInfo.defaultTextFormat = _loc1_;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(stage,MissionEvent.MISSION_CHANGE,this.whenMissionChange);
         addListenerOf(stage,CommandEvent.MENU_SETTING,this.stopAnimation);
         addListenerOf(stage,CommandEvent.RESUME_GAME,this.resumeAnimation);
      }
      
      function stopAnimation(param1:CommandEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:* = this._incomingCharList.concat(this._charList.concat(this._onRemoveChar));
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = TweenMax.getTweensOf(_loc4_);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               (_loc7_ = _loc5_[_loc6_]).pause();
               _loc6_++;
            }
            _loc3_++;
         }
      }
      
      function resumeAnimation(param1:CommandEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:* = this._incomingCharList.concat(this._charList.concat(this._onRemoveChar));
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = TweenMax.getTweensOf(_loc4_);
            _loc6_ = 0;
            while(_loc6_ < _loc5_.length)
            {
               (_loc7_ = _loc5_[_loc6_]).resume();
               _loc6_++;
            }
            _loc3_++;
         }
      }
      
      function whenMissionChange(param1:MissionEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc2_:* = -15;
         var _loc3_:* = 0.8 / this._charList.length;
         var _loc4_:* = 0;
         while(this._charList.length > 0)
         {
            _loc5_ = this._charList.pop();
            this._onRemoveChar.push(_loc5_);
            TweenLite.to(_loc5_,0.6,{
               "y":_loc2_,
               "delay":_loc4_ * _loc3_,
               "onComplete":this.removeClip,
               "onCompleteParams":[_loc5_]
            });
            _loc4_++;
         }
      }
      
      function removeClip(param1:*) : void
      {
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
         var _loc2_:* = this._onRemoveChar.indexOf(param1);
         if(_loc2_ in this._onRemoveChar)
         {
            this._onRemoveChar.splice(_loc2_,1);
         }
      }
      
      function createFlyingText() : void
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:TextFormat = null;
         var _loc10_:TextField = null;
         var _loc11_:Rectangle = null;
         var _loc12_:Rectangle = null;
         var _loc1_:* = this.rewardInfo.text;
         var _loc2_:* = this.rewardInfo.width / 2;
         var _loc3_:* = 0;
         var _loc4_:* = 0.8 / _loc1_.length;
         var _loc5_:* = -15;
         var _loc6_:* = 0;
         while(_loc6_ < _loc1_.length)
         {
            if((_loc7_ = _loc1_.charAt(_loc6_)) != " " && _loc7_ != "\n")
            {
               _loc8_ = new Sprite();
               (_loc9_ = this.rewardInfo.defaultTextFormat).align = TextFormatAlign.LEFT;
               (_loc10_ = new TextField()).defaultTextFormat = _loc9_;
               _loc10_.embedFonts = true;
               _loc11_ = (this.rewardInfo as TextField).getCharBoundaries(_loc6_);
               _loc10_.autoSize = TextFieldAutoSize.LEFT;
               _loc10_.text = _loc7_;
               _loc12_ = (_loc10_ as TextField).getCharBoundaries(0);
               _loc10_.x = -_loc10_.width / 2;
               _loc10_.y = -_loc10_.height / 2;
               _loc8_.addChild(_loc10_);
               _loc8_.x = _loc11_.x + this.rewardInfo.x + _loc10_.width / 2 - _loc12_.x;
               _loc8_.y = _loc11_.y + this.rewardInfo.y + _loc10_.height / 2 - _loc12_.y;
               addChild(_loc8_);
               this._incomingCharList.push(_loc8_);
               TweenLite.from(_loc8_,0.6,{
                  "y":_loc5_,
                  "delay":(_loc1_.length - 1 - _loc6_) * _loc4_,
                  "onComplete":this.addToCharList,
                  "onCompleteParams":[_loc8_]
               });
            }
            _loc6_++;
         }
      }
      
      function addToCharList(param1:*) : void
      {
         if(this._charList.indexOf(param1) < 0)
         {
            this._charList.push(param1);
         }
         var _loc2_:* = this._incomingCharList.indexOf(param1);
         if(_loc2_ in this._incomingCharList)
         {
            this._incomingCharList.splice(_loc2_,1);
         }
      }
      
      function removeAllChar() : void
      {
         var _loc1_:* = undefined;
         while(this._charList.length > 0)
         {
            _loc1_ = this._charList.shift();
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
         while(this._incomingCharList.length > 0)
         {
            _loc1_ = this._incomingCharList.shift();
            TweenLite.killTweensOf(_loc1_);
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      public function setReward(param1:String) : void
      {
         this.removeAllChar();
         this.rewardInfo.text = param1;
         this.createFlyingText();
      }
   }
}
