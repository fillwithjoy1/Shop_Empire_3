package Instance.property
{
   import Instance.SEMovieClip;
   import Instance.events.GameEvent;
   import Instance.events.LoopEvent;
   import Instance.gameplay.World;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class SonicBeamFX extends SEMovieClip
   {
       
      
      var _world:World;
      
      var _launchDistance:Number;
      
      var _thrownThief:Array;
      
      var _thrownDirrection:Array;
      
      public function SonicBeamFX()
      {
         super();
         this._thrownThief = new Array();
         this._thrownDirrection = new Array();
         stop();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,LoopEvent.ON_IDLE,this.animateAndMove);
      }
      
      function animateAndMove(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         if(this._world != null)
         {
            if(this.currentFrame < this.totalFrames)
            {
               this.nextFrame();
            }
            else
            {
               this.gotoAndStop(1);
            }
            this.x += 20 * scaleX;
            if(this.alpha >= 1)
            {
               _loc3_ = this.x - 25 * scaleX;
               _loc4_ = Math.min(_loc3_,this.x);
               _loc5_ = Math.max(_loc3_,this.x);
               _loc6_ = this._world.thiefList.concat(this._world.litterList);
               _loc7_ = 0;
               while(_loc7_ < _loc6_.length)
               {
                  if(!(_loc8_ = _loc6_[_loc7_]).isCaught)
                  {
                     if(_loc8_.inside == null)
                     {
                        if((_loc9_ = Math.abs(this.y - _loc8_.y)) <= 16)
                        {
                           if(_loc8_.x >= _loc4_ && _loc8_.x <= _loc5_)
                           {
                              (_loc10_ = new EffectHit()).x = _loc8_.x;
                              _loc10_.y = this.y;
                              _loc10_.scaleX = 0.5;
                              _loc10_.scaleY = 0.5;
                              _loc10_.stop();
                              this._world.bonusContainer.addChild(_loc10_);
                              _loc10_.addListenerOf(_loc10_,LoopEvent.ON_IDLE,this.animateEffect);
                              _loc8_.caught();
                              _loc8_.currentAnimation = null;
                              _loc8_.gotoAndStop("arrested");
                              if(this._thrownThief.indexOf(_loc8_) < 0)
                              {
                                 this._thrownThief.push(_loc8_);
                                 this._thrownDirrection.push({
                                    "dx":(Math.random() * 3 + 3) * scaleX,
                                    "dy":Math.floor(Math.random() * 4 + 3)
                                 });
                              }
                              _loc8_.dispatchEvent(new GameEvent(GameEvent.ARRESTED));
                              _loc8_.addListenerOf(_loc8_,LoopEvent.ON_IDLE,this.throwTheThief);
                           }
                        }
                     }
                  }
                  _loc7_++;
               }
            }
            _loc2_ = false;
            if(this._launchDistance > 0)
            {
               this._launchDistance = Math.max(0,this._launchDistance - 20);
            }
            else if(this.alpha > 0)
            {
               this.alpha = Math.max(0,this.alpha - 0.08);
            }
            else
            {
               _loc2_ = true;
            }
            if(!_loc2_)
            {
               if(this.x < this._world.mostLeft - 30 || this.x > this._world.mostRight + 30)
               {
                  _loc2_ = true;
               }
            }
            if(_loc2_)
            {
               this.parent.removeChild(this);
            }
         }
      }
      
      function animateEffect(param1:LoopEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.currentFrame < _loc2_.totalFrames)
         {
            _loc2_.nextFrame();
         }
         else
         {
            _loc2_.removeListenerOf(_loc2_,LoopEvent.ON_IDLE,this.animateEffect);
            if(_loc2_.parent != null)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
      }
      
      function throwTheThief(param1:LoopEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this._thrownThief.indexOf(_loc2_);
         if(_loc3_ in this._thrownDirrection)
         {
            _loc4_ = this._thrownDirrection[_loc3_];
            _loc5_ = null;
            _loc6_ = Infinity;
            _loc7_ = this._world.mainContainer.globalToLocal(_loc2_.localToGlobal(new Point(0,0)));
            _loc8_ = 0;
            while(_loc8_ < this._world.floorList.length)
            {
               if((_loc9_ = this._world.floorList[_loc8_]).y >= _loc7_.y)
               {
                  if((_loc10_ = Math.abs(_loc9_.y - _loc7_.y)) < _loc6_)
                  {
                     if(_loc7_.x >= _loc9_.left && _loc7_.x <= _loc9_.right)
                     {
                        _loc5_ = _loc9_;
                        _loc6_ = _loc10_;
                     }
                  }
               }
               _loc8_++;
            }
            if(_loc5_ != null)
            {
               _loc7_.x += _loc4_.dx;
               if(_loc7_.y - _loc4_.dy < _loc5_.y)
               {
                  _loc7_.y -= _loc4_.dy;
                  --_loc4_.dy;
               }
               else
               {
                  _loc7_.y = _loc5_.y;
                  this._thrownThief.splice(_loc3_,1);
                  this._thrownDirrection.splice(_loc3_,1);
                  _loc2_.vanish();
                  _loc2_.removeListenerOf(_loc2_,LoopEvent.ON_IDLE,this.throwTheThief);
               }
               _loc11_ = _loc2_.parent.globalToLocal(this._world.mainContainer.localToGlobal(_loc7_));
               _loc2_.x = _loc11_.x;
               _loc2_.y = _loc11_.y;
            }
            else
            {
               this._thrownThief.splice(_loc3_,1);
               this._thrownDirrection.splice(_loc3_,1);
               if(_loc2_.stage != null)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
               _loc2_.currentAnimation = "arrested";
               _loc2_.removeListenerOf(_loc2_,LoopEvent.ON_IDLE,this.throwTheThief);
            }
         }
      }
      
      public function set launchDistance(param1:Number) : void
      {
         this._launchDistance = param1;
      }
      
      public function get launchDistance() : Number
      {
         return this._launchDistance;
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
