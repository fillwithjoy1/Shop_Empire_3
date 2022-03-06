package Instance.gameplay
{
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import Instance.progress.CurseSpell;
   import Instance.property.FacilityElevatorBody;
   import Instance.sprite.Animation;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   
   public class Wizard extends Human
   {
       
      
      public var launchPos:MovieClip;
      
      public var castingPos:MovieClip;
      
      var _visitorInSight:Array;
      
      var _evidence:int;
      
      var _cooldownCast:int;
      
      var _castingTime:int;
      
      var _castSpell:Boolean;
      
      var _isCaught:Boolean;
      
      var _victim;
      
      var _castingClip:MovieClip;
      
      var _castingEffect1:MovieClip;
      
      var _castingEffect2:MovieClip;
      
      var _numberCast:int;
      
      var _recastChance:Number;
      
      var _delayToRecast:int;
      
      var dCol:int;
      
      public function Wizard()
      {
         super();
         this._visitorInSight = new Array();
         this._evidence = 0;
         this._cooldownCast = 0;
         this._castingTime = 0;
         this._numberCast = 0;
         this._isCaught = false;
         this._victim = null;
         this._castingClip = null;
         this._castingEffect1 = new sorcererfx();
         this._castingEffect2 = new sorcererfx2();
         this._castingEffect1.stop();
         this._castingEffect2.stop();
         this._delayToRecast = 0;
         this.dCol = 1;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,LoopEvent.ON_IDLE,this.castingEffect);
         addListenerOf(this,HumanEvent.END_CAST,this.afterEndCast);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.checkGameTime);
      }
      
      function castingClipAnimation() : void
      {
         var _loc1_:* = undefined;
         if(this._castingClip != null)
         {
            if(this.castingPos != null)
            {
               this._castingClip.x = this.castingPos.x;
               this._castingClip.y = this.castingPos.y;
               _loc1_ = this.getChildIndex(this.castingPos);
               if(this._castingClip.stage == null)
               {
                  addChildAt(this._castingClip,_loc1_);
               }
               else
               {
                  if(this._castingClip.currentFrame < this._castingClip.totalFrames)
                  {
                     this._castingClip.nextFrame();
                  }
                  else if(this._castingClip == this._castingEffect1)
                  {
                     this._castingClip.parent.removeChild(this._castingClip);
                     this._castingClip = this._castingEffect2;
                     this._castingClip.x = this.castingPos.x;
                     this._castingClip.y = this.castingPos.y;
                     addChildAt(this._castingClip,_loc1_);
                  }
                  else
                  {
                     this._castingClip.gotoAndStop(1);
                  }
                  setChildIndex(this._castingClip,_loc1_);
               }
            }
            else if(this._castingClip.stage != null)
            {
               this._castingClip.parent.removeChild(this._castingClip);
            }
         }
      }
      
      public function loadCondition(param1:*) : void
      {
         var _loc2_:* = undefined;
         this._evidence = param1.evidence;
         this._cooldownCast = param1.cooldownCast;
         this._isCaught = param1.isCaught;
         this._numberCast = param1.numberCast;
         this._recastChance = param1.recastChance;
         this._delayToRecast = param1.delayToRecast;
         if(param1.critterMode != null)
         {
            _loc2_ = new Critter();
            _loc2_.world = _world;
            _loc2_.x = this.x;
            _loc2_.y = this.y;
            _loc2_.related = this;
            _loc2_.scaleX = this.scaleX;
            _loc2_.loadCondition(param1.critterMode);
            _passive = true;
            _relatedCritter = _loc2_;
            _currentAnimation = "cast";
            this.gotoAndStop(Utility.getLabelIndex(this,"cast") + 12);
         }
         else
         {
            _relatedCritter = null;
         }
      }
      
      public function saveCondition(param1:*) : void
      {
         param1.evidence = this._evidence;
         param1.cooldownCast = this._cooldownCast;
         param1.isCaught = this._isCaught;
         param1.numberCast = this._numberCast;
         param1.recastChance = this._recastChance;
         param1.delayToRecast = this._delayToRecast;
         if(_relatedCritter != null)
         {
            param1.critterMode = new Object();
            _relatedCritter.saveCondition(param1.critterMode);
         }
         else
         {
            param1.critterMode = null;
         }
      }
      
      function castingEffect(param1:LoopEvent) : void
      {
         this.castingClipAnimation();
         this.victimAnimation();
         this.casterAnimation();
      }
      
      function casterAnimation() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this._castSpell)
         {
            if(this.launchPos != null)
            {
               _loc1_ = new CurseSpell();
               _loc2_ = _world.mainContainer.globalToLocal(this.launchPos.localToGlobal(new Point(0,0)));
               _loc1_.caster = this;
               _loc1_.world = _world;
               _loc1_.startPos = _loc2_;
               _loc1_.victim = this._victim;
               this._victim = null;
               _loc1_.runSpell();
               this._castingClip = null;
            }
            if(this.currentFrameLabel == "cast_end")
            {
               currentAnimation = null;
            }
         }
      }
      
      function afterEndCast(param1:HumanEvent) : void
      {
         var _loc2_:* = undefined;
         if(!this._isCaught)
         {
            _loc2_ = param1.tag;
            if(!_passive)
            {
               if(!_loc2_.failed)
               {
                  currentAnimation = "taunt";
               }
               else
               {
                  currentAnimation = Animation.IDLE;
               }
            }
            ++this._numberCast;
            this._evidence = 10;
            this._cooldownCast = 45;
            this._delayToRecast = 0;
            this._castSpell = false;
         }
      }
      
      function victimAnimation() : void
      {
         var _loc1_:ColorTransform = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this._victim != null)
         {
            _loc1_ = this._victim.transform.colorTransform;
            _loc2_ = _loc1_.redOffset;
            _loc3_ = _loc1_.greenOffset;
            _loc4_ = _loc1_.blueOffset;
            if(_loc2_ + 32 * this.dCol < 255 && _loc2_ + 32 * this.dCol > 0)
            {
               _loc2_ += 32 * this.dCol;
            }
            else if(_loc2_ + 32 * this.dCol >= 255)
            {
               _loc2_ = 255;
               this.dCol = -1;
            }
            else if(_loc2_ + 32 * this.dCol <= 0)
            {
               _loc2_ = 0;
               if(this._castingTime > 0)
               {
                  this.dCol = 1;
               }
            }
            _loc3_ = _loc2_;
            _loc4_ = _loc2_;
            _loc1_.redOffset = _loc2_;
            _loc1_.greenOffset = _loc3_;
            _loc1_.blueOffset = _loc4_;
            this._victim.transform.colorTransform = _loc1_;
         }
      }
      
      function checkGameTime(param1:GameEvent) : void
      {
         var _loc2_:* = param1.tag;
         if(!this._castSpell && this._evidence <= 0)
         {
            if(_destination != "home")
            {
               if(_loc2_.hour >= 22 || _loc2_.hour < 10)
               {
                  _destination = "home";
               }
            }
         }
      }
      
      override function destinationTargetCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(_destination == null && !_inHome)
         {
            if(_movePoint == null)
            {
               if(_floorTarget == null)
               {
                  if(Calculate.chance(30))
                  {
                     _floorTarget = _world.floorList[Math.floor(Math.random() * (_world.floorList.length - 1))];
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
               }
            }
         }
         super.destinationTargetCheck();
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         var _loc2_:* = undefined;
         if(!this._isCaught && !_passive)
         {
            if(insideMall && this._victim == null && !this._castSpell && this._evidence <= 0)
            {
               if(this._delayToRecast > 0)
               {
                  --this._delayToRecast;
               }
               else
               {
                  _loc2_ = Math.min(15 * this._numberCast + this._recastChance,90);
                  if(isNaN(_loc2_))
                  {
                     _loc2_ = 0;
                  }
                  if(Calculate.chance(_loc2_))
                  {
                     _destination = "home";
                  }
                  this._delayToRecast = 30;
                  if(isNaN(this._recastChance))
                  {
                     this._recastChance = 0;
                  }
                  else
                  {
                     this._recastChance += 1;
                  }
               }
            }
            if(_destination != "home")
            {
               this.castingCheck();
            }
            if(this._victim == null && !this._castSpell && this._evidence <= 0)
            {
               this.checkVisitorIsOutRange();
               if(_inside == null && _destination == null)
               {
                  this.searchVisitorToCurse();
               }
               super.behavior(param1);
            }
         }
      }
      
      override function inHomeBehaviorCheck() : void
      {
         if(this.stage)
         {
            dispatchEvent(new HumanEvent(HumanEvent.EXILE));
            this.parent.removeChild(this);
         }
      }
      
      function checkVisitorIsOutRange() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc1_:* = new Array();
         var _loc2_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc3_:* = 0;
         while(_loc3_ < this._visitorInSight.length)
         {
            if((_loc4_ = this._visitorInSight[_loc3_]).stage == null || _world.currentVisitorList.indexOf(_loc4_) < 0 || _loc4_.inHome || !_loc4_.insideMall)
            {
               _loc1_.push(_loc4_);
            }
            else if(_loc4_.inside != null && !(_loc4_.inside is FacilityElevatorBody))
            {
               _loc1_.push(_loc4_);
            }
            else if(_loc4_.passive)
            {
               _loc1_.push(_loc4_);
            }
            else
            {
               _loc5_ = _world.mainContainer.globalToLocal(_loc4_.localToGlobal(new Point(0,0)));
               if(_loc2_.y != _loc5_.y)
               {
                  _loc1_.push(_loc4_);
               }
               else if(!inSight(_loc4_))
               {
                  _loc1_.push(_loc4_);
               }
            }
            _loc3_++;
         }
         while(_loc1_.length > 0)
         {
            _loc4_ = _loc1_.pop();
            if((_loc6_ = this._visitorInSight.indexOf(_loc4_)) in this._visitorInSight)
            {
               this._visitorInSight.splice(_loc6_,1);
            }
         }
      }
      
      function searchVisitorToCurse() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(_inside == null)
         {
            _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
            _loc2_ = 0;
            while(_loc2_ < _world.currentVisitorList.length)
            {
               _loc3_ = _world.currentVisitorList[_loc2_];
               if(!_loc3_.passive && _loc3_.meetFriend == null && _loc3_.insideMall)
               {
                  if(_loc3_.inside == null || _loc3_.inside is FacilityElevatorBody)
                  {
                     if((_loc4_ = this._visitorInSight.indexOf(_loc3_)) < 0)
                     {
                        _loc5_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
                        if(inSight(_loc3_) && _loc5_.y == _loc1_.y)
                        {
                           this._visitorInSight.push(_loc3_);
                        }
                     }
                  }
               }
               _loc2_++;
            }
         }
      }
      
      function castingCheck() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         if(this._evidence > 0)
         {
            --this._evidence;
         }
         else if(this._cooldownCast > 0)
         {
            --this._cooldownCast;
         }
         else if(_inside == null && insideMall)
         {
            if(this._victim == null && !this._castSpell)
            {
               _loc1_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
               _loc2_ = new Array();
               _loc3_ = 0;
               while(_loc3_ < this._visitorInSight.length)
               {
                  if(!(_loc4_ = this._visitorInSight[_loc3_]).passive)
                  {
                     _loc5_ = _world.mainContainer.globalToLocal(_loc4_.localToGlobal(new Point(0,0)));
                     _loc6_ = Math.abs(_loc5_.x - _loc1_.x);
                     _loc7_ = Math.max(50,getSight() / 5);
                     if(_loc6_ <= _loc7_ && _loc6_ >= 15)
                     {
                        _loc2_.push(_loc4_);
                     }
                  }
                  _loc3_++;
               }
               Utility.shuffle(_loc2_);
               while(_loc2_.length > 0)
               {
                  _loc8_ = _loc2_.shift();
                  if(Calculate.chance(40))
                  {
                     this._victim = _loc8_;
                     this._victim.passive = true;
                     _movePoint = null;
                     _floorTarget = null;
                     _floorPoint = null;
                     _transportQueue = new Array();
                     _destinationTransport = null;
                     this.scaleX = this._victim.x < this.x ? Number(-1) : (this._victim.x > this.x ? Number(1) : Number(this.scaleX));
                     this._victim.cancelWaiting();
                     currentAnimation = "chant";
                     this._castingClip = this._castingEffect1;
                     this._castingTime = 10;
                     this._castSpell = true;
                     dispatchEvent(new HumanEvent(HumanEvent.CAST_SPELL,this._victim));
                     break;
                  }
               }
            }
            else if(this._victim != null)
            {
               if(this._castingTime > 0)
               {
                  --this._castingTime;
               }
               else if(this._castSpell)
               {
                  if(_currentAnimation != "cast")
                  {
                     currentAnimation = "cast";
                  }
               }
            }
         }
      }
      
      public function caught() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         _destination = null;
         _floorTarget = null;
         _movePoint = null;
         _transportQueue = new Array();
         _destinationTransport = null;
         this._isCaught = true;
         currentAnimation = "arrested";
         if(_inside is FacilityElevatorBody)
         {
            _inside.removePerson(this);
            _loc1_ = _inside.queueLine.indexOf(this);
            if(_loc1_ in _inside.queueLine)
            {
               _inside.queueLine.splice(_loc1_,1);
            }
            _loc2_ = _inside.elevatorLink;
            _loc3_ = _loc2_.passanger.indexOf(this);
            if(_loc3_ in _loc2_.passanger)
            {
               _loc2_.passanger.splice(_loc3_,1);
            }
         }
         this._castSpell = false;
         if(this._victim != null)
         {
            this._victim.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
            this._victim.passive = false;
            this._victim = null;
         }
         addListenerOf(this,LoopEvent.ON_IDLE,this.afterCaughtCheck);
      }
      
      function afterCaughtCheck(param1:LoopEvent) : void
      {
         if(currentAnimation == "arrested")
         {
            if(this.currentFrameLabel == "arrested_end")
            {
               currentAnimation = "vanish";
               addListenerOf(this,LoopEvent.ON_IDLE,this.vanishingCheck);
               removeListenerOf(this,LoopEvent.ON_IDLE,this.afterCaughtCheck);
            }
         }
      }
      
      public function vanish() : void
      {
         currentAnimation = "vanish";
         addListenerOf(this,LoopEvent.ON_IDLE,this.vanishingCheck);
      }
      
      function vanishingCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         if(currentAnimation == "vanish")
         {
            if(this.currentFrameLabel == "vanish_end")
            {
               currentAnimation = null;
               removeListenerOf(this,LoopEvent.ON_IDLE,this.vanishingCheck);
               _loc2_ = _world.humanList.indexOf(this);
               if(_loc2_ in _world.humanList)
               {
                  _world.humanList.splice(_loc2_,1);
               }
               if(this.stage != null)
               {
                  dispatchEvent(new HumanEvent(HumanEvent.EXILE));
                  this.parent.removeChild(this);
               }
            }
         }
      }
      
      public function get evidence() : int
      {
         return this._evidence;
      }
      
      public function get castSpell() : Boolean
      {
         return this._castSpell;
      }
      
      public function set isCaught(param1:Boolean) : void
      {
         this._isCaught = param1;
      }
      
      public function get isCaught() : Boolean
      {
         return this._isCaught;
      }
   }
}
