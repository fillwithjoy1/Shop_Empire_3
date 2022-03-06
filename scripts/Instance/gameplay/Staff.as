package Instance.gameplay
{
   import Instance.constant.HumanData;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityStairs;
   import Instance.sprite.Animation;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class Staff extends Human
   {
       
      
      public const SPEED_LV = [1,1.2,1.5];
      
      public const SIGHT_LV = [1,1.1,1.3];
      
      public const STAMINA_LV = [1,1.4,2];
      
      public const TO_NEXT_LEVEL = [200,500];
      
      var _level:int;
      
      var _workTime:Object;
      
      var _arrival:Boolean;
      
      var _doingJob:Boolean;
      
      var _maxLevel:int;
      
      var _promoteMode:Boolean;
      
      var _promoteState:Boolean;
      
      var _fired:Boolean;
      
      var _workFloor:Object;
      
      var _salary:int;
      
      var _tiredTime:int;
      
      var _recovery:Boolean;
      
      var _basicPayment:int;
      
      var _salaryObject;
      
      var _skipWork:Boolean;
      
      var idleCtr:int;
      
      var lossCarry = 0;
      
      var gainCarry = 0;
      
      public function Staff()
      {
         super();
         this._level = 1;
         this._workTime = new Object();
         this._workTime.workStart = 9;
         this._workTime.workEnd = 19;
         this._workFloor = null;
         this._doingJob = false;
         _vitality = MAX_VITALITY;
         _exp = 0;
         this._maxLevel = 3;
         this._promoteMode = false;
         this._promoteState = false;
         this._fired = false;
         this._tiredTime = 0;
         this._recovery = false;
         this._salaryObject = this;
         this._skipWork = false;
         this.idleCtr = 90;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.checkSalary();
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.checkGameTime);
         addListenerOf(this,HumanEvent.UPDATE_BEHAVIOR,this.expBehavior);
         addListenerOf(this,CommandEvent.PROMOTE_STAFF,this.promotion);
         addListenerOf(this,GameEvent.FIRE,this.afterFired);
      }
      
      function promotion(param1:CommandEvent) : void
      {
         var _loc2_:* = undefined;
         if(this.expPercentage < 1)
         {
            _world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Unable to promote right now"));
         }
         else
         {
            _loc2_ = _world.main;
            if(_loc2_.isEnough(this.promotionCost))
            {
               if(!this._promoteMode)
               {
                  if(this._level < this._maxLevel)
                  {
                     this.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
                     this._promoteMode = true;
                     this._promoteState = true;
                     _world.addListenerOf(this,LoopEvent.ON_IDLE,this.flashingAnimate);
                     dispatchEvent(new HumanEvent(HumanEvent.BECOMES_PROMOTE,param1.tag));
                  }
               }
            }
            else
            {
               _world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Not Enough Money"));
            }
         }
      }
      
      function afterFired(param1:GameEvent) : void
      {
         if(_world.main.isEnough(this.serverenceCost))
         {
            this._fired = true;
            dispatchEvent(new HumanEvent(HumanEvent.BECOMES_FIRE));
         }
         else
         {
            _world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Not Enough Money"));
         }
      }
      
      function flashingAnimate(param1:LoopEvent) : void
      {
         var _loc2_:ColorTransform = this.transform.colorTransform;
         var _loc3_:* = _loc2_.redOffset;
         var _loc4_:* = _loc2_.greenOffset;
         var _loc5_:* = _loc2_.blueOffset;
         var _loc6_:* = false;
         if(_loc3_ + 32 < 255)
         {
            _loc3_ += 32;
            _loc4_ += 32;
            _loc5_ += 32;
         }
         else
         {
            _loc6_ = true;
            _loc3_ = 255;
            _loc4_ = 255;
            _loc5_ = 255;
         }
         _loc2_.redOffset = _loc3_;
         _loc2_.greenOffset = _loc4_;
         _loc2_.blueOffset = _loc5_;
         this.transform.colorTransform = _loc2_;
         if(_loc6_)
         {
            _world.removeListenerOf(this,LoopEvent.ON_IDLE,this.flashingAnimate);
            ++this._level;
            this._promoteState = false;
            _world.addListenerOf(this,LoopEvent.ON_IDLE,this.unflashingAnimate);
            this.checkSalary();
            this._tiredTime = 0;
            _vitality = MAX_VITALITY;
            _exp = 0;
            _fatigue = false;
            this.afterUpgradeCheck();
            dispatchEvent(new HumanEvent(HumanEvent.SUCCESFULLY_PROMOTED));
         }
      }
      
      function checkSalary() : void
      {
         this._salary = HumanData.getJobSalary(this);
      }
      
      function unflashingAnimate(param1:LoopEvent) : void
      {
         var _loc2_:ColorTransform = this.transform.colorTransform;
         var _loc3_:* = _loc2_.redOffset;
         var _loc4_:* = _loc2_.greenOffset;
         var _loc5_:* = _loc2_.blueOffset;
         if(_loc3_ - 32 > 0)
         {
            _loc3_ -= 32;
            _loc4_ -= 32;
            _loc5_ -= 32;
         }
         else
         {
            _loc3_ = 0;
            _loc4_ = 0;
            _loc5_ = 0;
            _world.removeListenerOf(this,LoopEvent.ON_IDLE,this.unflashingAnimate);
            this._promoteMode = false;
         }
         _loc2_.redOffset = _loc3_;
         _loc2_.greenOffset = _loc4_;
         _loc2_.blueOffset = _loc5_;
         this.transform.colorTransform = _loc2_;
      }
      
      function afterUpgradeCheck() : void
      {
      }
      
      override function spriteCheck(param1:Event) : void
      {
         var _loc2_:* = undefined;
         if(numChildren > 0)
         {
            _loc2_ = this.getChildAt(0);
            if(_loc2_ != null)
            {
               _loc2_.gotoAndStop(this._level);
            }
         }
      }
      
      function expBehavior(param1:HumanEvent) : void
      {
         if(!(_inHome && !this._skipWork) && _destination != "home")
         {
            if(!this.inWorking)
            {
               if(this.idleCtr > 0)
               {
                  --this.idleCtr;
               }
               else
               {
                  this.idleCtr = 120;
                  this.gainExp(1);
               }
            }
         }
      }
      
      function gainExp(param1:int) : void
      {
         var _loc2_:* = undefined;
         if(this._level - 1 in this.TO_NEXT_LEVEL)
         {
            _loc2_ = this.TO_NEXT_LEVEL[this._level - 1];
            _exp = Math.min(_exp + param1,_loc2_);
            dispatchEvent(new HumanEvent(HumanEvent.UPDATE_EXPERIENCE));
         }
      }
      
      function get inWorking() : Boolean
      {
         return false;
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         if(!this._recovery)
         {
            this.staminaCheck();
            super.behavior(param1);
         }
         else
         {
            this.recoveryCheck();
         }
      }
      
      override function movingCheck(param1:LoopEvent) : void
      {
         if(!this._recovery)
         {
            super.movingCheck(param1);
         }
      }
      
      function recoveryCheck() : void
      {
         var _loc1_:* = this._tiredTime == 0 ? 1 : (this._tiredTime == 1 ? 0.7 : 0.4);
         if(_vitality < Math.round(MAX_VITALITY * _loc1_))
         {
            _vitality = Math.min(_vitality + Math.round(MAX_VITALITY * _loc1_ / 20),Math.round(MAX_VITALITY * _loc1_));
            dispatchEvent(new HumanEvent(HumanEvent.UPDATE_VITALITY));
         }
         else
         {
            if(_dialogIconBox.stage != null)
            {
               _dialogIconBox.parent.removeChild(_dialogIconBox);
            }
            this._recovery = false;
         }
      }
      
      function staminaCheck() : void
      {
         var _loc1_:* = undefined;
         if(!_inHome && !this._arrival && !this._fired)
         {
            if(!this._doingJob)
            {
               _loc1_ = this.staminaLossModifier / this.STAMINA_LV[this._level - 1];
               if(this.lossCarry > 100)
               {
                  _loc1_ += Math.floor(this.lossCarry / 100);
                  this.lossCarry -= 100;
               }
               _vitality -= Math.floor(_loc1_);
               if(_vitality < 0)
               {
                  _vitality = 0;
                  this.lossCarry = 0;
               }
               else
               {
                  this.lossCarry += Math.round(_loc1_ * 100) % 100;
               }
               this.checkDepletedVitality();
               dispatchEvent(new HumanEvent(HumanEvent.UPDATE_VITALITY));
            }
         }
      }
      
      function checkDepletedVitality() : void
      {
         if(!this._fired)
         {
            if(_vitality <= 0 && !this.additionalVitalityCheck)
            {
               ++this._tiredTime;
               this._recovery = true;
               if(_currentAnimation != Animation.IDLE)
               {
                  currentAnimation = Animation.IDLE;
               }
               showDialogIconBox("expresion","tired",0);
            }
         }
      }
      
      function get additionalVitalityCheck() : Boolean
      {
         return false;
      }
      
      override function destinationTargetCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(!this._fired)
         {
            if(_destination == null && !_inHome && !this._doingJob)
            {
               if(_movePoint == null)
               {
                  if(_floorTarget == null)
                  {
                     if(this._workFloor == null)
                     {
                        if(Calculate.chance(30))
                        {
                           _floorTarget = _world.floorList[Math.floor(Math.random() * (_world.floorList.length - 1))];
                        }
                     }
                     else if(_floorStep != this._workFloor)
                     {
                        _floorTarget = this._workFloor;
                     }
                     if(_floorTarget != null)
                     {
                        _loc1_ = null;
                        _loc2_ = _world.floorList.indexOf(_floorTarget);
                        if(_loc2_ + 1 in _world.floorList)
                        {
                           _loc1_ = _world.floorList[_loc2_ + 1];
                        }
                        else
                        {
                           _loc1_ = _floorTarget;
                        }
                        if(_loc1_ != null)
                        {
                           _loc3_ = Math.random() * (_loc1_.right - _loc1_.left) + _loc1_.left;
                           _floorPoint = new Point(_loc3_,_floorTarget.y);
                        }
                     }
                     else if(Calculate.chance(80))
                     {
                        if(_inside == null)
                        {
                           if((_loc4_ = onFloor) != null)
                           {
                              _loc1_ = null;
                              _loc2_ = _world.floorList.indexOf(_loc4_);
                              if(_loc2_ + 1 in _world.floorList)
                              {
                                 _loc1_ = _world.floorList[_loc2_ + 1];
                              }
                              else
                              {
                                 _loc1_ = _loc4_;
                              }
                              if(_loc1_ != null)
                              {
                                 _loc3_ = Math.random() * (_loc1_.right - _loc1_.left) + _loc1_.left;
                                 _movePoint = new Point(_loc3_,_loc4_.y);
                              }
                           }
                        }
                     }
                  }
               }
               else if(this._workFloor != null)
               {
                  if(_floorStep != this._workFloor)
                  {
                     if(_floorTarget != this._workFloor)
                     {
                        _destinationTransport = null;
                        _transportQueue = new Array();
                        _movePoint = null;
                        currentAnimation = Animation.IDLE;
                     }
                  }
               }
            }
         }
         else if(_inside == null || _inside is FacilityElevatorBody || _inside is FacilityStairs)
         {
            if(_dialogIconBox.stage == null)
            {
               showDialogIconBox("expresion","cry",0);
            }
         }
         else if(_dialogIconBox.stage != null)
         {
            _dialogIconBox.parent.removeChild(_dialogIconBox);
         }
         super.destinationTargetCheck();
      }
      
      function checkGameTime(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc2_:* = param1.tag;
         if(_inHome && !this._skipWork)
         {
            if(!this._fired)
            {
               _loc3_ = 0;
               _loc4_ = false;
               if((_loc5_ = this._workTime.workStart - 2) < 0)
               {
                  _loc5_ = 24 + _loc5_;
               }
               if(this._workTime.workEnd > _loc5_)
               {
                  _loc4_ = _loc2_.hour < this._workTime.workEnd && _loc2_.hour >= _loc5_;
               }
               else
               {
                  _loc4_ = _loc2_.hour < this._workTime.workEnd || _loc2_.hour >= _loc5_;
               }
               if(_loc4_)
               {
                  if(_loc2_.hour >= this._workTime.workStart)
                  {
                     _loc3_ = 100;
                  }
                  else
                  {
                     if((_loc6_ = this._workTime.workStart - 1) < 0)
                     {
                        _loc6_ = 24 + _loc6_;
                     }
                     if(_loc2_.hour >= _loc6_)
                     {
                        if(_loc2_.minute < 30)
                        {
                           _loc3_ = (_loc2_.minute + 60) / 90 * 100;
                        }
                        else
                        {
                           _loc3_ = 100;
                        }
                     }
                     else if(_loc2_.hour >= _loc5_)
                     {
                        _loc3_ = (_loc2_.minute - 30) / 90 * 100;
                     }
                  }
               }
               if(_loc3_ < 100)
               {
                  if(_fatigue)
                  {
                     _loc3_ = 0;
                  }
               }
               if(Calculate.chance(_loc3_))
               {
                  if(!_fatigue)
                  {
                     this._arrival = true;
                     _inHome = false;
                     this.visible = true;
                  }
                  else
                  {
                     this._skipWork = true;
                  }
               }
            }
         }
         else
         {
            if((_loc7_ = this._workTime.workStart - 2) < 0)
            {
               _loc7_ = 24 - _loc7_;
            }
            _loc8_ = false;
            if(!this._fired)
            {
               if(this._workTime.workEnd > _loc7_)
               {
                  _loc8_ = _loc2_.hour >= this._workTime.workEnd || _loc2_.hour < _loc7_;
               }
               else
               {
                  _loc8_ = _loc2_.hour >= this._workTime.workEnd && _loc2_.hour < _loc7_;
               }
            }
            else
            {
               _loc8_ = true;
            }
            if(_loc8_)
            {
               if(!this._doingJob)
               {
                  if(_destination != "home")
                  {
                     this._skipWork = false;
                     _destination = "home";
                     if(this._salaryObject == this && !this._fired)
                     {
                        dispatchEvent(new HumanEvent(HumanEvent.PAY_SALARY,this));
                     }
                  }
               }
               else
               {
                  this.checkHomeWhenDoingJob();
               }
            }
            else if(_destination == "home")
            {
               if(currentAnimation == Animation.WALK)
               {
                  currentAnimation = Animation.IDLE;
               }
               _destination = null;
               _movePoint = null;
               _transportQueue = new Array();
               _destinationTransport = null;
            }
            if(_destination != "home")
            {
               if(this._arrival)
               {
                  _loc9_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
                  _loc10_ = _world.floorList[1];
                  if(_loc9_.x >= _loc10_.left && _loc9_.x <= _loc10_.right)
                  {
                     this._arrival = false;
                  }
               }
            }
            if(this._salaryObject != this)
            {
               this._salaryObject = this;
            }
         }
      }
      
      function checkHomeWhenDoingJob() : void
      {
      }
      
      override function additionalCheckWhenHome() : void
      {
         var _loc1_:* = 40 * this._tiredTime * (1 - _stat.hygine / 100 * 0.9);
         if(Calculate.chance(_loc1_))
         {
            _fatigue = true;
         }
      }
      
      override function inHomeBehaviorCheck() : void
      {
         var _loc1_:* = undefined;
         if(!this._fired)
         {
            super.inHomeBehaviorCheck();
            if(_vitality < MAX_VITALITY)
            {
               _loc1_ = (_stat.stamina / 100 + _stat.hygine / 100) * this.STAMINA_LV[this._level - 1];
               if(_fatigue)
               {
                  _loc1_ *= 0.5 + 0.4 * (_stat.entertain / 100);
               }
               if(this.gainCarry > 100)
               {
                  _loc1_ += Math.floor(this.gainCarry / 100);
                  this.gainCarry -= 100;
               }
               _vitality += Math.floor(_loc1_);
               if(_vitality > MAX_VITALITY)
               {
                  _vitality = MAX_VITALITY;
                  this.gainCarry = 0;
               }
               else
               {
                  this.gainCarry += Math.round(_loc1_ * 100) % 100;
               }
               if(this._tiredTime > 1)
               {
                  if(_vitality > 0.4 * MAX_VITALITY)
                  {
                     this._tiredTime = 1;
                  }
               }
               else if(this._tiredTime > 0)
               {
                  if(_vitality > 0.7 * MAX_VITALITY)
                  {
                     this._tiredTime = 0;
                  }
               }
               else if(_vitality == MAX_VITALITY)
               {
                  _fatigue = false;
               }
               dispatchEvent(new HumanEvent(HumanEvent.UPDATE_VITALITY));
            }
         }
         else if(this.stage)
         {
            dispatchEvent(new HumanEvent(HumanEvent.EXILE));
            this.parent.removeChild(this);
         }
      }
      
      function get modTired() : Number
      {
         return 1 + 0.2 * Math.min(2,this._tiredTime);
      }
      
      override public function runSpeed() : Number
      {
         return super.runSpeed() / this.modTired;
      }
      
      override public function getSpeed() : Number
      {
         return _stat.countSpeed() * this.SPEED_LV[this._level - 1] / this.modTired;
      }
      
      override public function getSight() : Number
      {
         return _stat.countSight() * this.SIGHT_LV[this._level - 1] / this.modTired;
      }
      
      function searchTarget() : void
      {
      }
      
      public function loadCondition(param1:*) : void
      {
         this._tiredTime = param1.tiredTime;
         this._recovery = param1.recovery;
         _vitality = param1.vitality;
         _fatigue = param1.fatigue;
         this._skipWork = param1.skipWork;
         _exp = param1.exp;
      }
      
      public function saveCondition(param1:*) : void
      {
         param1.tiredTime = this._tiredTime;
         param1.recovery = this._recovery;
         param1.vitality = _vitality;
         param1.fatigue = _fatigue;
         param1.skipWork = this._skipWork;
         param1.exp = _exp;
      }
      
      function get staminaLossModifier() : Number
      {
         var _loc1_:* = 1;
         if("staminaLossDecrement" in _world.upgradeModifier)
         {
            _loc1_ = 1 - _world.upgradeModifier["staminaLossDecrement"];
         }
         return (1 - _stat.stamina / 100 * 0.9) * _loc1_;
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function get level() : int
      {
         return this._level;
      }
      
      public function get workTime() : Object
      {
         return this._workTime;
      }
      
      public function set workFloor(param1:Object) : void
      {
         this._workFloor = param1;
      }
      
      public function get workFloor() : Object
      {
         return this._workFloor;
      }
      
      public function get arrival() : Boolean
      {
         return this._arrival;
      }
      
      public function get doingJob() : Boolean
      {
         return this._doingJob;
      }
      
      public function get promoteMode() : Boolean
      {
         return this._promoteMode;
      }
      
      public function get promoteState() : Boolean
      {
         return this._promoteState;
      }
      
      public function get salary() : int
      {
         var _loc1_:* = this._workTime.workEnd + (this._workTime.workEnd < this._workTime.workStart ? 24 : 0) - this._workTime.workStart;
         var _loc2_:* = this._salary;
         if(_loc1_ > 10)
         {
            _loc2_ = this._salary * 2 - 5;
         }
         return _loc2_;
      }
      
      public function set salaryObject(param1:*) : void
      {
         this._salaryObject = param1;
      }
      
      public function get salaryObject() : *
      {
         return this._salaryObject;
      }
      
      public function set basicPayment(param1:int) : void
      {
         this._basicPayment = param1;
      }
      
      public function get basicPayment() : int
      {
         return this._basicPayment;
      }
      
      public function get promotionCost() : int
      {
         var _loc1_:* = [0.6,0.8];
         return Math.floor(_loc1_[this._level - 1] * this._basicPayment);
      }
      
      public function get serverenceCost() : int
      {
         var _loc1_:* = [1.4,1.8,2.4];
         var _loc2_:* = Math.floor(_loc1_[this._level - 1] * this._basicPayment);
         var _loc3_:* = 0;
         if("relocateDiscount" in _world.upgradeModifier)
         {
            _loc3_ = 1 - _world.upgradeModifier["relocateDiscount"];
         }
         return Math.round(_loc2_ * _loc3_);
      }
      
      public function get maxLevel() : int
      {
         return this._maxLevel;
      }
      
      public function get tiredTime() : int
      {
         return Math.min(2,this._tiredTime);
      }
      
      public function get recovery() : Boolean
      {
         return this._recovery;
      }
      
      public function get fatigue() : Boolean
      {
         return _fatigue;
      }
      
      public function get skipWork() : Boolean
      {
         return this._skipWork;
      }
      
      public function get expPercentage() : Number
      {
         var _loc1_:* = undefined;
         if(this._level - 1 in this.TO_NEXT_LEVEL)
         {
            _loc1_ = this.TO_NEXT_LEVEL[this._level - 1];
            return _exp / _loc1_;
         }
         return 1;
      }
   }
}
