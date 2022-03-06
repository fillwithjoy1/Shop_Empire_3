package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.constant.ConversationList;
   import Instance.constant.FavoriteList;
   import Instance.constant.HumanData;
   import Instance.constant.UpgradeData;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import Instance.property.Booth;
   import Instance.property.Building;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityRestRoom;
   import Instance.property.FacilityStairs;
   import Instance.property.FacilityTerrace;
   import Instance.property.FacilityTradingPost;
   import Instance.property.FictionalBuilding;
   import Instance.property.HalteWagon;
   import Instance.property.InsideRestroom;
   import Instance.property.Wagon;
   import Instance.sprite.Animation;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Visitor extends Human
   {
       
      
      var _pastDestination;
      
      var _favoriteList:Array;
      
      var _destinationTargetList:Array;
      
      var _searchDestinationCounter:int;
      
      var _waitingOpen:int;
      
      var _lastBrokenBoothList:Array;
      
      var _lastKnownFullBooth:Array;
      
      var _visitTime:int;
      
      var _visiting:Boolean;
      
      var _initMode:Boolean;
      
      var _purse:int;
      
      var _initialPurse:int;
      
      var _shopingPrice:int;
      
      var _numberItemBought:int;
      
      var _buyTreshold:int;
      
      var _staying:Boolean;
      
      var _canLeave:Boolean;
      
      var _stayingAt;
      
      var _statification:int;
      
      var entertainerOnView;
      
      var _restRoomPercentage:Number;
      
      var _dirtyDelay:int;
      
      var restRoomIncrementChance:Number;
      
      var _restRoomTarget:FacilityRestRoom;
      
      var _tradingPostTarget:FacilityTradingPost;
      
      var _gender:int;
      
      var _refundChance:Number;
      
      var _needMoney:Boolean;
      
      var _lastVisit;
      
      var _meetFriend;
      
      var _friendList:Array;
      
      var _chatComment:String;
      
      var _singleConversation;
      
      var visitTimeBefore:int;
      
      public function Visitor()
      {
         super();
         this._pastDestination = null;
         this._favoriteList = new Array();
         this._destinationTargetList = new Array();
         this._friendList = new Array();
         this._initMode = true;
         this._visitTime = 0;
         this._visiting = false;
         this._lastBrokenBoothList = new Array();
         this._lastKnownFullBooth = new Array();
         _mood = 50;
         this._shopingPrice = 0;
         this._numberItemBought = 0;
         this._buyTreshold = 0;
         this._staying = false;
         this._canLeave = true;
         this._stayingAt = null;
         this._restRoomPercentage = 0;
         this._dirtyDelay = 0;
         this._refundChance = 0;
         this._needMoney = false;
         this.entertainerOnView = null;
         this._meetFriend = null;
         this._chatComment = "";
      }
      
      override function initStat() : void
      {
         super.initStat();
         this.restRoomIncrementChance = 3 * ((100 - _stat.hygine) / 100) + 4;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(this._initMode)
         {
            this.addFriend();
            this.initPurse();
            this.initDestinationList();
            this.searchDestination();
            this._statification = _mood >= 80 ? 3 : (_mood >= 50 ? 2 : (_mood >= 20 ? 1 : 0));
            this._initMode = false;
         }
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.checkGameTime);
         addListenerOf(_world,GameEvent.BUILDING_REPAIRED,this.checkBuildingRepaired);
         addListenerOf(_world,GameEvent.BUILDING_CREATED,this.checkBuildingCreated);
         addListenerOf(_world,HumanEvent.EXIT_THE_BUILDING,this.checkSomeoneExitBuilding);
         addListenerOf(this,HumanEvent.MOOD_UPDATE,this.checkMood);
      }
      
      function setChatComment(param1:String) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         this._chatComment = param1;
         if(_inside == null || _inside is FacilityStairs)
         {
            _loc2_ = this.localToGlobal(new Point(this.x,this.y));
            if(_loc2_.x >= 20 && _loc2_.x <= 680 && _loc2_.y >= 20 && _loc2_.y <= 420)
            {
               _loc3_ = 25 * (5 / (5 + _world.conversationContainer.numChildren));
               if(this is SpecialVisitor && _destination == "home")
               {
                  _loc3_ = 100;
               }
               if(Calculate.chance(_loc3_))
               {
                  showDialogConversationBox(this._chatComment,7 + Math.round(0.2 * this._chatComment.length));
               }
            }
         }
      }
      
      function checkSomeoneExitBuilding(param1:HumanEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = param1.target;
         if(this._stayingAt == null)
         {
            if(_loc2_ != this)
            {
               _loc3_ = param1.tag;
               _loc4_ = _loc3_;
               if(_loc3_ is FictionalBuilding)
               {
                  _loc4_ = _loc3_.related;
               }
               if((_loc5_ = this._lastKnownFullBooth.indexOf(_loc4_)) in this._lastKnownFullBooth)
               {
                  if(isFinite(_loc4_.capacity))
                  {
                     if(!_loc4_.isFull)
                     {
                        this._lastKnownFullBooth.splice(_loc5_,1);
                        if(!this._staying && !this._visiting)
                        {
                           this.searchDestination();
                        }
                     }
                  }
                  else if(Calculate.chance(Math.max(100 - _loc4_.visitorList.length * 5,10)))
                  {
                     this._lastKnownFullBooth.splice(_loc5_,1);
                     if(!this._staying && !this._visiting)
                     {
                        this.searchDestination();
                     }
                  }
               }
            }
         }
      }
      
      function addFriend() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc1_:* = _world;
         if(!(this is SpecialVisitor))
         {
            _loc2_ = 0;
            _loc3_ = 50;
            while(Calculate.chance(_loc3_))
            {
               _loc2_++;
               _loc3_ -= Math.floor(Math.random() * 8) + 3;
            }
            if(_world.currentVisitorList.length > 0 && _world.currentVisitorList.length >= _loc2_)
            {
               if((_loc5_ = (_loc4_ = _world.currentVisitorList.concat()).indexOf(this)) in _loc4_)
               {
                  _loc4_.splice(_loc5_,1);
               }
               Utility.shuffle(_loc4_);
               while(_loc4_.length > 0 && this._friendList.length < _loc2_)
               {
                  _loc6_ = _loc4_.shift();
                  if(_world.specialVisitorList.indexOf(_loc6_) < 0)
                  {
                     if(_loc6_.insideMall)
                     {
                        if(this._friendList.indexOf(_loc6_) < 0)
                        {
                           this._friendList.push(_loc6_);
                           _loc6_.friendList.push(this);
                        }
                     }
                  }
               }
            }
         }
      }
      
      override function buildingIsDestroyed(param1:GameEvent) : void
      {
         var _loc2_:* = param1.tag;
         if(_loc2_ == this._restRoomTarget)
         {
            this._restRoomTarget = null;
         }
         if(_loc2_ == this._tradingPostTarget)
         {
            this._tradingPostTarget = null;
         }
         if(this._staying)
         {
            this._staying = false;
            if(_loc2_ == this._stayingAt)
            {
               this._stayingAt = null;
               this.setHomeDestination();
            }
            else if(_loc2_ == _destination)
            {
               this.setHomeDestination();
            }
         }
         super.buildingIsDestroyed(param1);
      }
      
      function checkBuildingRepaired(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = this._lastBrokenBoothList.indexOf(_loc2_);
         if(_loc3_ in this._lastBrokenBoothList)
         {
            this._lastBrokenBoothList.splice(_loc3_,1);
         }
         if(this._destinationTargetList.length > 0 && _destination == null && !this._staying && !this._visiting)
         {
            this.searchDestination();
         }
      }
      
      function restRoomCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(!(_inside is InsideRestroom))
         {
            if(Calculate.chance(this.restRoomIncrementChance))
            {
               this._restRoomPercentage += Math.random() * 5 + 2;
            }
            this._restRoomPercentage = Math.min(this._restRoomPercentage,100);
            if(this._restRoomPercentage > 70 && this._restRoomTarget == null)
            {
               if((_inside == null || _inside is FacilityStairs || _inside is FacilityElevatorBody) && this.entertainerOnView == null && _destination != "home" && !this._staying)
               {
                  showDialogIconBox("destination",BuildingData.getIconOf("Restroom"),7);
                  this._restRoomTarget = this.searchNearestRestRoom();
                  if(this._restRoomTarget == null)
                  {
                     _destination = "home";
                     this._staying = false;
                     this.setChatComment(this.getSingleConversation(this._singleConversation.noToilet[this._statification]));
                  }
                  else
                  {
                     this.setChatComment(this.getSingleConversation(this._singleConversation.toilet));
                  }
               }
            }
            if(this._restRoomPercentage > 85 && !_run)
            {
               _run = true;
            }
         }
         else if(!_inside.overload(this))
         {
            _loc1_ = _inside.relatedRestroom;
            if(this._restRoomPercentage > 0)
            {
               this._restRoomPercentage -= Math.random() * 8 * (_stat.hygine / 100) + 2;
               _loc1_.gainExp(0.4);
            }
            else
            {
               if(_world.isUpgradePurchased(UpgradeData.PEARL_SOAP))
               {
                  _loc2_ = Math.random() * 5 + 2;
                  gainMood(_loc2_);
               }
               this._restRoomPercentage = 0;
               this._restRoomTarget = null;
            }
         }
         else
         {
            this._restRoomTarget = null;
            this._lastKnownFullBooth.push(_inside);
            _destination = "exit";
         }
      }
      
      function refundCheck() : void
      {
         if(this._restRoomTarget == null)
         {
            if(this._needMoney && this._tradingPostTarget == null)
            {
               if((_inside == null || _inside is FacilityStairs || _inside is FacilityElevatorBody) && this.entertainerOnView == null && _destination != "home" && !this._staying)
               {
                  this._tradingPostTarget = this.searchTradingPost();
                  if(this._tradingPostTarget == null)
                  {
                     _destination = "home";
                     this._staying = false;
                     this.setChatComment(this.getSingleConversation(this._singleConversation.noTradingPost));
                  }
                  else
                  {
                     if(this._lastVisit != null)
                     {
                        this._pastDestination = this._lastVisit;
                     }
                     this.setChatComment(this.getSingleConversation(this._singleConversation.tradingPost));
                  }
               }
            }
         }
      }
      
      function searchNearestRestRoom() : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = Infinity;
         var _loc4_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc5_:* = 0;
         while(_loc5_ < _world.restRoomList.length)
         {
            _loc6_ = _world.restRoomList[_loc5_];
            if((_loc7_ = this._gender > 0 ? _loc6_.maleRoom : (this._gender < 0 ? _loc6_.femaleRoom : null)) != null)
            {
               if(!_loc7_.isFull)
               {
                  _loc8_ = _world.mainContainer.globalToLocal(_loc6_.localToGlobal(new Point(0,0)));
                  _loc9_ = _world.mainContainer.globalToLocal(_loc7_.localToGlobal(new Point(0,0)));
                  _loc10_ = Infinity;
                  if(_loc8_.y == _loc4_.y)
                  {
                     _loc10_ = Math.abs(_loc9_.y - _loc4_.y);
                  }
                  else
                  {
                     _loc11_ = _world.getFloorAt(_loc8_.y);
                     if(_inside is FacilityStairs)
                     {
                        _loc12_ = _loc4_.y > _loc8_.y ? _inside.upperEnterance : (_loc4_.y < _loc8_.y ? _inside.lowerEnterance : _inside.entrancePosition(_loc4_.y));
                        _loc13_ = _world.getFloorAt(_loc12_.y);
                        if(_loc11_ == _loc13_)
                        {
                           _loc10_ = Math.abs(_loc12_.x - _loc9_.x);
                        }
                        else
                        {
                           _loc10_ = (_loc14_ = searchAvailableTransport(_loc13_,_loc11_,_loc4_,_loc8_)).cost;
                        }
                     }
                     else
                     {
                        if((_loc15_ = _world.getFloorAt(_loc4_.y)) == null)
                        {
                           _loc15_ = _world.getBasementFloorAt(_loc4_.y);
                        }
                        _loc10_ = (_loc14_ = searchAvailableTransport(_loc15_,_loc11_,_loc4_,_loc8_)).cost;
                     }
                  }
                  if(isFinite(_loc10_))
                  {
                     if(_loc10_ < _loc3_)
                     {
                        _loc2_ = _loc6_;
                        _loc3_ = _loc10_;
                     }
                  }
               }
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      function checkEntertainer() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc1_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         if(this.entertainerOnView == null)
         {
            if(_destination != "home" && !this._staying && _inside == null && this._meetFriend == null)
            {
               if(!this.needToGo)
               {
                  _loc2_ = 0;
                  while(_loc2_ < _world.staffList.entertainer.length)
                  {
                     _loc3_ = _world.staffList.entertainer[_loc2_];
                     _loc4_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
                     if(_loc3_.doEntertain)
                     {
                        if(_loc4_.y == _loc1_.y)
                        {
                           _loc5_ = Math.abs(_loc1_.x - _loc4_.x);
                           _loc6_ = Math.max(40,getSight() / 8);
                           if(_loc5_ <= _loc6_)
                           {
                              _loc7_ = (100 - _mood) / 100 * 75 + 5;
                              if(Calculate.chance(_loc7_))
                              {
                                 this.entertainerOnView = _loc3_;
                                 _movePoint = null;
                                 currentAnimation = Animation.IDLE;
                              }
                           }
                        }
                     }
                     _loc2_++;
                  }
               }
            }
         }
         else if(this.entertainerOnView.doEntertain)
         {
            _loc8_ = _world.mainContainer.globalToLocal(this.entertainerOnView.localToGlobal(new Point(0,0)));
            this.scaleX = _loc8_.x < _loc1_.x ? Number(-1) : (_loc8_.x > _loc1_.x ? Number(1) : Number(this.scaleX));
         }
         else
         {
            _loc9_ = (2.5 + this.entertainerOnView.level * (this.entertainerOnView.stat.entertain / 50 * 1.5)) / (1 + 0.2 * Math.min(2,this.entertainerOnView.tiredTime));
            _loc10_ = (5 + this.entertainerOnView.level * (this.entertainerOnView.stat.entertain / 50 * 3)) / (1 + 0.2 * Math.min(2,this.entertainerOnView.tiredTime));
            _loc11_ = Math.random() * (_loc10_ - _loc9_) + _loc9_;
            _loc12_ = 1;
            if("moodGiveBonus" in _world.upgradeModifier)
            {
               _loc12_ = 1 + _world.upgradeModifier["moodGiveBonus"];
            }
            gainMood(_loc11_ * _loc12_);
            this.giveBonus();
            this.entertainerOnView = null;
         }
      }
      
      function giveBonus() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = _mood / 100 * 80;
         if(Calculate.chance(_loc1_))
         {
            _loc2_ = Math.round(this._purse * 0.01 * this.entertainerOnView.level);
            _loc3_ = Math.round(Math.random() * _loc2_);
            if(_loc3_ > 0)
            {
               this._purse -= _loc3_;
               dispatchEvent(new HumanEvent(HumanEvent.DROP_BONUS,{
                  "amount":_loc3_,
                  "giveTo":this.entertainerOnView
               }));
            }
         }
      }
      
      function checkBuildingCreated(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.tag;
         if(this._destinationTargetList.length > 0 && _destination == null && !this._staying && !this._visiting)
         {
            _loc3_ = BuildingData.returnClassTo(Utility.getClass(_loc2_));
            if(_loc3_ == this._destinationTargetList[0])
            {
               this.searchDestination();
            }
         }
      }
      
      function checkMood(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.tag;
         if(_mood >= 80 && _loc2_ < 80)
         {
            this._statification = 3;
            this.moodDialogAppear();
         }
         else if(_mood >= 50 && _loc2_ < 50 || _mood <= 78 && _loc2_ > 78)
         {
            this._statification = 2;
            this.moodDialogAppear();
         }
         else if(_mood >= 20 && _loc2_ < 20 || _mood <= 48 && _loc2_ > 48)
         {
            this._statification = 1;
            this.moodDialogAppear();
         }
         else if(_mood <= 18 && _loc2_ > 18)
         {
            this._statification = 0;
            this.moodDialogAppear();
         }
      }
      
      function initPurse() : void
      {
         this._initialPurse = Math.floor(Math.random() * 30 + 20) * 10;
         this._purse = this._initialPurse;
      }
      
      override function boothSearchCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(_destination.open)
         {
            super.boothSearchCheck();
         }
         else
         {
            _loc1_ = _world.getFloorAt(_destination.y);
            if(_loc1_ == null)
            {
               _loc1_ = _world.getBasementFloorAt(_destination.y);
            }
            _loc2_ = new Point(_destination.x,_destination.y);
            _loc3_ = false;
            if(_loc1_ == _floorStep)
            {
               if(_inside == null)
               {
                  _loc3_ = true;
                  _floorTarget = null;
                  _loc4_ = Math.abs(this.x - _loc2_.x);
                  _loc5_ = (_destination.width - 48) / 2;
                  if(_loc4_ > _loc5_)
                  {
                     if(_movePoint == null || (Math.abs(_movePoint.x - _loc2_.x) > _loc5_ || _movePoint.y != _loc2_.y))
                     {
                        _movePoint = new Point(_loc2_.x + (Math.random() * _loc5_ * 2 - _loc5_),_loc2_.y);
                     }
                  }
                  else if(this._waitingOpen < 0)
                  {
                     this._waitingOpen = Math.round(Math.random() * 5 + 40);
                     _movePoint = null;
                     currentAnimation = Animation.IDLE;
                  }
                  else
                  {
                     if(_movePoint == null)
                     {
                        if(Calculate.chance(10))
                        {
                           _movePoint = new Point(_loc2_.x + (Math.random() * _loc5_ * 2 - _loc5_),_loc2_.y);
                        }
                     }
                     if(this._waitingOpen > 0)
                     {
                        --this._waitingOpen;
                     }
                     else
                     {
                        this._destinationTargetList.shift();
                        this.searchDestination();
                     }
                  }
                  _destinationTransport = null;
                  _transportQueue = new Array();
               }
            }
            if(!_loc3_)
            {
               if(_floorTarget == null || _floorTarget != _loc1_)
               {
                  _floorTarget = _loc1_;
                  _floorPoint = new Point(_loc2_.x,_loc2_.y);
                  _destinationTransport = null;
                  _transportQueue = new Array();
               }
            }
         }
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         if(!_passive)
         {
            this.checkEntertainer();
            if(this.entertainerOnView == null)
            {
               this.meetFriendCheck();
               if(this._meetFriend == null)
               {
                  this.restRoomCheck();
                  this.refundCheck();
                  this.hygineCheck();
                  this.trashCheck();
                  if(this._restRoomPercentage < 85)
                  {
                     if(_world.deepRain && _world.weather <= -20)
                     {
                        _run = !insideMall;
                     }
                  }
                  super.behavior(param1);
               }
            }
         }
         else
         {
            this.entertainerOnView = null;
         }
         if(this._staying && this._stayingAt == null && _world.innList.indexOf(_destination) < 0)
         {
            this._staying = false;
            _destination = "home";
         }
      }
      
      function restRoomTargetCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(this._restRoomTarget != null)
         {
            if(_inside == null || _inside is FacilityStairs || _inside is FacilityElevatorBody)
            {
               if(_destination != this._restRoomTarget.maleRoom && _destination != this._restRoomTarget.femaleRoom && (_destination != "home" && !this._staying))
               {
                  if(_destination != null && _destination != this._tradingPostTarget && _destination != "exit")
                  {
                     this._pastDestination = _destination;
                  }
                  _destination = this._gender > 0 ? this._restRoomTarget.maleRoom : (this._gender < 0 ? this._restRoomTarget.femaleRoom : null);
               }
               else if(_destination != "home" && !this._staying)
               {
                  _loc1_ = _world.mainContainer.globalToLocal(_destination.localToGlobal(new Point(0,0)));
                  _loc2_ = _world.getFloorAt(_loc1_.y);
                  _loc3_ = _destination.enterancePosition;
                  _loc4_ = false;
                  if(_loc2_ == _floorStep)
                  {
                     if(_inside == null)
                     {
                        _loc4_ = true;
                        _floorTarget = null;
                        if((_loc5_ = Math.abs(this.x - _loc3_.x)) > 0)
                        {
                           if(_movePoint == null || (_movePoint.x != _loc3_.x || _movePoint.y != _loc3_.y))
                           {
                              _movePoint = new Point(_loc3_.x,_loc3_.y);
                           }
                        }
                        else
                        {
                           _movePoint = null;
                           if(_destination.enableToEnter)
                           {
                              dispatchEvent(new HumanEvent(HumanEvent.ENTER_THE_BUILDING,_destination));
                              _destination = null;
                           }
                           else if((_loc6_ = _destination.door) != null)
                           {
                              if(_loc6_.isClose)
                              {
                                 _destination.openTheDoor();
                              }
                           }
                        }
                        _destinationTransport = null;
                        _transportQueue = new Array();
                     }
                  }
                  if(!_loc4_)
                  {
                     if(_floorTarget == null || _floorTarget != _loc2_)
                     {
                        _floorTarget = _loc2_;
                        _floorPoint = new Point(_loc3_.x,_loc3_.y);
                        _destinationTransport = null;
                        _transportQueue = new Array();
                     }
                  }
               }
            }
         }
      }
      
      function tradingPostTargetCheck() : void
      {
         if(this._restRoomTarget == null)
         {
            if(this._tradingPostTarget != null)
            {
               if(_destination != this._tradingPostTarget && _destination != "home" && !this._staying)
               {
                  if(_destination != null && _destination != "exit")
                  {
                     this._pastDestination = _destination;
                  }
                  _destination = this._tradingPostTarget;
               }
            }
         }
      }
      
      function trashCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         if(_dialogIconBox.stage == null)
         {
            if(_inside == null)
            {
               _loc1_ = null;
               _loc2_ = _world.trashList.concat(_world.pupList);
               _loc3_ = 0;
               while(_loc3_ < _loc2_.length)
               {
                  if((_loc4_ = _loc2_[_loc3_]).y == this.y)
                  {
                     if((_loc5_ = Math.abs(_loc4_.x - this.x)) <= 12)
                     {
                        if(_loc1_ == null)
                        {
                           _loc1_ = _loc4_;
                        }
                        else if(_loc4_.dirtyLevel > _loc1_)
                        {
                           _loc1_ = _loc4_;
                        }
                     }
                  }
                  if(_loc1_ != null)
                  {
                     _loc6_ = _loc1_.dirtyLevel <= 10 ? 0 : _loc1_.dirtyLevel - 10;
                     if("trashMoodLossDecrement" in _world.upgradeModifier)
                     {
                        _loc6_ *= 1 - _world.upgradeModifier["trashMoodLossDecrement"];
                     }
                     if(Calculate.chance(_loc6_))
                     {
                        showDialogIconBox("expresion","itsDirty",7);
                        gainMood(-_loc4_.dirtyLevel / 10);
                     }
                  }
                  _loc3_++;
               }
            }
         }
      }
      
      function hygineCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(insideMall)
         {
            if(this._dirtyDelay > 0)
            {
               --this._dirtyDelay;
            }
            else if(_inside == null && !_run)
            {
               _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
               _loc2_ = 1;
               if("trashDecrement" in _world.upgradeModifier)
               {
                  _loc2_ = 1 - _world.upgradeModifier["trashDecrement"];
               }
               _loc3_ = ((100 - _stat.hygine) / 100 * 3.5 + 0.5) * _loc2_;
               if((_loc4_ = _world.getFloorAt(_loc1_.y)) != null)
               {
                  if(Calculate.chance(_loc3_))
                  {
                     _loc5_ = ((100 - _stat.hygine) / 100 * 1.5 + 1.5) * _loc2_;
                     _world.addTrash(_loc4_,_loc1_.x,_loc5_);
                     if(_destination == "home" || this._staying)
                     {
                        this._dirtyDelay = 20;
                     }
                     else
                     {
                        this._dirtyDelay = Math.floor(Math.random() * 7) + 8;
                     }
                  }
               }
            }
         }
      }
      
      override function destinationTargetCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         this.restRoomTargetCheck();
         this.tradingPostTargetCheck();
         if(_destination == null && !_inHome && !this._staying && this.entertainerOnView == null)
         {
            if(_world.basementFloorList.indexOf(_floorStep) < 0)
            {
               if(_movePoint == null)
               {
                  if(_floorTarget == null)
                  {
                     if(Calculate.chance(30))
                     {
                        _floorTarget = _world.floorList[Math.floor(Math.random() * (_world.floorList.length - 1))];
                     }
                     if(_floorTarget != null)
                     {
                        _loc1_ = null;
                        _loc2_ = _world.floorList.indexOf(_floorTarget);
                        if(_loc2_ + 1 in _world.floorList)
                        {
                           _loc1_ = _world.floorList[_loc2_ + 1];
                        }
                        else
                        {
                           _loc1_ = _floorTarget;
                        }
                        if(_loc1_ != null)
                        {
                           _loc3_ = Math.random() * (_loc1_.right - _loc1_.left) + _loc1_.left;
                           _floorPoint = new Point(_loc3_,_floorTarget.y);
                        }
                     }
                     else if(_inside == null)
                     {
                        if(Calculate.chance(80))
                        {
                           if((_loc4_ = onFloor) != null)
                           {
                              _loc1_ = null;
                              _loc2_ = _world.floorList.indexOf(_loc4_);
                              if(_loc2_ + 1 in _world.floorList)
                              {
                                 _loc1_ = _world.floorList[_loc2_ + 1];
                              }
                              else
                              {
                                 _loc1_ = _loc4_;
                              }
                              if(_loc1_ != null)
                              {
                                 _loc3_ = Math.random() * (_loc1_.right - _loc1_.left) + _loc1_.left;
                                 _movePoint = new Point(_loc3_,_loc4_.y);
                              }
                           }
                        }
                     }
                  }
               }
            }
            else if(_floorTarget != _world.floorList[0])
            {
               _floorTarget = _world.floorList[0];
               _loc5_ = _world.getConnectionAt(0);
               _floorPoint = _loc5_.enterancePosition;
            }
            this.simulateSearchDestination();
         }
         super.destinationTargetCheck();
      }
      
      function simulateSearchDestination() : void
      {
         if(!this._staying && insideMall)
         {
            if(_inside == null || _inside is FacilityElevatorBody || _world.transportList.indexOf(_inside) >= 0)
            {
               if(this._destinationTargetList.length > 0)
               {
                  if(this._searchDestinationCounter > 0)
                  {
                     --this._searchDestinationCounter;
                     if(Calculate.chance(10))
                     {
                        gainMood(-(Math.random() * 2 + 1) / 9);
                        showDialogIconBox("destination",BuildingData.getIconOf(this._destinationTargetList[0]),7);
                     }
                  }
                  else
                  {
                     this._destinationTargetList.shift();
                     this.searchDestination();
                  }
               }
               else if(this._searchDestinationCounter > 0)
               {
                  --this._searchDestinationCounter;
               }
               else
               {
                  this.searchDestination();
               }
            }
         }
      }
      
      function moodDialogAppear() : void
      {
         var _loc1_:* = undefined;
         if(_inside == null || _inside is FacilityElevatorBody || _world.transportList.indexOf(_inside) >= 0)
         {
            _loc1_ = this._statification == 3 ? "happy" : (this._statification == 2 ? "normal" : (this._statification == 1 ? "unhappy" : "angry"));
            showDialogIconBox("statification",_loc1_,7);
         }
      }
      
      function checkGameTime(param1:GameEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this._meetFriend == null && this.entertainerOnView == null)
         {
            _loc2_ = param1.tag;
            if(_destination != "home" && !this._staying)
            {
               if(_loc2_.hour >= 22 || _loc2_.hour < 8)
               {
                  _loc3_ = !(_inside is Booth);
                  if(_inside is Booth)
                  {
                     if(_inside.serveMode != BuildingData.SERVICE)
                     {
                        _loc3_ = true;
                     }
                     else
                     {
                        _loc3_ = _inside.visitorInService.indexOf(this) < 0;
                     }
                  }
                  if(_loc3_)
                  {
                     this.setHomeDestination();
                  }
               }
            }
            this.insideInnCheck(_loc2_);
         }
      }
      
      function getSingleConversation(param1:*) : String
      {
         var _loc2_:* = "";
         if(param1 != null)
         {
            if(param1.length > 0)
            {
               _loc2_ = param1[Math.floor(Math.random() * param1.length)];
            }
         }
         return _loc2_;
      }
      
      function setHomeDestination() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(_destination != "home")
         {
            _loc1_ = 0;
            if(_world.main.unlockedBuilding.indexOf("Lodge") >= 0)
            {
               _loc1_ = Math.max(0,_mood - 50) / 50 * 60 + Math.max(0,this._statification - 1) * 10;
               if(_world.deepRain)
               {
                  _loc1_ *= 1.5;
               }
            }
            this._staying = Calculate.chance(_loc1_);
            this._pastDestination = null;
            if(!this._staying)
            {
               _destination = "home";
               this.setChatComment(this.getSingleConversation(this._singleConversation.goingHome[this._statification]));
            }
            else
            {
               _loc2_ = this.searchPossibleInn();
               if(_loc2_ != null)
               {
                  _destination = _loc2_;
                  this.setChatComment(this.getSingleConversation(this._singleConversation.booth["Lodge"]));
               }
               else
               {
                  showDialogIconBox("destination",BuildingData.getIconOf("Lodge"),7);
                  _destination = "home";
                  this.setChatComment(this.getSingleConversation(this._singleConversation.goingHome[this._statification]));
                  this._staying = false;
               }
            }
         }
      }
      
      function insideInnCheck(param1:*) : void
      {
         var _loc2_:* = undefined;
         if(_inside != null && _inside == this._stayingAt)
         {
            if(this._staying)
            {
               if(!this._canLeave)
               {
                  if(param1.hour < 9)
                  {
                     this._canLeave = true;
                  }
               }
               else
               {
                  _loc2_ = 0;
                  if(param1.hour < 11)
                  {
                     if(param1.hour >= 10)
                     {
                        if(param1.minute < 30)
                        {
                           _loc2_ = (param1.minute + 60) / 90 * 80;
                        }
                        else
                        {
                           _loc2_ = 80;
                        }
                     }
                     else if(param1.hour >= 9)
                     {
                        _loc2_ = (param1.minute - 30) / 90 * 80;
                     }
                  }
                  else
                  {
                     _loc2_ = 80;
                  }
                  if(Calculate.chance(_loc2_))
                  {
                     this._staying = false;
                     this._restRoomPercentage = 0;
                     this._restRoomTarget = null;
                     _run = false;
                     this._purse = this._initialPurse;
                     this.initDestinationList();
                     this.searchDestination();
                     this._initMode = false;
                     if(_destination == null)
                     {
                        _destination = "exit";
                     }
                  }
               }
            }
         }
      }
      
      function searchPossibleInn() : *
      {
         var _loc4_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < _world.innList.length)
         {
            if(!(_loc4_ = _world.innList[_loc3_]).isFull)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         if(_loc2_.length > 0)
         {
            Utility.shuffle(_loc2_);
            _loc1_ = _loc2_.shift();
         }
         return _loc1_;
      }
      
      override function inHomeBehaviorCheck() : void
      {
         if(this.stage)
         {
            _world.updatePopularity(_mood);
            dispatchEvent(new HumanEvent(HumanEvent.EXILE));
            this.parent.removeChild(this);
            this._initMode = true;
         }
      }
      
      public function initData() : void
      {
         this.setFavoriteList();
         this._gender = HumanData.getGender(_model);
         _stat.characterName = HumanData.getRandomCharacterName(this._gender);
         this._singleConversation = ConversationList.generateConversation(this);
      }
      
      function setFavoriteList() : void
      {
         var _loc3_:* = undefined;
         var _loc1_:* = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < 10)
         {
            _loc3_ = FavoriteList.getRandomFavorite(this);
            if(_world.main.unlockedBuilding.indexOf(_loc3_) >= 0)
            {
               _loc1_.push(_loc3_);
            }
            else
            {
               _loc1_.push("(none)");
            }
            _loc2_++;
         }
         this.sortFavorite(_loc1_);
      }
      
      function sortFavorite(param1:Array) : void
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         param1.sort();
         var _loc2_:Array = new Array();
         var _loc3_:* = -1;
         while(param1.length > 0)
         {
            _loc7_ = param1.shift();
            if(_loc3_ < 0 || _loc2_[_loc3_].indexOf(_loc7_))
            {
               _loc3_++;
               _loc2_[_loc3_] = new Array();
            }
            _loc2_[_loc3_].push(_loc7_);
         }
         _loc2_.sortOn("length",Array.NUMERIC | Array.DESCENDING);
         var _loc4_:* = new Array();
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         while(_loc6_ < _loc2_.length)
         {
            if(_loc2_[_loc6_].indexOf("(none)") < 0)
            {
               if(_loc5_ < 5)
               {
                  this._favoriteList = this._favoriteList.concat(_loc2_[_loc6_]);
                  _loc5_++;
               }
               else
               {
                  _loc8_ = 0;
                  while(_loc8_ < _loc2_[_loc6_].length)
                  {
                     _loc4_.push("(none)");
                     _loc8_++;
                  }
               }
            }
            else
            {
               _loc4_ = _loc4_.concat(_loc2_[_loc6_]);
            }
            _loc6_++;
         }
         this._favoriteList = this._favoriteList.concat(_loc4_);
      }
      
      function initDestinationList() : void
      {
         var _loc4_:* = undefined;
         var _loc1_:* = Math.floor(Math.random() * 4);
         var _loc2_:* = this._favoriteList.concat();
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_)
         {
            if(_loc2_.length <= 0)
            {
               break;
            }
            Utility.shuffle(_loc2_);
            if((_loc4_ = _loc2_.shift()) != "(none)")
            {
               if(_world.main.unlockedBuilding.indexOf(_loc4_) >= 0)
               {
                  this._destinationTargetList.push(_loc4_);
               }
               _loc2_.push("(none)");
            }
            _loc3_++;
         }
      }
      
      function searchDestination() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(_world != null)
         {
            this._searchDestinationCounter = 100;
            this._waitingOpen = -1;
            this._needMoney = false;
            if(this._destinationTargetList.length > 0)
            {
               if(Calculate.chance(this._refundChance))
               {
                  this._needMoney = true;
               }
               else
               {
                  this._lastVisit = null;
                  _destination = this.searchBoothOf(this._destinationTargetList[0]);
                  if(_destination == null)
                  {
                     _loc1_ = (100 - _mood) / 100 * 60 + 20;
                     if(_world.deepRain)
                     {
                        _loc1_ *= 1.5;
                     }
                     if(Calculate.chance(_loc1_))
                     {
                        if((_inside == null || _inside is FacilityStairs || _inside is FacilityElevatorBody) && this.entertainerOnView == null && _destination != "home" && !this._staying)
                        {
                           _destination = this.searchTerrace();
                        }
                     }
                  }
                  this.setChatComment(this.getSingleConversation(this._singleConversation.booth[this._destinationTargetList[0]]));
               }
            }
            else
            {
               _loc2_ = Math.max(Math.min((22 - _world.main.gameHour) / 12,1),0);
               _loc3_ = 1;
               if("visitChance" in _world.upgradeModifier)
               {
                  _loc3_ = 1 + _world.upgradeModifier["visitChance"];
               }
               _loc4_ = _mood / 100 * 80 * _loc2_ * _loc3_;
               if(Calculate.chance(_loc4_))
               {
                  if(Calculate.chance(this._refundChance))
                  {
                     this._needMoney = true;
                  }
                  else
                  {
                     this._lastVisit = null;
                     _destination = this.getRandomBooth();
                     if(_destination != null)
                     {
                        this.setChatComment(this.getSingleConversation(this._singleConversation.booth[BuildingData.returnClassTo(Utility.getClass(_destination))]));
                     }
                     else
                     {
                        _loc1_ = (100 - _mood) / 100 * 60 + 20;
                        if(_world.deepRain)
                        {
                           _loc1_ *= 1.5;
                        }
                        if(Calculate.chance(_loc1_))
                        {
                           if((_inside == null || _inside is FacilityStairs || _inside is FacilityElevatorBody) && this.entertainerOnView == null && _destination != "home" && !this._staying)
                           {
                              _destination = this.searchTerrace();
                           }
                        }
                        this.setChatComment(this.getSingleConversation(this._singleConversation.noDestination));
                     }
                  }
               }
               else if(!this._initMode)
               {
                  _loc5_ = _loc2_ * 100;
                  _loc6_ = (100 - _mood) / 100 * 80;
                  _loc7_ = false;
                  if(_loc6_ > _loc5_)
                  {
                     if(Calculate.chance(_loc6_ / 100 * 40 + 30))
                     {
                        if((_inside == null || _inside is FacilityStairs || _inside is FacilityElevatorBody) && this.entertainerOnView == null && _destination != "home" && !this._staying)
                        {
                           _destination = this.searchTerrace();
                           if(_destination == null)
                           {
                              _loc7_ = true;
                           }
                        }
                     }
                     else
                     {
                        _loc7_ = true;
                     }
                  }
                  else
                  {
                     _loc7_ = true;
                  }
                  if(_loc7_)
                  {
                     _loc8_ = Math.max(_loc5_,_loc6_);
                     if(Calculate.chance(_loc8_))
                     {
                        this.setHomeDestination();
                     }
                     else
                     {
                        this.setChatComment(this.getSingleConversation(this._singleConversation.noDestination));
                     }
                  }
                  else
                  {
                     this.setChatComment(this.getSingleConversation(this._singleConversation.noDestination));
                  }
               }
            }
         }
      }
      
      function searchTerrace() : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = Infinity;
         var _loc4_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc5_:* = 0;
         while(_loc5_ < _world.terraceList.length)
         {
            if((_loc6_ = _world.terraceList[_loc5_]) != null)
            {
               if(this._lastKnownFullBooth.indexOf(_loc6_) < 0)
               {
                  if(!_loc6_.isFull && !_loc6_.isBroken)
                  {
                     _loc7_ = _world.mainContainer.globalToLocal(_loc6_.localToGlobal(new Point(0,0)));
                     _loc8_ = Infinity;
                     if(_loc7_.y == _loc4_.y)
                     {
                        _loc8_ = Math.abs(_loc7_.y - _loc4_.y);
                     }
                     else
                     {
                        _loc9_ = _world.getFloorAt(_loc7_.y);
                        if(_inside is FacilityStairs)
                        {
                           _loc10_ = _loc4_.y > _loc7_.y ? _inside.upperEnterance : (_loc4_.y < _loc7_.y ? _inside.lowerEnterance : _inside.entrancePosition(_loc4_.y));
                           _loc11_ = _world.getFloorAt(_loc10_.y);
                           if(_loc9_ == _loc11_)
                           {
                              _loc8_ = Math.abs(_loc10_.x - _loc7_.x);
                           }
                           else
                           {
                              _loc8_ = (_loc12_ = searchAvailableTransport(_loc11_,_loc9_,_loc4_,_loc7_)).cost;
                           }
                        }
                        else
                        {
                           if((_loc13_ = _world.getFloorAt(_loc4_.y)) == null)
                           {
                              _loc13_ = _world.getBasementFloorAt(_loc4_.y);
                           }
                           _loc8_ = (_loc12_ = searchAvailableTransport(_loc13_,_loc9_,_loc4_,_loc7_)).cost;
                        }
                     }
                     if(isFinite(_loc8_))
                     {
                        if(_loc8_ < _loc3_)
                        {
                           _loc2_ = _loc6_;
                           _loc3_ = _loc8_;
                        }
                     }
                  }
               }
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      function searchTradingPost() : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = Infinity;
         var _loc4_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc5_:* = 0;
         while(_loc5_ < _world.tradingPostList.length)
         {
            if((_loc6_ = _world.tradingPostList[_loc5_]) != null)
            {
               if(this._lastKnownFullBooth.indexOf(_loc6_) < 0)
               {
                  if(!_loc6_.isFull && !(_loc6_.isBroken && !(this is Leonidas)))
                  {
                     _loc7_ = _world.mainContainer.globalToLocal(_loc6_.localToGlobal(new Point(0,0)));
                     _loc8_ = Infinity;
                     if(_loc7_.y == _loc4_.y)
                     {
                        _loc8_ = Math.abs(_loc7_.y - _loc4_.y);
                     }
                     else
                     {
                        _loc9_ = _world.getFloorAt(_loc7_.y);
                        if(_inside is FacilityStairs)
                        {
                           _loc10_ = _loc4_.y > _loc7_.y ? _inside.upperEnterance : (_loc4_.y < _loc7_.y ? _inside.lowerEnterance : _inside.entrancePosition(_loc4_.y));
                           _loc11_ = _world.getFloorAt(_loc10_.y);
                           if(_loc9_ == _loc11_)
                           {
                              _loc8_ = Math.abs(_loc10_.x - _loc7_.x);
                           }
                           else
                           {
                              _loc8_ = (_loc12_ = searchAvailableTransport(_loc11_,_loc9_,_loc4_,_loc7_)).cost;
                           }
                        }
                        else
                        {
                           if((_loc13_ = _world.getFloorAt(_loc4_.y)) == null)
                           {
                              _loc13_ = _world.getBasementFloorAt(_loc4_.y);
                           }
                           _loc8_ = (_loc12_ = searchAvailableTransport(_loc13_,_loc9_,_loc4_,_loc7_)).cost;
                        }
                     }
                     if(isFinite(_loc8_))
                     {
                        if(_loc8_ < _loc3_)
                        {
                           _loc2_ = _loc6_;
                           _loc3_ = _loc8_;
                        }
                     }
                  }
               }
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      function searchBoothOf(param1:String) : *
      {
         var _loc5_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = new Array();
         var _loc4_:* = 0;
         while(_loc4_ < _world.boothList.length)
         {
            _loc5_ = _world.boothList[_loc4_];
            if(BuildingData.returnClassTo(Utility.getClass(_loc5_)) == param1)
            {
               if(_loc5_ != _destination)
               {
                  if(this._lastBrokenBoothList.indexOf(_loc5_) < 0 && this._lastKnownFullBooth.indexOf(_loc5_) < 0)
                  {
                     _loc3_.push(_loc5_);
                  }
               }
            }
            _loc4_++;
         }
         if(_loc3_.length > 0)
         {
            Utility.shuffle(_loc3_);
            _loc2_ = _loc3_.shift();
         }
         return _loc2_;
      }
      
      function getRandomBooth() : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = new Array();
         var _loc3_:* = 0;
         for(; _loc3_ < _world.boothList.length; _loc3_++)
         {
            _loc4_ = _world.boothList[_loc3_];
            if(this._lastBrokenBoothList.indexOf(_loc4_) < 0)
            {
               _loc2_.push(_loc4_);
            }
            if(!_world.deepRain)
            {
               continue;
            }
            _loc5_ = BuildingData.returnClassTo(Utility.getClass(_loc4_));
            _loc6_ = BuildingData.getCategoryOf(_loc5_);
            switch(_loc6_)
            {
               case BuildingData.FOOD:
                  if(Calculate.chance(60))
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               case BuildingData.INN:
                  if(Calculate.chance(45))
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
               case BuildingData.ENTERTAINMENT:
                  if(Calculate.chance(15))
                  {
                     _loc2_.push(_loc4_);
                  }
                  break;
            }
         }
         if(_loc2_.length > 0)
         {
            Utility.shuffle(_loc2_);
            _loc1_ = _loc2_.shift();
         }
         return _loc1_;
      }
      
      public function loadCondition(param1:*) : void
      {
         var _loc2_:* = undefined;
         if(!(this is SpecialVisitor))
         {
            this._favoriteList = param1.favoriteList.concat();
            _mood = param1.mood;
            this._statification = param1.statification;
         }
         this._destinationTargetList = param1.destinationTargetList.concat();
         this._shopingPrice = param1.shopingPrice;
         this._restRoomPercentage = param1.restRoomPercentage;
         this._purse = param1.purse;
         this._initialPurse = param1.initialPurse;
         this._numberItemBought = param1.numberItemBought;
         this._buyTreshold = param1.buyTreshold;
         this._visitTime = param1.visitTime;
         this._visiting = param1.visiting;
         this._staying = param1.staying;
         this._canLeave = param1.canLeave;
         this._gender = HumanData.getGender(_model);
         if(param1.critterMode != null)
         {
            _loc2_ = new Critter();
            _loc2_.world = _world;
            _loc2_.x = this.x;
            _loc2_.y = this.y;
            _loc2_.related = this;
            _loc2_.scaleX = this.scaleX;
            _loc2_.loadCondition(param1.critterMode);
            _passive = true;
            _relatedCritter = _loc2_;
         }
         else
         {
            _relatedCritter = null;
         }
         this._initMode = false;
         if(!(this is SpecialVisitor))
         {
            this.restRoomIncrementChance = 3 * ((100 - _stat.hygine) / 100) + 4;
            this._singleConversation = ConversationList.generateConversation(this);
         }
      }
      
      public function initChat() : void
      {
         var _loc1_:* = undefined;
         if(this._stayingAt == null)
         {
            if(this.restRoomTarget == null)
            {
               if(this.tradingPostTarget == null)
               {
                  if(_destination != "home")
                  {
                     if(_destination is Booth)
                     {
                        _loc1_ = BuildingData.returnClassTo(Utility.getClass(_destination));
                        if(_loc1_ in this._singleConversation.booth)
                        {
                           this._chatComment = this.getSingleConversation(this._singleConversation.booth[_loc1_]);
                        }
                     }
                     else if(this._destinationTargetList.length > 0)
                     {
                        if(this._destinationTargetList[0] in this._singleConversation.booth)
                        {
                           this._chatComment = this.getSingleConversation(this._singleConversation.booth[this._destinationTargetList[0]]);
                        }
                     }
                     else
                     {
                        this._chatComment = this.getSingleConversation(this._singleConversation.noDestination);
                     }
                  }
                  else
                  {
                     this._chatComment = this.getSingleConversation(this._singleConversation.goingHome[this._statification]);
                  }
               }
               else
               {
                  this._chatComment = this.getSingleConversation(this._singleConversation.tradingPost);
               }
            }
            else
            {
               this._chatComment = this.getSingleConversation(this._singleConversation.toilet);
            }
         }
         else
         {
            this._chatComment = "ZZZzzzzzz....";
         }
      }
      
      public function saveCondition(param1:*) : void
      {
         if(!(this is SpecialVisitor))
         {
            param1.favoriteList = this._favoriteList.concat();
            param1.mood = _mood;
            param1.statification = this._statification;
         }
         param1.destinationTargetList = this._destinationTargetList.concat();
         param1.restRoomPercentage = this._restRoomPercentage;
         param1.shopingPrice = this._shopingPrice;
         param1.purse = this._purse;
         param1.initialPurse = this._initialPurse;
         param1.numberItemBought = this._numberItemBought;
         param1.buyTreshold = this._buyTreshold;
         param1.visitTime = this._visitTime;
         param1.visiting = this._visiting;
         param1.staying = this._staying;
         param1.canLeave = this._canLeave;
         if(_relatedCritter != null)
         {
            param1.critterMode = new Object();
            _relatedCritter.saveCondition(param1.critterMode);
         }
         else
         {
            param1.critterMode = null;
         }
      }
      
      override function whenEnterTheBuilding(param1:HumanEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         super.whenEnterTheBuilding(param1);
         var _loc2_:* = param1.tag;
         if(_loc2_ == _destination)
         {
            if(_loc2_ is Booth || _loc2_ is FacilityTerrace)
            {
               if(_world.innList.indexOf(_loc2_) < 0)
               {
                  if(_loc2_.overload(this))
                  {
                     this._lastKnownFullBooth.push(_loc2_);
                  }
                  else
                  {
                     this._shopingPrice = 0;
                     this._numberItemBought = 0;
                     _loc3_ = 0;
                     if((_loc4_ = root).hacked > 1 && _world.main.mission.currentProgress <= 15)
                     {
                        _loc3_ = Math.floor(Math.random() * 4) + 1;
                     }
                     else
                     {
                        _loc3_ = Math.round((1 + 0.3 * _world.popularity / 10) * BuildingData.getItemTreshold(BuildingData.returnClassTo(Utility.getClass(_inside))));
                     }
                     _loc5_ = 1;
                     _loc6_ = BuildingData.returnClassTo(Utility.getClass(_loc2_));
                     if(["Weaponry","Armory","Blacksmith"].indexOf(_loc6_) >= 0)
                     {
                        if(_world.isUpgradePurchased(UpgradeData.RARE_IRON))
                        {
                           _loc5_ = 1.5;
                        }
                     }
                     else if(["Butcher","Snack","Soup","BBQ","Eatery"].indexOf(_loc6_) >= 0)
                     {
                        if(_world.isUpgradePurchased(UpgradeData.DELICIOUS_SPIES))
                        {
                           _loc5_ = 1.5;
                        }
                     }
                     else if(["Brewery","Potion Shop"].indexOf(_loc6_) >= 0)
                     {
                        if(_world.isUpgradePurchased(UpgradeData.DRUNK_CAMPAIGN))
                        {
                           _loc5_ = 1.5;
                        }
                     }
                     this._buyTreshold = _loc3_ * _loc5_;
                     this._visitTime = 30;
                     this._visiting = true;
                     if(_loc2_.serveMode == BuildingData.ENTRY)
                     {
                        if(_loc2_.entryVisitor.indexOf(this) < 0)
                        {
                           _loc2_.entryVisitor.push(this);
                        }
                     }
                     _loc2_.dispatchEvent(new GameEvent(GameEvent.VISITOR_VISIT,this));
                  }
               }
               else if(this._stayingAt == null)
               {
                  if(!_loc2_.overload(this))
                  {
                     _world.updatePopularity(_mood);
                     this._stayingAt = _loc2_;
                     this._canLeave = false;
                     this._chatComment = "ZZZzzzzzz....";
                     _loc2_.dispatchEvent(new GameEvent(GameEvent.VISITOR_VISIT,this));
                  }
                  else
                  {
                     this._staying = false;
                  }
               }
            }
         }
      }
      
      override function whenExitTheBuilding(param1:HumanEvent) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         super.whenExitTheBuilding(param1);
         var _loc2_:* = param1.tag;
         var _loc3_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         if(this._visiting || _loc2_ == this._stayingAt)
         {
            this.moodDialogAppear();
         }
         if(this._pastDestination != null)
         {
            _destination = this._pastDestination;
            if(_destination != "home")
            {
               if(_destination is Building)
               {
                  this.setChatComment(this.getSingleConversation(this._singleConversation.booth[BuildingData.returnClassTo(Utility.getClass(_destination))]));
               }
            }
            else
            {
               this.setChatComment(this.getSingleConversation(this._singleConversation.goingHome[this._statification]));
            }
            this._pastDestination = null;
         }
         var _loc4_:* = _loc2_;
         if(_loc2_ is FictionalBuilding)
         {
            _loc4_ = _loc2_.related;
         }
         if(_loc2_ is InsideRestroom)
         {
            _loc4_ = _loc2_.relatedRestroom;
            if(this._restRoomPercentage < 85)
            {
               _run = false;
            }
         }
         if(!(this is Leonidas))
         {
            if(_loc4_.isBroken)
            {
               gainMood(this.lossMoodValue(_loc2_) * 10);
               if(this._tradingPostTarget == _loc4_)
               {
                  this._tradingPostTarget = null;
               }
            }
         }
         if(this._lastKnownFullBooth.indexOf(_loc4_) >= 0)
         {
            showDialogIconBox("destination invalid",BuildingData.getIconOf(BuildingData.returnClassTo(Utility.getClass(_loc4_))),7);
            gainMood(-(Math.random() * 3 + 5));
         }
         if(_world.boothList.indexOf(_loc4_))
         {
            this._refundChance = Math.max(this._refundChance,(this._initialPurse - this._purse) / this._initialPurse * 100);
         }
         if(this._stayingAt == _loc2_)
         {
            _loc5_ = this._stayingAt.priceList.concat();
            Utility.shuffle(_loc5_);
            _loc6_ = _loc5_.shift();
            _loc7_ = Math.round(Math.min(this._purse - _loc6_,Math.max(0,Math.random() * (_loc6_ * (0.1 + 0.2 * this._stayingAt.level)) * (_mood - 50) / 25)) * (1 + 0.08 * _world.popularity / 10));
            _loc8_ = _loc6_ + _loc7_;
            dispatchEvent(new HumanEvent(HumanEvent.SPENT_MONEY,{
               "amount":_loc8_,
               "booth":this._stayingAt
            }));
            this._stayingAt = null;
         }
         if(this._visiting)
         {
            if(this._destinationTargetList.length > 0)
            {
               this._destinationTargetList.shift();
            }
            if(this._shopingPrice > 0)
            {
               this._purse -= this._shopingPrice;
               dispatchEvent(new HumanEvent(HumanEvent.SPENT_MONEY,{
                  "amount":this._shopingPrice,
                  "booth":_loc4_
               }));
            }
            if(_destination != "home" && !this._staying)
            {
               this.searchDestination();
            }
            this._visiting = false;
         }
         else if(!(_loc2_ is FacilityElevatorBody || _loc2_ is FacilityStairs || _loc2_ == _world.dungeon))
         {
            this.initChat();
            this.setChatComment(this._chatComment);
         }
      }
      
      function brokenBoothCheck() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc1_:* = _inside;
         if(_inside is FictionalBuilding)
         {
            _loc1_ = _inside.related;
         }
         if(_world.brokableBuildingList.indexOf(_loc1_) >= 0)
         {
            if(this._visitTime > 5)
            {
               _loc2_ = _inside.serveMode;
               _loc3_ = 0;
               if(_loc2_ == BuildingData.SERVICE)
               {
                  if((_loc5_ = _loc1_.visitorInService.indexOf(this)) in _loc1_.serviceTimeList)
                  {
                     _loc3_ = 5;
                  }
                  else
                  {
                     _loc3_ = 15;
                  }
               }
               else
               {
                  _loc3_ = 10;
               }
               _loc4_ = 1;
               if("buildingToughness" in _world.upgradeModifier)
               {
                  _loc4_ = 1 - _world.upgradeModifier["buildingToughness"];
               }
               if(Calculate.chance(_loc3_ * _loc4_))
               {
                  _loc1_.buildingHP -= Math.round(Math.random() * 2 + 1);
               }
            }
         }
      }
      
      override function insideBoothCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(_inside != null)
         {
            this.brokenBoothCheck();
            if(_inside is Booth || _inside is FacilityTerrace)
            {
               if(_world.innList.indexOf(_inside) < 0)
               {
                  if(_inside.insideRegion != null)
                  {
                     if(_destination == null || _destination == _inside)
                     {
                        if(_inside.visitorInSpot.indexOf(this) < 0 && (!(_inside is FacilityTerrace) && _inside.visitorInService.indexOf(this) < 0 && _inside.entryVisitor.indexOf(this) < 0 && _inside.onEntry.indexOf(this) < 0))
                        {
                           if(_movePoint == null)
                           {
                              if(Calculate.chance(10))
                              {
                                 _loc1_ = _inside.insideRegion.x + (Math.random() * _inside.insideRegion.width - _inside.insideRegion.width / 2);
                                 _movePoint = new Point(_loc1_,this.y);
                              }
                           }
                        }
                     }
                     else
                     {
                        _loc2_ = _inside.visitorInSpot.indexOf(this);
                        if(_loc2_ in _inside.visitorInSpot)
                        {
                           _inside.visitorInSpot[_loc2_] = null;
                           _inside.spotList[_loc2_].visible = false;
                           this.visible = true;
                        }
                     }
                  }
                  this.visitingProgress();
               }
               else if(this._stayingAt == null)
               {
                  if(_inside.overload(this))
                  {
                     showDialogIconBox("destination invalid",BuildingData.getIconOf("Lodge"),7);
                     this._staying = false;
                     this.setHomeDestination();
                  }
               }
            }
         }
         super.insideBoothCheck();
      }
      
      function insideRestroomCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this._restRoomTarget == null)
         {
            if(_inside is InsideRestroom)
            {
               _loc1_ = _inside.enterancePosition;
               _loc2_ = this.parent.globalToLocal(_world.mainContainer.localToGlobal(_loc1_));
               _loc3_ = Math.abs(_loc2_.x - this.x);
               if(_loc3_ > 0)
               {
                  if(_movePoint == null || _movePoint.x != _loc2_.x && _movePoint.y != _loc2_.y)
                  {
                     _movePoint = new Point(_loc2_.x,_loc2_.y);
                  }
               }
               else
               {
                  _movePoint = null;
                  if(_inside.enableToEnter)
                  {
                     dispatchEvent(new HumanEvent(HumanEvent.EXIT_THE_BUILDING,_inside));
                  }
                  else if((_loc4_ = _inside.door) != null)
                  {
                     if(_loc4_.isClose)
                     {
                        _inside.openTheDoor();
                     }
                  }
               }
            }
         }
      }
      
      override function insideBuildingCheck() : void
      {
         super.insideBuildingCheck();
         if(!(_inside is Wagon || _inside is HalteWagon))
         {
            this.insideRestroomCheck();
         }
      }
      
      function checkActivityInsideBuilding() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(_inside != null)
         {
            if(this._lastKnownFullBooth.indexOf(_inside) < 0)
            {
               if(!(_inside.isBroken && !(this is Leonidas)))
               {
                  _loc1_ = _inside;
                  if(_loc1_ is FictionalBuilding)
                  {
                     _loc1_ = _inside.related;
                  }
                  _loc2_ = _loc1_.serveMode;
                  if(_loc2_ == BuildingData.SALE)
                  {
                     this.activityInsideSaleMode();
                  }
                  else if(_loc2_ == BuildingData.SERVICE)
                  {
                     this.activityInsideServiceMode();
                  }
                  else if(_loc2_ == BuildingData.ENTRY)
                  {
                     this.activityInsideEntryMode();
                  }
                  else if(_loc1_ is FacilityTerrace)
                  {
                     this.activityInsideTerrace();
                  }
               }
               else if(this._visitTime > 5)
               {
                  this._visiting = false;
                  this._visitTime = 5;
                  this._lastBrokenBoothList.push(_inside);
               }
               else
               {
                  --this._visitTime;
               }
            }
            else
            {
               this._visitTime = 0;
            }
         }
      }
      
      function activityInsideSaleMode() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc1_:* = _inside;
         if(_inside is FictionalBuilding)
         {
            _loc1_ = _inside.related;
         }
         if(this._visitTime > 5)
         {
            _loc2_ = this._buyTreshold / (this._numberItemBought + this._buyTreshold);
            _loc3_ = Math.floor(1.2 * _mood) * _loc2_;
            if(Calculate.chance(Math.max(_loc3_,5)))
            {
               _loc4_ = _loc1_.priceList.concat();
               Utility.shuffle(_loc4_);
               _loc5_ = _loc4_.shift();
               if(this._purse - this._shopingPrice - _loc5_ >= 0)
               {
                  this._shopingPrice += _loc5_;
                  ++this._numberItemBought;
                  this._visitTime += Math.floor(Math.random() * 2) + 1;
                  gainMood(this.gainedMoodValue(_loc1_));
                  this.additionalRestroomCheck(_loc1_);
               }
               else
               {
                  this._lastVisit = _loc1_;
                  this._visitTime = 5;
                  this._refundChance += 20;
               }
            }
         }
         --this._visitTime;
      }
      
      function activityInsideServiceMode() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc1_:* = _inside;
         if(_loc1_ is FictionalBuilding)
         {
            _loc1_ = _inside.related;
         }
         var _loc2_:* = _loc1_.visitorInService.indexOf(this);
         if(!(_loc2_ in _loc1_.visitorInService))
         {
            if(this._visitTime > 0)
            {
               _loc3_ = _loc1_.visitorList.indexOf(this);
               if(_loc3_ >= 0 && _loc3_ < _loc1_.visitorInService.length)
               {
                  _loc4_ = new Array();
                  _loc5_ = 0;
                  while(_loc5_ < _loc1_.visitorInService.length)
                  {
                     if(_loc5_ in _loc1_.employeeInPosition)
                     {
                        if(_loc1_.employeeInPosition[_loc5_])
                        {
                           if(_loc1_.visitorInService[_loc5_] == null)
                           {
                              _loc4_.push(_loc5_);
                           }
                        }
                     }
                     _loc5_++;
                  }
                  if(_loc4_.length > 0)
                  {
                     Utility.shuffle(_loc4_);
                     _loc6_ = _loc4_.shift();
                     _loc1_.visitorInService[_loc6_] = this;
                  }
                  else
                  {
                     --this._visitTime;
                     if(this._visitTime <= 0)
                     {
                        this._lastKnownFullBooth.push(_loc1_);
                        gainMood(this.lossMoodValue(_loc1_));
                     }
                  }
               }
            }
         }
         else if(_loc2_ in _loc1_.serviceSpotList)
         {
            _loc7_ = _loc1_.serviceSpotList[_loc2_];
            if(this._visitTime > 0)
            {
               if((_loc8_ = Math.abs(this.x - _loc7_.x)) > 0)
               {
                  if(this.visible)
                  {
                     _movePoint = new Point(_loc7_.x,_loc7_.y);
                  }
                  else
                  {
                     this.x = _loc7_.x;
                  }
               }
               else if(_loc1_.serviceTimeList[_loc2_] < 0)
               {
                  _loc9_ = _loc1_.priceList.concat();
                  Utility.shuffle(_loc9_);
                  _loc10_ = _loc9_.shift();
                  if(this._purse - _loc10_ >= 0)
                  {
                     this._shopingPrice = _loc10_;
                     _loc7_.visible = true;
                     _loc7_.gotoAndStop(_model);
                     this.visible = false;
                  }
                  else
                  {
                     this._lastVisit = _loc1_;
                     this._visitTime = 0;
                     this._refundChance += 20;
                  }
               }
               else if(_loc1_.serviceTimeList[_loc2_] <= 0 && _loc1_.serviceTimeList[_loc2_] > -1)
               {
                  if(_world.tradingPostList.indexOf(_loc1_) < 0)
                  {
                     if(this._buyTreshold > 0)
                     {
                        _loc11_ = BuildingData.returnClassTo(Utility.getClass(_loc1_));
                        _loc12_ = Math.max(0,Math.random() * (this._shopingPrice * (0.1 + 0.2 * _inside.level)) * ((_mood - 50) / 25) * (1 + 0.08 * _world.popularity / 10));
                        if(["Barbershop","Bath House","Spa"].indexOf(_loc11_) >= 0)
                        {
                           if(_world.isUpgradePurchased(UpgradeData.BEAUTY_CAMPAIGN))
                           {
                              _loc12_ *= 1.5;
                           }
                        }
                        _loc13_ = Math.round(Math.min(this._purse - this._shopingPrice,_loc12_));
                        this._shopingPrice += _loc13_;
                     }
                     else
                     {
                        this._shopingPrice = 0;
                     }
                     this._visitTime = 0;
                  }
                  else
                  {
                     _loc14_ = Math.max(0,this._initialPurse - this._purse);
                     dispatchEvent(new HumanEvent(HumanEvent.REFUND_MONEY,_loc14_));
                     this._purse = this._initialPurse;
                     this._refundChance = 0;
                     this._visiting = false;
                     this._visitTime = 0;
                     this._needMoney = false;
                     this._tradingPostTarget = null;
                  }
               }
               else
               {
                  gainMood(this.gainedMoodValue(_loc1_) * (1 + 0.2 * (_loc1_.level - 1)));
               }
            }
            if(this._visitTime <= 0)
            {
               _loc1_.visitorInService[_loc2_] = null;
               _loc1_.serviceTimeList[_loc2_] = -1;
               _loc7_.visible = false;
               this.visible = true;
            }
         }
      }
      
      function checkInsideEntry(param1:*) : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc2_:* = param1.visitorInSpot.indexOf(this);
         var _loc3_:* = param1.entryVisitor.indexOf(this);
         var _loc4_:* = param1.priceList.concat();
         Utility.shuffle(_loc4_);
         var _loc5_:* = _loc4_.shift();
         if(!(_loc2_ in param1.visitorInSpot))
         {
            if((_loc6_ = param1.visitorList.indexOf(this)) >= 0 && _loc6_ < param1.visitorInSpot.length)
            {
               _loc7_ = new Array();
               _loc8_ = false;
               _loc9_ = 0;
               while(_loc9_ < param1.visitorInSpot.length)
               {
                  if(param1.visitorInSpot[_loc9_] == null)
                  {
                     _loc7_.push(_loc9_);
                  }
                  else if(param1 is BoothBathHouse)
                  {
                     if((_loc10_ = param1.visitorInSpot[_loc9_]).gender != this._gender)
                     {
                        if(!_loc8_)
                        {
                           _loc8_ = true;
                        }
                     }
                  }
                  _loc9_++;
               }
               if(!_loc8_)
               {
                  if(_loc7_.length > 0)
                  {
                     Utility.shuffle(_loc7_);
                     _loc11_ = _loc7_.shift();
                     param1.visitorInSpot[_loc11_] = this;
                  }
                  else if(_loc3_ in param1.entryVisitor)
                  {
                     param1.entryVisitor.splice(_loc3_,1);
                     if(this._purse - _loc5_ >= 0)
                     {
                        if(this._buyTreshold > 0)
                        {
                           this._purse -= _loc5_;
                           dispatchEvent(new HumanEvent(HumanEvent.SPENT_MONEY,{
                              "amount":_loc5_,
                              "booth":param1
                           }));
                           this._refundChance = Math.max(this._refundChance,(this._initialPurse - this._purse) / this._initialPurse * 100);
                        }
                     }
                     else
                     {
                        this._lastVisit = param1;
                        this._visitTime = 0;
                        this._refundChance += 20;
                     }
                  }
               }
               else if(_loc3_ in param1.entryVisitor)
               {
                  param1.entryVisitor.splice(_loc3_,1);
                  this._visitTime = 0;
                  showDialogIconBox("expresion","embrassment",12);
               }
            }
         }
         else if(_loc2_ in param1.spotList)
         {
            _loc12_ = param1.spotList[_loc2_];
            if((_loc13_ = Math.abs(this.x - _loc12_.x)) > 0)
            {
               if(this.visible)
               {
                  _movePoint = new Point(_loc12_.x,_loc12_.y);
               }
               else
               {
                  this.x = _loc12_.x;
               }
            }
            else if(_loc3_ in param1.entryVisitor)
            {
               param1.entryVisitor.splice(_loc3_,1);
               if(this._purse - _loc5_ >= 0)
               {
                  if(this._buyTreshold > 0)
                  {
                     this._purse -= _loc5_;
                     dispatchEvent(new HumanEvent(HumanEvent.SPENT_MONEY,{
                        "amount":_loc5_,
                        "booth":param1
                     }));
                     this._refundChance = Math.max(this._refundChance,(this._initialPurse - this._purse) / this._initialPurse * 100);
                  }
               }
               else
               {
                  this._lastVisit = param1;
                  this._visitTime = 0;
                  this._refundChance += 20;
               }
            }
            if(this._visitTime <= 0)
            {
               param1.visitorInSpot[_loc2_] = null;
               _loc12_.visible = false;
               this.visible = true;
            }
         }
      }
      
      function checkInsideSpot(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:* = param1.visitorInSpot.indexOf(this);
         if(!(_loc2_ in param1.visitorInSpot))
         {
            _loc3_ = param1.visitorList.indexOf(this);
            if(_loc3_ >= 0 && _loc3_ < param1.visitorInSpot.length)
            {
               _loc4_ = new Array();
               _loc5_ = 0;
               while(_loc5_ < param1.visitorInSpot.length)
               {
                  if(param1.visitorInSpot[_loc5_] == null)
                  {
                     _loc4_.push(_loc5_);
                  }
                  _loc5_++;
               }
               if(_loc4_.length > 0)
               {
                  Utility.shuffle(_loc4_);
                  _loc6_ = _loc4_.shift();
                  param1.visitorInSpot[_loc6_] = this;
               }
            }
         }
         else if(_loc2_ in param1.spotList)
         {
            _loc7_ = param1.spotList[_loc2_];
            if(this._visitTime > 0)
            {
               if((_loc8_ = Math.abs(this.x - _loc7_.x)) > 0)
               {
                  if(this.visible)
                  {
                     _movePoint = new Point(_loc7_.x,_loc7_.y);
                  }
                  else
                  {
                     this.x = _loc7_.x;
                  }
               }
               else
               {
                  _loc7_.visible = true;
                  _loc7_.gotoAndStop(_model);
                  this.visible = false;
               }
            }
            else
            {
               param1.visitorInSpot[_loc2_] = null;
               _loc7_.visible = false;
               this.visible = true;
            }
         }
      }
      
      function activityInsideEntryMode() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc1_:* = _inside;
         if(_loc1_ is FictionalBuilding)
         {
            _loc1_ = _loc1_.related;
         }
         var _loc2_:* = _loc1_.entryVisitor.indexOf(this);
         if(_loc2_ in _loc1_.entryVisitor)
         {
            if(_loc1_.cashierPosition != null)
            {
               _loc3_ = _loc1_.cashierPosition;
               _loc4_ = this.parent.globalToLocal(_world.mainContainer.localToGlobal(_loc3_));
               if((_loc5_ = Math.abs(_loc4_.x - this.x)) > 0)
               {
                  if(_movePoint == null || _movePoint.x != _loc4_.x && _movePoint.y != _loc4_.y)
                  {
                     _movePoint = new Point(_loc4_.x,_loc4_.y);
                  }
               }
               else
               {
                  _movePoint = null;
                  _loc1_.entryVisitor.splice(_loc2_,1);
                  if(_loc1_.onEntry.indexOf(this) < 0)
                  {
                     _loc1_.onEntry.push(this);
                  }
                  _loc6_ = _inside.priceList.concat();
                  Utility.shuffle(_loc6_);
                  _loc7_ = _loc6_.shift();
                  if(this._purse >= _loc7_)
                  {
                     if(this._buyTreshold > 0)
                     {
                        this._purse -= _loc7_;
                        dispatchEvent(new HumanEvent(HumanEvent.SPENT_MONEY,{
                           "amount":_loc7_,
                           "booth":_loc1_
                        }));
                        this._refundChance = Math.max(this._refundChance,(this._initialPurse - this._purse) / this._initialPurse * 100);
                     }
                  }
                  else
                  {
                     this._refundChance += 30;
                     this._lastVisit = _loc1_;
                     _destination = "exit";
                  }
               }
            }
            else
            {
               this.checkInsideEntry(_loc1_);
            }
         }
         else if(_inside.fictionalBuilding != null)
         {
            _loc9_ = (_loc8_ = _inside.fictionalBuilding).enterancePosition;
            _loc10_ = this.parent.globalToLocal(_world.mainContainer.localToGlobal(new Point(_loc9_.x,_loc9_.y)));
            if((_loc5_ = Math.abs(_loc10_.x - this.x)) > 0)
            {
               if(_movePoint == null || _movePoint.x != _loc10_.x && _movePoint.y != _loc10_.y)
               {
                  _movePoint = new Point(_loc10_.x,_loc10_.y);
               }
            }
            else
            {
               _movePoint = null;
               if(_loc8_.enableToEnter)
               {
                  if((_loc11_ = _loc1_.onEntry.indexOf(this)) in _loc1_.onEntry)
                  {
                     _loc1_.onEntry.splice(_loc11_,1);
                  }
                  dispatchEvent(new HumanEvent(HumanEvent.ENTER_THE_BUILDING,_loc8_));
               }
               else if((_loc12_ = _loc8_.door) != null)
               {
                  if(_loc12_.isClose)
                  {
                     _loc8_.openTheDoor();
                  }
               }
            }
         }
         else
         {
            this.checkInsideSpot(_loc1_);
            if(this._visitTime > 5)
            {
               _loc13_ = this._buyTreshold / (this._numberItemBought + this._buyTreshold);
               _loc14_ = Math.floor(35 * _loc13_);
               if(Calculate.chance(Math.max(_loc14_,5)))
               {
                  ++this._numberItemBought;
                  gainMood(this.gainedMoodValue(_loc1_) * _loc1_.level);
                  this._visitTime += Math.floor(Math.random() * 2) + 1;
               }
            }
            else if(this.visitTimeBefore > 5 || isNaN(this.visitTimeBefore))
            {
               if(this._buyTreshold > 0)
               {
                  _loc6_ = _loc1_.priceList.concat();
                  Utility.shuffle(_loc6_);
                  _loc15_ = _loc6_.shift();
                  _loc16_ = BuildingData.returnClassTo(Utility.getClass(_loc1_));
                  _loc17_ = Math.max(0,Math.random() * (_loc15_ * (0.2 + 0.1 * _inside.level)) * ((_mood - 50) / 25) * (1 + 0.05 * _world.popularity / 10));
                  if(["Barbershop","Bath House","Spa"].indexOf(_loc16_) >= 0)
                  {
                     _loc17_ *= 1.5;
                  }
                  _loc18_ = Math.round(Math.min(this._purse - _loc15_,_loc17_));
                  this._shopingPrice = _loc18_;
               }
            }
            this.visitTimeBefore = this._visitTime;
            --this._visitTime;
         }
      }
      
      function activityInsideTerrace() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc1_:* = _inside;
         var _loc2_:* = _loc1_.visitorInSpot.indexOf(this);
         if(!(_loc2_ in _loc1_.visitorInSpot))
         {
            if(this._visitTime > 0)
            {
               _loc3_ = _loc1_.visitorList.indexOf(this);
               if(_loc3_ >= 0 && _loc3_ < _loc1_.visitorInSpot.length)
               {
                  _loc4_ = new Array();
                  _loc5_ = 0;
                  while(_loc5_ < _loc1_.visitorInSpot.length)
                  {
                     if(_loc1_.visitorInSpot[_loc5_] == null)
                     {
                        _loc4_.push(_loc5_);
                     }
                     _loc5_++;
                  }
                  if(_loc4_.length > 0)
                  {
                     Utility.shuffle(_loc4_);
                     _loc6_ = _loc4_.shift();
                     _loc1_.visitorInSpot[_loc6_] = this;
                  }
                  else
                  {
                     this._visitTime = 0;
                     this._lastKnownFullBooth.push(_loc1_);
                     gainMood(this.lossMoodValue(_loc1_));
                  }
               }
            }
         }
         else
         {
            this.checkInsideSpot(_loc1_);
            if(this._visitTime > 5)
            {
               _loc7_ = 10 / (this._numberItemBought + 10);
               _loc8_ = (100 - _mood) / 100 * 45;
               _loc9_ = Math.floor(_loc8_ * _loc7_);
               if(Calculate.chance(Math.max(_loc9_,5)))
               {
                  ++this._numberItemBought;
                  gainMood(this.gainedMoodValue(_loc1_) * _loc1_.level);
                  this._visitTime += Math.floor(Math.random() * 3) + 2;
               }
            }
            --this._visitTime;
         }
      }
      
      function additionalRestroomCheck(param1:*) : void
      {
         var _loc2_:* = BuildingData.getCategoryOf(BuildingData.returnClassTo(Utility.getClass(param1)));
         if(_loc2_ == BuildingData.FOOD)
         {
            this._restRoomPercentage += Math.random() * 2.5 + 0.5;
            this._restRoomPercentage = Math.min(this._restRoomPercentage,100);
         }
      }
      
      function gainedMoodValue(param1:*) : Number
      {
         var _loc3_:* = undefined;
         var _loc2_:* = (Math.random() * 3 + 2) / 15;
         if(param1 != null)
         {
            _loc3_ = BuildingData.getMoodGain(BuildingData.returnClassTo(Utility.getClass(param1)));
            return _loc2_ * _loc3_;
         }
         return _loc2_;
      }
      
      function lossMoodValue(param1:*) : Number
      {
         var _loc3_:* = undefined;
         var _loc2_:* = -(Math.random() * 3 + 2) / 5;
         if(param1 != null)
         {
            _loc3_ = BuildingData.getMoodLoss(BuildingData.returnClassTo(Utility.getClass(param1)));
            return _loc2_ * _loc3_;
         }
         return _loc2_;
      }
      
      function visitingProgress() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = _inside;
         if(_inside is FictionalBuilding)
         {
            _loc1_ = _inside;
         }
         if(_destination == null || _destination == _loc1_ || _destination == _inside)
         {
            if(this._visitTime > 0)
            {
               this.checkActivityInsideBuilding();
            }
            else
            {
               if(!(_loc1_ is FacilityTerrace))
               {
                  _loc2_ = _loc1_.visitorInService.indexOf(this);
                  if(_loc2_ in _loc1_.visitorInService)
                  {
                     _loc1_.visitorInService[_loc2_] = null;
                     _loc1_.serviceTimeList[_loc2_] = -1;
                     _loc1_.serviceSpotList[_loc2_].visible = false;
                     this.visible = true;
                  }
               }
               _loc2_ = _loc1_.visitorInSpot.indexOf(this);
               if(_loc2_ in _loc1_.visitorInSpot)
               {
                  _loc1_.visitorInSpot[_loc2_] = null;
                  _loc1_.spotList[_loc2_].visible = false;
                  this.visible = true;
               }
               if(!(_loc1_ is FacilityTerrace))
               {
                  _loc2_ = _loc1_.entryVisitor.indexOf(this);
                  if(_loc2_ in _loc1_.entryVisitor)
                  {
                     _loc1_.entryVisitor.splice(_loc2_,1);
                  }
               }
               if(!this._staying)
               {
                  _destination = "exit";
               }
               else
               {
                  _destination = this.searchPossibleInn();
                  if(_destination == null)
                  {
                     _destination = "home";
                     this._staying = false;
                  }
               }
            }
         }
      }
      
      function meetFriendCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.stage != null)
         {
            if(_inside == null)
            {
               if(this._meetFriend == null)
               {
                  if(this._restRoomPercentage < 70)
                  {
                     _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
                     _loc2_ = 0;
                     while(_loc2_ < this._friendList.length)
                     {
                        _loc3_ = this._friendList[_loc2_];
                        if(_loc3_.stage != null && _loc3_.meetFriend == null && _loc3_.inside == null && !_loc3_.passive)
                        {
                           _loc4_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
                           if(_loc1_.y == _loc4_.y)
                           {
                              if((_loc5_ = Math.abs(_loc1_.x - _loc4_.x)) <= 30 && inSight(_loc3_))
                              {
                                 this._meetFriend = _loc3_;
                                 _loc3_.meetFriend = this;
                                 _world.addConversation(this,_loc3_);
                                 break;
                              }
                           }
                        }
                        _loc2_++;
                     }
                  }
               }
            }
         }
      }
      
      public function set stayingAt(param1:*) : void
      {
         this._stayingAt = param1;
      }
      
      public function get stayingAt() : *
      {
         return this._stayingAt;
      }
      
      public function get destinationTargetList() : Array
      {
         return this._destinationTargetList;
      }
      
      public function get purse() : int
      {
         return this._purse;
      }
      
      public function get initialPurse() : int
      {
         return this._initialPurse;
      }
      
      public function get statification() : int
      {
         return this._statification;
      }
      
      public function set meetFriend(param1:*) : void
      {
         this._meetFriend = param1;
      }
      
      public function get meetFriend() : *
      {
         return this._meetFriend;
      }
      
      public function get friendList() : Array
      {
         return this._friendList;
      }
      
      public function set restRoomTarget(param1:*) : void
      {
         this._restRoomTarget = param1;
      }
      
      public function get restRoomTarget() : *
      {
         return this._restRoomTarget;
      }
      
      public function set tradingPostTarget(param1:*) : void
      {
         this._tradingPostTarget = param1;
      }
      
      public function get tradingPostTarget() : *
      {
         return this._tradingPostTarget;
      }
      
      public function get pastDestination() : *
      {
         return this._pastDestination;
      }
      
      public function get needToGo() : Boolean
      {
         return this._restRoomPercentage >= 85;
      }
      
      public function get gender() : int
      {
         return this._gender;
      }
      
      public function get favoriteList() : Array
      {
         return this._favoriteList;
      }
      
      public function get chatComment() : String
      {
         return this._chatComment;
      }
   }
}
