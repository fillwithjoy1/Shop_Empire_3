package Instance.ui
{
   import Instance.Gameplay;
   import Instance.constant.BuildingData;
   import Instance.constant.ColorCode;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.gameplay.StaffHandyman;
   import Instance.modules.Utility;
   import Instance.property.Booth;
   import Instance.property.Elevator;
   import Instance.property.FacilityTradingPost;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class UIBoothInfo extends UI_InfoDialog
   {
       
      
      public var relocateCostInfo:TextField;
      
      public var itemPriceInfo:TextField;
      
      public var conditionHeader:TextField;
      
      public var numberPeople:TextField;
      
      public var star0:MovieClip;
      
      public var btnRelocate:SimpleButton;
      
      public var star1:MovieClip;
      
      public var star2:MovieClip;
      
      public var descriptionInfo:TextField;
      
      public var itemPriceIcon:MovieClip;
      
      public var capacityIcon:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var upgradeCostInfo:TextField;
      
      public var buildIcon:MovieClip;
      
      public var bodyPartBottomLeft:MovieClip;
      
      public var btnDestroy:SimpleButton;
      
      public var bodyPartBottomRight:MovieClip;
      
      public var buildingHeader:TextField;
      
      public var openStatus:MovieClip;
      
      public var bodyPartCenter:MovieClip;
      
      public var brokenStatus:MovieClip;
      
      public var buildingName:TextField;
      
      public var upgradeInfo:TextField;
      
      public var bodyPartBottomCenter:MovieClip;
      
      public var bodyPartRight:MovieClip;
      
      public var bodyPartLeft:MovieClip;
      
      public var expBar:MovieClip;
      
      public var btnUpgrade:SimpleButton;
      
      public var dragArea:MovieClip;
      
      var _starList:Array;
      
      var defaultUpgradeTextColor:int;
      
      var flashing:Boolean = false;
      
      var delayToFlashing:int = 12;
      
      public function UIBoothInfo()
      {
         super();
         this._starList = new Array();
         this._starList.push(this.star0);
         this._starList.push(this.star1);
         this._starList.push(this.star2);
         this.numberPeople.autoSize = TextFieldAutoSize.RIGHT;
         this.capacityIcon.gotoAndStop(1);
         this.openStatus.stop();
         this.brokenStatus.stop();
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.letterSpacing = -1;
         this.buildingName.defaultTextFormat = _loc1_;
         this.numberPeople.defaultTextFormat = _loc1_;
         this.descriptionInfo.defaultTextFormat = _loc1_;
         this.itemPriceInfo.defaultTextFormat = _loc1_;
         this.upgradeInfo.defaultTextFormat = _loc1_;
         this.upgradeCostInfo.defaultTextFormat = _loc1_;
         this.relocateCostInfo.defaultTextFormat = _loc1_;
         this.defaultUpgradeTextColor = this.upgradeCostInfo.textColor;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         super.Initialize(param1);
         if(_relation != null)
         {
            _loc2_ = BuildingData.returnClassTo(Utility.getClass(_relation));
            if(_loc2_ != null)
            {
               this.buildingHeader.text = _loc2_.toUpperCase();
               this.buildIcon.gotoAndStop(BuildingData.getIconOf(_loc2_));
               if(_relation is Booth && !(_relation is FacilityTradingPost))
               {
                  _loc3_ = _relation.priceList.concat();
                  _loc4_ = 0;
                  _loc5_ = 0;
                  while(_loc5_ < _loc3_.length)
                  {
                     _loc4_ += _loc3_[_loc5_];
                     _loc5_++;
                  }
                  _loc6_ = Math.round(_loc4_ / _loc3_.length);
                  this.itemPriceInfo.text = "" + _loc6_ + " G";
                  this.itemPriceInfo.visible = true;
                  this.itemPriceIcon.visible = true;
               }
               else
               {
                  this.itemPriceInfo.visible = false;
                  this.itemPriceIcon.visible = false;
               }
               if(_relation.world.boothList.indexOf(_relation) >= 0)
               {
                  _loc7_ = _relation.world.boothListByType[_loc2_].indexOf(_relation);
                  this.buildingName.text = _loc2_ + " #" + (_loc7_ + 1);
               }
               else
               {
                  if((_loc8_ = _relation.world.innList.indexOf(_relation)) in _relation.world.innList)
                  {
                     this.buildingName.text = _loc2_ + " #" + (_loc8_ + 1);
                  }
                  if((_loc9_ = _relation.world.tradingPostList.indexOf(_relation)) in _relation.world.tradingPostList)
                  {
                     this.buildingName.text = _loc2_ + " #" + (_loc9_ + 1);
                  }
               }
               this.descriptionInfo.text = BuildingData.getDescription(_loc2_);
               this.upgradeInfo.text = BuildingData.getUpgradeInfo(_loc2_);
               this.upgradeCostInfo.text = _relation.level < _relation.maxLevel ? "" + Utility.numberToMoney(_relation.upgradeCost) + " G" : "MAX";
               this.relocateCostInfo.text = "" + Utility.numberToMoney(_relation.relocateCost) + " G";
               this.checkAvailableUpgrade(_relation.world.main);
            }
            this.updateData(_relation);
         }
         addListenerOf(this,Event.ENTER_FRAME,this.checkCondition);
         addListenerOf(this.btnDestroy,MouseEvent.CLICK,this.btnDestroyOnClick);
         addListenerOf(this.btnUpgrade,MouseEvent.CLICK,this.btnUpgradeOnClick);
         addListenerOf(this.btnRelocate,MouseEvent.CLICK,this.btnRelocateOnClick);
         addListenerOf(_relation,GameEvent.BECOMES_UPGRADE,this.checkUpgrade);
         addListenerOf(_relation,GameEvent.BUILDING_SUCCESSFULLY_UPGRADE,this.successfullyUpgrade);
         addListenerOf(stage,GameEvent.UPDATE_BUDGET,this.whenBudgetChange);
         addListenerOf(_relation,GameEvent.GAIN_EXPERIENCE,this.checkCurrentExperience);
      }
      
      function checkUpgrade(param1:GameEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         this._starList[_loc2_.level].gotoAndPlay("Transform");
      }
      
      function checkCurrentExperience(param1:GameEvent) : void
      {
         this.updateExperience(param1.currentTarget);
      }
      
      function checkCondition(param1:Event) : void
      {
         if(_relation != null)
         {
            this.checkBrokenCondition(_relation);
            this.checkCapacity(_relation);
            this.checkOpenCondition(_relation);
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
      
      function whenBudgetChange(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ is Gameplay)
         {
            this.checkAvailableUpgrade(_loc2_);
         }
      }
      
      function checkAvailableUpgrade(param1:*) : void
      {
         if(param1.isEnough(_relation.upgradeCost))
         {
            this.upgradeCostInfo.textColor = this.defaultUpgradeTextColor;
         }
         else
         {
            this.upgradeCostInfo.textColor = ColorCode.NEGATIVE_CASH_ANIMATION;
         }
         if(param1.isEnough(_relation.relocateCost))
         {
            this.relocateCostInfo.textColor = this.defaultUpgradeTextColor;
         }
         else
         {
            this.relocateCostInfo.textColor = ColorCode.NEGATIVE_CASH_ANIMATION;
         }
      }
      
      function successfullyUpgrade(param1:GameEvent) : void
      {
         this.upgradeCostInfo.text = _relation.level < _relation.maxLevel ? "" + Utility.numberToMoney(_relation.upgradeCost) + " G" : "MAX";
         this.relocateCostInfo.text = "" + Utility.numberToMoney(_relation.relocateCost) + " G";
         this.checkUpgradeable(_relation);
         this.updateExperience(_relation);
      }
      
      function updateData(param1:*) : void
      {
         this.checkLevel(param1);
         if(param1.world.brokableBuildingList.indexOf(param1) < 0)
         {
            this.conditionHeader.visible = false;
            this.brokenStatus.visible = false;
         }
         else
         {
            this.conditionHeader.visible = true;
            this.brokenStatus.visible = true;
            this.checkBrokenCondition(param1);
         }
         this.checkCapacity(param1);
         this.checkOpenCondition(param1);
         this.checkUpgradeable(param1);
         this.updateExperience(param1);
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
               if(param1.upgradeState)
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
      
      function checkUpgradeable(param1:*) : void
      {
         if(param1.expPercentage < 1)
         {
            this.btnUpgrade.enabled = false;
         }
         else
         {
            this.btnUpgrade.enabled = param1.level < param1.maxLevel;
         }
         if(this.btnUpgrade.enabled)
         {
            this.btnUpgrade.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         else
         {
            this.btnUpgrade.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
         }
      }
      
      function updateExperience(param1:*) : void
      {
         if(!this.btnUpgrade.enabled && param1.level < param1.maxLevel)
         {
            this.checkUpgradeable(param1);
         }
         this.expBar.maskBar.width = this.expBar.fillBar.width * param1.expPercentage;
      }
      
      function checkBrokenCondition(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = false;
         if(param1.isBroken || param1.needRepair)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.humanList.length)
            {
               if((_loc4_ = param1.humanList[_loc3_]) is StaffHandyman)
               {
                  _loc2_ = true;
                  break;
               }
               _loc3_++;
            }
         }
         if(_loc2_)
         {
            this.brokenStatus.gotoAndStop("repaired");
         }
         else if(param1.isBroken)
         {
            this.brokenStatus.gotoAndStop("broken");
         }
         else if(param1.needRepair)
         {
            this.brokenStatus.gotoAndStop("damaged");
         }
         else
         {
            this.brokenStatus.gotoAndStop("fine");
         }
      }
      
      function checkCapacity(param1:*) : void
      {
         var _loc2_:* = "";
         _loc2_ = isFinite(param1.capacity) && !isNaN(param1.capacity) ? "/" + param1.capacity : "";
         if(param1 is Booth)
         {
            this.numberPeople.text = "" + param1.visitorList.length + "" + _loc2_;
         }
         this.capacityIcon.x = Math.round(this.numberPeople.x + this.numberPeople.width - this.numberPeople.textWidth) - 12;
      }
      
      function checkOpenCondition(param1:*) : void
      {
         if(param1 is Booth)
         {
            if(!this.openStatus.visible)
            {
               this.openStatus.visible = true;
            }
            if(param1.open)
            {
               if(this.openStatus.currentFrameLabel != "open")
               {
                  this.openStatus.gotoAndStop("open");
               }
            }
            else if(this.openStatus.currentFrameLabel != "closed")
            {
               this.openStatus.gotoAndStop("closed");
            }
         }
         else if(this.openStatus.visible)
         {
            this.openStatus.visible = false;
         }
      }
      
      function btnDestroyOnClick(param1:MouseEvent) : void
      {
         _relation.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_DESTROY));
      }
      
      function btnUpgradeOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            _relation.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_UPGRADE));
         }
      }
      
      function btnRelocateOnClick(param1:MouseEvent) : void
      {
         if(!(_relation is Elevator))
         {
            if(_relation.world.main.isEnough(_relation.relocateCost))
            {
               _relation.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_RELOCATE));
               btnCloseOnClick(param1);
            }
            else
            {
               _relation.world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Not Enough Money"));
            }
         }
      }
   }
}
