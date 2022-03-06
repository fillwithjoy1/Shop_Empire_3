package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.constant.ColorCode;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.modules.Utility;
   import fl.motion.Color;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import greensock.TweenLite;
   
   public class StaffBox extends SEMovieClip
   {
       
      
      public var star0:MovieClip;
      
      public var humanIcon:MovieClip;
      
      public var star1:MovieClip;
      
      public var star2:MovieClip;
      
      public var characterName:TextField;
      
      public var workStatus:MovieClip;
      
      public var vitalityBar:MovieClip;
      
      public var expBar:MovieClip;
      
      var _related;
      
      var blinkDelay:int;
      
      var _starList:Array;
      
      var _controlPanel;
      
      public function StaffBox()
      {
         super();
         this.blinkDelay = 20;
         this._starList = new Array();
         this._starList.push(this.star0);
         this._starList.push(this.star1);
         this._starList.push(this.star2);
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.letterSpacing = -1;
         this.characterName.defaultTextFormat = _loc1_;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,Event.ENTER_FRAME,this.checkRelatedFrame);
         addListenerOf(this,Event.ENTER_FRAME,this.animateWorkDuty);
         addListenerOf(stage,HumanEvent.UPDATE_VITALITY,this.checkCurrentVitality);
         addListenerOf(stage,HumanEvent.UPDATE_EXPERIENCE,this.checkCurrentExperience);
         addListenerOf(stage,HumanEvent.BECOMES_PROMOTE,this.checkPromotion);
         addListenerOf(stage,HumanEvent.SUCCESFULLY_PROMOTED,this.successfullyPromoted);
         if(this._controlPanel != null)
         {
            addListenerOf(this._controlPanel.btnPromote,MouseEvent.ROLL_OVER,this.showPromoteCost);
         }
         if(this._related != null)
         {
            this.characterName.text = this._related.characterName;
            this.updateLevel(this._related);
            this.updateVitality(this._related);
            this.updateExperience(this._related);
            this.checkUpgradeable(this._related);
         }
      }
      
      function showPromoteCost(param1:Event) : void
      {
         if(this._related != null)
         {
            if(this._related.level < this._related.maxLevel)
            {
               this._controlPanel.promoteInfo.bubbleText.text = Utility.numberToMoney(this._related.promotionCost) + " G";
               TweenLite.to(this,0.8,{"onComplete":this.showPromoteInfo});
               addListenerOf(this._controlPanel.btnPromote,MouseEvent.ROLL_OUT,this.hidePromoteCost);
            }
         }
      }
      
      function checkControlColor() : void
      {
         if(this._related != null)
         {
            if(this._related.world.main.isEnough(this._related.promotionCost))
            {
               this._controlPanel.promoteInfo.bubbleText.textColor = ColorCode.VALID_CASH;
            }
            else
            {
               this._controlPanel.promoteInfo.bubbleText.textColor = ColorCode.MINUS_CASH;
            }
         }
      }
      
      function showPromoteInfo() : void
      {
         this._controlPanel.promoteInfo.visible = true;
         this.checkControlColor();
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.whenCashUpdate);
      }
      
      function whenCashUpdate(param1:GameEvent) : void
      {
         this.checkControlColor();
      }
      
      function hidePromoteCost(param1:Event) : void
      {
         this._controlPanel.promoteInfo.visible = false;
         TweenLite.killTweensOf(this);
         removeListenerOf(this._controlPanel.btnPromote,MouseEvent.ROLL_OUT,this.hidePromoteCost);
         removeListenerOf(stage,GameEvent.GAME_UPDATE,this.whenCashUpdate);
      }
      
      function successfullyPromoted(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._related)
         {
            this.updateVitality(_loc2_);
            this.checkUpgradeable(_loc2_);
            this.updateExperience(_loc2_);
         }
      }
      
      function animateWorkDuty(param1:Event) : void
      {
         if(this.blinkDelay > 0)
         {
            --this.blinkDelay;
         }
         else
         {
            this.workStatus.visible = !this.workStatus.visible;
            this.blinkDelay = !!this.workStatus.visible ? 20 : 5;
         }
      }
      
      function checkRelatedFrame(param1:Event) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:* = this.humanIcon.getChildAt(0);
         if(this._related != null)
         {
            _loc3_ = this._related.localToGlobal(new Point(0,0));
            if((_loc4_ = this._related.localToGlobal(new Point(1,0))).x > _loc3_.x)
            {
               _loc2_.scaleX = 1;
            }
            else
            {
               _loc2_.scaleX = -1;
            }
            _loc2_.gotoAndStop(this._related.currentFrame);
            _loc5_ = this._related.transform.colorTransform;
            _loc2_.transform.colorTransform = _loc5_;
            (_loc6_ = _loc2_.getChildAt(0)).gotoAndStop(this._related.level);
            if((_loc7_ = this._related.getChildAt(0)) != null)
            {
               _loc8_ = _loc6_.getChildAt(0);
               if((_loc9_ = _loc7_.getChildAt(0)) is MovieClip && _loc8_ is MovieClip)
               {
                  _loc8_.gotoAndStop(_loc9_.currentFrame);
               }
            }
            if(this._related.fatigue)
            {
               this.workStatus.gotoAndStop("fatigue");
            }
            else if(this._related.inHome)
            {
               this.workStatus.gotoAndStop("rest");
            }
            else if(this._related.destination == "home")
            {
               this.workStatus.gotoAndStop("leaving");
            }
            else if(this._related.arrival)
            {
               this.workStatus.gotoAndStop("arriving");
            }
            else
            {
               this.workStatus.gotoAndStop("onDuty");
            }
         }
      }
      
      function updateLevel(param1:*) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < this._starList.length)
         {
            _loc3_ = this._starList[_loc2_];
            if(_loc2_ < param1.level)
            {
               _loc3_.gotoAndStop("Active");
            }
            else if(_loc2_ == param1.level)
            {
               if(param1.promoteState)
               {
                  _loc3_.gotoAndStop("Active");
               }
               else
               {
                  _loc3_.gotoAndStop("Inactive");
               }
            }
            else
            {
               _loc3_.gotoAndStop("Inactive");
            }
            _loc2_++;
         }
      }
      
      function updateVitality(param1:*) : void
      {
         var _loc2_:Color = new Color();
         _loc2_.color = param1.tiredTime == 0 ? uint(ColorCode.VITALITY_FINE) : (param1.tiredTime == 1 ? uint(ColorCode.VITALITY_LOW) : uint(ColorCode.VITALITY_DEPLETED));
         this.vitalityBar.fillBar.transform.colorTransform = _loc2_;
         var _loc3_:* = param1.tiredTime == 0 ? 1 : (param1.tiredTime == 1 ? 0.7 : 0.4);
         this.vitalityBar.maskBar.scaleX = param1.vitality / Math.round(param1.MAX_VITALITY * _loc3_);
      }
      
      function checkCurrentVitality(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._related)
         {
            this.updateVitality(_loc2_);
         }
      }
      
      function checkCurrentExperience(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._related)
         {
            this.updateExperience(_loc2_);
         }
      }
      
      function checkPromotion(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == this._related)
         {
            this._starList[this._related.level].gotoAndPlay("Transform");
         }
      }
      
      function updateExperience(param1:*) : void
      {
         if(this._controlPanel != null)
         {
            if(!this._controlPanel.btnPromote.enabled && param1.level < param1.maxLevel)
            {
               this.checkUpgradeable(param1);
            }
         }
         this.expBar.maskBar.scaleX = param1.expPercentage;
      }
      
      function checkUpgradeable(param1:*) : void
      {
         if(this._controlPanel != null)
         {
            if(param1.expPercentage < 1)
            {
               this._controlPanel.btnPromote.enabled = false;
            }
            else
            {
               this._controlPanel.btnPromote.enabled = param1.level < param1.maxLevel;
            }
            if(this._controlPanel.btnPromote.enabled)
            {
               this._controlPanel.btnPromote.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
            }
            else
            {
               this._controlPanel.btnPromote.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
            }
         }
      }
      
      public function set related(param1:*) : void
      {
         this._related = param1;
         if(this._related != null)
         {
            this.characterName.text = this._related.characterName;
            this.updateLevel(this._related);
            this.updateVitality(this._related);
            this.updateExperience(this._related);
            this.checkUpgradeable(this._related);
         }
      }
      
      public function get related() : *
      {
         return this._related;
      }
      
      public function set controlPanel(param1:*) : void
      {
         this._controlPanel = param1;
      }
      
      public function get controlPanel() : *
      {
         return this._controlPanel;
      }
   }
}
