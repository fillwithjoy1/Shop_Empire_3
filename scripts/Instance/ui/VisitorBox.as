package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.constant.BuildingData;
   import Instance.events.HumanEvent;
   import Instance.gameplay.Litter;
   import Instance.gameplay.Visitor;
   import Instance.modules.Utility;
   import Instance.property.Elevator;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityStairs;
   import Instance.property.FictionalBuilding;
   import Instance.property.HalteWagon;
   import Instance.property.InsideRestroom;
   import Instance.property.Wagon;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class VisitorBox extends SEMovieClip
   {
       
      
      public var humanIcon:HumanStand;
      
      public var insideInfo:MovieClip;
      
      public var coinSymbol:MovieClip;
      
      public var characterName:TextField;
      
      public var toDestroySymbol:MovieClip;
      
      public var sightSomeone:MovieClip;
      
      public var cashInfo:TextField;
      
      public var statificationInfo:MovieClip;
      
      var _related;
      
      var capturedClip:MovieClip;
      
      public function VisitorBox()
      {
         super();
         this.capturedClip = new MovieClip();
         this.capturedClip.x = this.humanIcon.x;
         this.capturedClip.y = this.humanIcon.y;
         addChild(this.capturedClip);
         this.humanIcon.visible = false;
         this.humanIcon.stop();
         this.sightSomeone.gotoAndStop(4);
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(stage,HumanEvent.SPRITE_CORRECTION,this.checkRelatedFrame);
      }
      
      function checkRelatedFrame(param1:Event) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Rectangle = null;
         var _loc6_:BitmapData = null;
         var _loc7_:Sprite = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc2_:* = param1.target;
         var _loc3_:* = this._related;
         if(this._related != null)
         {
            if(this._related.relatedCritter != null)
            {
               if(this._related.relatedCritter.model != "stone" && this._related.relatedCritter.model != "frozen")
               {
                  _loc3_ = this._related.relatedCritter;
               }
            }
         }
         if(_loc3_ != null && _loc2_ == _loc3_)
         {
            while(this.capturedClip.numChildren > 0)
            {
               this.capturedClip.removeChildAt(0);
            }
            _loc4_ = _loc3_.transform.colorTransform;
            _loc5_ = _loc3_.getBounds(_loc3_);
            _loc6_ = Utility.crop(_loc3_,_loc5_.x,_loc5_.y,_loc5_.width,_loc5_.height).bitmapData;
            (_loc7_ = new Sprite()).graphics.clear();
            _loc7_.graphics.beginBitmapFill(_loc6_,null,false);
            _loc7_.graphics.drawRect(0,0,_loc6_.width,_loc6_.height);
            _loc7_.graphics.endFill();
            _loc7_.x = _loc5_.x;
            _loc7_.y = _loc5_.y;
            this.capturedClip.addChild(_loc7_);
            this.capturedClip.transform.colorTransform = _loc4_;
            _loc8_ = _loc3_.world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
            if((_loc9_ = _loc3_.world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(1,0)))).x > _loc8_.x)
            {
               this.capturedClip.scaleX = 1;
            }
            else
            {
               this.capturedClip.scaleX = -1;
            }
            if(this._related != null)
            {
               this.characterName.text = this._related.characterName;
            }
            if(this._related is Visitor)
            {
               this.sightSomeone.visible = false;
               this.coinSymbol.visible = true;
               this.cashInfo.visible = true;
               this.statificationInfo.visible = true;
               this.cashInfo.text = "" + Utility.numberToMoney(this._related.purse) + " G";
               _loc11_ = this._related.statification == 3 ? "happy" : (this._related.statification == 2 ? "normal" : (this._related.statification == 1 ? "unhappy" : "angry"));
               this.statificationInfo.gotoAndStop(_loc11_);
            }
            else
            {
               if(this._related is Litter)
               {
                  this.sightSomeone.visible = this._related.guardInSight.length > 0 && !this._related.sabotageBuilding;
               }
               this.coinSymbol.visible = false;
               this.cashInfo.visible = false;
               this.statificationInfo.visible = false;
            }
            if((_loc10_ = this._related.inside) == null || _loc10_ is FacilityElevatorBody || _loc10_ is FacilityStairs)
            {
               if(this._related is Litter)
               {
                  if(this._related.sabotageBuilding != null)
                  {
                     this.toDestroySymbol.visible = this._related.sabotageProgress;
                     this.insideInfo.gotoAndStop(BuildingData.getIconOf(BuildingData.returnClassTo(Utility.getClass(this._related.sabotageBuilding))));
                     this.insideInfo.visible = true;
                  }
                  else
                  {
                     this.toDestroySymbol.visible = false;
                     this.insideInfo.visible = false;
                  }
               }
               else
               {
                  this.toDestroySymbol.visible = false;
                  this.insideInfo.visible = false;
               }
            }
            else
            {
               this.toDestroySymbol.visible = false;
               if(_loc10_ == this._related.world.dungeon)
               {
                  this.insideInfo.visible = false;
               }
               else if(_loc10_ is HalteWagon)
               {
                  this.insideInfo.gotoAndStop("halteWagon");
                  this.insideInfo.visible = true;
               }
               else if(_loc10_ is Wagon)
               {
                  this.insideInfo.gotoAndStop("halteWagon");
                  this.insideInfo.visible = true;
               }
               else if(_loc10_ is Elevator)
               {
                  this.insideInfo.gotoAndStop("facility - elevator");
                  this.insideInfo.visible = true;
               }
               else
               {
                  _loc12_ = _loc10_;
                  if(_loc10_ is InsideRestroom)
                  {
                     _loc12_ = _loc10_.relatedRestroom;
                  }
                  else if(_loc10_ is FictionalBuilding)
                  {
                     _loc12_ = _loc10_.related;
                  }
                  this.insideInfo.gotoAndStop(BuildingData.getIconOf(BuildingData.returnClassTo(Utility.getClass(_loc12_))));
                  this.insideInfo.visible = true;
               }
            }
         }
      }
      
      public function set related(param1:*) : void
      {
         this._related = param1;
         if(this._related != null)
         {
            this.characterName.text = this._related.characterName;
         }
      }
      
      public function get related() : *
      {
         return this._related;
      }
   }
}
