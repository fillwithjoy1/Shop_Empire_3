package Instance.ui
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.gameplay.SpecialVisitor;
   import Instance.modules.Utility;
   import Instance.property.Elevator;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityStairs;
   import Instance.property.FictionalBuilding;
   import Instance.property.HalteWagon;
   import Instance.property.InsideRestroom;
   import Instance.property.Wagon;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.text.TextField;
   
   public class UIVisitorInfo extends UI_InfoDialog
   {
       
      
      public var textPart:MovieClip;
      
      public var insideInfo:MovieClip;
      
      public var coinSymbol:MovieClip;
      
      public var rightPart:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var bodyPartBottomLeft:MovieClip;
      
      public var leftBottomPart:MovieClip;
      
      public var bottomPart:MovieClip;
      
      public var leftPart:MovieClip;
      
      public var genderInfo:TextField;
      
      public var genderIcon:MovieClip;
      
      public var rightTopPart:MovieClip;
      
      public var topPart:MovieClip;
      
      public var headerName:TextField;
      
      public var bodyPartBottomRight:MovieClip;
      
      public var cashInfo:TextField;
      
      public var bodyPartCenter:MovieClip;
      
      public var favoriteInfo:TextField;
      
      public var additionalNote:TextField;
      
      public var rightBottomPart:MovieClip;
      
      public var bodyPartBottomCenter:MovieClip;
      
      public var leftTopPart:MovieClip;
      
      public var bodyPartRight:MovieClip;
      
      public var bodyPartLeft:MovieClip;
      
      public var commentInfo:TextField;
      
      public var pointPart:MovieClip;
      
      public var dragArea:MovieClip;
      
      public var statificationInfo:MovieClip;
      
      public function UIVisitorInfo()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc6_:* = undefined;
         super.Initialize(param1);
         this.headerName.text = _relation.characterName.toUpperCase();
         this.genderInfo.text = _relation.gender > 0 ? "Male" : (_relation.gender < 0 ? "Female" : "Unknown");
         this.genderIcon.gotoAndStop(_relation.gender > 0 ? 1 : (_relation.gender < 0 ? 2 : 3));
         var _loc2_:* = null;
         var _loc3_:* = "";
         var _loc4_:* = 0;
         while(_loc4_ < _relation.favoriteList.length)
         {
            if((_loc6_ = _relation.favoriteList[_loc4_]) != "(none)")
            {
               if(_relation.world.main.unlockedBuilding.indexOf(_loc6_) >= 0)
               {
                  if(_loc6_ != _loc2_)
                  {
                     if(_loc3_.length > 0)
                     {
                        _loc3_ += ", ";
                     }
                     _loc3_ += _loc6_;
                     _loc2_ = _loc6_;
                  }
               }
            }
            _loc4_++;
         }
         if(_loc3_.length == 0)
         {
            _loc3_ = "(none)";
         }
         this.favoriteInfo.text = _loc3_;
         if(_relation is SpecialVisitor)
         {
            this.additionalNote.text = _relation.extraDescription;
         }
         else
         {
            this.additionalNote.text = "";
         }
         var _loc5_:* = (_loc5_ = _relation.chatComment).replace(/\n/g," ");
         this.commentInfo.text = _loc5_;
         addListenerOf(_relation,HumanEvent.EXILE,this.whenRelationExile);
         addListenerOf(_relation,Event.ENTER_FRAME,this.checkCondition);
      }
      
      function whenRelationExile(param1:HumanEvent) : void
      {
         this.parent.removeChild(this);
      }
      
      override protected function Removed(param1:Event) : void
      {
         super.Removed(param1);
         this.parent.dispatchEvent(new GameEvent(GameEvent.LOST_HUMAN_FOCUS));
      }
      
      function checkCondition(param1:Event) : void
      {
         var _loc5_:* = undefined;
         var _loc2_:* = _relation.statification == 3 ? "happy" : (_relation.statification == 2 ? "normal" : (_relation.statification == 1 ? "unhappy" : "angry"));
         this.statificationInfo.gotoAndStop(_loc2_);
         this.cashInfo.text = Utility.numberToMoney(_relation.purse) + " G";
         var _loc3_:* = _relation.chatComment;
         _loc3_ = _loc3_.replace(/\n/g," ");
         this.commentInfo.text = _loc3_;
         var _loc4_:*;
         if((_loc4_ = _relation.inside) == null || _loc4_ is FacilityElevatorBody || _loc4_ is FacilityStairs)
         {
            this.insideInfo.visible = false;
         }
         else if(_loc4_ == _relation.world.dungeon)
         {
            this.insideInfo.visible = false;
         }
         else if(_loc4_ is HalteWagon)
         {
            this.insideInfo.gotoAndStop("halteWagon");
            this.insideInfo.visible = true;
         }
         else if(_loc4_ is Wagon)
         {
            this.insideInfo.gotoAndStop("halteWagon");
            this.insideInfo.visible = true;
         }
         else if(_loc4_ is Elevator)
         {
            this.insideInfo.gotoAndStop("facility - elevator");
            this.insideInfo.visible = true;
         }
         else
         {
            _loc5_ = _loc4_;
            if(_loc4_ is InsideRestroom)
            {
               _loc5_ = _loc4_.relatedRestroom;
            }
            else if(_loc4_ is FictionalBuilding)
            {
               _loc5_ = _loc4_.related;
            }
            this.insideInfo.gotoAndStop(BuildingData.getIconOf(BuildingData.returnClassTo(Utility.getClass(_loc5_))));
            this.insideInfo.visible = true;
         }
      }
   }
}
