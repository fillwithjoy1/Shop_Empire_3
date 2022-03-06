package Instance
{
   import Instance.constant.HumanData;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import greensock.TweenMax;
   
   public class Preloader extends MovieClip
   {
       
      
      public var people0:MovieClip;
      
      public var people1:MovieClip;
      
      public var people2:MovieClip;
      
      public var people3:MovieClip;
      
      public var progressBar:MovieClip;
      
      public var people4:MovieClip;
      
      public var lgLink:SimpleButton;
      
      public var theWagon:MovieClip;
      
      public var people5:MovieClip;
      
      public var people6:MovieClip;
      
      public var people7:MovieClip;
      
      public var people8:MovieClip;
      
      public var toGamesfree:SimpleButton;
      
      public var people9:MovieClip;
      
      public var thief:MovieClip;
      
      var _percent:Number;
      
      var _maxPercent:Number;
      
      var _peopleList:Array;
      
      var _modelList:Array;
      
      var _defaultStandbyPosition:Array;
      
      var _standbyPosition:Array;
      
      var _animationList:Array;
      
      var _defaultBarPosition:Number;
      
      var _animationTheif:String;
      
      var _wheelRadius;
      
      var delayToStartTheGame:int;
      
      var thiefDX = 0;
      
      var thiefDY = 0;
      
      var preloadScene = 0;
      
      var wagonSpeed = 0;
      
      public function Preloader()
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         super();
         this._percent = 0;
         this._maxPercent = 0;
         this._peopleList = new Array();
         this._modelList = new Array();
         this._standbyPosition = new Array();
         this._defaultStandbyPosition = new Array();
         this._animationList = new Array();
         var _loc1_:* = HumanData.AVAILABLE_MALE_MODEL.concat(HumanData.AVAILABLE_FEMALE_MODEL);
         Utility.shuffle(_loc1_);
         var _loc2_:* = 0;
         while(getChildByName("people" + _loc2_) != null)
         {
            _loc3_ = getChildByName("people" + _loc2_);
            _loc3_.stop();
            _loc4_ = _loc1_.shift();
            (_loc5_ = _loc3_.getChildAt(0)).gotoAndStop(_loc4_);
            this._peopleList.push(_loc3_);
            this._modelList.push(_loc4_);
            this._standbyPosition.push(_loc3_.x);
            this._defaultStandbyPosition.push(_loc3_.x);
            this._animationList.push("idle");
            _loc2_++;
         }
         this._animationTheif = "idle";
         this._defaultBarPosition = this.progressBar.barIndicator.x;
         this.progressBar.barIndicator.x = this._defaultBarPosition - this.progressBar.barIndicator.width;
         this.theWagon.carriage.stop();
         this.theWagon.horse1.stop();
         this.theWagon.horse2.stop();
         this._wheelRadius = new Object();
         this._wheelRadius.front = this.theWagon.frontWheel.width / 2;
         this._wheelRadius.back = this.theWagon.backWheel.width / 2;
         addEventListener(Event.ADDED_TO_STAGE,this.Initialize);
      }
      
      function Initialize(param1:Event) : void
      {
         this.lgLink.addEventListener(MouseEvent.CLICK,this.linkToLG);
         this.toGamesfree.addEventListener(MouseEvent.CLICK,this.linkToGamesfree);
         addEventListener(Event.ENTER_FRAME,this.checkPeopleModel);
         addEventListener(Event.ENTER_FRAME,this.increaseMaxPercent);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      function removed(param1:Event) : void
      {
         this.lgLink.removeEventListener(MouseEvent.CLICK,this.linkToLG);
         this.toGamesfree.removeEventListener(MouseEvent.CLICK,this.linkToGamesfree);
         removeEventListener(Event.ENTER_FRAME,this.startTheGame);
         removeEventListener(Event.ENTER_FRAME,this.checkPeopleModel);
         removeEventListener(Event.ENTER_FRAME,this.increaseMaxPercent);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      function linkToLG(param1:MouseEvent) : void
      {
         var _loc2_:* = root;
         _loc2_.linkToLG();
      }
      
      function linkToGamesfree(param1:MouseEvent) : void
      {
         var _loc2_:* = root;
         _loc2_.linkToGamesfree();
      }
      
      function checkPeopleModel(param1:Event) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:* = Math.floor(Math.min(this._percent,this._maxPercent) / 10);
         var _loc3_:* = 0;
         while(_loc3_ < this._peopleList.length)
         {
            _loc5_ = this._peopleList[_loc3_];
            if(_loc3_ in this._standbyPosition && _loc3_ in this._animationList)
            {
               _loc6_ = false;
               if((_loc7_ = Math.abs(this._standbyPosition[_loc3_] - _loc5_.x)) > 0)
               {
                  if(this._animationList[_loc3_] != "walk")
                  {
                     this._animationList[_loc3_] = "walk";
                     _loc5_.gotoAndStop("walk");
                     _loc6_ = true;
                  }
                  if(_loc7_ > 3)
                  {
                     _loc5_.x += 3 * (this._standbyPosition[_loc3_] > _loc5_.x ? 1 : -1);
                  }
                  else
                  {
                     _loc5_.x = this._standbyPosition[_loc3_];
                  }
               }
               else
               {
                  if(this._animationList[_loc3_] != "idle")
                  {
                     this._animationList[_loc3_] = "idle";
                     _loc5_.gotoAndStop("idle");
                     _loc6_ = true;
                  }
                  _loc5_.visible = _loc3_ >= _loc2_;
               }
               if(!_loc6_)
               {
                  if(this._animationList[_loc3_] != null)
                  {
                     this.updateAnimation(_loc5_,this._animationList[_loc3_]);
                  }
               }
            }
            if(_loc3_ in this._modelList)
            {
               if((_loc8_ = _loc5_.getChildAt(0)) != null)
               {
                  _loc8_.gotoAndStop(this._modelList[_loc3_]);
               }
            }
            _loc3_++;
         }
         _loc6_ = false;
         var _loc4_:* = _loc2_ < 10 ? this._standbyPosition[this._standbyPosition.length - 1] - 28 : this.theWagon.x;
         if((_loc7_ = Math.abs(_loc4_ - this.thief.x)) > 0)
         {
            if(this._animationTheif != "walk")
            {
               this._animationTheif = "walk";
               this.thief.gotoAndStop("walk");
               _loc6_ = true;
            }
            if(_loc7_ > 3)
            {
               this.thief.x += 3 * (_loc4_ > this.thief.x ? 1 : -1);
            }
            else
            {
               this.thief.x = _loc4_;
            }
         }
         else
         {
            if(this._animationTheif != "idle")
            {
               this._animationTheif = "idle";
               this.thief.gotoAndStop("idle");
               _loc6_ = true;
            }
            if(_loc2_ >= 10)
            {
               this.delayToStartTheGame = 5;
               this.thief.visible = false;
               removeEventListener(Event.ENTER_FRAME,this.checkPeopleModel);
               addEventListener(Event.ENTER_FRAME,this.startTheGame);
            }
         }
         if(!_loc6_)
         {
            this.updateAnimation(this.thief,this._animationTheif);
         }
      }
      
      function updateAnimation(param1:*, param2:String) : void
      {
         if(Utility.hasLabel(param1,param2))
         {
            if(param1.currentFrameLabel != param2 + "_end")
            {
               param1.nextFrame();
            }
            else
            {
               param1.gotoAndStop(param2);
            }
         }
      }
      
      function startTheGame(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.delayToStartTheGame > 0)
         {
            --this.delayToStartTheGame;
         }
         else if(this.preloadScene == 0)
         {
            this.thief.visible = true;
            this.thief.scaleX = -1;
            this.thief.gotoAndStop("arrested_end");
            this.thief.x = this.theWagon.x - 5;
            this.thief.y = this.theWagon.y - 5;
            this.thiefDX = -5;
            this.thiefDY = -12;
            ++this.preloadScene;
         }
         else if(this.preloadScene == 1)
         {
            this.thief.x += this.thiefDX;
            if(this.thief.y + this.thiefDY < this.theWagon.y)
            {
               this.thief.y += this.thiefDY;
               this.thiefDY += 2;
            }
            else
            {
               this.thief.y = this.theWagon.y;
               this.theWagon.carriage.play();
               this.theWagon.horse1.play();
               this.theWagon.horse2.play();
               ++this.preloadScene;
            }
         }
         else if(this.preloadScene == 2)
         {
            if(this.theWagon.x < 700 + this.theWagon.width)
            {
               this.theWagon.x += this.wagonSpeed;
               _loc2_ = Math.PI * (this._wheelRadius.front * 2);
               _loc3_ = Math.PI * (this._wheelRadius.back * 2);
               this.theWagon.frontWheel.rotation -= 360 * (this.wagonSpeed / _loc2_);
               this.theWagon.backWheel.rotation -= 360 * (this.wagonSpeed / _loc3_);
               if(this.wagonSpeed < 10)
               {
                  this.wagonSpeed += 2;
               }
            }
            else
            {
               removeEventListener(Event.ENTER_FRAME,this.startTheGame);
               TweenMax.to(this,1.2,{
                  "tint":0,
                  "onComplete":this.playTheGame
               });
            }
         }
      }
      
      function increaseMaxPercent(param1:Event) : void
      {
         if(this._maxPercent < 100)
         {
            this._maxPercent += 2;
         }
         this.updateProgressBarPercentage();
         if(this._maxPercent > 100)
         {
            removeEventListener(Event.ENTER_FRAME,this.increaseMaxPercent);
         }
      }
      
      function checkPeople(param1:Number) : void
      {
         var _loc2_:* = Math.floor(param1 / 10);
         var _loc3_:* = 0;
         while(_loc3_ < this._standbyPosition.length)
         {
            if(_loc3_ < _loc2_)
            {
               this._standbyPosition[_loc3_] = this.theWagon.x;
            }
            else
            {
               this._standbyPosition[_loc3_] = this._defaultStandbyPosition[_loc3_ - _loc2_];
            }
            _loc3_++;
         }
      }
      
      function updateProgressBarPercentage() : void
      {
         var _loc1_:* = Math.min(this._percent,this._maxPercent);
         this.progressBar.barIndicator.x = this._defaultBarPosition - (100 - _loc1_) / 100 * this.progressBar.barIndicator.width;
         this.progressBar.percentIndicator.text = "" + Math.round(_loc1_) + "%";
         this.checkPeople(_loc1_);
         if(_loc1_ >= 100)
         {
            removeEventListener(Event.ENTER_FRAME,this.increaseMaxPercent);
         }
      }
      
      function playTheGame() : void
      {
         var _loc1_:* = this.root;
         if(_loc1_ != null)
         {
            _loc1_.nextFrame();
         }
      }
      
      public function set percent(param1:Number) : void
      {
         this._percent = param1;
         this.updateProgressBarPercentage();
      }
      
      public function get percent() : Number
      {
         return this._percent;
      }
   }
}
