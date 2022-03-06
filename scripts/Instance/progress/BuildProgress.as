package Instance.progress
{
   import Instance.constant.BuildingData;
   import Instance.constant.ComboList;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.gameplay.World;
   import Instance.modules.Utility;
   import Instance.property.FacilityGuardPost;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class BuildProgress
   {
       
      
      var _world:World;
      
      var _source;
      
      var buildSymbol:MovieClip;
      
      var columnSymbol:MovieClip;
      
      var elevatorBuildSymbol:MovieClip;
      
      var buildingCategory;
      
      var _type:String;
      
      var _coordinate:Point;
      
      var _enableToBuild:Boolean;
      
      var _validToBuild:Boolean;
      
      var _flipped:int;
      
      var _infoToBuild;
      
      var _cost:int;
      
      public function BuildProgress()
      {
         super();
         this._cost = 0;
      }
      
      function makeSymbol(param1:String, param2:String) : void
      {
         this.buildingCategory = BuildingData.getCategoryOf(param1);
         this.buildSymbol.gotoAndStop(param2);
         var _loc3_:* = this.buildSymbol.getChildAt(0);
         if(_loc3_ is MovieClip)
         {
            _loc3_.gotoAndStop(1);
         }
         this.buildSymbol.mouseEnabled = false;
         this.buildSymbol.mouseChildren = false;
         this.buildSymbol.alpha = 0.6;
         this.columnSymbol = new MovieClip();
         var _loc4_:*;
         (_loc4_ = new Column()).gotoAndStop(this.buildingCategory == BuildingData.INN ? 2 : 1);
         _loc4_.x = -(this.buildSymbol.width / 2) - _loc4_.width / 2;
         _loc4_.y = this.buildSymbol.height / 2;
         var _loc5_:*;
         (_loc5_ = new Column()).gotoAndStop(this.buildingCategory == BuildingData.INN ? 2 : 1);
         _loc5_.x = this.buildSymbol.width / 2 + _loc5_.width / 2;
         _loc5_.y = this.buildSymbol.height / 2;
         var _loc6_:*;
         (_loc6_ = this.buildingCategory == BuildingData.INN ? new FloorBasement() : new FloorUG()).x = 0;
         _loc6_.y = -this.buildSymbol.height / 2 - 12;
         _loc6_.left = -(this.buildSymbol.width / 2) - _loc4_.width;
         _loc6_.right = this.buildSymbol.width / 2 + _loc5_.width;
         this.columnSymbol.addChild(_loc4_);
         this.columnSymbol.addChild(_loc5_);
         this.columnSymbol.addChild(_loc6_);
         this.columnSymbol.alpha = 0.6;
      }
      
      function placeSymbol() : void
      {
         this._world.addChild(this.buildSymbol);
         this._world.addChild(this.columnSymbol);
      }
      
      public function runProgress() : void
      {
         this.buildSymbol = new ToBuildSymbol();
         var _loc1_:* = BuildingData.returnIconTo(this._source.icon);
         var _loc2_:* = BuildingData.getBuildingSymbolOf(_loc1_);
         if(Utility.hasLabel(this.buildSymbol,_loc2_))
         {
            this.makeSymbol(_loc1_,_loc2_);
            this.setBuildSymbolPosition();
            this.placeSymbol();
            this.setupCost(_loc1_);
            this._world.dispatchEvent(new GameEvent(GameEvent.RUN_BUILD_PROGRESS,this));
            this._world.addListenerOf(this.buildSymbol,Event.ENTER_FRAME,this.UpdatePosition);
            this._world.addListenerOf(this._world,MouseEvent.CLICK,this.confirmBuild);
         }
         else
         {
            trace("batalkan");
         }
      }
      
      function setupCost(param1:String) : void
      {
         this._cost = BuildingData.getBuildingCost(param1);
      }
      
      function UpdatePosition(param1:Event) : void
      {
         this.setBuildSymbolPosition();
         this.updateBuildComboInfo();
      }
      
      function confirmBuild(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = BuildingData.returnBuildingSymbolTo(this.buildSymbol.currentFrameLabel);
         if(this._world.main.isEnough(this.cost))
         {
            _loc3_ = this._world.mainContainer.globalToLocal(this.buildSymbol.localToGlobal(new Point(0,this.buildSymbol.height / 2)));
            this._type = _loc2_;
            this._coordinate = _loc3_;
            this._flipped = this.buildSymbol.scaleX;
            this._enableToBuild = !this.checkCollision();
            this._world.dispatchEvent(new CommandEvent(CommandEvent.DECIDE_BUILD,this));
         }
         else
         {
            this._world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Not Enough Money"));
         }
      }
      
      function setBuildSymbolPosition() : void
      {
         var _loc1_:* = this._world.mainContainer.globalToLocal(new Point(this._world.stage.mouseX,this._world.stage.mouseY));
         var _loc2_:* = new Point();
         _loc2_.x = Math.round((_loc1_.x - this.buildSymbol.width / 2) / 12) * 12 + this.buildSymbol.width / 2;
         _loc2_.y = Math.round((_loc1_.y + this.buildSymbol.height / 2) / 12) * 12 - this.buildSymbol.height / 2;
         var _loc3_:* = this._world.globalToLocal(this._world.mainContainer.localToGlobal(_loc2_));
         this.buildSymbol.x = _loc3_.x;
         this.buildSymbol.y = _loc3_.y;
         this.columnSymbol.x = this.buildSymbol.x;
         this.columnSymbol.y = this.buildSymbol.y;
         this._validToBuild = !this.checkCollision();
      }
      
      function hitOtherBuild(param1:Point) : Boolean
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:* = false;
         var _loc3_:* = param1.x - this.buildSymbol.width / 2 - 6;
         var _loc4_:* = param1.x + this.buildSymbol.width / 2 + 6;
         var _loc5_:* = BuildingData.returnBuildingSymbolTo(this.buildSymbol.currentFrameLabel);
         var _loc6_:* = 0;
         while(_loc6_ < this._world.buildingList.length)
         {
            if((_loc7_ = this._world.buildingList[_loc6_]).y == param1.y)
            {
               if(_loc5_ == "Guard Post" && _loc7_ is FacilityGuardPost)
               {
                  _loc2_ = true;
                  break;
               }
               _loc8_ = _loc7_.x - _loc7_.width / 2 - 6;
               _loc9_ = _loc7_.x + _loc7_.width / 2 + 6;
               if(_loc3_ < _loc9_ && _loc4_ > _loc8_)
               {
                  _loc2_ = true;
                  break;
               }
            }
            _loc6_++;
         }
         return _loc2_;
      }
      
      function checkCollision() : Boolean
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc1_:* = this._world.mainContainer.globalToLocal(this.buildSymbol.localToGlobal(new Point(0,this.buildSymbol.height / 2)));
         var _loc2_:* = null;
         if(this.buildingCategory != BuildingData.INN)
         {
            _loc4_ = 0;
            while(_loc4_ < this.world.floorList.length)
            {
               _loc5_ = this.world.floorList[_loc4_];
               if(_loc1_.y == _loc5_.y)
               {
                  _loc2_ = _loc5_;
                  break;
               }
               _loc4_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < this.world.basementFloorList.length)
            {
               if((_loc6_ = this.world.basementFloorList[_loc4_]) != this.world.topFloorBasement)
               {
                  if(_loc1_.y == _loc6_.y)
                  {
                     _loc2_ = _loc6_;
                     break;
                  }
               }
               _loc4_++;
            }
         }
         var _loc3_:* = false;
         if(_loc2_ != null)
         {
            if(_loc1_.x - this.columnSymbol.width / 2 >= this._world.mostLeft + 108 && _loc1_.x + this.columnSymbol.width / 2 <= this._world.mostRight - 108)
            {
               if(_loc1_.x - this.columnSymbol.width / 2 >= _loc2_.left && _loc1_.x + this.columnSymbol.width / 2 <= _loc2_.right)
               {
                  _loc3_ = !this.hitOtherBuild(_loc1_);
               }
            }
         }
         if(_loc3_)
         {
            this.buildSymbol.transform.colorTransform = new ColorTransform(1,1,1,0.6,0,0,0,0);
            this.columnSymbol.transform.colorTransform = new ColorTransform(1,1,1,0.6,0,0,0,0);
         }
         else
         {
            this.buildSymbol.transform.colorTransform = new ColorTransform(1,0.6,0.6,0.6,0,0,0,0);
            this.columnSymbol.transform.colorTransform = new ColorTransform(1,0.6,0.6,0.6,0,0,0,0);
         }
         return !_loc3_;
      }
      
      public function stopProgress() : void
      {
         if(this.buildSymbol != null)
         {
            this.world.removeListenerOf(this.buildSymbol,Event.ENTER_FRAME,this.UpdatePosition);
            if(this.world.getChildByName(this.buildSymbol.name))
            {
               this.world.removeChild(this.buildSymbol);
            }
         }
         if(this.columnSymbol != null)
         {
            if(this.world.getChildByName(this.columnSymbol.name))
            {
               this.world.removeChild(this.columnSymbol);
            }
         }
         if(this._infoToBuild != null)
         {
            if(this._infoToBuild.stage != null)
            {
               this._infoToBuild.parent.removeChild(this._infoToBuild);
            }
         }
         this.world.removeListenerOf(this.world,MouseEvent.CLICK,this.confirmBuild);
      }
      
      public function flipBuilding() : void
      {
      }
      
      function updateToBuildInfo() : void
      {
         if(this._infoToBuild != null)
         {
            this._infoToBuild.buildingName.text = "" + BuildingData.returnIconTo(this._source.icon) + "";
            this._infoToBuild.buildingIcon.gotoAndStop(this._source.icon);
            this._infoToBuild.toBuild = this;
            this._infoToBuild.buildingCost.text = "Cost: " + this._cost + " G";
            this.updateBuildComboInfo();
         }
      }
      
      function updateBuildComboInfo() : void
      {
         var _loc1_:* = undefined;
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
         var _loc13_:* = undefined;
         if(this._infoToBuild != null)
         {
            if(this._validToBuild)
            {
               _loc1_ = BuildingData.returnBuildingSymbolTo(this.buildSymbol.currentFrameLabel);
               _loc2_ = this._world.mainContainer.globalToLocal(this.buildSymbol.localToGlobal(new Point(0,this.buildSymbol.height / 2)));
               _loc3_ = 0;
               _loc4_ = 0;
               _loc5_ = 0;
               while(_loc5_ < this._world.buildingList.length)
               {
                  _loc6_ = this._world.buildingList[_loc5_];
                  _loc7_ = BuildingData.returnClassTo(Utility.getClass(_loc6_));
                  if(_loc6_.y == _loc2_.y)
                  {
                     _loc8_ = Math.abs(_loc2_.x - this.buildSymbol.width / 2 - (_loc6_.x + _loc6_.rWidth / 2));
                     _loc9_ = Math.abs(_loc6_.x - _loc6_.rWidth / 2 - (_loc2_.x + this.buildSymbol.width / 2));
                     if((_loc10_ = Math.round(Math.min(_loc8_,_loc9_) / 12)) <= 5)
                     {
                        _loc11_ = false;
                        if((_loc12_ = this._world.getComboIndex(_loc1_,_loc7_)) != null)
                        {
                           if(_loc12_.goodRelation)
                           {
                              _loc11_ = this._world.combination.good[_loc12_.index].unlocked;
                           }
                           else
                           {
                              _loc11_ = this._world.combination.bad[_loc12_.index].unlocked;
                           }
                        }
                        if(_loc11_)
                        {
                           _loc13_ = ComboList.checkComboType(_loc1_,_loc7_);
                           if(_loc6_.x < _loc2_.x)
                           {
                              _loc3_ += _loc13_;
                           }
                           else if(_loc2_.x < _loc6_.x)
                           {
                              _loc4_ += _loc13_;
                           }
                        }
                     }
                  }
                  _loc5_++;
               }
               this._infoToBuild.leftCompatibility.visible = _loc3_ != 0;
               this._infoToBuild.leftCompatibility.gotoAndStop(_loc3_ > 0 ? "good" : (_loc3_ < 0 ? "bad" : "unknown"));
               this._infoToBuild.rightCompatibility.visible = _loc4_ != 0;
               this._infoToBuild.rightCompatibility.gotoAndStop(_loc4_ > 0 ? "good" : (_loc4_ < 0 ? "bad" : "unknown"));
            }
            else
            {
               this._infoToBuild.leftCompatibility.visible = false;
               this._infoToBuild.rightCompatibility.visible = false;
            }
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
      
      public function set source(param1:*) : void
      {
         this._source = param1;
      }
      
      public function get source() : *
      {
         return this._source;
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function get coordinate() : Point
      {
         return this._coordinate;
      }
      
      public function get enableToBuild() : Boolean
      {
         return this._enableToBuild;
      }
      
      public function get flipped() : int
      {
         return this._flipped;
      }
      
      public function set infoToBuild(param1:*) : void
      {
         this._infoToBuild = param1;
         this.updateToBuildInfo();
      }
      
      public function get infoToBuild() : *
      {
         return this._infoToBuild;
      }
      
      public function set cost(param1:int) : void
      {
         this._cost = param1;
      }
      
      public function get cost() : int
      {
         return this._cost;
      }
   }
}
