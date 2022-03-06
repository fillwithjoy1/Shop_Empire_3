package Instance.property
{
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.LoopEvent;
   import Instance.modules.Calculate;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class HalteWagon extends Building
   {
       
      
      const MAX_PASSANGER_LEVEL = [3,5,8];
      
      const UPGRADE_COST_LEVEL = [5000,7500];
      
      var _currentWagon:Wagon;
      
      var _delayToSendWagon:int;
      
      var _maxPassanger:int;
      
      var _flashingClip:MovieClip;
      
      public function HalteWagon()
      {
         super();
         _destroyable = false;
         this._currentWagon = null;
         this._delayToSendWagon = 0;
         _level = 1;
         this._flashingClip = new MovieClip();
         this._flashingClip.graphics.beginFill(16777215);
         this._flashingClip.graphics.drawRect(-width / 2,-height,width,height);
         this._flashingClip.graphics.endFill();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this._maxPassanger = this.MAX_PASSANGER_LEVEL[_level - 1];
         _upgradeCost = this.UPGRADE_COST_LEVEL[_level - 1];
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.checkDelay);
         if(this._currentWagon != null)
         {
            if(this._currentWagon.scaleX == 1)
            {
               this._currentWagon.dropPosition = this.dropPointR;
            }
            else if(this._currentWagon.scaleX == -1)
            {
               this._currentWagon.dropPosition = this.dropPointL;
            }
            _world.wagonContainer.addChild(this._currentWagon);
         }
      }
      
      override function buildingOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.HALTE_ON_SELECT));
      }
      
      override function upgradeBuilding(param1:CommandEvent) : void
      {
         if(!_upgradeMode)
         {
            if(_level < _maxLevel)
            {
               _upgradeMode = true;
               _upgradeState = true;
               this._flashingClip.alpha = 0;
               addChild(this._flashingClip);
               addListenerOf(this,LoopEvent.ON_IDLE,this.flashingAnimate);
               dispatchEvent(new GameEvent(GameEvent.BECOMES_UPGRADE));
            }
         }
      }
      
      override function flashingAnimate(param1:LoopEvent) : void
      {
         var _loc2_:* = false;
         if(this._flashingClip.alpha + 1 / 8 < 1)
         {
            this._flashingClip.alpha += 1 / 8;
         }
         else
         {
            _loc2_ = true;
            this._flashingClip.alpha = 1;
         }
         if(_loc2_)
         {
            beforeUpgradeCheck();
            removeListenerOf(this,LoopEvent.ON_IDLE,this.flashingAnimate);
            ++_level;
            this.gotoAndStop(_level);
            _upgradeState = false;
            setChildIndex(this._flashingClip,numChildren - 1);
            _exp = 0;
            this.afterUpgradeCheck();
         }
      }
      
      override function unflashingAnimate(param1:LoopEvent) : void
      {
         if(this._flashingClip.alpha - 1 / 8 > 0)
         {
            this._flashingClip.alpha -= 1 / 8;
         }
         else
         {
            _upgradeMode = false;
            this._flashingClip.alpha = 0;
            this._flashingClip.parent.removeChild(this._flashingClip);
            removeListenerOf(this,LoopEvent.ON_IDLE,this.unflashingAnimate);
         }
      }
      
      override function setUpgradeCost() : void
      {
         _upgradeCost = this.UPGRADE_COST_LEVEL[_level - 1];
         _relocateCost = 0;
      }
      
      override function afterUpgradeCheck() : void
      {
         this._maxPassanger = this.MAX_PASSANGER_LEVEL[_level - 1];
         super.afterUpgradeCheck();
      }
      
      function checkDelay(param1:GameEvent) : void
      {
         if(this._delayToSendWagon > 0)
         {
            --this._delayToSendWagon;
         }
         if(_world.deepRain)
         {
            if(this._delayToSendWagon > 0)
            {
               --this._delayToSendWagon;
            }
         }
      }
      
      override public function loadCondition(param1:*) : void
      {
         var _loc2_:* = undefined;
         super.loadCondition(param1);
         this._delayToSendWagon = !!isNaN(param1.wagonDelay) ? 0 : int(param1.wagonDelay);
         if(param1.wagon != null)
         {
            _loc2_ = param1.wagon;
            this._currentWagon = new Wagon();
            this._currentWagon.halte = this;
            this._currentWagon.world = _world;
            this._currentWagon.x = _loc2_.coordinate.x;
            this._currentWagon.y = _loc2_.coordinate.y;
            this._currentWagon.loadArrivingStat(_loc2_.arriving);
            this._currentWagon.scaleX = _loc2_.dirrection;
         }
         else
         {
            this._currentWagon = null;
         }
      }
      
      override public function saveCondition(param1:*) : void
      {
         var _loc2_:* = undefined;
         super.saveCondition(param1);
         param1.wagonDelay = this._delayToSendWagon;
         if(this._currentWagon != null)
         {
            _loc2_ = new Object();
            _loc2_.coordinate = new Point(this._currentWagon.x,this._currentWagon.y);
            _loc2_.dirrection = this._currentWagon.scaleX;
            _loc2_.arriving = this._currentWagon.arriving;
            param1.wagon = _loc2_;
         }
         else
         {
            param1.wagon = null;
         }
      }
      
      public function sendWagon() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this._currentWagon = new Wagon();
         if(Calculate.chance(50))
         {
            this._currentWagon.x = _world.mostRight + this._currentWagon.width;
            this._currentWagon.scaleX = 1;
            this._currentWagon.dropPosition = this.dropPointR;
         }
         else
         {
            this._currentWagon.x = _world.mostLeft - this._currentWagon.width;
            this._currentWagon.scaleX = -1;
            this._currentWagon.dropPosition = this.dropPointL;
         }
         this._currentWagon.y = 0;
         this._currentWagon.halte = this;
         this._currentWagon.world = _world;
         var _loc1_:* = 100;
         var _loc2_:* = 0;
         while(_loc2_ < this._maxPassanger)
         {
            if(Calculate.chance(_loc1_))
            {
               (_loc4_ = _world.addVisitor()).passive = true;
               this._currentWagon.addPerson(_loc4_);
            }
            _loc3_ = 1 / this._maxPassanger * 80;
            if(_world.deepRain)
            {
               _loc3_ *= 0.8;
            }
            _loc1_ -= _loc3_;
            _loc2_++;
         }
         _world.wagonContainer.addChild(this._currentWagon);
      }
      
      public function removeWagon() : void
      {
         if(this._currentWagon != null)
         {
            this._currentWagon = null;
            this._delayToSendWagon = 90 - 15 * (_level - 1);
         }
      }
      
      public function get passangerInWagon() : int
      {
         if(this._currentWagon != null)
         {
            return this._currentWagon.passanger.length;
         }
         return 0;
      }
      
      override public function get capacity() : Number
      {
         return this._maxPassanger;
      }
      
      public function get dropPointL() : Point
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = null;
         if(this.numChildren > 0)
         {
            _loc2_ = this.getChildAt(0);
            _loc3_ = _loc2_.getChildByName("dropPointL");
            if(_loc3_ != null)
            {
               _loc1_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
            }
         }
         return _loc1_;
      }
      
      public function get dropPointR() : Point
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = null;
         if(this.numChildren > 0)
         {
            _loc2_ = this.getChildAt(0);
            _loc3_ = _loc2_.getChildByName("dropPointR");
            if(_loc3_ != null)
            {
               _loc1_ = _world.mainContainer.globalToLocal(_loc3_.localToGlobal(new Point(0,0)));
            }
         }
         return _loc1_;
      }
      
      public function set currentWagon(param1:Wagon) : void
      {
         this._currentWagon = param1;
      }
      
      public function get currentWagon() : Wagon
      {
         return this._currentWagon;
      }
      
      public function get canSendWagon() : Boolean
      {
         if(this._currentWagon == null)
         {
            return this._delayToSendWagon <= 0;
         }
         return false;
      }
      
      public function get delayToSendWagon() : int
      {
         return this._delayToSendWagon;
      }
      
      override public function get relocateCost() : Number
      {
         return _relocateCost;
      }
   }
}
