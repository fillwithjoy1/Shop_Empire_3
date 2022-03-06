package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.constant.BuildingData;
   import Instance.constant.ColorCode;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.gameplay.StaffHandyman;
   import Instance.modules.Utility;
   import Instance.property.Booth;
   import Instance.property.Elevator;
   import Instance.property.FacilityRestRoom;
   import Instance.property.HalteWagon;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import greensock.TweenLite;
   
   public class BuildingBox extends SEMovieClip
   {
       
      
      public var numberPeople:TextField;
      
      public var star0:MovieClip;
      
      public var star1:MovieClip;
      
      public var star2:MovieClip;
      
      public var capacityIcon:MovieClip;
      
      public var buildIcon:MovieClip;
      
      public var numberFemale:TextField;
      
      public var btnDestroy:SimpleButton;
      
      public var openStatus:MovieClip;
      
      public var buildingNameInfo:TextField;
      
      public var capacityFemaleIcon:MovieClip;
      
      public var brokenStatus:MovieClip;
      
      public var upgradeInfo:MovieClip;
      
      public var expBar:MovieClip;
      
      public var btnUpgrade:SimpleButton;
      
      var _related;
      
      var blinkDelay:int;
      
      var _starList:Array;
      
      var btnUpgradePosition:Point;
      
      public function BuildingBox()
      {
         super();
         this._starList = new Array();
         this._starList.push(this.star0);
         this._starList.push(this.star1);
         this._starList.push(this.star2);
         this.numberPeople.autoSize = TextFieldAutoSize.RIGHT;
         this.numberFemale.autoSize = TextFieldAutoSize.RIGHT;
         this.capacityIcon.gotoAndStop(1);
         this.capacityFemaleIcon.gotoAndStop(2);
         this.openStatus.stop();
         this.btnUpgradePosition = new Point(this.btnUpgrade.x,this.btnUpgrade.y);
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.letterSpacing = -1;
         this.buildingNameInfo.defaultTextFormat = _loc1_;
         this.numberPeople.defaultTextFormat = _loc1_;
         this.numberFemale.defaultTextFormat = _loc1_;
         this.upgradeInfo.visible = false;
         this.upgradeInfo.mouseEnabled = false;
         this.upgradeInfo.mouseChildren = false;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,Event.ENTER_FRAME,this.checkCondition);
         addListenerOf(this.btnUpgrade,MouseEvent.CLICK,this.btnUpgradeOnClick);
         addListenerOf(this.btnUpgrade,MouseEvent.ROLL_OVER,this.btnUpgradeOnOver);
         addListenerOf(this.btnDestroy,MouseEvent.CLICK,this.btnDestroyOnClick);
         addListenerOf(stage,GameEvent.BECOMES_UPGRADE,this.checkUpgrade);
         addListenerOf(stage,GameEvent.GAIN_EXPERIENCE,this.checkCurrentExperience);
         addListenerOf(stage,GameEvent.BUILDING_SUCCESSFULLY_UPGRADE,this.afterUpgradeCheck);
         if(this._related != null)
         {
            this.updateData(this._related);
         }
      }
      
      function btnUpgradeOnOver(param1:MouseEvent) : void
      {
         if(this._related != null)
         {
            if(this._related.level < this._related.maxLevel)
            {
               this.upgradeInfo.bubbleText.text = Utility.numberToMoney(this._related.upgradeCost) + " G";
               TweenLite.to(this,0.8,{"onComplete":this.showUpgradeInfo});
               addListenerOf(this.btnUpgrade,MouseEvent.ROLL_OUT,this.hideUpgradeCost);
            }
         }
      }
      
      function checkUpgradeColor() : void
      {
         if(this._related != null)
         {
            if(this._related.world.main.isEnough(this._related.upgradeCost))
            {
               this.upgradeInfo.bubbleText.textColor = ColorCode.VALID_CASH;
            }
            else
            {
               this.upgradeInfo.bubbleText.textColor = ColorCode.MINUS_CASH;
            }
         }
      }
      
      function showUpgradeInfo() : void
      {
         this.upgradeInfo.visible = true;
         this.checkUpgradeColor();
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.whenCashUpdate);
      }
      
      function whenCashUpdate(param1:GameEvent) : void
      {
         this.checkUpgradeColor();
      }
      
      function hideUpgradeCost(param1:MouseEvent) : void
      {
         this.upgradeInfo.visible = false;
         TweenLite.killTweensOf(this);
         removeListenerOf(this.btnUpgrade,MouseEvent.ROLL_OUT,this.hideUpgradeCost);
         removeListenerOf(stage,GameEvent.GAME_UPDATE,this.whenCashUpdate);
      }
      
      function checkCurrentExperience(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._related)
         {
            this.updateExperience(_loc2_);
         }
      }
      
      function checkUpgrade(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._related)
         {
            this._starList[this._related.level].gotoAndPlay("Transform");
         }
      }
      
      function afterUpgradeCheck(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._related)
         {
            this.checkUpgradeable(_loc2_);
            this.updateExperience(_loc2_);
            if(this.upgradeInfo.visible)
            {
               if(this._related.level < this._related.maxLevel)
               {
                  this.upgradeInfo.bubbleText.text = Utility.numberToMoney(this._related.upgradeCost) + " G";
                  this.checkUpgradeColor();
               }
               else
               {
                  this.upgradeInfo.visible = false;
                  TweenLite.killTweensOf(this);
                  removeListenerOf(this.btnUpgrade,MouseEvent.ROLL_OUT,this.hideUpgradeCost);
                  removeListenerOf(stage,GameEvent.GAME_UPDATE,this.whenCashUpdate);
               }
            }
            this.expBar.visible = _loc2_.level < _loc2_.maxLevel;
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
         this.expBar.maskBar.width = param1.expPercentage * this.expBar.fillBar.width;
      }
      
      function btnUpgradeOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            if(this._related != null)
            {
               this._related.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_UPGRADE));
            }
         }
      }
      
      function btnDestroyOnClick(param1:MouseEvent) : void
      {
         if(this._related != null)
         {
            this._related.dispatchEvent(new CommandEvent(CommandEvent.BEGIN_DESTROY));
         }
      }
      
      function checkCondition(param1:Event) : void
      {
         if(this._related != null)
         {
            if(this._related.world.brokableBuildingList.indexOf(this._related) >= 0)
            {
               if(this.blinkDelay > 0)
               {
                  --this.blinkDelay;
               }
               else
               {
                  if(!this.brokenStatus.visible)
                  {
                     this.checkBrokenCondition(this._related);
                  }
                  this.brokenStatus.visible = !this.brokenStatus.visible;
                  this.blinkDelay = !!this.brokenStatus.visible ? 20 : 5;
               }
            }
            this.checkCapacity(this._related);
            this.checkOpenCondition(this._related);
         }
      }
      
      function updateData(param1:*) : void
      {
         var _loc2_:* = "";
         if(param1 is Elevator)
         {
            _loc2_ = "Elevator";
         }
         else if(param1 is HalteWagon)
         {
            _loc2_ = "Halte Wagon";
         }
         else
         {
            _loc2_ = BuildingData.returnClassTo(Utility.getClass(param1));
            if(_loc2_ == null)
            {
               _loc2_ = "";
            }
         }
         var _loc3_:* = "";
         if(param1 is HalteWagon)
         {
            _loc3_ = "halteWagon";
         }
         else
         {
            _loc3_ = BuildingData.getIconOf(_loc2_);
         }
         this.buildingNameInfo.text = _loc2_;
         if(Utility.hasLabel(this.buildIcon,_loc3_))
         {
            this.buildIcon.visible = true;
            this.buildIcon.gotoAndStop(_loc3_);
         }
         else
         {
            this.buildIcon.visible = false;
         }
         if(param1.destroyable)
         {
            this.btnUpgrade.x = this.btnUpgradePosition.x;
            this.btnUpgrade.y = this.btnUpgradePosition.y;
            this.btnDestroy.visible = true;
         }
         else
         {
            this.btnUpgrade.x = this.btnDestroy.x;
            this.btnUpgrade.y = this.btnDestroy.y;
            this.btnDestroy.visible = false;
         }
         this.btnUpgrade.visible = param1.maxLevel > 1;
         this.expBar.visible = param1.level < param1.maxLevel;
         this.checkLevel(param1);
         this.upgradeInfo.x = this.btnUpgrade.x + 42;
         if(param1.world.brokableBuildingList.indexOf(param1) < 0)
         {
            this.brokenStatus.visible = false;
         }
         else
         {
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
         var _loc2_:* = 0;
         if(!(param1 is Elevator))
         {
            _loc2_ = isFinite(param1.capacity) && !isNaN(param1.capacity) ? "/" + param1.capacity : "";
         }
         if(param1 is FacilityRestRoom)
         {
            this.capacityFemaleIcon.visible = true;
            this.numberFemale.visible = true;
            if(param1.maleRoom != null)
            {
               this.numberPeople.text = param1.maleRoom.humanList.length + "" + _loc2_;
            }
            if(param1.femaleRoom != null)
            {
               this.numberFemale.text = param1.femaleRoom.humanList.length + "" + _loc2_;
            }
         }
         else
         {
            this.capacityFemaleIcon.visible = false;
            this.numberFemale.visible = false;
            if(param1 is Booth)
            {
               this.numberPeople.text = "" + param1.visitorList.length + "" + _loc2_;
            }
            else if(param1 is Elevator)
            {
               _loc2_ = "/" + param1.capacityLimit + "";
               this.numberPeople.text = "" + param1.passanger.length + "" + _loc2_;
            }
            else if(param1 is HalteWagon)
            {
               this.numberPeople.text = "" + (param1.humanList.length + param1.passangerInWagon) + "" + _loc2_;
            }
            else
            {
               this.numberPeople.text = "" + param1.numberPeople + "" + _loc2_;
            }
         }
         this.capacityIcon.x = Math.round(this.numberPeople.x + this.numberPeople.width - this.numberPeople.textWidth) - 12;
         if(this.numberFemale.visible)
         {
            this.numberFemale.x = Math.round(this.capacityIcon.x - 10 - this.numberFemale.width);
            this.capacityFemaleIcon.x = Math.round(this.numberFemale.x + this.numberFemale.width - this.numberFemale.textWidth) - 12;
         }
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
      
      public function set related(param1:*) : void
      {
         this._related = param1;
         if(this._related != null)
         {
            this.updateData(this._related);
         }
      }
      
      public function get related() : *
      {
         return this._related;
      }
   }
}
