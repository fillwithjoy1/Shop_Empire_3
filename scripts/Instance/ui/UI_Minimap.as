package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.GameEvent;
   import Instance.gameplay.World;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityStairs;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class UI_Minimap extends SEMovieClip
   {
       
      
      var _world:World;
      
      var drawArea:MovieClip;
      
      var frameArea:Shape;
      
      var framePos:Point;
      
      var framePos2:Point;
      
      var drawnFloorList:Array;
      
      var drawnBasementList:Array;
      
      var drawnElevatorList:Array;
      
      var drawnBuildingList:Array;
      
      var ground:Shape;
      
      var floorContainer:MovieClip;
      
      var buildingContainer:MovieClip;
      
      var elevatorContainer:MovieClip;
      
      var stairContainer:MovieClip;
      
      var humanContainer:MovieClip;
      
      public function UI_Minimap()
      {
         super();
         this.drawArea = new MovieClip();
         this.frameArea = new Shape();
         this.framePos = new Point(0,0);
         this.framePos2 = new Point(0,0);
         this.drawArea.y = 71 - 27;
         addChild(this.drawArea);
         this.frameArea.y = 71 - 27;
         addChild(this.frameArea);
         this.drawnFloorList = new Array();
         this.drawnBasementList = new Array();
         this.drawnElevatorList = new Array();
         this.drawnBuildingList = new Array();
         this.floorContainer = new MovieClip();
         this.buildingContainer = new MovieClip();
         this.elevatorContainer = new MovieClip();
         this.stairContainer = new MovieClip();
         this.humanContainer = new MovieClip();
         this.floorContainer.alpha = 0.8;
         this.elevatorContainer.alpha = 0.8;
         this.buildingContainer.alpha = 0.8;
         this.stairContainer.alpha = 0.8;
         this.humanContainer.alpha = 0.8;
         this.ground = new Shape();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.drawArea.addChild(this.floorContainer);
         this.drawArea.addChild(this.elevatorContainer);
         this.drawArea.addChild(this.buildingContainer);
         this.drawArea.addChild(this.stairContainer);
         this.drawArea.addChild(this.humanContainer);
         this.drawArea.addChild(this.ground);
         this.checkDrawnThing();
         addListenerOf(this,MouseEvent.MOUSE_DOWN,this.SetFocus);
         addListenerOf(this,Event.ENTER_FRAME,this.updateFrame);
         addListenerOf(stage,GameEvent.BUILDING_CREATED,this.checkBuildingCreated);
         addListenerOf(stage,GameEvent.BUILDING_DESTROYED,this.checkBuildingDestroyed);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.tick);
      }
      
      function tick(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         this.humanContainer.graphics.clear();
         var _loc2_:* = 0;
         while(_loc2_ < this._world.humanList.length)
         {
            _loc3_ = this._world.humanList[_loc2_];
            if(_loc3_.visible && (_loc3_.inside == null || _loc3_.inside is FacilityElevatorBody || this._world.transportList.indexOf(_loc3_.inside) >= 0))
            {
               _loc4_ = new Point();
               _loc5_ = this._world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
               _loc4_.x = Math.round(_loc5_.x / 12);
               _loc4_.y = Math.round(_loc5_.y / 12);
               _loc6_ = 2;
               _loc7_ = 3;
               this.humanContainer.graphics.beginFill(16777215);
               this.humanContainer.graphics.drawRoundRect(_loc4_.x - _loc6_ / 2,_loc4_.y - _loc7_,_loc6_,_loc7_,2,1);
               this.humanContainer.graphics.endFill();
            }
            _loc2_++;
         }
      }
      
      override protected function Removed(param1:Event) : void
      {
         super.Removed(param1);
         while(this.drawArea.numChildren > 0)
         {
            this.drawArea.removeChildAt(0);
         }
      }
      
      function checkDrawnThing() : void
      {
         this.floorCheck();
         this.basementCheck();
         this.initBuildingDraw();
         this.groundCheck();
      }
      
      function checkBuildingCreated(param1:GameEvent) : void
      {
         this.floorCheck();
         this.basementCheck();
         if(!(param1.tag is FacilityStairs))
         {
            this.buildingCreated(param1.tag);
         }
         else
         {
            this.stairCreated(param1.tag);
         }
      }
      
      function checkBuildingDestroyed(param1:GameEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:int = -1;
         var _loc3_:* = 0;
         while(_loc3_ < this.drawnBuildingList.length)
         {
            if((_loc4_ = this.drawnBuildingList[_loc3_]).related == param1.tag)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ in this.drawnBuildingList)
         {
            _loc5_ = this.drawnBuildingList[_loc2_].shape;
            if(this.buildingContainer.getChildByName(_loc5_.name))
            {
               this.buildingContainer.removeChild(_loc5_);
            }
            if(this.stairContainer.getChildByName(_loc5_.name))
            {
               this.stairContainer.removeChild(_loc5_);
            }
            this.drawnBuildingList.splice(_loc2_,1);
            if(param1.tag is FacilityElevatorBody)
            {
               if((_loc6_ = param1.tag.elevatorLink) != null)
               {
                  this.destroyElevator(_loc6_);
               }
            }
         }
      }
      
      function destroyElevator(param1:*) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:int = -1;
         var _loc3_:* = 0;
         while(_loc3_ < this.drawnElevatorList.length)
         {
            if((_loc4_ = this.drawnElevatorList[_loc3_]).related == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ in this.drawnElevatorList)
         {
            _loc5_ = this.drawnElevatorList[_loc2_].shape;
            trace(param1.bodyList.length);
            if(param1.bodyList.length > 0)
            {
               this.drawElevatorOnShape(param1,_loc5_);
            }
            else
            {
               if(this.elevatorContainer.getChildByName(_loc5_.name))
               {
                  trace("hancurkan");
                  this.elevatorContainer.removeChild(_loc5_);
               }
               this.drawnElevatorList.splice(_loc2_,1);
            }
         }
      }
      
      function groundCheck() : void
      {
         this.ground.graphics.clear();
         this.ground.graphics.beginFill(6829577);
         this.ground.graphics.drawRect(-112,0,224,3);
         this.ground.graphics.endFill();
      }
      
      function initBuildingDraw() : void
      {
         var _loc2_:* = undefined;
         while(this.buildingContainer.numChildren > 0)
         {
            this.buildingContainer.removeChildAt(0);
         }
         while(this.drawnBuildingList.length > 0)
         {
            this.drawnBuildingList.shift();
         }
         var _loc1_:* = 0;
         while(_loc1_ < this._world.buildingList.length)
         {
            _loc2_ = this._world.buildingList[_loc1_];
            this.buildingCreated(_loc2_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._world.stairList.length)
         {
            _loc2_ = this._world.stairList[_loc1_];
            this.stairCreated(_loc2_);
            _loc1_++;
         }
      }
      
      function buildingCreated(param1:*) : void
      {
         var _loc2_:* = new Shape();
         var _loc3_:* = param1;
         var _loc4_:* = this._world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
         var _loc5_:*;
         (_loc5_ = new Point()).x = Math.round(_loc4_.x / 12);
         _loc5_.y = Math.round(_loc4_.y / 12);
         var _loc6_:* = Math.round(_loc3_.width / 12);
         var _loc7_:* = Math.round(_loc3_.height / 12);
         _loc2_.x = _loc5_.x;
         _loc2_.y = _loc5_.y;
         _loc2_.graphics.beginFill(4878299);
         _loc2_.graphics.drawRect(-_loc6_ / 2,-_loc7_,_loc6_,_loc7_);
         _loc2_.graphics.endFill();
         this.buildingContainer.addChild(_loc2_);
         var _loc8_:*;
         (_loc8_ = new Object()).shape = _loc2_;
         _loc8_.related = _loc3_;
         this.drawnBuildingList.push(_loc8_);
         if(_loc3_ is FacilityElevatorBody)
         {
            if(_loc3_.elevatorLink != null)
            {
               this.elevatorExpand(_loc3_.elevatorLink);
            }
         }
      }
      
      function stairCreated(param1:*) : void
      {
         var _loc2_:* = new Shape();
         var _loc3_:* = param1;
         var _loc4_:* = new Point();
         var _loc5_:* = new Point();
         var _loc6_:* = _loc3_.lowerPosition;
         var _loc7_:* = _loc3_.upperPosition;
         _loc4_.x = Math.round(_loc6_.x / 12);
         _loc4_.y = Math.round(_loc6_.y / 12);
         _loc5_.x = Math.round(_loc7_.x / 12);
         _loc5_.y = Math.round(_loc7_.y / 12);
         _loc2_.graphics.beginFill(8539671);
         _loc2_.graphics.moveTo(_loc4_.x - 1,_loc4_.y);
         _loc2_.graphics.lineTo(_loc5_.x - 1,_loc5_.y);
         _loc2_.graphics.lineTo(_loc5_.x + 1,_loc5_.y);
         _loc2_.graphics.lineTo(_loc4_.x + 1,_loc4_.y);
         _loc2_.graphics.endFill();
         this.stairContainer.addChild(_loc2_);
         var _loc8_:*;
         (_loc8_ = new Object()).shape = _loc2_;
         _loc8_.related = _loc3_;
         this.drawnBuildingList.push(_loc8_);
      }
      
      function elevatorExpand(param1:*) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = -1;
         var _loc3_:* = 0;
         while(_loc3_ < this.drawnElevatorList.length)
         {
            if((_loc4_ = this.drawnElevatorList[_loc3_]).related == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
            _loc3_++;
         }
         if(_loc2_ in this.drawnElevatorList)
         {
            _loc5_ = this.drawnElevatorList[_loc2_].shape;
            this.drawElevatorOnShape(param1,_loc5_);
         }
         else
         {
            this.elevatorCreated(param1);
         }
      }
      
      function drawElevatorOnShape(param1:*, param2:*) : void
      {
         var _loc3_:* = param1;
         var _loc4_:* = (_loc3_.highestRoom.y - 84) / 12;
         var _loc5_:* = _loc3_.lowestRoom.y / 12;
         var _loc6_:* = this._world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
         var _loc7_:*;
         (_loc7_ = new Point()).x = Math.round(_loc6_.x / 12);
         param2.x = _loc7_.x;
         param2.graphics.clear();
         param2.graphics.beginFill(8539671);
         param2.graphics.drawRect(-5,_loc4_,10,_loc5_ - _loc4_);
         param2.graphics.endFill();
      }
      
      function elevatorCreated(param1:*) : void
      {
         var _loc2_:* = new Shape();
         this.drawElevatorOnShape(param1,_loc2_);
         this.elevatorContainer.addChild(_loc2_);
         var _loc3_:* = new Object();
         _loc3_.shape = _loc2_;
         _loc3_.related = param1;
         this.drawnElevatorList.push(_loc3_);
      }
      
      function floorCheck() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._world.floorList.length)
         {
            _loc2_ = new Shape();
            if(_loc1_ in this.drawnFloorList)
            {
               _loc2_ = this.drawnFloorList[_loc1_];
            }
            else
            {
               this.drawnFloorList.push(_loc2_);
               this.floorContainer.addChild(_loc2_);
            }
            if(_loc1_ > 0)
            {
               _loc3_ = this._world.floorList[_loc1_];
               _loc4_ = this._world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
               (_loc5_ = new Point()).x = Math.round(_loc4_.x / 12);
               _loc5_.y = Math.round(_loc4_.y / 12);
               _loc6_ = (_loc3_.right - _loc3_.left) / 12;
               _loc7_ = 7;
               _loc2_.x = _loc5_.x;
               _loc2_.y = _loc5_.y;
               _loc2_.graphics.clear();
               _loc2_.graphics.beginFill(15260867);
               _loc2_.graphics.drawRect(_loc3_.left / 12,0,_loc6_,_loc7_);
               _loc2_.graphics.endFill();
            }
            _loc1_++;
         }
         while(this.drawnFloorList.length > _loc1_)
         {
            _loc8_ = this.drawnFloorList.pop();
            this.floorContainer.removeChild(_loc8_);
         }
      }
      
      function basementCheck() : void
      {
         var _loc2_:Shape = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._world.basementFloorList.length)
         {
            _loc2_ = new Shape();
            if(_loc1_ in this.drawnBasementList)
            {
               _loc2_ = this.drawnBasementList[_loc1_];
            }
            else
            {
               this.drawnBasementList.push(_loc2_);
               this.floorContainer.addChild(_loc2_);
            }
            if(_loc1_ > 0)
            {
               _loc3_ = this._world.basementFloorList[_loc1_];
               _loc4_ = this._world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
               (_loc5_ = new Point()).x = Math.round(_loc4_.x / 12);
               _loc5_.y = Math.round(_loc4_.y / 12);
               _loc6_ = (_loc3_.right - _loc3_.left) / 12;
               _loc7_ = 7;
               _loc2_.x = _loc5_.x;
               _loc2_.y = _loc5_.y;
               _loc2_.graphics.clear();
               _loc2_.graphics.beginFill(7962767);
               _loc2_.graphics.drawRect(_loc3_.left / 12,-_loc7_,_loc6_,_loc7_);
               _loc2_.graphics.endFill();
               _loc2_.graphics.beginFill(11712706);
               _loc2_.graphics.drawRect(_loc3_.left / 12,-1,_loc6_,1);
               _loc2_.graphics.endFill();
            }
            _loc1_++;
         }
         while(this.drawnBasementList.length > _loc1_)
         {
            _loc8_ = this.drawnBasementList.pop();
            this.floorContainer.removeChild(_loc8_);
         }
      }
      
      function ChangeFocus() : void
      {
         var _loc1_:* = this.frameArea.globalToLocal(new Point(stage.mouseX,stage.mouseY));
         var _loc2_:* = new Point();
         _loc2_.x = -(_loc1_.x * 12);
         _loc2_.y = -(_loc1_.y * 12 + 430 / 2);
         this._world.mainContainer.x = _loc2_.x;
         this._world.mainContainer.y = _loc2_.y;
      }
      
      function SetFocus(param1:MouseEvent) : void
      {
         this.ChangeFocus();
         addListenerOf(this,MouseEvent.MOUSE_MOVE,this.DragFocus);
         addListenerOf(stage,MouseEvent.MOUSE_UP,this.CancelFocus);
      }
      
      function DragFocus(param1:MouseEvent) : void
      {
         this.ChangeFocus();
      }
      
      function CancelFocus(param1:MouseEvent) : void
      {
         removeListenerOf(this,MouseEvent.MOUSE_MOVE,this.DragFocus);
         removeListenerOf(stage,MouseEvent.MOUSE_UP,this.CancelFocus);
      }
      
      function updateFrame(param1:Event) : void
      {
         this.frameArea.graphics.clear();
         var _loc2_:* = this._world.mainContainer.globalToLocal(new Point(0,0));
         this.framePos.x = _loc2_.x / 12;
         this.framePos.y = _loc2_.y / 12;
         var _loc3_:* = this._world.mainContainer.globalToLocal(new Point(700,430));
         this.framePos2.x = _loc3_.x / 12;
         this.framePos2.y = _loc3_.y / 12;
         this.frameArea.graphics.lineStyle(1,65280);
         this.frameArea.graphics.moveTo(this.framePos.x,this.framePos.y);
         this.frameArea.graphics.lineTo(this.framePos2.x,this.framePos.y);
         this.frameArea.graphics.lineTo(this.framePos2.x,this.framePos2.y);
         this.frameArea.graphics.lineTo(this.framePos.x,this.framePos2.y);
         this.frameArea.graphics.lineTo(this.framePos.x,this.framePos.y);
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
