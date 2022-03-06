package
{
   import Instance.Gameplay;
   import Instance.events.AudioEvent;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.modules.Calculate;
   import Instance.ui.UI_InputName;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.net.SharedObject;
   import greensock.TweenLite;
   
   public class MainProgram extends MovieClip
   {
       
      
      var darkCover:Sprite;
      
      var brightCover:Sprite;
      
      var gameplay:Gameplay;
      
      var _playedBGM;
      
      var _bgmChannel:SoundChannel;
      
      var _bgmTransform:SoundTransform;
      
      var _bgmCurrentVolume:Number;
      
      var _bgmVolume:Number;
      
      var _interruptPlayedBGM;
      
      var _interruptChannel:SoundChannel;
      
      var _interruptTransform:SoundTransform;
      
      var _sfxChannelList:Array;
      
      var _sfxDataList:Array;
      
      var _ambientPlayed:Array;
      
      var _ambientChannelList:Array;
      
      var _ambientDataList:Array;
      
      var _sfxVolume:Number;
      
      var _bgmMute:Boolean;
      
      var _sfxMute:Boolean;
      
      var _so:SharedObject;
      
      var _autoSave:Boolean;
      
      public function MainProgram()
      {
         super();
         addFrameScript(1,this.frame2);
         this.darkCover = new Sprite();
         this.darkCover.graphics.clear();
         this.darkCover.graphics.beginFill(0,0.3);
         this.darkCover.graphics.drawRect(0,0,700,500);
         this.darkCover.graphics.endFill();
         this.brightCover = new Sprite();
         this.brightCover.graphics.clear();
         this.brightCover.graphics.beginFill(16777215);
         this.brightCover.graphics.drawRect(0,0,700,500);
         this.brightCover.graphics.endFill();
         addEventListener(Event.ADDED_TO_STAGE,this.Initialize);
         stage.tabChildren = false;
         this._interruptTransform = new SoundTransform();
         this._bgmTransform = new SoundTransform();
         this._bgmCurrentVolume = 1;
         this._bgmVolume = 1;
         this._so = SharedObject.getLocal("ShopEmpire3SavedGame");
         this._sfxVolume = 1;
         this._sfxChannelList = new Array();
         this._sfxDataList = new Array();
         this._ambientPlayed = new Array();
         this._ambientChannelList = new Array();
         this._ambientDataList = new Array();
         this._autoSave = true;
         this._bgmMute = false;
         this._sfxMute = false;
      }
      
      function Initialize(param1:Event) : void
      {
         this.initSetting();
         this.loadListener();
         addEventListener(Event.ADDED,this.firstAdded);
      }
      
      function initSetting() : void
      {
         var _loc1_:* = undefined;
         if(this._so.data.setting)
         {
            _loc1_ = this._so.data.setting;
            stage.quality = _loc1_.quality;
            this._bgmVolume = _loc1_.bgmVolume;
            this._sfxVolume = _loc1_.sfxVolume;
            this._autoSave = _loc1_.autoSave;
         }
      }
      
      function firstAdded(param1:Event) : void
      {
         removeEventListener(Event.ADDED,this.firstAdded);
         this.brightCover.alpha = 1;
         addChild(this.brightCover);
         TweenLite.to(this.brightCover,1.2,{
            "alpha":0,
            "onComplete":removeChild,
            "onCompleteParams":[this.brightCover]
         });
      }
      
      function loadListener() : void
      {
         addEventListener(CommandEvent.BEGIN_NEW_GAME,this.checkBeginNewGame);
         addEventListener(CommandEvent.BEGIN_LOAD_GAME,this.checkBeginLoadGame);
         addEventListener(CommandEvent.BACK_TO_MAIN_MENU,this.checkBackToMainMenu);
         addEventListener(AudioEvent.PLAY_BGM,this.playBGM);
         addEventListener(AudioEvent.PLAY_SFX,this.playSFX);
         addEventListener(AudioEvent.PLAY_DYNAMIC_SFX,this.playDynamicSFX);
         addEventListener(AudioEvent.PLAY_AMBIENT,this.playAmbient);
         addEventListener(AudioEvent.STOP_AMBIENT,this.stopAmbient);
         addEventListener(AudioEvent.PAUSE_AMBIENT,this.pauseAmbient);
         addEventListener(AudioEvent.RESUME_AMBIENT,this.resumeAmbient);
         addEventListener(AudioEvent.INTERRUPT_BGM,this.interruptBGM);
         addEventListener(AudioEvent.STOP_INTERRUPT_BGM,this.stopInterruptBGM);
         addEventListener(AudioEvent.STOP_BGM,this.stopBGM);
         addEventListener(AudioEvent.CHANGE_BGM_VOLUME,this.changeBGMVolume);
         addEventListener(AudioEvent.CHANGE_BGM_MASTER_VOLUME,this.changeBGMMasterVolume);
         addEventListener(AudioEvent.CHANGE_SFX_MASTER_VOLUME,this.changeSFXMasterVolume);
         addEventListener(GameEvent.SAVE_GAME_DATA,this.saveTheGame);
         addEventListener(CommandEvent.DELETE_SAVE_DATA,this.deleteTheData);
         addEventListener(Event.ENTER_FRAME,this.checkPlayedSFX);
      }
      
      function checkBeginNewGame(param1:CommandEvent) : void
      {
         addChild(this.darkCover);
         var _loc2_:* = new UI_InputName();
         _loc2_.x = 350;
         _loc2_.y = 250;
         _loc2_.slotIndex = param1.tag;
         _loc2_.text = "";
         addChild(_loc2_);
         _loc2_.addEventListener(Event.REMOVED_FROM_STAGE,this.cancelChooseName);
         _loc2_.addEventListener(CommandEvent.DECIDE_NAME,this.declareNameForNewGame);
      }
      
      function checkBeginLoadGame(param1:CommandEvent) : void
      {
         this.brightCover.alpha = 0;
         addChild(this.brightCover);
         TweenLite.to(this.brightCover,1.4,{
            "alpha":1,
            "onComplete":this.declareLoadGame,
            "onCompleteParams":[param1.tag]
         });
         dispatchEvent(new AudioEvent(AudioEvent.CHANGE_BGM_VOLUME,null,0,1.2));
      }
      
      function checkBackToMainMenu(param1:CommandEvent) : void
      {
         var _loc2_:* = undefined;
         this.brightCover.alpha = 0;
         addChild(this.brightCover);
         if(this._interruptPlayedBGM != null)
         {
            this._interruptChannel.removeEventListener(Event.SOUND_COMPLETE,this.repeatInterruptBGM);
            dispatchEvent(new AudioEvent(AudioEvent.STOP_BGM));
            this._bgmCurrentVolume = 1;
            this._bgmChannel = this._interruptChannel;
            this._playedBGM = this._interruptPlayedBGM;
            this._bgmChannel.addEventListener(Event.SOUND_COMPLETE,this.repeatBGM);
            this._interruptChannel = null;
            this._interruptPlayedBGM = null;
            while(this._ambientPlayed.length > 0)
            {
               _loc2_ = this._ambientPlayed[0];
               dispatchEvent(new AudioEvent(AudioEvent.STOP_AMBIENT,_loc2_));
               this._ambientPlayed.shift();
               this._ambientChannelList.shift();
               this._ambientDataList.shift();
            }
         }
         dispatchEvent(new AudioEvent(AudioEvent.CHANGE_BGM_VOLUME,null,0,1.2));
         TweenLite.to(this.brightCover,1.4,{
            "alpha":1,
            "onComplete":this.declareBackToMainMenu
         });
      }
      
      function cancelChooseName(param1:Event) : void
      {
         if(getChildByName(this.darkCover.name))
         {
            removeChild(this.darkCover);
         }
         param1.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE,this.cancelChooseName);
         param1.currentTarget.removeEventListener(CommandEvent.DECIDE_NAME,this.declareNameForNewGame);
      }
      
      function declareNameForNewGame(param1:CommandEvent) : void
      {
         this.brightCover.alpha = 0;
         addChild(this.brightCover);
         TweenLite.to(this.brightCover,1.4,{
            "alpha":1,
            "onComplete":this.declareNewGame,
            "onCompleteParams":[param1.currentTarget]
         });
         param1.currentTarget.removeEventListener(CommandEvent.DECIDE_NAME,this.declareNameForNewGame);
         dispatchEvent(new AudioEvent(AudioEvent.CHANGE_BGM_VOLUME,null,0,1.2));
      }
      
      function declareBackToMainMenu() : void
      {
         dispatchEvent(new AudioEvent(AudioEvent.STOP_BGM));
         removeChild(this.gameplay);
         gotoAndStop("main menu");
         setChildIndex(this.brightCover,numChildren - 1);
         TweenLite.to(this.brightCover,1.2,{
            "alpha":0,
            "onComplete":removeChild,
            "onCompleteParams":[this.brightCover]
         });
      }
      
      function declareNewGame(param1:*) : void
      {
         if(param1 != null)
         {
            if(getChildByName(param1.name))
            {
               removeChild(param1);
            }
         }
         gotoAndStop("gameplay");
         this.gameplay = new Gameplay();
         this.gameplay.mainProgram = this;
         this.gameplay.nameID = param1.text;
         this.gameplay.slotIndex = param1.slotIndex;
         this.gameplay.bgmVolume = this._bgmVolume;
         this.gameplay.sfxVolume = this._sfxVolume;
         addChildAt(this.gameplay,0);
         TweenLite.to(this.brightCover,1.2,{
            "alpha":0,
            "onComplete":this.runGameplay
         });
      }
      
      function declareLoadGame(param1:*) : void
      {
         gotoAndStop("gameplay");
         var _loc2_:* = this._so.data.slot[param1];
         this.gameplay = new Gameplay();
         this.gameplay.mainProgram = this;
         this.gameplay.slotIndex = param1;
         this.gameplay.bgmVolume = this._bgmVolume;
         this.gameplay.sfxVolume = this._sfxVolume;
         this.gameplay.loadFrom(_loc2_);
         addChildAt(this.gameplay,0);
         TweenLite.to(this.brightCover,1.2,{
            "alpha":0,
            "onComplete":this.runGameplay
         });
      }
      
      function runGameplay() : void
      {
         if(getChildByName(this.brightCover.name))
         {
            removeChild(this.brightCover);
         }
         this.gameplay.runGameplay();
      }
      
      function saveTheGame(param1:GameEvent) : void
      {
         var saveSign:* = undefined;
         var saveTime:* = undefined;
         var doSaving:Function = null;
         var e:GameEvent = param1;
         var index:* = e.tag.slot;
         var saveData:* = e.tag.toSave;
         if(this._so.data.slot == null)
         {
            this._so.data.slot = new Array();
            this._so.data.slot.push(null);
            this._so.data.slot.push(null);
            this._so.data.slot.push(null);
         }
         if(index in this._so.data.slot)
         {
            this._so.data.slot[index] = saveData;
         }
         this._so.flush(this._so.size);
         if(!e.tag.isAuto)
         {
            doSaving = function(param1:Event):void
            {
               if(saveTime > 0)
               {
                  --saveTime;
               }
               else
               {
                  if(saveSign.stage != null)
                  {
                     saveSign.parent.removeChild(saveSign);
                  }
                  removeEventListener(Event.ENTER_FRAME,doSaving);
               }
            };
            saveSign = new UISavingProgress();
            stage.addChild(saveSign);
            saveTime = 16 + Math.floor(Math.random() * 10);
            addEventListener(Event.ENTER_FRAME,doSaving);
         }
      }
      
      function deleteTheData(param1:CommandEvent) : void
      {
         var _loc2_:* = param1.tag;
         if(_loc2_ in this._so.data.slot)
         {
            this._so.data.slot[_loc2_] = null;
         }
      }
      
      function stopBGM(param1:AudioEvent) : void
      {
         if(this._bgmChannel != null)
         {
            this._bgmChannel.stop();
            this._bgmChannel.removeEventListener(Event.SOUND_COMPLETE,this.repeatBGM);
         }
         if(this._playedBGM != null)
         {
            this._playedBGM = null;
         }
      }
      
      function stopInterruptBGM(param1:AudioEvent) : void
      {
         if(this._interruptChannel != null)
         {
            this._interruptChannel.stop();
            this._interruptChannel.removeEventListener(Event.SOUND_COMPLETE,this.repeatInterruptBGM);
         }
         if(this._interruptPlayedBGM != null)
         {
            this._interruptPlayedBGM = null;
         }
         var _loc2_:* = this._bgmChannel.soundTransform;
         _loc2_.volume = this._bgmCurrentVolume * this._bgmVolume * (!!this._bgmMute ? 0 : 1);
         this._bgmChannel.soundTransform = _loc2_;
      }
      
      function interruptBGM(param1:AudioEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this._interruptChannel != null)
         {
            this._interruptChannel.removeEventListener(Event.SOUND_COMPLETE,this.repeatInterruptBGM);
         }
         var _loc2_:* = param1.audio;
         if(_loc2_ != null)
         {
            _loc3_ = this._bgmChannel.soundTransform;
            _loc3_.volume = 0;
            this._bgmChannel.soundTransform = _loc3_;
            this._interruptPlayedBGM = _loc2_;
            _loc4_ = _loc2_.bgm;
            this._interruptTransform.volume = this._bgmVolume * (!!this._bgmMute ? 0 : 1);
            if(_loc4_ != null)
            {
               _loc5_ = new _loc4_();
               this._interruptChannel = _loc5_.play(0,0,this._interruptTransform);
               this._interruptChannel.addEventListener(Event.SOUND_COMPLETE,this.repeatInterruptBGM);
            }
         }
      }
      
      function playBGM(param1:AudioEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this._bgmChannel != null)
         {
            this._bgmChannel.removeEventListener(Event.SOUND_COMPLETE,this.repeatBGM);
            this._bgmChannel.stop();
            this._bgmChannel = null;
         }
         var _loc2_:* = param1.audio;
         if(_loc2_ != null)
         {
            this._playedBGM = _loc2_;
            _loc3_ = _loc2_.bgm;
            this._bgmCurrentVolume = param1.volume;
            if(this._interruptPlayedBGM != null)
            {
               this._bgmTransform.volume = 0;
            }
            else
            {
               this._bgmTransform.volume = param1.volume * this._bgmVolume * (!!this._bgmMute ? 0 : 1);
            }
            if(_loc3_ != null)
            {
               _loc4_ = new _loc3_();
               this._bgmChannel = _loc4_.play(0,0,this._bgmTransform);
               this._bgmChannel.addEventListener(Event.SOUND_COMPLETE,this.repeatBGM);
            }
         }
      }
      
      function changeBGMVolume(param1:AudioEvent) : void
      {
         var theChannel:* = undefined;
         var newSoundTransform:* = undefined;
         var tObject:* = undefined;
         var e:AudioEvent = param1;
         theChannel = this._bgmChannel;
         if(theChannel != null)
         {
            if(e.duration == 0)
            {
               newSoundTransform = new SoundTransform();
               if(this._interruptPlayedBGM != null)
               {
                  newSoundTransform.volume = 0;
               }
               else
               {
                  newSoundTransform.volume = e.volume * this._bgmVolume * (!!this._bgmMute ? 0 : 1);
               }
               theChannel.soundTransform = newSoundTransform;
               this._bgmCurrentVolume = e.volume;
            }
            else
            {
               tObject = {"volume":this._bgmCurrentVolume};
               TweenLite.to(tObject,e.duration,{
                  "volume":e.volume,
                  "onUpdate":function():*
                  {
                     var _loc1_:* = new SoundTransform();
                     _bgmCurrentVolume = tObject.volume;
                     if(_interruptPlayedBGM != null)
                     {
                        _loc1_.volume = 0;
                     }
                     else
                     {
                        _loc1_.volume = tObject.volume * _bgmVolume * (!!_bgmMute ? 0 : 1);
                     }
                     theChannel.soundTransform = _loc1_;
                  },
                  "onComplete":dispatchEvent,
                  "onCompleteParams":[new AudioEvent(AudioEvent.FINISH_CHANGE_BGM_VOLUME)]
               });
            }
         }
      }
      
      function playRepeatBGM(param1:*, param2:SoundChannel, param3:Number) : SoundChannel
      {
         var _loc4_:*;
         var _loc5_:* = new (_loc4_ = param1.bgm)();
         var _loc6_:* = param2.soundTransform;
         var _loc7_:* = 0;
         if(param1.loopPos != null)
         {
            _loc7_ = param1.loopPos;
         }
         var _loc8_:*;
         (_loc8_ = new SoundTransform()).volume = param3 * this._bgmVolume * (!!this._bgmMute ? 0 : 1);
         return _loc5_.play(_loc7_,0,_loc8_);
      }
      
      function repeatBGM(param1:Event) : void
      {
         var _loc2_:* = undefined;
         this._bgmChannel.removeEventListener(Event.SOUND_COMPLETE,this.repeatBGM);
         if(this._playedBGM != null)
         {
            _loc2_ = 0;
            if(this._interruptPlayedBGM == null)
            {
               _loc2_ = this._bgmCurrentVolume;
            }
            this._bgmChannel = this.playRepeatBGM(this._playedBGM,this._bgmChannel,_loc2_);
            this._bgmChannel.addEventListener(Event.SOUND_COMPLETE,this.repeatBGM);
         }
      }
      
      function repeatInterruptBGM(param1:Event) : void
      {
         this._interruptChannel.removeEventListener(Event.SOUND_COMPLETE,this.repeatInterruptBGM);
         if(this._interruptPlayedBGM != null)
         {
            this._interruptChannel = this.playRepeatBGM(this._interruptPlayedBGM,this._interruptChannel,1);
            this._interruptChannel.addEventListener(Event.SOUND_COMPLETE,this.repeatInterruptBGM);
         }
      }
      
      function checkPlayedSFX(param1:Event) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:SoundTransform = null;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < this._sfxChannelList.length)
         {
            if(_loc2_ in this._sfxDataList)
            {
               _loc3_ = this._sfxDataList[_loc2_];
               if(_loc3_ != null && _loc3_.source != null)
               {
                  _loc4_ = 1;
                  _loc5_ = _loc3_.source.localToGlobal(new Point(0,0));
                  _loc6_ = new Point(350,200);
                  if((_loc7_ = Calculate.countDistance(_loc6_,_loc5_)) >= 250)
                  {
                     _loc4_ = Math.min(1,Math.max(0,1 - (_loc7_ - 250) / 175));
                  }
                  (_loc8_ = this._sfxChannelList[_loc2_].soundTransform).volume = _loc3_.volume * _loc4_ * this._sfxVolume * (!!this._sfxMute ? 0 : 1);
                  (_loc9_ = this._sfxChannelList[_loc2_]).soundTransform = _loc8_;
               }
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._ambientChannelList.length)
         {
            if(_loc2_ in this._ambientDataList)
            {
               if((_loc10_ = this._ambientDataList[_loc2_]) != null && _loc10_.source != null)
               {
                  _loc4_ = 1;
                  _loc11_ = _loc10_.source.getBounds(this);
                  _loc12_ = new Point(_loc11_.left,_loc11_.top);
                  _loc13_ = new Point(_loc11_.right,_loc11_.top);
                  _loc14_ = new Point(_loc11_.right,_loc11_.bottom);
                  _loc15_ = new Point(_loc11_.left,_loc11_.bottom);
                  _loc6_ = new Point(350,200);
                  if((_loc7_ = Math.min(Calculate.countDistance(_loc6_,_loc12_),Calculate.countDistance(_loc6_,_loc13_),Calculate.countDistance(_loc6_,_loc14_),Calculate.countDistance(_loc6_,_loc15_))) >= 250)
                  {
                     _loc4_ = Math.min(1,Math.max(0,1 - (_loc7_ - 250) / 175));
                  }
                  (_loc8_ = this._ambientChannelList[_loc2_].soundTransform).volume = _loc10_.volume * _loc4_ * this._sfxVolume * (!!this._sfxMute ? 0 : 1);
                  (_loc9_ = this._ambientChannelList[_loc2_]).soundTransform = _loc8_;
               }
            }
            _loc2_++;
         }
      }
      
      function pauseAmbient(param1:AudioEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = this._ambientPlayed.indexOf(param1.audio);
         var _loc3_:* = null;
         if(_loc2_ in this._ambientChannelList)
         {
            _loc3_ = this._ambientChannelList[_loc2_];
         }
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.position;
            this._ambientDataList[_loc2_].pausePosition = _loc4_;
            _loc3_.stop();
            _loc3_.removeEventListener(Event.SOUND_COMPLETE,this.repeatAmbient);
         }
      }
      
      function resumeAmbient(param1:AudioEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc2_:* = this._ambientPlayed.indexOf(param1.audio);
         if(_loc2_ in this._ambientChannelList)
         {
            if(this._ambientDataList[_loc2_].pausePosition != null)
            {
               _loc3_ = this._ambientDataList[_loc2_];
               _loc4_ = 1;
               _loc5_ = _loc3_.source.getBounds(this);
               _loc6_ = new Point(_loc5_.left,_loc5_.top);
               _loc7_ = new Point(_loc5_.right,_loc5_.top);
               _loc8_ = new Point(_loc5_.right,_loc5_.bottom);
               _loc9_ = new Point(_loc5_.left,_loc5_.bottom);
               _loc10_ = new Point(350,200);
               if((_loc11_ = Math.min(Calculate.countDistance(_loc10_,_loc6_),Calculate.countDistance(_loc10_,_loc7_),Calculate.countDistance(_loc10_,_loc8_),Calculate.countDistance(_loc10_,_loc9_))) >= 250)
               {
                  _loc4_ = Math.min(1,Math.max(0,1 - (_loc11_ - 250) / 175));
               }
               (_loc12_ = this._ambientChannelList[_loc2_].soundTransform).volume = _loc3_.volume * _loc4_ * this._sfxVolume * (!!this._sfxMute ? 0 : 1);
               _loc15_ = (_loc14_ = new (_loc13_ = this._ambientPlayed[_loc2_].sfx)()).play(this._ambientDataList[_loc2_].pausePosition,0,_loc12_);
               this._ambientChannelList[_loc2_] = _loc15_;
               _loc15_.addEventListener(Event.SOUND_COMPLETE,this.repeatAmbient);
               this._ambientDataList[_loc2_].pausePosition = null;
            }
         }
      }
      
      function playAmbient(param1:AudioEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         if(this._ambientChannelList.length < 2)
         {
            _loc2_ = param1.currentTarget;
            _loc3_ = param1.audio;
            if(_loc3_ != null)
            {
               _loc5_ = new (_loc4_ = _loc3_.sfx)();
               _loc6_ = 1;
               _loc7_ = param1.target.getBounds(this);
               _loc8_ = new Point(_loc7_.left,_loc7_.top);
               _loc9_ = new Point(_loc7_.right,_loc7_.top);
               _loc10_ = new Point(_loc7_.right,_loc7_.bottom);
               _loc11_ = new Point(_loc7_.left,_loc7_.bottom);
               _loc12_ = new Point(350,200);
               if((_loc13_ = Math.min(Calculate.countDistance(_loc12_,_loc8_),Calculate.countDistance(_loc12_,_loc9_),Calculate.countDistance(_loc12_,_loc10_),Calculate.countDistance(_loc12_,_loc11_))) >= 250)
               {
                  _loc6_ = Math.min(1,Math.max(0,1 - (_loc13_ - 250) / 175));
               }
               _loc14_ = new SoundTransform(param1.volume * _loc6_ * this._sfxVolume);
               _loc15_ = _loc5_.play(param1.startingPosition,0,_loc14_);
               this._ambientPlayed.push(_loc3_);
               this._ambientChannelList.push(_loc15_);
               this._ambientDataList.push({
                  "volume":param1.volume,
                  "source":param1.target
               });
               _loc15_.addEventListener(Event.SOUND_COMPLETE,this.repeatAmbient);
            }
         }
      }
      
      function stopAmbient(param1:AudioEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = param1.audio;
         var _loc3_:* = this._ambientPlayed.indexOf(_loc2_);
         if(_loc3_ in this._ambientPlayed)
         {
            (_loc4_ = this._ambientChannelList[_loc3_]).stop();
            this._ambientPlayed.splice(_loc3_,1);
            this._ambientChannelList.splice(_loc3_,1);
            this._ambientDataList.splice(_loc3_,1);
         }
      }
      
      function repeatAmbient(param1:Event) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         _loc2_.removeEventListener(Event.SOUND_COMPLETE,this.repeatBGM);
         var _loc3_:* = this._ambientChannelList.indexOf(_loc2_);
         if(_loc3_ in this._ambientChannelList)
         {
            if((_loc4_ = this._ambientDataList[_loc3_]) != null)
            {
               _loc6_ = new (_loc5_ = this._ambientPlayed[_loc3_].sfx)();
               _loc7_ = 1;
               _loc8_ = _loc4_.source.getBounds(this);
               _loc9_ = new Point(_loc8_.left,_loc8_.top);
               _loc10_ = new Point(_loc8_.right,_loc8_.top);
               _loc11_ = new Point(_loc8_.right,_loc8_.bottom);
               _loc12_ = new Point(_loc8_.left,_loc8_.bottom);
               _loc13_ = new Point(350,200);
               if((_loc14_ = Math.min(Calculate.countDistance(_loc13_,_loc9_),Calculate.countDistance(_loc13_,_loc10_),Calculate.countDistance(_loc13_,_loc11_),Calculate.countDistance(_loc13_,_loc12_))) >= 250)
               {
                  _loc7_ = Math.min(1,Math.max(0,1 - (_loc14_ - 250) / 175));
               }
               _loc15_ = _loc4_.volume;
               _loc16_ = this._ambientPlayed[_loc3_].loopPos;
               _loc17_ = new SoundTransform(_loc15_ * _loc7_ * this._sfxVolume);
               (_loc18_ = _loc6_.play(_loc16_,0,_loc17_)).addEventListener(Event.SOUND_COMPLETE,this.repeatAmbient);
               this._ambientChannelList[_loc3_] = _loc18_;
            }
         }
      }
      
      function playDynamicSFX(param1:AudioEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         if(this._sfxChannelList.length < 28)
         {
            _loc2_ = param1.currentTarget;
            _loc3_ = param1.audio;
            _loc4_ = new _loc3_();
            _loc5_ = 1;
            _loc6_ = param1.target.localToGlobal(new Point(0,0));
            _loc7_ = new Point(350,200);
            if((_loc8_ = Calculate.countDistance(_loc7_,_loc6_)) >= 250)
            {
               _loc5_ = Math.min(1,Math.max(0,1 - (_loc8_ - 250) / 175));
            }
            _loc9_ = new SoundTransform(param1.volume * _loc5_ * this._sfxVolume);
            _loc10_ = _loc4_.play(param1.startingPosition,0,_loc9_);
            this._sfxChannelList.push(_loc10_);
            this._sfxDataList.push({
               "volume":param1.volume,
               "source":param1.target
            });
            _loc10_.addEventListener(Event.SOUND_COMPLETE,this.finishSFX);
         }
      }
      
      function playSFX(param1:AudioEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this._sfxChannelList.length < 28)
         {
            _loc2_ = param1.currentTarget;
            _loc3_ = param1.audio;
            _loc4_ = new _loc3_();
            _loc5_ = new SoundTransform(param1.volume * this._sfxVolume);
            _loc6_ = _loc4_.play(param1.startingPosition,0,_loc5_);
            this._sfxChannelList.push(_loc6_);
            this._sfxDataList.push({"volume":param1.volume});
            _loc6_.addEventListener(Event.SOUND_COMPLETE,this.finishSFX);
         }
      }
      
      function finishSFX(param1:Event) : void
      {
         var _loc2_:* = param1.currentTarget;
         _loc2_.removeEventListener(Event.SOUND_COMPLETE,this.finishSFX);
         var _loc3_:* = this._sfxChannelList.indexOf(_loc2_);
         if(_loc3_ in this._sfxChannelList)
         {
            this._sfxChannelList.splice(_loc3_,1);
            this._sfxDataList.splice(_loc3_,1);
         }
      }
      
      function changeBGMMasterVolume(param1:AudioEvent) : void
      {
         var _loc2_:* = param1.target;
         this._bgmVolume = _loc2_.bgmVolume;
         this.updateBGMVolume();
      }
      
      function updateBGMVolume() : void
      {
         var _loc1_:* = undefined;
         if(this._bgmChannel != null)
         {
            _loc1_ = this._bgmChannel.soundTransform;
            _loc1_.volume = this._bgmCurrentVolume * this._bgmVolume * (!!this._bgmMute ? 0 : 1);
            this._bgmChannel.soundTransform = _loc1_;
         }
         if(this._interruptChannel != null)
         {
            _loc1_ = this._interruptChannel.soundTransform;
            _loc1_.volume = this._bgmVolume;
            this._interruptChannel.soundTransform = _loc1_;
         }
      }
      
      function changeSFXMasterVolume(param1:AudioEvent) : void
      {
         var _loc2_:* = param1.target;
         this._sfxVolume = _loc2_.sfxVolume;
         this.updateSFXVolume();
      }
      
      function updateSFXVolume() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._sfxChannelList.length)
         {
            _loc2_ = this._sfxChannelList[_loc1_];
            _loc3_ = this._sfxDataList[_loc1_];
            _loc4_ = 1;
            if(_loc3_.source != null)
            {
               _loc6_ = _loc3_.source.localToGlobal(new Point(0,0));
               _loc7_ = new Point(350,200);
               if((_loc8_ = Calculate.countDistance(_loc7_,_loc6_)) >= 250)
               {
                  _loc4_ = Math.min(1,Math.max(0,1 - (_loc8_ - 250) / 75));
               }
            }
            (_loc5_ = _loc2_.soundTransform).volume = _loc3_.volume * _loc4_ * this._sfxVolume * (!!this._sfxMute ? 0 : 1);
            _loc2_.soundTransform = _loc5_;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._ambientPlayed.length)
         {
            _loc2_ = this._ambientChannelList[_loc1_];
            _loc3_ = this._ambientDataList[_loc1_];
            _loc4_ = 1;
            if(_loc3_.source != null)
            {
               _loc6_ = _loc3_.source.localToGlobal(new Point(0,0));
               _loc7_ = new Point(350,200);
               if((_loc8_ = Calculate.countDistance(_loc7_,_loc6_)) >= 250)
               {
                  _loc4_ = Math.min(1,Math.max(0,1 - (_loc8_ - 250) / 75));
               }
            }
            (_loc5_ = _loc2_.soundTransform).volume = _loc3_.volume * _loc4_ * this._sfxVolume * (!!this._sfxMute ? 0 : 1);
            _loc2_.soundTransform = _loc5_;
            _loc1_++;
         }
      }
      
      public function getSaveData(param1:int) : *
      {
         if(this._so.data.slot)
         {
            if(param1 in this._so.data.slot)
            {
               return this._so.data.slot[param1];
            }
            return null;
         }
         return null;
      }
      
      public function set bgmVolume(param1:Number) : void
      {
         this._bgmVolume = param1;
         this.updateBGMVolume();
      }
      
      public function get bgmVolume() : Number
      {
         return this._bgmVolume;
      }
      
      public function set sfxVolume(param1:Number) : void
      {
         this._sfxVolume = param1;
         this.updateSFXVolume();
      }
      
      public function get sfxVolume() : Number
      {
         return this._sfxVolume;
      }
      
      public function set autoSave(param1:Boolean) : void
      {
         this._autoSave = param1;
      }
      
      public function get autoSave() : Boolean
      {
         return this._autoSave;
      }
      
      public function saveSetting(param1:*) : void
      {
         this._so.data.setting = param1;
      }
      
      public function set bgmMute(param1:Boolean) : void
      {
         this._bgmMute = param1;
         this.updateBGMVolume();
      }
      
      public function get bgmMute() : Boolean
      {
         return this._bgmMute;
      }
      
      public function set sfxMute(param1:Boolean) : void
      {
         this._sfxMute = param1;
         this.updateSFXVolume();
      }
      
      public function get sfxMute() : Boolean
      {
         return this._sfxMute;
      }
      
      function frame2() : *
      {
         stop();
      }
   }
}
