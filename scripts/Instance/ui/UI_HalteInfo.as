package Instance.ui
{
   import Instance.Gameplay;
   import Instance.constant.ColorCode;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class UI_HalteInfo extends UI_InfoDialog
   {
       
      
      public var arrivalStatus:TextField;
      
      public var numberPeople:TextField;
      
      public var star0:MovieClip;
      
      public var star1:MovieClip;
      
      public var star2:MovieClip;
      
      public var capacityIcon:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var upgradeCostInfo:TextField;
      
      public var buildIcon:MovieClip;
      
      public var bodyPartBottomLeft:MovieClip;
      
      public var bodyPartBottomRight:MovieClip;
      
      public var bodyPartCenter:MovieClip;
      
      public var bodyPartBottomCenter:MovieClip;
      
      public var bodyPartRight:MovieClip;
      
      public var bodyPartLeft:MovieClip;
      
      public var expBar:MovieClip;
      
      public var btnUpgrade:SimpleButton;
      
      public var dragArea:MovieClip;
      
      var _starList:Array;
      
      var flashing:Boolean = false;
      
      var delayToFlashing:int = 12;
      
      public function UI_HalteInfo()
      {
         super();
         this._starList = new Array();
         this._starList.push(this.star0);
         this._starList.push(this.star1);
         this._starList.push(this.star2);
         this.numberPeople.autoSize = TextFieldAutoSize.RIGHT;
         this.capacityIcon.gotoAndStop(1);
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.letterSpacing = -1;
         this.numberPeople.defaultTextFormat = _loc1_;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.buildIcon.gotoAndStop("halteWagon");
         this.upgradeCostInfo.text = _relation.level < _relation.maxLevel ? "" + Utility.numberToMoney(_relation.upgradeCost) + " G" : "MAX";
         this.checkAvailableUpgrade(_relation.world.main);
         this.updateData(_relation);
         addListenerOf(this,Event.ENTER_FRAME,this.checkCondition);
         addListenerOf(this.btnUpgrade,MouseEvent.CLICK,this.btnUpgradeOnClick);
         addListenerOf(_relation,GameEvent.BECOMES_UPGRADE,this.checkUpgrade);
         addListenerOf(_relation,GameEvent.BUILDING_SUCCESSFULLY_UPGRADE,this.successfullyUpgrade);
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
            this.checkCapacity(_relation);
            this.checkArrivalCondition(_relation);
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
            this.upgradeCostInfo.textColor = 16777215;
         }
         else
         {
            this.upgradeCostInfo.textColor = ColorCode.NEGATIVE_CASH_ANIMATION;
         }
      }
      
      function successfullyUpgrade(param1:GameEvent) : void
      {
         this.upgradeCostInfo.text = _relation.level < _relation.maxLevel ? "" + Utility.numberToMoney(_relation.upgradeCost) + " G" : "MAX";
         this.checkUpgradeable(_relation);
         this.updateExperience(_relation);
      }
      
      function updateData(param1:*) : void
      {
         this.checkLevel(param1);
         this.checkCapacity(param1);
         this.checkArrivalCondition(param1);
         this.checkUpgradeable(_relation);
         this.updateExperience(_relation);
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
      
      function checkCapacity(param1:*) : void
      {
         var _loc2_:* = "";
         _loc2_ = isFinite(param1.capacity) && !isNaN(param1.capacity) ? "/" + param1.capacity : "";
         this.numberPeople.text = "" + (param1.humanList.length + param1.passangerInWagon) + "" + _loc2_;
         this.capacityIcon.x = Math.round(this.numberPeople.x + this.numberPeople.width - this.numberPeople.textWidth) - 12;
      }
      
      function checkArrivalCondition(param1:*) : void
      {
         var _loc2_:* = undefined;
         if(param1.currentWagon == null)
         {
            this.arrivalStatus.textColor = ColorCode.REQUIREMENT_COLOR;
            if(param1.delayToSendWagon > 0)
            {
               this.arrivalStatus.text = "Waiting " + param1.delayToSendWagon + "...";
            }
            else
            {
               this.arrivalStatus.text = "Available";
            }
         }
         else
         {
            _loc2_ = param1.currentWagon;
            if(_loc2_.arriving == _loc2_.ARRIVE)
            {
               this.arrivalStatus.textColor = ColorCode.POSITIVE_CASH_ANIMATION;
               this.arrivalStatus.text = "Incoming";
            }
            else if(_loc2_.arriving == _loc2_.DROP)
            {
               this.arrivalStatus.textColor = ColorCode.REQUIREMENT_COLOR;
               this.arrivalStatus.text = "Deploy";
            }
            else if(_loc2_.arriving == _loc2_.LEAVE)
            {
               this.arrivalStatus.textColor = ColorCode.REFUND_CASH_ANIMATION;
               this.arrivalStatus.text = "Leaving";
            }
         }
      }
      
      function btnUpgradeOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            _relation.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_UPGRADE));
         }
      }
   }
}
