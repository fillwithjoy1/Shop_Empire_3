package Instance.ui
{
   import Instance.Gameplay;
   import Instance.constant.ColorCode;
   import Instance.constant.HumanData;
   import Instance.constant.UpgradeData;
   import Instance.events.ComboEvent;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.ToggleButtonEvent;
   import Instance.gameplay.StaffEntertainer;
   import Instance.gameplay.StaffGuard;
   import Instance.gameplay.StaffHandyman;
   import Instance.gameplay.StaffJanitor;
   import Instance.modules.Utility;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import greensock.TweenMax;
   
   public class UIStaffInfo extends UI_InfoDialog
   {
       
      
      public var statSymbolEntertain:MovieClip;
      
      public var statSymbolStamina:MovieClip;
      
      public var promotionCostInfo:TextField;
      
      public var star0:MovieClip;
      
      public var statSymbolHygine:MovieClip;
      
      public var star1:MovieClip;
      
      public var iconAbilityBlessedGuard:MovieClip;
      
      public var star2:MovieClip;
      
      public var btnPromote:SimpleButton;
      
      public var itemPriceIcon:MovieClip;
      
      public var statSymbolSpeed:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var btnFire:SimpleButton;
      
      public var workTimePopUp:UI_WorkTimePopUp;
      
      public var workFloorPopUp:UI_WorkFloorPopUp;
      
      public var btnChangeWorkFloor:dropdowntoggle;
      
      public var speedBar:MovieClip;
      
      public var jobHeader:TextField;
      
      public var bodyPartBottomLeft:MovieClip;
      
      public var btnChangeWorkTime:dropdowntoggle;
      
      public var promotionInfo:TextField;
      
      public var salaryInfo:TextField;
      
      public var statSymbolSight:MovieClip;
      
      public var bodyPartBottomRight:MovieClip;
      
      public var workStatus:MovieClip;
      
      public var currentWorkFloor:TextField;
      
      public var sightBar:MovieClip;
      
      public var staminaBar:MovieClip;
      
      public var staffIcon:MovieClip;
      
      public var selectedAbility:MovieClip;
      
      public var vitalityBar:MovieClip;
      
      public var bodyPartCenter:MovieClip;
      
      public var staffName:TextField;
      
      public var bodyPartBottomCenter:MovieClip;
      
      public var currentWorkTime:TextField;
      
      public var iconAbilitySacredBoots:MovieClip;
      
      public var bodyPartRight:MovieClip;
      
      public var bodyPartLeft:MovieClip;
      
      public var expBar:MovieClip;
      
      public var entertainBar:MovieClip;
      
      public var dragArea:MovieClip;
      
      public var hygineBar:MovieClip;
      
      var _starList:Array;
      
      var _statSymbolList:Array;
      
      var defaultUpgradeTextColor:int;
      
      var blinkDelay:int;
      
      var flashing:Boolean = false;
      
      var delayToFlashing:int = 12;
      
      public function UIStaffInfo()
      {
         super();
         this._starList = new Array();
         this._starList.push(this.star0);
         this._starList.push(this.star1);
         this._starList.push(this.star2);
         this._statSymbolList = new Array();
         this._statSymbolList.push(this.statSymbolStamina);
         this._statSymbolList.push(this.statSymbolHygine);
         this._statSymbolList.push(this.statSymbolEntertain);
         this._statSymbolList.push(this.statSymbolSight);
         this._statSymbolList.push(this.statSymbolSpeed);
         var _loc1_:* = 0;
         while(_loc1_ < this._statSymbolList.length)
         {
            this._statSymbolList[_loc1_].gotoAndStop(_loc1_ + 1);
            _loc1_++;
         }
         var _loc2_:TextFormat = new TextFormat();
         _loc2_.letterSpacing = -1;
         this.staffName.defaultTextFormat = _loc2_;
         this.salaryInfo.defaultTextFormat = _loc2_;
         this.promotionInfo.defaultTextFormat = _loc2_;
         this.promotionCostInfo.defaultTextFormat = _loc2_;
         this.defaultUpgradeTextColor = this.promotionCostInfo.textColor;
         this.blinkDelay = 0;
         this.workTimePopUp.parent.removeChild(this.workTimePopUp);
         this.workFloorPopUp.parent.removeChild(this.workFloorPopUp);
         this.selectedAbility.visible = false;
         this.selectedAbility.mouseEnabled = false;
         this.selectedAbility.mouseChildren = false;
         this.iconAbilityBlessedGuard.gotoAndStop("blessed_guards");
         this.iconAbilitySacredBoots.gotoAndStop("sacred_boots");
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc2_:* = undefined;
         super.Initialize(param1);
         if(_relation != null)
         {
            _loc2_ = "";
            if(_relation is StaffJanitor)
            {
               _loc2_ = "janitor";
            }
            else if(_relation is StaffHandyman)
            {
               _loc2_ = "handyman";
            }
            else if(_relation is StaffEntertainer)
            {
               _loc2_ = "entertainer";
            }
            else if(_relation is StaffGuard)
            {
               _loc2_ = "guard";
            }
            this.jobHeader.text = "STAFF - " + _loc2_.toUpperCase();
            this.staffIcon.gotoAndStop("staff - " + _loc2_);
            this.staffName.text = relation.characterName;
            this.salaryInfo.text = "" + _relation.salary + " G";
            this.promotionInfo.text = HumanData.getPromotionInfo(_relation);
            this.workFloorPopUp.world = _relation.world;
            this.updateWorkTime();
            this.updateWorkFloor();
            this.updateStatView();
            this.updateWorkStatus();
            this.updatePromotionCost();
            this.updateVitality(_relation);
            this.updateExperience(_relation);
            this.checkLevel(_relation);
            this.checkAvailablePromote(_relation.world.main);
            this.checkUpgradeable(_relation);
            this.checkAbility(_relation);
         }
         addListenerOf(this,Event.ENTER_FRAME,this.checkCondition);
         addListenerOf(this.btnChangeWorkFloor,ToggleButtonEvent.ACTIVATE,this.btnPopUpOnActivate);
         addListenerOf(this.btnChangeWorkFloor,ToggleButtonEvent.DEACTIVATE,this.btnPopUpOnDeactivate);
         addListenerOf(this.btnChangeWorkFloor,ToggleButtonEvent.FORCE_DEACTIVATE,this.btnPopUpOnDeactivate);
         addListenerOf(this.btnChangeWorkTime,ToggleButtonEvent.ACTIVATE,this.btnPopUpOnActivate);
         addListenerOf(this.btnChangeWorkTime,ToggleButtonEvent.DEACTIVATE,this.btnPopUpOnDeactivate);
         addListenerOf(this.btnChangeWorkTime,ToggleButtonEvent.FORCE_DEACTIVATE,this.btnPopUpOnDeactivate);
         addListenerOf(this.workTimePopUp,ComboEvent.ON_SELECT,this.selectWorkTime);
         addListenerOf(this.workFloorPopUp,ComboEvent.ON_SELECT,this.selectWorkFloor);
         addListenerOf(_relation,HumanEvent.BECOMES_PROMOTE,this.checkPromotion);
         addListenerOf(_relation,HumanEvent.SUCCESFULLY_PROMOTED,this.successfullyPromoted);
         addListenerOf(this.btnPromote,MouseEvent.CLICK,this.btnPromoteOnClick);
         addListenerOf(this.btnFire,MouseEvent.CLICK,this.btnFireOnClick);
         addListenerOf(stage,GameEvent.UPDATE_BUDGET,this.whenBudgetChange);
         addListenerOf(_relation,HumanEvent.UPDATE_VITALITY,this.checkCurrentVitality);
         addListenerOf(_relation,HumanEvent.UPDATE_EXPERIENCE,this.checkCurrentExperience);
         addListenerOf(this.iconAbilityBlessedGuard,MouseEvent.CLICK,this.changeAbility);
         addListenerOf(this.iconAbilitySacredBoots,MouseEvent.CLICK,this.changeAbility);
      }
      
      override protected function Removed(param1:Event) : void
      {
         super.Removed(param1);
         this.parent.dispatchEvent(new GameEvent(GameEvent.LOST_HUMAN_FOCUS));
      }
      
      function changeAbility(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         if(_relation is StaffGuard)
         {
            _loc2_ = param1.currentTarget;
            if(_loc2_.buttonMode)
            {
               if(_loc2_ == this.iconAbilityBlessedGuard)
               {
                  if(_relation.activatedAbility == UpgradeData.BLESSED_GUARD)
                  {
                     _relation.activatedAbility = null;
                  }
                  else
                  {
                     _relation.activatedAbility = UpgradeData.BLESSED_GUARD;
                  }
               }
               if(_loc2_ == this.iconAbilitySacredBoots)
               {
                  if(_relation.activatedAbility == UpgradeData.SACRED_BOOTS)
                  {
                     _relation.activatedAbility = null;
                  }
                  else
                  {
                     _relation.activatedAbility = UpgradeData.SACRED_BOOTS;
                  }
               }
               this.checkActivatedAbility(_relation);
            }
         }
      }
      
      function checkAbility(param1:*) : void
      {
         if(param1 is StaffGuard)
         {
            this.iconAbilityBlessedGuard.visible = true;
            this.iconAbilitySacredBoots.visible = true;
            if(param1.world.isUpgradePurchased(UpgradeData.BLESSED_GUARD))
            {
               this.iconAbilityBlessedGuard.buttonMode = true;
               TweenMax.to(this.iconAbilityBlessedGuard,0.01,{"colorMatrixFilter":{
                  "amount":1,
                  "saturation":1,
                  "brightness":1
               }});
            }
            else
            {
               this.iconAbilityBlessedGuard.buttonMode = false;
               TweenMax.to(this.iconAbilityBlessedGuard,0.01,{"colorMatrixFilter":{
                  "amount":1,
                  "saturation":0,
                  "brightness":0.6
               }});
            }
            if(param1.world.isUpgradePurchased(UpgradeData.SACRED_BOOTS))
            {
               this.iconAbilitySacredBoots.buttonMode = true;
               TweenMax.to(this.iconAbilitySacredBoots,0.01,{"colorMatrixFilter":{
                  "amount":1,
                  "saturation":1,
                  "brightness":1
               }});
            }
            else
            {
               this.iconAbilitySacredBoots.buttonMode = false;
               TweenMax.to(this.iconAbilitySacredBoots,0.01,{"colorMatrixFilter":{
                  "amount":1,
                  "saturation":0,
                  "brightness":0.6
               }});
            }
            this.checkActivatedAbility(param1);
         }
         else
         {
            this.iconAbilityBlessedGuard.visible = false;
            this.iconAbilitySacredBoots.visible = false;
         }
      }
      
      function checkActivatedAbility(param1:*) : void
      {
         if(param1 is StaffGuard)
         {
            if(param1.activatedAbility == null)
            {
               this.selectedAbility.visible = false;
            }
            else
            {
               if(param1.activatedAbility == UpgradeData.BLESSED_GUARD)
               {
                  this.selectedAbility.x = this.iconAbilityBlessedGuard.x + 1;
                  this.selectedAbility.y = this.iconAbilityBlessedGuard.y + 1;
                  this.selectedAbility.visible = true;
               }
               if(param1.activatedAbility == UpgradeData.SACRED_BOOTS)
               {
                  this.selectedAbility.x = this.iconAbilitySacredBoots.x + 1;
                  this.selectedAbility.y = this.iconAbilitySacredBoots.y + 1;
                  this.selectedAbility.visible = true;
               }
            }
         }
      }
      
      function checkUpgradeable(param1:*) : void
      {
         if(param1.expPercentage < 1)
         {
            this.btnPromote.enabled = false;
         }
         else
         {
            this.btnPromote.enabled = param1.level < param1.maxLevel;
         }
         if(this.btnPromote.enabled)
         {
            this.btnPromote.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         else
         {
            this.btnPromote.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
         }
      }
      
      function whenBudgetChange(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ is Gameplay)
         {
            this.checkAvailablePromote(_loc2_);
         }
      }
      
      function checkAvailablePromote(param1:*) : void
      {
         if(param1.isEnough(_relation.promotionCost))
         {
            this.promotionCostInfo.textColor = this.defaultUpgradeTextColor;
         }
         else
         {
            this.promotionCostInfo.textColor = ColorCode.NEGATIVE_CASH_ANIMATION;
         }
      }
      
      function checkCurrentVitality(param1:HumanEvent) : void
      {
         this.updateVitality(param1.currentTarget);
      }
      
      function checkCurrentExperience(param1:HumanEvent) : void
      {
         this.updateExperience(param1.currentTarget);
      }
      
      function checkPromotion(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         this._starList[_loc2_.level].gotoAndPlay("Transform");
      }
      
      function successfullyPromoted(param1:HumanEvent) : void
      {
         this.updateVitality(_relation);
         this.salaryInfo.text = "" + _relation.salary + " G";
         this.updatePromotionCost();
         this.checkUpgradeable(_relation);
         this.updateExperience(_relation);
      }
      
      function btnPopUpOnActivate(param1:ToggleButtonEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_ == this.btnChangeWorkFloor)
         {
            this.btnChangeWorkTime.isActive = false;
            if(getChildByName(this.workFloorPopUp.name) == null)
            {
               addChild(this.workFloorPopUp);
            }
            this.updateWorkFloorPopUp();
         }
         if(_loc2_ == this.btnChangeWorkTime)
         {
            this.btnChangeWorkFloor.isActive = false;
            if(getChildByName(this.workTimePopUp.name) == null)
            {
               addChild(this.workTimePopUp);
            }
            this.updateWorkTimePopUp();
         }
      }
      
      function btnPopUpOnDeactivate(param1:ToggleButtonEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_ == this.btnChangeWorkFloor)
         {
            if(getChildByName(this.workFloorPopUp.name) != null)
            {
               removeChild(this.workFloorPopUp);
            }
         }
         if(_loc2_ == this.btnChangeWorkTime)
         {
            if(getChildByName(this.workTimePopUp.name) != null)
            {
               removeChild(this.workTimePopUp);
            }
         }
      }
      
      function updateWorkFloorPopUp() : void
      {
         if(_relation != null)
         {
            this.workFloorPopUp.floorRelated = _relation.workFloor;
            this.workFloorPopUp.refreshView();
         }
      }
      
      function updateWorkTimePopUp() : void
      {
         var _loc1_:* = _relation.workTime;
         var _loc2_:* = null;
         if(_loc1_.workStart == 9 && _loc1_.workEnd == 19)
         {
            _loc2_ = this.workTimePopUp.highlighted0;
         }
         else if(_loc1_.workStart == 19 && _loc1_.workEnd == 5)
         {
            _loc2_ = this.workTimePopUp.highlighted1;
         }
         if(_loc1_.workStart == 9 && _loc1_.workEnd == 5)
         {
            _loc2_ = this.workTimePopUp.highlighted2;
         }
         if(_loc2_ != null)
         {
            this.workTimePopUp.selectedMark.y = _loc2_.y + _loc2_.height / 2;
         }
      }
      
      function updateVitality(param1:*) : void
      {
         var _loc2_:Color = new Color();
         _loc2_.color = param1.tiredTime == 0 ? uint(ColorCode.VITALITY_FINE) : (param1.tiredTime == 1 ? uint(ColorCode.VITALITY_LOW) : uint(ColorCode.VITALITY_DEPLETED));
         this.vitalityBar.fillBar.transform.colorTransform = _loc2_;
         var _loc3_:* = param1.tiredTime == 0 ? 1 : (param1.tiredTime == 1 ? 0.7 : 0.4);
         this.vitalityBar.maskBar.scaleX = param1.vitality / Math.round(param1.MAX_VITALITY * _loc3_);
      }
      
      function updateExperience(param1:*) : void
      {
         if(!this.btnPromote.enabled && param1.level < param1.maxLevel)
         {
            this.checkUpgradeable(param1);
         }
         this.expBar.maskBar.scaleX = param1.expPercentage;
      }
      
      function updatePromotionCost() : void
      {
         if(_relation.level < _relation.maxLevel)
         {
            this.promotionCostInfo.text = "" + Utility.numberToMoney(_relation.promotionCost) + " G";
         }
         else
         {
            this.promotionCostInfo.text = "MAX";
         }
      }
      
      function selectWorkTime(param1:ComboEvent) : void
      {
         var _loc2_:* = param1.selected;
         var _loc3_:* = this.workTimePopUp.getChildByName("highlighted" + _loc2_);
         if(_loc3_ != null)
         {
            this.workTimePopUp.selectedMark.y = _loc3_.y + _loc3_.height / 2;
            if(_relation != null)
            {
               if(_relation.destination != "home" && !(_relation.inHome && !_relation.skipWork))
               {
                  _relation.salaryObject = this.salaryInfo;
                  _relation.dispatchEvent(new HumanEvent(HumanEvent.PAY_SALARY,_relation.salaryObject));
               }
               switch(_loc2_)
               {
                  case 0:
                     _relation.workTime.workStart = 9;
                     _relation.workTime.workEnd = 19;
                     break;
                  case 1:
                     _relation.workTime.workStart = 19;
                     _relation.workTime.workEnd = 5;
                     break;
                  case 2:
                     _relation.workTime.workStart = 9;
                     _relation.workTime.workEnd = 5;
               }
               this.btnChangeWorkTime.isActive = false;
               this.salaryInfo.text = "" + _relation.salary + " G";
               this.updateWorkTime();
            }
         }
      }
      
      function selectWorkFloor(param1:ComboEvent) : void
      {
         var _loc2_:* = param1.selected;
         if(_relation != null)
         {
            if(_loc2_ == 0)
            {
               _relation.workFloor = null;
            }
            else
            {
               _relation.workFloor = _relation.world.floorList[_loc2_ - 1];
            }
            this.btnChangeWorkFloor.isActive = false;
            this.updateWorkFloor();
         }
      }
      
      function checkCondition(param1:Event) : void
      {
         if(this.blinkDelay > 0)
         {
            --this.blinkDelay;
         }
         else
         {
            if(!this.workStatus.visible)
            {
               this.updateWorkStatus();
            }
            this.workStatus.visible = !this.workStatus.visible;
            this.blinkDelay = !!this.workStatus.visible ? 20 : 5;
         }
         this.checkMaxExp(_relation);
      }
      
      function checkMaxExp(param1:*) : void
      {
         var _loc2_:ColorTransform = null;
         if(param1.expPercentage < 1)
         {
            this.flashing = false;
            this.delayToFlashing = 12;
            this.expBar.fillBar.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         else if(param1.level < param1.maxLevel)
         {
            if(this.delayToFlashing > 0)
            {
               --this.delayToFlashing;
            }
            else
            {
               _loc2_ = this.expBar.fillBar.transform.colorTransform;
               if(!this.flashing)
               {
                  _loc2_.redOffset = Math.min(255,_loc2_.redOffset + 32);
                  _loc2_.greenOffset = Math.min(255,_loc2_.greenOffset + 32);
                  _loc2_.blueOffset = Math.min(255,_loc2_.blueOffset + 32);
               }
               else
               {
                  _loc2_.redOffset = Math.max(0,_loc2_.redOffset - 16);
                  _loc2_.greenOffset = Math.max(0,_loc2_.greenOffset - 16);
                  _loc2_.blueOffset = Math.max(0,_loc2_.blueOffset - 16);
               }
               if(_loc2_.redOffset >= 255 || _loc2_.redOffset <= 0)
               {
                  this.flashing = !this.flashing;
                  if(!this.flashing)
                  {
                     this.delayToFlashing = 12;
                  }
               }
               this.expBar.fillBar.transform.colorTransform = _loc2_;
            }
         }
         else
         {
            this.expBar.fillBar.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
      }
      
      function updateStatView() : void
      {
         var _loc1_:* = undefined;
         if(_relation.stat != null)
         {
            _loc1_ = _relation.stat;
            this.staminaBar.maskBar.scaleX = _loc1_.stamina / 100;
            this.hygineBar.maskBar.scaleX = _loc1_.hygine / 100;
            this.entertainBar.maskBar.scaleX = _loc1_.entertain / 100;
            this.sightBar.maskBar.scaleX = _loc1_.sight / 100;
            this.speedBar.maskBar.scaleX = _loc1_.speed / 100;
         }
      }
      
      function updateWorkTime() : void
      {
         var _loc1_:* = relation.workTime;
         if(_loc1_.workStart == 9 && _loc1_.workEnd == 19)
         {
            this.currentWorkTime.text = "DAY";
         }
         else if(_loc1_.workStart == 19 && _loc1_.workEnd == 5)
         {
            this.currentWorkTime.text = "NIGHT";
         }
         else if(_loc1_.workStart == 9 && _loc1_.workEnd == 5)
         {
            this.currentWorkTime.text = "BOTH";
         }
         else
         {
            this.currentWorkTime.text = "???";
         }
      }
      
      function updateWorkFloor() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = relation.workFloor;
         if(_loc1_ == null)
         {
            this.currentWorkFloor.text = "ALL";
         }
         else
         {
            _loc2_ = relation.world.floorList.indexOf(_loc1_);
            if(_loc2_ == 0)
            {
               this.currentWorkFloor.text = "GROUND";
            }
            else
            {
               this.currentWorkFloor.text = Utility.numberToOrdinal(_loc2_) + " FLOOR";
            }
         }
      }
      
      function updateWorkStatus() : void
      {
         if(_relation.fatigue)
         {
            this.workStatus.gotoAndStop("fatigue");
         }
         else if(_relation.inHome)
         {
            this.workStatus.gotoAndStop("rest");
         }
         else if(_relation.destination == "home")
         {
            this.workStatus.gotoAndStop("leaving");
         }
         else if(_relation.arrival)
         {
            this.workStatus.gotoAndStop("arriving");
         }
         else
         {
            this.workStatus.gotoAndStop("onDuty");
         }
      }
      
      function checkLevel(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < this._starList.length)
         {
            _loc3_ = this._starList[_loc2_];
            _loc3_.visible = _loc2_ < param1.maxLevel;
            if(_loc2_ < param1.level)
            {
               _loc3_.gotoAndStop("Active");
            }
            else if(_loc2_ == param1.level)
            {
               if(param1.promoteState)
               {
                  _loc3_.gotoAndStop("Active");
               }
               else
               {
                  _loc3_.gotoAndStop("Inactive");
               }
            }
            else
            {
               _loc3_.gotoAndStop("Inactive");
            }
            _loc2_++;
         }
      }
      
      function btnPromoteOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            _relation.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_PROMOTE));
         }
      }
      
      function btnFireOnClick(param1:MouseEvent) : void
      {
         _relation.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_FIRE));
      }
   }
}
