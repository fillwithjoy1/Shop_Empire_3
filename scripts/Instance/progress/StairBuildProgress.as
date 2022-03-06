package Instance.progress
{
   import Instance.constant.BuildingData;
   import Instance.property.FacilityElevatorBody;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class StairBuildProgress extends BuildProgress
   {
       
      
      var bottomPos:Rectangle;
      
      var upperPos:Rectangle;
      
      public function StairBuildProgress()
      {
         super();
      }
      
      override function makeSymbol(param1:String, param2:String) : void
      {
         buildingCategory = BuildingData.getCategoryOf(param1);
         buildSymbol.gotoAndStop(param2);
         buildSymbol.mouseEnabled = false;
         buildSymbol.mouseChildren = false;
         buildSymbol.alpha = 0.6;
         this.bottomPos = new Rectangle();
         this.bottomPos.x = buildSymbol.width / 2 - 12;
         this.bottomPos.y = buildSymbol.height / 2 - 12;
         this.bottomPos.width = 12;
         this.bottomPos.height = 12;
         this.upperPos = new Rectangle();
         this.upperPos.x = -buildSymbol.width / 2;
         this.upperPos.y = buildSymbol.height / 2 - 96;
         this.upperPos.width = 12;
         this.upperPos.height = 12;
      }
      
      override function placeSymbol() : void
      {
         world.addChild(buildSymbol);
      }
      
      override function setBuildSymbolPosition() : void
      {
         var _loc1_:* = _world.mainContainer.globalToLocal(new Point(_world.stage.mouseX,_world.stage.mouseY));
         var _loc2_:* = new Point();
         _loc2_.x = Math.round((_loc1_.x - buildSymbol.width / 2) / 12) * 12 + buildSymbol.width / 2;
         _loc2_.y = Math.round((_loc1_.y + buildSymbol.height / 2) / 12) * 12 - buildSymbol.height / 2;
         var _loc3_:* = _world.globalToLocal(_world.mainContainer.localToGlobal(_loc2_));
         buildSymbol.x = _loc3_.x;
         buildSymbol.y = _loc3_.y;
         this.checkCollision();
      }
      
      function inFloorPosition(param1:*) : Boolean
      {
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
         var _loc2_:* = false;
         var _loc3_:* = _world.floorList.indexOf(param1);
         if(_loc3_ + 1 in _world.floorList)
         {
            _loc4_ = _world.floorList[_loc3_ + 1];
            _loc5_ = _world.mainContainer.globalToLocal(buildSymbol.localToGlobal(new Point(this.bottomPos.x,this.bottomPos.y)));
            _loc6_ = _world.mainContainer.globalToLocal(buildSymbol.localToGlobal(new Point(this.bottomPos.x + this.bottomPos.width,this.bottomPos.y)));
            _loc7_ = _world.mainContainer.globalToLocal(buildSymbol.localToGlobal(new Point(this.upperPos.x,this.upperPos.y)));
            _loc8_ = _world.mainContainer.globalToLocal(buildSymbol.localToGlobal(new Point(this.upperPos.x + this.upperPos.width,this.bottomPos.y)));
            _loc9_ = Math.min(_loc5_.x,_loc6_.x);
            _loc10_ = Math.max(_loc5_.x,_loc6_.x);
            _loc11_ = Math.min(_loc7_.x,_loc8_.x);
            _loc12_ = Math.max(_loc7_.x,_loc8_.x);
            _loc13_ = _loc9_ >= param1.left && _loc10_ <= param1.right;
            _loc14_ = _loc11_ >= _loc4_.left && _loc12_ <= _loc4_.right;
            _loc2_ = _loc13_ && _loc14_;
         }
         return _loc2_;
      }
      
      override function hitOtherBuild(param1:Point) : Boolean
      {
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc2_:* = false;
         var _loc3_:* = new Point();
         _loc3_.x = -(buildSymbol.width - 24) / 2;
         _loc3_.y = buildSymbol.height / 2 - 84;
         var _loc4_:* = _world.mainContainer.globalToLocal(buildSymbol.localToGlobal(_loc3_));
         var _loc5_:*;
         (_loc5_ = new Point()).x = (buildSymbol.width - 24) / 2;
         _loc5_.y = buildSymbol.height / 2;
         var _loc6_:* = _world.mainContainer.globalToLocal(buildSymbol.localToGlobal(_loc5_));
         var _loc7_:* = 0;
         while(_loc7_ < _world.stairList.length)
         {
            if((_loc8_ = _world.stairList[_loc7_]).y == param1.y)
            {
               _loc9_ = _loc8_.lowerPosition;
               _loc10_ = _loc8_.upperPosition;
               _loc11_ = Math.abs(_loc10_.x - _loc4_.x) / 12;
               _loc12_ = Math.abs(_loc9_.x - _loc6_.x) / 12;
               if(_loc11_ <= 1 || _loc12_ <= 1)
               {
                  _loc2_ = true;
                  break;
               }
            }
            _loc7_++;
         }
         if(!_loc2_)
         {
            _loc7_ = 0;
            while(_loc7_ < _world.buildingList.length)
            {
               if((_loc13_ = _world.buildingList[_loc7_]) is FacilityElevatorBody)
               {
                  if(param1.y == _loc13_.y)
                  {
                     _loc14_ = _loc13_.x - _loc13_.width / 2 - 6;
                     _loc15_ = _loc13_.x + _loc13_.width / 2 + 6;
                     if(_loc6_.x >= _loc14_ && _loc6_.x <= _loc15_ || _loc4_.x >= _loc14_ && _loc4_.x <= _loc15_)
                     {
                        _loc2_ = true;
                        break;
                     }
                  }
               }
               _loc7_++;
            }
         }
         return _loc2_;
      }
      
      override function checkCollision() : Boolean
      {
         var _loc5_:* = undefined;
         var _loc1_:* = _world.mainContainer.globalToLocal(buildSymbol.localToGlobal(new Point(0,buildSymbol.height / 2)));
         var _loc2_:* = null;
         var _loc3_:* = 0;
         while(_loc3_ < world.floorList.length)
         {
            _loc5_ = world.floorList[_loc3_];
            if(_loc1_.y == _loc5_.y)
            {
               if(_loc3_ + 1 in world.floorList)
               {
                  _loc2_ = _loc5_;
               }
               break;
            }
            _loc3_++;
         }
         var _loc4_:* = false;
         if(_loc2_ != null)
         {
            if(this.inFloorPosition(_loc2_))
            {
               _loc4_ = !this.hitOtherBuild(_loc1_);
            }
         }
         if(_loc4_)
         {
            buildSymbol.transform.colorTransform = new ColorTransform(1,1,1,0.6,0,0,0,0);
         }
         else
         {
            buildSymbol.transform.colorTransform = new ColorTransform(1,0.6,0.6,0.6,0,0,0,0);
         }
         return !_loc4_;
      }
      
      override public function flipBuilding() : void
      {
         buildSymbol.scaleX *= -1;
      }
   }
}
