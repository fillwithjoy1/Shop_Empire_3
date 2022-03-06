package Instance.progress
{
   import Instance.constant.UpgradeData;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.gameplay.Critter;
   import Instance.gameplay.Elsa;
   import Instance.gameplay.Gandalf;
   import Instance.gameplay.Kratos;
   import Instance.gameplay.World;
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import Instance.property.FacilityElevatorBody;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class CurseSpell
   {
       
      
      var _world:World;
      
      var _victim;
      
      var _startPos:Point;
      
      var _failed:Boolean;
      
      var _caster;
      
      var projectile;
      
      var buffEffect;
      
      var gap:int;
      
      var gravity:int;
      
      var _delayWhenFailed:int;
      
      public function CurseSpell()
      {
         super();
         this._failed = false;
      }
      
      function searchEntertainerToCounter() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this._world.isUpgradePurchased(UpgradeData.MAGIC_REPELMENT))
         {
            _loc1_ = this._world.mainContainer.globalToLocal(this._caster.localToGlobal(new Point(0,0)));
            _loc2_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < this._world.staffList.entertainer.length)
            {
               if((_loc4_ = this._world.staffList.entertainer[_loc3_]).inside == null || _loc4_.inside is FacilityElevatorBody)
               {
                  _loc5_ = this._world.mainContainer.globalToLocal(_loc4_.localToGlobal(new Point(0,0)));
                  if(_loc1_.y == _loc5_.y)
                  {
                     if((_loc6_ = Math.abs(_loc1_.x - _loc5_.x)) <= _loc4_.getSight() / 3)
                     {
                        _loc2_.push(_loc4_);
                     }
                  }
               }
               _loc3_++;
            }
            if(_loc2_.length > 0)
            {
               Utility.shuffle(_loc2_);
               if((_loc7_ = _loc2_.shift()) != null)
               {
                  _loc7_.counterSpell();
                  this._failed = true;
               }
            }
         }
      }
      
      public function runSpell() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.victim != null)
         {
            this.searchEntertainerToCounter();
            if(!this._failed)
            {
               this.projectile = new sorcererfx2();
               this.projectile.stop();
               if(this._startPos != null)
               {
                  this.projectile.x = this._startPos.x;
                  this.projectile.y = this._startPos.y;
               }
               _loc1_ = 0;
               _loc2_ = this.projectile.y;
               _loc3_ = 0;
               while(_loc2_ < this.victim.y)
               {
                  _loc2_ += _loc3_;
                  _loc3_++;
                  _loc1_++;
               }
               _loc4_ = Math.abs(this.projectile.x - this.victim.x);
               _loc5_ = this.victim.x < this.projectile.x ? -1 : 1;
               this.gap = _loc5_ * (_loc4_ / _loc1_);
               this.gravity = 0;
               this._world.frontContainer.addChild(this.projectile);
               this._world.addListenerOf(this.projectile,LoopEvent.ON_IDLE,this.movingProjectile);
            }
            else
            {
               this._victim.passive = false;
               this._delayWhenFailed = 5;
               this._world.addListenerOf(this._world.stage,GameEvent.GAME_UPDATE,this.afterFailCheck);
            }
         }
      }
      
      function afterFailCheck(param1:GameEvent) : void
      {
         if(this._delayWhenFailed > 0)
         {
            --this._delayWhenFailed;
         }
         else
         {
            this._world.removeListenerOf(param1.currentTarget,GameEvent.GAME_UPDATE,this.afterFailCheck);
            this._caster.dispatchEvent(new HumanEvent(HumanEvent.END_CAST,this));
         }
      }
      
      function movingProjectile(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.projectile.currentFrame < this.projectile.totalFrames)
         {
            this.projectile.nextFrame();
         }
         else
         {
            this.projectile.gotoAndStop(1);
         }
         this.projectile.x += this.gap;
         if(this.projectile.y + this.gravity < this.victim.y)
         {
            this.projectile.y += this.gravity;
            ++this.gravity;
         }
         else
         {
            this.buffEffect = new CurseBuff();
            this.buffEffect.x = this.victim.x;
            this.buffEffect.y = this.victim.y;
            this.buffEffect.stop();
            _loc2_ = this.victim.parent;
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.getChildIndex(this.victim);
               this._world.addListenerOf(this.buffEffect,LoopEvent.ON_IDLE,this.animateBuff);
               this._world.addListenerOf(this.buffEffect,LoopEvent.ON_IDLE,this.checkCurrentBuff);
               this._world.addListenerOf(this.buffEffect,Event.ADDED,this.buffEffectGetSomeClip);
               _loc2_.addChildAt(this.buffEffect,_loc3_ + 1);
            }
            this._world.removeListenerOf(this.projectile,LoopEvent.ON_IDLE,this.movingProjectile);
            this.projectile.parent.removeChild(this.projectile);
         }
      }
      
      function buffEffectGetSomeClip(param1:Event) : void
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
            if(_loc2_ == this.buffEffect)
            {
               _loc2_.parent.removeChild(_loc2_);
               this._world.removeListenerOf(this.buffEffect,Event.ADDED,this.buffEffectGetSomeClip);
               this._world.removeListenerOf(this.buffEffect,LoopEvent.ON_IDLE,this.checkCurrentBuff);
               this._caster.dispatchEvent(new HumanEvent(HumanEvent.END_CAST,this));
               if(this._failed)
               {
                  this.victim.passive = false;
               }
            }
         }
      }
      
      function checkCurrentBuff(param1:LoopEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.currentFrameLabel == "effectCurse")
         {
            if(this.victim is Gandalf)
            {
               this._failed = true;
            }
            else
            {
               _loc3_ = new Critter();
               _loc3_.world = this._world;
               _loc3_.x = this.victim.x;
               _loc3_.y = this.victim.y;
               _loc3_.related = this.victim;
               _loc3_.scaleX = this.victim.scaleX;
               if(this.victim is Kratos)
               {
                  _loc3_.model = "stone";
               }
               else if(this.victim is Elsa)
               {
                  _loc3_.model = "frozen";
                  if(this._caster != null)
                  {
                     this._caster.passive = true;
                     (_loc5_ = new Critter()).world = this._world;
                     _loc5_.x = this._caster.x;
                     _loc5_.y = this._caster.y;
                     _loc5_.related = this._caster;
                     _loc5_.scaleX = this._caster.scaleX;
                     _loc5_.model = "frozen";
                     if((_loc6_ = this._caster.parent) != null)
                     {
                        _loc7_ = _loc6_.getChildIndex(this._caster);
                        _loc6_.addChildAt(_loc5_,_loc7_ + 1);
                     }
                  }
               }
               else
               {
                  _loc3_.model = !!Calculate.chance(50) ? "chicken" : "pig";
               }
               if((_loc4_ = this.victim.parent) != null)
               {
                  _loc8_ = _loc4_.getChildIndex(this.victim);
                  _loc4_.addChildAt(_loc3_,_loc8_ + 1);
               }
            }
         }
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function set caster(param1:*) : void
      {
         this._caster = param1;
      }
      
      public function get caster() : *
      {
         return this._caster;
      }
      
      public function set victim(param1:*) : void
      {
         this._victim = param1;
      }
      
      public function get victim() : *
      {
         return this._victim;
      }
      
      public function set startPos(param1:Point) : void
      {
         this._startPos = param1;
      }
      
      public function get startPos() : *
      {
         return this._startPos;
      }
      
      public function get failed() : Boolean
      {
         return this._failed;
      }
   }
}
