package Instance.ui
{
   import Instance.Gameplay;
   import Instance.SEMovieClip;
   import Instance.events.ComboEvent;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import greensock.TweenLite;
   
   public class UI_Hire extends SEMovieClip
   {
       
      
      public var prevPage:SimpleButton;
      
      public var nextPage:SimpleButton;
      
      public var hireTab2:HireTab;
      
      public var hireTab3:HireTab;
      
      public var btnClose:SimpleButton;
      
      public var hireTab0:HireTab;
      
      public var noApplicantMessage:MovieClip;
      
      public var hireTab1:HireTab;
      
      public var orderByCombo:OrderByCombobox;
      
      public var pageIndicator:TextField;
      
      public const REFRESH_COST = 2500;
      
      var _hireTabList:Array;
      
      var _jobdesk:String;
      
      var _applicants:Array;
      
      var _page:int;
      
      var _selectedOrder:int;
      
      var _main:Gameplay;
      
      public function UI_Hire()
      {
         super();
         this._hireTabList = new Array();
         this._hireTabList.push(this.hireTab0);
         this._hireTabList.push(this.hireTab1);
         this._hireTabList.push(this.hireTab2);
         this._hireTabList.push(this.hireTab3);
         this._page = 0;
         var _loc1_:* = this.noApplicantMessage.messageInfo.text;
         this.noApplicantMessage.messageInfo.htmlText = _loc1_.replace(/&cost/g,"<font color=\'#FF3300\'>" + this.REFRESH_COST + " G</font>");
         this.orderByCombo.addItem("Oldest");
         this.orderByCombo.addItem("Newest");
         this.orderByCombo.addItem("Name");
         this.orderByCombo.addItem("Cost");
         this.orderByCombo.addItem("Average");
         this.orderByCombo.addItem("Stamina");
         this.orderByCombo.addItem("Hygine");
         this.orderByCombo.addItem("Fun");
         this.orderByCombo.addItem("Sight");
         this.orderByCombo.addItem("Speed");
         this._selectedOrder = 0;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         super.Initialize(param1);
         visible = true;
         this.orderByCombo.text = this.orderByCombo.comboItem[this._selectedOrder];
         var _loc2_:* = 0;
         while(_loc2_ < this._hireTabList.length)
         {
            _loc3_ = this._hireTabList[_loc2_];
            _loc3_.workTimeCombo.text = _loc3_.workTimeCombo.comboItem[0];
            addListenerOf(_loc3_,ComboEvent.ON_SHOW_ITEM,this.jobListShown);
            addListenerOf(_loc3_,CommandEvent.ON_HIRE,this.checkHireProgress);
            _loc2_++;
         }
         addListenerOf(stage,GameEvent.NEW_APPLICANT,this.confirmNewApplicant);
         addListenerOf(stage,GameEvent.LOST_APPLICANT,this.removeApplicant);
         addListenerOf(this,CommandEvent.BEGIN_HIRE,this.hideCauseHire);
         addListenerOf(this.noApplicantMessage.btnRefreshApplicant,MouseEvent.CLICK,this.refreshApplicant);
         addListenerOf(this.nextPage,MouseEvent.CLICK,this.changePage);
         addListenerOf(this.prevPage,MouseEvent.CLICK,this.changePage);
         addListenerOf(this.orderByCombo,ComboEvent.ON_CHANGE,this.changeOrderMode);
         if(this._applicants.length > 0)
         {
            (_loc4_ = this.noApplicantMessage.btnRefreshApplicant).enabled = true;
            _loc4_.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         this.updateTabIcon();
      }
      
      function changeOrderMode(param1:ComboEvent) : void
      {
         this._selectedOrder = param1.selected;
         this.updateTabIcon();
      }
      
      function confirmNewApplicant(param1:GameEvent) : void
      {
         var _loc2_:* = this.noApplicantMessage.btnRefreshApplicant;
         _loc2_.enabled = true;
         _loc2_.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         this.updateTabIcon();
      }
      
      function removeApplicant(param1:GameEvent) : void
      {
         this.updateTabIcon();
      }
      
      function sortMode(param1:Array) : void
      {
         var _loc2_:* = this.orderByCombo.comboItem[this._selectedOrder];
         switch(_loc2_.toLowerCase())
         {
            case "oldest":
               break;
            case "newest":
               param1.reverse();
               break;
            case "name":
               param1.sortOn("characterName");
               break;
            case "cost":
               this.sortCost(param1);
               break;
            case "average":
               param1.sortOn("average",Array.NUMERIC | Array.DESCENDING);
               break;
            case "stamina":
               param1.sortOn("stamina",Array.NUMERIC | Array.DESCENDING);
               break;
            case "hygine":
               param1.sortOn("hygine",Array.NUMERIC | Array.DESCENDING);
               break;
            case "fun":
               param1.sortOn("entertain",Array.NUMERIC | Array.DESCENDING);
               break;
            case "sight":
               param1.sortOn("sight",Array.NUMERIC | Array.DESCENDING);
               break;
            case "speed":
               param1.sortOn("speed",Array.NUMERIC | Array.DESCENDING);
         }
      }
      
      function getCost(param1:*) : int
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = 0;
         if(param1 != null)
         {
            _loc3_ = param1.stamina + param1.hygine + param1.entertain + param1.sight + param1.speed;
            switch(this._jobdesk)
            {
               case "janitor":
                  _loc3_ += param1.stamina * 0.4;
                  _loc3_ += param1.hygine * 1;
                  _loc3_ += param1.entertain * 0;
                  _loc3_ += param1.sight * 0.3;
                  _loc3_ += param1.speed * 0.5;
                  break;
               case "handyman":
                  _loc3_ += param1.stamina * 1.2;
                  _loc3_ += param1.hygine * 0;
                  _loc3_ += param1.entertain * 0;
                  _loc3_ += param1.sight * 0.3;
                  _loc3_ += param1.speed * 0.5;
                  break;
               case "entertainer":
                  _loc3_ += param1.stamina * 0.2;
                  _loc3_ += param1.hygine * 0;
                  _loc3_ += param1.entertain * 1.2;
                  _loc3_ += param1.sight * 0.1;
                  _loc3_ += param1.speed * 0.2;
                  break;
               case "guard":
                  _loc3_ += param1.stamina * 0.6;
                  _loc3_ += param1.hygine * 0;
                  _loc3_ += param1.entertain * 0;
                  _loc3_ += param1.sight * 0.8;
                  _loc3_ += param1.speed * 1;
            }
            _loc4_ = _loc3_ + _loc3_ * param1.hireCostDifference;
            _loc2_ = Math.round(_loc4_);
         }
         else
         {
            _loc2_ = 0;
         }
         return _loc2_;
      }
      
      function sortCost(param1:Array) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < param1.length - 1)
         {
            _loc3_ = _loc2_ + 1;
            while(_loc3_ < param1.length)
            {
               _loc4_ = this.getCost(param1[_loc2_]);
               _loc5_ = this.getCost(param1[_loc3_]);
               if(_loc4_ > _loc5_)
               {
                  _loc6_ = param1[_loc2_];
                  param1[_loc2_] = param1[_loc3_];
                  param1[_loc3_] = _loc6_;
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function updateTabIcon() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.stage != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this._hireTabList.length)
            {
               _loc4_ = this._hireTabList[_loc1_];
               if(Utility.hasLabel(_loc4_.staffSymbol,this._jobdesk.toLowerCase()))
               {
                  _loc4_.staffSymbol.gotoAndStop(this._jobdesk.toLowerCase());
               }
               else
               {
                  _loc4_.staffSymbol.gotoAndStop("unemployed");
               }
               _loc1_++;
            }
            _loc2_ = this._applicants.concat();
            this.sortMode(_loc2_);
            _loc3_ = this._page * this._hireTabList.length;
            _loc1_ = 0;
            while(_loc1_ < this._hireTabList.length)
            {
               this._hireTabList[_loc1_].visible = _loc3_ + _loc1_ in _loc2_;
               if(this._hireTabList[_loc1_].visible)
               {
                  this._hireTabList[_loc1_].statData = _loc2_[_loc3_ + _loc1_];
               }
               _loc1_++;
            }
            this.pageIndicator.text = "" + (this._page + 1) + "/" + (this.maxPage + 1) + "";
            this.noApplicantMessage.visible = this._applicants.length == 0;
         }
      }
      
      function changePage(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_ == this.nextPage)
         {
            ++this._page;
         }
         else if(_loc2_ == this.prevPage)
         {
            --this._page;
         }
         if(this._page < 0)
         {
            this._page = this.maxPage;
         }
         if(this._page > this.maxPage)
         {
            this._page = 0;
         }
         this.updateTabIcon();
      }
      
      function checkHireProgress(param1:CommandEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.BEGIN_HIRE,{
            "job":this._jobdesk,
            "stat":param1.tag.stat,
            "workTimeIndex":param1.tag.workTimeIndex,
            "cost":param1.tag.cost
         }));
      }
      
      function hideCauseHire(param1:CommandEvent) : void
      {
         var hideMe:Function = null;
         var e:CommandEvent = param1;
         hideMe = function():void
         {
            visible = false;
         };
         TweenLite.killTweensOf(this,true);
         TweenLite.to(this,0.4,{
            "scaleX":0,
            "scaleY":0,
            "alpha":0,
            "y":500,
            "onComplete":hideMe
         });
         addListenerOf(stage,GameEvent.FINISH_HIRE_PROGRESS,this.afterHire);
      }
      
      function afterHire(param1:GameEvent) : void
      {
         TweenLite.killTweensOf(this,true);
         if(this._page > this.maxPage)
         {
            this._page = this.maxPage;
         }
         this.updateTabIcon();
         visible = true;
         TweenLite.to(this,0.4,{
            "scaleX":1,
            "scaleY":1,
            "alpha":1,
            "x":350,
            "y":250
         });
         removeListenerOf(stage,GameEvent.FINISH_HIRE_PROGRESS,this.afterHire);
      }
      
      function jobListShown(param1:ComboEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = 0;
         while(_loc3_ < this._hireTabList.length)
         {
            if((_loc4_ = this._hireTabList[_loc3_]) != _loc2_)
            {
               _loc4_.workTimeCombo.hideDropDown();
            }
            _loc3_++;
         }
      }
      
      function refreshApplicant(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            if(this._main.isEnough(this.REFRESH_COST))
            {
               _loc2_.enabled = false;
               _loc2_.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
            }
            dispatchEvent(new CommandEvent(CommandEvent.REFRESH_APPLICANT));
         }
      }
      
      public function get maxPage() : int
      {
         return Math.max(0,Math.ceil(this._applicants.length / this._hireTabList.length) - 1);
      }
      
      public function set jobdesk(param1:String) : void
      {
         this._jobdesk = param1;
         this.updateTabIcon();
      }
      
      public function get jobdesk() : String
      {
         return this._jobdesk;
      }
      
      public function set applicants(param1:Array) : void
      {
         this._applicants = param1;
      }
      
      public function get applicants() : Array
      {
         return this._applicants;
      }
      
      public function set main(param1:Gameplay) : void
      {
         this._main = param1;
      }
      
      public function get main() : Gameplay
      {
         return this._main;
      }
   }
}
