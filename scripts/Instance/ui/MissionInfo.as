package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.AudioEvent;
   import Instance.events.CommandEvent;
   import Instance.events.MissionEvent;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import greensock.TweenLite;
   import greensock.TweenMax;
   
   public class MissionInfo extends SEMovieClip
   {
       
      
      public var missionInfo:TextField;
      
      var _charList:Array;
      
      var _incomingChar:Array;
      
      var _completedMissionChar:Array;
      
      var _onRemoveChar:Array;
      
      var _missionMark:MovieClip;
      
      var _changeMissionDelay:int;
      
      var _paused:Boolean;
      
      public function MissionInfo()
      {
         this._charList = new Array();
         this._incomingChar = new Array();
         this._completedMissionChar = new Array();
         this._onRemoveChar = new Array();
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.missionInfo.visible = false;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.letterSpacing = 1;
         this.missionInfo.defaultTextFormat = _loc1_;
         this._missionMark = new MissionMark();
         this._missionMark.mouseEnabled = false;
         this._missionMark.mouseChildren = false;
         this._paused = false;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(stage,MissionEvent.MISSION_SUCCESS,this.whenMissionSuccess);
         addListenerOf(stage,CommandEvent.MENU_SETTING,this.stopAnimation);
         addListenerOf(stage,CommandEvent.RESUME_GAME,this.resumeAnimation);
      }
      
      function stopAnimation(param1:CommandEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:* = this._incomingChar.concat(this._charList.concat(this._completedMissionChar.concat(this._onRemoveChar)));
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
         if(this._missionMark.parent != null)
         {
            this._missionMark.stop();
         }
         this._paused = true;
      }
      
      function resumeAnimation(param1:CommandEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:* = this._incomingChar.concat(this._charList.concat(this._completedMissionChar.concat(this._onRemoveChar)));
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
         if(this._missionMark.parent != null)
         {
            if(this._missionMark.currentFrameLabel != "changeMission")
            {
               this._missionMark.play();
            }
         }
         this._paused = false;
      }
      
      function whenMissionSuccess(param1:MissionEvent) : void
      {
         var _loc2_:* = this.parent;
         var _loc3_:* = _loc2_.globalToLocal(this.localToGlobal(new Point(this._charList[0].x - 15,-1)));
         this._missionMark.x = _loc3_.x;
         this._missionMark.y = _loc3_.y;
         this._missionMark.gotoAndPlay(1);
         var _loc4_:* = _loc2_.getChildIndex(this);
         _loc2_.addChildAt(this._missionMark,_loc4_ + 1);
         dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Mission_Complete));
         this.animateMissionSuccess();
      }
      
      function animateMissionSuccess() : void
      {
         var reflash:Function = null;
         var theChar:* = undefined;
         reflash = function(param1:*):void
         {
            TweenMax.to(param1,0.4,{
               "tint":null,
               "scaleX":1,
               "scaleY":1,
               "onComplete":removeFromCompletedList,
               "onCompleteParams":[param1]
            });
         };
         var delayPerChar:* = 1.2 / this._charList.length;
         var i:* = 0;
         while(i < this._charList.length)
         {
            theChar = this._charList[i];
            this._completedMissionChar.push(theChar);
            TweenMax.to(theChar,0.4,{
               "tint":5143812,
               "scaleX":1.2,
               "scaleY":1.2,
               "delay":i * delayPerChar,
               "onComplete":reflash,
               "onCompleteParams":[theChar]
            });
            i++;
         }
      }
      
      function removeFromCompletedList(param1:*) : void
      {
         var _loc2_:* = this._completedMissionChar.indexOf(param1);
         if(_loc2_ in this._completedMissionChar)
         {
            this._completedMissionChar.splice(_loc2_,1);
         }
         if(this._completedMissionChar.length == 0)
         {
            this._changeMissionDelay = 10;
            addListenerOf(this,Event.ENTER_FRAME,this.delayToChangeMission);
         }
      }
      
      function delayToChangeMission(param1:Event) : void
      {
         if(this._missionMark.currentFrameLabel == "changeMission")
         {
            if(!this._paused)
            {
               if(this._changeMissionDelay > 0)
               {
                  --this._changeMissionDelay;
               }
               else
               {
                  dispatchEvent(new MissionEvent(MissionEvent.MISSION_CHANGE));
                  this._missionMark.play();
                  this.removeCharList();
               }
            }
         }
         else
         {
            this._changeMissionDelay = 10;
         }
      }
      
      function removeCharList() : void
      {
         var _loc4_:* = undefined;
         var _loc1_:* = 0.8 / this._charList.length;
         var _loc2_:* = 0;
         var _loc3_:* = this.missionInfo.width / 2 + 10;
         while(this._charList.length > 0)
         {
            _loc4_ = this._charList.pop();
            this._onRemoveChar.push(_loc4_);
            TweenLite.to(_loc4_,0.6,{
               "x":_loc3_,
               "delay":_loc2_ * _loc1_,
               "onComplete":this.removeFromCharList,
               "onCompleteParams":[_loc4_]
            });
            _loc2_++;
         }
      }
      
      function removeFromCharList(param1:*) : void
      {
         var _loc2_:* = this._onRemoveChar.indexOf(param1);
         if(_loc2_ in this._onRemoveChar)
         {
            this._onRemoveChar.splice(_loc2_,1);
         }
         if(this._onRemoveChar.length == 0)
         {
            dispatchEvent(new MissionEvent(MissionEvent.SET_NEW_MISSION));
         }
      }
      
      function createFlyingText(param1:Boolean = true) : void
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:TextFormat = null;
         var _loc11_:TextField = null;
         var _loc12_:Rectangle = null;
         var _loc13_:Rectangle = null;
         var _loc2_:* = this.missionInfo.text;
         var _loc3_:* = this.missionInfo.width / 2;
         var _loc4_:* = 0;
         var _loc5_:* = 0.8 / _loc2_.length;
         var _loc6_:* = this.missionInfo.width / 2 + 10;
         var _loc7_:* = 0;
         while(_loc7_ < _loc2_.length)
         {
            if((_loc8_ = _loc2_.charAt(_loc7_)) != " " && _loc8_ != "\n")
            {
               _loc9_ = new Sprite();
               (_loc10_ = this.missionInfo.defaultTextFormat).align = TextFormatAlign.LEFT;
               (_loc11_ = new TextField()).defaultTextFormat = _loc10_;
               _loc11_.embedFonts = true;
               _loc11_.selectable = false;
               _loc12_ = (this.missionInfo as TextField).getCharBoundaries(_loc7_);
               _loc11_.autoSize = TextFieldAutoSize.LEFT;
               _loc11_.text = _loc8_;
               _loc13_ = (_loc11_ as TextField).getCharBoundaries(0);
               _loc11_.x = -_loc11_.width / 2;
               _loc11_.y = -_loc11_.height / 2;
               _loc9_.addChild(_loc11_);
               _loc9_.mouseEnabled = false;
               _loc9_.mouseChildren = false;
               _loc9_.x = _loc12_.x + this.missionInfo.x + _loc11_.width / 2 - _loc13_.x;
               _loc9_.y = _loc12_.y + this.missionInfo.y + _loc11_.height / 2 - _loc13_.y;
               addChild(_loc9_);
               if(param1)
               {
                  this._incomingChar.push(_loc9_);
                  TweenLite.from(_loc9_,0.6,{
                     "x":_loc6_,
                     "delay":_loc7_ * _loc5_,
                     "onComplete":this.addToCharList,
                     "onCompleteParams":[_loc9_]
                  });
               }
               else
               {
                  this._charList.push(_loc9_);
               }
            }
            _loc7_++;
         }
      }
      
      function addToCharList(param1:*) : void
      {
         if(this._charList.indexOf(param1) < 0)
         {
            this._charList.push(param1);
         }
         var _loc2_:* = this._incomingChar.indexOf(param1);
         if(_loc2_ in this._incomingChar)
         {
            this._incomingChar.splice(_loc2_,1);
         }
         if(this._incomingChar.length == 0)
         {
            dispatchEvent(new MissionEvent(MissionEvent.MISSION_SET));
         }
      }
      
      public function setLinkable() : void
      {
         this.mouseEnabled = true;
         this.mouseChildren = true;
         this.buttonMode = true;
         addListenerOf(this,MouseEvent.CLICK,this.onClick);
         addListenerOf(this,MouseEvent.ROLL_OVER,this.onOver);
      }
      
      function onClick(param1:MouseEvent) : void
      {
         var _loc2_:* = root;
         _loc2_.linkToGamesfree();
      }
      
      function onOver(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this._charList.length)
         {
            this._charList[_loc2_].transform.colorTransform = new ColorTransform(1,1,1,1,63,63,63,0);
            _loc2_++;
         }
         addListenerOf(this,MouseEvent.ROLL_OUT,this.onOut);
      }
      
      function onOut(param1:MouseEvent) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this._charList.length)
         {
            this._charList[_loc2_].transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
            _loc2_++;
         }
         removeListenerOf(this,MouseEvent.ROLL_OUT,this.onOut);
      }
      
      public function setMission(param1:String) : void
      {
         this.missionInfo.text = param1;
         this.createFlyingText();
      }
      
      public function changeText(param1:String) : void
      {
         var _loc2_:* = undefined;
         while(this._charList.length > 0)
         {
            _loc2_ = this._charList.shift();
            _loc2_.parent.removeChild(_loc2_);
         }
         this.missionInfo.text = param1;
         this.createFlyingText(false);
      }
   }
}
