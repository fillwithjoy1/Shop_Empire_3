package Instance.ui
{
   import Instance.Gameplay;
   import Instance.constant.BuildingData;
   import Instance.constant.ColorCode;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class UIElevatorInfo extends UI_InfoDialog
   {
       
      
      public var numberPeople:TextField;
      
      public var star0:MovieClip;
      
      public var star1:MovieClip;
      
      public var star2:MovieClip;
      
      public var movingIndicator:MovieClip;
      
      public var descriptionInfo:TextField;
      
      public var capacityIcon:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var expandCostInfo:TextField;
      
      public var upgradeCostInfo:TextField;
      
      public var buildIcon:MovieClip;
      
      public var bodyPartBottomLeft:MovieClip;
      
      public var connectionFloor:TextField;
      
      public var btnDestroy:SimpleButton;
      
      public var bodyPartBottomRight:MovieClip;
      
      public var atFloor:TextField;
      
      public var bodyPartCenter:MovieClip;
      
      public var buildingName:TextField;
      
      public var upgradeInfo:TextField;
      
      public var bodyPartBottomCenter:MovieClip;
      
      public var bodyPartRight:MovieClip;
      
      public var bodyPartLeft:MovieClip;
      
      public var expBar:MovieClip;
      
      public var btnUpgrade:SimpleButton;
      
      public var dragArea:MovieClip;
      
      var _starList:Array;
      
      var flashing:Boolean = false;
      
      var delayToFlashing:int = 12;
      
      public function UIElevatorInfo()
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
         this.buildingName.defaultTextFormat = _loc1_;
         this.numberPeople.defaultTextFormat = _loc1_;
         this.descriptionInfo.defaultTextFormat = _loc1_;
         this.movingIndicator.stop();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.buildIcon.gotoAndStop(BuildingData.getIconOf("Elevator"));
         var _loc2_:* = _relation.world.elevatorList.indexOf(_relation);
         if(_loc2_ in _relation.world.elevatorList)
         {
            this.buildingName.text = "Elevator #" + (_loc2_ + 1);
         }
         this.descriptionInfo.text = BuildingData.getDescription("Elevator");
         var _loc3_:* = _relation.lowestRoom;
         var _loc4_:* = _relation.highestRoom;
         var _loc5_:* = _relation.world.getFloorAt(_loc3_.y);
         var _loc6_:* = _relation.world.getFloorAt(_loc4_.y);
         var _loc7_:* = _relation.world.floorList.indexOf(_loc5_);
         var _loc8_:* = _relation.world.floorList.indexOf(_loc6_);
         var _loc9_:* = _loc7_ == 0 ? "Ground" : Utility.numberToOrdinal(_loc7_) + " floor";
         var _loc10_:* = _loc8_ == 0 ? "ground" : Utility.numberToOrdinal(_loc8_) + " floor";
         var _loc11_:* = _loc9_ + " to " + _loc10_;
         this.connectionFloor.text = _loc11_;
         this.upgradeInfo.text = BuildingData.getUpgradeInfo("Elevator");
         this.setUpgradeCost();
         this.checkAvailableUpgrade(_relation.world.main);
         this.updateData(_relation);
         this.checkUpgradeable(_relation);
         this.updateExperience(_relation);
         addListenerOf(this,Event.ENTER_FRAME,this.checkCondition);
         addListenerOf(this.btnDestroy,MouseEvent.CLICK,this.btnDestroyOnClick);
         addListenerOf(this.btnUpgrade,MouseEvent.CLICK,this.btnUpgradeOnClick);
         addListenerOf(_relation,GameEvent.BECOMES_UPGRADE,this.checkUpgrade);
         addListenerOf(_relation,GameEvent.BUILDING_SUCCESSFULLY_UPGRADE,this.successfullyUpgrade);
         addListenerOf(stage,GameEvent.UPDATE_BUDGET,this.whenBudgetChange);
         addListenerOf(_relation,GameEvent.GAIN_EXPERIENCE,this.checkCurrentExperience);
      }
      
      function setUpgradeCost() : void
      {
         this.upgradeCostInfo.text = "" + Utility.numberToMoney(_relation.upgradeCost) + " G";
         this.expandCostInfo.text = "" + Utility.numberToMoney(_relation.EXPAND_COST[_relation.level - 1]) + " G";
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
      
      function successfullyUpgrade(param1:GameEvent) : void
      {
         this.setUpgradeCost();
         this.checkUpgradeable(_relation);
         this.updateExperience(_relation);
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
         if(param1.isEnough(_relation.EXPAND_COST[_relation.level - 1]))
         {
            this.expandCostInfo.textColor = 16777215;
         }
         else
         {
            this.expandCostInfo.textColor = ColorCode.NEGATIVE_CASH_ANIMATION;
         }
      }
      
      function updateData(param1:*) : void
      {
         this.checkLevel(param1);
         this.checkCapacity(param1);
         this.checkMovingAndFloor(param1);
      }
      
      function checkCondition(param1:Event) : void
      {
         if(_relation != null)
         {
            this.checkCapacity(_relation);
            this.checkMovingAndFloor(_relation);
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
         _loc2_ = "/" + param1.capacityLimit;
         this.numberPeople.text = "" + param1.passanger.length + "" + _loc2_;
         this.capacityIcon.x = Math.round(this.numberPeople.x + this.numberPeople.width - this.numberPeople.textWidth) - 12;
      }
      
      function checkMovingAndFloor(param1:*) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(param1.roomTarget.length > 0)
         {
            if(param1.dirrectionRoom < 0)
            {
               this.movingIndicator.gotoAndStop("down");
            }
            else if(param1.dirrectionRoom > 0)
            {
               this.movingIndicator.gotoAndStop("up");
            }
         }
         else
         {
            this.movingIndicator.gotoAndStop("stop");
         }
         var _loc2_:* = param1.world.mainContainer.globalToLocal(param1.room.localToGlobal(new Point(0,0)));
         var _loc3_:* = -1;
         var _loc4_:* = Infinity;
         var _loc5_:* = 0;
         while(_loc5_ < param1.world.floorList.length)
         {
            _loc6_ = param1.world.floorList[_loc5_];
            if((_loc7_ = Math.abs(_loc6_.y - _loc2_.y)) < _loc4_)
            {
               if(_loc2_.x >= _loc6_.left && _loc2_.x <= _loc6_.right)
               {
                  _loc3_ = _loc5_;
                  _loc4_ = _loc7_;
               }
            }
            _loc5_++;
         }
         if(_loc3_ >= 0)
         {
            if(_loc3_ == 0)
            {
               this.atFloor.text = "Ground";
            }
            else
            {
               this.atFloor.text = Utility.numberToOrdinal(_loc3_) + " floor";
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
   }
}
