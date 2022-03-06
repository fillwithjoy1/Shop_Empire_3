package Instance.property
{
   import Instance.SEMovieClip;
   import Instance.events.GameEvent;
   import Instance.events.LoopEvent;
   import Instance.gameplay.World;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Wagon extends SEMovieClip
   {
       
      
      public var backWheel:MovieClip;
      
      public var carriage:MovieClip;
      
      public var horse1:MovieClip;
      
      public var horse2:MovieClip;
      
      public var frontWheel:MovieClip;
      
      public const ARRIVE = 1;
      
      public const LEAVE = -1;
      
      public const DROP = 0;
      
      public const TOP_SPEED = 8;
      
      public const REDUCE_SPEED_DISTANCE = 60;
      
      const WAGON_WIDTH = 42;
      
      var _world:World;
      
      var _halte:HalteWagon;
      
      var _currentSpeed:Number;
      
      var _delayToDrop:int;
      
      var _arriving:int;
      
      var _dropPosition:Point;
      
      var _humanContainer:MovieClip;
      
      var _passanger:Array;
      
      var _wheelRadius:Object;
      
      public function Wagon()
      {
         super();
         this._delayToDrop = 0;
         this._currentSpeed = this.TOP_SPEED;
         this._arriving = this.ARRIVE;
         this._humanContainer = new MovieClip();
         this._humanContainer.visible = false;
         addChildAt(this._humanContainer,0);
         this._passanger = new Array();
         this._wheelRadius = new Object();
         this._wheelRadius.front = this.frontWheel.width / 2;
         this._wheelRadius.back = this.backWheel.width / 2;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this,LoopEvent.ON_IDLE,this.animationCheck);
         addListenerOf(this,LoopEvent.ON_IDLE,this.movingCheck);
         addListenerOf(stage,GameEvent.GAME_UPDATE,this.delayCheck);
      }
      
      function animationCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = this.carriage.driver;
         _loc2_.stop();
         var _loc3_:* = [this.carriage,this.horse1,this.horse2];
         var _loc4_:* = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc3_[_loc4_].stop();
            if(this._arriving != this.DROP)
            {
               if(_loc3_[_loc4_].currentFrame < _loc3_[_loc4_].totalFrames)
               {
                  _loc3_[_loc4_].nextFrame();
               }
               else
               {
                  _loc3_[_loc4_].gotoAndStop(1);
               }
            }
            else
            {
               _loc3_[_loc4_].gotoAndStop(1);
            }
            _loc4_++;
         }
         var _loc5_:*;
         (_loc5_ = this.carriage.driver).gotoAndStop(_loc2_.currentFrame);
         if(this._arriving != this.DROP)
         {
            if(_loc5_.currentFrame < _loc5_.totalFrames)
            {
               _loc5_.nextFrame();
            }
            else
            {
               _loc5_.gotoAndStop(1);
            }
         }
         else
         {
            _loc5_.gotoAndStop(1);
         }
      }
      
      function delayCheck(param1:GameEvent) : void
      {
         if(this._delayToDrop > 0)
         {
            --this._delayToDrop;
         }
      }
      
      function movingCheck(param1:LoopEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         if(this._halte != null)
         {
            _loc2_ = Math.abs(this._dropPosition.x - this.x);
            _loc3_ = false;
            _loc4_ = Math.PI * (this._wheelRadius.front * 2);
            _loc5_ = Math.PI * (this._wheelRadius.back * 2);
            _loc6_ = 0;
            if(this._arriving != this.LEAVE)
            {
               if(_loc2_ > 0)
               {
                  if(this._arriving == this.ARRIVE)
                  {
                     this._currentSpeed = Math.max(Math.min(this.TOP_SPEED,_loc2_ / this.REDUCE_SPEED_DISTANCE * this.TOP_SPEED),1);
                     if(_loc2_ - this._currentSpeed > 0)
                     {
                        this.x -= this._currentSpeed * scaleX;
                        _loc3_ = true;
                        _loc6_ = this._currentSpeed;
                     }
                     else
                     {
                        this.x = this._dropPosition.x;
                        this._arriving = this.DROP;
                        this._delayToDrop = 10;
                        _loc3_ = true;
                        _loc6_ = Math.abs(this._dropPosition.x - this.x);
                     }
                  }
               }
               else
               {
                  if(this._passanger.length > 0)
                  {
                     _loc7_ = this._passanger.shift();
                     _loc8_ = this._world.mainContainer.globalToLocal(_loc7_.localToGlobal(new Point(0,0)));
                     _loc7_.x = _loc8_.x;
                     _loc7_.y = _loc8_.y;
                     (_loc9_ = this.parent).addChildAt(_loc7_,0);
                     _loc7_.inside = this._halte;
                     _loc7_.passive = false;
                     this._halte.addPerson(_loc7_);
                     this._halte.gainExp(4.5);
                  }
                  if(this._delayToDrop <= 0)
                  {
                     if(this._passanger.length == 0)
                     {
                        this._arriving = this.LEAVE;
                     }
                  }
               }
            }
            else
            {
               if(this._currentSpeed < this.TOP_SPEED)
               {
                  ++this._currentSpeed;
               }
               if(scaleX > 0)
               {
                  if(this.x + this.width >= this._world.mostLeft)
                  {
                     this.x -= this._currentSpeed;
                     _loc3_ = true;
                     _loc6_ = this._currentSpeed;
                  }
                  else
                  {
                     this._halte.removeWagon();
                     this.parent.removeChild(this);
                  }
               }
               else if(scaleX < 0)
               {
                  if(this.x - this.width <= this._world.mostRight)
                  {
                     this.x += this._currentSpeed;
                     _loc3_ = true;
                     _loc6_ = this._currentSpeed;
                  }
                  else
                  {
                     this._halte.removeWagon();
                     this.parent.removeChild(this);
                  }
               }
            }
            if(_loc3_)
            {
               this.frontWheel.rotation -= 360 * (_loc6_ / _loc4_);
               this.backWheel.rotation -= 360 * (_loc6_ / _loc5_);
            }
         }
      }
      
      public function loadArrivingStat(param1:int) : void
      {
         this._arriving = param1;
         if(this._arriving == this.DROP)
         {
            this._delayToDrop = 10;
         }
      }
      
      public function addPerson(param1:*) : void
      {
         if(this._passanger.indexOf(param1) < 0)
         {
            this._passanger.push(param1);
         }
         param1.x = Math.random() * this.WAGON_WIDTH - this.WAGON_WIDTH / 2;
         param1.y = 0;
         param1.inside = this;
         this._humanContainer.addChild(param1);
      }
      
      public function set halte(param1:HalteWagon) : void
      {
         this._halte = param1;
      }
      
      public function get halte() : HalteWagon
      {
         return this._halte;
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function get arriving() : int
      {
         return this._arriving;
      }
      
      public function get passanger() : Array
      {
         return this._passanger;
      }
      
      public function set dropPosition(param1:Point) : void
      {
         this._dropPosition = param1;
      }
      
      public function get dropPosition() : Point
      {
         return this._dropPosition;
      }
   }
}
