package Instance
{
   import Instance.constant.AchievementList;
   import Instance.constant.BGMData;
   import Instance.constant.BuildingData;
   import Instance.constant.ColorCode;
   import Instance.constant.HumanData;
   import Instance.constant.TipsList;
   import Instance.constant.UpgradeData;
   import Instance.events.AchievementEvent;
   import Instance.events.AudioEvent;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.MessageDialogEvent;
   import Instance.events.MissionEvent;
   import Instance.gameplay.Litter;
   import Instance.gameplay.Shopkeeper;
   import Instance.gameplay.SpecialVisitor;
   import Instance.gameplay.StaffEntertainer;
   import Instance.gameplay.StaffGuard;
   import Instance.gameplay.StaffHandyman;
   import Instance.gameplay.StaffJanitor;
   import Instance.gameplay.Thief;
   import Instance.gameplay.Visitor;
   import Instance.gameplay.Watchdog;
   import Instance.gameplay.Wizard;
   import Instance.gameplay.World;
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import Instance.property.AnimalPoop;
   import Instance.property.Booth;
   import Instance.property.BoothColloseum;
   import Instance.property.Building;
   import Instance.property.Elevator;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityRestRoom;
   import Instance.property.FacilityStairs;
   import Instance.property.FictionalBuilding;
   import Instance.property.HalteWagon;
   import Instance.property.HumanStat;
   import Instance.property.InsideRestroom;
   import Instance.property.Mission;
   import Instance.property.Statistic;
   import Instance.property.StatisticItem;
   import Instance.property.Tutorial;
   import Instance.property.Wagon;
   import Instance.sprite.Animation;
   import Instance.ui.InformationPopUpBuilding;
   import Instance.ui.UIManual;
   import Instance.ui.UI_Confirmation;
   import Instance.ui.UI_InGame;
   import Instance.ui.UI_Menu;
   import Instance.ui.UI_NotificationNewBuild;
   import Instance.ui.UI_Option;
   import Instance.ui.UIachievements;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.ui.Mouse;
   import greensock.TweenLite;
   import greensock.TweenMax;
   import greensock.easing.Linear;
   
   public class Gameplay extends SEMovieClip
   {
       
      
      const MAX_BUDGET = 999999999;
      
      const MIN_BUDGET = -999999999;
      
      const APPLICANT_DELAY = 2880.0;
      
      var _GUI:UI_InGame;
      
      var _world:World;
      
      var _gameHour:int;
      
      var _gameMinute:int;
      
      var _gameSpeed:Number;
      
      var _gameSpeedCtr:Number;
      
      var _minimap;
      
      var _staffList:Object;
      
      var _applicants:Array;
      
      var _chanceToGetApplicant:Number;
      
      var _minimalNewApplicant:int;
      
      var _countdownApplicant:int;
      
      var _budget:int;
      
      var _currentStatistic:Statistic;
      
      var _humanFocus;
      
      var _mission:Mission;
      
      var _tutorial:Tutorial;
      
      var tempObject;
      
      var currentTween;
      
      var notifObject;
      
      var lastNotification:String;
      
      var _menuSetting:UI_Menu;
      
      var _optionMenu:UI_Option;
      
      var _achievementPage:UIachievements;
      
      var _manualPage:UIManual;
      
      var _menuAppear:Boolean;
      
      var _blankCover:Sprite;
      
      var _chatLog:Array;
      
      var _unlockedBuilding:Array;
      
      var _newUnlockedBuilding:Array;
      
      var _unlockedUpgrade:Array;
      
      var _newUnlockedUpgrade:Array;
      
      var _unlockedStaff:Array;
      
      var _unlockedHint:Array;
      
      var _newUnlockedHint:Array;
      
      var _dayPassed:int;
      
      var _nextBGMToPlay;
      
      var _enablePlayBGM:Array;
      
      var _enableRainBGM:Array;
      
      var _bgmVolume:Number;
      
      var _sfxVolume:Number;
      
      var _nameID:String;
      
      var _slotIndex:int;
      
      var _loadGame:Boolean;
      
      var _history;
      
      var _achievement:Array;
      
      var _achievementUnlock:Array;
      
      var _achievementGainInfo:MovieClip;
      
      var _delayWhenRevealAchievement:int;
      
      var _delayToRevealAchievement:int;
      
      var _mainProgram:MainProgram;
      
      var _onStackSFX:Array;
      
      var _onStackSFXSource:Array;
      
      var _autoSaveIndicator;
      
      var _scrollHand;
      
      public function Gameplay()
      {
         super();
         this._gameHour = 9;
         this._gameMinute = 0;
         this._dayPassed = 1;
         this._loadGame = false;
         this._scrollHand = new scrollHand();
         this._scrollHand.mouseEnabled = false;
         this._scrollHand.mouseChildren = false;
         this._unlockedBuilding = new Array();
         this.initUnlockedBuilding();
         this._newUnlockedBuilding = new Array();
         this._unlockedUpgrade = new Array();
         this._newUnlockedUpgrade = new Array();
         this._unlockedHint = new Array();
         this._unlockedHint.push(TipsList.CODE_LIST[0]);
         this._newUnlockedHint = new Array();
         this._unlockedStaff = new Array();
         this._unlockedStaff.push("janitor");
         this._unlockedStaff.push("handyman");
         this._unlockedStaff.push("guard");
         this._chatLog = new Array();
         this._menuSetting = new UI_Menu();
         this._optionMenu = new UI_Option();
         this._optionMenu.main = this;
         this._menuAppear = false;
         this._blankCover = new Sprite();
         this._blankCover.graphics.clear();
         this._blankCover.graphics.beginFill(0,0.3);
         this._blankCover.graphics.drawRect(0,0,700,500);
         this._blankCover.graphics.endFill();
         this.tempObject = new Object();
         this.notifObject = new Object();
         this._staffList = new Object();
         this._staffList.janitor = new Array();
         this._staffList.handyman = new Array();
         this._staffList.entertainer = new Array();
         this._staffList.guard = new Array();
         this._staffList.unshown = new Array();
         this._world = new World();
         this._world.staffList = this._staffList;
         this._world.main = this;
         this._world.x = 350;
         this._world.y = 350;
         addChild(this._world);
         this._GUI = new UI_InGame();
         this._GUI.main = this;
         this._minimap = this.GUI.minimapPanel;
         this._GUI.statisticPanel.statistic = new Statistic();
         this._autoSaveIndicator = this._GUI.autoSaveIndicator;
         addChild(this._GUI);
         addChild(this._GUI.helpPage);
         this._gameSpeed = 1;
         this._budget = 50000;
         this.initApplicant();
         this._currentStatistic = new Statistic();
         this._humanFocus = null;
         this._mission = new Mission();
         this._tutorial = new Tutorial();
         this._tutorial.main = this;
         this._history = new Object();
         this._onStackSFX = new Array();
         this._onStackSFXSource = new Array();
         this._enablePlayBGM = new Array();
         this._enablePlayBGM.push(BGMData.FOLK_ROUND);
         this._enableRainBGM = new Array();
         this._enableRainBGM.push(BGMData.PIZZICATO_POLKA);
         this.generateAchievement();
         this._manualPage = new UIManual();
         this._manualPage.world = this._world;
      }
      
      function generateAchievement() : void
      {
         this._achievement = AchievementList.generateAchievement();
         this._achievementPage = new UIachievements();
         this._achievementPage.main = this;
         this._achievementUnlock = new Array();
         this._achievementGainInfo = new AchievementGainInfo();
         this._delayToRevealAchievement = 0;
         this._delayToRevealAchievement = 0;
      }
      
      function initUnlockedBuilding() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < BuildingData.BUILDING_LIST.length)
         {
            _loc2_ = BuildingData.getPopularityUnlock(BuildingData.BUILDING_LIST[_loc1_]);
            if(_loc2_ == 0)
            {
               this._unlockedBuilding.push(BuildingData.BUILDING_LIST[_loc1_]);
            }
            _loc1_++;
         }
      }
      
      function initApplicant() : void
      {
         var _loc3_:* = undefined;
         this._applicants = new Array();
         var _loc1_:* = [["stamina","hygine","hygine"],["stamina","stamina"],["entertain"],["stamina","sight","speed","speed"]];
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = this.getRandomHumanStat(_loc1_[_loc2_]);
            _loc3_.characterName = HumanData.getRandomCharacterName(1);
            this._applicants.push(_loc3_);
            _loc2_++;
         }
         this._countdownApplicant = this.APPLICANT_DELAY;
         this._minimalNewApplicant = 1;
         this._chanceToGetApplicant = 30;
      }
      
      function getRandomHumanStat(param1:Array = null) : HumanStat
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = 250;
         _loc2_ += Math.round(Math.random() * 150 - 75);
         var _loc3_:HumanStat = new HumanStat();
         _loc3_.stamina = 1;
         _loc3_.speed = 1;
         _loc3_.hygine = 1;
         _loc3_.entertain = 1;
         _loc3_.sight = 1;
         _loc2_ -= 5;
         var _loc4_:Array = ["stamina","speed","hygine","entertain","sight"];
         if(param1 != null)
         {
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc4_.push(param1[_loc5_]);
               _loc5_++;
            }
         }
         Utility.shuffle(_loc4_);
         while(_loc2_ > 0)
         {
            _loc6_ = Math.floor(Math.random() * _loc4_.length);
            if(_loc3_[_loc4_[_loc6_]] < 100)
            {
               ++_loc3_[_loc4_[_loc6_]];
               _loc2_--;
            }
            else
            {
               _loc4_.splice(_loc6_,1);
            }
         }
         _loc3_.hireCostDifference = Math.random() * 0.2 - 0.1;
         return _loc3_;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this._world.gameSpeed = 0;
         this._GUI.clock.hour = this._gameHour;
         this._GUI.clock.minute = this._gameMinute;
         this._GUI.updateSpeedButton(this._gameSpeed);
         this._GUI.extraUpgradePanel.world = this._world;
         this._GUI.detailStaffInfo.staffList = this._staffList;
         this._GUI.detailVisitorInfo.world = this._world;
         this._GUI.detailBuildingInfo.world = this._world;
         this._GUI.hirePanel.main = this;
         this._GUI.hirePanel.applicants = this._applicants;
         this._GUI.shownBudget = this._budget;
         this._GUI.changePopularity(this._world.popularity);
         this._GUI.statisticPanel.world = this._world;
         this._GUI.statisticPanel.updateShown();
         this._GUI.hintPanel.main = this;
         this._GUI.followUsPanel.main = this;
         this._GUI.nameInfoIndicator.text = this._nameID.toUpperCase() + " MALL";
         this._GUI.dayPassedInfo.text = "DAY " + this._dayPassed;
         this._autoSaveIndicator.mouseEnabled = false;
         this._autoSaveIndicator.mouseChildren = false;
         this._autoSaveIndicator.stop();
         this._autoSaveIndicator.parent.removeChild(this._autoSaveIndicator);
         addListenerOf(this._autoSaveIndicator,Event.ADDED_TO_STAGE,this.initAutoSaveIndicator);
         addListenerOf(this._world,CommandEvent.BOOTH_ON_SELECT,this.selectBooth);
         addListenerOf(this._world,CommandEvent.ELEVATOR_ON_SELECT,this.selectElevator);
         addListenerOf(this._world,CommandEvent.HALTE_ON_SELECT,this.selectHalte);
         addListenerOf(this._world,CommandEvent.HUMAN_ON_SELECT,this.selectHuman);
         addListenerOf(this._world,GameEvent.RUN_BUILD_PROGRESS,this.buildProgressRun);
         addListenerOf(this._world,GameEvent.HIRE_STAFF,this.staffHired);
         addListenerOf(this._world,GameEvent.FIRE,this.staffFired);
         addListenerOf(this._world,GameEvent.BUILDING_CREATED,this.updateBuildingData);
         addListenerOf(this._world,GameEvent.BUILDING_DESTROYED,this.updateBuildingData);
         addListenerOf(this._world,GameEvent.UPDATE_POPULARITY,this.updatePopularity);
         addListenerOf(this._world,GameEvent.VISITOR_VISIT,this.checkVisitorVisit);
         addListenerOf(this._world,HumanEvent.SPENT_MONEY,this.checkSpentMoney);
         addListenerOf(this._world,HumanEvent.RETURN_BOUNTY,this.checkReturnBounty);
         addListenerOf(this._world,HumanEvent.REFUND_MONEY,this.checkRefundMoney);
         addListenerOf(this._world,HumanEvent.STEAL_MONEY,this.checkStolenMoney);
         addListenerOf(this._world,HumanEvent.PAY_SALARY,this.checkSalaryPaid);
         addListenerOf(this._world,GameEvent.BONUS_GAIN,this.checkBonusGain);
         addListenerOf(this._world,CommandEvent.DECIDE_BUILD,this.buildingIsBought);
         addListenerOf(this._world,CommandEvent.CONFIRM_EXPAND,this.expandElevator);
         addListenerOf(this._world,CommandEvent.DECIDE_RELOCATE,this.buildingIsRelocated);
         addListenerOf(this._world,GameEvent.BECOMES_UPGRADE,this.buildingIsUpgraded);
         addListenerOf(this._world,HumanEvent.BECOMES_PROMOTE,this.staffIsPromoted);
         addListenerOf(this._world,HumanEvent.BECOMES_FIRE,this.staffIsFired);
         addListenerOf(this._world,CommandEvent.DECIDE_HIRE,this.staffIsHired);
         addListenerOf(this._world,GameEvent.ALARM_TRIGGERED,this.checkAlarmTrigger);
         addListenerOf(this._world,GameEvent.ALARM_STOPPED,this.checkAlarmStop);
         addListenerOf(this,GameEvent.SHOW_NOTIFICATION,this.checkNotification);
         addListenerOf(this,GameEvent.SHOW_MUTE_NOTIFICATION,this.checkNotificationMute);
         addListenerOf(this,CommandEvent.REFRESH_APPLICANT,this.instantRefreshApplicant);
         addListenerOf(this.GUI,CommandEvent.SPEED_CHANGE,this.changeSpeed);
         addListenerOf(this.GUI,CommandEvent.DECLINE_STAFF,this.removeApplicant);
         addListenerOf(this,GameEvent.PURCHASE_UPGRADE,this.whenUpgradePurchased);
         addListenerOf(this,GameEvent.LOST_HUMAN_FOCUS,this.whenHumanFocusLost);
         addListenerOf(this,MissionEvent.MISSION_SUCCESS,this.whenMissionSuccess);
         addListenerOf(this,GameEvent.ADD_CHAT_LOG,this.whenConversationAdded);
         addListenerOf(this.GUI,Event.ADDED,this.checkDialogAdded);
         addListenerOf(this.GUI,CommandEvent.MENU_SETTING,this.showMenu);
         addListenerOf(this.GUI,CommandEvent.SHOW_ACHIEVEMENT_PAGE,this.showAchievement);
         addListenerOf(this.GUI,CommandEvent.SHOW_MANUAL,this.showManual);
         addListenerOf(this,CommandEvent.EXIT_GAME,this.askToExitGame);
         addListenerOf(this,CommandEvent.SAVE_GAME,this.askToSaveGame);
         addListenerOf(this,Event.ENTER_FRAME,this.checkPlayedSound);
         addListenerOf(this,GameEvent.UPDATE_BUDGET,this.whenBudgetUpdated);
         addListenerOf(this,AchievementEvent.UPDATE_HISTORY,this.checkHistoryUpdated);
         addListenerOf(this,Event.ENTER_FRAME,this.checkHandCursor);
         this._world.initCloud(this._GUI.clock.daySymbol.alpha);
         this._world.drawSky(this._GUI.clock.daySymbol.alpha);
         this._minimap.world = this._world;
         this._mission.world = this._world;
         this._mission.GUI = this.GUI;
         this.initAchievement();
         this.initBGM();
         var _loc2_:* = root;
         if(_loc2_.hacked > 0)
         {
            this.GUI.hackedMessage.visible = this._mission.currentProgress > 15;
            this.GUI.hackedMessage.text = _loc2_.hackedMessage;
         }
      }
      
      function checkHandCursor(param1:Event) : void
      {
         this._scrollHand.x = stage.mouseX;
         this._scrollHand.y = stage.mouseY;
         if(this._GUI.btnDrag.isActive)
         {
            if(getChildByName(this._scrollHand.name))
            {
               setChildIndex(this._scrollHand,numChildren - 1);
            }
            else
            {
               addChild(this._scrollHand);
            }
            this._scrollHand.visible = !(this._GUI.hitTestPoint(stage.mouseX,stage.mouseY,true) || this._blankCover.hitTestPoint(stage.mouseX,stage.mouseY,true) || this._achievementPage.hitTestPoint(stage.mouseX,stage.mouseY,true) || this._manualPage.hitTestPoint(stage.mouseX,stage.mouseY,true));
            if(this._scrollHand.visible)
            {
               Mouse.hide();
            }
            else
            {
               Mouse.show();
            }
         }
         else if(getChildByName(this._scrollHand.name))
         {
            Mouse.show();
            removeChild(this._scrollHand);
         }
      }
      
      function initAutoSaveIndicator(param1:Event) : void
      {
         this._autoSaveIndicator.gotoAndPlay(1);
         addListenerOf(this._autoSaveIndicator,Event.ENTER_FRAME,this.checkAnimationSaveIndicator);
      }
      
      function checkAnimationSaveIndicator(param1:Event) : void
      {
         if(this._autoSaveIndicator.currentFrame >= this._autoSaveIndicator.totalFrames)
         {
            this._autoSaveIndicator.parent.removeChild(this._autoSaveIndicator);
            this._autoSaveIndicator.stop();
            removeListenerOf(this._autoSaveIndicator,Event.ENTER_FRAME,this.checkAnimationSaveIndicator);
         }
      }
      
      function whenBudgetUpdated(param1:GameEvent) : void
      {
         this.updateHistoryMax("cash",this._budget);
      }
      
      function initAchievement() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._achievement.length)
         {
            _loc2_ = this._achievement[_loc1_];
            if(_loc2_.amountCheck == "allSpecialVisitor")
            {
               _loc2_.amountCheck = this._world.specialVisitorList.length;
            }
            _loc1_++;
         }
      }
      
      function checkHistoryUpdated(param1:AchievementEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = param1.variable;
         var _loc3_:* = 0;
         while(_loc3_ < this._achievement.length)
         {
            if(!(_loc4_ = this._achievement[_loc3_]).aquired)
            {
               if(_loc4_.varCheck is String)
               {
                  if(_loc4_.varCheck == _loc2_ || _loc2_ == null)
                  {
                     if(this._history[_loc4_.varCheck] >= _loc4_.amountCheck)
                     {
                        if(this._achievementUnlock.indexOf(_loc4_) < 0)
                        {
                           this._achievementUnlock.push(_loc4_);
                        }
                     }
                  }
               }
               else if(_loc4_.varCheck is Array)
               {
                  if(_loc4_.varCheck.indexOf(_loc2_) >= 0 || _loc2_ == null)
                  {
                     _loc5_ = 0;
                     _loc6_ = 0;
                     while(_loc6_ < _loc4_.varCheck.length)
                     {
                        if(_loc4_.varCheck[_loc6_] in this._history)
                        {
                           _loc5_ += this._history[_loc4_.varCheck[_loc6_]];
                        }
                        _loc6_++;
                     }
                     if(_loc5_ >= _loc4_.amountCheck)
                     {
                        if(this._achievementUnlock.indexOf(_loc4_) < 0)
                        {
                           this._achievementUnlock.push(_loc4_);
                        }
                     }
                  }
               }
            }
            _loc3_++;
         }
      }
      
      function checkAchievementGain(param1:Event) : void
      {
         var toShow:* = undefined;
         var e:Event = param1;
         if(getChildByName(this._achievementGainInfo.name) == null)
         {
            if(this._delayToRevealAchievement > 0)
            {
               --this._delayToRevealAchievement;
            }
            else if(this._achievementUnlock.length > 0)
            {
               var countdownProgress:Function = function():void
               {
                  toShow.aquired = true;
                  _delayWhenRevealAchievement = Math.round(24 * 2.5);
                  addListenerOf(_achievementGainInfo,Event.ENTER_FRAME,countdownToVanishAchievement);
                  _achievementPage.updateView();
               };
               this._delayToRevealAchievement = 6;
               toShow = this._achievementUnlock[0];
               this._achievementGainInfo.x = 700;
               this._achievementGainInfo.y = 12;
               this._achievementGainInfo.rotation = -90;
               if(Utility.hasLabel(this._achievementGainInfo.achievementIcon,toShow.frameCheck))
               {
                  this._achievementGainInfo.achievementIcon.gotoAndStop(toShow.frameCheck);
               }
               this._achievementGainInfo.achievementTitle.text = toShow.codeName.toUpperCase();
               addChild(this._achievementGainInfo);
               TweenLite.to(this._achievementGainInfo,0.3,{
                  "rotation":0,
                  "ease":Linear.easeNone,
                  "onComplete":countdownProgress
               });
               dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Checkpoint));
            }
         }
      }
      
      function countdownToVanishAchievement(param1:Event) : void
      {
         var e:Event = param1;
         if(this._delayWhenRevealAchievement > 0)
         {
            --this._delayWhenRevealAchievement;
         }
         else
         {
            var finishShown:Function = function():void
            {
               if(getChildByName(_achievementGainInfo.name) != null)
               {
                  removeChild(_achievementGainInfo);
                  _achievementUnlock.shift();
               }
            };
            TweenLite.to(this._achievementGainInfo,0.3,{
               "rotation":-90,
               "ease":Linear.easeNone,
               "onComplete":finishShown
            });
            removeListenerOf(this._achievementGainInfo,Event.ENTER_FRAME,this.countdownToVanishAchievement);
         }
      }
      
      public function updateHistory(param1:String) : void
      {
         if(!(param1 in this._history) || isNaN(this._history[param1]))
         {
            this._history[param1] = 0;
         }
         ++this._history[param1];
         dispatchEvent(new AchievementEvent(AchievementEvent.UPDATE_HISTORY,param1));
      }
      
      public function updateHistoryMax(param1:String, param2:Number) : void
      {
         if(!(param1 in this._history) || isNaN(this._history[param1]))
         {
            this._history[param1] = 0;
         }
         this._history[param1] = Math.max(this._history[param1],param2);
         dispatchEvent(new AchievementEvent(AchievementEvent.UPDATE_HISTORY,param1));
      }
      
      function initBGM() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this._gameHour >= 22 || this._gameHour < 9)
         {
            dispatchEvent(new AudioEvent(AudioEvent.PLAY_BGM,BGMData.IN_THE_HALL_OF_MOUNTAIN_KING));
         }
         else if(!this._world.deepRain)
         {
            _loc1_ = this._enablePlayBGM[Math.floor(Math.random() * this._enablePlayBGM.length)];
            dispatchEvent(new AudioEvent(AudioEvent.PLAY_BGM,_loc1_));
         }
         else
         {
            _loc2_ = this._enableRainBGM[Math.floor(Math.random() * this._enableRainBGM.length)];
            dispatchEvent(new AudioEvent(AudioEvent.PLAY_BGM,_loc2_));
         }
      }
      
      function checkPlayedSound(param1:Event) : void
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
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         while(this._onStackSFX.length > 0)
         {
            _loc4_ = this._onStackSFX.shift();
            _loc5_ = this._onStackSFXSource.shift();
            if((_loc6_ = _loc2_.indexOf(_loc4_)) in this._onStackSFX)
            {
               _loc8_ = (_loc7_ = _loc3_[_loc6_]).localToGlobal(new Point(0,0));
               _loc9_ = _loc5_.localToGlobal(new Point(0,0));
               _loc10_ = new Point(350,200);
               _loc11_ = Calculate.countDistance(_loc8_,_loc10_);
               if((_loc12_ = Calculate.countDistance(_loc9_,_loc10_)) < _loc11_)
               {
                  _loc3_[_loc6_] = _loc5_;
               }
            }
            else
            {
               _loc2_.push(_loc4_);
               _loc3_.push(_loc5_);
            }
         }
         while(_loc2_.length > 0)
         {
            _loc13_ = _loc2_.shift();
            if((_loc14_ = _loc3_.shift()) != null && _loc13_ != null)
            {
               _loc14_.dispatchEvent(new AudioEvent(AudioEvent.PLAY_DYNAMIC_SFX,_loc13_));
            }
         }
      }
      
      function checkAlarmTrigger(param1:GameEvent) : void
      {
         dispatchEvent(new AudioEvent(AudioEvent.INTERRUPT_BGM,BGMData.RONDA_ALLA_TURCA));
      }
      
      function checkAlarmStop(param1:GameEvent) : void
      {
         dispatchEvent(new AudioEvent(AudioEvent.STOP_INTERRUPT_BGM));
      }
      
      override protected function Removed(param1:Event) : void
      {
         super.Removed(param1);
         if(this.currentTween != null)
         {
            this.currentTween.kill();
         }
      }
      
      function showMenu(param1:CommandEvent) : void
      {
         this._tutorial.pauseTutor();
         addChild(this._blankCover);
         this._menuSetting.x = 350;
         this._menuSetting.y = 250;
         this._menuSetting.scaleX = 1;
         this._menuSetting.scaleY = 1;
         this._menuSetting.alpha = 1;
         this._menuSetting.unsaveWarning.visible = this._tutorial.inProgress;
         if(this._tutorial.inProgress)
         {
            this._menuSetting.btnSave.enabled = false;
            this._menuSetting.btnSave.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
         }
         else
         {
            this._menuSetting.btnSave.enabled = true;
            this._menuSetting.btnSave.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         addChild(this._menuSetting);
         var _loc2_:* = this.GUI.btnSetting;
         TweenLite.from(this._menuSetting,0.4,{
            "x":_loc2_.x,
            "y":_loc2_.y,
            "width":_loc2_.width,
            "height":_loc2_.height,
            "alpha":0
         });
         this._menuAppear = true;
         this.GUI.dispatchEvent(new CommandEvent(CommandEvent.SPEED_CHANGE));
         addListenerOf(this._menuSetting,CommandEvent.RESUME_GAME,this.resumeGameAfterMenu);
         addListenerOf(this._menuSetting,CommandEvent.ENTER_OPTION,this.enterTheOption);
      }
      
      function showAchievement(param1:CommandEvent) : void
      {
         var _loc2_:* = undefined;
         if(getChildByName(this._manualPage.name) != null)
         {
            this._manualPage.dispatchEvent(new CommandEvent(CommandEvent.RESUME_GAME));
         }
         if(getChildByName(this._achievementPage.name) == null)
         {
            this._achievementPage.x = 350;
            this._achievementPage.y = 250;
            this._achievementPage.scaleX = 1;
            this._achievementPage.scaleY = 1;
            this._achievementPage.alpha = 1;
            addChild(this._achievementPage);
            _loc2_ = this.GUI.btnAchievement;
            TweenLite.from(this._achievementPage,0.4,{
               "x":_loc2_.x,
               "y":_loc2_.y,
               "width":_loc2_.width,
               "height":_loc2_.height,
               "alpha":0
            });
            addListenerOf(this._achievementPage,CommandEvent.RESUME_GAME,this.resumeGameAfterMenu);
         }
         else
         {
            this._achievementPage.dispatchEvent(new CommandEvent(CommandEvent.RESUME_GAME));
         }
      }
      
      function showManual(param1:CommandEvent) : void
      {
         var _loc2_:* = undefined;
         if(getChildByName(this._achievementPage.name) != null)
         {
            this._achievementPage.dispatchEvent(new CommandEvent(CommandEvent.RESUME_GAME));
         }
         if(getChildByName(this._manualPage.name) == null)
         {
            this._manualPage.x = 350;
            this._manualPage.y = 250;
            this._manualPage.scaleX = 1;
            this._manualPage.scaleY = 1;
            this._manualPage.alpha = 1;
            addChild(this._manualPage);
            _loc2_ = this.GUI.btnManual;
            TweenLite.from(this._manualPage,0.4,{
               "x":_loc2_.x,
               "y":_loc2_.y,
               "width":_loc2_.width,
               "height":_loc2_.height,
               "alpha":0
            });
            addListenerOf(this._manualPage,CommandEvent.RESUME_GAME,this.resumeGameAfterMenu);
         }
         else
         {
            this._manualPage.dispatchEvent(new CommandEvent(CommandEvent.RESUME_GAME));
         }
      }
      
      function resumeGameAfterMenu(param1:CommandEvent) : void
      {
         this._tutorial.resumeTutor();
         this._menuAppear = false;
         if(getChildByName(this._blankCover.name))
         {
            removeChild(this._blankCover);
         }
         var _loc2_:* = null;
         var _loc3_:* = param1.target;
         if(_loc3_ == this._menuSetting)
         {
            _loc2_ = this.GUI.btnSetting;
         }
         else if(_loc3_ == this._achievementPage)
         {
            _loc2_ = this.GUI.btnAchievement;
         }
         else if(_loc3_ == this._manualPage)
         {
            _loc2_ = this.GUI.btnManual;
         }
         if(_loc2_ != null)
         {
            TweenLite.to(_loc3_,0.4,{
               "x":_loc2_.x,
               "y":_loc2_.y,
               "width":_loc2_.width,
               "height":_loc2_.height,
               "alpha":0,
               "onComplete":_loc3_.parent.removeChild,
               "onCompleteParams":[_loc3_]
            });
         }
         else
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         this.GUI.dispatchEvent(new CommandEvent(CommandEvent.SPEED_CHANGE));
      }
      
      function enterTheOption(param1:CommandEvent) : void
      {
         addChild(this._blankCover);
         this._optionMenu.x = 350;
         this._optionMenu.y = 250;
         this._optionMenu.scaleX = 1;
         this._optionMenu.scaleY = 1;
         this._optionMenu.alpha = 1;
         addChild(this._optionMenu);
         TweenLite.from(this._optionMenu,0.4,{
            "scaleX":0,
            "scaleY":0,
            "alpha":0
         });
         addListenerOf(this._optionMenu,CommandEvent.EXIT_OPTION,this.closeTheOption);
      }
      
      function closeTheOption(param1:CommandEvent) : void
      {
         var _loc2_:* = undefined;
         if(getChildByName(this._menuSetting.name))
         {
            _loc2_ = getChildIndex(this._menuSetting);
            setChildIndex(this._blankCover,_loc2_);
            TweenLite.to(this._optionMenu,0.4,{
               "scaleX":0,
               "scaleY":0,
               "alpha":0,
               "onComplete":this._optionMenu.parent.removeChild,
               "onCompleteParams":[this._optionMenu]
            });
         }
      }
      
      function askToExitGame(param1:CommandEvent) : void
      {
         var confirmation:* = undefined;
         var onChoose:Function = null;
         var e:CommandEvent = param1;
         onChoose = function(param1:MessageDialogEvent):void
         {
            removeListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
            if(param1.choice == MessageDialogEvent.CHOICE_YES)
            {
               dispatchEvent(new CommandEvent(CommandEvent.BACK_TO_MAIN_MENU));
            }
            confirmation.parent.removeChild(confirmation);
            var _loc2_:* = getChildIndex(_menuSetting);
            setChildIndex(_blankCover,_loc2_);
         };
         confirmation = new UI_Confirmation();
         confirmation.toConfirm = "toExit";
         confirmation.x = 350;
         confirmation.y = 250;
         addChild(this._blankCover);
         addChild(confirmation);
         addListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
      }
      
      function askToSaveGame(param1:CommandEvent) : void
      {
         var previousSaveData:* = undefined;
         var confirmation:* = undefined;
         var onChoose:Function = null;
         var e:CommandEvent = param1;
         if(!this._tutorial.inProgress)
         {
            previousSaveData = this._mainProgram.getSaveData(this._slotIndex);
            if(previousSaveData != null)
            {
               onChoose = function(param1:MessageDialogEvent):void
               {
                  removeListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
                  if(param1.choice == MessageDialogEvent.CHOICE_YES)
                  {
                     saveTheGame();
                  }
                  confirmation.parent.removeChild(confirmation);
                  var _loc2_:* = getChildIndex(_menuSetting);
                  setChildIndex(_blankCover,_loc2_);
               };
               confirmation = new UI_Confirmation();
               confirmation.toConfirm = "toSave";
               confirmation.x = 350;
               confirmation.y = 250;
               addChild(this._blankCover);
               addChild(confirmation);
               addListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
            }
            else
            {
               this.saveTheGame();
            }
         }
      }
      
      public function loadFrom(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1 != null)
         {
            this._loadGame = true;
            this._nameID = param1.nameID;
            this._gameHour = param1.gameHour;
            this._gameMinute = param1.gameMinute;
            _loc2_ = 0;
            while(_loc2_ < param1.tutorialPassed.length)
            {
               this._tutorial.passed.push(param1.tutorialPassed[_loc2_]);
               _loc2_++;
            }
            this._mission.currentProgress = param1.missionPassed;
            if(param1.specialCheck != null)
            {
               this._mission.specialCheck = param1.specialCheck;
            }
            this._unlockedBuilding = param1.unlockedBuilding.concat();
            this._newUnlockedBuilding = param1.newUnlockedBuilding.concat();
            this._unlockedUpgrade = param1.unlockedUpgrade.concat();
            this._newUnlockedUpgrade = param1.newUnlockedUpgrade.concat();
            this._unlockedStaff = param1.unlockedStaff.concat();
            if(param1.unlockedHint != null)
            {
               this._unlockedHint = param1.unlockedHint.concat();
            }
            if(param1.newUnlockedHint != null)
            {
               this._newUnlockedHint = param1.newUnlockedHint.concat();
            }
            this._budget = param1.budget;
            if(param1.dayPassed != null)
            {
               this._dayPassed = param1.dayPassed;
            }
            this._world.loadCondition(param1.world);
            if(param1.gui != null)
            {
               this._GUI.loadCondition(param1.gui);
            }
            if(param1.history != null)
            {
               this._history = new Object();
               for(_loc4_ in param1.history)
               {
                  this._history[_loc4_] = param1.history[_loc4_];
               }
            }
            this.loadApplicant(param1);
            this.loadFloorData(param1);
            this.loadBuildingData(param1);
            this.loadTrash(param1);
            this.loadAchievement(param1);
            _loc3_ = 0;
            _loc3_ = this._world.onInfoBuildingList.length - 1;
            this._GUI.setNumberBuilding(_loc3_);
            this.updateNumberStaff();
            this._GUI.setNumberVisitor(this._world.currentVisitorList.length);
            if(this._dayPassed >= 10)
            {
               this._enablePlayBGM.push(BGMData.PARISIAN);
            }
            if(this._history["popularity"] >= 10)
            {
               this._enablePlayBGM.push(BGMData.CELTIC_2);
            }
            if(this._history["popularity"] >= 20)
            {
               this._enableRainBGM.push(BGMData.SKYE_CUILLIN);
            }
            if(this._history["popularity"] >= 30)
            {
               this._enablePlayBGM.push(BGMData.CELTIC_3);
            }
            if(this._dayPassed >= 15)
            {
               this._enableRainBGM.push(BGMData.FUR_ELISE);
            }
         }
      }
      
      function loadAchievement(param1:*) : void
      {
         var _loc2_:* = undefined;
         if(param1.achievement != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this._achievement.length)
            {
               this._achievement[_loc2_].aquired = param1.achievement[_loc2_] == 1;
               if(param1.achievement[_loc2_] == 2)
               {
                  this._achievementUnlock.push(this._achievement[_loc2_]);
               }
               _loc2_++;
            }
         }
      }
      
      function loadApplicant(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.applicant != null)
         {
            this._countdownApplicant = param1.applicant.countdown;
            this._minimalNewApplicant = param1.applicant.minimal;
            this._chanceToGetApplicant = param1.applicant.chance;
            this._applicants = new Array();
            _loc2_ = 0;
            while(_loc2_ < param1.applicant.list.length)
            {
               _loc3_ = param1.applicant.list[_loc2_];
               (_loc4_ = new HumanStat()).stamina = _loc3_.stamina;
               _loc4_.hygine = _loc3_.hygine;
               _loc4_.entertain = _loc3_.entertain;
               _loc4_.sight = _loc3_.sight;
               _loc4_.speed = _loc3_.speed;
               _loc4_.characterName = _loc3_.characterName;
               _loc4_.hireCostDifference = _loc3_.hireCostDifference;
               this._applicants.push(_loc4_);
               _loc2_++;
            }
         }
      }
      
      function loadFloorData(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < param1.floorList.length)
         {
            _loc3_ = param1.floorList[_loc2_];
            this._world.addFloor(_loc3_.posY,_loc3_.left,_loc3_.right);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.basementFloorList.length)
         {
            _loc4_ = param1.basementFloorList[_loc2_];
            this._world.addBasementFloor(_loc4_.posY,_loc4_.left,_loc4_.right);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.columnList.length)
         {
            _loc5_ = param1.columnList[_loc2_];
            (_loc6_ = new Column()).x = _loc5_.coordinate.x;
            _loc6_.y = _loc5_.coordinate.y;
            _loc6_.gotoAndStop(_loc5_.model);
            this._world.columnList.push(_loc6_);
            _loc2_++;
         }
      }
      
      function loadBuildingData(param1:*) : void
      {
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc2_:* = new Array();
         var _loc3_:* = new Array();
         var _loc4_:* = 0;
         while(_loc4_ < param1.buildingList.length)
         {
            if((_loc11_ = param1.buildingList[_loc4_]) != null)
            {
               _loc12_ = null;
               if(_loc11_.type == "Enterance")
               {
                  _loc12_ = new BuildingInnEnterance();
               }
               else if(_loc11_.type == "HalteWagon")
               {
                  _loc12_ = new HalteWagon();
               }
               else if(_loc11_.type == "Connection")
               {
                  _loc12_ = new BuildingInnConnection();
               }
               else if((_loc13_ = BuildingData.getClassOf(_loc11_.type)) != null)
               {
                  _loc12_ = new _loc13_();
               }
               if(_loc12_ != null)
               {
                  _loc12_.world = this._world;
                  _loc12_.level = _loc11_.level;
                  _loc12_.initExp(_loc11_.exp);
                  _loc12_.x = _loc11_.coordinate.x;
                  _loc12_.y = _loc11_.coordinate.y;
                  _loc12_.loadCondition(_loc11_);
                  if("fictionalBuilding" in _loc12_)
                  {
                     if(_loc12_.fictionalBuilding != null)
                     {
                        _loc2_.push(_loc11_.codeName + "_Inside");
                        _loc3_.push(_loc12_.fictionalBuilding);
                     }
                  }
                  if(_loc12_ is FacilityRestRoom)
                  {
                     _loc2_.push(_loc11_.codeName + "_ManRoom");
                     _loc3_.push(_loc12_.maleRoom);
                     _loc2_.push(_loc11_.codeName + "_WomanRoom");
                     _loc3_.push(_loc12_.femaleRoom);
                  }
                  this._world.buildingList.push(_loc12_);
               }
               _loc2_.push(_loc11_.codeName);
               _loc3_.push(_loc12_);
            }
            _loc4_++;
         }
         var _loc5_:*;
         if((_loc5_ = _loc2_.indexOf(param1.halte)) in _loc3_)
         {
            this._world.halte = _loc3_[_loc5_] as HalteWagon;
            if(this._world.halte.currentWagon != null)
            {
               _loc2_.push(this.getCodeNameOf(this._world.halte.currentWagon));
               _loc3_.push(this._world.halte.currentWagon);
            }
         }
         var _loc6_:*;
         if((_loc6_ = _loc2_.indexOf(param1.connectionSurface)) in _loc3_)
         {
            this._world.connectionSurface = _loc3_[_loc6_];
         }
         this.loadElevatorData(param1,_loc2_,_loc3_);
         this.loadStairData(param1,_loc2_,_loc3_);
         var _loc7_:* = [param1.dungeonConnection,param1.boothList,param1.restRoomList,param1.innList,param1.tradingPostList,param1.terraceList,param1.brokableBuildingList,param1.guardPostList,param1.transportList,param1.onInfoBuildingList];
         var _loc8_:* = [this._world.dungeonConnection,this._world.boothList,this._world.restRoomList,this._world.innList,this._world.tradingPostList,this._world.terraceList,this._world.brokableBuildingList,this._world.guardPostList,this._world.transportList,this._world.onInfoBuildingList];
         for(_loc9_ in param1.boothListByType)
         {
            this._world.boothListByType[_loc9_] = new Array();
            _loc7_.push(param1.boothListByType[_loc9_]);
            _loc8_.push(this._world.boothListByType[_loc9_]);
         }
         _loc10_ = 0;
         while(_loc10_ < _loc7_.length)
         {
            if(_loc10_ in _loc8_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc7_[_loc10_].length)
               {
                  if((_loc14_ = _loc2_.indexOf(_loc7_[_loc10_][_loc4_])) in _loc3_)
                  {
                     _loc8_[_loc10_].push(_loc3_[_loc14_]);
                  }
                  _loc4_++;
               }
            }
            _loc10_++;
         }
         this.loadStatistic(param1,_loc2_,_loc3_);
         this.loadShopkeeper(param1,_loc2_,_loc3_);
         this.loadStaff(param1,_loc2_,_loc3_);
         this.loadVisitor(param1,_loc2_,_loc3_);
         this.loadThief(param1,_loc2_,_loc3_);
         this.loadLitter(param1,_loc2_,_loc3_);
         this.loadWizard(param1,_loc2_,_loc3_);
         this.loadWatchdog(param1,_loc2_,_loc3_);
      }
      
      function loadStatistic(param1:*, param2:Array, param3:Array) : void
      {
         this._currentStatistic.loadStatistic(param1.statistic.current,param2,param3);
         var _loc4_:Statistic;
         (_loc4_ = new Statistic()).loadStatistic(param1.statistic.past,param2,param3);
         this.GUI.statisticPanel.statistic = _loc4_;
      }
      
      function loadElevatorData(param1:*, param2:Array, param3:Array) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc4_:* = 0;
         while(_loc4_ < param1.elevatorList.length)
         {
            if((_loc5_ = param1.elevatorList[_loc4_]) != null)
            {
               (_loc6_ = new Elevator()).world = this._world;
               _loc6_.x = _loc5_.posX;
               _loc7_ = 0;
               while(_loc7_ < _loc5_.bodyList.length)
               {
                  if((_loc8_ = param2.indexOf(_loc5_.bodyList[_loc7_])) in param3)
                  {
                     param3[_loc8_].elevatorLink = _loc6_;
                     _loc6_.bodyList.push(param3[_loc8_]);
                  }
                  _loc7_++;
               }
               _loc6_.bodyList.sortOn("y",Array.NUMERIC | Array.DESCENDING);
               _loc7_ = 0;
               while(_loc7_ < _loc5_.roomTarget.length)
               {
                  if((_loc9_ = param2.indexOf(_loc5_.roomTarget[_loc7_])) in param3)
                  {
                     _loc6_.roomTarget.push(param3[_loc9_]);
                  }
                  _loc7_++;
               }
               _loc6_.bodyTarget = _loc5_.bodyTarget;
               _loc6_.level = _loc5_.level;
               _loc6_.initExp(_loc5_.exp);
               this._world.elevatorList.push(_loc6_);
               param2.push(_loc5_.codeName);
               param3.push(_loc6_);
            }
            _loc4_++;
         }
      }
      
      function loadStairData(param1:*, param2:Array, param3:Array) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc4_:* = 0;
         while(_loc4_ < param1.stairList.length)
         {
            if((_loc5_ = param1.stairList[_loc4_]) != null)
            {
               (_loc6_ = new FacilityStairs()).world = this._world;
               _loc6_.x = _loc5_.coordinate.x;
               _loc6_.y = _loc5_.coordinate.y;
               _loc6_.scaleX = !!_loc5_.swapped ? -1 : 1;
               this._world.stairList.push(_loc6_);
               param2.push(_loc5_.codeName);
               param3.push(_loc6_);
            }
            _loc4_++;
         }
      }
      
      function loadTrash(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(param1.trashList != null)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.trashList.length)
            {
               _loc3_ = param1.trashList[_loc2_];
               if(_loc3_ != null)
               {
                  (_loc4_ = new Trash()).x = _loc3_.coordinate.x;
                  _loc4_.y = _loc3_.coordinate.y;
                  _loc4_.dirtyLevel = _loc3_.dirtyLevel;
                  this._world.trashList.push(_loc4_);
               }
               _loc2_++;
            }
         }
         if(param1.pupList != null)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.pupList.length)
            {
               if((_loc5_ = param1.pupList[_loc2_]) != null)
               {
                  (_loc6_ = new AnimalPoop()).x = _loc5_.coordinate.x;
                  _loc6_.y = _loc5_.coordinate.y;
                  _loc6_.dirtyLevel = _loc5_.dirtyLevel;
                  this._world.pupList.push(_loc6_);
               }
               _loc2_++;
            }
         }
      }
      
      function loadAsHuman(param1:*, param2:*, param3:Array, param4:Array) : void
      {
         param1.world = this._world;
         param1.x = param2.coordinate.x;
         param1.y = param2.coordinate.y;
         param1.scaleX = param2.dirrection;
         var _loc5_:*;
         if((_loc5_ = param3.indexOf(param2.destination)) in param4)
         {
            param1.destination = param4[_loc5_];
         }
         else
         {
            param1.destination = param2.destination;
         }
         param1.inHome = param2.inHome;
         param1.currentAnimation = Animation.IDLE;
         param1.baseHome = param2.baseHome;
         var _loc6_:*;
         if((_loc6_ = param3.indexOf(param2.inside)) in param4)
         {
            param1.inside = param4[_loc6_];
         }
         else if(param2.inside == "Dungeon")
         {
            param1.inside = this._world.dungeon;
         }
         else
         {
            param1.inside = null;
         }
      }
      
      function loadShopkeeper(param1:*, param2:Array, param3:Array) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:Shopkeeper = null;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc4_:* = 0;
         while(_loc4_ < param1.shopkeeperList.length)
         {
            _loc5_ = param1.shopkeeperList[_loc4_];
            _loc6_ = new Shopkeeper();
            this.loadAsHuman(_loc6_,_loc5_,param2,param3);
            _loc6_.model = _loc5_.model;
            (_loc7_ = new HumanStat()).stamina = _loc5_.stat.stamina;
            _loc7_.hygine = _loc5_.stat.hygine;
            _loc7_.entertain = _loc5_.stat.entertain;
            _loc7_.sight = _loc5_.stat.sight;
            _loc7_.speed = _loc5_.stat.speed;
            _loc6_.stat = _loc7_;
            if((_loc8_ = param2.indexOf(_loc5_.boothInCharge)) in param3)
            {
               (_loc9_ = param3[_loc8_]).shopkeeperList.push(_loc6_);
               _loc6_.boothInAction = _loc9_;
               if((_loc10_ = _loc9_.shopkeeperList.indexOf(_loc6_)) in _loc9_.employeeInPosition)
               {
                  _loc9_.employeeInPosition[_loc10_] = _loc5_.inPosition;
                  if(_loc9_.employeeInPosition[_loc10_])
                  {
                     _loc9_.employeeClipList[_loc10_].visible = true;
                     _loc6_.visible = false;
                  }
               }
               if(_loc5_.absense)
               {
                  _loc9_.shopkeeperAbsense.push(_loc6_);
               }
               if(_loc9_ is BoothColloseum)
               {
                  _loc9_.openCloseCheck();
               }
               else
               {
                  _loc9_.open = _loc9_.shopkeeperAbsense.length > 0;
               }
            }
            this._world.humanList.push(_loc6_);
            _loc4_++;
         }
      }
      
      function loadStaff(param1:*, param2:Array, param3:Array) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         for(_loc4_ in param1.staff)
         {
            if(_loc4_ in this._staffList)
            {
               this._staffList[_loc4_] = new Array();
               _loc5_ = 0;
               while(_loc5_ < param1.staff[_loc4_].length)
               {
                  _loc6_ = param1.staff[_loc4_][_loc5_];
                  _loc7_ = null;
                  switch(_loc4_)
                  {
                     case "janitor":
                        _loc7_ = new StaffJanitor();
                        break;
                     case "handyman":
                        _loc7_ = new StaffHandyman();
                        break;
                     case "entertainer":
                        _loc7_ = new StaffEntertainer();
                        break;
                     case "guard":
                        _loc7_ = new StaffGuard();
                        break;
                  }
                  if(_loc7_ != null)
                  {
                     if(_loc6_.guardPost != null)
                     {
                        if((_loc9_ = param2.indexOf(_loc6_.guardPost)) in param3)
                        {
                           _loc7_.guardPost = param3[_loc9_];
                           if(_loc7_.guardPost != null)
                           {
                              _loc7_.guardPost.guardTakeCare = _loc7_;
                              this._staffList.unshown.push(_loc7_);
                           }
                        }
                     }
                     this.loadAsHuman(_loc7_,_loc6_,param2,param3);
                     (_loc8_ = new HumanStat()).stamina = _loc6_.stat.stamina;
                     _loc8_.hygine = _loc6_.stat.hygine;
                     _loc8_.entertain = _loc6_.stat.entertain;
                     _loc8_.sight = _loc6_.stat.sight;
                     _loc8_.speed = _loc6_.stat.speed;
                     _loc8_.characterName = _loc6_.stat.characterName;
                     _loc7_.stat = _loc8_;
                     _loc7_.level = _loc6_.level;
                     _loc7_.workTime.workStart = _loc6_.workTime.workStart;
                     _loc7_.workTime.workEnd = _loc6_.workTime.workEnd;
                     if(_loc6_.workFloor != null)
                     {
                        if(_loc6_.workFloor in this._world.floorList)
                        {
                           _loc7_.workFloor = this._world.floorList[_loc6_.workFloor];
                        }
                        else
                        {
                           _loc7_.workFloor = null;
                        }
                     }
                     else
                     {
                        _loc7_.workFloor = null;
                     }
                     _loc7_.loadCondition(_loc6_);
                     _loc7_.basicPayment = _loc6_.basicPayment;
                     this._staffList[_loc4_].push(_loc7_);
                     this._world.humanList.push(_loc7_);
                  }
                  _loc5_++;
               }
            }
         }
      }
      
      function loadSpecialVisitor(param1:*, param2:Array) : Array
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc3_:* = new Array();
         var _loc4_:* = 0;
         while(_loc4_ < param1.specialVisitorList.length)
         {
            _loc5_ = param1.specialVisitorList[_loc4_];
            if((_loc6_ = this._world.getSpecialVisitorByCode(_loc5_.codeName)) != null)
            {
               _loc6_.loadStatus(_loc5_);
               param2.push(_loc5_.codeName);
               _loc3_.push(_loc6_);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      function loadVisitor(param1:*, param2:Array, param3:Array) : void
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc4_:* = new Array();
         var _loc5_:* = this.loadSpecialVisitor(param1,_loc4_);
         var _loc6_:* = 0;
         while(_loc6_ < param1.visitorList.length)
         {
            _loc7_ = param1.visitorList[_loc6_];
            _loc8_ = null;
            if(!_loc7_.isSpecial)
            {
               _loc8_ = new Visitor();
               (_loc9_ = new HumanStat()).stamina = _loc7_.stat.stamina;
               _loc9_.hygine = _loc7_.stat.hygine;
               _loc9_.entertain = _loc7_.stat.entertain;
               _loc9_.sight = _loc7_.stat.sight;
               _loc9_.speed = _loc7_.stat.speed;
               _loc9_.characterName = _loc7_.stat.characterName;
               _loc8_.stat = _loc9_;
               _loc8_.model = _loc7_.model;
            }
            else if((_loc10_ = _loc4_.indexOf(_loc7_.codeName)) in _loc5_)
            {
               (_loc8_ = _loc5_[_loc10_]).hasCome = true;
            }
            if(_loc8_ != null)
            {
               this.loadAsHuman(_loc8_,_loc7_,param2,param3);
               _loc8_.loadCondition(_loc7_);
               if((_loc11_ = param2.indexOf(_loc7_.restRoomTarget)) in param3)
               {
                  _loc8_.restroomTarget = param3[_loc11_];
               }
               if((_loc12_ = param2.indexOf(_loc7_.tradingPostTarget)) in param3)
               {
                  _loc8_.tradingPostTarget = param3[_loc12_];
               }
               if((_loc13_ = param2.indexOf(_loc7_.stayingAt)) in param3)
               {
                  _loc8_.stayingAt = param3[_loc13_];
               }
               this._world.currentVisitorList.push(_loc8_);
               this._world.humanList.push(_loc8_);
            }
            _loc6_++;
         }
      }
      
      function loadThief(param1:*, param2:Array, param3:Array) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc4_:* = 0;
         while(_loc4_ < param1.thiefList.length)
         {
            _loc5_ = param1.thiefList[_loc4_];
            _loc6_ = new Thief();
            (_loc7_ = new HumanStat()).stamina = _loc5_.stat.stamina;
            _loc7_.hygine = _loc5_.stat.hygine;
            _loc7_.entertain = _loc5_.stat.entertain;
            _loc7_.sight = _loc5_.stat.sight;
            _loc7_.speed = _loc5_.stat.speed;
            _loc6_.stat = _loc7_;
            this.loadAsHuman(_loc6_,_loc5_,param2,param3);
            _loc6_.loadCondition(_loc5_);
            _loc8_ = 0;
            while(_loc8_ < _loc5_.stolenTarget.length)
            {
               if((_loc10_ = param2.indexOf(_loc5_.stolenTarget[_loc8_])) in param3)
               {
                  _loc6_.stolenTarget.push(param3[_loc10_]);
               }
               _loc8_++;
            }
            if((_loc9_ = param2.indexOf(_loc5_.currentTargetSteal)) in param3)
            {
               _loc6_.currentTargetSteal = param3[_loc9_];
            }
            if(_loc6_.inside == _loc6_.currentTargetSteal)
            {
               _loc6_.visible = false;
            }
            if(_loc6_.isCaught)
            {
               this._budget += _loc6_.bounty;
               _loc11_ = _loc6_.bounty;
               if(this._currentStatistic.miscStat.expenditure > _loc11_)
               {
                  this._currentStatistic.miscStat.expenditure -= _loc11_;
               }
               else
               {
                  _loc12_ = _loc11_ - this._currentStatistic.miscStat.expenditure;
                  this._currentStatistic.miscStat.expenditure = 0;
                  this._currentStatistic.miscStat.revenue += _loc12_;
               }
            }
            else
            {
               this._world.thiefList.push(_loc6_);
               this._world.humanList.push(_loc6_);
            }
            _loc4_++;
         }
      }
      
      function loadLitter(param1:*, param2:Array, param3:Array) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc4_:* = 0;
         while(_loc4_ < param1.litterList.length)
         {
            _loc5_ = param1.litterList[_loc4_];
            _loc6_ = new Litter();
            (_loc7_ = new HumanStat()).stamina = _loc5_.stat.stamina;
            _loc7_.hygine = _loc5_.stat.hygine;
            _loc7_.entertain = _loc5_.stat.entertain;
            _loc7_.sight = _loc5_.stat.sight;
            _loc7_.speed = _loc5_.stat.speed;
            _loc6_.stat = _loc7_;
            this.loadAsHuman(_loc6_,_loc5_,param2,param3);
            _loc6_.loadCondition(_loc5_);
            if(!_loc6_.isCaught)
            {
               this._world.litterList.push(_loc6_);
               this._world.humanList.push(_loc6_);
            }
            _loc4_++;
         }
      }
      
      function loadWizard(param1:*, param2:Array, param3:Array) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc4_:* = 0;
         while(_loc4_ < param1.wizardList.length)
         {
            _loc5_ = param1.wizardList[_loc4_];
            _loc6_ = new Wizard();
            (_loc7_ = new HumanStat()).stamina = _loc5_.stat.stamina;
            _loc7_.hygine = _loc5_.stat.hygine;
            _loc7_.entertain = _loc5_.stat.entertain;
            _loc7_.sight = _loc5_.stat.sight;
            _loc7_.speed = _loc5_.stat.speed;
            _loc6_.stat = _loc7_;
            this.loadAsHuman(_loc6_,_loc5_,param2,param3);
            _loc6_.loadCondition(_loc5_);
            if(!_loc6_.isCaught)
            {
               this._world.wizardList.push(_loc6_);
               this._world.humanList.push(_loc6_);
            }
            _loc4_++;
         }
      }
      
      function loadWatchdog(param1:*, param2:Array, param3:Array) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(param1.watchdog != null)
         {
            _loc4_ = param1.watchdog;
            _loc5_ = new Watchdog();
            _loc6_ = new HumanStat();
            this.loadAsHuman(_loc5_,_loc4_,param2,param3);
            this._world.watchdog = _loc5_;
            this._world.humanList.push(_loc5_);
         }
      }
      
      function saveTheGame(param1:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = new Object();
         _loc2_.saveDate = new Date();
         _loc2_.nameID = this._nameID;
         _loc2_.gameHour = this._gameHour;
         _loc2_.gameMinute = this._gameMinute;
         _loc2_.tutorialPassed = this._tutorial.passed.concat();
         _loc2_.missionPassed = this._mission.currentProgress + (!!this._mission.currentSuccess ? 1 : 0);
         _loc2_.specialCheck = this._mission.specialCheck;
         _loc2_.unlockedBuilding = this._unlockedBuilding.concat();
         _loc2_.newUnlockedBuilding = this._newUnlockedBuilding.concat();
         _loc2_.unlockedUpgrade = this._unlockedUpgrade.concat();
         _loc2_.newUnlockedUpgrade = this._newUnlockedUpgrade.concat();
         _loc2_.unlockedStaff = this._unlockedStaff.concat();
         _loc2_.unlockedHint = this._unlockedHint.concat();
         _loc2_.newUnlockedHint = this._newUnlockedHint.concat();
         _loc2_.budget = this._budget;
         _loc2_.dayPassed = this._dayPassed;
         _loc2_.world = new Object();
         this._world.saveCondition(_loc2_.world);
         _loc2_.gui = new Object();
         this._GUI.saveCondition(_loc2_.gui);
         if(this._history != null)
         {
            _loc2_.history = new Object();
            for(_loc3_ in this._history)
            {
               _loc2_.history[_loc3_] = this._history[_loc3_];
            }
         }
         this.saveApplicants(_loc2_);
         this.saveStatistic(_loc2_);
         this.saveFloorData(_loc2_);
         this.saveBuildingData(_loc2_);
         this.saveShopkeeper(_loc2_);
         this.saveStaff(_loc2_);
         this.saveVisitor(_loc2_);
         this.saveThief(_loc2_);
         this.saveLitter(_loc2_);
         this.saveWizard(_loc2_);
         this.saveWatchDog(_loc2_);
         this.saveTrash(_loc2_);
         this.saveAchievement(_loc2_);
         dispatchEvent(new GameEvent(GameEvent.SAVE_GAME_DATA,{
            "toSave":_loc2_,
            "slot":this._slotIndex,
            "isAuto":param1
         }));
      }
      
      function saveAchievement(param1:*) : void
      {
         param1.achievement = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._achievement.length)
         {
            if(this._achievement[_loc2_].aquired)
            {
               param1.achievement.push(1);
            }
            else if(this._achievementUnlock.indexOf(this._achievement[_loc2_]) < 0)
            {
               param1.achievement.push(0);
            }
            else
            {
               param1.achievement.push(2);
            }
            _loc2_++;
         }
      }
      
      function saveApplicants(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         param1.applicant = new Object();
         param1.applicant.countdown = this._countdownApplicant;
         param1.applicant.minimal = this._minimalNewApplicant;
         param1.applicant.chance = this._chanceToGetApplicant;
         param1.applicant.list = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._applicants.length)
         {
            _loc3_ = this._applicants[_loc2_];
            (_loc4_ = new Object()).stamina = _loc3_.stamina;
            _loc4_.hygine = _loc3_.hygine;
            _loc4_.entertain = _loc3_.entertain;
            _loc4_.sight = _loc3_.sight;
            _loc4_.speed = _loc3_.speed;
            _loc4_.characterName = _loc3_.characterName;
            _loc4_.hireCostDifference = _loc3_.hireCostDifference;
            param1.applicant.list.push(_loc4_);
            _loc2_++;
         }
      }
      
      function saveStatistic(param1:*) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         param1.statistic = new Object();
         var _loc2_:* = this._currentStatistic.saveStatistic();
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.boothStatistic.length)
         {
            if((_loc5_ = _loc2_.boothStatistic[_loc3_].relation) is Building)
            {
               _loc6_ = this.getCodeNameOf(_loc5_);
               _loc2_.boothStatistic[_loc3_].relation = _loc6_;
               if(_loc6_ == null || _loc6_ == "")
               {
                  _loc2_.boothStatistic[_loc3_].relationDestroyed = BuildingData.returnClassTo(Utility.getClass(_loc5_));
               }
            }
            _loc3_++;
         }
         param1.statistic.current = _loc2_;
         var _loc4_:* = this.GUI.statisticPanel.statistic.saveStatistic();
         _loc3_ = 0;
         while(_loc3_ < _loc4_.boothStatistic.length)
         {
            if((_loc5_ = _loc4_.boothStatistic[_loc3_].relation) is Building)
            {
               _loc6_ = this.getCodeNameOf(_loc5_);
               _loc4_.boothStatistic[_loc3_].relation = _loc6_;
               if(_loc6_ == null || _loc6_ == "")
               {
                  _loc4_.boothStatistic[_loc3_].relationDestroyed = BuildingData.returnClassTo(Utility.getClass(_loc5_));
               }
            }
            _loc3_++;
         }
         param1.statistic.past = _loc4_;
      }
      
      function saveShopkeeper(param1:*) : void
      {
         var _loc3_:Booth = null;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         param1.shopkeeperList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.buildingList.length)
         {
            _loc3_ = this._world.buildingList[_loc2_] as Booth;
            if(_loc3_ != null)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.shopkeeperList.length)
               {
                  _loc5_ = _loc3_.shopkeeperList[_loc4_];
                  (_loc6_ = new Object()).model = _loc5_.model;
                  (_loc7_ = new Object()).stamina = _loc5_.stat.stamina;
                  _loc7_.hygine = _loc5_.stat.hygine;
                  _loc7_.entertain = _loc5_.stat.entertain;
                  _loc7_.sight = _loc5_.stat.sight;
                  _loc7_.speed = _loc5_.stat.speed;
                  _loc6_.stat = _loc7_;
                  _loc6_.boothInCharge = this.getCodeNameOf(_loc3_);
                  _loc6_.baseHome = _loc5_.baseHome;
                  if((_loc8_ = _loc3_.shopkeeperList.indexOf(_loc5_)) in _loc3_.employeeInPosition)
                  {
                     _loc6_.inPosition = _loc3_.employeeInPosition[_loc8_];
                  }
                  else
                  {
                     _loc6_.inPosition = false;
                  }
                  _loc6_.absense = _loc3_.shopkeeperAbsense.indexOf(_loc5_) >= 0;
                  this.saveAsHuman(_loc5_,_loc6_);
                  param1.shopkeeperList.push(_loc6_);
                  _loc4_++;
               }
            }
            _loc2_++;
         }
      }
      
      function saveStaff(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         param1.staff = new Object();
         for(_loc2_ in this._staffList)
         {
            if(_loc2_ != "unshown")
            {
               param1.staff[_loc2_] = new Array();
               _loc3_ = 0;
               while(_loc3_ < this._staffList[_loc2_].length)
               {
                  _loc4_ = this._staffList[_loc2_][_loc3_];
                  _loc5_ = new Object();
                  (_loc6_ = new Object()).stamina = _loc4_.stat.stamina;
                  _loc6_.hygine = _loc4_.stat.hygine;
                  _loc6_.entertain = _loc4_.stat.entertain;
                  _loc6_.sight = _loc4_.stat.sight;
                  _loc6_.speed = _loc4_.stat.speed;
                  _loc6_.characterName = _loc4_.stat.characterName;
                  _loc5_.stat = _loc6_;
                  _loc5_.level = _loc4_.level;
                  (_loc7_ = new Object()).workStart = _loc4_.workTime.workStart;
                  _loc7_.workEnd = _loc4_.workTime.workEnd;
                  _loc5_.workTime = _loc7_;
                  _loc5_.workFloor = _loc4_.workFloor != null ? this._world.floorList.indexOf(_loc4_.workFloor) : null;
                  _loc4_.saveCondition(_loc5_);
                  _loc5_.basicPayment = _loc4_.basicPayment;
                  this.saveAsHuman(_loc4_,_loc5_);
                  param1.staff[_loc2_].push(_loc5_);
                  _loc3_++;
               }
            }
         }
      }
      
      function saveSpecialVisitor(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         param1.specialVisitorList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.specialVisitorList.length)
         {
            _loc3_ = this._world.specialVisitorList[_loc2_];
            (_loc4_ = new Object()).codeName = _loc3_.codeName;
            _loc3_.saveStatus(_loc4_);
            param1.specialVisitorList.push(_loc4_);
            _loc2_++;
         }
      }
      
      function saveVisitor(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this.saveSpecialVisitor(param1);
         param1.visitorList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.currentVisitorList.length)
         {
            _loc3_ = this._world.currentVisitorList[_loc2_];
            _loc4_ = new Object();
            if(!(_loc3_ is SpecialVisitor))
            {
               (_loc5_ = new Object()).stamina = _loc3_.stat.stamina;
               _loc5_.hygine = _loc3_.stat.hygine;
               _loc5_.entertain = _loc3_.stat.entertain;
               _loc5_.sight = _loc3_.stat.sight;
               _loc5_.speed = _loc3_.stat.speed;
               _loc5_.characterName = _loc3_.stat.characterName;
               _loc4_.stat = _loc5_;
               _loc4_.isSpecial = false;
               _loc4_.model = _loc3_.model;
            }
            else
            {
               _loc4_.isSpecial = true;
               _loc4_.codeName = _loc3_.codeName;
            }
            _loc4_.restroomTarget = this.getCodeNameOf(_loc3_.restRoomTarget);
            _loc4_.tradingPostTarget = this.getCodeNameOf(_loc3_.tradingPostTarget);
            _loc4_.stayingAt = this.getCodeNameOf(_loc3_.stayingAt);
            _loc3_.saveCondition(_loc4_);
            this.saveAsHuman(_loc3_,_loc4_);
            param1.visitorList.push(_loc4_);
            _loc2_++;
         }
      }
      
      function saveThief(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         param1.thiefList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.thiefList.length)
         {
            _loc3_ = this._world.thiefList[_loc2_];
            _loc4_ = new Object();
            (_loc5_ = new Object()).stamina = _loc3_.stat.stamina;
            _loc5_.hygine = _loc3_.stat.hygine;
            _loc5_.entertain = _loc3_.stat.entertain;
            _loc5_.sight = _loc3_.stat.sight;
            _loc5_.speed = _loc3_.stat.speed;
            _loc4_.stat = _loc5_;
            _loc3_.saveCondition(_loc4_);
            _loc4_.stolenTarget = new Array();
            _loc6_ = 0;
            while(_loc6_ < _loc3_.stolenTarget.length)
            {
               _loc4_.stolenTarget.push(this.getCodeNameOf(_loc3_.stolenTarget[_loc6_]));
               _loc6_++;
            }
            _loc4_.currentTargetSteal = this.getCodeNameOf(_loc3_.currentTargetSteal);
            this.saveAsHuman(_loc3_,_loc4_);
            param1.thiefList.push(_loc4_);
            _loc2_++;
         }
      }
      
      function saveLitter(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         param1.litterList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.litterList.length)
         {
            _loc3_ = this._world.litterList[_loc2_];
            _loc4_ = new Object();
            (_loc5_ = new Object()).stamina = _loc3_.stat.stamina;
            _loc5_.hygine = _loc3_.stat.hygine;
            _loc5_.entertain = _loc3_.stat.entertain;
            _loc5_.sight = _loc3_.stat.sight;
            _loc5_.speed = _loc3_.stat.speed;
            _loc4_.stat = _loc5_;
            _loc3_.saveCondition(_loc4_);
            this.saveAsHuman(_loc3_,_loc4_);
            param1.litterList.push(_loc4_);
            _loc2_++;
         }
      }
      
      function saveWizard(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         param1.wizardList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.wizardList.length)
         {
            _loc3_ = this._world.wizardList[_loc2_];
            _loc4_ = new Object();
            (_loc5_ = new Object()).stamina = _loc3_.stat.stamina;
            _loc5_.hygine = _loc3_.stat.hygine;
            _loc5_.entertain = _loc3_.stat.entertain;
            _loc5_.sight = _loc3_.stat.sight;
            _loc5_.speed = _loc3_.stat.speed;
            _loc4_.stat = _loc5_;
            _loc3_.saveCondition(_loc4_);
            this.saveAsHuman(_loc3_,_loc4_);
            param1.wizardList.push(_loc4_);
            _loc2_++;
         }
      }
      
      function saveWatchDog(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this._world.watchdog != null)
         {
            _loc2_ = this._world.watchdog;
            _loc3_ = new Object();
            _loc4_ = new Object();
            this.saveAsHuman(_loc2_,_loc3_);
            param1.watchdog = _loc3_;
         }
      }
      
      function saveAsHuman(param1:*, param2:*) : void
      {
         param2.coordinate = new Point(param1.x,param1.y);
         param2.dirrection = param1.scaleX;
         param2.inside = this.getCodeNameOf(param1.inside);
         param2.baseHome = param1.baseHome;
         param2.destination = param1.destination is Building ? this.getCodeNameOf(param1.destination) : (param1.destination is String ? param1.destination : null);
         param2.inHome = param1.inHome;
      }
      
      function saveTrash(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         param1.trashList = new Array();
         param1.pupList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.trashList.length)
         {
            _loc3_ = this._world.trashList[_loc2_];
            (_loc4_ = new Object()).coordinate = new Point(_loc3_.x,_loc3_.y);
            _loc4_.dirtyLevel = _loc3_.dirtyLevel;
            param1.trashList.push(_loc4_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._world.pupList.length)
         {
            _loc5_ = this._world.pupList[_loc2_];
            (_loc6_ = new Object()).coordinate = new Point(_loc5_.x,_loc5_.y);
            _loc6_.dirtyLevel = _loc5_.dirtyLevel;
            param1.pupList.push(_loc6_);
            _loc2_++;
         }
      }
      
      function saveFloorData(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         param1.floorList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.floorList.length)
         {
            if(_loc2_ != 0)
            {
               _loc3_ = this._world.floorList[_loc2_];
               (_loc4_ = new Object()).posY = _loc3_.y;
               _loc4_.left = _loc3_.left;
               _loc4_.right = _loc3_.right;
               param1.floorList.push(_loc4_);
            }
            _loc2_++;
         }
         param1.basementFloorList = new Array();
         _loc2_ = 0;
         while(_loc2_ < this._world.basementFloorList.length)
         {
            _loc5_ = this._world.basementFloorList[_loc2_];
            (_loc6_ = new Object()).posY = _loc5_.y;
            _loc6_.left = _loc5_.left;
            _loc6_.right = _loc5_.right;
            param1.basementFloorList.push(_loc6_);
            _loc2_++;
         }
         param1.columnList = new Array();
         _loc2_ = 0;
         while(_loc2_ < this._world.columnList.length)
         {
            _loc7_ = this._world.columnList[_loc2_];
            (_loc8_ = new Object()).coordinate = new Point(_loc7_.x,_loc7_.y);
            _loc8_.model = _loc7_.currentFrame;
            param1.columnList.push(_loc8_);
            _loc2_++;
         }
      }
      
      function saveBuildingData(param1:*) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         param1.buildingList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.buildingList.length)
         {
            _loc7_ = new Object();
            _loc8_ = this._world.buildingList[_loc2_];
            _loc9_ = this.getCodeNameOf(_loc8_);
            _loc10_ = "";
            if(_loc8_ is BuildingInnEnterance)
            {
               _loc10_ = "Enterance";
               _loc9_ = "Enterance";
            }
            else if(_loc8_ is BuildingInnConnection)
            {
               _loc10_ = "Connection";
            }
            else if(_loc8_ is HalteWagon)
            {
               _loc10_ = "HalteWagon";
            }
            else
            {
               _loc10_ = BuildingData.returnClassTo(Utility.getClass(_loc8_));
            }
            _loc8_.saveCondition(_loc7_);
            _loc7_.codeName = _loc9_;
            _loc7_.type = _loc10_;
            _loc7_.coordinate = new Point(_loc8_.x,_loc8_.y);
            _loc7_.level = _loc8_.level;
            _loc7_.exp = _loc8_.expSave;
            param1.buildingList.push(_loc7_);
            _loc2_++;
         }
         param1.halte = this.getCodeNameOf(this._world.halte);
         param1.connectionSurface = this.getCodeNameOf(this._world.connectionSurface);
         param1.dungeonConnection = new Array();
         param1.boothList = new Array();
         param1.restRoomList = new Array();
         param1.innList = new Array();
         param1.tradingPostList = new Array();
         param1.terraceList = new Array();
         param1.brokableBuildingList = new Array();
         param1.guardPostList = new Array();
         param1.transportList = new Array();
         param1.onInfoBuildingList = new Array();
         var _loc3_:* = [param1.dungeonConnection,param1.boothList,param1.restRoomList,param1.innList,param1.tradingPostList,param1.terraceList,param1.brokableBuildingList,param1.guardPostList,param1.transportList,param1.onInfoBuildingList];
         var _loc4_:* = [this._world.dungeonConnection,this._world.boothList,this._world.restRoomList,this._world.innList,this._world.tradingPostList,this._world.terraceList,this._world.brokableBuildingList,this._world.guardPostList,this._world.transportList,this._world.onInfoBuildingList];
         param1.boothListByType = new Object();
         for(_loc5_ in this._world.boothListByType)
         {
            param1.boothListByType[_loc5_] = new Array();
            _loc3_.push(param1.boothListByType[_loc5_]);
            _loc4_.push(this._world.boothListByType[_loc5_]);
         }
         _loc6_ = 0;
         while(_loc6_ < _loc4_.length)
         {
            if(_loc6_ in _loc3_)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc4_[_loc6_].length)
               {
                  _loc3_[_loc6_].push(this.getCodeNameOf(_loc4_[_loc6_][_loc2_]));
                  _loc2_++;
               }
            }
            _loc6_++;
         }
         this.saveElevatorData(param1);
         this.saveStairData(param1);
      }
      
      function saveElevatorData(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         param1.elevatorList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.elevatorList.length)
         {
            _loc3_ = this._world.elevatorList[_loc2_];
            (_loc4_ = new Object()).codeName = this.getCodeNameOf(_loc3_);
            _loc4_.posX = _loc3_.x;
            _loc4_.bodyList = new Array();
            _loc5_ = 0;
            while(_loc5_ < _loc3_.bodyList.length)
            {
               _loc6_ = _loc3_.bodyList[_loc5_];
               _loc4_.bodyList.push(this.getCodeNameOf(_loc6_));
               _loc5_++;
            }
            _loc4_.roomTarget = new Array();
            _loc5_ = 0;
            while(_loc5_ < _loc3_.roomTarget.length)
            {
               _loc7_ = _loc3_.roomTarget[_loc5_];
               _loc4_.roomTarget.push(this.getCodeNameOf(_loc7_));
               _loc5_++;
            }
            _loc4_.bodyTarget = _loc3_.bodyTarget;
            _loc4_.level = _loc3_.level;
            _loc4_.exp = _loc3_.expSave;
            param1.elevatorList.push(_loc4_);
            _loc2_++;
         }
      }
      
      function saveStairData(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         param1.stairList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.stairList.length)
         {
            _loc3_ = this._world.stairList[_loc2_];
            (_loc4_ = new Object()).codeName = this.getCodeNameOf(_loc3_);
            _loc4_.coordinate = new Point(_loc3_.x,_loc3_.y);
            _loc4_.swapped = _loc3_.scaleX != 1;
            param1.stairList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function getCodeNameOf(param1:*) : String
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
         if(param1 != null)
         {
            _loc2_ = "";
            if(param1 is BuildingInnEnterance)
            {
               _loc2_ = "Enterance";
            }
            else if(param1 is BuildingInnConnection)
            {
               _loc3_ = this._world.basementFloorList.indexOf(this._world.getBasementFloorAt(param1.y));
               _loc2_ = "Connection#" + _loc3_;
            }
            else if(param1 is HalteWagon)
            {
               _loc2_ = "HalteWagon";
            }
            else if(param1 is Wagon)
            {
               if(param1.halte != null)
               {
                  _loc2_ = "HalteWagon#Carriage";
               }
            }
            else if(param1 is Elevator)
            {
               _loc2_ = "Elevator#" + this._world.elevatorList.indexOf(param1);
            }
            else if(param1 is InsideRestroom)
            {
               _loc4_ = param1.relatedRestroom;
               _loc5_ = this.getCodeNameOf(param1.relatedRestroom);
               if(param1 == _loc4_.maleRoom)
               {
                  _loc2_ = _loc5_ + "_ManRoom";
               }
               else if(param1 == _loc4_.femaleRoom)
               {
                  _loc2_ = _loc5_ + "_WomanRoom";
               }
            }
            else if(param1 is FictionalBuilding)
            {
               _loc6_ = param1.related;
               if((_loc7_ = this.getCodeNameOf(_loc6_)) != null)
               {
                  _loc2_ = _loc7_ + "_Inside";
               }
            }
            else if(param1 == this._world.dungeon)
            {
               _loc2_ = "Dungeon";
            }
            else if((_loc8_ = BuildingData.returnClassTo(Utility.getClass(param1))) in this._world.boothListByType)
            {
               if((_loc9_ = this._world.boothListByType[_loc8_].indexOf(param1)) in this._world.boothListByType[_loc8_])
               {
                  _loc2_ = _loc8_ + "#" + (_loc9_ + 1);
               }
            }
            else if(param1 is FacilityElevatorBody)
            {
               _loc10_ = this._world.elevatorList.indexOf(param1.elevatorLink);
               _loc11_ = param1.elevatorLink.bodyList.indexOf(param1);
               _loc2_ = _loc8_ + "#" + _loc10_ + "-" + _loc11_;
            }
            else if(this._world.innList.indexOf(param1) >= 0)
            {
               _loc2_ = _loc8_ + "#" + this._world.innList.indexOf(param1);
            }
            else if(this._world.restRoomList.indexOf(param1) >= 0)
            {
               _loc2_ = _loc8_ + "#" + this._world.restRoomList.indexOf(param1);
            }
            else if(this._world.tradingPostList.indexOf(param1) >= 0)
            {
               _loc2_ = _loc8_ + "#" + this._world.tradingPostList.indexOf(param1);
            }
            else if(this._world.terraceList.indexOf(param1) >= 0)
            {
               _loc2_ = _loc8_ + "#" + this._world.terraceList.indexOf(param1);
            }
            else if(this._world.guardPostList.indexOf(param1) >= 0)
            {
               _loc2_ = _loc8_ + "#" + this._world.guardPostList.indexOf(param1);
            }
            else if(this._world.stairList.indexOf(param1) >= 0)
            {
               _loc2_ = _loc8_ + "#" + this._world.stairList.indexOf(param1);
            }
            return _loc2_;
         }
         return null;
      }
      
      function removeApplicant(param1:CommandEvent) : void
      {
         var _loc2_:* = param1.tag;
         var _loc3_:* = this._applicants.indexOf(_loc2_);
         if(_loc3_ in this._applicants)
         {
            this._applicants.splice(_loc3_,1);
            dispatchEvent(new GameEvent(GameEvent.LOST_APPLICANT));
         }
      }
      
      function whenConversationAdded(param1:GameEvent) : void
      {
         var _loc7_:* = undefined;
         var _loc2_:* = param1.target;
         var _loc3_:* = param1.tag;
         _loc3_ = _loc3_.replace(/\n/g," ");
         var _loc4_:* = this._gameHour > 12 ? this._gameHour - 12 : this._gameHour;
         var _loc5_:* = (String(_loc4_).length > 1 ? "" : "0") + _loc4_ + ":" + (String(this._gameMinute).length > 1 ? "" : "0") + this._gameMinute + " " + (this._gameHour >= 12 ? "PM" : "AM");
         var _loc6_:* = {
            "speakerName":_loc2_.characterName,
            "model":_loc2_.model,
            "modelPos":0,
            "chatText":_loc3_,
            "timeInfo":_loc5_,
            "dayTime":this._dayPassed
         };
         if(this._chatLog.length > 0)
         {
            if((_loc7_ = this._chatLog[this._chatLog.length - 1]).modelPos == 0)
            {
               if(_loc7_.dayTime == _loc6_.dayTime)
               {
                  _loc6_.modelPos = 1;
               }
            }
         }
         this._chatLog.push(_loc6_);
         while(this._chatLog.length >= 50)
         {
            this._chatLog.shift();
         }
         this.GUI.chatLogPanel.chatLog = this._chatLog.concat().reverse();
      }
      
      function checkDialogAdded(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ is InformationPopUpBuilding)
         {
            if(this._budget < _loc2_.price)
            {
               _loc2_.priceInfo.textColor = ColorCode.MINUS_CASH;
            }
            else
            {
               _loc2_.priceInfo.textColor = ColorCode.VALID_CASH;
            }
         }
      }
      
      function checkNotification(param1:GameEvent) : void
      {
         this.showNotification(param1.tag);
         dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Notification));
      }
      
      function checkNotificationMute(param1:GameEvent) : void
      {
         this.showNotification(param1.tag);
      }
      
      function staffHired(param1:GameEvent) : void
      {
         var _loc2_:* = param1.tag;
         if(_loc2_ is StaffJanitor)
         {
            this._staffList.janitor.push(_loc2_);
         }
         if(_loc2_ is StaffHandyman)
         {
            this._staffList.handyman.push(_loc2_);
         }
         if(_loc2_ is StaffEntertainer)
         {
            this._staffList.entertainer.push(_loc2_);
         }
         if(_loc2_ is StaffGuard)
         {
            this._staffList.guard.push(_loc2_);
         }
         var _loc3_:* = this._applicants.indexOf(_loc2_.stat);
         if(_loc3_ in this._applicants)
         {
            this._applicants.splice(_loc3_,1);
         }
         this.updateNumberStaff();
         this._GUI.hirePanel.updateTabIcon();
      }
      
      function updateNumberStaff() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         for(_loc2_ in this._staffList)
         {
            if(_loc2_ != "unshown")
            {
               _loc1_ += this._staffList[_loc2_].length;
            }
            else
            {
               _loc1_ -= this._staffList[_loc2_].length;
            }
         }
         this._GUI.setNumberStaff(_loc1_);
      }
      
      function staffFired(param1:GameEvent) : void
      {
         this.updateNumberStaff();
         var _loc2_:* = 0;
      }
      
      function updateBuildingData(param1:GameEvent) : void
      {
         var _loc2_:* = 0;
         _loc2_ = this._world.onInfoBuildingList.length - 1;
         this._GUI.setNumberBuilding(_loc2_);
      }
      
      function updatePopularity(param1:GameEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         this._GUI.changePopularity(this._world.popularity);
         if(!("popularity" in this._history))
         {
            this._history["popularity"] = 0;
         }
         this._history["popularity"] = Math.max(this._world.popularity,this._history["popularity"]);
         var _loc2_:* = new Array();
         var _loc3_:* = Infinity;
         var _loc4_:* = 0;
         while(_loc4_ < BuildingData.BUILDING_LIST.length)
         {
            _loc5_ = BuildingData.BUILDING_LIST[_loc4_];
            if(this._unlockedBuilding.indexOf(_loc5_) < 0)
            {
               if((_loc6_ = BuildingData.getPopularityUnlock(_loc5_)) > 0)
               {
                  if(this._history["popularity"] >= _loc6_)
                  {
                     if(_loc3_ >= _loc6_)
                     {
                        if(_loc3_ > _loc6_)
                        {
                           _loc2_ = new Array();
                        }
                        _loc2_.push(_loc5_);
                        _loc3_ = _loc6_;
                     }
                  }
               }
            }
            _loc4_++;
         }
         if(_loc2_.length > 0)
         {
            this.unlockBuildReward(_loc2_);
         }
         if(this._history["popularity"] >= 10)
         {
            if(this._enablePlayBGM.indexOf(BGMData.CELTIC_2) < 0)
            {
               this._enablePlayBGM.push(BGMData.CELTIC_2);
            }
         }
         if(this._history["popularity"] >= 20)
         {
            if(this._enableRainBGM.indexOf(BGMData.SKYE_CUILLIN) < 0)
            {
               this._enableRainBGM.push(BGMData.SKYE_CUILLIN);
            }
         }
         if(this._history["popularity"] >= 30)
         {
            if(this._enablePlayBGM.indexOf(BGMData.CELTIC_3) < 0)
            {
               this._enablePlayBGM.push(BGMData.CELTIC_3);
            }
         }
         dispatchEvent(new AchievementEvent(AchievementEvent.UPDATE_HISTORY,"popularity"));
      }
      
      function selectBooth(param1:CommandEvent) : void
      {
         if(this._world.buildProgress == null)
         {
            this._GUI.showBoothData(param1.target);
         }
      }
      
      function selectElevator(param1:CommandEvent) : void
      {
         if(this._world.buildProgress == null)
         {
            this._GUI.showElevatorData(param1.target);
         }
      }
      
      function selectHalte(param1:CommandEvent) : void
      {
         if(this._world.buildProgress == null)
         {
            this._GUI.showHalteData(param1.target);
         }
      }
      
      function selectHuman(param1:CommandEvent) : void
      {
         if(this._world.buildProgress == null)
         {
            if(param1.target != this._humanFocus)
            {
               if(this._GUI.showHumanData(param1.target))
               {
                  this._humanFocus = param1.target;
               }
            }
         }
      }
      
      function whenHumanFocusLost(param1:GameEvent) : void
      {
         this._humanFocus = null;
      }
      
      function changeSpeed(param1:CommandEvent) : void
      {
         if(param1.tag != null)
         {
            this._gameSpeed = param1.tag;
         }
         if(this._tutorial.inProgress || this._menuAppear)
         {
            this._world.gameSpeed = 0;
            this.currentTween.pause();
         }
         else
         {
            this._world.gameSpeed = this._gameSpeed;
            if(this._gameSpeed > 0)
            {
               this.currentTween.resume();
               this.currentTween.duration = 0.1 * (1 / this._gameSpeed);
            }
            else
            {
               this.currentTween.pause();
            }
         }
      }
      
      public function cashReward(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1 is Number)
         {
            _loc2_ = param1;
            _loc3_ = this.globalToLocal(this.GUI.rewardPanel.localToGlobal(new Point(0,0)));
            this._currentStatistic.miscStat.revenue += _loc2_;
            this.showGainMoney(_loc2_,this,_loc3_);
            this._budget += _loc2_;
            dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
         }
      }
      
      public function unlockBuildReward(param1:*) : void
      {
         var notificationNewBuild:* = undefined;
         var makeClickable:Function = null;
         var i:* = undefined;
         var toUnlock:* = undefined;
         var reward:* = param1;
         makeClickable = function():void
         {
            notificationNewBuild.mouseEnabled = true;
            notificationNewBuild.mouseChildren = true;
         };
         notificationNewBuild = new UI_NotificationNewBuild();
         if(reward is Array)
         {
            i = 0;
            while(i < reward.length)
            {
               toUnlock = reward[i];
               if(this._unlockedBuilding.indexOf(toUnlock) < 0)
               {
                  notificationNewBuild.toShown.push(toUnlock);
                  this._unlockedBuilding.push(toUnlock);
                  if(this._newUnlockedBuilding.indexOf(toUnlock) < 0)
                  {
                     this._newUnlockedBuilding.push(toUnlock);
                  }
               }
               i++;
            }
         }
         else if(reward is String)
         {
            if(this._unlockedBuilding.indexOf(reward) < 0)
            {
               notificationNewBuild.toShown.push(reward);
               this._unlockedBuilding.push(reward);
               if(this._newUnlockedBuilding.push(toUnlock))
               {
                  this._newUnlockedBuilding.push(toUnlock);
               }
            }
         }
         var pPos:* = this.globalToLocal(this.GUI.rewardPanel.localToGlobal(new Point(0,0)));
         notificationNewBuild.x = pPos.x;
         notificationNewBuild.y = pPos.y;
         notificationNewBuild.alpha = 0;
         notificationNewBuild.scaleX = 0;
         notificationNewBuild.scaleY = 0;
         notificationNewBuild.mouseEnabled = false;
         notificationNewBuild.mouseChildren = false;
         addChild(notificationNewBuild);
         var diffX:* = pPos.x - 350;
         TweenMax.to(notificationNewBuild,0.8,{
            "bezierThrough":[{
               "x":350 + diffX,
               "y":200
            },{
               "x":350,
               "y":250
            }],
            "scaleX":1,
            "scaleY":1,
            "alpha":0.8,
            "onComplete":makeClickable
         });
         dispatchEvent(new GameEvent(GameEvent.UNLOCK_NEW_BUILDING));
      }
      
      function unlockUpgradeReward(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1 is Array)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.length)
            {
               _loc3_ = param1[_loc2_];
               if(this._unlockedUpgrade.indexOf(_loc3_) < 0)
               {
                  this._unlockedUpgrade.push(_loc3_);
                  if(this._newUnlockedUpgrade.indexOf(_loc3_) < 0)
                  {
                     this._newUnlockedUpgrade.push(_loc3_);
                  }
               }
               _loc2_++;
            }
         }
         else if(param1 is String)
         {
            if(this._unlockedUpgrade.indexOf(param1) < 0)
            {
               this._unlockedUpgrade.push(param1);
               if(this._newUnlockedUpgrade.indexOf(param1) < 0)
               {
                  this._unlockedUpgrade.push(param1);
               }
            }
         }
         dispatchEvent(new GameEvent(GameEvent.UNLOCK_NEW_UPGRADE));
         dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"New Upgrade Available"));
      }
      
      function buildingExpBonus(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(param1 is Number)
         {
            _loc2_ = this._world.buildingList.concat(this._world.elevatorList);
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               if(!((_loc4_ = _loc2_[_loc3_]) is FacilityElevatorBody))
               {
                  if(_loc4_.maxLevel > 1)
                  {
                     _loc5_ = _loc4_.toNextLevel;
                     _loc6_ = new Point(_loc4_.x,_loc4_.y - 64);
                     this.showFlyingText("Exp +5%",ColorCode.REQUIREMENT_COLOR,this._world.bonusContainer,_loc6_);
                     _loc7_ = Math.round(_loc5_ * 5 / 100);
                     _loc4_.gainExp(_loc7_);
                  }
               }
               _loc3_++;
            }
         }
      }
      
      function popularityBonus(param1:*) : void
      {
         var _loc2_:* = undefined;
         if(param1 is Number)
         {
            this._world.addPopularity(param1);
            _loc2_ = this.globalToLocal(this.GUI.localToGlobal(new Point(this.GUI.popularityValue.x - 12,this.GUI.popularityValue.y - 10)));
            this.showFlyingText("Popularity +" + param1 + "%",14951365,this,_loc2_,0.5);
         }
      }
      
      function worldExpand() : void
      {
         this._world.expandArea();
      }
      
      function finalReward() : void
      {
         var banner:* = undefined;
         var setBannerDismiss:Function = null;
         setBannerDismiss = function():void
         {
            TweenLite.to(banner,1.2,{
               "delay":3.5,
               "scaleX":0,
               "scaleY":0,
               "onComplete":removeChild,
               "onCompleteParams":[banner]
            });
         };
         banner = new CongratMission();
         banner.x = 350;
         banner.y = 250;
         banner.scaleX = 1;
         banner.scaleY = 1;
         addChild(banner);
         TweenLite.from(banner,1.2,{
            "scaleX":0,
            "scaleY":0,
            "onComplete":setBannerDismiss
         });
      }
      
      function whenMissionSuccess(param1:MissionEvent) : void
      {
         if(this._mission.rewardType == "cash")
         {
            this.cashReward(this._mission.reward);
         }
         else if(this._mission.rewardType == "unlockBuild")
         {
            this.unlockBuildReward(this._mission.reward);
         }
         else if(this._mission.rewardType == "unlockUpgrade")
         {
            this.unlockUpgradeReward(this._mission.reward);
         }
         else if(this._mission.rewardType == "buildingExpBonus")
         {
            this.buildingExpBonus(this._mission.reward);
         }
         else if(this._mission.rewardType == "popularity")
         {
            this.popularityBonus(this._mission.reward);
         }
         else if(this._mission.rewardType == "worldLevel")
         {
            this.worldExpand();
         }
         else if(this._mission.rewardType == "finalMission")
         {
            this.finalReward();
         }
      }
      
      function buildingIsBought(param1:CommandEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = param1.tag;
         if(_loc2_.enableToBuild)
         {
            _loc3_ = _loc2_.cost;
            _loc4_ = new Point(_loc2_.coordinate.x,_loc2_.coordinate.y - 64);
            this.showGainMoney(-_loc3_,this._world.bonusContainer,_loc4_);
            this._budget -= _loc3_;
            this._currentStatistic.buildBuildingStat.relation = "New Building";
            this._currentStatistic.buildBuildingStat.expenditure += _loc3_;
            dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
         }
      }
      
      function expandElevator(param1:CommandEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = param1.tag;
         if(_loc2_.enableToBuild)
         {
            _loc3_ = _loc2_.cost;
            _loc4_ = this.globalToLocal(this.GUI.goldInfo.localToGlobal(new Point(this.GUI.goldInfo.width,-10)));
            this.showGainMoney(-_loc3_,this,_loc4_);
            this._budget -= _loc3_;
            this._currentStatistic.upgradeBuildingStat.relation = "Upgrade Building";
            this._currentStatistic.upgradeBuildingStat.expenditure += _loc3_;
            dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
         }
      }
      
      function buildingIsRelocated(param1:CommandEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = param1.tag;
         if(_loc2_.enableToBuild)
         {
            _loc3_ = _loc2_.cost;
            _loc4_ = new Point(_loc2_.coordinate.x,_loc2_.coordinate.y - 64);
            this.showGainMoney(-_loc3_,this._world.bonusContainer,_loc4_);
            this._budget -= _loc3_;
            this._currentStatistic.buildingRelocationStat.relation = "Relocation";
            this._currentStatistic.buildingRelocationStat.expenditure += _loc3_;
            dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
         }
      }
      
      function buildingIsUpgraded(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = param1.target;
         if(!(_loc2_ is FacilityElevatorBody))
         {
            _loc3_ = _loc2_.upgradeCost;
            _loc4_ = new Point(_loc2_.x,_loc2_.y - 64);
            this.showGainMoney(-_loc3_,this._world.bonusContainer,_loc4_);
            this._budget -= _loc3_;
            this._currentStatistic.upgradeBuildingStat.relation = "Upgrade Building";
            this._currentStatistic.upgradeBuildingStat.expenditure += _loc3_;
            dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
         }
      }
      
      function staffIsPromoted(param1:HumanEvent) : void
      {
         var _loc7_:* = undefined;
         var _loc2_:* = param1.target;
         var _loc3_:* = param1.tag;
         var _loc4_:* = _loc2_.promotionCost;
         var _loc5_:* = null;
         var _loc6_:* = null;
         if(_loc3_ == null)
         {
            _loc5_ = this._world.bonusContainer;
            _loc6_ = _loc2_;
         }
         else
         {
            _loc5_ = this;
            _loc6_ = _loc3_.humanIcon;
         }
         this._budget -= _loc4_;
         if(_loc5_ != null && _loc6_ != null)
         {
            _loc7_ = _loc5_.globalToLocal(_loc6_.localToGlobal(new Point(0,-32)));
            this.showGainMoney(-_loc4_,_loc5_,_loc7_);
         }
         this._currentStatistic.promotionStaffStat.relation = "Staff Promotion";
         this._currentStatistic.promotionStaffStat.expenditure += _loc4_;
         dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
      }
      
      function staffIsFired(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = _loc2_.serverenceCost;
         var _loc4_:* = this.globalToLocal(this.GUI.goldInfo.localToGlobal(new Point(this.GUI.goldInfo.width,-10)));
         this.showGainMoney(-_loc3_,this,_loc4_);
         this._currentStatistic.serveranceStaffStat.relation = "Serverance";
         this._currentStatistic.serveranceStaffStat.expenditure += _loc3_;
         this._budget -= _loc3_;
         dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
      }
      
      function staffIsHired(param1:CommandEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = param1.tag;
         if(_loc2_.enableToBuild)
         {
            _loc3_ = _loc2_.cost;
            _loc4_ = new Point(_loc2_.coordinate.x,_loc2_.coordinate.y - 32);
            this.showGainMoney(-_loc3_,this._world.bonusContainer,_loc4_);
            this._budget -= _loc3_;
            this._currentStatistic.hireStaffStat.relation = "Staff Hired";
            this._currentStatistic.hireStaffStat.expenditure += _loc3_;
            dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
         }
      }
      
      function buildProgressRun(param1:GameEvent) : void
      {
         this._GUI.showToBuildInfo(param1.tag);
      }
      
      function showGainMoney(param1:Number, param2:*, param3:Point, param4:Boolean = true) : void
      {
         var _loc5_:* = undefined;
         if(param1 != 0)
         {
            _loc5_ = new CashAnimation();
            if(param1 < 0)
            {
               _loc5_.textColor = ColorCode.NEGATIVE_CASH_ANIMATION;
            }
            else
            {
               _loc5_.textColor = ColorCode.POSITIVE_CASH_ANIMATION;
            }
            _loc5_.text = Utility.numberToMoney(Math.abs(param1)) + "G";
            _loc5_.charList[_loc5_.charList.length - 1].x += 5;
            _loc5_.x = param3.x - _loc5_.width / 2;
            _loc5_.y = param3.y;
            _loc5_.mouseEnabled = false;
            _loc5_.mouseChildren = false;
            if(param2 != null)
            {
               param2.addChild(_loc5_);
            }
            else
            {
               addChild(_loc5_);
            }
            _loc5_.animateText();
            if(param4)
            {
               this._onStackSFX.push(SFX_Coin);
               this._onStackSFXSource.push(_loc5_);
            }
         }
      }
      
      function showRefundMoney(param1:Number, param2:*, param3:Point) : void
      {
         var _loc4_:* = undefined;
         if(param1 != 0)
         {
            (_loc4_ = new CashAnimation()).textColor = ColorCode.REFUND_CASH_ANIMATION;
            _loc4_.text = Utility.numberToMoney(Math.abs(param1)) + "G";
            _loc4_.charList[_loc4_.charList.length - 1].x += 5;
            _loc4_.scaleX = 0.6;
            _loc4_.scaleY = 0.6;
            _loc4_.x = param3.x - _loc4_.width / 2;
            _loc4_.y = param3.y;
            if(param2 != null)
            {
               param2.addChild(_loc4_);
            }
            else
            {
               addChild(_loc4_);
            }
            _loc4_.animateText();
         }
      }
      
      function showFlyingText(param1:String, param2:uint, param3:*, param4:Point, param5:Number = 1) : void
      {
         var _loc6_:*;
         (_loc6_ = new CashAnimation()).textColor = param2;
         _loc6_.text = param1;
         _loc6_.scaleX = param5;
         _loc6_.scaleY = param5;
         _loc6_.x = param4.x - _loc6_.width * param5 / 2;
         _loc6_.y = param4.y;
         _loc6_.mouseEnabled = false;
         _loc6_.mouseChildren = false;
         if(param3 != null)
         {
            param3.addChild(_loc6_);
         }
         else
         {
            addChild(_loc6_);
         }
         _loc6_.animateText();
      }
      
      function checkVisitorVisit(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = param1.target;
         if(this._world.boothList.indexOf(_loc2_) >= 0 || this._world.innList.indexOf(_loc2_) >= 0)
         {
            _loc3_ = this._currentStatistic.indexOf(_loc2_);
            if(_loc3_ in this._currentStatistic.boothStatistic)
            {
               ++(_loc4_ = this._currentStatistic.boothStatistic[_loc3_]).numberVisitor;
            }
            else
            {
               (_loc5_ = new StatisticItem()).relation = _loc2_;
               ++_loc5_.numberVisitor;
               this._currentStatistic.boothStatistic.push(_loc5_);
            }
         }
      }
      
      function checkBonusGain(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = param1.tag;
         var _loc4_:* = this._world.bonusContainer.globalToLocal(_loc2_.localToGlobal(new Point(0,-20)));
         this.showGainMoney(_loc3_,this._world.bonusContainer,_loc4_);
         this._budget += _loc3_;
         this._currentStatistic.miscStat.revenue += _loc3_;
         dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
      }
      
      function checkSpentMoney(param1:HumanEvent) : void
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:* = param1.target;
         var _loc3_:* = param1.tag;
         var _loc4_:* = _loc3_.amount;
         var _loc5_:* = _loc3_.booth;
         var _loc6_:* = this._world.bonusContainer.globalToLocal(_loc2_.localToGlobal(new Point(0,-20)));
         var _loc7_:*;
         if((_loc7_ = this._currentStatistic.indexOf(_loc5_)) in this._currentStatistic.boothStatistic)
         {
            _loc8_ = this._currentStatistic.boothStatistic[_loc7_];
            _loc8_.revenue += _loc4_;
         }
         else
         {
            (_loc9_ = new StatisticItem()).relation = _loc5_;
            _loc9_.revenue = _loc4_;
            this._currentStatistic.boothStatistic.push(_loc9_);
         }
         if(this._world.innList.indexOf(_loc5_) < 0)
         {
            _loc5_.gainExp(_loc4_ / 5);
         }
         else
         {
            _loc5_.gainExp(_loc4_ / 3);
         }
         this.showGainMoney(_loc4_,this._world.bonusContainer,_loc6_);
         this._budget += _loc4_;
         dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
      }
      
      function checkReturnBounty(param1:HumanEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc2_:* = param1.target;
         var _loc3_:* = param1.tag;
         var _loc4_:* = this._world.bonusContainer.globalToLocal(_loc2_.localToGlobal(new Point(0,-20)));
         if(this._currentStatistic.miscStat.expenditure > _loc3_)
         {
            this._currentStatistic.miscStat.expenditure -= _loc3_;
         }
         else
         {
            _loc5_ = _loc3_ - this._currentStatistic.miscStat.expenditure;
            this._currentStatistic.miscStat.expenditure = 0;
            this._currentStatistic.miscStat.revenue += _loc5_;
         }
         this.showGainMoney(_loc3_,this._world.bonusContainer,_loc4_);
         this._budget += _loc3_;
         dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
      }
      
      function checkSalaryPaid(param1:HumanEvent) : void
      {
         var _loc6_:* = undefined;
         var _loc2_:* = param1.tag;
         var _loc3_:* = param1.target;
         var _loc4_:* = _loc3_.salary;
         var _loc5_:* = null;
         if(_loc3_ is StaffJanitor)
         {
            _loc5_ = this._currentStatistic.staffSallaries.janitor;
         }
         else if(_loc3_ is StaffHandyman)
         {
            _loc5_ = this._currentStatistic.staffSallaries.handyman;
         }
         else if(_loc3_ is StaffEntertainer)
         {
            _loc5_ = this._currentStatistic.staffSallaries.entertainer;
         }
         else if(_loc3_ is StaffGuard)
         {
            _loc5_ = this._currentStatistic.staffSallaries.guard;
         }
         if(_loc5_ != null)
         {
            _loc5_.expenditure += _loc4_;
         }
         if(_loc2_ == _loc3_)
         {
            _loc6_ = this._world.bonusContainer.globalToLocal(_loc2_.localToGlobal(new Point(0,-32)));
            this.showGainMoney(-_loc4_,this._world.bonusContainer,_loc6_);
         }
         else
         {
            _loc6_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,-20)));
            this.showGainMoney(-_loc4_,this,_loc6_);
         }
         this._budget -= _loc4_;
         dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
      }
      
      function checkRefundMoney(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = param1.tag;
         var _loc4_:* = this._world.bonusContainer.globalToLocal(_loc2_.localToGlobal(new Point(0,-20)));
         this.showRefundMoney(_loc3_,this._world.bonusContainer,_loc4_);
      }
      
      function checkStolenMoney(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = param1.tag;
         var _loc4_:* = this._world.bonusContainer.globalToLocal(_loc2_.localToGlobal(new Point(0,-20)));
         this.showGainMoney(-_loc3_,this._world.bonusContainer,_loc4_);
         this._currentStatistic.miscStat.expenditure += _loc3_;
         this._budget -= _loc3_;
         dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
      }
      
      function whenUpgradePurchased(param1:GameEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = param1.target;
         var _loc3_:* = param1.tag;
         if(!_loc3_.purchased)
         {
            if(this.isEnough(_loc3_.cost))
            {
               _loc4_ = this.globalToLocal(_loc2_.upgradeCostInfo.localToGlobal(new Point(_loc2_.upgradeCostInfo.width / 2,-10)));
               if(this.GUI.extraUpgradePanel.autoClose.isActive)
               {
                  this.GUI.extraUpgradePanel.dispatchEvent(new CommandEvent(CommandEvent.PANEL_NEED_TO_CLOSE));
                  _loc4_ = this.globalToLocal(this.GUI.goldInfo.localToGlobal(new Point(this.GUI.goldInfo.width,-10)));
               }
               _loc2_.purchasedSign.visible = true;
               this.showGainMoney(-_loc3_.cost,this,_loc4_);
               if(this._currentStatistic.extraUpgradeStat.relation == null)
               {
                  this._currentStatistic.extraUpgradeStat.relation = "Extra Upgrade";
               }
               this._currentStatistic.extraUpgradeStat.expenditure += _loc3_.cost;
               _loc3_.purchased = true;
               this._budget -= _loc3_.cost;
               dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
               dispatchEvent(new GameEvent(GameEvent.AFTER_UPGRADE_PURCHASED,_loc3_));
            }
            else
            {
               this._world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Not Enough Money"));
            }
         }
         else
         {
            this._world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Upgrade Already Purchased"));
         }
      }
      
      public function runGameplay() : void
      {
         this._world.gameSpeed = this._gameSpeed;
         this.updateTime();
         this._mission.runMission();
         this._tutorial.runTutorial();
         addListenerOf(this,Event.ENTER_FRAME,this.checkAchievementGain);
      }
      
      function updateTime() : void
      {
         ++this._gameMinute;
         if(this._gameMinute >= 60)
         {
            ++this._gameHour;
            if(this._gameHour >= 24)
            {
               this._gameHour = 0;
            }
            this._gameMinute = 0;
         }
         if(this._gameHour == 0 && this._gameMinute == 0)
         {
            ++this._dayPassed;
            this._GUI.dayPassedInfo.text = "DAY " + this._dayPassed;
         }
         if(this._gameHour == 6 && this._gameMinute == 0)
         {
            this.updateStatistic();
            if(this._dayPassed >= 10)
            {
               if(this._enablePlayBGM.indexOf(BGMData.PARISIAN) < 0)
               {
                  this._enablePlayBGM.push(BGMData.PARISIAN);
               }
            }
            if(this._dayPassed >= 15)
            {
               if(this._enableRainBGM.indexOf(BGMData.FUR_ELISE) < 0)
               {
                  this._enableRainBGM.push(BGMData.FUR_ELISE);
               }
            }
         }
         this._world.drawSky(this._GUI.clock.daySymbol.alpha);
         if(this._applicants.length < 20)
         {
            if(this._countdownApplicant > 0)
            {
               --this._countdownApplicant;
            }
            else
            {
               this.getNewApplicant();
            }
         }
         this.GUI.setNumberVisitor(this._world.currentVisitorList.length);
         if(this._gameHour == 22 && this._gameMinute == 0)
         {
            this.changeBGMTo(BGMData.IN_THE_HALL_OF_MOUNTAIN_KING);
         }
         if(this._gameHour == 9 && this._gameMinute == 0)
         {
            if(this._world.deepRain)
            {
               this.changeRainBGM();
            }
            else
            {
               this.changeNormalBGM();
            }
            if(this._mainProgram.autoSave)
            {
               if(!this._tutorial.inProgress)
               {
                  this.saveTheGame(true);
                  addChild(this._autoSaveIndicator);
               }
            }
         }
         this.currentTween = TweenLite.to(this.tempObject,0.15 * (1 / this._gameSpeed),{
            "ease":Linear.easeNone,
            "onComplete":this.updateTime
         });
         dispatchEvent(new GameEvent(GameEvent.GAME_UPDATE,{
            "hour":this._gameHour,
            "minute":this._gameMinute
         }));
      }
      
      public function changeNormalBGM() : void
      {
         var _loc1_:* = this._enablePlayBGM[Math.floor(Math.random() * this._enablePlayBGM.length)];
         this.changeBGMTo(_loc1_);
      }
      
      public function changeRainBGM() : void
      {
         var _loc1_:* = this._enableRainBGM[Math.floor(Math.random() * this._enableRainBGM.length)];
         this.changeBGMTo(_loc1_);
      }
      
      public function changeBGMTo(param1:*) : void
      {
         removeListenerOf(stage,AudioEvent.FINISH_CHANGE_BGM_VOLUME,this.afterFinishedChangeVolume);
         this._nextBGMToPlay = param1;
         dispatchEvent(new AudioEvent(AudioEvent.CHANGE_BGM_VOLUME,null,0,1.6));
         addListenerOf(stage,AudioEvent.FINISH_CHANGE_BGM_VOLUME,this.afterFinishedChangeVolume);
      }
      
      function afterFinishedChangeVolume(param1:AudioEvent) : void
      {
         if(this._nextBGMToPlay != null)
         {
            removeListenerOf(stage,AudioEvent.FINISH_CHANGE_BGM_VOLUME,this.afterFinishedChangeVolume);
            dispatchEvent(new AudioEvent(AudioEvent.PLAY_BGM,this._nextBGMToPlay));
            this._nextBGMToPlay = null;
         }
      }
      
      function checkUpgradeUnlock() : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc1_:* = new Array();
         var _loc2_:* = this._currentStatistic.totalProfit;
         var _loc3_:* = Infinity;
         var _loc4_:* = 0;
         while(_loc4_ < UpgradeData.UPGRADE_CODE.length)
         {
            _loc5_ = UpgradeData.UPGRADE_CODE[_loc4_];
            if(this._unlockedUpgrade.indexOf(_loc5_) < 0)
            {
               if((_loc6_ = UpgradeData.getProfitUnlcok(_loc5_)) > 0)
               {
                  if(_loc2_ >= _loc6_)
                  {
                     if((_loc7_ = UpgradeData.getRequirement(_loc5_)) == null || this._unlockedUpgrade.indexOf(_loc7_) >= 0)
                     {
                        if(_loc3_ >= _loc6_)
                        {
                           if(_loc3_ > _loc6_)
                           {
                              _loc1_ = new Array();
                              _loc3_ = _loc6_;
                           }
                           _loc1_.push(_loc5_);
                        }
                     }
                  }
               }
            }
            _loc4_++;
         }
         if(_loc1_.length > 0)
         {
            Utility.shuffle(_loc1_);
            _loc8_ = _loc1_.shift();
            this._unlockedUpgrade.push(_loc8_);
            this._newUnlockedUpgrade.push(_loc8_);
            dispatchEvent(new GameEvent(GameEvent.UNLOCK_NEW_UPGRADE));
            dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"New Upgrade Available"));
         }
      }
      
      function updateStatistic() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:StatisticItem = null;
         this.checkUpgradeUnlock();
         this.GUI.statisticPanel.statistic = this._currentStatistic;
         this.GUI.autoShowStatistic();
         dispatchEvent(new GameEvent(GameEvent.SHOW_REPORT,this._currentStatistic));
         this._currentStatistic = new Statistic();
         var _loc1_:* = 0;
         while(_loc1_ < this._world.boothList.length)
         {
            _loc2_ = this._world.boothList[_loc1_];
            _loc3_ = new StatisticItem();
            _loc3_.relation = _loc2_;
            _loc3_.numberVisitor = 0;
            _loc3_.revenue = 0;
            _loc3_.expenditure = 0;
            _loc3_.showVisitor = true;
            _loc3_.showRevenue = true;
            _loc3_.showExpenditure = false;
            this._currentStatistic.boothStatistic.push(_loc3_);
            _loc1_++;
         }
      }
      
      public function instantRefreshApplicant(param1:CommandEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.isEnough(this._GUI.hirePanel.REFRESH_COST))
         {
            this._countdownApplicant = 10;
            this._minimalNewApplicant = 3;
            this._chanceToGetApplicant = 100;
            _loc2_ = this._GUI.hirePanel.REFRESH_COST;
            _loc3_ = param1.target;
            _loc4_ = _loc3_.noApplicantMessage.btnRefreshApplicant;
            _loc5_ = this.globalToLocal(_loc4_.localToGlobal(new Point(0,0)));
            this.showGainMoney(-_loc2_,this,_loc5_);
            this._budget -= _loc2_;
            this._currentStatistic.miscStat.expenditure += _loc2_;
            dispatchEvent(new GameEvent(GameEvent.UPDATE_BUDGET,this._budget));
         }
         else
         {
            this._world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Not Enough Money"));
         }
      }
      
      public function getNewApplicant() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(Calculate.chance(this._chanceToGetApplicant))
         {
            _loc1_ = 20 - this._applicants.length;
            _loc2_ = Math.min(_loc1_,Math.max(this._minimalNewApplicant,Math.floor(Math.random() * 5) + 1));
            if(_loc2_ > 0)
            {
               _loc3_ = ["stamina","speed","hygine","entertain","sight"];
               _loc4_ = 0;
               while(_loc4_ < _loc2_)
               {
                  _loc5_ = new Array();
                  _loc6_ = 0;
                  while(_loc6_ < 3)
                  {
                     if(Calculate.chance(60))
                     {
                        _loc5_.push(_loc3_[Math.floor(Math.random() * _loc3_.length)]);
                     }
                     _loc6_++;
                  }
                  (_loc7_ = this.getRandomHumanStat(_loc5_)).characterName = HumanData.getRandomCharacterName(1);
                  this._applicants.push(_loc7_);
                  _loc4_++;
               }
               dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,_loc2_ + " new applicant" + (_loc2_ > 1 ? "s" : "") + " appear"));
               dispatchEvent(new GameEvent(GameEvent.NEW_APPLICANT,_loc2_));
               this._countdownApplicant = this.APPLICANT_DELAY;
               this._minimalNewApplicant = 1;
               this._chanceToGetApplicant = 30;
            }
         }
      }
      
      public function showNotification(param1:String) : void
      {
         if(param1 != this.lastNotification)
         {
            this.GUI.addNotification(param1);
            this.lastNotification = param1;
            TweenLite.to(this.notifObject,1,{"onComplete":this.resetNotification});
         }
      }
      
      public function resetNotification() : void
      {
         this.lastNotification = "";
      }
      
      public function isEnough(param1:int) : Boolean
      {
         return this._budget >= param1;
      }
      
      public function get GUI() : UI_InGame
      {
         return this._GUI;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function get staffList() : Object
      {
         return this._staffList;
      }
      
      public function get unlockedBuilding() : Array
      {
         return this._unlockedBuilding;
      }
      
      public function get newUnlockedBuilding() : Array
      {
         return this._newUnlockedBuilding;
      }
      
      public function get unlockedStaff() : Array
      {
         return this._unlockedStaff;
      }
      
      public function get unlockedUpgrade() : Array
      {
         return this._unlockedUpgrade;
      }
      
      public function get newUnlockedUpgrade() : Array
      {
         return this._newUnlockedUpgrade;
      }
      
      public function get unlockedHint() : Array
      {
         return this._unlockedHint;
      }
      
      public function get newUnlockedHint() : Array
      {
         return this._newUnlockedHint;
      }
      
      public function get budget() : int
      {
         return this._budget;
      }
      
      public function get currentStatistic() : Statistic
      {
         return this._currentStatistic;
      }
      
      public function get humanFocus() : *
      {
         return this._humanFocus;
      }
      
      public function get gameHour() : int
      {
         return this._gameHour;
      }
      
      public function get gameSpeed() : int
      {
         return this._gameSpeed;
      }
      
      public function get menuAppear() : Boolean
      {
         return this._menuAppear;
      }
      
      public function get dayPassed() : int
      {
         return this._dayPassed;
      }
      
      public function set slotIndex(param1:int) : void
      {
         this._slotIndex = param1;
      }
      
      public function get slotIndex() : int
      {
         return this._slotIndex;
      }
      
      public function set nameID(param1:String) : void
      {
         this._nameID = param1;
      }
      
      public function get nameID() : String
      {
         return this._nameID;
      }
      
      public function set mainProgram(param1:MainProgram) : void
      {
         this._mainProgram = param1;
      }
      
      public function get loadGame() : Boolean
      {
         return this._loadGame;
      }
      
      public function get mainProgram() : MainProgram
      {
         return this._mainProgram;
      }
      
      public function get mission() : Mission
      {
         return this._mission;
      }
      
      public function get history() : *
      {
         return this._history;
      }
      
      public function get achievement() : Array
      {
         return this._achievement;
      }
      
      public function get tutorial() : Tutorial
      {
         return this._tutorial;
      }
      
      public function set bgmVolume(param1:Number) : void
      {
         this._bgmVolume = param1;
      }
      
      public function get bgmVolume() : Number
      {
         return this._bgmVolume;
      }
      
      public function set sfxVolume(param1:Number) : void
      {
         this._sfxVolume = param1;
      }
      
      public function get sfxVolume() : Number
      {
         return this._sfxVolume;
      }
      
      public function get onStackSFX() : Array
      {
         return this._onStackSFX;
      }
      
      public function get onStackSFXSource() : Array
      {
         return this._onStackSFXSource;
      }
   }
}
