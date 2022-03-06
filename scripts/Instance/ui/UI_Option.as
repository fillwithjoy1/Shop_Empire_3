package Instance.ui
{
   import Instance.Gameplay;
   import Instance.SEMovieClip;
   import Instance.constant.DefaultSetting;
   import Instance.events.AudioEvent;
   import Instance.events.CommandEvent;
   import Instance.events.SliderBarEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.StageQuality;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class UI_Option extends SEMovieClip
   {
       
      
      public var btnSaveAndExit:SimpleButton;
      
      public var bgmSlider:UI_OptionSoundSlider;
      
      public var btnClose:SimpleButton;
      
      public var sfxSlider:UI_OptionSfxSlider;
      
      public var qualityControl:MovieClip;
      
      public var autoSaveCheckBox:CheckBox;
      
      public var btnDefault:SimpleButton;
      
      const SELECTED_COLOR = 15278883;
      
      const OVERRED_COLOR = 16750642;
      
      const UNSELECTED_COLOR = 10790052;
      
      var currentQuality;
      
      var currentVolume:Number;
      
      var currentSFXVolume:Number;
      
      var currentAutoSave:Boolean;
      
      var _main:Gameplay;
      
      var _mainProgram:MainProgram;
      
      public function UI_Option()
      {
         super();
         with(this.qualityControl)
         {
            graphicLow.mouseEnabled = false;
            graphicMed.mouseEnabled = false;
            graphicHigh.mouseEnabled = false;
            btnGraphicLow.buttonMode = true;
            btnGraphicLow.tabEnabled = false;
            btnGraphicMed.buttonMode = true;
            btnGraphicMed.tabEnabled = false;
            btnGraphicHigh.buttonMode = true;
            btnGraphicHigh.tabEnabled = false;
         }
      }
      
      override protected function Initialize(param1:Event) : void
      {
         this.currentQuality = stage.quality;
         if(this._main != null)
         {
            this.currentVolume = this._main.bgmVolume;
            this.currentSFXVolume = this._main.sfxVolume;
            this.bgmSlider.indicatorSign.alpha = !!this._main.mainProgram.bgmMute ? Number(0.6) : Number(1);
            this.sfxSlider.indicatorSign.alpha = !!this._main.mainProgram.sfxMute ? Number(0.6) : Number(1);
         }
         else if(this._mainProgram != null)
         {
            this.currentVolume = this._mainProgram.bgmVolume;
            this.currentSFXVolume = this._mainProgram.sfxVolume;
            this.bgmSlider.indicatorSign.alpha = !!this._mainProgram.bgmMute ? Number(0.6) : Number(1);
            this.sfxSlider.indicatorSign.alpha = !!this._mainProgram.sfxMute ? Number(0.6) : Number(1);
         }
         super.Initialize(param1);
         addListenerOf(this.btnClose,MouseEvent.CLICK,this.closeOption);
         addListenerOf(this.btnSaveAndExit,MouseEvent.CLICK,this.saveOption);
         addListenerOf(this.btnDefault,MouseEvent.CLICK,this.setToDefault);
         addListenerOf(this.qualityControl.btnGraphicLow,MouseEvent.CLICK,this.btnQualityOnClick);
         addListenerOf(this.qualityControl.btnGraphicMed,MouseEvent.CLICK,this.btnQualityOnClick);
         addListenerOf(this.qualityControl.btnGraphicHigh,MouseEvent.CLICK,this.btnQualityOnClick);
         addListenerOf(this.qualityControl.btnGraphicLow,MouseEvent.MOUSE_OVER,this.btnQualityOnOver);
         addListenerOf(this.qualityControl.btnGraphicMed,MouseEvent.MOUSE_OVER,this.btnQualityOnOver);
         addListenerOf(this.qualityControl.btnGraphicHigh,MouseEvent.MOUSE_OVER,this.btnQualityOnOver);
         addListenerOf(this.bgmSlider,SliderBarEvent.CHANGE_POSITION,this.soundSliderPositionChange);
         addListenerOf(this.sfxSlider,SliderBarEvent.CHANGE_POSITION,this.soundSliderPositionChange);
         this.setQualitySelection();
         if(this._main != null)
         {
            this.bgmSlider.setPosition(this._main.bgmVolume);
            this.sfxSlider.setPosition(this._main.sfxVolume);
            this.autoSaveCheckBox.isActive = this._main.mainProgram.autoSave;
         }
         else if(this._mainProgram != null)
         {
            this.bgmSlider.setPosition(this._mainProgram.bgmVolume);
            this.sfxSlider.setPosition(this._mainProgram.sfxVolume);
            this.autoSaveCheckBox.isActive = this._mainProgram.autoSave;
         }
      }
      
      function soundSliderPositionChange(param1:SliderBarEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         _loc2_.indicatorSign.scaleX = _loc2_.getPosition();
         if(_loc2_ == this.bgmSlider)
         {
            if(this._main != null)
            {
               this._main.bgmVolume = _loc2_.getPosition();
               this._main.dispatchEvent(new AudioEvent(AudioEvent.CHANGE_BGM_MASTER_VOLUME));
            }
            else if(this._mainProgram != null)
            {
               this._mainProgram.bgmVolume = _loc2_.getPosition();
            }
         }
         else if(_loc2_ == this.sfxSlider)
         {
            if(this._main != null)
            {
               this._main.sfxVolume = _loc2_.getPosition();
               this._main.dispatchEvent(new AudioEvent(AudioEvent.CHANGE_SFX_MASTER_VOLUME));
            }
            else if(this._mainProgram != null)
            {
               this._mainProgram.sfxVolume = _loc2_.getPosition();
            }
         }
      }
      
      function closeOption(param1:MouseEvent) : void
      {
         this.cancelChange();
         dispatchEvent(new CommandEvent(CommandEvent.EXIT_OPTION));
      }
      
      public function cancelChange() : void
      {
         stage.quality = this.currentQuality;
         if(this._main != null)
         {
            this._main.bgmVolume = this.currentVolume;
            this._main.sfxVolume = this.currentSFXVolume;
            this._main.dispatchEvent(new AudioEvent(AudioEvent.CHANGE_BGM_MASTER_VOLUME));
            this._main.dispatchEvent(new AudioEvent(AudioEvent.CHANGE_SFX_MASTER_VOLUME));
         }
         else if(this._mainProgram != null)
         {
            this._mainProgram.bgmVolume = this.currentVolume;
            this._mainProgram.sfxVolume = this.currentSFXVolume;
         }
      }
      
      function saveOption(param1:MouseEvent) : void
      {
         if(this._main != null)
         {
            this._main.GUI.soundPanel.bgmSlider.setPosition(this._main.bgmVolume);
            this._main.GUI.soundPanel.sfxSlider.setPosition(this._main.sfxVolume);
            this._main.mainProgram.autoSave = this.autoSaveCheckBox.isActive;
         }
         else
         {
            this._mainProgram.autoSave = this.autoSaveCheckBox.isActive;
         }
         var _loc2_:* = new Object();
         _loc2_.quality = stage.quality;
         if(this._main != null)
         {
            _loc2_.bgmVolume = this._main.bgmVolume;
            _loc2_.sfxVolume = this._main.sfxVolume;
            _loc2_.autoSave = this._main.mainProgram.autoSave;
            this._main.mainProgram.saveSetting(_loc2_);
         }
         else if(this._mainProgram != null)
         {
            _loc2_.bgmVolume = this._mainProgram.bgmVolume;
            _loc2_.sfxVolume = this._mainProgram.sfxVolume;
            _loc2_.autoSave = this._mainProgram.autoSave;
            this._mainProgram.saveSetting(_loc2_);
         }
         dispatchEvent(new CommandEvent(CommandEvent.EXIT_OPTION));
      }
      
      function setToDefault(param1:MouseEvent) : void
      {
         stage.quality = DefaultSetting.QUALITY;
         this.bgmSlider.setPosition(DefaultSetting.VOLUME);
         this.sfxSlider.setPosition(DefaultSetting.VOLUME);
         this.autoSaveCheckBox.isActive = DefaultSetting.AUTO_SAVE;
         this.setQualitySelection();
      }
      
      function setQualitySelection() : void
      {
         with(this.qualityControl)
         {
            graphicLow.textColor = stage.quality == "LOW" ? 16711680 : 9671571;
            graphicMed.textColor = stage.quality == "MEDIUM" ? 16711680 : 9671571;
            graphicHigh.textColor = stage.quality == "HIGH" ? 16711680 : 9671571;
            btnGraphicLow.enabled = stage.quality != "LOW";
            btnGraphicMed.enabled = stage.quality != "MEDIUM";
            btnGraphicHigh.enabled = stage.quality != "HIGH";
         }
      }
      
      function btnQualityOnClick(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var target:* = e.currentTarget;
         if(target.enabled)
         {
            with(this.qualityControl)
            {
               
               graphicLow.textColor = target == btnGraphicLow ? SELECTED_COLOR : UNSELECTED_COLOR;
               graphicMed.textColor = target == btnGraphicMed ? SELECTED_COLOR : UNSELECTED_COLOR;
               graphicHigh.textColor = target == btnGraphicHigh ? SELECTED_COLOR : UNSELECTED_COLOR;
               btnGraphicLow.enabled = btnGraphicLow != target;
               btnGraphicMed.enabled = btnGraphicMed != target;
               btnGraphicHigh.enabled = btnGraphicHigh != target;
            }
            stage.quality = this.getQualityActive();
         }
      }
      
      function getQualityActive() : String
      {
         return !this.qualityControl.btnGraphicLow.enabled ? StageQuality.LOW : (!this.qualityControl.btnGraphicMed.enabled ? StageQuality.MEDIUM : (!this.qualityControl.btnGraphicHigh.enabled ? StageQuality.HIGH : StageQuality.HIGH));
      }
      
      function btnQualityOnOver(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var target:* = e.currentTarget;
         if(target.enabled)
         {
            with(this.qualityControl)
            {
               
               if(target == btnGraphicLow)
               {
                  graphicLow.textColor = OVERRED_COLOR;
               }
               else if(target == btnGraphicMed)
               {
                  graphicMed.textColor = OVERRED_COLOR;
               }
               else if(target == btnGraphicHigh)
               {
                  graphicHigh.textColor = OVERRED_COLOR;
               }
            }
            addListenerOf(target,MouseEvent.MOUSE_OUT,this.btnQualityOnOut);
         }
      }
      
      function btnQualityOnOut(param1:MouseEvent) : void
      {
         var e:MouseEvent = param1;
         var target:* = e.currentTarget;
         if(target.enabled)
         {
            with(this.qualityControl)
            {
               
               if(target == btnGraphicLow)
               {
                  graphicLow.textColor = UNSELECTED_COLOR;
               }
               else if(target == btnGraphicMed)
               {
                  graphicMed.textColor = UNSELECTED_COLOR;
               }
               else if(target == btnGraphicHigh)
               {
                  graphicHigh.textColor = UNSELECTED_COLOR;
               }
            }
            removeListenerOf(target,MouseEvent.MOUSE_OUT,this.btnQualityOnOut);
         }
      }
      
      public function set mainProgram(param1:MainProgram) : void
      {
         this._mainProgram = param1;
      }
      
      public function get mainProgram() : MainProgram
      {
         return this._mainProgram;
      }
      
      public function set main(param1:Gameplay) : void
      {
         this._main = param1;
      }
      
      public function get main() : Gameplay
      {
         return this._main;
      }
   }
}
