package Instance.events
{
   import flash.events.Event;
   
   public class AudioEvent extends Event
   {
      
      public static const PLAY_SFX = "playSFX";
      
      public static const PLAY_DYNAMIC_SFX = "playDynamicSFX";
      
      public static const PAUSE_SFX = "pauseSFX";
      
      public static const RESUME_SFX = "resumeSFX";
      
      public static const CHANGE_SFX_VOLUME = "changeSFXVolume";
      
      public static const PLAY_AMBIENT = "playAmbient";
      
      public static const STOP_AMBIENT = "stopAmbient";
      
      public static const PAUSE_AMBIENT = "pauseAmbient";
      
      public static const RESUME_AMBIENT = "resumeAmbient";
      
      public static const CHANGE_AMBIENT_VOLUME = "changeAmbientVolume";
      
      public static const PLAY_BGM = "playBGM";
      
      public static const STOP_BGM = "stopBGM";
      
      public static const CHANGE_BGM_VOLUME = "changeBGMVolume";
      
      public static const CHANGE_BGM_MASTER_VOLUME = "changeBGMMasterVolume";
      
      public static const INTERRUPT_BGM = "interruptBGM";
      
      public static const STOP_INTERRUPT_BGM = "stopInterruptBGM";
      
      public static const FINISH_CHANGE_BGM_VOLUME = "finishChangeBGMVolume";
      
      public static const CHANGE_SFX_MASTER_VOLUME = "changeSFXMasterVolume";
       
      
      var _audio;
      
      var _volume:Number;
      
      var _duration:Number;
      
      var _startingPosition:int;
      
      var _bgm;
      
      public function AudioEvent(param1:String, param2:* = null, param3:Number = 1, param4:Number = 0, param5:Number = 0)
      {
         super(param1,true,true);
         this._audio = param2;
         this._volume = param3;
         this._startingPosition = param5;
         this._duration = param4;
      }
      
      override public function clone() : Event
      {
         return new AudioEvent(type,this._audio,this._volume,this._duration);
      }
      
      public function get audio() : *
      {
         return this._audio;
      }
      
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function get duration() : Number
      {
         return this._duration;
      }
      
      public function get startingPosition() : int
      {
         return this._startingPosition;
      }
   }
}
