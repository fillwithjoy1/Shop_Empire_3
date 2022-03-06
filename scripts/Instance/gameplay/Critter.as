package Instance.gameplay
{
   import Instance.SEMovieClip;
   import Instance.events.AchievementEvent;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import greensock.TweenMax;
   
   public class Critter extends SEMovieClip
   {
       
      
      var _world:World;
      
      var _model:String;
      
      var _related;
      
      var _movePoint:Point;
      
      var _passive:Boolean;
      
      var _critterCountdown:int;
      
      var returnBuff;
      
      public function Critter()
      {
         super();
         this._passive = true;
         priority = 3;
         stop();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(this._related != null)
         {
            if(this._model == "stone")
            {
               this.visible = false;
               TweenMax.to(this._related,0.01,{"colorMatrixFilter":{
                  "amount":1,
                  "saturation":0,
                  "brightness":0.6
               }});
               this._critterCountdown = 30;
            }
            else if(this._model == "frozen")
            {
               this.visible = false;
               TweenMax.to(this._related,0.01,{"colorTransform":{
                  "tint":5343977,
                  "tintAmount":0.5
               }});
               if(this._related is SpecialVisitor)
               {
                  this._critterCountdown = 15;
               }
               else
               {
                  this._passive = false;
                  this._critterCountdown = 60;
               }
            }
            else
            {
               this._related.alpha = 0;
               this._related.mouseEnabled = false;
               this._related.mouseChildren = false;
               this._critterCountdown = 60;
               this._world.main.updateHistory("critter");
               dispatchEvent(new AchievementEvent(AchievementEvent.UPDATE_HISTORY,"critter"));
            }
            this._related.relatedCritter = this;
         }
         addListenerOf(this,Event.ENTER_FRAME,this.spriteCheck);
         addListenerOf(this,LoopEvent.ON_IDLE,this.movingCheck);
         addListenerOf(stage,HumanEvent.END_CAST,this.afterCurseWork);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.updateCondition);
      }
      
      function afterCurseWork(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.tag;
         if(_loc2_.victim == this._related)
         {
            if(!_loc2_.failed)
            {
               this._passive = false;
               if(this._model == "chicken")
               {
                  this._world.main.onStackSFX.push(SFX_Chicken_Run);
                  this._world.main.onStackSFXSource.push(this);
               }
               else if(this._model == "pig")
               {
                  this._world.main.onStackSFX.push(SFX_Pig);
                  this._world.main.onStackSFXSource.push(this);
               }
            }
         }
      }
      
      public function loadCondition(param1:*) : void
      {
         this._critterCountdown = param1.countdown;
         this._model = param1.model;
         this._passive = false;
      }
      
      public function saveCondition(param1:*) : void
      {
         param1.countdown = this._critterCountdown;
         param1.model = this._model;
      }
      
      function updateCondition(param1:GameEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(!this._passive)
         {
            if(this._critterCountdown > 0)
            {
               if(this._model != "stone" && this._model != "frozen")
               {
                  if(this._movePoint == null)
                  {
                     _loc2_ = this._world.getFloorAt(this.y);
                     if(_loc2_ != null)
                     {
                        _loc3_ = this._world.floorList.indexOf(_loc2_);
                        if(_loc3_ + 1 in this._world.floorList)
                        {
                           _loc4_ = this._world.floorList[_loc3_ + 1];
                           _loc5_ = Math.round((Math.random() * (_loc4_.right - _loc4_.left) + _loc4_.left) * 10) / 10;
                           this._movePoint = new Point(_loc5_,this.y);
                        }
                     }
                  }
                  this.hygineCheck();
               }
               --this._critterCountdown;
            }
            else
            {
               this.endOfCurse();
            }
         }
      }
      
      function returnBuffGetSomeClip(param1:Event) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ is MovieClip && _loc2_.totalFrames > 1)
         {
            _loc2_.stop();
            this._world.addListenerOf(_loc2_,LoopEvent.ON_IDLE,this.animateBuff);
         }
      }
      
      function animateBuff(param1:LoopEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.currentFrame < _loc2_.totalFrames)
         {
            _loc2_.nextFrame();
         }
         else
         {
            this._world.removeListenerOf(_loc2_,LoopEvent.ON_IDLE,this.animateBuff);
            if(_loc2_ == this.returnBuff)
            {
               _loc2_.parent.removeChild(_loc2_);
               removeListenerOf(this.returnBuff,Event.ADDED,this.returnBuffGetSomeClip);
               removeListenerOf(this.returnBuff,LoopEvent.ON_IDLE,this.checkCurrentBuff);
               if(this._model != "stone")
               {
                  this._related.passive = false;
               }
               this.parent.removeChild(this);
            }
         }
      }
      
      function checkCurrentBuff(param1:LoopEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.currentFrameLabel == "effectCurse")
         {
            if(this._related != null)
            {
               this._related.x = this.x;
               this._related.y = this.y;
               this._related.scaleX = this.scaleX;
               this._related.alpha = 1;
               this._related.mouseEnabled = true;
               this._related.mouseChildren = true;
               this._related.relatedCritter = null;
               if(this._model == "stone")
               {
                  this._related.passive = false;
                  TweenMax.to(this._related,0.01,{"colorMatrixFilter":{
                     "amount":1,
                     "saturation":1,
                     "brightness":1
                  }});
               }
               else if(this._model == "frozen")
               {
                  TweenMax.to(this._related,0.01,{"colorTransform":{
                     "tint":null,
                     "tintAmount":0
                  }});
               }
            }
            this.visible = false;
         }
      }
      
      function hygineCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this._model != "stone" && this._model != "frozen")
         {
            _loc1_ = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc2_ = 15;
            _loc3_ = this._world.getFloorAt(_loc1_.y);
            if(_loc3_ != null)
            {
               if(Calculate.chance(_loc2_))
               {
                  this._world.addTrash(_loc3_,_loc1_.x,0,true);
               }
            }
         }
      }
      
      public function getSpeed() : Number
      {
         if(this._model != "stone" && this._model != "frozen")
         {
            if(this._model == "chicken")
            {
               return 2.4;
            }
            return 2;
         }
         return 0;
      }
      
      function movingCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this._movePoint != null)
         {
            if(this.currentFrame < this.totalFrames)
            {
               this.nextFrame();
            }
            else
            {
               this.gotoAndStop(1);
            }
            _loc2_ = this.getSpeed();
            _loc3_ = Math.min(_loc2_,5);
            while(_loc2_ > 0)
            {
               this.scaleX = this._movePoint.x > this.x ? Number(1) : (this._movePoint.x < this.x ? Number(-1) : Number(this.scaleX));
               if((_loc4_ = Math.abs(this._movePoint.x - this.x)) - _loc3_ > 0)
               {
                  _loc5_ = _loc3_ / _loc4_;
                  this.x += _loc5_ * (this._movePoint.x - this.x);
                  _loc2_ = Math.max(_loc2_ - _loc3_,0);
                  _loc3_ = Math.min(_loc2_,5);
               }
               else
               {
                  this.x = this._movePoint.x;
                  this._movePoint = null;
                  _loc2_ = 0;
               }
            }
         }
         else
         {
            this.gotoAndStop(this.totalFrames);
         }
         if(this._related != null)
         {
            if(this._model != "stone" && this._model != "frozen")
            {
               this._related.x = this.x;
               this._related.y = this.y;
            }
            else if(this._model != "frozen")
            {
               if(this._critterCountdown < 10)
               {
                  if(this._related.x < this.x)
                  {
                     this._related.x = this.x + 1;
                  }
                  else
                  {
                     this._related.x = this.x - 1;
                  }
               }
            }
         }
      }
      
      function spriteCheck(param1:Event) : void
      {
         var _loc2_:* = undefined;
         if(numChildren > 0)
         {
            _loc2_ = this.getChildAt(0);
            if(_loc2_ != null)
            {
               if(Utility.hasLabel(_loc2_,this._model))
               {
                  _loc2_.gotoAndStop(this._model);
               }
            }
         }
         dispatchEvent(new HumanEvent(HumanEvent.SPRITE_CORRECTION));
      }
      
      function endOfCurse() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this._movePoint = null;
         this._passive = true;
         if(this._model != "stone")
         {
            this.returnBuff = new CurseBuff();
         }
         else
         {
            this.returnBuff = new RockFallCrack();
         }
         this.returnBuff.x = this.x;
         this.returnBuff.y = this.y;
         this.returnBuff.stop();
         this._related.x = this.x;
         this._related.y = this.y;
         var _loc1_:* = this._related.parent;
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.getChildIndex(this._related);
            _loc3_ = _loc2_;
            if(_loc1_.getChildByName(this.name))
            {
               _loc3_ = _loc1_.getChildIndex(this);
            }
            addListenerOf(this.returnBuff,LoopEvent.ON_IDLE,this.animateBuff);
            addListenerOf(this.returnBuff,LoopEvent.ON_IDLE,this.checkCurrentBuff);
            addListenerOf(this.returnBuff,Event.ADDED,this.returnBuffGetSomeClip);
            _loc4_ = Math.max(_loc2_,_loc3_);
            _loc1_.addChildAt(this.returnBuff,_loc4_ + 1);
         }
      }
      
      public function debuff() : void
      {
         if(this._model == "stone")
         {
            this._model = "none";
            TweenMax.to(this._related,0.01,{"colorMatrixFilter":{
               "amount":1,
               "saturation":1,
               "brightness":1
            }});
         }
         this.endOfCurse();
      }
      
      public function set model(param1:String) : void
      {
         this._model = param1;
      }
      
      public function get model() : String
      {
         return this._model;
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function set related(param1:*) : void
      {
         this._related = param1;
      }
      
      public function get related() : *
      {
         return this._related;
      }
   }
}
