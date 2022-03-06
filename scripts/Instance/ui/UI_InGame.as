package Instance.ui
{
   import Instance.Gameplay;
   import Instance.SEMovieClip;
   import Instance.constant.BuildingData;
   import Instance.constant.ColorCode;
   import Instance.constant.HumanData;
   import Instance.events.AudioEvent;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.InfoDialogEvent;
   import Instance.events.MessageDialogEvent;
   import Instance.events.SliderBarEvent;
   import Instance.events.ToggleButtonEvent;
   import Instance.gameplay.Staff;
   import Instance.gameplay.Visitor;
   import Instance.modules.Utility;
   import Instance.progress.StaffHireProgress;
   import Instance.property.FacilityRestRoom;
   import Instance.property.FacilityStairs;
   import fl.motion.easing.Back;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import greensock.TweenLite;
   import greensock.TweenMax;
   import greensock.easing.Linear;
   
   public class UI_InGame extends SEMovieClip
   {
       
      
      public var dayPassedInfo:TextField;
      
      public var goldInfo:TextField;
      
      public var btnSpeed2:ToggleSpeed2;
      
      public var btnStaffDetail:ToggleStaffData;
      
      public var btnVisitorDetail:ToggleVisitorData;
      
      public var extraUpgradePanel:UI_ExtraUpgrade;
      
      public var btnBooth:UIToggleButtonSector;
      
      public var btnHelp:SimpleButton;
      
      public var helpPage:MovieClip;
      
      public var btnPause:UIToggleButtonPause;
      
      public var btnHint:UIToggleButtonSector;
      
      public var missionPanel:MissionInfo;
      
      public var clock:UIclock;
      
      public var statisticPanel:UI_Statistic;
      
      public var infoToBuild:UI_InfoBuild;
      
      public var notificationMask:MovieClip;
      
      public var chatLogPanel:UIchatlog;
      
      public var btnEntertainment:UIToggleButtonSector;
      
      public var btnManual:SimpleButton;
      
      public var hackedMessage:TextField;
      
      public var btnReport:UIToggleButtonSector;
      
      public var btnFacility:UIToggleButtonSector;
      
      public var foodCenterPanel:MovieClip;
      
      public var tutorialPanel:TutorialPanel;
      
      public var nameInfoIndicator:TextField;
      
      public var btnDrag:UIToggleButtonSector;
      
      public var btnAchievement:SimpleButton;
      
      public var hintPanel:HintPanel;
      
      public var btnFollowUs:SimpleButton;
      
      public var detailBuildingInfo:UI_BoothDetail;
      
      public var rewardPanel:RewardInfo;
      
      public var btnMiniMap:SimpleButton;
      
      public var detailStaffInfo:UI_StaffDetail;
      
      public var soundPanel:MovieClip;
      
      public var popularityValue:TextField;
      
      public var btnFood:UIToggleButtonSector;
      
      public var btnSetting:SimpleButton;
      
      public var staffPanel:MovieClip;
      
      public var hirePanel:UI_Hire;
      
      public var infoToHire:UI_InfoHire;
      
      public var btnGamesfree:SimpleButton;
      
      public var btnBuildingDetail:ToggleBuildingData;
      
      public var btnStaff:UIToggleButtonSector;
      
      public var entertainmentPanel:MovieClip;
      
      public var innPanel:MovieClip;
      
      public var generalStorePanel:MovieClip;
      
      public var detailVisitorInfo:UI_VisitorDetail;
      
      public var autoSaveIndicator:MovieClip;
      
      public var btnSpeed1:ToggleSpeed1;
      
      public var btnExtra:UIToggleButtonSector;
      
      public var btnInn:UIToggleButtonSector;
      
      public var minimapPanel:UI_Minimap;
      
      public var followUsPanel:UI_follow;
      
      public var btnLogHistory:SimpleButton;
      
      public var btnSelect:UIToggleButtonSector;
      
      public var btnSpeed3:ToggleSpeed3;
      
      public var facilityPanel:MovieClip;
      
      const NOTIFICATION_X = 690;
      
      const NOTIFICATION_Y = 430;
      
      const MAIN_BUTTON_INFO = ["Hint and tips","Select Cursor","Drag Cursor","Build General Store","Build Food Center","Build Inn\nBasment only","Build Entertainment","Build Facility","Hire Staff","Extra Upgrade","Statistic"];
      
      var _mainButtonList:Array;
      
      var _mainButtonIcon:Array;
      
      var _speedButtonList:Array;
      
      var _detailButtonList:Array;
      
      var _buttonGroup:Array;
      
      var _panelGrouping:Array;
      
      var _panelList:Array;
      
      var _defaultPanelPosition:Array;
      
      var _hidePanelPosition:Array;
      
      var _panelActivationButton:Array;
      
      var _panelToBuild:Array;
      
      var _panelToBuildButton:Array;
      
      var _panelIconList:Array;
      
      var _resizePanel:Array;
      
      var _hideSize:Array;
      
      var _revealedPanel;
      
      var _shownBudget:int;
      
      var _main:Gameplay;
      
      var activatePanelButton;
      
      var shownInfo;
      
      var infoPosition:Point;
      
      var minimapPosition:Point;
      
      var chatLogPosition:Point;
      
      var cover:Sprite;
      
      var notificationList:Array;
      
      var noticeContainer:MovieClip;
      
      var noticeBody:MovieClip;
      
      var _currentNumberVisitor:int;
      
      var _currentNumberStaff:int;
      
      var _currentNumberBuilding:int;
      
      var _infoPopUp;
      
      public function UI_InGame()
      {
         var _loc3_:* = undefined;
         super();
         this._mainButtonList = new Array();
         this._mainButtonList.push(this.btnHint);
         this._mainButtonList.push(this.btnSelect);
         this._mainButtonList.push(this.btnDrag);
         this._mainButtonList.push(this.btnBooth);
         this._mainButtonList.push(this.btnFood);
         this._mainButtonList.push(this.btnInn);
         this._mainButtonList.push(this.btnEntertainment);
         this._mainButtonList.push(this.btnFacility);
         this._mainButtonList.push(this.btnStaff);
         this._mainButtonList.push(this.btnExtra);
         this._mainButtonList.push(this.btnReport);
         this._speedButtonList = new Array();
         this._speedButtonList.push(this.btnSpeed1);
         this._speedButtonList.push(this.btnSpeed2);
         this._speedButtonList.push(this.btnSpeed3);
         this._detailButtonList = new Array();
         this._detailButtonList.push(this.btnVisitorDetail);
         this._detailButtonList.push(this.btnStaffDetail);
         this._detailButtonList.push(this.btnBuildingDetail);
         this._panelGrouping = new Array();
         this._panelGrouping = this._detailButtonList.concat();
         this._panelGrouping.push(this.btnHint);
         this._panelGrouping.push(this.btnBooth);
         this._panelGrouping.push(this.btnFood);
         this._panelGrouping.push(this.btnInn);
         this._panelGrouping.push(this.btnEntertainment);
         this._panelGrouping.push(this.btnFacility);
         this._panelGrouping.push(this.btnStaff);
         this._panelGrouping.push(this.btnExtra);
         this._panelGrouping.push(this.btnReport);
         this._buttonGroup = new Array();
         this._buttonGroup.push(this._mainButtonList);
         this._buttonGroup.push(this._speedButtonList);
         this._buttonGroup.push(this._panelGrouping);
         this._panelToBuild = new Array();
         this._panelToBuild.push(this.generalStorePanel);
         this._panelToBuild.push(this.foodCenterPanel);
         this._panelToBuild.push(this.innPanel);
         this._panelToBuild.push(this.entertainmentPanel);
         this._panelToBuild.push(this.facilityPanel);
         this._panelToBuild.push(this.staffPanel);
         this.initPanelIconList();
         this._resizePanel = new Array();
         this._hideSize = new Array();
         this._resizePanel.push(this.hintPanel);
         this._hideSize.push({
            "w":this.hintPanel.width / 2,
            "h":0
         });
         this._resizePanel.push(this.extraUpgradePanel);
         this._hideSize.push({
            "w":this.btnExtra.width,
            "h":this.btnExtra.height
         });
         this._resizePanel.push(this.statisticPanel);
         this._hideSize.push({
            "w":this.btnReport.width,
            "h":this.btnReport.height
         });
         this._panelList = new Array();
         this._panelActivationButton = new Array();
         this._hidePanelPosition = new Array();
         this._panelList.push(this.hintPanel);
         this._panelActivationButton.push(this.btnHint);
         this._hidePanelPosition.push(new Point(this.hintPanel.x,this.hintPanel.y));
         this._panelList.push(this.generalStorePanel);
         this._panelActivationButton.push(this.btnBooth);
         this._hidePanelPosition.push(new Point(-this.generalStorePanel.width,this.generalStorePanel.y));
         this._panelList.push(this.foodCenterPanel);
         this._panelActivationButton.push(this.btnFood);
         this._hidePanelPosition.push(new Point(-this.foodCenterPanel.width,this.foodCenterPanel.y));
         this._panelList.push(this.innPanel);
         this._panelActivationButton.push(this.btnInn);
         this._hidePanelPosition.push(new Point(-this.innPanel.width,this.innPanel.y));
         this._panelList.push(this.entertainmentPanel);
         this._panelActivationButton.push(this.btnEntertainment);
         this._hidePanelPosition.push(new Point(-this.entertainmentPanel.width,this.entertainmentPanel.y));
         this._panelList.push(this.facilityPanel);
         this._panelActivationButton.push(this.btnFacility);
         this._hidePanelPosition.push(new Point(-this.facilityPanel.width,this.facilityPanel.y));
         this._panelList.push(this.staffPanel);
         this._panelActivationButton.push(this.btnStaff);
         this._hidePanelPosition.push(new Point(-this.staffPanel.width,this.staffPanel.y));
         this._panelList.push(this.extraUpgradePanel);
         this._panelActivationButton.push(this.btnExtra);
         this._hidePanelPosition.push(new Point(this.btnExtra.x,this.btnExtra.y));
         this._panelList.push(this.statisticPanel);
         this._panelActivationButton.push(this.btnReport);
         this._hidePanelPosition.push(new Point(this.btnReport.x,this.btnReport.y));
         this._panelList.push(this.detailVisitorInfo);
         this._panelActivationButton.push(this.btnVisitorDetail);
         this._hidePanelPosition.push(new Point(this.detailVisitorInfo.x,-this.detailVisitorInfo.height / 2));
         this._panelList.push(this.detailStaffInfo);
         this._panelActivationButton.push(this.btnStaffDetail);
         this._hidePanelPosition.push(new Point(this.detailStaffInfo.x,-this.detailStaffInfo.height / 2));
         this._panelList.push(this.detailBuildingInfo);
         this._panelActivationButton.push(this.btnBuildingDetail);
         this._hidePanelPosition.push(new Point(this.detailStaffInfo.x,-this.detailStaffInfo.height / 2));
         this._defaultPanelPosition = new Array();
         var _loc1_:* = 0;
         while(_loc1_ < this._panelList.length)
         {
            this._defaultPanelPosition.push(new Point(this._panelList[_loc1_].x,this._panelList[_loc1_].y));
            if(_loc1_ in this._hidePanelPosition)
            {
               this._panelList[_loc1_].x = this._hidePanelPosition[_loc1_].x;
               this._panelList[_loc1_].y = this._hidePanelPosition[_loc1_].y;
            }
            _loc3_ = this._resizePanel.indexOf(this._panelList[_loc1_]);
            if(_loc3_ in this._hideSize)
            {
               this._panelList[_loc1_].width = this._hideSize[_loc3_].w;
               this._panelList[_loc1_].height = this._hideSize[_loc3_].h;
               this._panelList[_loc1_].alpha = 0;
            }
            this._panelList[_loc1_].parent.removeChild(this._panelList[_loc1_]);
            this.initButtonGroupPanel(this._panelList[_loc1_]);
            this.disableAllButtonFromPanel(this._panelList[_loc1_]);
            _loc1_++;
         }
         this.hirePanel.parent.removeChild(this.hirePanel);
         this.followUsPanel.parent.removeChild(this.followUsPanel);
         this._revealedPanel = null;
         this.shownInfo = null;
         this.infoPosition = new Point(350,250 - 150);
         this.infoToBuild.parent.removeChild(this.infoToBuild);
         this.infoToHire.parent.removeChild(this.infoToHire);
         this.cover = new Sprite();
         this.cover.graphics.clear();
         this.cover.graphics.beginFill(0,0.4);
         this.cover.graphics.drawRect(0,0,700,500);
         this.cover.graphics.endFill();
         this.minimapPosition = new Point(this.minimapPanel.x,this.minimapPanel.y);
         this.minimapPanel.parent.removeChild(this.minimapPanel);
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.letterSpacing = 0.5;
         this.goldInfo.defaultTextFormat = _loc2_;
         this.notificationList = new Array();
         this.noticeContainer = new MovieClip();
         this.noticeContainer.mouseEnabled = false;
         this.noticeContainer.mouseChildren = false;
         this.noticeBody = new MovieClip();
         this.noticeBody.mouseEnabled = false;
         this.noticeBody.mouseChildren = false;
         this.noticeContainer.addChild(this.noticeBody);
         this.noticeContainer.addChild(this.notificationMask);
         this.noticeBody.mask = this.notificationMask;
         addChild(this.noticeContainer);
         this.chatLogPosition = new Point(this.chatLogPanel.x,this.chatLogPanel.y);
         this.chatLogPanel.parent.removeChild(this.chatLogPanel);
         this._currentNumberVisitor = 0;
         this._currentNumberStaff = 0;
         this._currentNumberBuilding = 0;
         this.tutorialPanel.parent.removeChild(this.tutorialPanel);
         this.helpPage.visible = false;
         this.helpPage.mouseEnabled = false;
         this.helpPage.mouseChildren = false;
         this.hackedMessage.visible = false;
         this.__setProp_btnHint_UIingame_Layer1_0();
         this.__setProp_btnSelect_UIingame_Layer1_0();
         this.__setProp_btnDrag_UIingame_Layer1_0();
         this.__setProp_btnBooth_UIingame_Layer1_0();
         this.__setProp_btnFood_UIingame_Layer1_0();
         this.__setProp_btnInn_UIingame_Layer1_0();
         this.__setProp_btnEntertainment_UIingame_Layer1_0();
         this.__setProp_btnFacility_UIingame_Layer1_0();
         this.__setProp_btnStaff_UIingame_Layer1_0();
         this.__setProp_btnExtra_UIingame_Layer1_0();
         this.__setProp_btnReport_UIingame_Layer1_0();
      }
      
      function initPanelIconList() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this._panelIconList = new Array();
         this._panelToBuildButton = new Array();
         var _loc1_:* = 0;
         while(_loc1_ < this._panelToBuild.length)
         {
            _loc2_ = new Array();
            _loc3_ = 0;
            while(this._panelToBuild[_loc1_].getChildByName("btnPanel" + _loc3_))
            {
               _loc2_.push(this._panelToBuild[_loc1_].getChildByName("btnPanel" + _loc3_));
               _loc3_++;
            }
            this._panelToBuildButton.push(_loc2_);
            this._panelIconList.push(new Array());
            _loc1_++;
         }
      }
      
      function initButtonGroupPanel(param1:*) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = new Array();
         var _loc3_:* = 0;
         while(param1.getChildByName("btnPanel" + _loc3_))
         {
            if((_loc4_ = param1.getChildByName("btnPanel" + _loc3_)) is ToggleButton)
            {
               _loc2_.push(_loc4_);
               addListenerOf(_loc4_,MouseEvent.CLICK,this.playButtonSound);
            }
            _loc3_++;
         }
         this._buttonGroup.push(_loc2_);
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,ToggleButtonEvent.ACTIVATE,this.anyToggleButtonActivate);
         this._mainButtonIcon = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._mainButtonList.length)
         {
            this._mainButtonIcon.push(this._mainButtonList[_loc2_].icon);
            addListenerOf(this._mainButtonList[_loc2_],ToggleButtonEvent.DEACTIVATE,this.mainButtonDeactivate);
            addListenerOf(this._mainButtonList[_loc2_],MouseEvent.ROLL_OVER,this.mainButtonOnOver);
            addListenerOf(this._mainButtonList[_loc2_],MouseEvent.CLICK,this.playButtonSound);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._speedButtonList.length)
         {
            addListenerOf(this._speedButtonList[_loc2_],ToggleButtonEvent.ACTIVATE,this.speedButtonActivate);
            addListenerOf(this._speedButtonList[_loc2_],ToggleButtonEvent.FORCE_DEACTIVATE,this.speedButtonDeactivate);
            addListenerOf(this._speedButtonList[_loc2_],MouseEvent.CLICK,this.playButtonSound);
            _loc2_++;
         }
         addListenerOf(this.btnPause,MouseEvent.CLICK,this.togglePause);
         _loc2_ = 0;
         while(_loc2_ < this._detailButtonList.length)
         {
            addListenerOf(this._detailButtonList[_loc2_],ToggleButtonEvent.ACTIVATE,this.detailButtonActivate);
            addListenerOf(this._detailButtonList[_loc2_],MouseEvent.CLICK,this.playButtonSound);
            _loc2_++;
         }
         addListenerOf(this.btnMiniMap,MouseEvent.CLICK,this.btnMiniMapOnClick);
         addListenerOf(this.btnFollowUs,MouseEvent.CLICK,this.btnFollowUsOnClick);
         addListenerOf(this.btnHelp,MouseEvent.CLICK,this.btnHelpOnClick);
         this.initMainButton();
         this.initDetailButton();
         this.initSoundPanel();
         this.extraUpgradeCheck();
         this.btnSelect.isActive = true;
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.gameUpdate);
         addListenerOf(stage,MouseEvent.MOUSE_DOWN,this.onMouseDownEvent);
         addListenerOf(stage,CommandEvent.BEGIN_BUILD,this.enterBuildProgress);
         addListenerOf(stage,CommandEvent.CANCEL_BUILD,this.cancelBuildProgress);
         addListenerOf(stage,CommandEvent.BEGIN_DESTROY,this.startToDestory);
         addListenerOf(stage,CommandEvent.BEGIN_UPGRADE,this.startToUpgrade);
         addListenerOf(stage,GameEvent.FINISH_BUILD_PROGRESS,this.finishBuildProgress);
         addListenerOf(stage,GameEvent.UPDATE_BUDGET,this.budgetIsUpdated);
         addListenerOf(stage,CommandEvent.BEGIN_PROMOTE,this.startToPromote);
         addListenerOf(stage,CommandEvent.BEGIN_FIRE,this.startToFire);
         addListenerOf(stage,CommandEvent.DECLINE_HIRE,this.declineStaff);
         addListenerOf(this,GameEvent.NOTIFICATION_END,this.vanishNotification);
         addListenerOf(stage,GameEvent.UNLOCK_NEW_BUILDING,this.whenNewBuildingUnlocked);
         addListenerOf(stage,GameEvent.UNLOCK_NEW_UPGRADE,this.whenNewUpgradeUnlocked);
         addListenerOf(this.hirePanel.btnClose,MouseEvent.CLICK,this.hirePanelDitutup);
         addListenerOf(this.btnLogHistory,MouseEvent.CLICK,this.toggleShownChatLog);
         addListenerOf(this.btnGamesfree,MouseEvent.CLICK,this.linkToGamesfree);
         addListenerOf(this.chatLogPanel.btnClose,MouseEvent.CLICK,this.onCloseChatLog);
         addListenerOf(this.followUsPanel.btnClose,MouseEvent.CLICK,this.onCloseFollowUs);
         addListenerOf(this.soundPanel,SliderBarEvent.CHANGE_POSITION,this.audioUpdate);
         addListenerOf(this.soundPanel.muteBGM,MouseEvent.CLICK,this.muteUpdate);
         addListenerOf(this.soundPanel.muteSFX,MouseEvent.CLICK,this.muteUpdate);
         addListenerOf(this.btnSetting,MouseEvent.CLICK,this.btnSettingOnClick);
         addListenerOf(this.btnAchievement,MouseEvent.CLICK,this.btnAchievementOnClick);
         addListenerOf(this.btnManual,MouseEvent.CLICK,this.btnManualOnClick);
         this.initPanel();
         this.updateButtonVisitorDetail();
         this.updateButtonStaffDetail();
         this.updateButtonBuildingDetail();
         var _loc3_:* = this._main.world.popularity;
         if("popularity" in this._main.history)
         {
            _loc3_ = Math.max(this._main.history["popularity"],this._main.world.popularity);
         }
         if(_loc3_ < 10)
         {
            addListenerOf(stage,GameEvent.UPDATE_POPULARITY,this.whenPopularityUpdated);
         }
      }
      
      function linkToGamesfree(param1:Event) : void
      {
         var _loc2_:* = root;
         _loc2_.linkToGamesfree();
      }
      
      function whenPopularityUpdated(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = this._main.world.popularity;
         if("popularity" in this._main.history)
         {
            _loc2_ = Math.max(this._main.history["popularity"],this._main.world.popularity);
         }
         if(_loc2_ >= 10)
         {
            _loc3_ = 0;
            if("likeLG" in this._main.history && this._main.history["likeLG"] == 1)
            {
               this._main.history["likeLG"] = 2;
               _loc3_ += 5000;
            }
            if("likeGamesfree" in this._main.history && this._main.history["likeGamesfree"] == 1)
            {
               this._main.history["likeGamesfree"] = 2;
               _loc3_ += 5000;
            }
            if(_loc3_ > 0)
            {
               this._main.cashReward(_loc3_);
            }
            removeListenerOf(stage,GameEvent.UPDATE_POPULARITY,this.whenPopularityUpdated);
         }
      }
      
      function playButtonSound(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Select,1,0,24));
         }
      }
      
      function initSoundPanel() : void
      {
         this.soundPanel.muteBGM.buttonMode = true;
         this.soundPanel.muteSFX.buttonMode = true;
         this.soundPanel.muteBGM.alpha = !!this._main.mainProgram.bgmMute ? 1 : 0;
         this.soundPanel.muteSFX.alpha = !!this._main.mainProgram.sfxMute ? 1 : 0;
         this.soundPanel.bgmSlider.setPosition(this._main.bgmVolume);
         this.soundPanel.sfxSlider.setPosition(this._main.sfxVolume);
      }
      
      function extraUpgradeCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this._main.unlockedUpgrade.length > 0)
         {
            _loc1_ = this._mainButtonList.indexOf(this.btnExtra);
            if(_loc1_ in this._mainButtonIcon)
            {
               this.btnExtra.icon = this._mainButtonIcon[_loc1_];
            }
            else
            {
               this.btnExtra.icon = "";
            }
            this.btnExtra.enabled = true;
         }
         else
         {
            this.btnExtra.icon = "locked";
            this.btnExtra.enabled = false;
         }
         if(this._main.newUnlockedUpgrade.length > 0)
         {
            _loc2_ = new UI_SomethingNewClip();
            _loc2_.x = this.btnExtra.x + this.btnExtra.width / 2 - 5;
            _loc2_.y = this.btnExtra.y - this.btnExtra.height / 2 + 10;
            _loc2_.mouseEnabled = false;
            _loc2_.mouseChildren = false;
            _loc2_.name = "" + this.btnExtra.name + "_newIndicator";
            addChild(_loc2_);
         }
         else
         {
            _loc3_ = getChildByName(this.btnExtra.name + "_newIndicator");
            if(_loc3_ != null)
            {
               removeChild(_loc3_);
            }
         }
      }
      
      function audioUpdate(param1:SliderBarEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this.soundPanel.bgmSlider)
         {
            this._main.bgmVolume = _loc2_.getPosition();
            this._main.dispatchEvent(new AudioEvent(AudioEvent.CHANGE_BGM_MASTER_VOLUME));
         }
         if(_loc2_ == this.soundPanel.sfxSlider)
         {
            this._main.sfxVolume = _loc2_.getPosition();
            this._main.dispatchEvent(new AudioEvent(AudioEvent.CHANGE_SFX_MASTER_VOLUME));
         }
      }
      
      function muteUpdate(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_ == this.soundPanel.muteBGM)
         {
            this._main.mainProgram.bgmMute = !this._main.mainProgram.bgmMute;
            this.soundPanel.muteBGM.alpha = !!this._main.mainProgram.bgmMute ? 1 : 0;
         }
         if(_loc2_ == this.soundPanel.muteSFX)
         {
            this._main.mainProgram.sfxMute = !this._main.mainProgram.sfxMute;
            this.soundPanel.muteSFX.alpha = !!this._main.mainProgram.sfxMute ? 1 : 0;
         }
      }
      
      function btnSettingOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.MENU_SETTING));
      }
      
      function btnAchievementOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.SHOW_ACHIEVEMENT_PAGE));
      }
      
      function btnManualOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.SHOW_MANUAL));
      }
      
      function whenNewBuildingUnlocked(param1:GameEvent) : void
      {
         this.initPanel();
      }
      
      function whenNewUpgradeUnlocked(param1:GameEvent) : void
      {
         this.extraUpgradeCheck();
      }
      
      function mainButtonOnOver(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         this.removeLastInfo();
         var _loc3_:* = new InformationPopUp();
         var _loc4_:* = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
         _loc3_.x = _loc4_.x;
         _loc3_.y = _loc4_.y;
         var _loc5_:*;
         if((_loc5_ = this._mainButtonList.indexOf(_loc2_)) in this.MAIN_BUTTON_INFO)
         {
            if(_loc2_.icon == "locked")
            {
               _loc3_.text = this.MAIN_BUTTON_INFO[_loc5_] + "\n(locked)";
            }
            else
            {
               _loc3_.text = this.MAIN_BUTTON_INFO[_loc5_];
            }
         }
         this._infoPopUp = _loc3_;
         TweenLite.to(this._infoPopUp,0.6,{
            "onComplete":addChild,
            "onCompleteParams":[this._infoPopUp]
         });
         addListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.onMouseOut);
      }
      
      function buildingButtonOnOver(param1:MouseEvent) : void
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
         var _loc2_:* = param1.currentTarget;
         this.removeLastInfo();
         if(_loc2_.icon != "locked")
         {
            _loc3_ = new InformationPopUpBuilding();
            _loc4_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
            _loc3_.x = _loc4_.x;
            _loc3_.y = _loc4_.y;
            _loc5_ = BuildingData.returnIconTo(_loc2_.icon);
            _loc3_.header = _loc5_;
            _loc3_.price = BuildingData.getBuildingCost(_loc5_);
            _loc3_.text = BuildingData.getDescription(_loc5_);
            this._infoPopUp = _loc3_;
            TweenLite.to(this._infoPopUp,0.6,{
               "onComplete":addChild,
               "onCompleteParams":[this._infoPopUp]
            });
            addListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.onMouseOut);
         }
         else
         {
            _loc6_ = _loc2_.parent;
            if((_loc7_ = this._panelToBuild.indexOf(_loc6_)) in this._panelIconList && _loc7_ in this._panelToBuildButton)
            {
               _loc8_ = this._panelIconList[_loc7_];
               if((_loc10_ = (_loc9_ = this._panelToBuildButton[_loc7_]).indexOf(_loc2_)) in _loc8_)
               {
                  _loc3_ = new InformationPopUp();
                  _loc4_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
                  _loc3_.x = _loc4_.x;
                  _loc3_.y = _loc4_.y;
                  _loc5_ = BuildingData.returnIconTo(_loc8_[_loc10_]);
                  if((_loc11_ = BuildingData.getBuildingCost(_loc5_)) <= 15000)
                  {
                     _loc3_.text = _loc5_ + "\n(locked)";
                  }
                  else
                  {
                     _loc3_.text = "??????";
                  }
                  this._infoPopUp = _loc3_;
                  TweenLite.to(this._infoPopUp,0.6,{
                     "onComplete":addChild,
                     "onCompleteParams":[this._infoPopUp]
                  });
                  addListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.onMouseOut);
               }
            }
         }
      }
      
      function staffButtonOnOver(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         this.removeLastInfo();
         if(_loc2_.icon != "locked")
         {
            _loc3_ = new InformationPopUpBuilding();
            _loc4_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
            _loc3_.x = _loc4_.x;
            _loc3_.y = _loc4_.y;
            _loc5_ = (_loc5_ = (_loc2_.icon as String).substring("staff - ".length)).substr(0,1).toUpperCase() + _loc5_.substr(1).toLowerCase();
            _loc3_.header = _loc5_;
            _loc3_.price = 0;
            _loc3_.priceSign.visible = false;
            _loc3_.priceInfo.visible = false;
            _loc3_.text = HumanData.getStaffInfo(_loc5_);
            this._infoPopUp = _loc3_;
            TweenLite.to(this._infoPopUp,0.6,{
               "onComplete":addChild,
               "onCompleteParams":[this._infoPopUp]
            });
            addListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.onMouseOut);
         }
         else
         {
            _loc6_ = _loc2_.parent;
            if((_loc7_ = this._panelToBuild.indexOf(_loc6_)) in this._panelIconList && _loc7_ in this._panelToBuildButton)
            {
               _loc8_ = this._panelIconList[_loc7_];
               if((_loc10_ = (_loc9_ = this._panelToBuildButton[_loc7_]).indexOf(_loc2_)) in _loc8_)
               {
                  _loc3_ = new InformationPopUp();
                  _loc4_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
                  _loc3_.x = _loc4_.x;
                  _loc3_.y = _loc4_.y;
                  _loc5_ = (_loc5_ = (_loc8_[_loc10_] as String).substring("staff - ".length)).substr(0,1).toUpperCase() + _loc5_.substr(1).toLowerCase();
                  _loc3_.text = _loc5_ + "\n(locked)";
                  this._infoPopUp = _loc3_;
                  TweenLite.to(this._infoPopUp,0.6,{
                     "onComplete":addChild,
                     "onCompleteParams":[this._infoPopUp]
                  });
                  addListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.onMouseOut);
               }
            }
         }
      }
      
      function onMouseOut(param1:MouseEvent) : void
      {
         this.removeLastInfo();
      }
      
      function removeLastInfo() : void
      {
         if(this._infoPopUp != null)
         {
            TweenLite.killTweensOf(this._infoPopUp);
            if(getChildByName(this._infoPopUp.name))
            {
               removeChild(this._infoPopUp);
            }
         }
      }
      
      public function loadCondition(param1:*) : void
      {
         this.statisticPanel.autoShowCheckBox.isActive = param1.autoShowStatistic;
         this.extraUpgradePanel.autoClose.isActive = param1.autoCloseUpgrade;
      }
      
      public function saveCondition(param1:*) : void
      {
         param1.autoShowStatistic = this.statisticPanel.autoShowCheckBox.isActive;
         param1.autoCloseUpgrade = this.extraUpgradePanel.autoClose.isActive;
      }
      
      public function setNumberVisitor(param1:int) : void
      {
         this._currentNumberVisitor = param1;
         this.updateButtonVisitorDetail();
      }
      
      public function setNumberStaff(param1:int) : void
      {
         this._currentNumberStaff = param1;
         this.updateButtonStaffDetail();
         this.updatePanelBuildingAmount();
      }
      
      public function setNumberBuilding(param1:int) : void
      {
         this._currentNumberBuilding = param1;
         this.updateButtonBuildingDetail();
         this.updatePanelBuildingAmount();
      }
      
      function updateButtonVisitorDetail() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:* = this.btnVisitorDetail.getChildAt(0);
         if(_loc1_ is SimpleButton)
         {
            _loc2_ = _loc1_.upState;
            _loc3_ = _loc1_.overState;
            _loc4_ = _loc1_.downState;
            _loc2_.toShow.totalNumber.text = "" + this._currentNumberVisitor + "";
            _loc3_.toShow.totalNumber.text = "" + this._currentNumberVisitor + "";
            _loc4_.toShow.totalNumber.text = "" + this._currentNumberVisitor + "";
         }
      }
      
      function updateButtonStaffDetail() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:* = this.btnStaffDetail.getChildAt(0);
         if(_loc1_ is SimpleButton)
         {
            _loc2_ = _loc1_.upState;
            _loc3_ = _loc1_.overState;
            _loc4_ = _loc1_.downState;
            _loc2_.toShow.totalNumber.text = "" + this._currentNumberStaff + "";
            _loc3_.toShow.totalNumber.text = "" + this._currentNumberStaff + "";
            _loc4_.toShow.totalNumber.text = "" + this._currentNumberStaff + "";
         }
      }
      
      function updateButtonBuildingDetail() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:* = this.btnBuildingDetail.getChildAt(0);
         if(_loc1_ is SimpleButton)
         {
            _loc2_ = _loc1_.upState;
            _loc3_ = _loc1_.overState;
            _loc4_ = _loc1_.downState;
            _loc2_.toShow.totalNumber.text = "" + this._currentNumberBuilding + "";
            _loc3_.toShow.totalNumber.text = "" + this._currentNumberBuilding + "";
            _loc4_.toShow.totalNumber.text = "" + this._currentNumberBuilding + "";
         }
      }
      
      function updatePanelBuildingAmount() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this._revealedPanel != null)
         {
            if(this._panelToBuild.indexOf(this._revealedPanel) >= 0)
            {
               _loc1_ = 0;
               while(this._revealedPanel.getChildByName("btnPanel" + _loc1_))
               {
                  _loc2_ = this._revealedPanel.getChildByName("btnPanel" + _loc1_);
                  _loc3_ = this._revealedPanel.getChildByName("amountPanel" + _loc1_);
                  if(_loc2_ is ToggleButton)
                  {
                     if(_loc2_.icon != "locked")
                     {
                        if(this._revealedPanel == this.staffPanel)
                        {
                           _loc4_ = (_loc2_.icon as String).substring("staff - ".length);
                           _loc5_ = this._main.mission.countStaff(_loc4_);
                           _loc3_.info.text = (_loc5_.toString().length > 1 ? "" : "0") + "" + _loc5_ + "";
                        }
                        else
                        {
                           _loc6_ = BuildingData.returnIconTo(_loc2_.icon);
                           if(_loc3_ != null)
                           {
                              _loc7_ = this._main.world.countBuildingByType(_loc6_);
                              _loc3_.info.text = (_loc7_.toString().length > 1 ? "" : "0") + "" + _loc7_ + "";
                           }
                        }
                     }
                  }
                  _loc1_++;
               }
            }
         }
      }
      
      function removeTarget(param1:*) : void
      {
         if(param1.stage != null)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      function hirePanelDitutup(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.hirePanel.stage != null)
         {
            _loc2_ = this.btnStaff;
            switch(this.hirePanel.jobdesk)
            {
               case "janitor":
                  _loc2_ = this.staffPanel.btnPanel0;
                  break;
               case "handyman":
                  _loc2_ = this.staffPanel.btnPanel1;
                  break;
               case "entertainer":
                  _loc2_ = this.staffPanel.btnPanel2;
                  break;
               case "guard":
                  _loc2_ = this.staffPanel.btnPanel3;
            }
            _loc3_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
            TweenLite.killTweensOf(this.hirePanel,true);
            TweenLite.to(this.hirePanel,0.4,{
               "x":_loc3_.x,
               "y":_loc3_.y,
               "width":_loc2_.width,
               "height":_loc2_.height,
               "alpha":0,
               "onComplete":this.removeTarget,
               "onCompleteParams":[this.hirePanel]
            });
            _loc2_.isActive = false;
         }
      }
      
      function panelOnClose(param1:CommandEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.stage != null)
         {
            _loc3_ = this._panelList.indexOf(_loc2_);
            if(_loc3_ in this._panelActivationButton)
            {
               if((_loc4_ = this._panelActivationButton[_loc3_]).isActive || _loc2_.stage != null)
               {
                  _loc4_.isActive = false;
                  this.btnSelect.isActive = true;
               }
            }
         }
      }
      
      function initPanel() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this._panelList.length)
         {
            this.initPanelButton(this._panelList[_loc1_]);
            addListenerOf(this._panelList[_loc1_],CommandEvent.PANEL_NEED_TO_CLOSE,this.panelOnClose);
            addListenerOf(this._panelList[_loc1_],Event.REMOVED_FROM_STAGE,this.panelOnDismiss);
            _loc1_++;
         }
      }
      
      function sortIconByUnlocked(param1:Array) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < param1.length - 1)
         {
            _loc3_ = _loc2_;
            while(_loc3_ < param1.length)
            {
               _loc4_ = BuildingData.returnIconTo(param1[_loc2_]);
               if((_loc5_ = this._main.unlockedBuilding.indexOf(_loc4_)) >= 0)
               {
                  break;
               }
               _loc6_ = BuildingData.returnIconTo(param1[_loc3_]);
               if((_loc7_ = this._main.unlockedBuilding.indexOf(_loc6_)) >= 0)
               {
                  _loc8_ = param1[_loc2_];
                  param1[_loc2_] = param1[_loc3_];
                  param1[_loc3_] = _loc8_;
                  break;
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      function sortIconStaffByUnlocked(param1:Array) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < param1.length - 1)
         {
            _loc3_ = _loc2_;
            while(_loc3_ < param1.length)
            {
               _loc4_ = (param1[_loc2_] as String).substring("staff - ".length);
               if((_loc5_ = this._main.unlockedStaff.indexOf(_loc4_)) >= 0)
               {
                  break;
               }
               _loc6_ = (param1[_loc3_] as String).substring("staff - ".length);
               if((_loc7_ = this._main.unlockedStaff.indexOf(_loc6_)) >= 0)
               {
                  _loc8_ = param1[_loc2_];
                  param1[_loc2_] = param1[_loc3_];
                  param1[_loc3_] = _loc8_;
                  break;
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      function initPanelButton(param1:*) : void
      {
         var _loc2_:Array = null;
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
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         switch(param1)
         {
            case this.generalStorePanel:
               _loc2_ = BuildingData.getIconListOf(BuildingData.GENERAL);
               break;
            case this.foodCenterPanel:
               _loc2_ = BuildingData.getIconListOf(BuildingData.FOOD);
               break;
            case this.innPanel:
               _loc2_ = BuildingData.getIconListOf(BuildingData.INN);
               break;
            case this.entertainmentPanel:
               _loc2_ = BuildingData.getIconListOf(BuildingData.ENTERTAINMENT);
               break;
            case this.facilityPanel:
               _loc2_ = BuildingData.getIconListOf(BuildingData.FACILITY);
               break;
            case this.staffPanel:
               _loc2_ = ["staff - janitor","staff - handyman","staff - entertainer","staff - guard"];
         }
         var _loc3_:* = this._panelToBuild.indexOf(param1);
         if(_loc3_ in this._panelIconList)
         {
            this._panelIconList[_loc3_] = _loc2_;
         }
         if(_loc2_ != null)
         {
            if(_loc2_.length > 0)
            {
               _loc4_ = 0;
               if(param1 == this.staffPanel)
               {
                  this.sortIconStaffByUnlocked(_loc2_);
               }
               else
               {
                  this.sortIconByUnlocked(_loc2_);
               }
               _loc5_ = false;
               _loc6_ = false;
               _loc7_ = 0;
               while(param1.getChildByName("btnPanel" + _loc7_))
               {
                  _loc9_ = param1.getChildByName("btnPanel" + _loc7_);
                  _loc10_ = param1.getChildByName("amountPanel" + _loc7_);
                  if(_loc9_ is ToggleButton)
                  {
                     if(param1 == this.staffPanel)
                     {
                        _loc11_ = (_loc2_[_loc4_] as String).substring("staff - ".length);
                        if(this._main.unlockedStaff.indexOf(_loc11_) < 0)
                        {
                           _loc9_.icon = "locked";
                           _loc9_.enabled = false;
                           if(_loc10_ != null)
                           {
                              _loc10_.info.text = "-";
                           }
                        }
                        else
                        {
                           _loc9_.icon = _loc2_[_loc4_];
                           if(!_loc5_)
                           {
                              _loc5_ = true;
                           }
                           _loc12_ = (_loc2_[_loc4_] as String).substring("staff - ".length);
                           _loc13_ = this._main.mission.countStaff(_loc12_);
                           _loc10_.info.text = (_loc13_.toString().length > 1 ? "" : "0") + "" + _loc13_ + "";
                        }
                     }
                     else
                     {
                        _loc14_ = BuildingData.returnIconTo(_loc2_[_loc4_]);
                        if(this.main.unlockedBuilding.indexOf(_loc14_) < 0)
                        {
                           _loc9_.icon = "locked";
                           _loc9_.enabled = false;
                           if(_loc10_ != null)
                           {
                              _loc10_.info.text = "-";
                           }
                        }
                        else
                        {
                           _loc9_.icon = _loc2_[_loc4_];
                           _loc9_.enabled = true;
                           if(!_loc5_)
                           {
                              _loc5_ = true;
                           }
                           if(this.main.newUnlockedBuilding.indexOf(_loc14_) < 0)
                           {
                              if((_loc16_ = (_loc15_ = _loc9_.parent).getChildByName("" + _loc9_.name + "new_Indicator")) != null)
                              {
                                 _loc15_.removeChild(_loc16_);
                              }
                           }
                           else
                           {
                              (_loc17_ = new UI_SomethingNewClip()).x = _loc9_.x + _loc9_.width / 2 - 5;
                              _loc17_.y = _loc9_.y - _loc9_.height / 2 + 10;
                              _loc17_.mouseEnabled = false;
                              _loc17_.mouseChildren = false;
                              _loc17_.name = "" + _loc9_.name + "_newIndicator";
                              _loc9_.parent.addChild(_loc17_);
                              if(!_loc6_)
                              {
                                 _loc6_ = true;
                              }
                           }
                           if(_loc10_ != null)
                           {
                              _loc18_ = this._main.world.countBuildingByType(_loc14_);
                              _loc10_.info.text = (_loc18_.toString().length > 1 ? "" : "0") + "" + _loc18_ + "";
                           }
                        }
                     }
                     _loc4_++;
                  }
                  if(param1 != this.staffPanel)
                  {
                     addListenerOf(_loc9_,ToggleButtonEvent.ACTIVATE,this.activateBuildMode);
                     addListenerOf(_loc9_,ToggleButtonEvent.DEACTIVATE,this.cancelBuildMode);
                     addListenerOf(_loc9_,ToggleButtonEvent.FORCE_DEACTIVATE,this.cancelBuildMode);
                     addListenerOf(_loc9_,MouseEvent.ROLL_OVER,this.buildingButtonOnOver);
                  }
                  else
                  {
                     addListenerOf(_loc9_,ToggleButtonEvent.ACTIVATE,this.revealHirePanel);
                     addListenerOf(_loc9_,ToggleButtonEvent.DEACTIVATE,this.dismissHirePanel);
                     addListenerOf(_loc9_,MouseEvent.ROLL_OVER,this.staffButtonOnOver);
                  }
                  _loc7_++;
               }
               if((_loc8_ = this._panelList.indexOf(param1)) in this._panelActivationButton)
               {
                  _loc19_ = this._panelActivationButton[_loc8_];
                  if(_loc5_)
                  {
                     if((_loc20_ = this._mainButtonList.indexOf(_loc19_)) in this._mainButtonIcon)
                     {
                        _loc19_.icon = this._mainButtonIcon[_loc20_];
                     }
                     else
                     {
                        _loc19_.icon = "";
                     }
                     _loc19_.enabled = true;
                  }
                  else
                  {
                     _loc19_.icon = "locked";
                     _loc19_.enabled = false;
                  }
                  if(_loc6_)
                  {
                     (_loc17_ = new UI_SomethingNewClip()).x = _loc19_.x + _loc19_.width / 2 - 5;
                     _loc17_.y = _loc19_.y - _loc19_.height / 2 + 10;
                     _loc17_.mouseEnabled = false;
                     _loc17_.mouseChildren = false;
                     _loc17_.name = "" + _loc19_.name + "_newIndicator";
                     addChild(_loc17_);
                  }
                  else if((_loc16_ = getChildByName("" + _loc19_.name + "new_Indicator")) != null)
                  {
                     removeChild(_loc16_);
                  }
               }
            }
         }
      }
      
      function activateBuildMode(param1:ToggleButtonEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = _loc2_.parent;
         var _loc4_:*;
         if((_loc4_ = _loc3_.getChildByName(_loc2_.name + "_newIndicator")) != null)
         {
            _loc3_.removeChild(_loc4_);
         }
         dispatchEvent(new CommandEvent(CommandEvent.BEGIN_BUILD,_loc2_));
      }
      
      function cancelBuildMode(param1:ToggleButtonEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         dispatchEvent(new CommandEvent(CommandEvent.CANCEL_BUILD,_loc2_));
      }
      
      function enterBuildProgress(param1:CommandEvent) : void
      {
         if(this.activatePanelButton != null)
         {
            this.activatePanelButton = null;
            removeListenerOf(this,MouseEvent.ROLL_OVER,this.onOverInBuildMode);
            removeListenerOf(this,MouseEvent.ROLL_OUT,this.onOutInBuildMode);
         }
         if(param1.tag is UIToggleButtonSector)
         {
            this.activatePanelButton = param1.tag;
            addListenerOf(this,MouseEvent.ROLL_OVER,this.onOverInBuildMode);
            addListenerOf(this,MouseEvent.ROLL_OUT,this.onOutInBuildMode);
         }
      }
      
      function btnMiniMapOnClick(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this.minimapPanel,true);
         if(getChildByName(this.minimapPanel.name))
         {
            TweenLite.to(this.minimapPanel,0.4,{
               "x":700 + this.minimapPanel.width / 2,
               "alpha":0,
               "onComplete":this.removeTarget,
               "onCompleteParams":[this.minimapPanel]
            });
         }
         else
         {
            addChildAt(this.minimapPanel,0);
            this.minimapPanel.x = 700 + this.minimapPanel.width / 2;
            this.minimapPanel.alpha = 0;
            TweenLite.to(this.minimapPanel,0.4,{
               "x":this.minimapPosition.x,
               "alpha":1
            });
         }
      }
      
      function btnHelpOnClick(param1:MouseEvent) : void
      {
         this.helpPage.visible = !this.helpPage.visible;
      }
      
      function btnFollowUsOnClick(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            TweenLite.killTweensOf(this.followUsPanel,true);
            if(getChildByName(this.followUsPanel.name))
            {
               TweenLite.to(this.followUsPanel,0.4,{
                  "x":this.btnFollowUs.x,
                  "y":this.btnFollowUs.y,
                  "width":this.btnFollowUs.width,
                  "height":this.btnFollowUs.height,
                  "alpha":0,
                  "onComplete":this.removeTarget,
                  "onCompleteParams":[this.followUsPanel]
               });
            }
            else
            {
               this.followUsPanel.x = 350;
               this.followUsPanel.y = 250;
               this.followUsPanel.scaleX = 1;
               this.followUsPanel.scaleY = 1;
               this.followUsPanel.alpha = 1;
               addChild(this.followUsPanel);
               TweenLite.from(this.followUsPanel,0.4,{
                  "x":this.btnFollowUs.x,
                  "y":this.btnFollowUs.y,
                  "width":this.btnFollowUs.width,
                  "height":this.btnFollowUs.height,
                  "alpha":0
               });
               setChildIndex(this.noticeContainer,numChildren - 1);
               this.closeChatLog();
               if(this._revealedPanel != null)
               {
                  _loc3_ = this._panelList.indexOf(this._revealedPanel);
                  if(_loc3_ in this._panelActivationButton)
                  {
                     if(this._panelActivationButton[_loc3_].isActive)
                     {
                        this._panelActivationButton[_loc3_].isActive = false;
                        this.btnSelect.isActive = true;
                     }
                  }
               }
            }
         }
      }
      
      function cancelBuildProgress(param1:CommandEvent) : void
      {
         if(this.activatePanelButton != null)
         {
            if(this.activatePanelButton == param1.tag || param1.tag == null)
            {
               this.activatePanelButton = null;
               removeListenerOf(this,MouseEvent.ROLL_OVER,this.onOverInBuildMode);
               removeListenerOf(this,MouseEvent.ROLL_OUT,this.onOutInBuildMode);
            }
         }
      }
      
      function finishBuildProgress(param1:GameEvent) : void
      {
         addListenerOf(this.btnSelect,ToggleButtonEvent.FORCE_ACTIVATE,this.anyToggleButtonActivate);
         this.btnSelect.isActive = true;
         removeListenerOf(this.btnSelect,ToggleButtonEvent.FORCE_ACTIVATE,this.anyToggleButtonActivate);
      }
      
      public function showToBuildInfo(param1:*) : void
      {
         var _loc2_:* = getChildIndex(this.noticeContainer);
         if(param1 is StaffHireProgress)
         {
            param1.infoToBuild = this.infoToHire;
            addChildAt(this.infoToHire,_loc2_);
         }
         else
         {
            param1.infoToBuild = this.infoToBuild;
            addChildAt(this.infoToBuild,_loc2_);
         }
      }
      
      function revealShownInfo() : void
      {
         if(this.shownInfo != null)
         {
            if(this._revealedPanel != null)
            {
               this._revealedPanel.dispatchEvent(new CommandEvent(CommandEvent.PANEL_NEED_TO_CLOSE));
            }
            this.shownInfo.x = this.infoPosition.x;
            this.shownInfo.y = this.infoPosition.y;
            addChild(this.shownInfo);
            this.closeChatLog();
            this.closeFollowUs();
            if(getChildByName(this.noticeContainer.name))
            {
               setChildIndex(this.noticeContainer,numChildren - 1);
            }
            addListenerOf(this.shownInfo,InfoDialogEvent.BEGIN_DRAG,this.infoDialogBeginDrag);
            addListenerOf(this.shownInfo,Event.REMOVED_FROM_STAGE,this.infoDialogRemoved);
         }
      }
      
      function deleteShownInfo() : void
      {
         if(this.shownInfo != null)
         {
            if(getChildByName(this.shownInfo.name))
            {
               removeChild(this.shownInfo);
               dispatchEvent(new GameEvent(GameEvent.LOST_HUMAN_FOCUS));
            }
         }
      }
      
      public function showBoothData(param1:*) : void
      {
         if(!this.btnDrag.isActive)
         {
            this.deleteShownInfo();
            if(param1 is FacilityRestRoom)
            {
               this.shownInfo = new UIRestroomInfo();
            }
            else if(param1.maxLevel > 1)
            {
               this.shownInfo = new UIBoothInfo();
            }
            else if(param1 is FacilityStairs)
            {
               this.shownInfo = new UIStairInfo();
            }
            else
            {
               this.shownInfo = new UIBoothInfoUnupgradeable();
            }
            this.shownInfo.relation = param1;
            this.revealShownInfo();
         }
      }
      
      public function showElevatorData(param1:*) : void
      {
         if(!this.btnDrag.isActive)
         {
            this.deleteShownInfo();
            this.shownInfo = new UIElevatorInfo();
            this.shownInfo.relation = param1;
            this.revealShownInfo();
         }
      }
      
      public function showHalteData(param1:*) : void
      {
         if(!this.btnDrag.isActive)
         {
            this.deleteShownInfo();
            this.shownInfo = new UI_HalteInfo();
            this.shownInfo.relation = param1;
            this.revealShownInfo();
         }
      }
      
      public function showHumanData(param1:*) : Boolean
      {
         var _loc2_:* = false;
         if(!this.btnDrag.isActive)
         {
            this.deleteShownInfo();
            if(param1 is Staff)
            {
               this.shownInfo = new UIStaffInfo();
               this.shownInfo.relation = param1;
               this.revealShownInfo();
               _loc2_ = true;
            }
            else if(param1 is Visitor)
            {
               this.shownInfo = new UIVisitorInfo();
               this.shownInfo.relation = param1;
               this.revealShownInfo();
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      public function autoShowStatistic() : void
      {
         if(this.statisticPanel.autoShowCheckBox.isActive)
         {
            if(!getChildByName(this.statisticPanel.name))
            {
               this.statisticPanel.x = 350;
               this.statisticPanel.y = 250;
               this.statisticPanel.scaleX = 0;
               this.statisticPanel.scaleY = 0;
               this.statisticPanel.alpha = 0;
               this.statisticPanel.autoSizeTimer = 8 * 24;
               this.addChild(this.statisticPanel);
               TweenLite.to(this.statisticPanel,0.5,{
                  "scaleX":1,
                  "scaleY":1,
                  "alpha":1
               });
               setChildIndex(this.noticeContainer,numChildren - 1);
            }
         }
      }
      
      function infoDialogRemoved(param1:Event) : void
      {
         this.shownInfo = null;
         var _loc2_:* = param1.currentTarget;
         removeListenerOf(_loc2_,InfoDialogEvent.BEGIN_DRAG,this.infoDialogBeginDrag);
         removeListenerOf(_loc2_,Event.REMOVED_FROM_STAGE,this.infoDialogRemoved);
      }
      
      function infoDialogBeginDrag(param1:InfoDialogEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         addListenerOf(_loc2_,InfoDialogEvent.END_DRAG,this.infoDialogEndDrag);
      }
      
      function infoDialogEndDrag(param1:InfoDialogEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         this.infoPosition.x = _loc2_.x;
         this.infoPosition.y = _loc2_.y;
         removeListenerOf(_loc2_,InfoDialogEvent.END_DRAG,this.infoDialogEndDrag);
      }
      
      function startToDestory(param1:CommandEvent) : void
      {
         var target:* = undefined;
         var confirmation:* = undefined;
         var onChoose:Function = null;
         var e:CommandEvent = param1;
         onChoose = function(param1:MessageDialogEvent):void
         {
            removeListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
            if(param1.choice == MessageDialogEvent.CHOICE_YES)
            {
               if(shownInfo != null)
               {
                  if(shownInfo.stage != null)
                  {
                     shownInfo.parent.removeChild(shownInfo);
                  }
               }
               target.dispatchEvent(new CommandEvent(CommandEvent.DESTROY_BUILD));
            }
            confirmation.parent.removeChild(confirmation);
            cover.parent.removeChild(cover);
         };
         target = e.target;
         confirmation = new UI_Confirmation();
         confirmation.toConfirm = "toDestroy";
         confirmation.x = 350;
         confirmation.y = 250;
         addChild(this.cover);
         addChild(confirmation);
         addListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
      }
      
      function startToUpgrade(param1:CommandEvent) : void
      {
         var _loc2_:* = param1.target;
         _loc2_.dispatchEvent(new CommandEvent(CommandEvent.UPGRADE_BUILD));
      }
      
      function startToPromote(param1:CommandEvent) : void
      {
         var _loc2_:* = param1.target;
         _loc2_.dispatchEvent(new CommandEvent(CommandEvent.PROMOTE_STAFF,param1.tag));
      }
      
      function startToFire(param1:CommandEvent) : void
      {
         var target:* = undefined;
         var confirmation:* = undefined;
         var onChoose:Function = null;
         var confirmationText:* = undefined;
         var serveranceCost:* = undefined;
         var e:CommandEvent = param1;
         onChoose = function(param1:MessageDialogEvent):void
         {
            removeListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
            if(param1.choice == MessageDialogEvent.CHOICE_YES)
            {
               if(shownInfo != null)
               {
                  if(target.world.main.isEnough(target.serverenceCost))
                  {
                     if(shownInfo.stage != null)
                     {
                        shownInfo.parent.removeChild(shownInfo);
                     }
                  }
               }
               target.dispatchEvent(new CommandEvent(CommandEvent.FIRE_STAFF));
            }
            confirmation.parent.removeChild(confirmation);
            cover.parent.removeChild(cover);
         };
         target = e.target;
         confirmation = new UI_Confirmation();
         confirmation.toConfirm = "toFire";
         confirmation.x = 350;
         confirmation.y = 250;
         if(confirmation.noteText != null)
         {
            confirmationText = confirmation.noteText.text;
            serveranceCost = target.serverenceCost;
            confirmationText = confirmationText.replace(/&cost/g,"<font color=\'#" + int(ColorCode.MINUS_CASH).toString(16) + "\'>" + Utility.numberToMoney(serveranceCost) + " G</font>");
            confirmation.noteText.htmlText = confirmationText;
         }
         addChild(this.cover);
         addChild(confirmation);
         addListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
      }
      
      function declineStaff(param1:CommandEvent) : void
      {
         var toDecline:* = undefined;
         var confirmation:* = undefined;
         var onChoose:Function = null;
         var e:CommandEvent = param1;
         onChoose = function(param1:MessageDialogEvent):void
         {
            removeListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
            if(param1.choice == MessageDialogEvent.CHOICE_YES)
            {
               if(shownInfo != null)
               {
                  if(shownInfo.stage != null)
                  {
                     shownInfo.parent.removeChild(shownInfo);
                  }
               }
               dispatchEvent(new CommandEvent(CommandEvent.DECLINE_STAFF,toDecline));
            }
            confirmation.parent.removeChild(confirmation);
            cover.parent.removeChild(cover);
         };
         toDecline = e.tag;
         confirmation = new UI_Confirmation();
         confirmation.toConfirm = "toDecline";
         confirmation.x = 350;
         confirmation.y = 250;
         addChild(this.cover);
         addChild(confirmation);
         addListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
      }
      
      function onOverInBuildMode(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this._revealedPanel);
         var _loc2_:* = this._panelList.indexOf(this._revealedPanel);
         if(_loc2_ in this._defaultPanelPosition)
         {
            TweenLite.to(this._revealedPanel,0.5,{"x":this._defaultPanelPosition[_loc2_].x});
         }
      }
      
      function onOutInBuildMode(param1:MouseEvent) : void
      {
         TweenLite.killTweensOf(this._revealedPanel);
         var _loc2_:* = this._panelList.indexOf(this._revealedPanel);
         if(_loc2_ in this._defaultPanelPosition)
         {
            TweenLite.to(this._revealedPanel,0.5,{"x":this._defaultPanelPosition[_loc2_].x - (this._revealedPanel.width - 15)});
         }
      }
      
      function panelOnDismiss(param1:Event) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(this._revealedPanel == _loc2_)
         {
            this._revealedPanel = null;
         }
         var _loc3_:* = 0;
         while(_loc2_.getChildByName("btnPanel" + _loc3_))
         {
            if((_loc4_ = _loc2_.getChildByName("btnPanel" + _loc3_)) is ToggleButton)
            {
               _loc4_.isActive = false;
            }
            _loc3_++;
         }
      }
      
      function anyToggleButtonActivate(param1:Event) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = param1.target;
         var _loc3_:* = 0;
         while(_loc3_ < this._buttonGroup.length)
         {
            if((_loc4_ = this._buttonGroup[_loc3_]).indexOf(_loc2_) >= 0)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  if(_loc4_[_loc5_] != _loc2_ && _loc4_[_loc5_].isActive)
                  {
                     _loc4_[_loc5_].isActive = false;
                  }
                  _loc5_++;
               }
            }
            _loc3_++;
         }
      }
      
      function mainButtonDeactivate(param1:Event) : void
      {
         var _loc2_:* = param1.currentTarget;
         this.btnSelect.isActive = true;
      }
      
      function detailButtonActivate(param1:Event) : void
      {
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = false;
         var _loc4_:* = 0;
         while(_loc4_ < this._mainButtonList.length)
         {
            if(this._mainButtonList[_loc4_].isActive)
            {
               if(this._panelGrouping.indexOf(this._mainButtonList[_loc4_]) >= 0)
               {
                  _loc3_ = true;
                  break;
               }
            }
            _loc4_++;
         }
         this.updateButtonVisitorDetail();
         if(_loc3_)
         {
            this.btnSelect.isActive = true;
         }
      }
      
      function togglePause(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(!_loc2_.isActive)
         {
            dispatchEvent(new CommandEvent(CommandEvent.SPEED_CHANGE,0));
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this._speedButtonList.length)
            {
               if(this._speedButtonList[_loc3_].isActive)
               {
                  dispatchEvent(new CommandEvent(CommandEvent.SPEED_CHANGE,_loc3_ + 1));
                  break;
               }
               _loc3_++;
            }
         }
      }
      
      function speedButtonActivate(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(!this.btnPause.isActive)
         {
            _loc2_ = param1.currentTarget;
            _loc2_.enabled = false;
            _loc3_ = this._speedButtonList.indexOf(_loc2_);
            dispatchEvent(new CommandEvent(CommandEvent.SPEED_CHANGE,_loc3_ + 1));
         }
      }
      
      function speedButtonDeactivate(param1:Event) : void
      {
         var _loc2_:* = param1.currentTarget;
         _loc2_.enabled = true;
      }
      
      function initMainButton() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._mainButtonList.length)
         {
            _loc2_ = this._mainButtonList[_loc1_];
            if(this._panelActivationButton.indexOf(_loc2_) >= 0)
            {
               addListenerOf(_loc2_,ToggleButtonEvent.ACTIVATE,this.revealPanel);
               addListenerOf(_loc2_,ToggleButtonEvent.FORCE_ACTIVATE,this.revealPanel);
               addListenerOf(_loc2_,ToggleButtonEvent.DEACTIVATE,this.dismissPanel);
               addListenerOf(_loc2_,ToggleButtonEvent.FORCE_DEACTIVATE,this.dismissPanel);
            }
            if(_loc2_ == this.btnStaff)
            {
               addListenerOf(_loc2_,ToggleButtonEvent.DEACTIVATE,this.dismissHirePanel);
               addListenerOf(_loc2_,ToggleButtonEvent.FORCE_DEACTIVATE,this.dismissHirePanel);
            }
            _loc1_++;
         }
      }
      
      function initDetailButton() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._detailButtonList.length)
         {
            _loc2_ = this._detailButtonList[_loc1_];
            if(this._panelActivationButton.indexOf(_loc2_) >= 0)
            {
               addListenerOf(_loc2_,ToggleButtonEvent.ACTIVATE,this.revealPanel);
               addListenerOf(_loc2_,ToggleButtonEvent.FORCE_ACTIVATE,this.revealPanel);
               addListenerOf(_loc2_,ToggleButtonEvent.DEACTIVATE,this.dismissPanel);
               addListenerOf(_loc2_,ToggleButtonEvent.FORCE_DEACTIVATE,this.dismissPanel);
            }
            _loc1_++;
         }
      }
      
      function closeChatLog() : void
      {
         TweenLite.killTweensOf(this.chatLogPanel,true);
         if(getChildByName(this.chatLogPanel.name))
         {
            TweenLite.to(this.chatLogPanel,0.4,{
               "y":500,
               "onComplete":this.removeTarget,
               "onCompleteParams":[this.chatLogPanel]
            });
         }
      }
      
      function closeFollowUs() : void
      {
         TweenLite.killTweensOf(this.followUsPanel,true);
         if(getChildByName(this.followUsPanel.name))
         {
            TweenLite.to(this.followUsPanel,0.4,{
               "x":this.btnFollowUs.x,
               "y":this.btnFollowUs.y,
               "width":this.btnFollowUs.width,
               "height":this.btnFollowUs.height,
               "alpha":0,
               "onComplete":this.removeTarget,
               "onCompleteParams":[this.followUsPanel]
            });
         }
      }
      
      function onCloseChatLog(param1:MouseEvent) : void
      {
         this.closeChatLog();
      }
      
      function onCloseFollowUs(param1:MouseEvent) : void
      {
         this.closeFollowUs();
      }
      
      function toggleShownChatLog(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         TweenLite.killTweensOf(this.chatLogPanel,true);
         if(getChildByName(this.chatLogPanel.name))
         {
            TweenLite.to(this.chatLogPanel,0.4,{
               "y":500,
               "onComplete":this.removeTarget,
               "onCompleteParams":[this.chatLogPanel]
            });
         }
         else
         {
            this.chatLogPanel.y = 500;
            addChild(this.chatLogPanel);
            TweenLite.to(this.chatLogPanel,0.4,{"y":this.chatLogPosition.y});
            setChildIndex(this.noticeContainer,numChildren - 1);
            this.closeFollowUs();
            if(this._revealedPanel != null)
            {
               _loc2_ = this._panelList.indexOf(this._revealedPanel);
               if(_loc2_ in this._panelActivationButton)
               {
                  if(this._panelActivationButton[_loc2_].isActive)
                  {
                     this._panelActivationButton[_loc2_].isActive = false;
                     this.btnSelect.isActive = true;
                  }
               }
            }
         }
      }
      
      function revealHirePanel(param1:ToggleButtonEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         TweenLite.killTweensOf(this.hirePanel,true);
         var _loc3_:* = (_loc2_.icon as String).substring("staff - ".length);
         this.hirePanel.jobdesk = _loc3_;
         if(getChildByName(this.hirePanel.name) == null)
         {
            _loc4_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
            this.hirePanel.x = _loc4_.x;
            this.hirePanel.y = _loc4_.y;
            this.hirePanel.width = _loc2_.width;
            this.hirePanel.height = _loc2_.height;
            this.hirePanel.alpha = 0;
            addChild(this.hirePanel);
            this.closeChatLog();
            this.closeFollowUs();
            setChildIndex(this.noticeContainer,numChildren - 1);
            TweenLite.to(this.hirePanel,0.4,{
               "x":350,
               "y":250,
               "scaleX":1,
               "scaleY":1,
               "alpha":1
            });
         }
         dispatchEvent(new CommandEvent(CommandEvent.SHOW_HIRE_PANEL,this.hirePanel));
      }
      
      function revealPanel(param1:ToggleButtonEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this._panelActivationButton.indexOf(_loc2_);
         if(_loc3_ in this._panelList)
         {
            if(this.shownInfo != null)
            {
               if(getChildByName(this.shownInfo.name))
               {
                  removeChild(this.shownInfo);
               }
            }
            _loc5_ = this._panelList[_loc3_];
            TweenLite.killTweensOf(_loc5_,true);
            _loc6_ = 0;
            while(_loc5_.getChildByName("btnPanel" + _loc6_))
            {
               if((_loc8_ = _loc5_.getChildByName("btnPanel" + _loc6_)) is ToggleButton)
               {
                  if(_loc8_.icon != "locked")
                  {
                     _loc9_ = BuildingData.returnIconTo(_loc8_.icon);
                     if((_loc10_ = this._main.newUnlockedBuilding.indexOf(_loc9_)) in this._main.newUnlockedBuilding)
                     {
                        this._main.newUnlockedBuilding.splice(_loc10_,1);
                     }
                  }
               }
               _loc6_++;
            }
            _loc7_ = !getChildByName(_loc5_.name);
            if(_loc5_ is UI_Statistic)
            {
               _loc5_.autoSizeTimer = -1;
            }
            if(_loc3_ in this._defaultPanelPosition)
            {
               if(this._panelToBuild.indexOf(_loc5_) >= 0)
               {
                  if(this._revealedPanel == null)
                  {
                     this.addChildAt(_loc5_,0);
                  }
                  else if(this._panelToBuild.indexOf(this._revealedPanel) >= 0)
                  {
                     if(getChildByName(this._revealedPanel.name))
                     {
                        _loc11_ = getChildIndex(this._revealedPanel);
                        this.addChildAt(_loc5_,_loc11_ + 1);
                     }
                     else
                     {
                        this.addChildAt(_loc5_,0);
                     }
                  }
                  else
                  {
                     this.addChildAt(_loc5_,0);
                  }
                  if(getChildByName(this.minimapPanel.name))
                  {
                     setChildIndex(this.minimapPanel,0);
                  }
                  this.closeChatLog();
                  this.closeFollowUs();
               }
               else
               {
                  this.addChild(_loc5_);
                  this.closeChatLog();
                  this.closeFollowUs();
                  setChildIndex(this.noticeContainer,numChildren - 1);
               }
               this._revealedPanel = _loc5_;
               this.updatePanelBuildingAmount();
               if(_loc7_)
               {
                  if(this._resizePanel.indexOf(_loc5_) < 0)
                  {
                     TweenLite.to(_loc5_,0.5,{
                        "x":this._defaultPanelPosition[_loc3_].x,
                        "y":this._defaultPanelPosition[_loc3_].y,
                        "ease":Back.easeOut,
                        "onComplete":this.setActivePanel,
                        "onCompleteParams":[_loc5_]
                     });
                  }
                  else
                  {
                     if(_loc3_ in this._hidePanelPosition)
                     {
                        _loc5_.x = this._hidePanelPosition[_loc3_].x;
                        _loc5_.y = this._hidePanelPosition[_loc3_].y;
                        if(_loc3_ in this._hideSize)
                        {
                           _loc5_.width = this._hideSize[_loc3_].w;
                           _loc5_.height = this._hideSize[_loc3_].h;
                        }
                     }
                     TweenLite.to(_loc5_,0.3,{
                        "x":this._defaultPanelPosition[_loc3_].x,
                        "y":this._defaultPanelPosition[_loc3_].y,
                        "scaleX":1,
                        "scaleY":1,
                        "alpha":1,
                        "ease":Linear.easeNone,
                        "onComplete":this.setActivePanel,
                        "onCompleteParams":[_loc5_]
                     });
                  }
               }
            }
         }
         if(_loc2_ == this.btnVisitorDetail)
         {
            this.updateButtonVisitorDetail();
         }
         if(_loc2_ == this.btnStaffDetail)
         {
            this.updateButtonStaffDetail();
         }
         if(_loc2_ == this.btnBuildingDetail)
         {
            this.updateButtonBuildingDetail();
         }
         var _loc4_:*;
         if((_loc4_ = getChildByName(_loc2_.name + "_newIndicator")) != null)
         {
            if(_loc2_ != this.btnExtra)
            {
               removeChild(_loc4_);
            }
            else if(this._main.newUnlockedUpgrade.length == 0)
            {
               removeChild(_loc4_);
            }
         }
      }
      
      function setActivePanel(param1:*) : void
      {
         this.enableAllButtonFromPanel(param1);
      }
      
      function dismissHirePanel(param1:ToggleButtonEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         TweenLite.killTweensOf(this.hirePanel,true);
         if(this.hirePanel.stage != null)
         {
            _loc3_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
            TweenLite.to(this.hirePanel,0.4,{
               "x":_loc3_.x,
               "y":_loc3_.y,
               "width":_loc2_.width,
               "height":_loc2_.height,
               "alpha":0,
               "onComplete":this.removeTarget,
               "onCompleteParams":[this.hirePanel]
            });
            dispatchEvent(new CommandEvent(CommandEvent.CANCEL_BUILD));
         }
      }
      
      function dismissPanel(param1:ToggleButtonEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this._panelActivationButton.indexOf(_loc2_);
         if(_loc3_ in this._panelList)
         {
            _loc4_ = this._panelList[_loc3_];
            this.disableAllButtonFromPanel(_loc4_);
            dispatchEvent(new CommandEvent(CommandEvent.CANCEL_BUILD));
            TweenLite.killTweensOf(_loc4_,true);
            _loc5_ = 0;
            while(_loc4_.getChildByName("btnPanel" + _loc5_))
            {
               if((_loc6_ = _loc4_.getChildByName("btnPanel" + _loc5_)) is ToggleButton)
               {
                  if(_loc6_.icon != "locked")
                  {
                     _loc7_ = BuildingData.returnIconTo(_loc6_.icon);
                     if(this._main.newUnlockedBuilding.indexOf(_loc7_) < 0)
                     {
                        if((_loc9_ = (_loc8_ = _loc6_.parent).getChildByName(_loc6_.name + "_newIndicator")) != null)
                        {
                           _loc8_.removeChild(_loc9_);
                        }
                     }
                  }
               }
               _loc5_++;
            }
            if(_loc3_ in this._hidePanelPosition)
            {
               if(_loc4_.parent != null)
               {
                  if((_loc10_ = this._resizePanel.indexOf(_loc4_)) in this._hideSize)
                  {
                     TweenLite.to(_loc4_,0.3,{
                        "x":this._hidePanelPosition[_loc3_].x,
                        "y":this._hidePanelPosition[_loc3_].y,
                        "ease":Linear.easeNone,
                        "width":this._hideSize[_loc10_].w,
                        "height":this._hideSize[_loc10_].h,
                        "onComplete":this.removeTarget,
                        "alpha":0,
                        "onCompleteParams":[_loc4_]
                     });
                  }
                  else
                  {
                     TweenLite.to(_loc4_,0.5,{
                        "x":this._hidePanelPosition[_loc3_].x,
                        "y":this._hidePanelPosition[_loc3_].y,
                        "ease":Back.easeIn,
                        "onComplete":this.removeTarget,
                        "onCompleteParams":[_loc4_]
                     });
                  }
               }
            }
            else if(_loc4_.parent != null)
            {
               _loc4_.parent.removeChild(_loc4_);
            }
            if(_loc4_ is UI_InfoPanel)
            {
               _loc4_.onDismiss();
            }
         }
         if(_loc2_ == this.btnVisitorDetail)
         {
            this.updateButtonVisitorDetail();
         }
         if(_loc2_ == this.btnStaffDetail)
         {
            this.updateButtonStaffDetail();
         }
         if(_loc2_ == this.btnBuildingDetail)
         {
            this.updateButtonBuildingDetail();
         }
      }
      
      function enableAllButtonFromPanel(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = 0;
         while(param1.getChildByName("btnPanel" + _loc2_))
         {
            _loc3_ = param1.getChildByName("btnPanel" + _loc2_);
            if(_loc3_.icon != "locked")
            {
               _loc3_.enabled = true;
            }
            _loc2_++;
         }
      }
      
      function disableAllButtonFromPanel(param1:*) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = 0;
         while(param1.getChildByName("btnPanel" + _loc2_))
         {
            _loc3_ = param1.getChildByName("btnPanel" + _loc2_);
            _loc3_.enabled = false;
            _loc2_++;
         }
      }
      
      function gameUpdate(param1:GameEvent) : void
      {
         this.clock.hour = param1.tag.hour;
         this.clock.minute = param1.tag.minute;
      }
      
      function onMouseDownEvent(param1:MouseEvent) : void
      {
         if(!this.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            if(this.btnDrag.isActive)
            {
               dispatchEvent(new CommandEvent(CommandEvent.BEGIN_SCROLL));
            }
         }
      }
      
      public function updateSpeedButton(param1:Number) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this._speedButtonList.length)
         {
            this._speedButtonList[_loc2_].isActive = param1 == _loc2_ + 1;
            this._speedButtonList[_loc2_].enabled = !this._speedButtonList[_loc2_].isActive;
            _loc2_++;
         }
      }
      
      public function addNotification(param1:String) : void
      {
         var _loc2_:* = new Notification();
         _loc2_.text = param1;
         _loc2_.x = this.NOTIFICATION_X;
         _loc2_.y = this.NOTIFICATION_Y;
         this.noticeBody.addChild(_loc2_);
         addListenerOf(_loc2_,Event.REMOVED_FROM_STAGE,this.notificationRemoved);
         this.notificationList.unshift(_loc2_);
         TweenLite.from(_loc2_,0.5,{
            "y":500 - _loc2_.height,
            "ease":Back.easeOut,
            "onUpdate":this.correctNotificationPosition
         });
      }
      
      public function changePopularity(param1:Number) : void
      {
         var _loc2_:* = Math.round(param1 * 10);
         this.popularityValue.text = Math.floor(_loc2_ / 10) + "." + _loc2_ % 10 + "%";
      }
      
      function vanishNotification(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = this.notificationList.indexOf(_loc2_);
         if(_loc3_ in this.notificationList)
         {
            this.notificationList.splice(_loc3_,1);
         }
         TweenLite.to(_loc2_,0.3,{
            "x":700 + _loc2_.width,
            "onComplete":this.removeTarget,
            "onCompleteParams":[_loc2_]
         });
      }
      
      function correctNotificationPosition() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this.notificationList.length)
         {
            _loc2_ = this.notificationList[_loc1_];
            if(_loc1_ + 1 in this.notificationList)
            {
               _loc3_ = this.notificationList[_loc1_ + 1];
               if(_loc3_.y > _loc2_.y - _loc2_.height)
               {
                  _loc3_.y = _loc2_.y - _loc2_.height;
               }
            }
            _loc1_++;
         }
      }
      
      function notificationRemoved(param1:Event) : void
      {
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this.notificationList.indexOf(_loc2_);
         if(_loc3_ >= 0)
         {
            this.notificationList.splice(_loc3_,1);
         }
      }
      
      function budgetIsUpdated(param1:GameEvent) : void
      {
         var _loc2_:* = param1.tag;
         var _loc3_:* = Math.abs(this._shownBudget - _loc2_);
         var _loc4_:* = Math.min(_loc3_ * 0.01,1.8);
         TweenMax.to(this,_loc4_,{
            "shownBudget":_loc2_,
            "roundProps":["shownBudget"],
            "ease":Linear.easeNone
         });
      }
      
      public function set shownBudget(param1:int) : void
      {
         this._shownBudget = param1;
         if(this._shownBudget >= 0)
         {
            this.goldInfo.textColor = ColorCode.VALID_CASH;
         }
         else
         {
            this.goldInfo.textColor = ColorCode.MINUS_CASH;
         }
         this.goldInfo.text = Utility.numberToMoney(this._shownBudget) + " G";
      }
      
      public function get shownBudget() : int
      {
         return this._shownBudget;
      }
      
      public function set main(param1:Gameplay) : void
      {
         this._main = param1;
      }
      
      public function get main() : Gameplay
      {
         return this._main;
      }
      
      function __setProp_btnHint_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnHint["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnHint.enabled = true;
         this.btnHint.icon = "hint";
         this.btnHint.isActive = false;
         try
         {
            this.btnHint["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnSelect_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnSelect["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnSelect.enabled = true;
         this.btnSelect.icon = "select";
         this.btnSelect.isActive = false;
         try
         {
            this.btnSelect["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnDrag_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnDrag["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnDrag.enabled = true;
         this.btnDrag.icon = "drag";
         this.btnDrag.isActive = false;
         try
         {
            this.btnDrag["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnBooth_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnBooth["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnBooth.enabled = true;
         this.btnBooth.icon = "booth";
         this.btnBooth.isActive = false;
         try
         {
            this.btnBooth["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnFood_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnFood["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnFood.enabled = true;
         this.btnFood.icon = "food";
         this.btnFood.isActive = false;
         try
         {
            this.btnFood["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnInn_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnInn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnInn.enabled = true;
         this.btnInn.icon = "inn";
         this.btnInn.isActive = false;
         try
         {
            this.btnInn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnEntertainment_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnEntertainment["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnEntertainment.enabled = true;
         this.btnEntertainment.icon = "entertainment";
         this.btnEntertainment.isActive = false;
         try
         {
            this.btnEntertainment["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnFacility_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnFacility["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnFacility.enabled = true;
         this.btnFacility.icon = "facility";
         this.btnFacility.isActive = false;
         try
         {
            this.btnFacility["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnStaff_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnStaff["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnStaff.enabled = true;
         this.btnStaff.icon = "staff";
         this.btnStaff.isActive = false;
         try
         {
            this.btnStaff["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnExtra_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnExtra["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnExtra.enabled = true;
         this.btnExtra.icon = "extra";
         this.btnExtra.isActive = false;
         try
         {
            this.btnExtra["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnReport_UIingame_Layer1_0() : *
      {
         try
         {
            this.btnReport["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnReport.enabled = true;
         this.btnReport.icon = "report";
         this.btnReport.isActive = false;
         try
         {
            this.btnReport["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
