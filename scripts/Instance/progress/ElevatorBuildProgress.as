package Instance.progress
{
   import Instance.constant.BuildingData;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class ElevatorBuildProgress extends BuildProgress
   {
       
      
      var extendSymbol:MovieClip;
      
      public function ElevatorBuildProgress()
      {
         super();
      }
      
      override function makeSymbol(param1:String, param2:String) : void
      {
         super.makeSymbol(param1,param2);
         this.extendSymbol = new ToBuildSymbol();
         this.extendSymbol.gotoAndStop(param2);
         var _loc3_:* = this.extendSymbol.getChildAt(0);
         if(_loc3_ is MovieClip)
         {
            _loc3_.gotoAndStop(1);
         }
         this.extendSymbol.mouseEnabled = false;
         this.extendSymbol.mouseChildren = false;
         this.extendSymbol.alpha = 0.6;
         this.extendSymbol.y = buildSymbol.y - 12 - this.extendSymbol.height;
         var _loc4_:*;
         (_loc4_ = new Column()).gotoAndStop(1);
         _loc4_.x = -(this.extendSymbol.width / 2) - _loc4_.width / 2;
         _loc4_.y = this.extendSymbol.y + this.extendSymbol.height / 2;
         var _loc5_:*;
         (_loc5_ = new Column()).gotoAndStop(1);
         _loc5_.x = this.extendSymbol.width / 2 + _loc4_.width / 2;
         _loc5_.y = this.extendSymbol.y + this.extendSymbol.height / 2;
         var _loc6_:*;
         (_loc6_ = new FloorUG()).x = 0;
         _loc6_.y = this.extendSymbol.y - this.extendSymbol.height / 2 - 12;
         _loc6_.left = -(this.extendSymbol.width / 2) - _loc4_.width;
         _loc6_.right = this.extendSymbol.width / 2 + _loc5_.width;
         columnSymbol.addChild(_loc4_);
         columnSymbol.addChild(_loc5_);
         columnSymbol.addChild(_loc6_);
      }
      
      override function setupCost(param1:String) : void
      {
         _cost = BuildingData.getBuildingCost(param1);
      }
      
      override function placeSymbol() : void
      {
         super.placeSymbol();
         _world.addChild(this.extendSymbol);
      }
      
      override function setBuildSymbolPosition() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.extendSymbol != null)
         {
            _loc1_ = _world.mainContainer.globalToLocal(new Point(_world.stage.mouseX,_world.stage.mouseY));
            _loc2_ = new Point();
            _loc2_.x = Math.round((_loc1_.x - buildSymbol.width / 2) / 12) * 12 + buildSymbol.width / 2;
            _loc2_.y = Math.round((_loc1_.y + buildSymbol.height / 2) / 12) * 12 - buildSymbol.height / 2;
            _loc3_ = _world.globalToLocal(_world.mainContainer.localToGlobal(_loc2_));
            this.extendSymbol.x = _loc3_.x;
            this.extendSymbol.y = _loc3_.y - (buildSymbol.height + 12);
         }
         super.setBuildSymbolPosition();
      }
      
      override function hitOtherBuild(param1:Point) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:* = super.hitOtherBuild(param1);
         if(!_loc2_)
         {
            _loc3_ = _world.mainContainer.globalToLocal(this.extendSymbol.localToGlobal(new Point(0,this.extendSymbol.height / 2)));
            _loc4_ = param1.x - this.extendSymbol.width / 2 - 6;
            _loc5_ = param1.x + this.extendSymbol.width / 2 + 6;
            _loc6_ = 0;
            while(_loc6_ < _world.buildingList.length)
            {
               if((_loc7_ = _world.buildingList[_loc6_]).y == _loc3_.y)
               {
                  _loc8_ = _loc7_.x - _loc7_.width / 2 - 6;
                  _loc9_ = _loc7_.x + _loc7_.width / 2 + 6;
                  if(_loc4_ < _loc9_ && _loc5_ > _loc8_)
                  {
                     _loc2_ = true;
                     break;
                  }
               }
               _loc6_++;
            }
         }
         if(!_loc2_)
         {
            _loc2_ = this.checkHitStair(param1);
         }
         return _loc2_;
      }
      
      function checkHitStair(param1:Point) : Boolean
      {
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc2_:* = false;
         var _loc3_:* = param1.x - buildSymbol.width / 2 - 6;
         var _loc4_:* = param1.x + buildSymbol.width / 2 + 6;
         var _loc5_:* = param1.x - this.extendSymbol.width / 2 - 6;
         var _loc6_:* = param1.x + this.extendSymbol.width / 2 + 6;
         var _loc7_:* = _world.mainContainer.globalToLocal(this.extendSymbol.localToGlobal(new Point(0,this.extendSymbol.height / 2)));
         var _loc8_:* = 0;
         while(_loc8_ < _world.stairList.length)
         {
            _loc10_ = (_loc9_ = _world.stairList[_loc8_]).lowerPosition;
            _loc11_ = _loc9_.upperPosition;
            if(_loc9_.y == param1.y)
            {
               if(_loc10_.x >= _loc3_ && _loc10_.x <= _loc4_ || _loc11_.x >= _loc3_ && _loc11_.x <= _loc4_)
               {
                  _loc2_ = true;
                  break;
               }
            }
            else if(_loc9_.y == _loc7_.y)
            {
               if(_loc10_.x >= _loc5_ && _loc10_.x <= _loc6_ || _loc11_.x >= _loc5_ && _loc11_.x <= _loc6_)
               {
                  _loc2_ = true;
                  break;
               }
            }
            _loc8_++;
         }
         return _loc2_;
      }
      
      override function checkCollision() : Boolean
      {
         var _loc1_:* = super.checkCollision();
         if(!_loc1_)
         {
            this.extendSymbol.transform.colorTransform = new ColorTransform(1,1,1,0.6,0,0,0,0);
         }
         else
         {
            this.extendSymbol.transform.colorTransform = new ColorTransform(1,0.6,0.6,0.6,0,0,0,0);
         }
         return _loc1_;
      }
      
      override public function stopProgress() : void
      {
         super.stopProgress();
         if(this.extendSymbol != null)
         {
            if(world.getChildByName(this.extendSymbol.name))
            {
               world.removeChild(this.extendSymbol);
            }
         }
      }
   }
}
