package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.constant.BuildingData;
   import Instance.constant.ColorCode;
   import Instance.events.CommandEvent;
   import Instance.events.SliderBarEvent;
   import Instance.gameplay.World;
   import Instance.modules.Utility;
   import Instance.property.Statistic;
   import Instance.property.StatisticItem;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import greensock.TweenLite;
   
   public class UI_Statistic extends SEMovieClip
   {
       
      
      public var totalEarning:TextField;
      
      public var scrollBar:StatisticSlideBar;
      
      public var btnClose:SimpleButton;
      
      public var expenditureList:TextField;
      
      public var maskAreaRevenue:MovieClip;
      
      public var profitList:TextField;
      
      public var autoShowCheckBox:CheckBox;
      
      public var maskAreaExpenditure:MovieClip;
      
      public var visitorList:TextField;
      
      public var maskAreaEarning:MovieClip;
      
      public var maskAreaVisitor:MovieClip;
      
      public var revenueList:TextField;
      
      public var descriptionList:TextField;
      
      public var maskAreaDescription:MovieClip;
      
      var _statistic:Statistic;
      
      var _world:World;
      
      var _autoCloseTimer:int;
      
      public function UI_Statistic()
      {
         super();
         this.descriptionList.autoSize = TextFieldAutoSize.LEFT;
         this.visitorList.autoSize = TextFieldAutoSize.CENTER;
         this.revenueList.autoSize = TextFieldAutoSize.RIGHT;
         this.expenditureList.autoSize = TextFieldAutoSize.RIGHT;
         this.profitList.autoSize = TextFieldAutoSize.RIGHT;
         this.scrollBar.slideMode = this.scrollBar.VERTICAL;
         this.__setProp_autoShowCheckBox_UIbudget_Layer3_0();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,Event.ENTER_FRAME,this.countdownToVanish);
         addListenerOf(this.btnClose,MouseEvent.CLICK,this.btnMouseOnClick);
         addListenerOf(this.scrollBar,SliderBarEvent.CHANGE_POSITION,this.scrollPage);
      }
      
      override protected function Removed(param1:Event) : void
      {
         super.Removed(param1);
         this._autoCloseTimer = -1;
      }
      
      function scrollPage(param1:SliderBarEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(this.descriptionList.height > this.maskAreaDescription.height)
         {
            _loc3_ = this.descriptionList.height - this.maskAreaDescription.height;
            this.descriptionList.y = this.maskAreaDescription.y - _loc3_ * _loc2_.getPosition();
            this.visitorList.y = this.descriptionList.y;
            this.revenueList.y = this.descriptionList.y;
            this.expenditureList.y = this.descriptionList.y;
            this.profitList.y = this.descriptionList.y;
         }
         else
         {
            this.descriptionList.y = this.maskAreaDescription.y;
            this.visitorList.y = this.descriptionList.y;
            this.revenueList.y = this.descriptionList.y;
            this.expenditureList.y = this.descriptionList.y;
            this.profitList.y = this.descriptionList.y;
         }
      }
      
      function countdownToVanish(param1:Event) : void
      {
         if(this._autoCloseTimer > 0)
         {
            --this._autoCloseTimer;
         }
         else if(this._autoCloseTimer == 0)
         {
            if(this.parent != null)
            {
               TweenLite.to(this,0.5,{
                  "scaleX":0,
                  "scaleY":0,
                  "alpha":0,
                  "onComplete":this.parent.removeChild,
                  "onCompleteParams":[this]
               });
            }
            this._autoCloseTimer = -1;
         }
      }
      
      function btnMouseOnClick(param1:MouseEvent) : void
      {
         this._autoCloseTimer = -1;
         dispatchEvent(new CommandEvent(CommandEvent.PANEL_NEED_TO_CLOSE));
      }
      
      public function updateShown() : void
      {
         var descriptionText:* = undefined;
         var visitorText:* = undefined;
         var revenueText:* = undefined;
         var expenditureText:* = undefined;
         var profitText:* = undefined;
         var boothStatArr:* = undefined;
         var destroyedBoothStatArr:* = undefined;
         var i:* = undefined;
         var boothToShown:* = undefined;
         var toCheckBuild:* = undefined;
         var toCheckStaff:* = undefined;
         var staffSalariesCheck:* = undefined;
         var arr:* = undefined;
         var totalProfit:* = undefined;
         var temp:* = undefined;
         var theBuild:* = undefined;
         var buildingType:* = undefined;
         var index:* = undefined;
         var tStatistic:* = undefined;
         var pastStatistic:* = undefined;
         var ii:* = undefined;
         var shownBooth:* = undefined;
         var checkStat:* = undefined;
         var vNum:* = undefined;
         var rNum:* = undefined;
         var eNum:* = undefined;
         if(this._world != null)
         {
            var addTextForBudget:Function = function(param1:* = "", param2:* = "", param3:* = "", param4:* = "", param5:* = ""):void
            {
               descriptionText += param1;
               visitorText += param2;
               revenueText += param3;
               expenditureText += param4;
               profitText += param5;
            };
            var addSpaceForBudget:Function = function():void
            {
               addTextForBudget("\n","\n","\n","\n","\n");
            };
            var addBudgetList:Function = function(param1:* = "", param2:* = 0, param3:* = 0, param4:* = 0):void
            {
               var _loc5_:* = param1;
               var _loc6_:* = param2 < 0 ? "-" : "" + param2 + "";
               var _loc7_:* = param3 < 0 ? "-" : "" + Utility.numberToMoney(param3) + " G";
               var _loc8_:* = param4 < 0 ? "-" : "" + Utility.numberToMoney(param4) + " G";
               if(param3 > 0)
               {
                  _loc7_ = "<font color=\'#0000FF\'>" + _loc7_ + "</font>";
               }
               if(param4 > 0)
               {
                  _loc8_ = "<font color=\'#FF0000\'>" + _loc8_ + "</font>";
               }
               var _loc9_:* = Math.max(param3,0) - Math.max(param4,0);
               var _loc10_:* = "" + Utility.numberToMoney(_loc9_) + " G";
               if(_loc9_ > 0)
               {
                  _loc10_ = "<font color=\'#0000FF\'>" + _loc10_ + "</font>";
               }
               else if(_loc9_ < 0)
               {
                  _loc10_ = "<font color=\'#FF0000\'>" + _loc10_ + "</font>";
               }
               addTextForBudget(_loc5_,_loc6_,_loc7_,_loc8_,_loc10_);
            };
            descriptionText = "";
            visitorText = "";
            revenueText = "";
            expenditureText = "";
            profitText = "";
            addTextForBudget("Booths");
            boothStatArr = new Array();
            destroyedBoothStatArr = new Array();
            i = 0;
            while(i < this.statistic.boothStatistic.length)
            {
               temp = this.statistic.boothStatistic[i];
               theBuild = temp.relation;
               buildingType = BuildingData.returnClassTo(Utility.getClass(theBuild));
               if(this._world.boothList.indexOf(theBuild) >= 0 || this._world.innList.indexOf(theBuild) >= 0)
               {
                  index = Math.max(this._world.boothListByType[buildingType].indexOf(theBuild),this._world.innList.indexOf(theBuild));
                  tStatistic = new StatisticItem();
                  tStatistic.relation = buildingType + " #" + (index + 1);
                  tStatistic.numberVisitor = temp.numberVisitor;
                  tStatistic.revenue = temp.revenue;
                  tStatistic.expenditure = temp.expenditure;
                  boothStatArr.push(tStatistic);
               }
               else
               {
                  pastStatistic = null;
                  ii = 0;
                  while(ii < destroyedBoothStatArr.length)
                  {
                     if(destroyedBoothStatArr[ii].relation == buildingType + " (x)")
                     {
                        pastStatistic = destroyedBoothStatArr[ii];
                        break;
                     }
                     ii++;
                  }
                  if(pastStatistic == null)
                  {
                     pastStatistic = new StatisticItem();
                     pastStatistic.relation = buildingType + " (x)";
                     pastStatistic.numberVisitor = 0;
                     pastStatistic.revenue = 0;
                     pastStatistic.expenditure = 0;
                     destroyedBoothStatArr.push(pastStatistic);
                  }
                  pastStatistic.numberVisitor += temp.numberVisitor;
                  pastStatistic.revenue += temp.revenue;
                  pastStatistic.expenditure += temp.expenditure;
               }
               i++;
            }
            boothStatArr.sortOn("relation");
            destroyedBoothStatArr.sortOn("relation");
            boothToShown = boothStatArr.concat(destroyedBoothStatArr);
            i = 0;
            while(i < boothToShown.length)
            {
               shownBooth = boothToShown[i];
               addSpaceForBudget();
               addBudgetList("  " + shownBooth.relation,shownBooth.numberVisitor,shownBooth.revenue,-1);
               i++;
            }
            toCheckBuild = [this.statistic.buildBuildingStat,this.statistic.upgradeBuildingStat,this.statistic.buildingRelocationStat];
            toCheckStaff = [this.statistic.hireStaffStat,this.statistic.promotionStaffStat,this.statistic.serveranceStaffStat,this.statistic.staffSallaries];
            staffSalariesCheck = [this.statistic.staffSallaries.janitor,this.statistic.staffSallaries.handyman,this.statistic.staffSallaries.entertainer,this.statistic.staffSallaries.guard];
            arr = toCheckBuild.concat(toCheckStaff.concat(staffSalariesCheck));
            arr.push(this._statistic.extraUpgradeStat);
            arr.push(this._statistic.miscStat);
            i = 0;
            while(i < arr.length)
            {
               checkStat = arr[i];
               if(toCheckBuild.indexOf(checkStat) == 0 || toCheckStaff.indexOf(checkStat) == 0 || checkStat == this.statistic.extraUpgradeStat || checkStat == this.statistic.miscStat)
               {
                  addSpaceForBudget();
               }
               if(checkStat is StatisticItem)
               {
                  if(checkStat.relation != null)
                  {
                     addSpaceForBudget();
                     vNum = !!checkStat.showVisitor ? checkStat.numberVisitor : -1;
                     rNum = !!checkStat.showRevenue ? checkStat.revenue : -1;
                     eNum = !!checkStat.showExpenditure ? checkStat.expenditure : -1;
                     if(staffSalariesCheck.indexOf(checkStat) < 0)
                     {
                        addBudgetList(checkStat.relation,vNum,rNum,eNum);
                     }
                     else
                     {
                        addBudgetList("  " + checkStat.relation,vNum,rNum,eNum);
                     }
                  }
               }
               else
               {
                  addSpaceForBudget();
                  addTextForBudget("Staff Sallaries");
               }
               i++;
            }
            this.descriptionList.text = descriptionText;
            this.visitorList.text = visitorText;
            this.revenueList.htmlText = revenueText;
            this.expenditureList.htmlText = expenditureText;
            this.profitList.htmlText = profitText;
            totalProfit = this._statistic.totalProfit;
            this.totalEarning.text = Utility.numberToMoney(totalProfit) + " G";
            if(totalProfit > 0)
            {
               this.totalEarning.textColor = ColorCode.VALID_CASH;
            }
            else
            {
               this.totalEarning.textColor = ColorCode.MINUS_CASH;
            }
            this.updateScrollBar();
         }
      }
      
      function updateScrollBar() : void
      {
         this.scrollBar.setPosition(0);
         this.descriptionList.y = this.maskAreaDescription.y;
         this.visitorList.y = this.descriptionList.y;
         this.revenueList.y = this.descriptionList.y;
         this.expenditureList.y = this.descriptionList.y;
         this.profitList.y = this.descriptionList.y;
         this.scrollBar.enabled = this.descriptionList.height > this.maskAreaDescription.height;
         this.scrollBar.slideIndicator.visible = this.scrollBar.enabled;
         this.scrollBar.slideArea.visible = this.scrollBar.enabled;
         if(this.scrollBar.enabled)
         {
            this.scrollBar.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         else
         {
            this.scrollBar.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
         }
      }
      
      public function set statistic(param1:Statistic) : void
      {
         this._statistic = param1;
         this.updateShown();
      }
      
      public function get statistic() : Statistic
      {
         return this._statistic;
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function set autoSizeTimer(param1:int) : void
      {
         this._autoCloseTimer = param1;
      }
      
      public function get autoSizeTimer() : int
      {
         return this._autoCloseTimer;
      }
      
      function __setProp_autoShowCheckBox_UIbudget_Layer3_0() : *
      {
         try
         {
            this.autoShowCheckBox["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.autoShowCheckBox.enabled = true;
         this.autoShowCheckBox.isActive = true;
         try
         {
            this.autoShowCheckBox["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
