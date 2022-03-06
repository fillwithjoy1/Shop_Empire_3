package Instance.gameplay
{
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import Instance.property.Bonus;
   import Instance.property.FacilityElevatorBody;
   import Instance.sprite.Animation;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class StaffEntertainer extends Staff
   {
       
      
      var _toPick;
      
      var _entertainProgress:int;
      
      var _entertainDelay:int;
      
      var _doEntertain:Boolean;
      
      var _doCounter:Boolean;
      
      var _performCoin:Array;
      
      var canGain:Boolean = false;
      
      public function StaffEntertainer()
      {
         super();
         this._toPick = null;
         this._entertainProgress = 0;
         this._entertainDelay = 0;
         this._doEntertain = false;
         this._performCoin = new Array();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(_world,GameEvent.BONUS_TAKEN,this.whenBonusLost);
      }
      
      function whenBonusLost(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         if(_loc2_ == _destination)
         {
            _destination = null;
         }
         var _loc3_:* = this._performCoin.indexOf(_loc2_);
         if(_loc3_ in this._performCoin)
         {
            this._performCoin.splice(_loc3_,1);
         }
      }
      
      function checkAround() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(_destination == null)
         {
            if(!_arrival && !_inHome)
            {
               if(!this._doEntertain && !_doingJob && !this._doCounter && this._toPick == null)
               {
                  if(this._entertainDelay > 0)
                  {
                     --this._entertainDelay;
                  }
                  else if(_inside == null)
                  {
                     _loc1_ = _world.currentVisitorList.concat();
                     _loc2_ = 0;
                     _loc3_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
                     _loc4_ = 0;
                     while(_loc4_ < _loc1_.length)
                     {
                        if((_loc5_ = _loc1_[_loc4_]).inside == null)
                        {
                           _loc6_ = _world.mainContainer.globalToLocal(_loc5_.localToGlobal(new Point(0,0)));
                           if(_loc3_.y == _loc6_.y)
                           {
                              _loc7_ = Math.abs(_loc3_.x - _loc6_.x);
                              _loc8_ = Math.max(40,getSight() / 8);
                              if(_loc7_ <= _loc8_)
                              {
                                 _loc2_ += (100 - _loc5_.mood) / 100 * 20;
                              }
                           }
                        }
                        _loc4_++;
                     }
                     if(Calculate.chance(Math.min(_loc2_,80)))
                     {
                        this._doEntertain = true;
                        this._entertainDelay = 35;
                        currentAnimation = "entertain";
                        this._entertainProgress = 20;
                        if(_level >= 3)
                        {
                           addListenerOf(this,LoopEvent.ON_IDLE,this.checkLevel3Perform);
                        }
                        _movePoint = null;
                        _floorTarget = null;
                        _floorPoint = null;
                        _destinationTransport = null;
                        _transportQueue = new Array();
                     }
                  }
               }
            }
         }
      }
      
      function checkLevel3Perform(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(numChildren > 0)
         {
            _loc2_ = this.getChildAt(0);
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.getChildAt(0);
               if(_loc3_ is MovieClip)
               {
                  if(_loc3_.currentFrame >= _loc3_.totalFrames)
                  {
                     currentAnimation = Animation.IDLE;
                     this._entertainProgress = 0;
                     removeListenerOf(this,LoopEvent.ON_IDLE,this.checkLevel3Perform);
                  }
               }
            }
         }
      }
      
      override function afterUpgradeCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this._doEntertain)
         {
            _loc1_ = this.getChildAt(0);
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_.getChildAt(0);
               if(_loc2_ is MovieClip)
               {
                  _loc2_.gotoAndStop(1);
                  if(_level >= 3)
                  {
                     addListenerOf(this,LoopEvent.ON_IDLE,this.checkLevel3Perform);
                  }
               }
            }
         }
      }
      
      override function movingCheck(param1:LoopEvent) : void
      {
         if(!this._doEntertain && !this._doCounter)
         {
            super.movingCheck(param1);
         }
      }
      
      override function animationCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         super.animationCheck(param1);
         if(_currentAnimation == "entertain")
         {
            if(numChildren > 0)
            {
               _loc2_ = this.getChildAt(0);
               if(_loc2_ != null)
               {
                  _loc3_ = _loc2_.getChildAt(0);
                  if(_loc3_ is MovieClip)
                  {
                     _loc3_.stop();
                     if(_loc3_.currentFrame < _loc3_.totalFrames)
                     {
                        _loc3_.nextFrame();
                     }
                     else
                     {
                        _loc3_.gotoAndStop(1);
                     }
                  }
               }
            }
         }
      }
      
      function entertainProgress() : void
      {
         if(this._doEntertain)
         {
            if(this._entertainProgress > 0)
            {
               if(_level < 3)
               {
                  --this._entertainProgress;
               }
            }
            else
            {
               this._doEntertain = false;
               this.searchTarget();
               checkDepletedVitality();
            }
         }
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         if(!_recovery)
         {
            if(!this._doEntertain)
            {
               if(!this._doCounter)
               {
                  if(this._toPick == null)
                  {
                     this.checkAround();
                     this.searchTarget();
                     super.behavior(param1);
                  }
                  else
                  {
                     this.pickingCheck();
                  }
               }
            }
            else
            {
               this.staminaCheck();
               this.entertainProgress();
            }
         }
         else
         {
            recoveryCheck();
         }
      }
      
      override function staminaCheck() : void
      {
         var _loc1_:* = undefined;
         if(!this._doEntertain)
         {
            super.staminaCheck();
         }
         else
         {
            _loc1_ = staminaLossModifier * 2 / STAMINA_LV[_level - 1];
            if(lossCarry > 100)
            {
               _loc1_ += Math.floor(lossCarry / 100);
               lossCarry -= 100;
            }
            _vitality -= Math.floor(_loc1_);
            if(_vitality < 0)
            {
               _vitality = 0;
               lossCarry = 0;
            }
            else
            {
               lossCarry += Math.round(_loc1_ * 100) % 100;
            }
            dispatchEvent(new HumanEvent(HumanEvent.UPDATE_VITALITY));
         }
      }
      
      override function expBehavior(param1:HumanEvent) : void
      {
         super.expBehavior(param1);
         if(!(_inHome && !_skipWork) && _destination != "home")
         {
            if(this._doEntertain)
            {
               if(this.canGain)
               {
                  gainExp(1);
               }
               this.canGain = !this.canGain;
            }
         }
      }
      
      override function get inWorking() : Boolean
      {
         return this._doEntertain || _doingJob;
      }
      
      function pickingCheck() : void
      {
         if(this._toPick != null)
         {
            if(!_doingJob)
            {
               _doingJob = true;
               currentAnimation = "happy";
               addListenerOf(this,LoopEvent.ON_IDLE,this.afterPickCheck);
            }
         }
      }
      
      function afterPickCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         if(this._toPick != null)
         {
            if(currentAnimation == "happy")
            {
               if(this.currentFrameLabel == "pick")
               {
                  this._toPick.taken = true;
                  this._toPick.y = this.y - this.height - 5;
               }
               if(this.currentFrameLabel == "happy_end")
               {
                  gainExp(4);
                  _loc2_ = this._performCoin.indexOf(this._toPick);
                  if(_loc2_ in this._performCoin)
                  {
                     this._performCoin.splice(_loc2_,1);
                  }
                  this._toPick = null;
                  currentAnimation = "idle";
                  _doingJob = false;
                  removeListenerOf(this,LoopEvent.ON_IDLE,this.afterPickCheck);
               }
            }
            else
            {
               currentAnimation = "happy";
            }
         }
         else
         {
            currentAnimation = "idle";
            _doingJob = false;
            removeListenerOf(this,LoopEvent.ON_IDLE,this.afterPickCheck);
         }
      }
      
      override function searchTarget() : void
      {
         if(_destination == null)
         {
            if(!_inHome && !_doingJob)
            {
               _destination = this.searchBonusDrop();
               if(_destination != null)
               {
                  super.destinationTargetCheck();
               }
            }
         }
      }
      
      function searchBonusDrop() : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = _world.bonusList;
         var _loc3_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc4_:* = Infinity;
         var _loc5_:* = 0;
         while(_loc5_ < _loc2_.length)
         {
            if(!(_loc6_ = _loc2_[_loc5_]).taken)
            {
               if(_loc6_.y == _loc3_.y)
               {
                  if(inSight(_loc6_) || this._performCoin.indexOf(_loc6_) >= 0)
                  {
                     if((_loc7_ = Math.abs(_loc6_.x - _loc3_.x)) < _loc4_)
                     {
                        if(_loc6_.picker != null && _loc6_.picker != this)
                        {
                           _loc8_ = _world.mainContainer.globalToLocal(_loc6_.picker.localToGlobal(new Point(0,0)));
                           _loc10_ = (_loc9_ = Math.abs(_loc6_.x - _loc8_.x)) / _loc6_.picker.getSpeed();
                           if((_loc11_ = _loc7_ / getSpeed()) < _loc10_)
                           {
                              _loc1_ = _loc6_;
                              _loc4_ = _loc7_;
                           }
                        }
                        else
                        {
                           _loc1_ = _loc6_;
                           _loc4_ = _loc7_;
                        }
                     }
                     else if(_loc7_ == _loc4_)
                     {
                        if(_loc6_.picker == null && Calculate.chance(50))
                        {
                           _loc1_ = _loc6_;
                           _loc4_ = _loc7_;
                        }
                     }
                  }
               }
            }
            _loc5_++;
         }
         if(_loc1_ != null)
         {
            if(_loc1_.picker != null)
            {
               _loc1_.picker.destination = null;
            }
            _loc1_.picker = this;
         }
         return _loc1_;
      }
      
      override function destinationTargetCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(_destination is Bonus)
         {
            _loc1_ = _world.getFloorAt(_destination.y);
            _loc2_ = _world.mainContainer.globalToLocal(_destination.localToGlobal(new Point(0,0)));
            _loc3_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc4_ = true;
            if(_loc1_ == _floorStep)
            {
               if(_inside == null)
               {
                  _floorTarget = null;
                  if((_loc5_ = Math.abs(_loc2_.x - _loc3_.x)) > 0)
                  {
                     if(_movePoint == null || _movePoint.x != _loc2_.x)
                     {
                        _movePoint = new Point(_loc2_.x,_loc2_.y);
                     }
                  }
                  else
                  {
                     _movePoint = null;
                     this._toPick = _destination;
                     _destination = null;
                  }
                  _destinationTransport = null;
                  _transportQueue = new Array();
               }
               else if(_world.transportList.indexOf(_inside) >= 0 || _inside is FacilityElevatorBody)
               {
                  _loc4_ = false;
               }
            }
            else
            {
               _loc4_ = false;
            }
            if(!_loc4_)
            {
               if(_floorTarget == null || _floorTarget != _loc1_)
               {
                  _floorTarget = _loc1_;
                  _floorPoint = _loc2_;
                  _destinationTransport = null;
                  _transportQueue = new Array();
               }
            }
         }
         else
         {
            super.destinationTargetCheck();
         }
      }
      
      function afterCounterCheck(param1:LoopEvent) : void
      {
         if(currentAnimation == "happy")
         {
            if(this.currentFrameLabel == "happy_end")
            {
               currentAnimation = "idle";
               this._doCounter = false;
               removeListenerOf(this,LoopEvent.ON_IDLE,this.afterCounterCheck);
            }
         }
         else
         {
            currentAnimation = "happy";
         }
      }
      
      function animationCounterSpell(param1:LoopEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.currentFrame < _loc2_.totalFrames)
         {
            _loc2_.nextFrame();
         }
         else
         {
            removeListenerOf(_loc2_,LoopEvent.ON_IDLE,this.animationCounterSpell);
            if(_loc2_.stage != null)
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         }
      }
      
      public function counterSpell() : void
      {
         if(!this._doEntertain && !_doingJob)
         {
            this._doCounter = true;
            currentAnimation = "happy";
            nextFrameQueue = "pick";
            addListenerOf(this,LoopEvent.ON_IDLE,this.afterCounterCheck);
         }
         var _loc1_:* = new CounterClip();
         _loc1_.x = this.x;
         _loc1_.y = this.y - this.height - 5;
         _loc1_.stop();
         addListenerOf(_loc1_,LoopEvent.ON_IDLE,this.animationCounterSpell);
         var _loc2_:* = this.parent;
         var _loc3_:* = _loc2_.getChildIndex(this);
         _loc2_.addChildAt(_loc1_,_loc3_ + 1);
         dispatchEvent(new HumanEvent(HumanEvent.COUNTER_SPELL));
      }
      
      public function get doEntertain() : Boolean
      {
         return this._doEntertain;
      }
      
      public function get doCounter() : Boolean
      {
         return this._doEntertain;
      }
      
      public function get performCoin() : Array
      {
         return this._performCoin;
      }
      
      public function get toPick() : *
      {
         return this._toPick;
      }
   }
}
