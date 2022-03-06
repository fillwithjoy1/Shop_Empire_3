package Instance.progress
{
   import Instance.constant.ComboList;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.property.FacilityElevatorBody;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class ExpandElevatorProgress extends BuildProgress
   {
       
      
      var _expandedElevator;
      
      var _toBuildSymbol:Array;
      
      var _toBuildData:Array;
      
      var _expandUp:MovieClip;
      
      var _expandDown:MovieClip;
      
      public function ExpandElevatorProgress()
      {
         super();
         this._toBuildSymbol = new Array();
         this._expandUp = new UI_ExpandElevator();
         this._expandDown = new UI_ExpandElevator();
         this._expandDown.scaleY = -1;
      }
      
      override public function runProgress() : void
      {
         buildSymbol = new MovieClip();
         world.addChild(buildSymbol);
         this.setBuildSymbolPosition();
         this._expandedElevator.canClick = true;
         this._expandUp.x = this._expandedElevator.x;
         this._expandDown.x = this._expandedElevator.x;
         if(this._expandedElevator.highestRoom.y - 84 > -_world.gameHeight)
         {
            this._expandUp.y = this._expandedElevator.highestRoom.y - 84 - 12;
            _world.bonusContainer.addChild(this._expandUp);
         }
         if(this._expandedElevator.lowestRoom.y < 0)
         {
            this._expandDown.y = this._expandedElevator.lowestRoom.y + 12;
            _world.bonusContainer.addChild(this._expandDown);
         }
         world.addListenerOf(buildSymbol,Event.ENTER_FRAME,this.UpdatePosition);
         world.addListenerOf(world.stage,MouseEvent.MOUSE_UP,this.endExpand);
      }
      
      override function UpdatePosition(param1:Event) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         this.setBuildSymbolPosition();
         buildSymbol.graphics.clear();
         buildSymbol.graphics.lineStyle(1.5,39168);
         var _loc2_:* = this._expandedElevator.globalToLocal(new Point(world.stage.mouseX,world.stage.mouseY));
         var _loc3_:* = this._expandedElevator.highestRoom;
         var _loc4_:* = this._expandedElevator.lowestRoom;
         if(_loc2_.y < _loc3_.y - 84)
         {
            _loc5_ = _world.globalToLocal(_loc3_.localToGlobal(new Point(0,-84)));
            this.drawUpperExpandArea(_loc5_);
            this.checkExpansion(_loc5_);
            this._expandedElevator.canClick = false;
         }
         if(_loc2_.y > _loc4_.y)
         {
            _loc6_ = _world.globalToLocal(_loc4_.localToGlobal(new Point(0,0)));
            this.drawLowerExpandArea(_loc6_);
            this.checkExpansion(_loc6_);
            this._expandedElevator.canClick = false;
         }
      }
      
      function checkRoomCollision(param1:*) : Boolean
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc2_:* = false;
         var _loc3_:* = _world.mainContainer.globalToLocal(param1.localToGlobal(new Point(0,0)));
         var _loc4_:* = _loc3_.x - (param1.width - 24) / 2 - 6;
         var _loc5_:* = _loc3_.x + (param1.width - 24) / 2 + 6;
         var _loc6_:* = 0;
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
         if(!_loc2_)
         {
            _loc6_ = 0;
            while(_loc6_ < _world.stairList.length)
            {
               _loc11_ = (_loc10_ = _world.stairList[_loc6_]).lowerPosition;
               _loc12_ = _loc10_.upperPosition;
               if(_loc10_.y == _loc3_.y)
               {
                  if(_loc11_.x >= _loc4_ && _loc11_.x <= _loc5_ || _loc12_.x >= _loc4_ && _loc12_.x <= _loc5_)
                  {
                     _loc2_ = true;
                     break;
                  }
               }
               _loc6_++;
            }
         }
         return _loc2_;
      }
      
      function checkExpansion(param1:Point) : void
      {
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc2_:* = _world.globalToLocal(_world.mainContainer.localToGlobal(new Point(0,0)));
         var _loc3_:* = _world.globalToLocal(_world.mainContainer.localToGlobal(new Point(0,-_world.gameHeight)));
         var _loc4_:* = _world.globalToLocal(new Point(world.stage.mouseX,world.stage.mouseY));
         var _loc5_:*;
         var _loc6_:* = (_loc5_ = Math.abs(param1.y - Math.max(_loc3_.y,Math.min(_loc2_.y,_loc4_.y)))) / (param1.y - Math.max(_loc3_.y,Math.min(_loc2_.y,_loc4_.y)));
         var _loc7_:* = Math.floor(_loc5_ / 84);
         var _loc8_:* = buildSymbol.globalToLocal(_world.localToGlobal(param1));
         while(this._toBuildSymbol.length != _loc7_)
         {
            if(this._toBuildSymbol.length > _loc7_)
            {
               (_loc12_ = this._toBuildSymbol.pop()).parent.removeChild(_loc12_);
            }
            else
            {
               _loc13_ = new MovieClip();
               _loc14_ = new ToBuildSymbol();
               _loc14_.y = -_loc14_.height / 2;
               _loc14_.gotoAndStop("elevator");
               if((_loc15_ = _loc14_.getChildAt(0)) is MovieClip)
               {
                  _loc15_.gotoAndStop(this._expandedElevator.level);
               }
               _loc13_.addChild(_loc14_);
               (_loc16_ = new Column()).gotoAndStop(1);
               _loc16_.x = -(_loc14_.width / 2) - _loc16_.width / 2;
               _loc16_.y = 0;
               _loc13_.addChild(_loc16_);
               (_loc17_ = new Column()).gotoAndStop(1);
               _loc17_.x = _loc14_.width / 2 + _loc17_.width / 2;
               _loc17_.y = 0;
               _loc13_.addChild(_loc17_);
               (_loc18_ = new FloorUG()).x = 0;
               _loc18_.y = -_loc14_.height - 12;
               _loc18_.left = -(_loc14_.width / 2) - _loc16_.width;
               _loc18_.right = _loc14_.width / 2 + _loc17_.width;
               _loc13_.addChild(_loc18_);
               _loc13_.alpha = 0.6;
               buildSymbol.addChild(_loc13_);
               this._toBuildSymbol.push(_loc13_);
            }
         }
         var _loc9_:* = 0;
         var _loc10_:* = false;
         var _loc11_:* = 0;
         while(_loc11_ < this._toBuildSymbol.length)
         {
            (_loc19_ = this._toBuildSymbol[_loc11_]).y = _loc8_.y - _loc19_.height * ((_loc11_ - (_loc6_ - 1) / 2) * _loc6_);
            if(!_loc10_)
            {
               _loc10_ = this.checkRoomCollision(_loc19_);
            }
            if(_loc10_)
            {
               _loc19_.transform.colorTransform = new ColorTransform(1,0.6,0.6,0.6,0,0,0,0);
            }
            else
            {
               _loc9_++;
               _loc19_.transform.colorTransform = new ColorTransform(1,1,1,0.6,0,0,0,0);
            }
            _loc11_++;
         }
         _cost = _loc9_ * this._expandedElevator.EXPAND_COST[this._expandedElevator.level - 1];
         _enableToBuild = _loc9_ > 0;
         if(_loc9_ > 0)
         {
            _world.main.GUI.showToBuildInfo(this);
         }
         else if(_infoToBuild != null)
         {
            if(_world.main.GUI.getChildByName(_infoToBuild.name) != null)
            {
               _world.main.GUI.removeChild(_infoToBuild);
               _infoToBuild = null;
            }
         }
      }
      
      override function updateToBuildInfo() : void
      {
         if(_infoToBuild != null)
         {
            _infoToBuild.buildingName.text = "Elevator";
            _infoToBuild.buildingIcon.gotoAndStop("facility - elevator");
            _infoToBuild.toBuild = this;
            _infoToBuild.buildingCost.text = "Cost: " + _cost + " G";
            this.updateBuildComboInfo();
         }
      }
      
      override function updateBuildComboInfo() : void
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
         if(_infoToBuild != null)
         {
            _loc1_ = this._toBuildSymbol[this._toBuildSymbol.length - 1];
            _loc2_ = _world.mainContainer.globalToLocal(_loc1_.localToGlobal(new Point(0,0)));
            _loc3_ = new FacilityElevatorBody();
            _loc3_.x = _loc2_.x;
            _loc3_.y = _loc2_.y;
            _loc4_ = 0;
            _loc5_ = 0;
            _loc6_ = 0;
            while(_loc6_ < _world.buildingList.length)
            {
               if((_loc7_ = _world.buildingList[_loc6_]).y == _loc3_.y)
               {
                  _loc8_ = Math.abs(_loc3_.x - _loc3_.width / 2 - (_loc7_.x + _loc7_.width / 2));
                  _loc9_ = Math.abs(_loc7_.x - _loc7_.width / 2 - (_loc3_.x + _loc3_.width / 2));
                  if((_loc10_ = Math.round(Math.min(_loc8_,_loc9_) / 12)) <= 5)
                  {
                     _loc11_ = ComboList.checkComboRelation(_loc3_,_loc7_);
                     if(_loc7_.x < _loc3_.x)
                     {
                        _loc4_ += _loc11_;
                     }
                     else if(_loc3_.x < _loc7_.x)
                     {
                        _loc5_ += _loc11_;
                     }
                  }
               }
               _loc6_++;
            }
            _infoToBuild.leftCompatibility.visible = _loc4_ != 0;
            _infoToBuild.leftCompatibility.gotoAndStop(_loc4_ > 0 ? "good" : (_loc4_ < 0 ? "bad" : "unknown"));
            _infoToBuild.rightCompatibility.visible = _loc5_ != 0;
            _infoToBuild.rightCompatibility.gotoAndStop(_loc5_ > 0 ? "good" : (_loc5_ < 0 ? "bad" : "unknown"));
         }
      }
      
      function drawUpperExpandArea(param1:Point) : void
      {
         var _loc2_:* = _world.globalToLocal(new Point(world.stage.mouseX,world.stage.mouseY));
         var _loc3_:* = true;
         var _loc4_:* = _world.globalToLocal(_world.mainContainer.localToGlobal(new Point(0,-_world.gameHeight)));
         var _loc5_:* = Math.max(_loc2_.y,_loc4_.y);
         buildSymbol.graphics.moveTo(-60,param1.y);
         var _loc6_:* = param1.y;
         while(_loc6_ > _loc5_)
         {
            if(_loc3_)
            {
               buildSymbol.graphics.lineTo(-60,Math.max(_loc6_ - 3,_loc5_));
            }
            else
            {
               buildSymbol.graphics.moveTo(-60,Math.max(_loc6_ - 3,_loc5_));
            }
            _loc3_ = !_loc3_;
            _loc6_ -= 3;
         }
         _loc3_ = true;
         buildSymbol.graphics.moveTo(60,param1.y);
         _loc6_ = param1.y;
         while(_loc6_ > _loc2_.y)
         {
            if(_loc3_)
            {
               buildSymbol.graphics.lineTo(60,Math.max(_loc6_ - 3,_loc5_));
            }
            else
            {
               buildSymbol.graphics.moveTo(60,Math.max(_loc6_ - 3,_loc5_));
            }
            _loc3_ = !_loc3_;
            _loc6_ -= 3;
         }
         _loc3_ = true;
         buildSymbol.graphics.moveTo(-60,_loc5_);
         _loc6_ = -60 - 1.5;
         while(_loc6_ < 60 + 1.5)
         {
            if(_loc3_)
            {
               buildSymbol.graphics.lineTo(Math.max(-60,Math.min(_loc6_ + 3,60)),_loc5_);
            }
            else
            {
               buildSymbol.graphics.moveTo(Math.max(-60,Math.min(_loc6_ + 3,60)),_loc5_);
            }
            _loc3_ = !_loc3_;
            _loc6_ += 3;
         }
      }
      
      function drawLowerExpandArea(param1:Point) : void
      {
         var _loc2_:* = _world.globalToLocal(new Point(world.stage.mouseX,world.stage.mouseY));
         var _loc3_:* = true;
         var _loc4_:* = _world.globalToLocal(_world.mainContainer.localToGlobal(new Point(0,0)));
         var _loc5_:* = Math.min(_loc2_.y,_loc4_.y);
         buildSymbol.graphics.moveTo(-60,param1.y);
         var _loc6_:* = param1.y;
         while(_loc6_ < _loc5_)
         {
            if(_loc3_)
            {
               buildSymbol.graphics.lineTo(-60,Math.min(_loc6_ + 3,_loc5_));
            }
            else
            {
               buildSymbol.graphics.moveTo(-60,Math.min(_loc6_ + 3,_loc5_));
            }
            _loc3_ = !_loc3_;
            _loc6_ += 3;
         }
         _loc3_ = true;
         buildSymbol.graphics.moveTo(60,param1.y);
         _loc6_ = param1.y;
         while(_loc6_ < _loc5_)
         {
            if(_loc3_)
            {
               buildSymbol.graphics.lineTo(60,Math.min(_loc6_ + 3,_loc5_));
            }
            else
            {
               buildSymbol.graphics.moveTo(60,Math.min(_loc6_ + 3,_loc5_));
            }
            _loc3_ = !_loc3_;
            _loc6_ += 3;
         }
         _loc3_ = true;
         buildSymbol.graphics.moveTo(-60,_loc5_);
         _loc6_ = -60 - 1.5;
         while(_loc6_ < 60 + 1.5)
         {
            if(_loc3_)
            {
               buildSymbol.graphics.lineTo(Math.max(-60,Math.min(_loc6_ + 3,60)),_loc5_);
            }
            else
            {
               buildSymbol.graphics.moveTo(Math.max(-60,Math.min(_loc6_ + 3,60)),_loc5_);
            }
            _loc3_ = !_loc3_;
            _loc6_ += 3;
         }
      }
      
      override function setBuildSymbolPosition() : void
      {
         var _loc1_:* = _world.globalToLocal(this._expandedElevator.localToGlobal(new Point(0,0)));
         buildSymbol.x = _loc1_.x;
         buildSymbol.y = 0;
      }
      
      function endExpand(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(_world.main.isEnough(_cost))
         {
            this._toBuildData = new Array();
            _loc2_ = 0;
            while(_loc2_ < this._toBuildSymbol.length)
            {
               _loc3_ = this._toBuildSymbol[_loc2_];
               if(this.checkRoomCollision(_loc3_))
               {
                  break;
               }
               _loc4_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
               (_loc5_ = new Object()).coordinate = _loc4_;
               this._toBuildData.push(_loc5_);
               _loc2_++;
            }
            _world.dispatchEvent(new CommandEvent(CommandEvent.CONFIRM_EXPAND,this));
            this._expandedElevator.setUpgradeCost();
         }
         else
         {
            _world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Not Enough Money"));
         }
         if(this._expandUp.parent != null)
         {
            this._expandUp.parent.removeChild(this._expandUp);
         }
         if(this._expandDown.parent != null)
         {
            this._expandDown.parent.removeChild(this._expandDown);
         }
         this.stopProgress();
      }
      
      override public function stopProgress() : void
      {
         super.stopProgress();
         world.removeListenerOf(world.stage,MouseEvent.MOUSE_UP,this.endExpand);
         world.dispatchEvent(new CommandEvent(CommandEvent.FINISH_EXPAND));
      }
      
      public function set expandedElavator(param1:*) : void
      {
         this._expandedElevator = param1;
      }
      
      public function get expandedElavator() : *
      {
         return this._expandedElevator;
      }
      
      public function get toBuildData() : Array
      {
         return this._toBuildData;
      }
   }
}
