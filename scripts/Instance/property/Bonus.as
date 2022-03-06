package Instance.property
{
   import Instance.SEMovieClip;
   import Instance.events.GameEvent;
   import Instance.events.LoopEvent;
   import Instance.gameplay.World;
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Bonus extends SEMovieClip
   {
       
      
      public var coinTaken:MovieClip;
      
      public var bundle:MovieClip;
      
      public var coinIdle:MovieClip;
      
      var _amount:int;
      
      var _idleSprite;
      
      var _takenSprite;
      
      var _taken:Boolean;
      
      var _world:World;
      
      var _vSpeed:Number;
      
      var _spriteLabel;
      
      var _picker;
      
      var _takenDelay:int;
      
      var _moveSpeed:Number;
      
      public function Bonus()
      {
         super();
      }
      
      public function bonus() : *
      {
         var _loc2_:* = undefined;
         this._taken = false;
         this._spriteLabel = null;
         var _loc1_:* = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            if(_loc2_ is MovieClip && _loc2_.totalFrames > 1)
            {
               _loc2_.stop();
            }
            _loc1_++;
         }
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(this._amount > 250)
         {
            this._idleSprite = this.bundle;
            this._takenSprite = this.bundle;
            this._spriteLabel = null;
            if(getChildByName(this.coinIdle.name))
            {
               this.coinIdle.parent.removeChild(this.coinIdle);
            }
            if(getChildByName(this.coinTaken.name))
            {
               this.coinTaken.parent.removeChild(this.coinTaken);
            }
         }
         else
         {
            this._spriteLabel = this._amount >= 100 ? "gold" : (this._amount >= 50 ? "silver" : "bronze");
            this._idleSprite = this.coinIdle;
            this._takenSprite = this.coinTaken;
            if(getChildByName(this.bundle.name))
            {
               this.bundle.parent.removeChild(this.bundle);
            }
         }
         this._takenDelay = 11;
         this.checkTakenCondition();
         addListenerOf(this,LoopEvent.ON_IDLE,this.animateCheck);
         addListenerOf(this,LoopEvent.ON_IDLE,this.afterTakenCheck);
         addListenerOf(this,LoopEvent.ON_IDLE,this.mouseOverCheck);
      }
      
      function mouseOverCheck(param1:LoopEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = !(this._picker != null && this._picker.toPick == this) && !this._taken;
         if(_loc2_)
         {
            _loc3_ = this._world.bonusList.indexOf(this);
            if(_loc3_ in this._world.bonusList)
            {
               if((_loc4_ = Calculate.countDistance(new Point(0,0),new Point(this.mouseX,this.mouseY))) <= 30)
               {
                  this._moveSpeed = 0;
                  this._world.bonusList.splice(_loc3_,1);
                  dispatchEvent(new GameEvent(GameEvent.BONUS_TAKEN));
                  removeListenerOf(this,LoopEvent.ON_IDLE,this.mouseOverCheck);
                  addListenerOf(this,Event.ENTER_FRAME,this.moveToMouse);
               }
            }
         }
      }
      
      function moveToMouse(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(!this._taken)
         {
            _loc2_ = Calculate.countDistance(new Point(0,0),new Point(this.mouseX,this.mouseY));
            _loc3_ = this.parent.globalToLocal(this.localToGlobal(new Point(this.mouseX,this.mouseY)));
            _loc4_ = this._moveSpeed / _loc2_;
            if(_loc2_ - this._moveSpeed > 0)
            {
               this.x += _loc4_ * (_loc3_.x - this.x);
               this.y += _loc4_ * (_loc3_.y - this.y);
               this._moveSpeed += 10;
            }
            else
            {
               this.x = _loc3_.x;
               this.y = _loc3_.y;
               this._taken = true;
               this.checkTakenCondition();
            }
         }
         else
         {
            this.y -= this._takenDelay * 0.5;
         }
      }
      
      function checkTakenCondition() : void
      {
         if(!this._taken)
         {
            if(getChildByName(this._idleSprite.name) == null)
            {
               addChild(this._idleSprite);
            }
            if(this._idleSprite != this._takenSprite)
            {
               if(getChildByName(this._takenSprite.name))
               {
                  removeChild(this._takenSprite);
               }
            }
         }
         else
         {
            if(!getChildByName(this._takenSprite.name))
            {
               addChild(this._takenSprite);
            }
            if(this._idleSprite != this._takenSprite)
            {
               if(getChildByName(this._idleSprite.name))
               {
                  removeChild(this._idleSprite);
               }
            }
         }
      }
      
      function afterTakenCheck(param1:LoopEvent) : void
      {
         if(this._taken)
         {
            if(this._takenDelay > 0)
            {
               --this._takenDelay;
            }
            else if(this.stage != null)
            {
               dispatchEvent(new GameEvent(GameEvent.BONUS_GAIN,this._amount));
               this.parent.removeChild(this);
            }
         }
      }
      
      function animateCheck(param1:LoopEvent) : void
      {
         this.dropAnimation();
         this.spriteAnimation();
      }
      
      function checkSprite(param1:*) : void
      {
         var _loc2_:* = undefined;
         if(getChildByName(param1.name))
         {
            if(param1.currentFrame < param1.totalFrames)
            {
               param1.nextFrame();
            }
            else
            {
               param1.gotoAndStop(1);
            }
            _loc2_ = param1.getChildAt(0);
            if(_loc2_ != null && _loc2_ is MovieClip)
            {
               if(Utility.hasLabel(_loc2_,this._spriteLabel))
               {
                  _loc2_.gotoAndStop(this._spriteLabel);
               }
            }
         }
      }
      
      function spriteAnimation() : void
      {
         if(this._spriteLabel != null)
         {
            this.checkSprite(this._idleSprite);
            this.checkSprite(this._takenSprite);
         }
      }
      
      function dropAnimation() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(!this._taken)
         {
            _loc1_ = null;
            _loc2_ = Infinity;
            _loc3_ = this._world.mainContainer.globalToLocal(this.localToGlobal(new Point()));
            _loc4_ = 0;
            while(_loc4_ < this._world.floorList.length)
            {
               if((_loc5_ = this._world.floorList[_loc4_]).y >= _loc3_.y)
               {
                  if((_loc6_ = Math.abs(_loc5_.y - _loc3_.y)) < _loc2_)
                  {
                     if(_loc3_.x >= _loc5_.left && _loc3_.x <= _loc5_.right)
                     {
                        _loc1_ = _loc5_;
                        _loc2_ = _loc6_;
                     }
                  }
               }
               _loc4_++;
            }
            if(_loc1_ != null)
            {
               if(_loc3_.y + this.vSpeed < _loc1_.y)
               {
                  _loc3_.y += this.vSpeed;
                  this.vSpeed += 2;
               }
               else
               {
                  _loc3_.y = _loc1_.y;
                  this.vSpeed = 0;
               }
               _loc7_ = this.parent.globalToLocal(this._world.mainContainer.localToGlobal(_loc3_));
               this.x = _loc7_.x;
               this.y = _loc7_.y;
            }
         }
      }
      
      public function set taken(param1:Boolean) : void
      {
         this._taken = param1;
         this.checkTakenCondition();
      }
      
      public function get taken() : Boolean
      {
         return this._taken;
      }
      
      public function set vSpeed(param1:Number) : void
      {
         this._vSpeed = param1;
      }
      
      public function get vSpeed() : Number
      {
         return this._vSpeed;
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function set amount(param1:int) : void
      {
         this._amount = param1;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
      
      public function set picker(param1:*) : void
      {
         this._picker = param1;
      }
      
      public function get picker() : *
      {
         return this._picker;
      }
   }
}
