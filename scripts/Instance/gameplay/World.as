package Instance.gameplay
{
   import Instance.Gameplay;
   import Instance.SEMovieClip;
   import Instance.constant.BuildingData;
   import Instance.constant.ColorCode;
   import Instance.constant.ComboList;
   import Instance.constant.Config;
   import Instance.constant.ConversationList;
   import Instance.constant.HumanData;
   import Instance.constant.UpgradeData;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import Instance.progress.BuildProgress;
   import Instance.progress.Conversation;
   import Instance.progress.ElevatorBuildProgress;
   import Instance.progress.ExpandElevatorProgress;
   import Instance.progress.RelocateBuilding;
   import Instance.progress.StaffHireProgress;
   import Instance.progress.StairBuildProgress;
   import Instance.property.AnimalPoop;
   import Instance.property.Bonus;
   import Instance.property.Booth;
   import Instance.property.BoothColloseum;
   import Instance.property.Elevator;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityGuardPost;
   import Instance.property.FacilityRestRoom;
   import Instance.property.FacilityStairs;
   import Instance.property.FacilityTerrace;
   import Instance.property.FacilityTradingPost;
   import Instance.property.Floor;
   import Instance.property.HalteWagon;
   import Instance.property.StatisticItem;
   import Instance.property.Wagon;
   import fl.motion.Color;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import greensock.TweenLite;
   import greensock.easing.Linear;
   
   public class World extends SEMovieClip
   {
       
      
      public const HEIGHT_CHECK = 36;
      
      public const TOP_CHECK = 120;
      
      public const GRID = 12;
      
      public const BUILD_HEIGHT = 72;
      
      public const MAX_VISITOR = 150;
      
      public const ALARM_DELAY = 45;
      
      public const TRASH_GRID = 128;
      
      var _gameSpeed:Number;
      
      var _gameSpeedCtr:Number;
      
      var _gameHeight:Number;
      
      var _bgContainer:MovieClip;
      
      var _mainContainer:MainContainer;
      
      var _sceneryContainer:MovieClip;
      
      var _roadContainer:MovieClip;
      
      var _buildLimitContainer:MovieClip;
      
      var _elevatorContainer:MovieClip;
      
      var _dungeon:MovieClip;
      
      var _wagonContainer:MovieClip;
      
      var _buildContainer:MovieClip;
      
      var _frontContainer:MovieClip;
      
      var _legendContainer:MovieClip;
      
      var _conversationContainer:MovieClip;
      
      var _bonusContainer:MovieClip;
      
      var _level:int;
      
      var _basementLevel:int;
      
      var _buildingList:Array;
      
      var _onInfoBuildingList:Array;
      
      var _stairList:Array;
      
      var _elevatorList:Array;
      
      var _transportList:Array;
      
      var _restRoomList:Array;
      
      var _boothListByType:Object;
      
      var _dungeonConnection:Array;
      
      var _connectionSurface;
      
      var _boothList:Array;
      
      var _brokableBuildingList:Array;
      
      var _innList:Array;
      
      var _tradingPostList:Array;
      
      var _guardPostList:Array;
      
      var _terraceList:Array;
      
      var _needToSwapObject:Array;
      
      var _columnList:Array;
      
      var _floorList:Array;
      
      var _bottomFloor:Floor;
      
      var _wallList:Array;
      
      var _basementFloorList:Array;
      
      var _topFloorBasement;
      
      var _humanList:Array;
      
      var _thiefList:Array;
      
      var _litterList:Array;
      
      var _wizardList:Array;
      
      var _trashList:Array;
      
      var _pupList:Array;
      
      var _bonusList:Array;
      
      var _watchdog;
      
      var _popularity:Number;
      
      var _popularityModifier:Number;
      
      var _maxPopularity:Number;
      
      var _buildCompletionPopularity:Number;
      
      var _upgradeModifier:Object;
      
      var _mostLeft:Number;
      
      var _mostRight:Number;
      
      var mostBottom:Number;
      
      var lastCoordinate:Point;
      
      var _buildProgress:BuildProgress;
      
      var scrollButtonOnPressed:Array;
      
      var buttonPressed:Array;
      
      var _compatibilityPoint:int;
      
      var _weather:Number;
      
      var _maxWeatherPoint:Number;
      
      var _minWeatherPoint:Number;
      
      var _forecast:Number;
      
      var _rainEnvirontment;
      
      var _skyColor:uint;
      
      var _currentWeatherPercent:Number;
      
      var _deepRain:Boolean;
      
      var _cloudList:Array;
      
      var _staffList:Object;
      
      var _currentVisitorList:Array;
      
      var _specialVisitorList:Array;
      
      var _maxVisitor:int;
      
      var _halte:HalteWagon;
      
      var _extraUpgradeList:Array;
      
      var thiefDelay:int;
      
      var villainDelay:int;
      
      var _alarmTrigger:Boolean;
      
      var _triggerBooth;
      
      var alarmDelay:int;
      
      var _combination;
      
      var _main:Gameplay;
      
      var dRainAlpha:Number;
      
      public function World()
      {
         super();
         this._gameSpeed = 1;
         this._gameSpeedCtr = 0;
         this._gameHeight = 84 * 15;
         this._level = 1;
         this._basementLevel = 1;
         this._sceneryContainer = new MovieClip();
         this._bgContainer = new MovieClip();
         this._mainContainer = new MainContainer();
         this._roadContainer = new MovieClip();
         this._buildingList = new Array();
         this._onInfoBuildingList = new Array();
         this._dungeonConnection = new Array();
         this._brokableBuildingList = new Array();
         this._boothListByType = new Object();
         this._columnList = new Array();
         this._floorList = new Array();
         this._wallList = new Array();
         this._stairList = new Array();
         this._elevatorList = new Array();
         this._transportList = new Array();
         this._restRoomList = new Array();
         this._boothList = new Array();
         this._innList = new Array();
         this._tradingPostList = new Array();
         this._guardPostList = new Array();
         this._terraceList = new Array();
         this._trashList = new Array();
         this._pupList = new Array();
         this._bonusList = new Array();
         this._humanList = new Array();
         this._thiefList = new Array();
         this._litterList = new Array();
         this._wizardList = new Array();
         this._currentVisitorList = new Array();
         this._specialVisitorList = new Array();
         this._cloudList = new Array();
         this._needToSwapObject = new Array();
         this._extraUpgradeList = new Array();
         this.initExtraUpgrade();
         this.scrollButtonOnPressed = new Array();
         this.buttonPressed = new Array();
         this._basementFloorList = new Array();
         this._buildProgress = null;
         this._compatibilityPoint = 0;
         this._weather = 0;
         this._maxWeatherPoint = 50;
         this._minWeatherPoint = -50;
         this._forecast = -5;
         this._rainEnvirontment = new EffectRain();
         this._rainEnvirontment.x = 0;
         this._rainEnvirontment.y = -100;
         this._rainEnvirontment.mouseEnabled = false;
         this._rainEnvirontment.mouseChildren = false;
         this._popularity = 0;
         this._popularityModifier = 0;
         this._maxPopularity = 10;
         this._alarmTrigger = false;
         this._dungeon = new MovieClip();
         this._dungeon.visible = false;
         this._bottomFloor = this.addFloor(0,-128,128);
         this._bottomFloor.visible = false;
         this.alarmDelay = this.ALARM_DELAY;
         this.mostBottom = 3 * this.GRID + this.BUILD_HEIGHT;
         this.thiefDelay = 15;
         this.villainDelay = 15;
         this.initSpecialVisitor();
         this._combination = new Object();
         this.generateCombination();
      }
      
      function generateCombination() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this._combination.good = new Array();
         this._combination.bad = new Array();
         var _loc1_:* = 0;
         while(_loc1_ < BuildingData.BUILDING_LIST.length - 1)
         {
            _loc2_ = BuildingData.BUILDING_LIST[_loc1_];
            _loc3_ = _loc1_ + 1;
            while(_loc3_ < BuildingData.BUILDING_LIST.length)
            {
               _loc4_ = BuildingData.BUILDING_LIST[_loc3_];
               if((_loc5_ = ComboList.checkComboType(_loc2_,_loc4_)) > 0)
               {
                  this._combination.good.push({
                     "tier1":_loc2_,
                     "tier2":_loc4_,
                     "unlocked":false
                  });
               }
               else if(_loc5_ < 0)
               {
                  this._combination.bad.push({
                     "tier1":_loc2_,
                     "tier2":_loc4_,
                     "unlocked":false
                  });
               }
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      function initExtraUpgrade() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this._upgradeModifier = new Object();
         var _loc1_:* = 0;
         while(_loc1_ < UpgradeData.UPGRADE_CODE.length)
         {
            _loc2_ = new Object();
            _loc2_.code = UpgradeData.UPGRADE_CODE[_loc1_];
            _loc2_.upgradeName = UpgradeData.getNameOf(_loc2_.code);
            _loc2_.description = UpgradeData.getDescriptionOf(_loc2_.code);
            _loc2_.requirement = UpgradeData.getRequirement(_loc2_.code);
            _loc2_.cost = UpgradeData.getCostOf(_loc2_.code);
            _loc2_.purchased = false;
            _loc2_.towerCheck = UpgradeData.getTowerCheck(_loc2_.code);
            this._extraUpgradeList.push(_loc2_);
            _loc3_ = UpgradeData.getVarOf(_loc2_.code);
            if(_loc3_ != null)
            {
               if(!(_loc3_ in this._upgradeModifier))
               {
                  this._upgradeModifier[_loc3_] = 0;
               }
            }
            _loc1_++;
         }
      }
      
      public function loadCondition(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1 != null)
         {
            this.checkMaxPopularity();
            this._level = param1.level;
            this._popularity = param1.popularity;
            this._popularityModifier = param1.popularityModifier;
            _loc2_ = 0;
            while(_loc2_ < this._extraUpgradeList.length)
            {
               if(_loc2_ in param1.upgradePurchased)
               {
                  this._extraUpgradeList[_loc2_].purchased = param1.upgradePurchased[_loc2_];
               }
               if(this._extraUpgradeList[_loc2_].purchased)
               {
                  _loc3_ = UpgradeData.getVarOf(this._extraUpgradeList[_loc2_].code);
                  if(_loc3_ != null)
                  {
                     if(!(_loc3_ in this._upgradeModifier))
                     {
                        this._upgradeModifier[_loc3_] = 0;
                     }
                     if((_loc4_ = UpgradeData.getValueOf(this._extraUpgradeList[_loc2_].code)) != null)
                     {
                        this._upgradeModifier[_loc3_] += _loc4_;
                     }
                  }
               }
               _loc2_++;
            }
            if(param1.combination != null)
            {
               _loc2_ = 0;
               while(_loc2_ < param1.combination.good.length)
               {
                  this._combination.good[_loc2_].unlocked = param1.combination.good[_loc2_];
                  _loc2_++;
               }
               _loc2_ = 0;
               while(_loc2_ < param1.combination.bad.length)
               {
                  this._combination.bad[_loc2_].unlocked = param1.combination.bad[_loc2_];
                  _loc2_++;
               }
            }
            if(param1.basementLevel != null)
            {
               this._basementLevel = param1.basementLevel;
            }
            else
            {
               this._basementLevel = 1;
               if(this.isUpgradePurchased(UpgradeData.BASEMENT_II))
               {
                  ++this._basementLevel;
               }
               if(this.isUpgradePurchased(UpgradeData.BASEMENT_III))
               {
                  ++this._basementLevel;
               }
            }
            this._weather = param1.weather;
            this._forecast = param1.forecast;
            this._deepRain = param1.deepRain;
         }
      }
      
      public function saveCondition(param1:*) : void
      {
         var _loc2_:* = undefined;
         if(param1 != null)
         {
            param1.level = this._level;
            param1.basementLevel = this._basementLevel;
            param1.popularity = this._popularity;
            param1.popularityModifier = this._popularityModifier;
            param1.upgradePurchased = new Array();
            _loc2_ = 0;
            while(_loc2_ < this._extraUpgradeList.length)
            {
               param1.upgradePurchased.push(this._extraUpgradeList[_loc2_].purchased);
               _loc2_++;
            }
            param1.combination = new Object();
            param1.combination.good = new Array();
            param1.combination.bad = new Array();
            _loc2_ = 0;
            while(_loc2_ < this._combination.good.length)
            {
               param1.combination.good.push(this._combination.good[_loc2_].unlocked);
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < this._combination.bad.length)
            {
               param1.combination.bad.push(this._combination.bad[_loc2_].unlocked);
               _loc2_++;
            }
            param1.weather = this._weather;
            param1.forecast = this._forecast;
            param1.deepRain = this._deepRain;
         }
      }
      
      public function isUpgradePurchased(param1:*) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc2_:* = false;
         var _loc3_:* = 0;
         while(_loc3_ < this._extraUpgradeList.length)
         {
            if((_loc4_ = this._extraUpgradeList[_loc3_]).code == param1)
            {
               _loc2_ = _loc4_.purchased;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         super.Initialize(param1);
         addListenerOf(this,Event.ENTER_FRAME,this.gameIdle);
         addListenerOf(stage,CommandEvent.BEGIN_SCROLL,this.startToScroll);
         addListenerOf(this._mainContainer,GameEvent.POSITION_CHANGE,this.fixPosition);
         this._elevatorContainer = new MovieClip();
         this._wagonContainer = new MovieClip();
         this._buildContainer = new MovieClip();
         this._frontContainer = new MovieClip();
         this._legendContainer = new MovieClip();
         this._legendContainer.mouseEnabled = false;
         this._legendContainer.mouseChildren = false;
         this._conversationContainer = new MovieClip();
         this._conversationContainer.mouseEnabled = false;
         this._conversationContainer.mouseChildren = false;
         this._bonusContainer = new MovieClip();
         this._bonusContainer.mouseEnabled = false;
         this._bonusContainer.mouseChildren = false;
         this.initRoad();
         if(!this._main.loadGame)
         {
            this.createBasement();
         }
         else
         {
            this.initTopFloorBasement();
         }
         this.createScenery();
         this._mainContainer.addChild(this._wagonContainer);
         this._mainContainer.addChild(this._elevatorContainer);
         this._mainContainer.addChild(this._dungeon);
         this._mainContainer.addChild(this._buildContainer);
         this._mainContainer.addChild(this._frontContainer);
         this._mainContainer.addChild(this._buildLimitContainer);
         this._mainContainer.addChild(this._legendContainer);
         this._mainContainer.addChild(this._conversationContainer);
         this._mainContainer.addChild(this._bonusContainer);
         addChild(this._bgContainer);
         addChild(this._sceneryContainer);
         addChild(this._mainContainer);
         var _loc2_:* = 0;
         while(_loc2_ < this._specialVisitorList.length)
         {
            _loc3_ = this._specialVisitorList[_loc2_];
            _loc3_.world = this;
            _loc3_.initData();
            _loc2_++;
         }
         this.loadBuilding();
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.updateGameTime);
         addListenerOf(stage,CommandEvent.BEGIN_BUILD,this.startToBuild);
         addListenerOf(stage,CommandEvent.BEGIN_HIRE,this.startToHire);
         addListenerOf(stage,CommandEvent.CANCEL_BUILD,this.cancelToBuild);
         addListenerOf(this,CommandEvent.DECIDE_BUILD,this.buildingInProgress);
         addListenerOf(this,CommandEvent.DECIDE_RELOCATE,this.relocateInProgress);
         addListenerOf(this,CommandEvent.DECIDE_HIRE,this.hireInProgress);
         addListenerOf(this,CommandEvent.DESTROY_BUILD,this.buildingToDestroy);
         addListenerOf(this,CommandEvent.FIRE_STAFF,this.staffToFire);
         addListenerOf(stage,CommandEvent.BEGIN_EXPAND,this.startToExpand);
         addListenerOf(this,CommandEvent.BEGIN_RELOCATE,this.startToRelocate);
         addListenerOf(this,GameEvent.DESTROY,this.destroyProgress);
         addListenerOf(this,GameEvent.BUILDING_CREATED,this.whenBuildingUpdated);
         addListenerOf(this,GameEvent.BUILDING_DESTROYED,this.whenBuildingUpdated);
         addListenerOf(this,GameEvent.BUILDING_SUCCESSFULLY_UPGRADE,this.whenBuildingUpdated);
         addListenerOf(stage,KeyboardEvent.KEY_DOWN,this.keyboardIsDown);
         addListenerOf(stage,KeyboardEvent.KEY_UP,this.keyboardIsUp);
         addListenerOf(this,LoopEvent.ON_IDLE,this.checkWeather);
         addListenerOf(this,HumanEvent.DROP_BONUS,this.checkBonusDrop);
         addListenerOf(this,GameEvent.BONUS_GAIN,this.checkBonusGain);
         addListenerOf(this,HumanEvent.EXILE,this.someoneExile);
         addListenerOf(stage,GameEvent.AFTER_UPGRADE_PURCHASED,this.afterUpgradePurchased);
         addListenerOf(this,GameEvent.BECOMES_ROBBED,this.checkBoothRobbed);
         addListenerOf(this,GameEvent.SPECIAL_VISITOR_COME,this.whenSpecialVisitorCome);
         addListenerOf(this,GameEvent.ARRESTED,this.whenSomeoneArrested);
         if(this._weather <= -20)
         {
            if(this._rainEnvirontment.stage == null)
            {
               this._rainEnvirontment.alpha = 0;
               this.dRainAlpha = 1;
               _loc4_ = getChildIndex(this._mainContainer);
               addChildAt(this._rainEnvirontment,_loc4_);
            }
         }
         this.checkMaxPopularity();
      }
      
      function whenSomeoneArrested(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(!(_loc2_ is Wizard))
         {
            this._main.updateHistory("arrested");
         }
      }
      
      function whenSpecialVisitorCome(param1:GameEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(_loc3_ < this._specialVisitorList.length)
         {
            if((_loc4_ = this._specialVisitorList[_loc3_]).hasCome)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         this._main.updateHistoryMax("specialVisitor",_loc2_);
      }
      
      function initTopFloorBasement() : void
      {
         var _loc1_:* = undefined;
         if(this._basementFloorList.length > 0)
         {
            this._topFloorBasement = null;
            _loc1_ = 0;
            while(_loc1_ < this._basementFloorList.length)
            {
               if(this._topFloorBasement == null)
               {
                  this._topFloorBasement = this._basementFloorList[_loc1_];
               }
               else if(this._basementFloorList[_loc1_].y < this._topFloorBasement)
               {
                  this._topFloorBasement = this._basementFloorList[_loc1_];
               }
               _loc1_++;
            }
         }
      }
      
      function afterUpgradePurchased(param1:GameEvent) : void
      {
         var theVar:* = undefined;
         var varValue:* = undefined;
         var newAddList:* = undefined;
         var lastCreated:* = undefined;
         var posY:* = undefined;
         var toAdd:* = undefined;
         var additionalConnection:* = undefined;
         var body:* = undefined;
         var pastBody:* = undefined;
         var newColumn:* = undefined;
         var bottomCheck:* = undefined;
         var bottomRoad:* = undefined;
         var animateAppearBasement:Function = null;
         var i:* = undefined;
         var e:GameEvent = param1;
         var upgradeCheck:* = e.tag;
         if(upgradeCheck != null)
         {
            theVar = UpgradeData.getVarOf(upgradeCheck.code);
            if(theVar != null)
            {
               if(!(theVar in this._upgradeModifier))
               {
                  this._upgradeModifier[theVar] = 0;
               }
               varValue = UpgradeData.getValueOf(upgradeCheck.code);
               if(varValue != null)
               {
                  this._upgradeModifier[theVar] += varValue;
               }
            }
            if(upgradeCheck.code == UpgradeData.HEAVY_GLADIATOR)
            {
               this._main.unlockBuildReward(["Colloseum"]);
            }
            if(upgradeCheck.code == UpgradeData.EXPERT_ACCOUNTANT)
            {
               this._main.unlockBuildReward(["Bath House","Spa"]);
            }
            if(upgradeCheck.code == UpgradeData.WATCHDOG)
            {
               if(this._watchdog == null)
               {
                  this._watchdog = new Watchdog();
                  this._watchdog.x = 0;
                  this._watchdog.y = 0;
                  this._watchdog.world = this;
                  this.addHuman(this._watchdog);
               }
            }
            if(upgradeCheck.code == UpgradeData.BASEMENT_II || upgradeCheck.code == UpgradeData.BASEMENT_III)
            {
               animateAppearBasement = function(param1:LoopEvent):void
               {
                  var _loc2_:* = param1.currentTarget;
                  if(_loc2_.alpha < 1)
                  {
                     _loc2_.alpha = Math.min(1,_loc2_.alpha + 0.04);
                  }
                  else
                  {
                     removeListenerOf(_loc2_,LoopEvent.ON_IDLE,animateAppearBasement);
                  }
               };
               ++this._basementLevel;
               newAddList = new Array();
               lastCreated = this._basementFloorList[this._basementFloorList.length - 1];
               posY = lastCreated.y + lastCreated.height + this.BUILD_HEIGHT;
               toAdd = this.addBasementFloor(posY,this._mostLeft,this._mostRight);
               this._buildContainer.addChild(toAdd);
               newAddList.push(toAdd);
               additionalConnection = new BuildingInnConnection();
               additionalConnection.x = this._connectionSurface.x;
               additionalConnection.y = toAdd.y;
               additionalConnection.world = this;
               body = additionalConnection.getChildAt(0);
               pastBody = this._connectionSurface.getChildAt(0);
               body.obj0.gotoAndStop(pastBody.obj0.currentFrame);
               body.obj1.gotoAndStop(pastBody.obj1.currentFrame);
               this._dungeonConnection.push(additionalConnection);
               this._buildingList.push(additionalConnection);
               this._buildContainer.addChild(additionalConnection);
               newAddList.push(additionalConnection);
               newColumn = this.addColumnFrom(additionalConnection);
               if(newColumn != null)
               {
                  if(newColumn.left != null)
                  {
                     this._buildContainer.addChild(newColumn.left);
                     newAddList.push(newColumn.left);
                  }
                  if(newColumn.right != null)
                  {
                     this._buildContainer.addChild(newColumn.right);
                     newAddList.push(newColumn.right);
                  }
               }
               newAddList = newAddList.concat(this.createWall(toAdd.y));
               bottomCheck = this.HEIGHT_CHECK + (this._basementLevel + 1) * this.BUILD_HEIGHT;
               bottomRoad = this._roadContainer.getChildAt(this._roadContainer.numChildren - 1);
               bottomRoad.width = this._mostRight - this._mostLeft;
               bottomRoad.height = bottomCheck;
               i = 0;
               while(i < newAddList.length)
               {
                  newAddList[i].alpha = 0;
                  addListenerOf(newAddList[i],LoopEvent.ON_IDLE,animateAppearBasement);
                  i++;
               }
               dispatchEvent(new GameEvent(GameEvent.BUILDING_CREATED,additionalConnection));
            }
         }
         this._main.updateHistoryMax("extraUpgrade",this.numberPurchasedExtraUpgrade);
      }
      
      function checkBoothRobbed(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.target;
         if(!_loc2_.isBroken)
         {
            if(this.isUpgradePurchased(UpgradeData.CRYSTAL_BALL))
            {
               _loc3_ = _loc2_.level * 15;
               if(Calculate.chance(_loc3_))
               {
                  this._alarmTrigger = true;
                  this.alarmDelay = this.ALARM_DELAY;
                  this._triggerBooth = _loc2_;
                  this._triggerBooth.alarmTrigger = true;
                  dispatchEvent(new GameEvent(GameEvent.ALARM_TRIGGERED));
               }
            }
         }
      }
      
      function someoneExile(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = this._humanList.indexOf(_loc2_);
         if(_loc3_ in this._humanList)
         {
            this._humanList.splice(_loc3_,1);
         }
         var _loc4_:*;
         if((_loc4_ = this._currentVisitorList.indexOf(_loc2_)) in this._currentVisitorList)
         {
            this._currentVisitorList.splice(_loc4_,1);
         }
         var _loc5_:*;
         if((_loc5_ = this._thiefList.indexOf(_loc2_)) in this._thiefList)
         {
            this._thiefList.splice(_loc5_,1);
         }
         var _loc6_:*;
         if((_loc6_ = this._litterList.indexOf(_loc2_)) in this._litterList)
         {
            this._litterList.splice(_loc6_,1);
         }
         var _loc7_:*;
         if((_loc7_ = this._wizardList.indexOf(_loc2_)) in this._wizardList)
         {
            this._wizardList.splice(_loc7_,1);
         }
      }
      
      function initSpecialVisitor() : void
      {
         var _loc1_:* = new Bilbo();
         this._specialVisitorList.push(_loc1_);
         var _loc2_:* = new DaVinci();
         this._specialVisitorList.push(_loc2_);
         var _loc3_:* = new Elsa();
         this._specialVisitorList.push(_loc3_);
         var _loc4_:* = new Flintstone();
         this._specialVisitorList.push(_loc4_);
         var _loc5_:* = new Gandalf();
         this._specialVisitorList.push(_loc5_);
         var _loc6_:* = new Gollum();
         this._specialVisitorList.push(_loc6_);
         var _loc7_:* = new Hercules();
         this._specialVisitorList.push(_loc7_);
         var _loc8_:* = new Kratos();
         this._specialVisitorList.push(_loc8_);
         var _loc9_:* = new Leonidas();
         this._specialVisitorList.push(_loc9_);
         var _loc10_:* = new Xena();
         this._specialVisitorList.push(_loc10_);
      }
      
      public function getSpecialVisitorByCode(param1:String) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         while(_loc3_ < this._specialVisitorList.length)
         {
            if((_loc4_ = this._specialVisitorList[_loc3_]).codeName == param1)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function initCloud(param1:Number) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = this._weather < 0 ? 12 : (this._weather < 20 ? 7 : (this._weather < 30 ? 4 : 2));
         while(this.cloudWeight < _loc2_)
         {
            _loc3_ = _loc2_ - this.cloudWeight;
            (_loc4_ = new Cloud()).speed = Math.random() * 2 + 1;
            _loc4_.gotoAndStop(Math.floor(Math.random() * Math.min(_loc4_.totalFrames,_loc3_ * 2)) + 1);
            _loc4_.x = Math.random() * 700 - 350;
            _loc4_.y = Math.random() * 350 - 300;
            this._cloudList.push(_loc4_);
            this._cloudList.sortOn("speed",Array.NUMERIC);
            _loc5_ = this._cloudList.indexOf(_loc4_);
            this._bgContainer.addChildAt(_loc4_,_loc5_);
            addListenerOf(_loc4_,LoopEvent.ON_IDLE,this.moveCloud);
         }
      }
      
      function moveCloud(param1:LoopEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = _loc2_.localToGlobal(new Point(_loc2_.width / 2,0));
         if(_loc3_.x > 0)
         {
            _loc2_.x -= _loc2_.speed;
         }
         else
         {
            if((_loc4_ = this._cloudList.indexOf(_loc2_)) in this._cloudList)
            {
               this._cloudList.splice(_loc4_,1);
            }
            _loc2_.parent.removeChild(_loc2_);
            removeListenerOf(_loc2_,LoopEvent.ON_IDLE,this.moveCloud);
         }
      }
      
      public function get cloudWeight() : Number
      {
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this._cloudList.length)
         {
            _loc3_ = this._cloudList[_loc2_];
            _loc1_ += Math.ceil(_loc3_.currentFrame / 2);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function drawSky(param1:Number) : *
      {
         var _loc7_:* = undefined;
         var _loc2_:* = Math.max(0,Math.min(1,((!!this._deepRain ? -5 : -20) - this._weather) / 10));
         if(isNaN(this._currentWeatherPercent))
         {
            this._currentWeatherPercent = _loc2_;
         }
         else if((_loc7_ = Math.abs(this._currentWeatherPercent - _loc2_)) > 0)
         {
            if(this._currentWeatherPercent > _loc2_)
            {
               this._currentWeatherPercent -= Math.min(0.05,_loc7_);
            }
            else
            {
               this._currentWeatherPercent += Math.min(0.05,_loc7_);
            }
         }
         var _loc3_:* = 0.6 + 0.4 * (1 - this._currentWeatherPercent);
         var _loc4_:* = 0.05 + 0.95 * param1;
         var _loc5_:* = 0;
         while(_loc5_ < this._cloudList.length)
         {
            this._cloudList[_loc5_].transform.colorTransform = new ColorTransform(_loc3_,_loc3_,_loc3_,_loc4_,0,0,0,0);
            _loc5_++;
         }
         var _loc6_:* = Color.interpolateColor(ColorCode.DAY_SKY,ColorCode.OVERCAST_SKY,this._currentWeatherPercent);
         this._skyColor = Color.interpolateColor(ColorCode.NIGHT_SKY,_loc6_,param1);
         this._bgContainer.graphics.clear();
         this._bgContainer.graphics.beginFill(this._skyColor);
         this._bgContainer.graphics.drawRect(-350,-350,700,500);
         this._bgContainer.graphics.endFill();
      }
      
      function updateGameTime(param1:GameEvent) : void
      {
         var _loc8_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < this._humanList.length)
         {
            this._humanList[_loc2_].dispatchEvent(new HumanEvent(HumanEvent.UPDATE_BEHAVIOR));
            _loc2_++;
         }
         var _loc3_:* = param1.tag;
         if(_loc3_.minute == 0)
         {
            _loc8_ = this._deepRain;
            this.weatherChangeCheck();
            if(param1.tag.hour < 22 && param1.tag.hour >= 9)
            {
               if(this._deepRain && !_loc8_)
               {
                  this._main.changeRainBGM();
               }
               else if(!this._deepRain && _loc8_)
               {
                  this._main.changeNormalBGM();
               }
            }
            if(_loc3_.hour == 6 || _loc3_.hour == 18)
            {
               this._forecast = Math.round(Math.random() * 8) - 9;
            }
         }
         if(_loc3_.minute % 10 == 0)
         {
            this.cloudAddedCheck();
         }
         this.loadMaxVisitor();
         var _loc4_:* = param1.tag.hour;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(_loc4_ >= 10 && _loc4_ < 12)
         {
            _loc5_ = 0.5;
            _loc6_ = 0.5;
         }
         else if(_loc4_ >= 12 && _loc4_ < 15)
         {
            _loc5_ = 1.5;
            _loc6_ = 1;
         }
         else if(_loc4_ >= 15 && _loc4_ < 18)
         {
            _loc5_ = 1;
            _loc6_ = 1.5;
         }
         else if(_loc4_ >= 18 && _loc4_ < 21)
         {
            _loc5_ = 2;
            _loc6_ = 1;
         }
         var _loc7_:*;
         if((_loc7_ = this._popularity * ((_loc5_ + (Math.random() * (_loc6_ * 2) - _loc6_)) / 2) * 0.75) < 2 && _loc4_ >= 12 && _loc4_ < 19)
         {
            _loc7_ = 2;
         }
         _loc7_ *= this._maxVisitor / (this._maxVisitor + this._currentVisitorList.length);
         this.createRandomVisitor(_loc7_);
         this.thiefCheck(param1.tag);
         this.villainCheck(param1.tag);
         this.checkAlarm();
      }
      
      function checkAlarm() : void
      {
         if(this._alarmTrigger)
         {
            if(this.alarmDelay > 0 && this._thiefList.length > 0)
            {
               --this.alarmDelay;
            }
            else
            {
               this._alarmTrigger = false;
               this._triggerBooth.alarmTrigger = false;
               this._triggerBooth = null;
               dispatchEvent(new GameEvent(GameEvent.ALARM_STOPPED));
            }
         }
      }
      
      public function loadMaxVisitor() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 60;
         var _loc3_:* = 1;
         while(_loc3_ < this._floorList.length)
         {
            _loc1_ += Math.round((this._floorList[_loc3_].right - this._floorList[_loc3_].left) / _loc2_);
            _loc3_++;
         }
         _loc3_ = 1;
         while(_loc3_ < this._basementFloorList.length)
         {
            _loc1_ += Math.round((this._basementFloorList[_loc3_].right - this._basementFloorList[_loc3_].left) / (_loc2_ * 4));
            _loc3_++;
         }
         this._maxVisitor = Math.min(_loc1_,this.MAX_VISITOR);
      }
      
      function createRandomVisitor(param1:Number) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this._currentVisitorList.length < this._maxVisitor)
         {
            _loc2_ = 0;
            while(_loc2_ < 3)
            {
               _loc3_ = false;
               if(Calculate.chance(param1))
               {
                  if(this._halte.canSendWagon)
                  {
                     _loc4_ = this._popularity;
                     if(this._deepRain)
                     {
                        _loc4_ += 10;
                     }
                     if(Calculate.chance(_loc4_))
                     {
                        this._halte.sendWagon();
                     }
                     else
                     {
                        _loc3_ = true;
                     }
                  }
                  else
                  {
                     _loc3_ = true;
                  }
               }
               if(_loc3_)
               {
                  if(this._deepRain)
                  {
                     _loc5_ = 40;
                     if(this._weather < -20)
                     {
                        _loc5_ = 20;
                     }
                     if(Calculate.chance(_loc5_))
                     {
                        this.addVisitor();
                     }
                  }
                  else
                  {
                     this.addVisitor();
                  }
               }
               _loc2_++;
            }
            this._main.updateHistoryMax("visitor",this._currentVisitorList.length);
         }
      }
      
      function thiefCheck(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this._main.dayPassed >= 3)
         {
            if(!this._alarmTrigger)
            {
               _loc2_ = param1.hour;
               _loc3_ = param1.minute;
               if(_loc2_ >= 22 || _loc2_ < 5 && (_loc2_ < 4 || _loc3_ < 30))
               {
                  if(this.thiefDelay > 0)
                  {
                     --this.thiefDelay;
                  }
                  else
                  {
                     _loc4_ = Math.max(Math.min(100,this._popularity * 1.8),Math.min(100,Math.max(0,(this.main.budget - 50000) / 2500)));
                     _loc5_ = 1;
                     if(this._deepRain)
                     {
                        if(this._weather < -20)
                        {
                           _loc5_ = 0.8;
                        }
                     }
                     if((_loc6_ = this._main.mission.thiefMod) != null)
                     {
                        _loc5_ *= _loc6_;
                     }
                     _loc7_ = _loc4_ * _loc5_;
                     if(Calculate.chance(_loc7_))
                     {
                        this.createThief();
                     }
                     this.thiefDelay = 15 - Math.round(_loc4_ / 100 * 10);
                  }
               }
            }
         }
      }
      
      function villainCheck(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this._main.dayPassed >= 3 && this._main.mission.currentProgress >= 15)
         {
            _loc2_ = param1.hour;
            if(_loc2_ >= 11 && _loc2_ < 20)
            {
               if(this.villainDelay > 0)
               {
                  --this.villainDelay;
               }
               else
               {
                  _loc3_ = Math.max(Math.min(60,this._popularity * 2 / 3));
                  _loc4_ = 1;
                  if(this._deepRain)
                  {
                     if(this._weather < -20)
                     {
                        _loc4_ = 0.4;
                     }
                     else
                     {
                        _loc4_ = 0.6;
                     }
                  }
                  if("villainChanceReduce" in this._upgradeModifier)
                  {
                     _loc4_ *= 1 - this._upgradeModifier["villainChanceReduce"];
                  }
                  _loc5_ = _loc3_ * _loc4_;
                  if(Calculate.chance(_loc5_))
                  {
                     _loc6_ = 0;
                     if(this._main.mission.currentProgress >= 25)
                     {
                        _loc6_ = 20;
                     }
                     if(Calculate.chance(_loc6_))
                     {
                        this.createWizard();
                     }
                     else
                     {
                        this.createLitter();
                     }
                  }
                  this.villainDelay = 15 - Math.round(_loc3_ / 100 * 10);
               }
            }
         }
      }
      
      function cloudAddedCheck() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc1_:* = this._weather < 0 ? 12 : (this._weather < 20 ? 7 : (this._weather < 30 ? 4 : 2));
         var _loc2_:* = _loc1_ - this.cloudWeight;
         if(_loc2_ > 0)
         {
            _loc3_ = new Cloud();
            _loc3_.gotoAndStop(Math.floor(Math.random() * _loc3_.totalFrames) + 1);
            if((_loc4_ = Math.ceil(_loc3_.currentFrame / 2)) <= _loc2_)
            {
               _loc3_.speed = Math.random() * 2 + 1;
               _loc5_ = this.globalToLocal(new Point(700,0));
               _loc3_.x = _loc5_.x + _loc3_.width / 2 + 5;
               _loc3_.y = Math.random() * 350 - 300;
               this._cloudList.push(_loc3_);
               this._cloudList.sortOn("speed",Array.NUMERIC);
               _loc6_ = this._cloudList.indexOf(_loc3_);
               _loc7_ = 0.6 + 0.4 * (1 - this._currentWeatherPercent);
               _loc3_.transform.colorTransform = new ColorTransform(_loc7_,_loc7_,_loc7_,1,0,0,0,0);
               this._bgContainer.addChildAt(_loc3_,_loc6_);
               addListenerOf(_loc3_,LoopEvent.ON_IDLE,this.moveCloud);
            }
         }
      }
      
      function weatherChangeCheck() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:* = this._forecast + Math.random() * 10;
         if(this._weather < -20)
         {
            if(_loc1_ < 0)
            {
               _loc1_ *= 0.5;
            }
            else if(this._weather < -3)
            {
               _loc1_ *= 1.5;
            }
         }
         else if(this._weather > 2)
         {
            if(_loc1_ > 0)
            {
               _loc1_ *= 0.5;
            }
            else if(this._weather > 3)
            {
               _loc1_ *= 1.5;
            }
         }
         var _loc2_:* = this._weather + Math.round(_loc1_);
         if(_loc2_ <= -20)
         {
            if(this._weather > -20)
            {
               if(this._rainEnvirontment.stage == null)
               {
                  this._rainEnvirontment.alpha = 0;
                  this.dRainAlpha = 1;
                  _loc3_ = getChildIndex(this._mainContainer);
                  addChildAt(this._rainEnvirontment,_loc3_);
               }
            }
         }
         this._weather = Math.min(this._maxWeatherPoint,Math.max(this._minWeatherPoint,_loc2_));
         if(this._main.dayPassed < 3)
         {
            if(this._weather < -20)
            {
               this._weather = 20;
            }
         }
         if(this._deepRain)
         {
            if(this._weather > -10)
            {
               this._deepRain = false;
            }
         }
         else if(this._weather <= -25)
         {
            this._deepRain = true;
         }
      }
      
      function checkWeather(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         if(this._rainEnvirontment.stage != null)
         {
            if(this._weather > -30 || this.dRainAlpha < 0)
            {
               _loc2_ = 0.08 + (-20 - this._weather) / 10 * 0.08;
               this._rainEnvirontment.alpha = Math.max(0,this._rainEnvirontment.alpha + 0.08 * this.dRainAlpha);
               if(this._rainEnvirontment.alpha >= 0.5 || this._rainEnvirontment.alpha <= 0)
               {
                  this.dRainAlpha *= -1;
               }
               if(this._rainEnvirontment.alpha == 0 && this._weather > -20)
               {
                  this._rainEnvirontment.parent.removeChild(this._rainEnvirontment);
               }
            }
            else if(this._rainEnvirontment.alpha < 1)
            {
               this._rainEnvirontment.alpha = Math.min(1,this._rainEnvirontment.alpha + 0.16);
            }
         }
      }
      
      function checkBonusGain(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = this._bonusList.indexOf(_loc2_);
         if(_loc3_ in this._bonusList)
         {
            this._bonusList.splice(_loc3_,1);
         }
      }
      
      function checkBonusDrop(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = this._mainContainer.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
         var _loc4_:* = new Bonus();
         var _loc5_:* = 0;
         var _loc6_:* = null;
         if(param1.tag is Number)
         {
            _loc5_ = param1.tag;
         }
         else if(param1.tag is Object)
         {
            _loc5_ = param1.tag.amount;
            _loc6_ = param1.tag.giveTo;
         }
         _loc4_.x = _loc3_.x;
         _loc4_.y = _loc3_.y;
         _loc4_.world = this;
         _loc4_.amount = _loc5_;
         _loc4_.vSpeed = -10;
         if(_loc6_ != null)
         {
            _loc6_.performCoin.push(_loc4_);
         }
         this._bonusContainer.addChild(_loc4_);
         this._bonusList.push(_loc4_);
      }
      
      function startToBuild(param1:CommandEvent) : void
      {
         if(this._buildProgress != null)
         {
            this._buildProgress.stopProgress();
            this._buildProgress = null;
         }
         var _loc2_:* = BuildingData.returnIconTo(param1.tag.icon);
         if(_loc2_ == "Elevator")
         {
            this._buildProgress = new ElevatorBuildProgress();
         }
         else if(_loc2_ == "Stairs")
         {
            this._buildProgress = new StairBuildProgress();
         }
         else
         {
            this._buildProgress = new BuildProgress();
         }
         if(this._buildProgress != null)
         {
            this._buildProgress.world = this;
            this._buildProgress.source = param1.tag;
            this._buildProgress.runProgress();
         }
      }
      
      function cancelToBuild(param1:CommandEvent) : void
      {
         if(this._buildProgress != null)
         {
            if(this._buildProgress.source == param1.tag || param1.tag == null)
            {
               if(this._buildProgress is StaffHireProgress)
               {
                  dispatchEvent(new GameEvent(GameEvent.FINISH_HIRE_PROGRESS));
               }
               this._buildProgress.stopProgress();
               this._buildProgress = null;
            }
         }
      }
      
      function startToHire(param1:CommandEvent) : void
      {
         if(this._buildProgress != null)
         {
            this._buildProgress.stopProgress();
            this._buildProgress = null;
         }
         this._buildProgress = new StaffHireProgress();
         this._buildProgress.world = this;
         var _loc2_:StaffHireProgress = this._buildProgress as StaffHireProgress;
         if(_loc2_ != null)
         {
            _loc2_.stat = param1.tag.stat;
            _loc2_.job = param1.tag.job;
            _loc2_.workTimeIndex = param1.tag.workTimeIndex;
            _loc2_.cost = param1.tag.cost;
         }
         this._buildProgress.runProgress();
      }
      
      function startToRelocate(param1:CommandEvent) : void
      {
         if(this._buildProgress != null)
         {
            this._buildProgress.stopProgress();
            this._buildProgress = null;
         }
         this._buildProgress = new RelocateBuilding();
         this._buildProgress.world = this;
         if(this._buildProgress != null)
         {
            this._buildProgress.source = param1.target;
            this._buildProgress.runProgress();
         }
      }
      
      function startToExpand(param1:CommandEvent) : void
      {
         var _loc2_:ExpandElevatorProgress = null;
         if(this._buildProgress == null)
         {
            this._buildProgress = new ExpandElevatorProgress();
            this._buildProgress.world = this;
            _loc2_ = this._buildProgress as ExpandElevatorProgress;
            if(_loc2_ != null)
            {
               _loc2_.expandedElavator = param1.target;
            }
            this._buildProgress.runProgress();
            addListenerOf(this,CommandEvent.FINISH_EXPAND,this.endExpand);
            addListenerOf(this,CommandEvent.CONFIRM_EXPAND,this.confirmExpand);
         }
      }
      
      function confirmExpand(param1:CommandEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc2_:* = param1.tag;
         if(_loc2_.toBuildData.length > 0)
         {
            _loc3_ = _loc2_.expandedElavator;
            if(_loc3_ != null)
            {
               _loc4_ = (_loc3_ as Elevator).bodyList[_loc3_.bodyTarget];
               _loc5_ = new Array();
               _loc6_ = 0;
               while(_loc6_ < _loc2_.toBuildData.length)
               {
                  _loc9_ = (_loc8_ = _loc2_.toBuildData[_loc6_]).coordinate;
                  (_loc10_ = new FacilityElevatorBody()).world = this;
                  _loc10_.x = _loc9_.x;
                  _loc10_.y = _loc9_.y;
                  _loc10_.stop();
                  _loc10_.level = _loc3_.level;
                  this.checkBuildingCompatibility(_loc10_);
                  this._buildingList.push(_loc10_);
                  this._buildContainer.addChild(_loc10_);
                  this.removeWallHitting(_loc10_);
                  this.removeColumnHitting(_loc10_);
                  if((_loc11_ = this.addColumnFrom(_loc10_)) != null)
                  {
                     if(_loc11_.left != null)
                     {
                        this._buildContainer.addChild(_loc11_.left);
                     }
                     if(_loc11_.right != null)
                     {
                        this._buildContainer.addChild(_loc11_.right);
                     }
                  }
                  _loc12_ = null;
                  if(_loc9_.y <= 0)
                  {
                     _loc12_ = this.createFloor(_loc10_);
                  }
                  if(_loc12_ != null)
                  {
                     if(this._buildContainer.getChildByName(_loc12_.name) == null)
                     {
                        this._buildContainer.addChild(_loc12_);
                     }
                  }
                  _loc3_.bodyList.push(_loc10_);
                  _loc5_.push(_loc10_);
                  _loc6_++;
               }
               _loc3_.bodyList.sortOn("y",Array.NUMERIC | Array.DESCENDING);
               _loc7_ = _loc3_.bodyList.indexOf(_loc4_);
               _loc3_.bodyTarget = _loc7_;
               _loc3_.recreateElevator();
               this._main.updateHistoryMax("elevator",this.countRoomElevator());
               while(_loc5_.length > 0)
               {
                  dispatchEvent(new GameEvent(GameEvent.BUILDING_CREATED,_loc5_.shift()));
               }
            }
         }
      }
      
      function endExpand(param1:CommandEvent) : void
      {
         removeListenerOf(this,CommandEvent.FINISH_EXPAND,this.endExpand);
         removeListenerOf(this,CommandEvent.CONFIRM_EXPAND,this.confirmExpand);
         this._buildProgress = null;
      }
      
      function countRoomElevator() : int
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this._elevatorList.length)
         {
            _loc1_ += this._elevatorList[_loc2_].bodyList.length;
            _loc2_++;
         }
         return _loc1_;
      }
      
      function whenBuildingUpdated(param1:GameEvent) : void
      {
         this.checkMaxPopularity();
         this._main.updateHistoryMax("maxUpgradeBooth",this._main.mission.countBuildingWithLevel(3,this._boothList));
      }
      
      function buildingInProgress(param1:CommandEvent) : void
      {
         var buildingClass:* = undefined;
         var buildingCategory:* = undefined;
         var coordinate:* = undefined;
         var newBuilding:* = undefined;
         var newBoothStatistic:* = undefined;
         var newColumn:* = undefined;
         var newFloor:* = undefined;
         var newExtend:* = undefined;
         var extendColumn:* = undefined;
         var extendFloor:* = undefined;
         var newElevator:* = undefined;
         var checkAfterRapidBuild:Function = null;
         var e:CommandEvent = param1;
         var buildData:* = e.tag;
         if(buildData.enableToBuild)
         {
            buildingClass = BuildingData.getClassOf(buildData.type);
            buildingCategory = BuildingData.getCategoryOf(buildData.type);
            if(buildingClass != null)
            {
               coordinate = buildData.coordinate;
               newBuilding = new buildingClass();
               newBuilding.world = this;
               newBuilding.x = coordinate.x;
               newBuilding.y = coordinate.y;
               newBuilding.scaleX = buildData.flipped;
               newBuilding.level = 1;
               newBuilding.stop();
               if(!(newBuilding is FacilityElevatorBody))
               {
                  this._onInfoBuildingList.push(newBuilding);
               }
               if(newBuilding is Booth)
               {
                  newBuilding.open = false;
                  newBuilding.generateShopkeeper();
                  if(buildingCategory != BuildingData.INN && !(newBuilding is BoothColloseum))
                  {
                     this._brokableBuildingList.push(newBuilding);
                  }
                  if(newBuilding is BoothLodging)
                  {
                     this._innList.push(newBuilding);
                  }
                  else if(newBuilding is FacilityTradingPost)
                  {
                     this._tradingPostList.push(newBuilding);
                     this._main.updateHistoryMax("tradingPost",this._transportList.length);
                  }
                  else
                  {
                     this._boothList.push(newBuilding);
                  }
                  if(!(newBuilding is FacilityTradingPost))
                  {
                     if(!(buildData.type in this._boothListByType))
                     {
                        this._boothListByType[buildData.type] = new Array();
                     }
                     this._boothListByType[buildData.type].push(newBuilding);
                     newBoothStatistic = new StatisticItem();
                     newBoothStatistic.relation = newBuilding;
                     newBoothStatistic.numberVisitor = 0;
                     newBoothStatistic.revenue = 0;
                     newBoothStatistic.expenditure = 0;
                     newBoothStatistic.showVisitor = true;
                     newBoothStatistic.showRevenue = true;
                     newBoothStatistic.showExpenditure = false;
                     this._main.currentStatistic.boothStatistic.push(newBoothStatistic);
                     this._main.updateHistoryMax("largeBooth",this.countLargeBooth());
                  }
               }
               else
               {
                  if(newBuilding is FacilityRestRoom)
                  {
                     this._restRoomList.push(newBuilding);
                     this._main.updateHistoryMax("restroom",this._restRoomList.length);
                  }
                  if(newBuilding is FacilityTerrace)
                  {
                     this._terraceList.push(newBuilding);
                     this._main.updateHistoryMax("terrace",this._terraceList.length);
                  }
                  if(newBuilding is FacilityGuardPost)
                  {
                     newBuilding.createSpecialGuard(coordinate);
                     this._guardPostList.push(newBuilding);
                  }
               }
               if(buildData is StairBuildProgress)
               {
                  this._stairList.push(newBuilding);
                  this._transportList.push(newBuilding);
                  this._frontContainer.addChild(newBuilding);
                  this._needToSwapObject.push(newBuilding);
                  this.swapDepthObject();
                  this._main.updateHistoryMax("stairs",this._stairList.length);
                  dispatchEvent(new GameEvent(GameEvent.BUILDING_CREATED,newBuilding));
               }
               else
               {
                  this.checkBuildingCompatibility(newBuilding);
                  this._buildingList.push(newBuilding);
                  this._buildContainer.addChild(newBuilding);
                  this.removeWallHitting(newBuilding);
                  this.removeColumnHitting(newBuilding);
                  newColumn = this.addColumnFrom(newBuilding);
                  if(newColumn != null)
                  {
                     if(newColumn.left != null)
                     {
                        this._buildContainer.addChild(newColumn.left);
                     }
                     if(newColumn.right != null)
                     {
                        this._buildContainer.addChild(newColumn.right);
                     }
                  }
                  newFloor = null;
                  if(coordinate.y <= 0)
                  {
                     newFloor = this.createFloor(newBuilding);
                  }
                  else
                  {
                     this.createWall(coordinate.y);
                  }
                  if(newFloor != null)
                  {
                     if(this._buildContainer.getChildByName(newFloor.name) == null)
                     {
                        this._buildContainer.addChild(newFloor);
                     }
                  }
                  dispatchEvent(new GameEvent(GameEvent.BUILDING_CREATED,newBuilding));
                  if(buildData is ElevatorBuildProgress)
                  {
                     newExtend = new buildingClass();
                     newExtend.world = this;
                     newExtend.x = coordinate.x;
                     newExtend.y = newFloor.y;
                     newExtend.stop();
                     this.checkBuildingCompatibility(newExtend);
                     this._buildingList.push(newExtend);
                     this._buildContainer.addChild(newExtend);
                     this.removeWallHitting(newExtend);
                     this.removeColumnHitting(newExtend);
                     extendColumn = this.addColumnFrom(newExtend);
                     if(extendColumn != null)
                     {
                        if(extendColumn.left != null)
                        {
                           this._buildContainer.addChild(extendColumn.left);
                        }
                        if(extendColumn.right != null)
                        {
                           this._buildContainer.addChild(extendColumn.right);
                        }
                     }
                     extendFloor = null;
                     if(coordinate.y <= 0)
                     {
                        extendFloor = this.createFloor(newExtend);
                     }
                     if(extendFloor != null)
                     {
                        if(this._buildContainer.getChildByName(extendFloor.name) == null)
                        {
                           this._buildContainer.addChild(extendFloor);
                        }
                     }
                     newElevator = new Elevator();
                     newElevator.world = this;
                     newElevator.x = newBuilding.x;
                     newElevator.bodyList.push(newBuilding);
                     newElevator.bodyList.push(newExtend);
                     newElevator.bodyList.sortOn("y",Array.NUMERIC | Array.DESCENDING);
                     this._elevatorContainer.addChild(newElevator);
                     this._elevatorList.push(newElevator);
                     this._transportList.push(newElevator);
                     this._onInfoBuildingList.push(newElevator);
                     this._main.updateHistoryMax("elevator",this.countRoomElevator());
                     dispatchEvent(new GameEvent(GameEvent.BUILDING_CREATED,newExtend));
                  }
               }
               if(this.buttonPressed.indexOf(Keyboard.SHIFT) >= 0 && buildingClass != FacilityGuardPost)
               {
                  checkAfterRapidBuild = function(param1:KeyboardEvent):void
                  {
                     var _loc2_:* = param1.keyCode;
                     if(_loc2_ == Keyboard.SHIFT)
                     {
                        removeListenerOf(stage,KeyboardEvent.KEY_UP,checkAfterRapidBuild);
                        dispatchEvent(new GameEvent(GameEvent.FINISH_BUILD_PROGRESS));
                     }
                  };
                  addListenerOf(stage,KeyboardEvent.KEY_UP,checkAfterRapidBuild);
               }
               else
               {
                  dispatchEvent(new GameEvent(GameEvent.FINISH_BUILD_PROGRESS));
               }
            }
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Unable build there"));
         }
      }
      
      function countLargeBooth() : int
      {
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this._boothList.length)
         {
            _loc3_ = this._boothList[_loc2_];
            if(_loc3_.brokenClip is BrokenLarge)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      function hireInProgress(param1:CommandEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = param1.tag;
         var _loc3_:* = null;
         switch(param1.tag.job)
         {
            case "janitor":
               _loc3_ = new StaffJanitor();
               break;
            case "handyman":
               _loc3_ = new StaffHandyman();
               break;
            case "entertainer":
               _loc3_ = new StaffEntertainer();
               break;
            case "guard":
               _loc3_ = new StaffGuard();
         }
         if(_loc3_ != null)
         {
            _loc4_ = _loc2_.coordinate;
            _loc3_.x = _loc4_.x;
            _loc3_.y = _loc4_.y;
            _loc3_.scaleX = _loc2_.flipped;
            _loc3_.salaryObject = null;
            _loc3_.world = this;
            _loc3_.basicPayment = _loc2_.cost;
            if(param1.tag.stat != null)
            {
               _loc3_.stat = param1.tag.stat;
            }
            if(param1.tag.workTime != null)
            {
               _loc3_.workTime.workStart = param1.tag.workTime.start;
               _loc3_.workTime.workEnd = param1.tag.workTime.end;
            }
            dispatchEvent(new GameEvent(GameEvent.HIRE_STAFF,_loc3_));
            this.addHuman(_loc3_);
         }
         dispatchEvent(new GameEvent(GameEvent.FINISH_HIRE_PROGRESS));
         this._buildProgress.stopProgress();
         this._buildProgress = null;
      }
      
      function relocateInProgress(param1:CommandEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:* = param1.tag;
         if(_loc2_.enableToBuild)
         {
            _loc3_ = _loc2_.source;
            this.checkReverseBuildingCompatibility(_loc3_);
            _loc4_ = new Point(_loc3_.x,_loc3_.y);
            _loc5_ = _loc2_.coordinate;
            _loc3_.x = _loc5_.x;
            _loc3_.y = _loc5_.y;
            _loc3_.scaleX = _loc2_.flipped;
            this.checkBuildingCompatibility(_loc3_);
            this.createWall(_loc4_.y);
            this.removeWallHitting(_loc3_);
            this.removeColumnHitting(_loc3_);
            if((_loc6_ = this.addColumnFrom(_loc3_)) != null)
            {
               if(_loc6_.left != null)
               {
                  this._buildContainer.addChild(_loc6_.left);
               }
               if(_loc6_.right != null)
               {
                  this._buildContainer.addChild(_loc6_.right);
               }
            }
            _loc7_ = null;
            if(_loc5_.y <= 0)
            {
               _loc7_ = this.createFloor(_loc3_);
            }
            else
            {
               this.createWall(_loc5_.y);
            }
            if(_loc7_ != null)
            {
               if(this._buildContainer.getChildByName(_loc7_.name) == null)
               {
                  this._buildContainer.addChild(_loc7_);
               }
            }
            dispatchEvent(new GameEvent(GameEvent.BUILDING_CREATED,_loc3_));
            this._buildProgress.stopProgress();
            this._buildProgress = null;
         }
         else
         {
            dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Unable to move there"));
         }
      }
      
      function checkReverseBuildingCompatibility(param1:*) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < this._buildingList.length)
         {
            if((_loc4_ = this._buildingList[_loc3_]) != param1)
            {
               if(_loc4_.y == param1.y)
               {
                  _loc5_ = Math.abs(param1.x - param1.width / 2 - (_loc4_.x + _loc4_.width / 2));
                  _loc6_ = Math.abs(_loc4_.x - _loc4_.width / 2 - (param1.x + param1.width / 2));
                  if((_loc7_ = Math.round(Math.min(_loc5_,_loc6_) / this.GRID)) <= 5)
                  {
                     if((_loc8_ = ComboList.checkComboRelation(param1,_loc4_)) != 0)
                     {
                        _loc9_ = new Point(param1.x,param1.y - param1.height / 2);
                        if(_loc4_.x < param1.x)
                        {
                           _loc9_.x = param1.x - param1.width / 2 - _loc5_ / 2;
                        }
                        else if(param1.x < _loc4_.x)
                        {
                           _loc9_.x = param1.x + param1.width / 2 + _loc6_ / 2;
                        }
                        _loc10_ = {
                           "combo":_loc8_,
                           "position":_loc9_
                        };
                        _loc2_.push(_loc10_);
                     }
                  }
               }
            }
            _loc3_++;
         }
         while(_loc2_.length > 0)
         {
            if((_loc11_ = _loc2_.shift()).combo > 0)
            {
               this._popularityModifier -= 0.1;
            }
            else
            {
               this._popularityModifier += 0.1;
            }
         }
      }
      
      public function getComboIndex(param1:String, param2:String) : *
      {
         var _loc5_:* = undefined;
         var _loc3_:* = null;
         var _loc4_:* = 0;
         while(_loc4_ < this._combination.good.length)
         {
            if((_loc5_ = this._combination.good[_loc4_]).tier1 == param1 && _loc5_.tier2 == param2 || _loc5_.tier1 == param2 && _loc5_.tier2 == param1)
            {
               _loc3_ = new Object();
               _loc3_.index = _loc4_;
               _loc3_.goodRelation = true;
               break;
            }
            _loc4_++;
         }
         if(_loc3_ == null)
         {
            _loc4_ = 0;
            while(_loc4_ < this._combination.bad.length)
            {
               if((_loc5_ = this._combination.bad[_loc4_]).tier1 == param1 && _loc5_.tier2 == param2 || _loc5_.tier1 == param2 && _loc5_.tier2 == param1)
               {
                  _loc3_ = new Object();
                  _loc3_.index = _loc4_;
                  _loc3_.goodRelation = false;
                  break;
               }
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      function checkBuildingCompatibility(param1:*) : void
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
         var _loc3_:* = 0;
         while(_loc3_ < this._buildingList.length)
         {
            if((_loc4_ = this._buildingList[_loc3_]) != param1)
            {
               if(_loc4_.y == param1.y)
               {
                  _loc5_ = Math.abs(param1.x - param1.width / 2 - (_loc4_.x + _loc4_.width / 2));
                  _loc6_ = Math.abs(_loc4_.x - _loc4_.width / 2 - (param1.x + param1.width / 2));
                  if((_loc7_ = Math.round(Math.min(_loc5_,_loc6_) / this.GRID)) <= 5)
                  {
                     if((_loc8_ = ComboList.checkComboRelation(param1,_loc4_)) != 0)
                     {
                        _loc9_ = new Point(param1.x,param1.y - param1.height / 2);
                        if(_loc4_.x < param1.x)
                        {
                           _loc9_.x = param1.x - param1.width / 2 - _loc5_ / 2;
                        }
                        else if(param1.x < _loc4_.x)
                        {
                           _loc9_.x = param1.x + param1.width / 2 + _loc6_ / 2;
                        }
                        _loc10_ = {
                           "combo":_loc8_,
                           "position":_loc9_
                        };
                        _loc2_.push(_loc10_);
                        if((_loc11_ = this.getComboIndex(BuildingData.returnClassTo(Utility.getClass(param1)),BuildingData.returnClassTo(Utility.getClass(_loc4_)))) != null)
                        {
                           if(_loc11_.goodRelation)
                           {
                              if(!this._combination.good[_loc11_.index].unlocked)
                              {
                                 this._combination.good[_loc11_.index].unlocked = true;
                              }
                           }
                           else if(!this._combination.bad[_loc11_.index].unlocked)
                           {
                              this._combination.bad[_loc11_.index].unlocked = true;
                           }
                        }
                     }
                  }
               }
            }
            _loc3_++;
         }
         while(_loc2_.length > 0)
         {
            _loc12_ = _loc2_.shift();
            (_loc13_ = new ThumbSign()).gotoAndStop(_loc12_.combo > 0 ? "good" : "bad");
            _loc13_.x = _loc12_.position.x;
            _loc13_.y = _loc12_.position.y;
            this._bonusContainer.addChild(_loc13_);
            _loc14_ = _loc13_.y - 50;
            if(_loc12_.combo > 0)
            {
               this._popularityModifier += 0.1;
               TweenLite.to(_loc13_,0.4,{
                  "y":_loc14_,
                  "ease":Linear.easeNone,
                  "onComplete":TweenLite.to,
                  "onCompleteParams":[_loc13_,0.4,{
                     "delay":0.4,
                     "alpha":0,
                     "ease":Linear.easeNone,
                     "onComplete":this.removeTarget,
                     "onCompleteParams":[_loc13_]
                  }]
               });
            }
            else
            {
               this._popularityModifier -= 0.1;
               TweenLite.from(_loc13_,0.4,{
                  "y":_loc14_,
                  "onComplete":TweenLite.to,
                  "onCompleteParams":[_loc13_,0.4,{
                     "delay":0.4,
                     "alpha":0,
                     "ease":Linear.easeNone,
                     "onComplete":this.removeTarget,
                     "onCompleteParams":[_loc13_]
                  }]
               });
            }
         }
         this._main.updateHistoryMax("combo",this.countCombo(true));
      }
      
      function removeTarget(param1:*) : void
      {
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      public function countCurrentSpecialVisitor() : int
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this._specialVisitorList.length)
         {
            if(this._currentVisitorList.indexOf(this._specialVisitorList[_loc2_]) >= 0)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         trace(_loc1_);
         return _loc1_;
      }
      
      public function countCombo(param1:Boolean) : int
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(_loc3_ < this._buildingList.length - 1)
         {
            _loc4_ = this._buildingList[_loc3_];
            _loc5_ = _loc3_ + 1;
            while(_loc5_ < this._buildingList.length)
            {
               if((_loc6_ = this._buildingList[_loc5_]) != _loc4_)
               {
                  if(_loc6_.y == _loc4_.y)
                  {
                     _loc7_ = Math.abs(_loc4_.x - _loc4_.width / 2 - (_loc6_.x + _loc6_.width / 2));
                     _loc8_ = Math.abs(_loc6_.x - _loc6_.width / 2 - (_loc4_.x + _loc4_.width / 2));
                     if((_loc9_ = Math.round(Math.min(_loc7_,_loc8_) / this.GRID)) <= 5)
                     {
                        if((_loc10_ = ComboList.checkComboRelation(_loc4_,_loc6_)) != 0)
                        {
                           if(param1 && _loc10_ > 0)
                           {
                              _loc2_++;
                           }
                           if(!param1 && _loc10_ < 0)
                           {
                              _loc2_++;
                           }
                        }
                     }
                  }
               }
               _loc5_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function swapDepthObject() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this._needToSwapObject.length > 0)
         {
            this._needToSwapObject.sortOn(["y","priority"],Array.NUMERIC);
            _loc1_ = new Array();
            _loc2_ = 0;
            while(_loc2_ < this._frontContainer.numChildren)
            {
               _loc3_ = this._frontContainer.getChildAt(_loc2_);
               _loc1_.push(_loc3_);
               _loc2_++;
            }
            _loc1_.sortOn(["y","priority"],Array.NUMERIC);
            while(this._needToSwapObject.length > 0)
            {
               _loc4_ = this._needToSwapObject.shift();
               if((_loc5_ = _loc1_.indexOf(_loc4_)) in _loc1_)
               {
                  this._frontContainer.setChildIndex(_loc4_,_loc5_);
               }
            }
         }
      }
      
      function destroyProgress(param1:GameEvent) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc2_:* = param1.target;
         _loc2_.dispatchEvent(new GameEvent(GameEvent.BEFORE_DESTROY_CHECK));
         var _loc3_:* = [this._buildingList,this._brokableBuildingList,this._boothList,this._restRoomList,this._innList,this._tradingPostList,this._onInfoBuildingList,this._guardPostList,this._terraceList];
         var _loc4_:*;
         if((_loc4_ = BuildingData.returnClassTo(Utility.getClass(_loc2_))) in this._boothListByType)
         {
            _loc3_.push(this._boothListByType[_loc4_]);
         }
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_.length)
         {
            if((_loc7_ = (_loc6_ = _loc3_[_loc5_]).indexOf(_loc2_)) in _loc6_)
            {
               _loc6_.splice(_loc7_,1);
            }
            _loc5_++;
         }
         dispatchEvent(new GameEvent(GameEvent.BUILDING_DESTROYED,_loc2_));
         if(this._transportList.indexOf(_loc2_) < 0)
         {
            if(_loc2_.stage != null)
            {
               _loc2_.parent.removeChild(_loc2_);
               this.createWall(_loc2_.y);
            }
         }
      }
      
      function buildingToDestroy(param1:CommandEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = param1.target;
         if(_loc2_ is Booth || _loc2_ is FacilityRestRoom || _loc2_ is FacilityGuardPost || _loc2_ is FacilityTerrace)
         {
            _loc2_.dispatchEvent(new GameEvent(GameEvent.DESTROY));
         }
         else
         {
            if(_loc2_ is Elevator)
            {
               if((_loc5_ = this._elevatorList.indexOf(_loc2_)) in this._elevatorList)
               {
                  this._elevatorList.splice(_loc5_,1);
                  _loc2_.destroyBody();
               }
               _loc2_.dispatchEvent(new GameEvent(GameEvent.DESTROY));
            }
            if(_loc2_ is FacilityStairs)
            {
               if((_loc6_ = this._stairList.indexOf(_loc2_)) in this._stairList)
               {
                  this._stairList.splice(_loc6_,1);
               }
            }
            _loc3_ = this._transportList.indexOf(_loc2_);
            if(_loc3_ in this._transportList)
            {
               this._transportList.splice(_loc3_,1);
            }
            _loc4_ = this._onInfoBuildingList.indexOf(_loc2_);
            if(_loc3_ in this._onInfoBuildingList)
            {
               this._onInfoBuildingList.splice(_loc4_,1);
            }
            dispatchEvent(new GameEvent(GameEvent.BUILDING_DESTROYED,_loc2_));
            if(_loc2_.stage != null)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
      }
      
      function staffToFire(param1:CommandEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = param1.target;
         for(_loc3_ in this._staffList)
         {
            if((_loc5_ = (_loc4_ = this._staffList[_loc3_]).indexOf(_loc2_)) in _loc4_)
            {
               _loc4_.splice(_loc5_,1);
            }
         }
         _loc2_.dispatchEvent(new GameEvent(GameEvent.FIRE));
      }
      
      function createScenery() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:* = new SceneryBackground();
         this._sceneryContainer.addChild(_loc1_);
         while(this._sceneryContainer.width < this._mostRight - this._mostLeft)
         {
            _loc2_ = this._sceneryContainer.width;
            _loc3_ = new SceneryBackground();
            _loc3_.x = -_loc2_ / 2 - _loc3_.width / 2;
            this._sceneryContainer.addChild(_loc3_);
            (_loc4_ = new SceneryBackground()).x = _loc2_ / 2 + _loc4_.width / 2;
            this._sceneryContainer.addChild(_loc4_);
         }
      }
      
      function loadBuilding() : void
      {
         if(!this._main.loadGame)
         {
            this.addStarterBuilding();
         }
         var _loc1_:* = 0;
         while(_loc1_ < this._buildingList.length)
         {
            this._buildContainer.addChild(this._buildingList[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._columnList.length)
         {
            this._buildContainer.addChild(this._columnList[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._floorList.length)
         {
            this._buildContainer.addChild(this._floorList[_loc1_]);
            if(_loc1_ < this._floorList.length - 1)
            {
               this.createWall(this._floorList[_loc1_].y);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._basementFloorList.length)
         {
            this._buildContainer.addChild(this._basementFloorList[_loc1_]);
            if(_loc1_ > 0)
            {
               this.createWall(this._basementFloorList[_loc1_].y);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._stairList.length)
         {
            this._frontContainer.addChild(this._stairList[_loc1_]);
            this._needToSwapObject.push(this._stairList[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._elevatorList.length)
         {
            this._elevatorContainer.addChild(this._elevatorList[_loc1_]);
            _loc1_++;
         }
         this.loadPerson();
         this.loadTrash();
         if(this._needToSwapObject.length > 0)
         {
            this.swapDepthObject();
         }
      }
      
      function loadPerson() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._humanList.length)
         {
            _loc2_ = this._humanList[_loc1_];
            if(_loc2_.relatedCritter != null)
            {
               this._frontContainer.addChild(_loc2_.relatedCritter);
               this._needToSwapObject.push(_loc2_.relatedCritter);
            }
            if(_loc2_.inside == null)
            {
               this._frontContainer.addChild(_loc2_);
               this._needToSwapObject.push(_loc2_);
            }
            else
            {
               if(_loc2_.inside == this._dungeon)
               {
                  this._dungeon.addChild(_loc2_);
               }
               else if(_loc2_.inside is Wagon)
               {
                  _loc2_.passive = true;
                  _loc2_.inside.addPerson(_loc2_);
               }
               else if(_loc2_.inside is HalteWagon)
               {
                  _loc2_.inside.addPerson(_loc2_);
                  this._wagonContainer.addChild(_loc2_);
               }
               else
               {
                  _loc2_.inside.addPerson(_loc2_,true);
               }
               if(_loc2_.inside is FacilityElevatorBody)
               {
                  this._frontContainer.addChild(_loc2_);
                  this._needToSwapObject.push(_loc2_);
               }
               if(this._transportList.indexOf(_loc2_.inside) >= 0)
               {
                  if(!(_loc2_.inside is Elevator))
                  {
                     if(_loc2_.transportQueue.indexOf(_loc2_.inside) < 0)
                     {
                        _loc2_.transportQueue.push(_loc2_.inside);
                     }
                  }
               }
            }
            if(_loc2_ is Visitor)
            {
               _loc2_.initChat();
            }
            _loc1_++;
         }
      }
      
      function loadTrash() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._trashList.length)
         {
            _loc2_ = this._trashList[_loc1_];
            this._frontContainer.addChild(_loc2_);
            this._needToSwapObject.push(_loc2_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._pupList.length)
         {
            _loc3_ = this._pupList[_loc1_];
            this._frontContainer.addChild(_loc3_);
            this._needToSwapObject.push(_loc3_);
            _loc1_++;
         }
      }
      
      function addStarterBuilding() : void
      {
         var _loc1_:* = new BuildingInnEnterance();
         var _loc2_:* = new HalteWagon();
         var _loc3_:* = new BuildingInnConnection();
         this._dungeonConnection.push(_loc1_);
         this._dungeonConnection.push(_loc3_);
         var _loc4_:* = 0;
         while(_loc4_ < this._dungeonConnection.length)
         {
            this._dungeonConnection[_loc4_].world = this;
            _loc4_++;
         }
         _loc2_.world = this;
         this._onInfoBuildingList.push(_loc2_);
         this._halte = _loc2_;
         this._connectionSurface = _loc1_;
         var _loc5_:* = Math.round((_loc1_.width + _loc2_.width + this.GRID) / 2 / this.GRID) * this.GRID;
         _loc1_.x = -_loc5_ + _loc1_.width / 2;
         _loc2_.x = _loc1_.x + _loc1_.width / 2 + this.GRID + _loc2_.width / 2;
         _loc3_.x = _loc1_.x;
         _loc3_.y = this._basementFloorList[1].y;
         this._buildingList.push(_loc1_);
         this.addColumnFrom(_loc1_);
         this.createFloor(_loc1_);
         this._buildingList.push(_loc2_);
         this.addColumnFrom(_loc2_);
         this.createFloor(_loc2_);
         this._buildingList.push(_loc3_);
         this.addColumnFrom(_loc3_);
      }
      
      function addColumnFrom(param1:*) : *
      {
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc2_:* = {
            "left":null,
            "right":null
         };
         var _loc3_:* = param1.x - param1.width / 2 - 6;
         var _loc4_:* = param1.x + param1.width / 2 + 6;
         var _loc5_:* = param1.y;
         var _loc6_:* = false;
         var _loc7_:* = false;
         var _loc8_:* = 0;
         while(_loc8_ < this._columnList.length)
         {
            if((_loc9_ = this._columnList[_loc8_]).y == _loc5_)
            {
               if(!_loc6_)
               {
                  if(_loc9_.x == _loc3_)
                  {
                     _loc6_ = true;
                  }
               }
               if(!_loc7_)
               {
                  if(_loc9_.x == _loc4_)
                  {
                     _loc7_ = true;
                  }
               }
               if(_loc6_ && _loc7_)
               {
                  break;
               }
            }
            _loc8_++;
         }
         if(!_loc6_)
         {
            (_loc10_ = new Column()).x = _loc3_;
            _loc10_.y = _loc5_;
            _loc10_.gotoAndStop(_loc5_ <= 0 ? 1 : 2);
            this._columnList.push(_loc10_);
            _loc2_.left = _loc10_;
         }
         if(!_loc7_)
         {
            (_loc11_ = new Column()).x = _loc4_;
            _loc11_.y = _loc5_;
            _loc11_.gotoAndStop(_loc5_ <= 0 ? 1 : 2);
            this._columnList.push(_loc11_);
            _loc2_.right = _loc11_;
         }
         return _loc2_;
      }
      
      function checkMaxPopularity() : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc1_:* = BuildingData.BUILDING_LIST.concat();
         _loc1_.splice(_loc1_.indexOf("Elevator"),1);
         _loc1_.splice(_loc1_.indexOf("Stairs"),1);
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < this._buildingList.length)
         {
            _loc5_ = this._buildingList[_loc4_];
            _loc6_ = BuildingData.returnClassTo(Utility.getClass(_loc5_));
            if((_loc7_ = _loc1_.indexOf(_loc6_)) in _loc1_)
            {
               if(_loc2_.indexOf(_loc6_) < 0)
               {
                  _loc2_.push(_loc6_);
               }
            }
            _loc8_ = BuildingData.getCategoryOf(_loc6_);
            _loc9_ = 0;
            switch(_loc8_)
            {
               case BuildingData.GENERAL:
                  _loc9_ = 1;
                  break;
               case BuildingData.FOOD:
                  _loc9_ = 1.5;
                  break;
               case BuildingData.INN:
                  _loc9_ = 2;
                  break;
               case BuildingData.ENTERTAINMENT:
                  _loc9_ = 3;
                  break;
               case BuildingData.FACILITY:
                  if(_loc5_ is FacilityTerrace)
                  {
                     _loc9_ = 1.5;
                  }
                  else if(!(_loc5_ is FacilityStairs && _loc5_ is FacilityElevatorBody && _loc5_ is FacilityGuardPost))
                  {
                     _loc9_ = 0.5;
                  }
                  break;
            }
            _loc3_ += _loc9_ + _loc9_ * 0.2 * Math.max(0,_loc5_.level - 1);
            _loc4_++;
         }
         this._buildCompletionPopularity = _loc2_.length / _loc1_.length * 100;
         this._maxPopularity = this._level / 3 * (Math.min(_loc3_,100) * 0.4 + this._buildCompletionPopularity * 0.5) + 10;
      }
      
      public function expandArea() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         ++this._level;
         while(this._roadContainer.numChildren > 0)
         {
            this._roadContainer.removeChildAt(0);
         }
         this.createRoad();
         this._bottomFloor.left = this._mostLeft;
         this._bottomFloor.right = this._mostRight;
         var _loc1_:* = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._wallList.length)
         {
            _loc3_ = this._wallList[_loc2_];
            if(_loc3_.y > 0)
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         while(_loc1_.length > 0)
         {
            _loc4_ = _loc1_.shift();
            if((_loc5_ = this._wallList.indexOf(_loc4_)) in this._wallList)
            {
               this._wallList.splice(_loc5_,1);
            }
            _loc4_.parent.removeChild(_loc4_);
         }
         _loc2_ = 0;
         while(_loc2_ < this._basementFloorList.length)
         {
            this._basementFloorList[_loc2_].left = this._mostLeft;
            this._basementFloorList[_loc2_].right = this._mostRight;
            if(_loc2_ > 0)
            {
               this.createWall(this._basementFloorList[_loc2_].y);
            }
            _loc2_++;
         }
      }
      
      public function updatePopularity(param1:Number) : void
      {
         var _loc2_:* = (param1 - 50) / 50 * (2.5 * this._buildCompletionPopularity / 100 + 0.25);
         if(_loc2_ > 0)
         {
            if(this._popularityModifier >= 0)
            {
               _loc2_ *= 1 + this._popularityModifier;
            }
            else
            {
               _loc2_ *= Math.max(1 + this._popularityModifier,0.6);
            }
         }
         else if(_loc2_ < 0)
         {
            if(this._popularityModifier <= 0)
            {
               _loc2_ *= 1 + Math.abs(this._popularityModifier);
            }
            else
            {
               _loc2_ *= Math.max(1 - Math.abs(this._popularityModifier),0.6);
            }
         }
         var _loc3_:* = _loc2_ * 0.1;
         this._popularity += _loc2_ + (Math.random() * _loc3_ - 2 * _loc3_);
         if(this._popularity < 0)
         {
            this._popularity = 0;
         }
         if(this._popularity > this._maxPopularity)
         {
            this._popularity = this._maxPopularity;
         }
         dispatchEvent(new GameEvent(GameEvent.UPDATE_POPULARITY));
      }
      
      public function addPopularity(param1:Number) : void
      {
         this._popularity += param1;
         if(this._popularity > this._maxPopularity)
         {
            this._popularity = this._maxPopularity;
         }
         dispatchEvent(new GameEvent(GameEvent.UPDATE_POPULARITY));
      }
      
      public function createFloor(param1:*) : *
      {
         var _loc2_:* = param1.x - param1.width / 2 - this.GRID;
         var _loc3_:* = param1.x + param1.width / 2 + this.GRID;
         return this.addFloor(param1.y - Math.round(param1.height / this.GRID) * this.GRID - this.GRID,_loc2_,_loc3_);
      }
      
      public function addFloor(param1:Number, param2:Number, param3:Number) : *
      {
         var _loc7_:* = undefined;
         var _loc4_:* = false;
         var _loc5_:* = null;
         var _loc6_:* = 0;
         while(_loc6_ < this._floorList.length)
         {
            if(param1 == this._floorList[_loc6_].y)
            {
               _loc5_ = this._floorList[_loc6_];
               _loc4_ = true;
               break;
            }
            _loc6_++;
         }
         if(!_loc4_)
         {
            (_loc7_ = new FloorUG()).x = 0;
            _loc7_.y = param1;
            _loc7_.left = param2;
            _loc7_.right = param3;
            this._floorList.push(_loc7_);
            this._floorList.sortOn("y",Array.NUMERIC | Array.DESCENDING);
            return _loc7_;
         }
         _loc5_.left = Math.min(_loc5_.left,param2);
         _loc5_.right = Math.max(_loc5_.right,param3);
         this.createWall(_loc5_.y + 84);
         return _loc5_;
      }
      
      function createWall(param1:Number) : Array
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc2_:* = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:* = 0;
         while(_loc4_ < this._columnList.length)
         {
            if((_loc5_ = this._columnList[_loc4_]).y == param1)
            {
               _loc3_.push(_loc5_);
            }
            _loc4_++;
         }
         _loc3_.sortOn("x",Array.NUMERIC);
         if(param1 <= 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length - 1)
            {
               _loc6_ = _loc3_[_loc4_];
               _loc7_ = _loc3_[_loc4_ + 1];
               if((_loc8_ = this.addWall(_loc6_.x + _loc6_.width / 2,_loc7_.x - _loc7_.width / 2,param1)) != null)
               {
                  this._buildContainer.addChild(_loc8_);
                  _loc2_.push(_loc8_);
               }
               _loc4_++;
            }
         }
         else
         {
            _loc9_ = this._mostLeft;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc11_ = _loc3_[_loc4_].x - _loc3_[_loc4_].width / 2;
               if((_loc8_ = this.addWall(_loc9_,_loc11_,param1)) != null)
               {
                  this._buildContainer.addChild(_loc8_);
                  _loc2_.push(_loc8_);
               }
               _loc9_ = _loc3_[_loc4_].x + _loc3_[_loc4_].width / 2;
               _loc4_++;
            }
            _loc10_ = this._mostRight;
            if((_loc8_ = this.addWall(_loc9_,_loc10_,param1)) != null)
            {
               this._buildContainer.addChild(_loc8_);
               _loc2_.push(_loc8_);
            }
         }
         return _loc2_;
      }
      
      function addWall(param1:Number, param2:Number, param3:Number) : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc4_:* = null;
         if(param1 != param2)
         {
            _loc5_ = true;
            _loc6_ = 0;
            while(_loc6_ < this._buildingList.length)
            {
               if((_loc7_ = this._buildingList[_loc6_]).y == param3)
               {
                  if(_loc7_.x >= param1 && _loc7_.x <= param2)
                  {
                     _loc5_ = false;
                     break;
                  }
               }
               _loc6_++;
            }
            if(_loc5_)
            {
               _loc6_ = 0;
               while(_loc6_ < this._wallList.length)
               {
                  if((_loc8_ = this._wallList[_loc6_]).y == param3)
                  {
                     if(_loc8_.left >= param1 && _loc8_.left <= param2 || _loc8_.right >= param1 && _loc8_.right <= param2 || param1 >= _loc8_.left && param2 <= _loc8_.right)
                     {
                        _loc5_ = false;
                        break;
                     }
                  }
                  _loc6_++;
               }
            }
            if(_loc5_)
            {
               (_loc9_ = param3 <= 0 ? new WallUG() : new WallBasement()).x = 0;
               _loc9_.y = param3;
               _loc9_.left = param1;
               _loc9_.right = param2;
               this._wallList.push(_loc9_);
               _loc4_ = _loc9_;
            }
         }
         return _loc4_;
      }
      
      public function addBasementFloor(param1:Number, param2:Number, param3:Number) : *
      {
         var _loc7_:* = undefined;
         var _loc4_:* = false;
         var _loc5_:* = null;
         var _loc6_:* = 0;
         while(_loc6_ < this._basementFloorList.length)
         {
            if(param1 == this._basementFloorList[_loc6_].y)
            {
               _loc5_ = this._basementFloorList[_loc6_];
               _loc4_ = true;
               break;
            }
            _loc6_++;
         }
         if(!_loc4_)
         {
            (_loc7_ = new FloorBasement()).x = 0;
            _loc7_.y = param1;
            _loc7_.left = param2;
            _loc7_.right = param3;
            this._basementFloorList.push(_loc7_);
            this._basementFloorList.sortOn("y",Array.NUMERIC);
            return _loc7_;
         }
         _loc5_.left = Math.min(_loc5_.left,param2);
         _loc5_.right = Math.max(_loc5_.right,param3);
         return _loc5_;
      }
      
      function removeColumnHitting(param1:*) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < this._columnList.length)
         {
            _loc4_ = this._columnList[_loc3_];
            if(param1.y == _loc4_.y)
            {
               if(_loc4_.x >= param1.x - param1.width / 2 && _loc4_.x <= param1.x + param1.width / 2)
               {
                  _loc2_.push(_loc4_);
               }
            }
            _loc3_++;
         }
         while(_loc2_.length > 0)
         {
            _loc5_ = _loc2_.shift();
            if((_loc6_ = this._columnList.indexOf(_loc5_)) in this._columnList)
            {
               this._columnList.splice(_loc6_,1);
            }
            _loc5_.parent.removeChild(_loc5_);
         }
      }
      
      function removeWallHitting(param1:*) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < this._wallList.length)
         {
            _loc4_ = this._wallList[_loc3_];
            if(param1.y == _loc4_.y)
            {
               if(param1.x - param1.width / 2 >= _loc4_.left && param1.x - param1.width / 2 <= _loc4_.right || param1.x + param1.width / 2 >= _loc4_.left && param1.x + param1.width / 2 <= _loc4_.right || _loc4_.left >= param1.x - param1.width / 2 && _loc4_.right <= param1.x + param1.width / 2)
               {
                  _loc2_.push(_loc4_);
               }
            }
            _loc3_++;
         }
         while(_loc2_.length > 0)
         {
            _loc5_ = _loc2_.shift();
            if((_loc6_ = this._wallList.indexOf(_loc5_)) in this._wallList)
            {
               this._wallList.splice(_loc6_,1);
            }
            _loc5_.parent.removeChild(_loc5_);
         }
      }
      
      function fixPosition(param1:GameEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         removeListenerOf(_loc2_,GameEvent.POSITION_CHANGE,this.fixPosition);
         var _loc3_:* = _loc2_.globalToLocal(new Point(0,0)).x;
         var _loc4_:* = _loc2_.globalToLocal(new Point(700,0)).x;
         if(_loc3_ < this._mostLeft)
         {
            _loc2_.x -= this._mostLeft - _loc3_;
         }
         if(_loc4_ > this._mostRight)
         {
            _loc2_.x -= this._mostRight - _loc4_;
         }
         var _loc5_:* = -(this.HEIGHT_CHECK + this.BUILD_HEIGHT * this._basementLevel);
         if(_loc2_.y < _loc5_)
         {
            _loc2_.y = _loc5_;
         }
         if(_loc2_.y > this._gameHeight - (this.y - this.TOP_CHECK))
         {
            _loc2_.y = this._gameHeight - (this.y - this.TOP_CHECK);
         }
         this.updateSceneryPosition();
         addListenerOf(_loc2_,GameEvent.POSITION_CHANGE,this.fixPosition);
      }
      
      function updateSceneryPosition() : void
      {
         this._sceneryContainer.x = this._mainContainer.x / 2;
         this._sceneryContainer.y = this._mainContainer.y;
      }
      
      function keyboardIsDown(param1:KeyboardEvent) : void
      {
         var _loc2_:* = param1.keyCode;
         if(Config.SCROLL_KEY.indexOf(_loc2_) >= 0)
         {
            if(this.scrollButtonOnPressed.indexOf(_loc2_) < 0)
            {
               if(this.scrollButtonOnPressed.length <= 0)
               {
                  addListenerOf(this,Event.ENTER_FRAME,this.scrollScreenByKey);
               }
               this.scrollButtonOnPressed.push(_loc2_);
            }
         }
         if(this.buttonPressed.indexOf(_loc2_) < 0)
         {
            this.buttonPressed.push(_loc2_);
         }
      }
      
      function keyboardIsUp(param1:KeyboardEvent) : void
      {
         var _loc2_:* = param1.keyCode;
         var _loc3_:* = this.scrollButtonOnPressed.indexOf(_loc2_);
         if(_loc3_ in this.scrollButtonOnPressed)
         {
            this.scrollButtonOnPressed.splice(_loc3_,1);
            if(this.scrollButtonOnPressed.length <= 0)
            {
               removeListenerOf(this,Event.ENTER_FRAME,this.scrollScreenByKey);
            }
         }
         var _loc4_:*;
         if((_loc4_ = this.buttonPressed.indexOf(_loc2_)) in this.buttonPressed)
         {
            this.buttonPressed.splice(_loc4_,1);
         }
      }
      
      function startToScroll(param1:CommandEvent) : void
      {
         if(this._main.humanFocus == null)
         {
            this.lastCoordinate = new Point(stage.mouseX,stage.mouseY);
            addListenerOf(stage,MouseEvent.MOUSE_MOVE,this.scrollScreen);
            addListenerOf(stage,MouseEvent.MOUSE_UP,this.cancelScrollScreen);
            addListenerOf(stage,Event.DEACTIVATE,this.cancelScrollScreen);
         }
      }
      
      function scrollScreen(param1:MouseEvent) : void
      {
         var _loc2_:* = this.lastCoordinate.x - stage.mouseX;
         var _loc3_:* = this.lastCoordinate.y - stage.mouseY;
         this._mainContainer.x -= _loc2_;
         this._mainContainer.y -= _loc3_;
         this.lastCoordinate.x = stage.mouseX;
         this.lastCoordinate.y = stage.mouseY;
      }
      
      function cancelScrollScreen(param1:MouseEvent) : void
      {
         removeListenerOf(stage,MouseEvent.MOUSE_MOVE,this.scrollScreen);
         removeListenerOf(stage,MouseEvent.MOUSE_UP,this.cancelScrollScreen);
         removeListenerOf(stage,Event.DEACTIVATE,this.cancelScrollScreen);
      }
      
      function scrollScreenByKey(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this._main.humanFocus == null)
         {
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < this.scrollButtonOnPressed.length)
            {
               _loc5_ = Config.getScrollCode(this.scrollButtonOnPressed[_loc4_]);
               switch(_loc5_)
               {
                  case Config.SCROLL_LEFT:
                     _loc2_ -= 15;
                     break;
                  case Config.SCROLL_UP:
                     _loc3_ -= 15;
                     break;
                  case Config.SCROLL_DOWN:
                     _loc3_ += 15;
                     break;
                  case Config.SCROLL_RIGHT:
                     _loc2_ += 15;
                     break;
               }
               _loc4_++;
            }
            this._mainContainer.x -= _loc2_;
            this._mainContainer.y -= _loc3_;
         }
      }
      
      function initRoad() : void
      {
         this._buildLimitContainer = new MovieClip();
         this.createRoad();
         this._mainContainer.addChild(this._roadContainer);
         this._bottomFloor.left = this._mostLeft;
         this._bottomFloor.right = this._mostRight;
      }
      
      function createRoad() : void
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc1_:* = new RoadTop();
         this._roadContainer.addChild(_loc1_);
         this._mostLeft = _loc1_.x - _loc1_.width / 2;
         this._mostRight = _loc1_.x + _loc1_.width / 2;
         var _loc2_:* = 0;
         while(_loc2_ < this._level)
         {
            _loc8_ = new RoadTop();
            _loc8_.x = -(_loc8_.width * (_loc2_ + 1));
            this._roadContainer.addChild(_loc8_);
            this._mostLeft = Math.min(_loc8_.x - _loc8_.width / 2,this._mostLeft);
            _loc9_ = new RoadTop();
            _loc9_.x = _loc9_.width * (_loc2_ + 1);
            this._roadContainer.addChild(_loc9_);
            this._mostRight = Math.max(_loc9_.x + _loc9_.width / 2,this._mostRight);
            _loc2_++;
         }
         var _loc3_:* = this.HEIGHT_CHECK + (this._basementLevel + 1) * this.BUILD_HEIGHT;
         var _loc4_:*;
         (_loc4_ = new RoadBottom()).x = 0;
         _loc4_.y = _loc1_.height;
         _loc4_.width = this._mostRight - this._mostLeft;
         _loc4_.height = _loc3_;
         this._roadContainer.addChild(_loc4_);
         this._buildLimitContainer.graphics.clear();
         this._buildLimitContainer.graphics.lineStyle(1,16711680);
         var _loc5_:* = true;
         var _loc6_:* = _loc3_;
         while(_loc6_ > -this._gameHeight - this.TOP_CHECK)
         {
            if(_loc5_)
            {
               this._buildLimitContainer.graphics.moveTo(this._mostLeft + 108,_loc6_);
               this._buildLimitContainer.graphics.lineTo(this._mostLeft + 108,_loc6_ - this.GRID);
               this._buildLimitContainer.graphics.moveTo(this._mostRight - 108,_loc6_);
               this._buildLimitContainer.graphics.lineTo(this._mostRight - 108,_loc6_ - this.GRID);
            }
            _loc5_ = !_loc5_;
            _loc6_ -= this.GRID;
         }
         var _loc7_:* = this._mostLeft;
         _loc5_ = true;
         while(_loc7_ < this._mostRight)
         {
            if(_loc5_)
            {
               this._buildLimitContainer.graphics.moveTo(_loc7_,-this._gameHeight);
               this._buildLimitContainer.graphics.lineTo(_loc7_ + this.GRID,-this._gameHeight);
            }
            _loc5_ = !_loc5_;
            _loc7_ += this.GRID;
         }
      }
      
      function createBasement() : void
      {
         var _loc3_:* = undefined;
         this._topFloorBasement = this.addBasementFloor(36,this._mostLeft,this._mostRight);
         var _loc1_:* = this.topFloorBasement;
         var _loc2_:* = 0;
         while(_loc2_ < this._basementLevel)
         {
            _loc3_ = _loc1_.y + _loc1_.height + this.BUILD_HEIGHT;
            _loc1_ = this.addBasementFloor(_loc3_,this._mostLeft,this._mostRight);
            _loc2_++;
         }
      }
      
      function gameIdle(param1:Event) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         while(this._gameSpeedCtr < this._gameSpeed)
         {
            this.dispatchTo(this);
            ++this._gameSpeedCtr;
         }
         if(this._gameSpeedCtr >= this._gameSpeed)
         {
            this._gameSpeedCtr -= this._gameSpeed;
         }
         if(this._main.humanFocus != null)
         {
            if(this._main.humanFocus.parent != null)
            {
               _loc3_ = this._mainContainer.globalToLocal(this._main.humanFocus.localToGlobal(new Point(0,0)));
               this._mainContainer.x = -_loc3_.x;
               this._mainContainer.y = -_loc3_.y;
            }
         }
      }
      
      function dispatchTo(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1 != null)
         {
            param1.dispatchEvent(new LoopEvent(LoopEvent.ON_IDLE));
            if(param1 as DisplayObjectContainer)
            {
               _loc2_ = new Array();
               _loc3_ = 0;
               while(_loc3_ < param1.numChildren)
               {
                  _loc4_ = param1.getChildAt(_loc3_);
                  _loc2_.push(_loc4_);
                  _loc3_++;
               }
               while(_loc2_.length > 0)
               {
                  this.dispatchTo(_loc2_.shift());
               }
            }
         }
      }
      
      public function addHuman(param1:* = null) : void
      {
         var _loc2_:* = undefined;
         if(param1 == null)
         {
            _loc2_ = new Human();
            _loc2_.y = Math.floor(Math.random() * 2) * -84;
            _loc2_.currentAnimation = "idle";
            _loc2_.world = this;
            this._needToSwapObject.push(_loc2_);
            if(this._humanList.indexOf(_loc2_) < 0)
            {
               this._humanList.push(_loc2_);
            }
            this._frontContainer.addChild(_loc2_);
         }
         else if(param1 is Human)
         {
            if(this._humanList.indexOf(param1) < 0)
            {
               this._humanList.push(param1);
            }
            this._needToSwapObject.push(param1);
            this._frontContainer.addChild(param1);
         }
         dispatchEvent(new GameEvent(GameEvent.HUMAN_ADDED));
         this.swapDepthObject();
      }
      
      public function createThief() : void
      {
         var _loc1_:* = new Thief();
         _loc1_.world = this;
         _loc1_.y = 0;
         _loc1_.currentAnimation = "idle";
         if(_loc1_.baseHome < 0)
         {
            _loc1_.x = this._mostLeft - 15;
         }
         else if(_loc1_.baseHome > 0)
         {
            _loc1_.x = this._mostRight + 15;
         }
         this._thiefList.push(_loc1_);
         this.addHuman(_loc1_);
      }
      
      public function createLitter() : void
      {
         var _loc1_:* = new Litter();
         _loc1_.world = this;
         _loc1_.y = 0;
         _loc1_.currentAnimation = "idle";
         if(_loc1_.baseHome < 0)
         {
            _loc1_.x = this._mostLeft - 15;
         }
         else if(_loc1_.baseHome > 0)
         {
            _loc1_.x = this._mostRight + 15;
         }
         this._litterList.push(_loc1_);
         this.addHuman(_loc1_);
      }
      
      public function createWizard() : void
      {
         var _loc1_:* = new Wizard();
         _loc1_.world = this;
         _loc1_.y = 0;
         _loc1_.currentAnimation = "idle";
         if(_loc1_.baseHome < 0)
         {
            _loc1_.x = this._mostLeft - 15;
         }
         else if(_loc1_.baseHome > 0)
         {
            _loc1_.x = this._mostRight + 15;
         }
         this._wizardList.push(_loc1_);
         this.addHuman(_loc1_);
      }
      
      public function addVisitor() : *
      {
         var _loc1_:* = new Visitor();
         _loc1_.y = 0;
         if(_loc1_.baseHome < 0)
         {
            _loc1_.x = this._mostLeft - 15;
         }
         else if(_loc1_.baseHome > 0)
         {
            _loc1_.x = this._mostRight + 15;
         }
         _loc1_.currentAnimation = "idle";
         _loc1_.world = this;
         _loc1_.model = HumanData.randomModel();
         _loc1_.initData();
         this._currentVisitorList.push(_loc1_);
         this.addHuman(_loc1_);
         return _loc1_;
      }
      
      public function countBuildingByType(param1:String) : int
      {
         var _loc2_:* = undefined;
         if(param1 in this._boothListByType)
         {
            return this._boothListByType[param1].length;
         }
         _loc2_ = 0;
         switch(param1)
         {
            case "Lodging":
               _loc2_ = this._innList.length;
               break;
            case "Restroom":
               _loc2_ = this._restRoomList.length;
               break;
            case "Stairs":
               _loc2_ = this._stairList.length;
               break;
            case "Elevator":
               _loc2_ = this._elevatorList.length;
               break;
            case "Trading Post":
               _loc2_ = this._tradingPostList.length;
               break;
            case "Terrace":
               _loc2_ = this._terraceList.length;
         }
         return _loc2_;
      }
      
      public function getFloorAt(param1:Number) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         while(_loc3_ < this._floorList.length)
         {
            if((_loc4_ = this._floorList[_loc3_]).y == param1)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getConnectionAt(param1:Number) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         while(_loc3_ < this._dungeonConnection.length)
         {
            if((_loc4_ = this._dungeonConnection[_loc3_]).y == param1)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getBasementFloorAt(param1:Number) : *
      {
         var _loc4_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = 0;
         while(_loc3_ < this._basementFloorList.length)
         {
            if((_loc4_ = this._basementFloorList[_loc3_]).y == param1)
            {
               _loc2_ = _loc4_;
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function addTrash(param1:*, param2:Number, param3:Number, param4:Boolean = false) : void
      {
         var _loc8_:* = undefined;
         var _loc5_:*;
         if((_loc5_ = Math.round(param2 / this.TRASH_GRID) * this.TRASH_GRID) < param1.left)
         {
            _loc5_ = Math.ceil((param1.left + this.TRASH_GRID / 2) / this.TRASH_GRID) * this.TRASH_GRID;
         }
         if(_loc5_ > param1.right)
         {
            _loc5_ = Math.floor((param1.right - this.TRASH_GRID / 2) / this.TRASH_GRID) * this.TRASH_GRID;
         }
         var _loc6_:* = null;
         var _loc7_:* = null;
         if(!param4)
         {
            _loc8_ = 0;
            while(_loc8_ < this._trashList.length)
            {
               if(this._trashList[_loc8_].y == param1.y)
               {
                  if(this._trashList[_loc8_].x == _loc5_)
                  {
                     _loc6_ = this._trashList[_loc8_];
                     break;
                  }
               }
               _loc8_++;
            }
            if(_loc6_ != null)
            {
               _loc6_.dirtyLevel += param3;
            }
            else
            {
               (_loc7_ = new Trash()).dirtyLevel = param3;
               this._trashList.push(_loc7_);
            }
         }
         else
         {
            _loc8_ = 0;
            while(_loc8_ < this._pupList.length)
            {
               if(this._pupList[_loc8_].y == param1.y)
               {
                  if(this._pupList[_loc8_].x == _loc5_)
                  {
                     _loc6_ = this._pupList[_loc8_];
                     break;
                  }
               }
               _loc8_++;
            }
            if(_loc6_ != null)
            {
               _loc6_.dirtyLevel = 50;
            }
            else
            {
               _loc7_ = new AnimalPoop();
               this._pupList.push(_loc7_);
            }
         }
         if(_loc7_ != null)
         {
            _loc7_.x = _loc5_;
            _loc7_.y = param1.y;
            this._frontContainer.addChild(_loc7_);
            this._needToSwapObject.push(_loc7_);
            this.swapDepthObject();
         }
      }
      
      public function addConversation(param1:*, param2:*, param3:String = "Greet", param4:* = null) : void
      {
         var _loc5_:*;
         (_loc5_ = new Conversation(param1,param2)).world = this;
         if(param4 != null)
         {
            _loc5_.inTerrace = param4;
         }
         var _loc6_:* = param1;
         var _loc7_:* = ConversationList.getConversationType(param3);
         Utility.shuffle(_loc7_);
         var _loc8_:* = _loc7_.shift();
         _loc5_.addText(_loc8_.comment,_loc6_,_loc8_.tipsCode);
         while(_loc8_.nextComment != null)
         {
            if(!_loc8_.sameSpeaker)
            {
               _loc6_ = _loc6_ == param1 ? param2 : param1;
            }
            _loc8_ = ConversationList.getRandomConversation(_loc6_,_loc8_.nextComment);
            _loc5_.addText(_loc8_.comment,_loc6_,_loc8_.tipsCode);
         }
         _loc5_.run();
      }
      
      public function set gameSpeed(param1:Number) : void
      {
         this._gameSpeed = param1;
      }
      
      public function get gameSpeed() : Number
      {
         return this._gameSpeed;
      }
      
      public function get mainContainer() : MainContainer
      {
         return this._mainContainer;
      }
      
      public function get frontContainer() : MovieClip
      {
         return this._frontContainer;
      }
      
      public function get wagonContainer() : MovieClip
      {
         return this._wagonContainer;
      }
      
      public function set halte(param1:HalteWagon) : void
      {
         this._halte = param1;
      }
      
      public function get halte() : HalteWagon
      {
         return this._halte;
      }
      
      public function get dungeon() : MovieClip
      {
         return this._dungeon;
      }
      
      public function get legendContainer() : MovieClip
      {
         return this._legendContainer;
      }
      
      public function get conversationContainer() : MovieClip
      {
         return this._conversationContainer;
      }
      
      public function get bonusContainer() : MovieClip
      {
         return this._bonusContainer;
      }
      
      public function set buildingList(param1:Array) : void
      {
         this._buildingList = param1;
      }
      
      public function get buildingList() : Array
      {
         return this._buildingList;
      }
      
      public function get onInfoBuildingList() : Array
      {
         return this._onInfoBuildingList;
      }
      
      public function get dungeonConnection() : Array
      {
         return this._dungeonConnection;
      }
      
      public function set connectionSurface(param1:*) : void
      {
         this._connectionSurface = param1;
      }
      
      public function get connectionSurface() : *
      {
         return this._connectionSurface;
      }
      
      public function get brokableBuildingList() : Array
      {
         return this._brokableBuildingList;
      }
      
      public function get boothList() : Array
      {
         return this._boothList;
      }
      
      public function get boothListByType() : Object
      {
         return this._boothListByType;
      }
      
      public function get innList() : Array
      {
         return this._innList;
      }
      
      public function get guardPostList() : Array
      {
         return this._guardPostList;
      }
      
      public function get terraceList() : Array
      {
         return this._terraceList;
      }
      
      public function get tradingPostList() : Array
      {
         return this._tradingPostList;
      }
      
      public function get restRoomList() : Array
      {
         return this._restRoomList;
      }
      
      public function set stairList(param1:Array) : void
      {
         this._stairList = param1;
      }
      
      public function get stairList() : Array
      {
         return this._stairList;
      }
      
      public function set elevatorList(param1:Array) : void
      {
         this._elevatorList = param1;
      }
      
      public function get elevatorList() : Array
      {
         return this._elevatorList;
      }
      
      public function set transportList(param1:Array) : void
      {
         this._transportList = param1;
      }
      
      public function get transportList() : Array
      {
         return this._transportList;
      }
      
      public function set columnList(param1:Array) : void
      {
         this._columnList = param1;
      }
      
      public function get columnList() : Array
      {
         return this._columnList;
      }
      
      public function set floorList(param1:Array) : void
      {
         this._floorList = param1;
      }
      
      public function get floorList() : Array
      {
         return this._floorList;
      }
      
      public function set basementFloorList(param1:Array) : void
      {
         this._basementFloorList = param1;
      }
      
      public function get basementFloorList() : Array
      {
         return this._basementFloorList;
      }
      
      public function get humanList() : Array
      {
         return this._humanList;
      }
      
      public function get thiefList() : Array
      {
         return this._thiefList;
      }
      
      public function get litterList() : Array
      {
         return this._litterList;
      }
      
      public function get wizardList() : Array
      {
         return this._wizardList;
      }
      
      public function get trashList() : Array
      {
         return this._trashList;
      }
      
      public function get pupList() : Array
      {
         return this._pupList;
      }
      
      public function get bonusList() : Array
      {
         return this._bonusList;
      }
      
      public function get topFloorBasement() : *
      {
         return this._topFloorBasement;
      }
      
      public function get buildProgress() : *
      {
         return this._buildProgress;
      }
      
      public function get gameHeight() : Number
      {
         return this._gameHeight;
      }
      
      public function get mostLeft() : Number
      {
         return this._mostLeft;
      }
      
      public function get mostRight() : Number
      {
         return this._mostRight;
      }
      
      public function set staffList(param1:Object) : void
      {
         this._staffList = param1;
      }
      
      public function get staffList() : Object
      {
         return this._staffList;
      }
      
      public function set main(param1:Gameplay) : void
      {
         this._main = param1;
      }
      
      public function get main() : Gameplay
      {
         return this._main;
      }
      
      public function get weather() : Number
      {
         return this._weather;
      }
      
      public function get popularity() : Number
      {
         return this._popularity;
      }
      
      public function get visitorAlreadyVisit() : Array
      {
         return this.visitorAlreadyVisit;
      }
      
      public function get currentVisitorList() : Array
      {
         return this._currentVisitorList;
      }
      
      public function get specialVisitorList() : Array
      {
         return this._specialVisitorList;
      }
      
      public function get extraUpgradeList() : Array
      {
         return this._extraUpgradeList;
      }
      
      public function get numberPurchasedExtraUpgrade() : int
      {
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this._extraUpgradeList.length)
         {
            _loc3_ = this._extraUpgradeList[_loc2_];
            if(_loc3_.purchased)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function get deepRain() : Boolean
      {
         return this._deepRain;
      }
      
      public function get alarmTrigger() : Boolean
      {
         return this._alarmTrigger;
      }
      
      public function set watchdog(param1:*) : void
      {
         this._watchdog = param1;
      }
      
      public function get watchdog() : *
      {
         return this._watchdog;
      }
      
      public function get upgradeModifier() : Object
      {
         return this._upgradeModifier;
      }
      
      public function get needToSwapObject() : Array
      {
         return this._needToSwapObject;
      }
      
      public function get combination() : *
      {
         return this._combination;
      }
   }
}
