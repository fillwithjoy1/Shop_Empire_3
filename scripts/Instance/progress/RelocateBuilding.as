package Instance.progress
{
   import Instance.constant.BuildingData;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.modules.Utility;
   import Instance.property.FacilityGuardPost;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class RelocateBuilding extends BuildProgress
   {
       
      
      public function RelocateBuilding()
      {
         super();
      }
      
      override function makeSymbol(param1:String, param2:String) : void
      {
         buildingCategory = BuildingData.getCategoryOf(param1);
         buildSymbol.gotoAndStop(param2);
         var _loc3_:* = buildSymbol.getChildAt(0);
         if(_loc3_ is MovieClip)
         {
            _loc3_.gotoAndStop(_source.level);
         }
         buildSymbol.mouseEnabled = false;
         buildSymbol.mouseChildren = false;
         buildSymbol.alpha = 0.6;
         columnSymbol = new MovieClip();
         var _loc4_:*;
         (_loc4_ = new Column()).gotoAndStop(buildingCategory == BuildingData.INN ? 2 : 1);
         _loc4_.x = -(buildSymbol.width / 2) - _loc4_.width / 2;
         _loc4_.y = buildSymbol.height / 2;
         var _loc5_:*;
         (_loc5_ = new Column()).gotoAndStop(buildingCategory == BuildingData.INN ? 2 : 1);
         _loc5_.x = buildSymbol.width / 2 + _loc5_.width / 2;
         _loc5_.y = buildSymbol.height / 2;
         var _loc6_:*;
         (_loc6_ = buildingCategory == BuildingData.INN ? new FloorBasement() : new FloorUG()).x = 0;
         _loc6_.y = -buildSymbol.height / 2 - 12;
         _loc6_.left = -(buildSymbol.width / 2) - _loc4_.width;
         _loc6_.right = buildSymbol.width / 2 + _loc5_.width;
         columnSymbol.addChild(_loc4_);
         columnSymbol.addChild(_loc5_);
         columnSymbol.addChild(_loc6_);
         columnSymbol.alpha = 0.6;
      }
      
      override public function runProgress() : void
      {
         buildSymbol = new ToBuildSymbol();
         var _loc1_:* = BuildingData.returnClassTo(Utility.getClass(_source));
         var _loc2_:* = BuildingData.getBuildingSymbolOf(_loc1_);
         if(Utility.hasLabel(buildSymbol,_loc2_))
         {
            this.makeSymbol(_loc1_,_loc2_);
            setBuildSymbolPosition();
            placeSymbol();
            _cost = source.relocateCost;
            world.dispatchEvent(new GameEvent(GameEvent.RUN_BUILD_PROGRESS,this));
            world.addListenerOf(buildSymbol,Event.ENTER_FRAME,UpdatePosition);
            world.addListenerOf(world,MouseEvent.CLICK,this.confirmRelocate);
         }
         else
         {
            trace("batalkan");
         }
      }
      
      override function hitOtherBuild(param1:Point) : Boolean
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:* = false;
         var _loc3_:* = param1.x - buildSymbol.width / 2 - 6;
         var _loc4_:* = param1.x + buildSymbol.width / 2 + 6;
         var _loc5_:* = 0;
         while(_loc5_ < _world.buildingList.length)
         {
            if((_loc6_ = _world.buildingList[_loc5_]) != _source)
            {
               if(_loc6_.y == param1.y)
               {
                  if(_source is FacilityGuardPost && _loc6_ is FacilityGuardPost)
                  {
                     _loc2_ = true;
                     break;
                  }
                  _loc7_ = _loc6_.x - _loc6_.width / 2 - 6;
                  _loc8_ = _loc6_.x + _loc6_.width / 2 + 6;
                  if(_loc3_ < _loc8_ && _loc4_ > _loc7_)
                  {
                     _loc2_ = true;
                     break;
                  }
               }
            }
            _loc5_++;
         }
         return _loc2_;
      }
      
      override function updateToBuildInfo() : void
      {
         var _loc1_:* = undefined;
         if(_infoToBuild != null)
         {
            _loc1_ = BuildingData.returnClassTo(Utility.getClass(_source));
            _infoToBuild.buildingName.text = "" + _loc1_ + "";
            _infoToBuild.buildingIcon.gotoAndStop(BuildingData.getIconOf(_loc1_));
            _infoToBuild.buildingCost.text = "Cost: " + Utility.numberToMoney(BuildingData.getRelocateCost(_source)) + " G";
            _infoToBuild.toBuild = this;
            updateBuildComboInfo();
         }
      }
      
      function confirmRelocate(param1:MouseEvent) : void
      {
         var _loc2_:* = _world.mainContainer.globalToLocal(buildSymbol.localToGlobal(new Point(0,buildSymbol.height / 2)));
         if(_world.main.isEnough(_cost))
         {
            _coordinate = _loc2_;
            _flipped = buildSymbol.scaleX;
            _enableToBuild = !checkCollision();
            world.dispatchEvent(new CommandEvent(CommandEvent.DECIDE_RELOCATE,this));
         }
         else
         {
            _world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Not Enough Money"));
         }
      }
      
      override public function stopProgress() : void
      {
         super.stopProgress();
         world.removeListenerOf(world,MouseEvent.CLICK,this.confirmRelocate);
      }
   }
}
