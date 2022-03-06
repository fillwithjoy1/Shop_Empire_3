package Instance.ui
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.gameplay.World;
   import Instance.modules.Utility;
   import Instance.property.Elevator;
   import Instance.property.HalteWagon;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class UI_BoothDetail extends UI_InfoPanel
   {
       
      
      public var prevPage:SimpleButton;
      
      public var nextPage:SimpleButton;
      
      public var buildbox0:BuildingBox;
      
      public var buildbox3:BuildingBox;
      
      public var pageInfo:TextField;
      
      public var buildbox2:BuildingBox;
      
      public var deactiveTab0:MovieClip;
      
      public var deactiveTab1:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var deactiveTab2:MovieClip;
      
      public var deactiveTab3:MovieClip;
      
      public var buildbox5:BuildingBox;
      
      public var activateTab:MovieClip;
      
      public var buildbox4:BuildingBox;
      
      public var orderByCombo:OrderByCombobox;
      
      public var buildbox1:BuildingBox;
      
      public var deactiveTab4:MovieClip;
      
      const FRAME_BUILD = [BuildingData.GENERAL,BuildingData.FOOD,BuildingData.INN,BuildingData.ENTERTAINMENT,BuildingData.FACILITY];
      
      var boxList:Array;
      
      var _world:World;
      
      var _page:int;
      
      public function UI_BoothDetail()
      {
         var _loc2_:* = undefined;
         super();
         this.boxList = new Array();
         var _loc1_:* = 0;
         while(getChildByName("buildbox" + _loc1_))
         {
            _loc2_ = getChildByName("buildbox" + _loc1_);
            this.boxList.push(_loc2_);
            _loc1_++;
         }
         this.orderByCombo.addItem("First Build");
         this.orderByCombo.addItem("Latest");
         this.orderByCombo.addItem("Type");
         this.orderByCombo.addItem("Upg Cost");
         this.orderByCombo.addItem("Level");
         this.orderByCombo.addItem("Experience");
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this._world,GameEvent.BUILDING_DESTROYED,this.updateBuildingInfo);
         addListenerOf(this.prevPage,MouseEvent.CLICK,this.changePage);
         addListenerOf(this.nextPage,MouseEvent.CLICK,this.changePage);
      }
      
      function updateBuildingInfo(param1:GameEvent) : void
      {
         this.checkActiveTab();
      }
      
      function changePage(param1:MouseEvent) : void
      {
         var _loc2_:* = this.FRAME_BUILD[_activeTab];
         var _loc3_:Array = this.getShownBuilding(_loc2_);
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
      
      function sortByType(param1:Array) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < param1.length - 1)
         {
            _loc3_ = _loc2_;
            while(_loc3_ < param1.length)
            {
               _loc4_ = BuildingData.BUILDING_LIST.indexOf(BuildingData.returnClassTo(Utility.getClass(param1[_loc2_])));
               _loc5_ = BuildingData.BUILDING_LIST.indexOf(BuildingData.returnClassTo(Utility.getClass(param1[_loc3_])));
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
      
      function sortMode(param1:Array) : void
      {
         var _loc2_:* = this.orderByCombo.comboItem[_selectedOrder];
         switch(_loc2_.toLowerCase())
         {
            case "first building":
               break;
            case "latest":
               param1.reverse();
               break;
            case "type":
               this.sortByType(param1);
               break;
            case "upg cost":
               param1.sortOn("upgradeCost",Array.NUMERIC);
               break;
            case "level":
               param1.sortOn(["level","expPercentage"],[Array.NUMERIC,Array.NUMERIC | Array.DESCENDING]);
               break;
            case "experience":
               param1.sortOn(["expPercentage","level"],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC]);
         }
      }
      
      function getShownBuilding(param1:*) : Array
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < this._world.onInfoBuildingList.length)
         {
            _loc4_ = this._world.onInfoBuildingList[_loc3_];
            if((_loc5_ = BuildingData.getCategoryOf(BuildingData.returnClassTo(Utility.getClass(_loc4_)))) == param1)
            {
               _loc2_.push(_loc4_);
            }
            else if(param1 == BuildingData.FACILITY)
            {
               if(_loc4_ is Elevator || _loc4_ is HalteWagon)
               {
                  _loc2_.push(_loc4_);
               }
            }
            _loc3_++;
         }
         this.sortMode(_loc2_);
         return _loc2_;
      }
      
      override function checkActiveTab() : void
      {
         super.checkActiveTab();
         var _loc1_:* = this.FRAME_BUILD[_activeTab];
         var _loc2_:Array = this.getShownBuilding(_loc1_);
         var _loc3_:* = Math.max(1,Math.ceil(_loc2_.length / this.boxList.length));
         if(this._page >= _loc3_)
         {
            this._page = _loc3_ - 1;
         }
         this.pageInfo.text = "" + (this._page + 1) + "/" + _loc3_;
         var _loc4_:* = this._page * this.boxList.length;
         var _loc5_:* = 0;
         while(_loc5_ < this.boxList.length)
         {
            this.boxList[_loc5_].visible = _loc4_ + _loc5_ in _loc2_;
            if(this.boxList[_loc5_].visible)
            {
               this.boxList[_loc5_].related = _loc2_[_loc4_ + _loc5_];
            }
            _loc5_++;
         }
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
   }
}
