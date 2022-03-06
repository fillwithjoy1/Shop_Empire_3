package Instance.property
{
   import Instance.constant.BuildingData;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.gameplay.Shopkeeper;
   import Instance.modules.Utility;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class Booth extends Building
   {
       
      
      var _shopkeeperList:Array;
      
      var _shopkeeperAbsense:Array;
      
      var _employeeClipList:Array;
      
      var _employeeInPosition:Array;
      
      var _serviceSpotList:Array;
      
      var _visitorInService:Array;
      
      var _spotList:Array;
      
      var _visitorInSpot:Array;
      
      var _serviceTimeList:Array;
      
      var _openPropList:Array;
      
      var _closePropList:Array;
      
      var _visitorList:Array;
      
      var body:MovieClip;
      
      var _open:Boolean;
      
      var _priceList:Array;
      
      var _employeeContainer:MovieClip;
      
      var _entryVisitor:Array;
      
      var _onEntry:Array;
      
      var _fictionalBuilding;
      
      var pastFictionalBuilding;
      
      public function Booth()
      {
         super();
         this._shopkeeperList = new Array();
         this._shopkeeperAbsense = new Array();
         this._employeeClipList = new Array();
         this._employeeInPosition = new Array();
         this._serviceSpotList = new Array();
         this._visitorInService = new Array();
         this._spotList = new Array();
         this._visitorInSpot = new Array();
         this._serviceTimeList = new Array();
         this._openPropList = new Array();
         this._closePropList = new Array();
         this._visitorList = new Array();
         this._entryVisitor = new Array();
         this._onEntry = new Array();
         var _loc1_:* = BuildingData.getPriceList(BuildingData.returnClassTo(Utility.getClass(this)));
         if(_loc1_ != null)
         {
            this._priceList = _loc1_.concat();
         }
         _brokenClip = this.width <= 96 ? new BrokenSmall() : (this.width <= 204 ? new BrokenMedium() : new BrokenLarge());
         _brokenClip.mouseEnabled = false;
         _brokenClip.mouseChildren = false;
         _brokenClip.y = -this.height / 2;
         _buildingBaseHP = this.width <= 96 ? 150 : (this.width <= 204 ? 250 : 400);
         _buildingIncrementHP = this.width <= 96 ? 50 : (this.width <= 204 ? 75 : 100);
         _buildingMaxHP = _buildingBaseHP + _buildingIncrementHP * (_level - 1);
         _buildingHP = _buildingMaxHP;
      }
      
      function createEmployeeList() : void
      {
         var _loc1_:* = undefined;
         if(this.body != null)
         {
            _loc1_ = 0;
            while(this.body.getChildByName("emp" + _loc1_))
            {
               if(_loc1_ in this._employeeClipList)
               {
                  this._employeeClipList[_loc1_] = this.body.getChildByName("emp" + _loc1_);
               }
               else
               {
                  this._employeeClipList.push(this.body.getChildByName("emp" + _loc1_));
                  this._employeeInPosition.push(false);
               }
               _loc1_++;
            }
         }
      }
      
      function createOpenCloseObject() : void
      {
         var _loc1_:* = undefined;
         if(this.body != null)
         {
            _loc1_ = 0;
            while(this.body.getChildByName("openProp" + _loc1_))
            {
               if(_loc1_ in this._openPropList)
               {
                  this._openPropList[_loc1_] = this.body.getChildByName("openProp" + _loc1_);
               }
               else
               {
                  this._openPropList.push(this.body.getChildByName("openProp" + _loc1_));
               }
               _loc1_++;
            }
            while(_loc1_ < this._openPropList.length)
            {
               this._openPropList.pop();
            }
            _loc1_ = 0;
            while(this.body.getChildByName("closeProp" + _loc1_))
            {
               if(_loc1_ in this._closePropList)
               {
                  this._closePropList[_loc1_] = this.body.getChildByName("closeProp" + _loc1_);
               }
               else
               {
                  this._closePropList.push(this.body.getChildByName("closeProp" + _loc1_));
               }
               _loc1_++;
            }
            while(_loc1_ < this._closePropList.length)
            {
               this._closePropList.pop();
            }
         }
      }
      
      function createServiceSpot() : void
      {
         var _loc1_:* = undefined;
         if(this.body != null)
         {
            _loc1_ = 0;
            while(this.body.getChildByName("serviceSpot" + _loc1_))
            {
               if(_loc1_ in this._serviceSpotList)
               {
                  this._serviceSpotList[_loc1_] = this.body.getChildByName("serviceSpot" + _loc1_);
               }
               else
               {
                  this._serviceSpotList.push(this.body.getChildByName("serviceSpot" + _loc1_));
                  this._visitorInService.push(null);
                  this._serviceTimeList.push(-1);
               }
               _loc1_++;
            }
            _loc1_ = 0;
            while(this.body.getChildByName("spot" + _loc1_))
            {
               if(_loc1_ in this._spotList)
               {
                  this._spotList[_loc1_] = this.body.getChildByName("spot" + _loc1_);
               }
               else
               {
                  this._spotList.push(this.body.getChildByName("spot" + _loc1_));
                  this._visitorInSpot.push(null);
               }
               _loc1_++;
            }
         }
      }
      
      function createHumanContainer() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.body != null)
         {
            _loc1_ = this.body.getChildByName("insideClip");
            if(_loc1_ != null)
            {
               _insideRegion = _loc1_;
               _loc3_ = this.body.getChildIndex(_loc1_);
               _humanContainer.visible = _loc1_.blendMode == BlendMode.NORMAL;
               this.body.addChildAt(_humanContainer,_loc3_ + 1);
               _loc1_.visible = false;
            }
            _loc2_ = this.body.getChildByName("employeeClip");
            if(_loc2_ != null)
            {
               _loc3_ = this.body.getChildIndex(_loc2_);
               if(this._employeeContainer == null)
               {
                  this._employeeContainer = new MovieClip();
               }
               this._employeeContainer.visible = _loc2_.blendMode == BlendMode.NORMAL;
               this.body.addChildAt(this._employeeContainer,_loc3_);
               _loc2_.visible = false;
            }
            else if(this._employeeContainer != null)
            {
               if(this.body.getChildByName(this._employeeContainer.name))
               {
                  this.body.removeChild(this._employeeContainer);
               }
               this._employeeContainer = null;
            }
         }
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc2_:* = undefined;
         super.Initialize(param1);
         this.body = getChildAt(0) as MovieClip;
         this.createEmployeeList();
         this.createOpenCloseObject();
         this.createServiceSpot();
         this.createHumanContainer();
         _enteranceRange = BuildingData.getEnteranceRange(this);
         if(this._shopkeeperList.length == 0)
         {
            this._open = true;
         }
         if(!this._open)
         {
            _loc2_ = 0;
            while(_loc2_ < this._employeeInPosition.length)
            {
               this._employeeInPosition[_loc2_] = false;
               _loc2_++;
            }
         }
         this.checkEmployeeList();
         this.checkOpenCloseObject();
         this.checkServiceSpotList();
         this.fictionalBuildingCheck();
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.serviceCheckTime);
      }
      
      override public function loadCondition(param1:*) : void
      {
         super.loadCondition(param1);
         this.fictionalBuildingCheck();
      }
      
      function fictionalBuildingCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.body != null)
         {
            _loc1_ = this.body.getChildByName("fictionalBuilding");
            if(_loc1_ != null)
            {
               _loc1_.related = this;
               this._fictionalBuilding = _loc1_;
            }
            else
            {
               this._fictionalBuilding = null;
            }
         }
         if(this.pastFictionalBuilding != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.pastFictionalBuilding.humanContainer.numChildren)
            {
               _loc3_ = this.pastFictionalBuilding.humanContainer.getChildAt(_loc2_);
               if(this._fictionalBuilding != null)
               {
                  this._fictionalBuilding.humanList.push(_loc3_);
                  this._fictionalBuilding.humanContainer.addChild(_loc3_);
                  _loc3_.dispatchEvent(new HumanEvent(HumanEvent.CHANGE_INSIDE,this._fictionalBuilding));
               }
               else
               {
                  _humanContainer.addChild(_loc3_);
                  _loc3_.dispatchEvent(new HumanEvent(HumanEvent.CHANGE_INSIDE,this));
               }
               _loc2_++;
            }
         }
      }
      
      function checkEmployeeList() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this._employeeClipList.length)
         {
            if(_loc1_ in this._employeeInPosition)
            {
               this._employeeClipList[_loc1_].visible = this._employeeInPosition[_loc1_];
            }
            _loc1_++;
         }
         var _loc2_:* = this.body.getChildByName("cashierPosition");
         if(_loc2_ != null)
         {
            _loc2_.visible = false;
         }
      }
      
      function checkOpenCloseObject() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this._openPropList.length)
         {
            this._openPropList[_loc1_].visible = this._open;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._closePropList.length)
         {
            this._closePropList[_loc1_].visible = !this._open;
            _loc1_++;
         }
      }
      
      function checkServiceSpotList() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._serviceSpotList.length)
         {
            if(_loc1_ in this._visitorInService)
            {
               _loc2_ = this._visitorInService[_loc1_];
               this._serviceSpotList[_loc1_].visible = _loc2_ != null;
               if(_loc2_ != null)
               {
                  this._serviceSpotList[_loc1_].gotoAndStop(_loc2_.model);
               }
            }
            _loc1_++;
         }
         this.checkWatchSpot();
      }
      
      function checkWatchSpot() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._spotList.length)
         {
            if(_loc1_ in this._visitorInSpot)
            {
               _loc2_ = this._visitorInSpot[_loc1_];
               this._spotList[_loc1_].visible = _loc2_ != null;
               if(_loc2_ != null)
               {
                  this._spotList[_loc1_].gotoAndStop(_loc2_.model);
               }
            }
            _loc1_++;
         }
      }
      
      override function beforeUpgradeCheck() : void
      {
         this.pastFictionalBuilding = this._fictionalBuilding;
      }
      
      override function afterUpgradeCheck() : void
      {
         super.afterUpgradeCheck();
         this.body = getChildAt(0) as MovieClip;
         this.createEmployeeList();
         this.createOpenCloseObject();
         this.createServiceSpot();
         this.createHumanContainer();
         this.generateShopkeeper();
         this.checkEmployeeList();
         this.checkOpenCloseObject();
         this.checkServiceSpotList();
         this.fictionalBuildingCheck();
         var _loc1_:* = _buildingHP / _buildingMaxHP;
         _buildingMaxHP = _buildingBaseHP + _buildingIncrementHP * (_level - 1);
         _buildingHP = Math.max(_loc1_ * _buildingMaxHP);
      }
      
      override function buildingOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.BOOTH_ON_SELECT));
      }
      
      override public function addPerson(param1:*, param2:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         super.addPerson(param1);
         if(!param2)
         {
            _loc3_ = _humanContainer.globalToLocal(param1.localToGlobal(new Point(0,0)));
            _loc4_ = _humanContainer.globalToLocal(param1.localToGlobal(new Point(1,0)));
            param1.x = _loc3_.x;
            param1.y = _loc3_.y;
            if(_loc4_.x > _loc3_.x)
            {
               param1.scaleX = 1;
            }
            else
            {
               param1.scaleX = -1;
            }
         }
         if(param1 is Shopkeeper)
         {
            if(this._employeeContainer != null)
            {
               this._employeeContainer.addChild(param1);
            }
            else
            {
               _humanContainer.addChild(param1);
            }
         }
         else
         {
            _humanContainer.addChild(param1);
         }
         if(_world.currentVisitorList.indexOf(param1) >= 0)
         {
            this._visitorList.push(param1);
         }
      }
      
      override public function removePerson(param1:*) : void
      {
         super.removePerson(param1);
         var _loc2_:* = this._visitorList.indexOf(param1);
         if(_loc2_ in this._visitorList)
         {
            this._visitorList.splice(_loc2_,1);
         }
      }
      
      public function generateShopkeeper() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = BuildingData.getShopkeeperOf(BuildingData.returnClassTo(Utility.getClass(this)));
         if(_loc1_ != null)
         {
            if(_level - 1 in _loc1_)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_[_level - 1].length)
               {
                  _loc3_ = new Shopkeeper();
                  _loc3_.y = 0;
                  if(_loc3_.baseHome < 0)
                  {
                     _loc3_.x = _world.mostLeft - 15;
                  }
                  else if(_loc3_.baseHome > 0)
                  {
                     _loc3_.x = _world.mostRight + 15;
                  }
                  _loc3_.currentAnimation = "idle";
                  _loc3_.world = _world;
                  _loc3_.model = _loc1_[_level - 1][_loc2_];
                  _loc3_.boothInAction = this;
                  this._shopkeeperList.push(_loc3_);
                  _world.addHuman(_loc3_);
                  _loc2_++;
               }
            }
         }
      }
      
      function serviceCheckTime(param1:GameEvent) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this._serviceTimeList.length)
         {
            if(_loc2_ in this._visitorInService)
            {
               if(_loc2_ in this._employeeInPosition)
               {
                  if(this._employeeInPosition[_loc2_])
                  {
                     if(this._visitorInService[_loc2_] != null)
                     {
                        if(Math.abs(this._visitorInService[_loc2_].x - this._serviceSpotList[_loc2_].x) == 0)
                        {
                           if(this._serviceSpotList[_loc2_].visible)
                           {
                              if(this._serviceTimeList[_loc2_] > 0)
                              {
                                 --this._serviceTimeList[_loc2_];
                              }
                              else if(this._serviceTimeList[_loc2_] < 0)
                              {
                                 this._serviceTimeList[_loc2_] = BuildingData.getServiceTime(this);
                              }
                           }
                        }
                     }
                     else
                     {
                        this._serviceTimeList[_loc2_] = -1;
                     }
                  }
               }
            }
            _loc2_++;
         }
      }
      
      public function set open(param1:Boolean) : void
      {
         this._open = param1;
         this.checkOpenCloseObject();
      }
      
      public function get open() : Boolean
      {
         return this._open;
      }
      
      public function get shopkeeperList() : Array
      {
         return this._shopkeeperList;
      }
      
      public function get shopkeeperAbsense() : Array
      {
         return this._shopkeeperAbsense;
      }
      
      public function get employeeClipList() : Array
      {
         return this._employeeClipList;
      }
      
      public function get employeeInPosition() : Array
      {
         return this._employeeInPosition;
      }
      
      public function get priceList() : Array
      {
         return this._priceList;
      }
      
      public function get serviceSpotList() : Array
      {
         return this._serviceSpotList;
      }
      
      public function get visitorInService() : Array
      {
         return this._visitorInService;
      }
      
      public function get serviceTimeList() : Array
      {
         return this._serviceTimeList;
      }
      
      public function get spotList() : Array
      {
         return this._spotList;
      }
      
      public function get visitorInSpot() : Array
      {
         return this._visitorInSpot;
      }
      
      public function get visitorList() : Array
      {
         return this._visitorList;
      }
      
      public function overload(param1:*) : Boolean
      {
         return this._visitorList.indexOf(param1) >= _capacity;
      }
      
      public function get isFull() : Boolean
      {
         return this._visitorList.length >= _capacity;
      }
      
      public function get brokenClip() : *
      {
         return _brokenClip;
      }
      
      public function get sizeModifier() : int
      {
         if(_brokenClip != null)
         {
            if(_brokenClip is BrokenSmall)
            {
               return 3;
            }
            if(_brokenClip is BrokenMedium)
            {
               return 2;
            }
            return 1;
         }
         return 0;
      }
      
      public function get employeeContainer() : MovieClip
      {
         return this._employeeContainer;
      }
      
      public function get entryVisitor() : Array
      {
         return this._entryVisitor;
      }
      
      public function get onEntry() : Array
      {
         return this._onEntry;
      }
      
      public function get cashierPosition() : Point
      {
         var _loc1_:* = undefined;
         if(_world != null)
         {
            _loc1_ = this.body.getChildByName("cashierPosition");
            if(_loc1_ != null)
            {
               _loc1_.visible = false;
               return _world.mainContainer.globalToLocal(_loc1_.localToGlobal(new Point(0,0)));
            }
            return null;
         }
         return null;
      }
      
      public function get fictionalBuilding() : *
      {
         return this._fictionalBuilding;
      }
      
      override public function get numberPeople() : int
      {
         return this._visitorList.length;
      }
   }
}
