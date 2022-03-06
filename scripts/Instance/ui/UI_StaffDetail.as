package Instance.ui
{
   import Instance.events.ComboEvent;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class UI_StaffDetail extends UI_InfoPanel
   {
       
      
      public var prevPage:SimpleButton;
      
      public var nextPage:SimpleButton;
      
      public var box1:StaffBox;
      
      public var box2:StaffBox;
      
      public var box3:StaffBox;
      
      public var pageInfo:TextField;
      
      public var box4:StaffBox;
      
      public var deactiveTab0:MovieClip;
      
      public var box5:StaffBox;
      
      public var deactiveTab1:MovieClip;
      
      public var workFloorPopUp:UI_WorkFloorPopUp;
      
      public var workTimePopUp:UI_WorkTimePopUp;
      
      public var btnClose:SimpleButton;
      
      public var control6:MovieClip;
      
      public var box6:StaffBox;
      
      public var deactiveTab2:MovieClip;
      
      public var control7:MovieClip;
      
      public var box7:StaffBox;
      
      public var deactiveTab3:MovieClip;
      
      public var control4:MovieClip;
      
      public var statusPopUp:MovieClip;
      
      public var control5:MovieClip;
      
      public var control2:MovieClip;
      
      public var control3:MovieClip;
      
      public var control0:MovieClip;
      
      public var control1:MovieClip;
      
      public var activateTab:MovieClip;
      
      public var orderByCombo:OrderByCombobox;
      
      public var box0:StaffBox;
      
      const JANITOR = 0;
      
      const HANDYMAN = 1;
      
      const ENTERTAINER = 2;
      
      const GUARD = 3;
      
      const FRAME_JOB = ["janitor","handyman","entertainer","guard"];
      
      var boxList:Array;
      
      var controlList:Array;
      
      var _staffList:Object;
      
      var _page:int;
      
      var delayToRevealStatus:int;
      
      var checkedBox;
      
      var _focusTarget;
      
      var _hasUpdate:Boolean;
      
      var _toUpdateCtr:int;
      
      public function UI_StaffDetail()
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         super();
         this._staffList = new Object();
         this._staffList.janitor = new Array();
         this._staffList.handyman = new Array();
         this._staffList.entertainment = new Array();
         this._focusTarget = null;
         this._page = 0;
         this._toUpdateCtr = 0;
         this.statusPopUp.statSymbolStamina.gotoAndStop(1);
         this.statusPopUp.statSymbolHygine.gotoAndStop(2);
         this.statusPopUp.statSymbolEntertain.gotoAndStop(3);
         this.statusPopUp.statSymbolSight.gotoAndStop(4);
         this.statusPopUp.statSymbolSpeed.gotoAndStop(5);
         this.statusPopUp.mouseEnabled = false;
         this.statusPopUp.mouseChildren = false;
         this.statusPopUp.parent.removeChild(this.statusPopUp);
         this.workTimePopUp.parent.removeChild(this.workTimePopUp);
         this.workFloorPopUp.parent.removeChild(this.workFloorPopUp);
         this.boxList = new Array();
         var _loc1_:* = 0;
         while(getChildByName("box" + _loc1_))
         {
            _loc2_ = getChildByName("box" + _loc1_);
            _loc2_.mouseChildren = false;
            _loc2_.buttonMode = true;
            this.boxList.push(_loc2_);
            _loc1_++;
         }
         this.controlList = new Array();
         _loc1_ = 0;
         while(getChildByName("control" + _loc1_))
         {
            _loc3_ = getChildByName("control" + _loc1_);
            _loc3_.workFloorChange.buttonMode = true;
            _loc3_.workTimeChange.buttonMode = true;
            this.controlList.push(_loc3_);
            _loc1_++;
         }
         this.orderByCombo.addItem("First Hired");
         this.orderByCombo.addItem("Latest");
         this.orderByCombo.addItem("Name");
         this.orderByCombo.addItem("Prm Cost");
         this.orderByCombo.addItem("Average");
         this.orderByCombo.addItem("Stamina");
         this.orderByCombo.addItem("Hygine");
         this.orderByCombo.addItem("Fun");
         this.orderByCombo.addItem("Sight");
         this.orderByCombo.addItem("Speed");
         this.orderByCombo.addItem("Level");
         this.orderByCombo.addItem("Vitality");
         this.orderByCombo.addItem("Experience");
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         super.Initialize(param1);
         var _loc2_:* = 0;
         while(_loc2_ < this.boxList.length)
         {
            _loc3_ = this.boxList[_loc2_];
            if(_loc2_ in this.controlList)
            {
               _loc3_.controlPanel = this.controlList[_loc2_];
            }
            addListenerOf(_loc3_,MouseEvent.ROLL_OVER,this.showStaffStatus);
            addListenerOf(_loc3_,MouseEvent.CLICK,this.boxOnClick);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.controlList.length)
         {
            (_loc4_ = this.controlList[_loc2_]).promoteInfo.visible = false;
            _loc4_.promoteInfo.mouseEnabled = false;
            _loc4_.promoteInfo.mouseChildren = false;
            addListenerOf(_loc4_.btnPromote,MouseEvent.CLICK,this.promote);
            addListenerOf(_loc4_.btnFire,MouseEvent.CLICK,this.fire);
            addListenerOf(_loc4_.workFloorChange,MouseEvent.CLICK,this.workFloorChangeOnClick);
            addListenerOf(_loc4_.workTimeChange,MouseEvent.CLICK,this.workTimeChangeOnClick);
            _loc2_++;
         }
         addListenerOf(this.prevPage,MouseEvent.CLICK,this.changePage);
         addListenerOf(this.nextPage,MouseEvent.CLICK,this.changePage);
         addListenerOf(stage,GameEvent.FIRE,this.whenSomeoneFired);
         addListenerOf(stage,HumanEvent.UPDATE_VITALITY,this.checkUpdateVitality);
         addListenerOf(stage,HumanEvent.UPDATE_EXPERIENCE,this.checkUpdateExperience);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.updateView);
      }
      
      function updateView(param1:GameEvent) : void
      {
         if(this._toUpdateCtr > 0)
         {
            --this._toUpdateCtr;
         }
         else if(this._hasUpdate)
         {
            this.checkActiveTab();
            this._hasUpdate = false;
            this._toUpdateCtr = 5;
         }
      }
      
      function checkUpdateVitality(param1:HumanEvent) : void
      {
         var _loc2_:* = this.orderByCombo.comboItem[_selectedOrder].toLowerCase();
         if(_loc2_ == "vitality")
         {
            this._hasUpdate = true;
         }
      }
      
      function checkUpdateExperience(param1:HumanEvent) : void
      {
         var _loc2_:* = this.orderByCombo.comboItem[_selectedOrder].toLowerCase();
         if(_loc2_ == "experience" || _loc2_ == "level")
         {
            this._hasUpdate = true;
         }
      }
      
      function boxOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.related != null)
         {
            _loc2_.related.dispatchEvent(new CommandEvent(CommandEvent.HUMAN_ON_SELECT));
         }
      }
      
      function changePage(param1:MouseEvent) : void
      {
         var _loc2_:* = this.FRAME_JOB[_activeTab];
         var _loc3_:Array = this.getShownStaff(_loc2_);
         var _loc4_:* = Math.max(1,Math.ceil(_loc3_.length / this.boxList.length));
         var _loc5_:*;
         if((_loc5_ = param1.currentTarget) == this.prevPage)
         {
            --this._page;
            if(this._page < 0)
            {
               this._page = _loc4_ - 1;
            }
         }
         else if(_loc5_ == this.nextPage)
         {
            ++this._page;
            if(this._page >= _loc4_)
            {
               this._page = 0;
            }
         }
         this.checkActiveTab();
      }
      
      function whenSomeoneFired(param1:GameEvent) : void
      {
         var _loc2_:* = this.FRAME_JOB[_activeTab];
         var _loc3_:Array = this.getShownStaff(_loc2_);
         var _loc4_:* = Math.max(1,Math.ceil(_loc3_.length / this.boxList.length));
         if(this._page >= _loc4_)
         {
            this._page = _loc4_ - 1;
         }
         this.checkActiveTab();
      }
      
      function promote(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            _loc3_ = _loc2_.parent;
            if((_loc4_ = this.controlList.indexOf(_loc3_)) in this.controlList)
            {
               _loc5_ = this.getShownStaff(this.FRAME_JOB[_activeTab]);
               if((_loc6_ = this._page * this.controlList.length + _loc4_) in _loc5_)
               {
                  _loc5_[_loc6_].dispatchEvent(new CommandEvent(CommandEvent.BEGIN_PROMOTE,this.boxList[_loc4_]));
               }
            }
         }
      }
      
      function fire(param1:MouseEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = _loc2_.parent;
         var _loc4_:*;
         if((_loc4_ = this.controlList.indexOf(_loc3_)) in this.controlList)
         {
            _loc5_ = this.getShownStaff(this.FRAME_JOB[_activeTab]);
            if((_loc6_ = this._page * this.controlList.length + _loc4_) in _loc5_)
            {
               _loc5_[_loc6_].dispatchEvent(new CommandEvent(CommandEvent.BEGIN_FIRE));
            }
         }
      }
      
      override public function onDismiss() : void
      {
         if(this.workTimePopUp.stage != null)
         {
            this.workTimePopUp.parent.removeChild(this.workTimePopUp);
         }
         if(this.workFloorPopUp.stage != null)
         {
            this.workFloorPopUp.parent.removeChild(this.workFloorPopUp);
         }
         this._focusTarget = null;
      }
      
      override function tabBarOnClick(param1:MouseEvent) : void
      {
         this._page = 0;
         super.tabBarOnClick(param1);
         this.onDismiss();
      }
      
      function selectWorkTime(param1:ComboEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Array = null;
         var _loc6_:* = undefined;
         var _loc2_:* = param1.selected;
         var _loc3_:* = this.workTimePopUp.getChildByName("highlighted" + _loc2_);
         if(_loc3_ != null)
         {
            this.workTimePopUp.selectedMark.y = _loc3_.y + _loc3_.height / 2;
            if(this._focusTarget != null)
            {
               if(this._focusTarget.destination != "home" && !this._focusTarget.inHome)
               {
                  _loc4_ = this.FRAME_JOB[_activeTab];
                  if((_loc6_ = (_loc5_ = this.getShownStaff(_loc4_)).indexOf(this._focusTarget)) - this._page in this.boxList)
                  {
                     this._focusTarget.salaryObject = this.boxList[_loc6_ - this._page].humanIcon;
                     this._focusTarget.dispatchEvent(new HumanEvent(HumanEvent.PAY_SALARY,this._focusTarget.salaryObject));
                  }
               }
               switch(_loc2_)
               {
                  case 0:
                     this._focusTarget.workTime.workStart = 9;
                     this._focusTarget.workTime.workEnd = 19;
                     break;
                  case 1:
                     this._focusTarget.workTime.workStart = 19;
                     this._focusTarget.workTime.workEnd = 5;
                     break;
                  case 2:
                     this._focusTarget.workTime.workStart = 9;
                     this._focusTarget.workTime.workEnd = 5;
               }
               if(this.workTimePopUp.stage != null)
               {
                  this.workTimePopUp.parent.removeChild(this.workTimePopUp);
               }
               this._focusTarget = null;
               this.checkActiveTab();
            }
         }
      }
      
      function selectWorkFloor(param1:ComboEvent) : void
      {
         var _loc2_:* = param1.selected;
         if(this._focusTarget != null)
         {
            if(_loc2_ == 0)
            {
               this._focusTarget.workFloor = null;
            }
            else
            {
               this._focusTarget.workFloor = this._focusTarget.world.floorList[_loc2_ - 1];
            }
            if(this.workFloorPopUp.stage != null)
            {
               this.workFloorPopUp.parent.removeChild(this.workFloorPopUp);
            }
            this._focusTarget = null;
            this.checkActiveTab();
         }
      }
      
      function selectWorkTimeRemoved(param1:Event) : void
      {
         removeListenerOf(this.workTimePopUp,ComboEvent.ON_SELECT,this.selectWorkTime);
         removeListenerOf(this.workTimePopUp,Event.REMOVED_FROM_STAGE,this.selectWorkTimeRemoved);
      }
      
      function selectWorkFloorRemoved(param1:Event) : void
      {
         removeListenerOf(this.workFloorPopUp,ComboEvent.ON_SELECT,this.selectWorkFloor);
         removeListenerOf(this.workFloorPopUp,Event.REMOVED_FROM_STAGE,this.selectWorkFloorRemoved);
      }
      
      function workTimeChangeOnClick(param1:MouseEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = _loc2_.parent;
         var _loc4_:*;
         if((_loc4_ = this.controlList.indexOf(_loc3_)) in this.boxList)
         {
            _loc5_ = this.boxList[_loc4_];
            if(this._focusTarget == null || this._focusTarget != _loc5_.related || this.workFloorPopUp.stage != null)
            {
               this._focusTarget = _loc5_.related;
               _loc6_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
               this.workTimePopUp.x = _loc6_.x + _loc2_.width / 2 - 15;
               if(this.workTimePopUp.x > 0)
               {
                  this.workTimePopUp.x = _loc6_.x - _loc2_.width / 2 + 15 - this.workTimePopUp.width;
               }
               this.workTimePopUp.y = _loc6_.y + _loc2_.height / 2;
               this.workTimePopUp.y -= this.workTimePopUp.height;
               if(this.workTimePopUp.stage == null)
               {
                  this.addChild(this.workTimePopUp);
               }
               _loc7_ = _loc5_.related.workTime;
               _loc8_ = null;
               if(_loc7_.workStart == 9 && _loc7_.workEnd == 19)
               {
                  _loc8_ = this.workTimePopUp.highlighted0;
               }
               else if(_loc7_.workStart == 19 && _loc7_.workEnd == 5)
               {
                  _loc8_ = this.workTimePopUp.highlighted1;
               }
               if(_loc7_.workStart == 9 && _loc7_.workEnd == 5)
               {
                  _loc8_ = this.workTimePopUp.highlighted2;
               }
               if(_loc8_ != null)
               {
                  this.workTimePopUp.selectedMark.y = _loc8_.y + _loc8_.height / 2;
               }
               addListenerOf(this.workTimePopUp,ComboEvent.ON_SELECT,this.selectWorkTime);
               addListenerOf(this.workTimePopUp,Event.REMOVED_FROM_STAGE,this.selectWorkTimeRemoved);
               if(this.workFloorPopUp.stage != null)
               {
                  this.workFloorPopUp.parent.removeChild(this.workFloorPopUp);
               }
            }
            else
            {
               this._focusTarget = null;
               if(this.workTimePopUp.stage != null)
               {
                  this.workTimePopUp.parent.removeChild(this.workTimePopUp);
               }
            }
         }
      }
      
      function workFloorChangeOnClick(param1:MouseEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = _loc2_.parent;
         var _loc4_:*;
         if((_loc4_ = this.controlList.indexOf(_loc3_)) in this.boxList)
         {
            _loc5_ = this.boxList[_loc4_];
            if(this._focusTarget == null || this._focusTarget != _loc5_.related || this.workTimePopUp.stage != null)
            {
               this._focusTarget = _loc5_.related;
               this.workFloorPopUp.world = this._focusTarget.world;
               this.workFloorPopUp.floorRelated = this._focusTarget.workFloor;
               if(this.workFloorPopUp.stage == null)
               {
                  this.addChild(this.workFloorPopUp);
               }
               else
               {
                  this.workFloorPopUp.refreshView();
               }
               _loc6_ = this.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
               this.workFloorPopUp.x = _loc6_.x + _loc2_.width / 2 - 15;
               if(this.workFloorPopUp.x > 0)
               {
                  this.workFloorPopUp.x = _loc6_.x - _loc2_.width / 2 + 15 - this.workFloorPopUp.width;
               }
               this.workFloorPopUp.y = _loc6_.y + _loc2_.height / 2;
               this.workFloorPopUp.y -= this.workFloorPopUp.height;
               if(this.workTimePopUp.stage != null)
               {
                  this.workTimePopUp.parent.removeChild(this.workTimePopUp);
               }
               addListenerOf(this.workFloorPopUp,ComboEvent.ON_SELECT,this.selectWorkFloor);
               addListenerOf(this.workFloorPopUp,Event.REMOVED_FROM_STAGE,this.selectWorkFloorRemoved);
            }
            else
            {
               this._focusTarget = null;
               if(this.workFloorPopUp.stage != null)
               {
                  this.workFloorPopUp.parent.removeChild(this.workFloorPopUp);
               }
            }
         }
      }
      
      function showStaffStatus(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         this.delayToRevealStatus = 30;
         if(_loc2_.related != null)
         {
            _loc3_ = _loc2_.related.stat;
            this.statusPopUp.staminaBar.maskBar.scaleX = _loc3_.stamina / 100;
            this.statusPopUp.hygineBar.maskBar.scaleX = _loc3_.hygine / 100;
            this.statusPopUp.entertainBar.maskBar.scaleX = _loc3_.entertain / 100;
            this.statusPopUp.sightBar.maskBar.scaleX = _loc3_.sight / 100;
            this.statusPopUp.speedBar.maskBar.scaleX = _loc3_.speed / 100;
            this.checkedBox = _loc2_;
            addListenerOf(this,Event.ENTER_FRAME,this.countdownToRevealStatus);
         }
         addListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.hideStaffStatus);
      }
      
      function countdownToRevealStatus(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.delayToRevealStatus > 0)
         {
            --this.delayToRevealStatus;
         }
         else
         {
            if(this.statusPopUp.stage == null)
            {
               _loc2_ = this.parent;
               _loc3_ = _loc2_.globalToLocal(this.checkedBox.localToGlobal(new Point(0,0)));
               this.statusPopUp.x = _loc3_.x + this.checkedBox.width - 25;
               if(this.statusPopUp.x > 400)
               {
                  this.statusPopUp.x = _loc3_.x - this.checkedBox.width + 25;
               }
               this.statusPopUp.y = _loc3_.y + this.checkedBox.height / 2;
               if(this.statusPopUp.y > 250)
               {
                  this.statusPopUp.y -= this.statusPopUp.height;
               }
               this.parent.addChild(this.statusPopUp);
            }
            removeListenerOf(this,Event.ENTER_FRAME,this.countdownToRevealStatus);
         }
      }
      
      function hideStaffStatus(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(this.statusPopUp.stage != null)
         {
            this.statusPopUp.parent.removeChild(this.statusPopUp);
         }
         this.checkedBox = null;
         removeListenerOf(this,Event.ENTER_FRAME,this.countdownToRevealStatus);
         removeListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.hideStaffStatus);
      }
      
      function sortByStatus(param1:Array, param2:String, param3:Boolean = false) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc4_:* = 0;
         while(_loc4_ < param1.length - 1)
         {
            _loc5_ = _loc4_ + 1;
            while(_loc5_ < param1.length)
            {
               if(param2 in param1[_loc4_].stat && param2 in param1[_loc5_].stat)
               {
                  _loc6_ = param1[_loc4_].stat[param2];
                  _loc7_ = param1[_loc5_].stat[param2];
                  _loc8_ = false;
                  if(param3)
                  {
                     _loc8_ = _loc6_ < _loc7_;
                  }
                  else
                  {
                     _loc8_ = _loc6_ > _loc7_;
                  }
                  if(_loc8_)
                  {
                     _loc9_ = param1[_loc4_];
                     param1[_loc4_] = param1[_loc5_];
                     param1[_loc5_] = _loc9_;
                  }
               }
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      function sortMode(param1:Array) : void
      {
         var _loc2_:* = this.orderByCombo.comboItem[_selectedOrder];
         switch(_loc2_.toLowerCase())
         {
            case "first hire":
               break;
            case "latest":
               param1.reverse();
               break;
            case "name":
               this.sortByStatus(param1,"characterName");
               break;
            case "prm cost":
               param1.sortOn("promotionCost");
               break;
            case "average":
               this.sortByStatus(param1,"average",true);
               break;
            case "stamina":
               this.sortByStatus(param1,"stamina",true);
               break;
            case "hygine":
               this.sortByStatus(param1,"hygine",true);
               break;
            case "fun":
               this.sortByStatus(param1,"entertain",true);
               break;
            case "sight":
               this.sortByStatus(param1,"sight",true);
               break;
            case "speed":
               this.sortByStatus(param1,"speed",true);
               break;
            case "level":
               param1.sortOn(["level","expPercentage"],[Array.NUMERIC,Array.NUMERIC | Array.DESCENDING]);
               break;
            case "vitality":
               param1.sortOn(["tiredTime","vitality"],[Array.NUMERIC,Array.NUMERIC | Array.DESCENDING]);
               break;
            case "experience":
               param1.sortOn(["expPercentage","level"],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
         }
      }
      
      function getShownStaff(param1:*) : Array
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = new Array();
         switch(param1)
         {
            case "janitor":
               _loc2_ = this._staffList.janitor.concat();
               break;
            case "handyman":
               _loc2_ = this._staffList.handyman.concat();
               break;
            case "entertainer":
               _loc2_ = this._staffList.entertainer.concat();
               break;
            case "guard":
               _loc2_ = this._staffList.guard.concat();
         }
         var _loc3_:* = 0;
         while(_loc3_ < this._staffList.unshown.length)
         {
            _loc4_ = this._staffList.unshown[_loc3_];
            if((_loc5_ = _loc2_.indexOf(_loc4_)) in _loc2_)
            {
               _loc2_.splice(_loc5_,1);
            }
            _loc3_++;
         }
         this.sortMode(_loc2_);
         return _loc2_;
      }
      
      override function checkActiveTab() : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         super.checkActiveTab();
         var _loc1_:* = this.FRAME_JOB[_activeTab];
         var _loc2_:* = 0;
         while(_loc2_ < this.boxList.length)
         {
            (_loc5_ = this.boxList[_loc2_]).humanIcon.gotoAndStop(_loc1_);
            _loc2_++;
         }
         var _loc3_:Array = this.getShownStaff(_loc1_);
         this.pageInfo.text = "" + (this._page + 1) + "/" + Math.max(1,Math.ceil(_loc3_.length / this.boxList.length));
         var _loc4_:* = this._page * this.boxList.length;
         _loc2_ = 0;
         while(_loc2_ < this.boxList.length)
         {
            this.boxList[_loc2_].visible = _loc4_ + _loc2_ in _loc3_;
            if(this.boxList[_loc2_].visible)
            {
               this.boxList[_loc2_].related = _loc3_[_loc4_ + _loc2_];
            }
            if(_loc2_ in this.controlList)
            {
               if(this.boxList[_loc2_].visible)
               {
                  if((_loc7_ = (_loc6_ = _loc3_[_loc4_ + _loc2_]).workTime).workStart == 9 && _loc7_.workEnd == 19)
                  {
                     this.controlList[_loc2_].currentWorkTime.text = "DAY";
                  }
                  else if(_loc7_.workStart == 19 && _loc7_.workEnd == 5)
                  {
                     this.controlList[_loc2_].currentWorkTime.text = "NIGHT";
                  }
                  else if(_loc7_.workStart == 9 && _loc7_.workEnd == 5)
                  {
                     this.controlList[_loc2_].currentWorkTime.text = "BOTH";
                  }
                  else
                  {
                     this.controlList[_loc2_].currentWorkTime.text = "???";
                  }
                  if((_loc8_ = _loc6_.workFloor) == null)
                  {
                     this.controlList[_loc2_].currentWorkFloor.text = "ALL";
                  }
                  else if((_loc9_ = _loc6_.world.floorList.indexOf(_loc8_)) == 0)
                  {
                     this.controlList[_loc2_].currentWorkFloor.text = "GROUND";
                  }
                  else
                  {
                     this.controlList[_loc2_].currentWorkFloor.text = Utility.numberToOrdinal(_loc9_) + " FL";
                  }
               }
               this.controlList[_loc2_].visible = this.boxList[_loc2_].visible;
            }
            _loc2_++;
         }
      }
      
      public function set staffList(param1:Object) : void
      {
         this._staffList = param1;
      }
      
      public function get staffList() : Object
      {
         return this._staffList;
      }
   }
}
