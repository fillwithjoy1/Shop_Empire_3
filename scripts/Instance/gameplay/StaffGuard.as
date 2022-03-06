package Instance.gameplay
{
   import Instance.SEMovieClip;
   import Instance.constant.UpgradeData;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import Instance.property.Booth;
   import Instance.property.Elevator;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityStairs;
   import Instance.property.HalteWagon;
   import Instance.property.SonicBeamFX;
   import Instance.property.Wagon;
   import Instance.sprite.Animation;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class StaffGuard extends Staff
   {
       
      
      var _targetToCaught:Array;
      
      var _targetInSight:Array;
      
      var _caughtInBooth:Array;
      
      var _enterCaught:Array;
      
      var _thrownThief:Array;
      
      var _thrownDirrection:Array;
      
      var _chaseTarget;
      
      var _guardPost;
      
      var _activatedAbility;
      
      var _abilityCooldown:int;
      
      var _dashTime:int;
      
      var _casting:Boolean;
      
      var strangeDoorOpen;
      
      var _castingTime:int;
      
      var _transUp:Boolean;
      
      var _afterCastDelay:int;
      
      public function StaffGuard()
      {
         super();
         this._targetToCaught = new Array();
         this._targetInSight = new Array();
         this._caughtInBooth = new Array();
         this._enterCaught = new Array();
         this._thrownThief = new Array();
         this._thrownDirrection = new Array();
         this._chaseTarget = null;
         this._guardPost = null;
         this._activatedAbility = null;
         this._abilityCooldown = 0;
         this._dashTime = 0;
         this._casting = false;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(_world.alarmTrigger && this._guardPost == null)
         {
            this.lockAllThief();
         }
         addListenerOf(_world,HumanEvent.ESCAPE_FROM_GUARD,this.whenThiefEscape);
         addListenerOf(_world,GameEvent.BEFORE_DESTROY_CHECK,this.beforeBuildingWasDestroyed);
         addListenerOf(_world,GameEvent.ALARM_TRIGGERED,this.whenAlarmTrigger);
      }
      
      function whenAlarmTrigger(param1:GameEvent) : void
      {
         if(this._guardPost == null && !_fired && _destination != "home")
         {
            this.lockAllThief();
         }
      }
      
      function lockAllThief() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < _world.thiefList.length)
         {
            _loc2_ = _world.thiefList[_loc1_];
            if(!_loc2_.isCaught)
            {
               if(this._targetToCaught.indexOf(_loc2_) < 0)
               {
                  this._targetToCaught.push(_loc2_);
               }
            }
            _loc1_++;
         }
      }
      
      function beforeBuildingWasDestroyed(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.target;
         if(_inside == _loc2_)
         {
            while(this._enterCaught.length > 0)
            {
               _loc3_ = this._enterCaught.shift();
               _loc3_.stopVanish = true;
               _loc3_.caught();
               _loc3_.gotoAndStop("arrested_end");
               this._caughtInBooth.push(_loc3_);
               _loc3_.dispatchEvent(new GameEvent(GameEvent.ARRESTED));
            }
         }
      }
      
      override public function loadCondition(param1:*) : void
      {
         super.loadCondition(param1);
         if(param1.activatedAbility != null)
         {
            this._activatedAbility = param1.activatedAbility;
         }
         if(param1.abilityCooldown != null)
         {
            this._abilityCooldown = param1.abilityCooldown;
         }
      }
      
      override public function saveCondition(param1:*) : void
      {
         super.saveCondition(param1);
         if(this._guardPost != null)
         {
            param1.guardPost = _world.main.getCodeNameOf(this._guardPost);
         }
         param1.activatedAbility = this._activatedAbility;
         param1.abilityCooldown = this._abilityCooldown;
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         if(!this._casting)
         {
            if(this._dashTime <= 0)
            {
               if(this._abilityCooldown > 0)
               {
                  --this._abilityCooldown;
               }
            }
            this.checkBanditIsOutRange();
            if(!_inHome && !_doingJob && !_recovery)
            {
               this.searchTarget();
               this.abilityProgress();
            }
            if(this._guardPost != null)
            {
               this.guardPostCheck();
               if(this._guardPost.guardInPosition)
               {
                  this.guardingProgress();
               }
               else
               {
                  differentFloorTargetCheck();
                  insideBuildingCheck();
               }
            }
            else
            {
               super.behavior(param1);
            }
         }
      }
      
      override public function getSpeed() : Number
      {
         if(this._dashTime > 0)
         {
            return _stat.countSpeed() * SPEED_LV[_level - 1];
         }
         return _stat.countSpeed() * SPEED_LV[_level - 1] / modTired;
      }
      
      override public function runSpeed() : Number
      {
         if(this._dashTime > 0)
         {
            return super.runSpeed() * 2.4;
         }
         return super.runSpeed();
      }
      
      function abilityProgress() : void
      {
         if(this._abilityCooldown <= 0 && _inside == null)
         {
            if(this._chaseTarget != null)
            {
               if(this._activatedAbility != null)
               {
                  if(this._activatedAbility == UpgradeData.SACRED_BOOTS)
                  {
                     if(!this._casting)
                     {
                        if(this._targetInSight.indexOf(this._chaseTarget) >= 0)
                        {
                           if(this._dashTime <= 0)
                           {
                              if(Calculate.chance(25))
                              {
                                 this._dashTime = 60;
                                 this._abilityCooldown = 30;
                              }
                           }
                        }
                     }
                  }
                  else if(this._activatedAbility == UpgradeData.BLESSED_GUARD)
                  {
                     if(this._dashTime <= 0 && !this._casting && _inside == null)
                     {
                        if(this._targetInSight.indexOf(this._chaseTarget) >= 0 && inSight(this._chaseTarget))
                        {
                           if(Calculate.chance(25))
                           {
                              this.castingSonicBlade();
                           }
                        }
                     }
                  }
               }
            }
            else
            {
               this._dashTime = 0;
            }
         }
      }
      
      function castingProgress(param1:LoopEvent) : void
      {
         var _loc2_:ColorTransform = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this._castingTime > 0)
         {
            --this._castingTime;
            if(!_promoteMode)
            {
               _loc2_ = this.transform.colorTransform;
               _loc3_ = _loc2_.redOffset;
               _loc4_ = _loc2_.greenOffset;
               _loc5_ = _loc2_.blueOffset;
               if(this._transUp)
               {
                  if(_loc3_ + 64 < 255)
                  {
                     _loc3_ += 64;
                     _loc4_ += 64;
                     _loc5_ += 64;
                  }
                  else
                  {
                     this._transUp = false;
                     _loc3_ = 255;
                     _loc4_ = 255;
                     _loc5_ = 255;
                  }
               }
               else if(_loc3_ - 64 > 0)
               {
                  _loc3_ -= 64;
                  _loc4_ -= 64;
                  _loc5_ -= 64;
               }
               else
               {
                  this._transUp = true;
                  _loc3_ = 0;
                  _loc4_ = 0;
                  _loc5_ = 0;
               }
               _loc2_.redOffset = _loc3_;
               _loc2_.greenOffset = _loc4_;
               _loc2_.blueOffset = _loc5_;
               this.transform.colorTransform = _loc2_;
            }
         }
         else
         {
            if(!_promoteMode)
            {
               _loc2_ = this.transform.colorTransform;
               _loc2_.redOffset = 0;
               _loc2_.greenOffset = 0;
               _loc2_.blueOffset = 0;
               this.transform.colorTransform = _loc2_;
            }
            removeListenerOf(this,LoopEvent.ON_IDLE,this.castingProgress);
            addListenerOf(this,LoopEvent.ON_IDLE,this.launchSonicBeam);
         }
      }
      
      function launchSonicBeam(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.currentFrameLabel != "attack_end")
         {
            this.nextFrame();
            _loc2_ = Utility.getLabelIndex(this,"attack_end") - 3;
            if(this.currentFrame == _loc2_)
            {
               _loc3_ = new SonicBeamFX();
               _loc3_.x = this.x + 32 * scaleX;
               _loc3_.y = this.y - 16;
               _loc3_.priority = 4;
               _loc3_.scaleX = scaleX;
               _loc3_.world = _world;
               _loc3_.launchDistance = getSight();
               _world.frontContainer.addChild(_loc3_);
               _world.needToSwapObject.push(_loc3_);
               _world.swapDepthObject();
               if(this._guardPost == null)
               {
                  _loc4_ = staminaLossModifier * 30 / STAMINA_LV[level - 1];
                  if(lossCarry > 100)
                  {
                     _loc4_ += Math.floor(lossCarry / 100);
                     lossCarry -= 100;
                  }
                  _vitality -= Math.floor(_loc4_);
                  if(_vitality < 0)
                  {
                     _vitality = 0;
                     lossCarry = 0;
                  }
                  else
                  {
                     lossCarry += Math.round(_loc4_ * 100) % 100;
                  }
                  dispatchEvent(new HumanEvent(HumanEvent.UPDATE_VITALITY));
               }
            }
         }
         else
         {
            currentAnimation = Animation.IDLE;
            removeListenerOf(this,LoopEvent.ON_IDLE,this.launchSonicBeam);
            addListenerOf(this,LoopEvent.ON_IDLE,this.afterCastingProgress);
         }
      }
      
      function afterCastingProgress(param1:LoopEvent) : void
      {
         if(this._afterCastDelay > 0)
         {
            --this._afterCastDelay;
         }
         else
         {
            this._casting = false;
            checkDepletedVitality();
            removeListenerOf(this,LoopEvent.ON_IDLE,this.afterCastingProgress);
         }
      }
      
      function castingSonicBlade() : void
      {
         this._castingTime = 20;
         this._afterCastDelay = 15;
         this._transUp = true;
         this._casting = true;
         this._abilityCooldown = 30;
         currentAnimation = null;
         var _loc1_:* = Utility.getLabelIndex(this,"attack");
         this.gotoAndStop(_loc1_ + 2);
         addListenerOf(this,LoopEvent.ON_IDLE,this.castingProgress);
      }
      
      function guardingProgress() : void
      {
         if(_currentAnimation != Animation.IDLE)
         {
            currentAnimation = Animation.IDLE;
         }
         if(Calculate.chance(15))
         {
            this.scaleX = -this.scaleX;
         }
      }
      
      function guardPostCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this._chaseTarget == null)
         {
            if(this._guardPost != null)
            {
               _loc1_ = _world.getFloorAt(this._guardPost.y);
               _loc2_ = new Point(this._guardPost.x,this._guardPost.y);
               _loc3_ = false;
               if(_loc1_ == _floorStep)
               {
                  if(_inside == null)
                  {
                     _loc3_ = true;
                     _floorTarget = null;
                     if((_loc4_ = Math.abs(this.x - _loc2_.x)) > 0)
                     {
                        if(_movePoint == null || (_movePoint.x != _loc2_.x || _movePoint.y != _loc2_.y))
                        {
                           _movePoint = new Point(_loc2_.x,_loc2_.y);
                           this._guardPost.guardInPosition = false;
                        }
                     }
                     else
                     {
                        _movePoint = null;
                        this._guardPost.guardInPosition = true;
                     }
                     _destinationTransport = null;
                     _transportQueue = new Array();
                  }
               }
               if(!_loc3_)
               {
                  if(_floorTarget == null || _floorTarget != _loc1_)
                  {
                     _floorTarget = _loc1_;
                     _floorPoint = new Point(_loc2_.x,_loc2_.y);
                     _destinationTransport = null;
                     _transportQueue = new Array();
                  }
               }
            }
         }
      }
      
      override function checkGameTime(param1:GameEvent) : void
      {
         if(this._guardPost == null)
         {
            super.checkGameTime(param1);
         }
      }
      
      function whenThiefEscape(param1:HumanEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = this._targetToCaught.indexOf(_loc2_);
         if(_loc3_ in this._targetToCaught)
         {
            this._targetToCaught.splice(_loc3_,1);
         }
         _loc3_ = this._targetInSight.indexOf(_loc2_);
         if(_loc3_ in this._targetInSight)
         {
            this._targetInSight.splice(_loc3_,1);
         }
      }
      
      function checkBanditIsOutRange() : void
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
         if(_destination != "home" && !_inHome)
         {
            _loc1_ = new Array();
            _loc2_ = new Array();
            _loc3_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc4_ = 0;
            while(_loc4_ < this._targetToCaught.length)
            {
               if((_loc5_ = this._targetToCaught[_loc4_]).stage == null)
               {
                  _loc1_.push(_loc5_);
               }
               else if(_loc5_ is Thief && _world.thiefList.indexOf(_loc5_) < 0)
               {
                  _loc1_.push(_loc5_);
               }
               else if(_loc5_ is Litter && _world.litterList.indexOf(_loc5_) < 0)
               {
                  _loc1_.push(_loc5_);
               }
               else
               {
                  _loc6_ = _world.mainContainer.globalToLocal(_loc5_.localToGlobal(new Point(0,0)));
                  if((_loc7_ = Math.abs(_loc6_.y - _loc3_.y)) >= 126)
                  {
                     if(!(_world.alarmTrigger && this._guardPost == null))
                     {
                        _loc1_.push(_loc5_);
                     }
                     else
                     {
                        _loc2_.push(_loc5_);
                     }
                  }
                  else if((_loc8_ = Math.abs(_loc6_.x - _loc3_.x)) >= getSight() * 1.5)
                  {
                     if(!(_world.alarmTrigger && this._guardPost == null))
                     {
                        _loc1_.push(_loc5_);
                     }
                     else
                     {
                        _loc2_.push(_loc5_);
                     }
                  }
                  if(_loc5_.isCaught)
                  {
                     _loc1_.push(_loc5_);
                  }
                  else if(_loc5_.inside is Elevator)
                  {
                     _loc1_.push(_loc5_);
                  }
               }
               _loc4_++;
            }
            while(_loc1_.length > 0)
            {
               _loc5_ = _loc1_.pop();
               if((_loc9_ = this._targetToCaught.indexOf(_loc5_)) >= 0)
               {
                  this._targetToCaught.splice(_loc9_,1);
               }
               if((_loc9_ = this._targetInSight.indexOf(_loc5_)) >= 0)
               {
                  this._targetInSight.splice(_loc9_,1);
               }
            }
            while(_loc2_.length > 0)
            {
               _loc5_ = _loc2_.pop();
               if((_loc9_ = this._targetInSight.indexOf(_loc5_)) >= 0)
               {
                  this._targetInSight.splice(_loc9_,1);
               }
            }
         }
         else
         {
            while(this._targetToCaught.length > 0)
            {
               this._targetToCaught.shift();
            }
            while(this._targetInSight.length > 0)
            {
               this._targetInSight.shift();
            }
         }
      }
      
      function createShadow() : void
      {
         var fadingProgress:Function = null;
         fadingProgress = function(param1:LoopEvent):void
         {
            var _loc2_:* = param1.currentTarget;
            if(_loc2_.alpha > 0)
            {
               _loc2_.alpha = Math.max(0,_loc2_.alpha - 0.08);
            }
            else
            {
               _loc2_.parent.removeChild(_loc2_);
            }
         };
         var newClip:* = new SEMovieClip();
         var rect:Rectangle = this.getBounds(this);
         var bitmap:* = Utility.crop(this,rect.x,rect.y,rect.width,rect.height);
         var lPoint:* = localToGlobal(new Point(-1,0)).x;
         var rPoint:* = localToGlobal(new Point(1,0)).x;
         bitmap.x = rect.x;
         bitmap.y = rect.y;
         newClip.addChild(bitmap);
         newClip.alpha = 0.9;
         newClip.x = this.x;
         newClip.y = this.y;
         newClip.scaleX = this.scaleX;
         newClip.transform.colorTransform = new ColorTransform(1,0.4,0.4,0.9,0,0,0,0);
         var index:* = this.parent.getChildIndex(this);
         this.parent.addChildAt(newClip,index);
         newClip.addListenerOf(newClip,LoopEvent.ON_IDLE,fadingProgress);
      }
      
      override function movingCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         if(!_doingJob && !_recovery && !this._casting)
         {
            if(!_inHome && _destination != "home")
            {
               if(this._dashTime <= 0)
               {
                  _loc2_ = this._chaseTarget;
                  this._chaseTarget = this.getNearestTarget();
                  if(this._chaseTarget == null && _loc2_ != null)
                  {
                     _movePoint = null;
                  }
               }
               if(this._chaseTarget != null)
               {
                  if(this._guardPost != null)
                  {
                     this._guardPost.guardInPosition = false;
                  }
                  _run = true;
                  this.pursueTheTarget(this._chaseTarget);
                  if(this._dashTime > 0)
                  {
                     --this._dashTime;
                     this.createShadow();
                  }
               }
               else
               {
                  if(_inside is FacilityStairs)
                  {
                     if(_floorTarget == null)
                     {
                        _loc3_ = _inside.upperEnterance;
                        _loc4_ = _inside.lowerEnterance;
                        _loc5_ = new Array();
                        _loc6_ = new Array();
                        _loc7_ = _world.getFloorAt(_loc3_.y);
                        _loc8_ = _world.getFloorAt(_loc4_.y);
                        if(_world.floorList.indexOf(_loc7_) >= 0 && _world.floorList.indexOf(_loc7_) < _world.floorList.length - 1)
                        {
                           _loc5_.push(_loc7_);
                        }
                        if(_world.floorList.indexOf(_loc8_) >= 0 && _world.floorList.indexOf(_loc8_) < _world.floorList.length - 1)
                        {
                           _loc5_.push(_loc8_);
                        }
                        _loc9_ = Math.floor(Math.random() * _loc5_.length);
                        _floorTarget = _loc5_[_loc9_];
                     }
                  }
                  _run = false;
                  if(this._dashTime > 0)
                  {
                     this._dashTime = 0;
                  }
               }
            }
            else
            {
               _run = false;
            }
            super.movingCheck(param1);
         }
      }
      
      override function get additionalVitalityCheck() : Boolean
      {
         return this._dashTime > 0 || this._casting;
      }
      
      override function whenEnterTheBuilding(param1:HumanEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         super.whenEnterTheBuilding(param1);
         if(_inside != null)
         {
            if(_inside is FacilityStairs)
            {
               this.searchTarget();
            }
            if(_world.transportList.indexOf(_inside) < 0 && !(_inside is FacilityElevatorBody))
            {
               this.visible = false;
               _loc2_ = 0;
               while(_loc2_ < _world.thiefList.length)
               {
                  _loc3_ = _world.thiefList[_loc2_];
                  if(_loc3_.inside == _inside)
                  {
                     if(this._dashTime > 0)
                     {
                        this._dashTime = 0;
                     }
                     if(this._targetToCaught.indexOf(_loc3_) >= 0)
                     {
                        _loc3_.isCaught = true;
                        this._enterCaught.push(_loc3_);
                     }
                     else
                     {
                        _loc4_ = (_loc3_.stat.sight + _loc3_.stat.speed) / 2;
                        if(Calculate.chance(_loc4_))
                        {
                           _loc3_.isCaught = true;
                           this._enterCaught.push(_loc3_);
                        }
                     }
                  }
                  _loc2_++;
               }
               addListenerOf(this,HumanEvent.EXIT_THE_BUILDING,this.afterExitCaught);
            }
         }
      }
      
      override function whenExitTheBuilding(param1:HumanEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         super.whenExitTheBuilding(param1);
         this.visible = true;
         if(param1.tag is FacilityElevatorBody)
         {
            _loc2_ = param1.tag;
            _loc3_ = new Array();
            _loc4_ = 0;
            while(_loc4_ < _world.thiefList.length)
            {
               if((_loc5_ = _world.thiefList[_loc4_]).inside == _loc2_)
               {
                  _loc3_.push(_loc5_);
               }
               _loc4_++;
            }
            if(_loc3_.length > 0)
            {
               _doingJob = true;
               currentAnimation = "attack";
               addListenerOf(this,LoopEvent.ON_IDLE,this.afterCaughtCheck);
            }
            while(_loc3_.length > 0)
            {
               (_loc6_ = _loc3_.shift()).caught();
               _loc6_.dispatchEvent(new GameEvent(GameEvent.ARRESTED));
            }
         }
         this.searchTarget();
      }
      
      override function insideElevatorCheck() : void
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
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         if(!_doingJob)
         {
            if(this._caughtInBooth.length == 0)
            {
               if(_inside is Elevator)
               {
                  if(_inside.activeRoom == null)
                  {
                     _loc1_ = 0;
                     while(_loc1_ < _world.thiefList.length)
                     {
                        _loc2_ = _world.thiefList[_loc1_];
                        if(_loc2_.inside == _inside)
                        {
                           _loc2_.floorTarget = null;
                           _loc2_.floorPoint = null;
                           _loc3_ = _inside.escapePassanger.indexOf(_loc2_);
                           if(_loc3_ in _inside.escapePassanger)
                           {
                              _inside.escapePassanger.splice(_loc3_,1);
                           }
                           _loc2_.stopVanish = true;
                           this._caughtInBooth.push(_loc2_);
                        }
                        _loc1_++;
                     }
                     _loc1_ = 0;
                     while(_loc1_ < this._caughtInBooth.length)
                     {
                        _loc2_ = this._caughtInBooth[_loc1_];
                        _loc2_.caught();
                        _loc1_++;
                     }
                  }
               }
               if(_inside is FacilityElevatorBody)
               {
                  if(_inside.enableToEnter)
                  {
                     _loc4_ = _inside.elevatorLink;
                     _loc1_ = 0;
                     while(_loc1_ < _world.thiefList.length)
                     {
                        _loc2_ = _world.thiefList[_loc1_];
                        if(_loc2_.inside == _loc4_)
                        {
                           if(_loc4_.escapePassanger.indexOf(_loc2_) >= 0)
                           {
                              _loc2_.floorTarget = null;
                              _loc2_.floorPoint = null;
                              _loc2_.destination = null;
                              _loc2_.isCaught = true;
                              this._caughtInBooth.push(_loc2_);
                              _loc4_.removePerson(_loc2_);
                           }
                        }
                        _loc1_++;
                     }
                     _loc1_ = 0;
                     while(_loc1_ < this._caughtInBooth.length)
                     {
                        if((_loc5_ = _world.thiefList.indexOf(this._caughtInBooth[_loc1_])) in _world.thiefList)
                        {
                           _world.thiefList.splice(_loc5_,1);
                        }
                        if((_loc6_ = this._targetToCaught.indexOf(this._caughtInBooth[_loc1_])) in this._targetToCaught)
                        {
                           this._targetToCaught.splice(_loc6_,1);
                        }
                        if((_loc6_ = this._targetInSight.indexOf(this._caughtInBooth[_loc1_])) in this._targetInSight)
                        {
                           this._targetInSight.splice(_loc6_,1);
                        }
                        _loc1_++;
                     }
                  }
               }
               if(this._caughtInBooth.length == 0)
               {
                  super.insideElevatorCheck();
               }
            }
            else
            {
               if(_inside is Elevator)
               {
                  if(_inside.activeRoom != null)
                  {
                     if((_loc7_ = _inside.activeRoom).enableToEnter)
                     {
                        _loc8_ = _loc7_.enterancePosition;
                        _loc9_ = new Array();
                        _loc1_ = 0;
                        while(_loc1_ < this._caughtInBooth.length)
                        {
                           if((_loc10_ = this._caughtInBooth[_loc1_]).currentFrameLabel == "arrested_end")
                           {
                              _loc9_.push(_loc10_);
                           }
                           _loc1_++;
                        }
                        while(_loc9_.length > 0)
                        {
                           (_loc11_ = _loc9_.shift()).x = _loc8_.x;
                           _loc11_.y = _loc8_.y;
                           if((_loc12_ = _inside.passanger.indexOf(_loc11_)) in _inside.passanger)
                           {
                              _inside.passanger.splice(_loc12_,1);
                           }
                           _world.addHuman(_loc11_);
                           if(this._thrownThief.indexOf(_loc11_) < 0)
                           {
                              this._thrownThief.inside = null;
                              this._thrownThief.push(_loc11_);
                              this._thrownDirrection.push({
                                 "dx":Math.random() * 6 - 3,
                                 "dy":Math.floor(Math.random() * 4 + 3)
                              });
                              _loc11_.dispatchEvent(new GameEvent(GameEvent.ARRESTED));
                           }
                           _loc11_.addListenerOf(_loc11_,LoopEvent.ON_IDLE,this.throwTheThief);
                           if((_loc13_ = this._caughtInBooth.indexOf(_loc11_)) in this._caughtInBooth)
                           {
                              this._caughtInBooth.splice(_loc13_);
                           }
                        }
                     }
                  }
               }
               if(_inside is FacilityElevatorBody)
               {
                  if((_loc14_ = Math.abs(_inside.enterancePosition.x - this.x)) > 0)
                  {
                     if(_movePoint == null || _movePoint.x != _inside.enterancePosition.x)
                     {
                        _movePoint = new Point(_inside.enterancePosition.x,_inside.enterancePosition.y);
                     }
                  }
                  else
                  {
                     _movePoint = null;
                     _doingJob = true;
                     currentAnimation = "attack";
                     _loc15_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
                     while(this._caughtInBooth.length > 0)
                     {
                        (_loc10_ = this._caughtInBooth.shift()).caught();
                        _loc10_.x = _loc15_.x + Math.random() * 30 - 15;
                        _loc10_.y = _loc15_.y;
                        _world.addHuman(_loc10_);
                        _loc10_.dispatchEvent(new GameEvent(GameEvent.ARRESTED));
                     }
                     addListenerOf(this,LoopEvent.ON_IDLE,this.afterCaughtCheck);
                  }
               }
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
            _loc7_ = _world.mainContainer.globalToLocal(_loc2_.localToGlobal(new Point()));
            _loc8_ = 0;
            while(_loc8_ < _world.floorList.length)
            {
               if((_loc9_ = _world.floorList[_loc8_]).y >= _loc7_.y)
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
               _loc11_ = _loc2_.parent.globalToLocal(_world.mainContainer.localToGlobal(_loc7_));
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
               _loc2_.removeListenerOf(_loc2_,LoopEvent.ON_IDLE,this.throwTheThief);
            }
         }
      }
      
      override function insideBoothCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         super.insideBoothCheck();
         if(_inside != null && _inside != _world.dungeon && !(_inside is Wagon || _inside is HalteWagon))
         {
            if(_world.transportList.indexOf(_inside) < 0 && !(_inside is FacilityElevatorBody))
            {
               if(this._enterCaught.length > 0)
               {
                  _loc1_ = Math.abs(this._enterCaught[0].x - this.x);
                  if(_loc1_ > 0)
                  {
                     if(_movePoint == null || _movePoint.x != this._enterCaught[0].x)
                     {
                        _movePoint = new Point(this._enterCaught[0].x,this._enterCaught[0].y);
                     }
                  }
                  else
                  {
                     _loc2_ = this._enterCaught.shift();
                     _loc2_.stopVanish = true;
                     _loc2_.caught();
                     this._caughtInBooth.push(_loc2_);
                  }
               }
               else
               {
                  _loc3_ = true;
                  _loc4_ = 0;
                  while(_loc4_ < this._caughtInBooth.length)
                  {
                     if(this._caughtInBooth[_loc4_].currentFrameLabel != "arrested_end")
                     {
                        _loc3_ = false;
                        break;
                     }
                     _loc4_++;
                  }
                  if(_loc3_)
                  {
                     _destination = "exit";
                  }
               }
            }
         }
      }
      
      override function insideStairsCheck() : void
      {
         if(!_doingJob)
         {
            super.insideStairsCheck();
         }
      }
      
      function pursueTheTarget(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         _loc2_ = param1.onFloor;
         var _loc3_:* = onFloor;
         var _loc4_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc5_:* = _world.mainContainer.globalToLocal(param1.localToGlobal(new Point(0,0)));
         var _loc6_:* = Math.abs(_loc5_.x - _loc4_.x);
         var _loc7_:* = false;
         var _loc8_:* = false;
         if(_inside is FacilityStairs)
         {
            if(param1.inside == _inside)
            {
               if(_loc6_ > 20)
               {
                  _movePoint = this.parent.globalToLocal(_world.mainContainer.localToGlobal(new Point(_loc5_.x,_loc5_.y)));
               }
               else
               {
                  _movePoint = null;
                  _loc7_ = true;
               }
            }
            else if(param1.inside == null || param1.inside is FacilityElevatorBody)
            {
               if(_floorTarget != _loc2_)
               {
                  _floorTarget = _loc2_;
                  _floorPoint = new Point(_loc5_.x,_loc5_.y);
                  _movePoint = null;
                  _destinationTransport = null;
                  if(_transportQueue.length > 1 && _transportQueue[0] != _inside)
                  {
                     _transportQueue = [_inside];
                  }
                  this.insideStairsCheck();
               }
            }
         }
         else
         {
            if(_inside is FacilityElevatorBody)
            {
               if(_transportQueue.length == 0 || _transportQueue[0] != _inside)
               {
                  _inside.removePerson(this);
                  if((_loc9_ = _inside.queueLine.indexOf(this)) in _inside.queueLine)
                  {
                     _inside.queueLine.splice(_loc9_,1);
                  }
                  if((_loc10_ = _inside.elevatorLink) != null)
                  {
                     if((_loc11_ = _loc10_.passanger.indexOf(this)) in _loc10_.passanger)
                     {
                        _loc10_.passanger.splice(_loc11_,1);
                     }
                  }
                  _inside = null;
               }
            }
            if(_inside == null)
            {
               if(param1.inside == null || param1.inside is FacilityElevatorBody)
               {
                  if(_loc2_ == _loc3_)
                  {
                     if(_loc6_ > 20)
                     {
                        _movePoint = new Point(_loc5_.x,_loc5_.y);
                     }
                     else
                     {
                        _movePoint = null;
                        _loc7_ = true;
                     }
                     _destinationTransport = null;
                     _transportQueue = new Array();
                  }
                  else if(_floorTarget != _loc2_)
                  {
                     _destinationTransport = null;
                     _transportQueue = new Array();
                     _floorTarget = _loc2_;
                     _floorPoint = new Point(_loc5_.x,_loc5_.y);
                  }
               }
               else if(param1.inside is FacilityStairs)
               {
                  if((_loc12_ = param1.inside.entrancePosition(_loc4_.y)) != null)
                  {
                     if(_transportQueue.length != 1 || _transportQueue[0] != param1.inside)
                     {
                        _destinationTransport = null;
                        _transportQueue = [param1.inside];
                        _floorTarget = null;
                     }
                  }
               }
               else if(!(param1.inside is Elevator))
               {
                  _loc8_ = true;
                  if(_destination != param1.inside)
                  {
                     _destination = param1.inside;
                     super.destinationTargetCheck();
                  }
               }
            }
         }
         if(!_loc8_)
         {
            if(_destination != null)
            {
               _destination = null;
            }
         }
         if(_loc7_)
         {
            _doingJob = true;
            currentAnimation = "attack";
            param1.caught();
            param1.dispatchEvent(new GameEvent(GameEvent.ARRESTED));
            if((_loc13_ = this._targetToCaught.indexOf(param1)) in this._targetToCaught)
            {
               this._targetToCaught.splice(_loc13_,1);
            }
            if((_loc13_ = this._targetInSight.indexOf(param1)) in this._targetInSight)
            {
               this._targetInSight.splice(_loc13_,1);
            }
            if(this._dashTime > 0)
            {
               this._dashTime = 0;
            }
            addListenerOf(this,LoopEvent.ON_IDLE,this.afterCaughtCheck);
            param1.removeListenerOf(param1,HumanEvent.EXILE,this.thiefRemoved);
         }
      }
      
      override function staminaCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this._guardPost == null)
         {
            if(_run)
            {
               _loc1_ = staminaLossModifier * 5 / STAMINA_LV[_level - 1];
               if(this._dashTime > 0)
               {
                  _loc2_ = [1.8,1.6,1.3];
                  _loc1_ *= _loc2_[_level - 1];
               }
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
               checkDepletedVitality();
               dispatchEvent(new HumanEvent(HumanEvent.UPDATE_VITALITY));
            }
            else
            {
               super.staminaCheck();
            }
         }
      }
      
      override function expBehavior(param1:HumanEvent) : void
      {
         super.expBehavior(param1);
         if(!(_inHome && !_skipWork) && _destination != "home")
         {
            if(_run)
            {
               gainExp(2);
            }
         }
      }
      
      override function get inWorking() : Boolean
      {
         return _run || _doingJob;
      }
      
      function afterExitCaught(param1:HumanEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         while(this._caughtInBooth.length > 0)
         {
            _loc3_ = this._caughtInBooth.shift();
            _loc3_.x = _loc2_.x;
            _loc3_.y = _loc2_.y;
            _loc3_.visible = true;
            _world.addHuman(_loc3_);
            if(this._thrownThief.indexOf(_loc3_) < 0)
            {
               this._thrownThief.push(_loc3_);
               this._thrownDirrection.push({
                  "dx":Math.random() * 6 - 3,
                  "dy":Math.floor(Math.random() * 4 + 3)
               });
               _loc3_.dispatchEvent(new GameEvent(GameEvent.ARRESTED));
            }
            _loc3_.addListenerOf(_loc3_,LoopEvent.ON_IDLE,this.throwTheThief);
            if((_loc4_ = this._caughtInBooth.indexOf(_loc3_)) in this._caughtInBooth)
            {
               this._caughtInBooth.splice(_loc4_);
            }
            gainExp(15);
         }
         if(this._enterCaught.length > 0)
         {
            trace("masih ada maling didalam");
            while(this._enterCaught.length > 0)
            {
               (_loc5_ = this._enterCaught.shift()).isCaught = false;
            }
         }
      }
      
      function getNearestTarget() : *
      {
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:* = undefined;
         var _loc19_:* = undefined;
         var _loc20_:* = undefined;
         var _loc21_:* = undefined;
         var _loc22_:* = undefined;
         var _loc23_:* = undefined;
         var _loc24_:* = undefined;
         var _loc1_:* = null;
         var _loc2_:* = null;
         var _loc3_:* = Infinity;
         var _loc4_:* = Infinity;
         var _loc5_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc6_:* = onFloor;
         var _loc7_:* = _world.floorList.indexOf(_loc6_);
         var _loc8_:* = 0;
         while(_loc8_ < this._targetToCaught.length)
         {
            if(!(_loc9_ = this._targetToCaught[_loc8_]).isCaught)
            {
               _loc10_ = _loc9_.onFloor;
               _loc11_ = _world.mainContainer.globalToLocal(_loc9_.localToGlobal(new Point(0,0)));
               _loc12_ = Infinity;
               _loc13_ = Infinity;
               if(_inside is FacilityStairs)
               {
                  if(_loc9_.inside == _inside)
                  {
                     _loc12_ = Math.abs(this.x - _loc9_.x);
                     _loc13_ = 0;
                  }
               }
               else if(_inside == null)
               {
                  if(_loc9_.inside == null || _loc9_.inside is FacilityElevatorBody)
                  {
                     if(_loc6_ == _loc10_)
                     {
                        _loc12_ = Math.abs(_loc5_.x - _loc11_.x);
                        _loc13_ = 0;
                     }
                     else
                     {
                        _loc14_ = _world.floorList.indexOf(_loc10_);
                        _loc13_ = Math.abs(_loc7_ - _loc14_);
                     }
                  }
                  else if(_loc9_.inside is FacilityStairs)
                  {
                     if((_loc16_ = (_loc15_ = _loc9_.inside).entrancePosition(_loc5_.y)) != null)
                     {
                        _loc13_ = 0;
                        _loc12_ = Math.abs(_loc5_.x - _loc16_.x) + Math.abs(_loc16_.x - _loc11_.x);
                     }
                     else
                     {
                        _loc17_ = _loc15_.upperEnterance;
                        _loc18_ = _loc15_.lowerEnterance;
                        _loc19_ = _world.mainContainer.globalToLocal(_loc15_.localToGlobal(_loc17_));
                        _loc20_ = _world.mainContainer.globalToLocal(_loc15_.localToGlobal(_loc18_));
                        _loc21_ = _world.getFloorAt(_loc19_.y);
                        _loc22_ = _world.getFloorAt(_loc19_.y);
                        _loc23_ = _world.floorList.indexOf(_loc21_);
                        _loc24_ = _world.floorList.indexOf(_loc22_);
                        _loc13_ = Math.min(Math.abs(_loc7_ - _loc23_),Math.abs(_loc7_ - _loc24_));
                     }
                  }
               }
               if(_loc13_ < _loc4_)
               {
                  _loc2_ = _loc9_;
                  _loc4_ = _loc13_;
                  _loc3_ = _loc12_;
               }
               else if(_loc13_ == _loc3_)
               {
                  if(_loc2_ == null)
                  {
                     _loc2_ = _loc9_;
                     _loc4_ = _loc13_;
                     _loc3_ = _loc12_;
                  }
                  else if(_loc12_ < _loc3_)
                  {
                     _loc2_ = _loc9_;
                     _loc3_ = _loc12_;
                     _loc4_ = _loc13_;
                  }
                  else if(_loc12_ == _loc3_)
                  {
                     if(Calculate.chance(50))
                     {
                        _loc2_ = _loc9_;
                        _loc3_ = _loc12_;
                        _loc4_ = _loc13_;
                     }
                  }
               }
            }
            _loc8_++;
         }
         return _loc2_;
      }
      
      override function noTargetCheck() : void
      {
         if(this._targetToCaught.length <= 0)
         {
            super.noTargetCheck();
         }
      }
      
      function afterCaughtCheck(param1:LoopEvent) : void
      {
         if(currentAnimation == "attack")
         {
            if(this.currentFrameLabel == "attack_end")
            {
               currentAnimation = "idle";
               _doingJob = false;
               gainExp(15);
               removeListenerOf(this,LoopEvent.ON_IDLE,this.afterCaughtCheck);
            }
         }
         else
         {
            currentAnimation = "attack";
         }
      }
      
      override function searchTarget() : void
      {
         if(!_inHome && !_doingJob && _destination != "home")
         {
            this.searchThiefTarget();
            this.searchSaboteurTarget();
         }
      }
      
      function searchThiefTarget() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(_inside == null || _inside is FacilityElevatorBody || _inside is FacilityStairs)
         {
            _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc2_ = 0;
            while(_loc2_ < _world.thiefList.length)
            {
               _loc3_ = _world.thiefList[_loc2_];
               if(!(_loc3_.hiding && _loc3_.canHide || _loc3_.inside is Booth || _loc3_.inside is Elevator || _loc3_.isCaught))
               {
                  _loc4_ = this._targetToCaught.indexOf(_loc3_);
                  _loc5_ = this._targetInSight.indexOf(_loc3_);
                  if(_loc4_ < 0 || _loc5_ < 0)
                  {
                     _loc6_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
                     _loc7_ = false;
                     if(_inside is FacilityStairs)
                     {
                        if(_loc3_.inside == _inside)
                        {
                           _loc7_ = true;
                        }
                        else
                        {
                           _loc7_ = Math.abs(_loc6_.y - _loc1_.y) <= 60;
                        }
                     }
                     else if(_loc3_.inside == null || _loc3_.inside is FacilityElevatorBody)
                     {
                        _loc7_ = Math.abs(_loc6_.y - _loc1_.y) == 0;
                     }
                     else if(_loc3_.inside is FacilityStairs)
                     {
                        if((_loc8_ = _loc3_.inside.entrancePosition(_loc1_.y)) != null)
                        {
                           _loc7_ = Math.abs(_loc6_.y - _loc1_.y) <= 60;
                        }
                     }
                     if(inSight(_loc3_) && _loc7_)
                     {
                        if(_loc4_ < 0)
                        {
                           this._targetToCaught.push(_loc3_);
                        }
                        if(_loc5_ < 0)
                        {
                           this._targetInSight.push(_loc3_);
                        }
                        _loc3_.addListenerOf(_loc3_,HumanEvent.EXILE,this.thiefRemoved);
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      function searchSaboteurTarget() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(_inside == null || _inside is FacilityElevatorBody || _inside is FacilityStairs)
         {
            _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc2_ = 0;
            while(_loc2_ < _world.litterList.length)
            {
               _loc3_ = _world.litterList[_loc2_];
               if((_loc3_.sabotageProgress || _loc3_.evidence > 5 || !_loc3_.canHide) && !_loc3_.isCaught)
               {
                  _loc4_ = this._targetToCaught.indexOf(_loc3_);
                  _loc5_ = this._targetInSight.indexOf(_loc3_);
                  if(_loc4_ < 0 || _loc5_ < 0)
                  {
                     _loc6_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
                     _loc7_ = false;
                     if(_inside is FacilityStairs)
                     {
                        if(_loc3_.inside == _inside)
                        {
                           _loc7_ = true;
                        }
                        else
                        {
                           _loc7_ = Math.abs(_loc6_.y - _loc1_.y) <= 60;
                        }
                     }
                     else if(_loc3_.inside == null || _loc3_.inside is FacilityElevatorBody)
                     {
                        _loc7_ = Math.abs(_loc6_.y - _loc1_.y) == 0;
                     }
                     else if(_loc3_.inside is FacilityStairs)
                     {
                        if((_loc8_ = _loc3_.inside.entrancePosition(_loc1_.y)) != null)
                        {
                           _loc7_ = Math.abs(_loc6_.y - _loc1_.y) <= 60;
                        }
                     }
                     if(inSight(_loc3_) && _loc7_)
                     {
                        if(_loc4_ < 0)
                        {
                           this._targetToCaught.push(_loc3_);
                        }
                        if(_loc5_ < 0)
                        {
                           this._targetInSight.push(_loc3_);
                        }
                        _loc3_.addListenerOf(_loc3_,HumanEvent.EXILE,this.thiefRemoved);
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      function thiefRemoved(param1:Event) : void
      {
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this._targetToCaught.indexOf(_loc2_);
         if(_loc3_ in this._targetToCaught)
         {
            this._targetToCaught.splice(_loc3_,1);
         }
         _loc3_ = this._targetInSight.indexOf(_loc2_);
         if(_loc3_ in this._targetInSight)
         {
            this._targetInSight.splice(_loc3_,1);
         }
         if(this._targetToCaught.length == 0)
         {
            _movePoint = null;
            if(!_inHome && _destination != "home")
            {
               this.noTargetCheck();
            }
         }
         _loc2_.removeListenerOf(_loc2_,HumanEvent.EXILE,this.thiefRemoved);
      }
      
      public function get targetToCaught() : Array
      {
         return this._targetToCaught;
      }
      
      public function get chaseTarget() : *
      {
         return this._chaseTarget;
      }
      
      public function set guardPost(param1:*) : void
      {
         this._guardPost = param1;
      }
      
      public function get guardPost() : *
      {
         return this._guardPost;
      }
      
      public function set activatedAbility(param1:*) : void
      {
         this._activatedAbility = param1;
      }
      
      public function get activatedAbility() : *
      {
         return this._activatedAbility;
      }
   }
}
