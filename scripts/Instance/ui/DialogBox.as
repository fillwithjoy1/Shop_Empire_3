package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.GameEvent;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class DialogBox extends SEMovieClip
   {
       
      
      public var iconClip:MovieClip;
      
      var _relation:MovieClip;
      
      var _delay:Number;
      
      var _yDistance:Number;
      
      var ctr:Number;
      
      public function DialogBox()
      {
         super();
         this._relation = null;
         this.ctr = 0;
         this.visible = false;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         super.Initialize(param1);
         if(this._relation != null)
         {
            if(this._relation.parent != null)
            {
               _loc2_ = this.parent;
               _loc3_ = _loc2_.globalToLocal(this._relation.localToGlobal(new Point(0,0)));
               this.x = _loc3_.x;
               this.y = _loc3_.y - this.yDistance;
               addListenerOf(this,Event.ENTER_FRAME,this.correctPosition);
               if(this._delay > 0)
               {
                  addListenerOf(stage,GameEvent.GAME_UPDATE,this.tick);
               }
            }
         }
      }
      
      function correctPosition(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.stage != null)
         {
            if(this._relation.parent != null)
            {
               this.visible = true;
               _loc2_ = this.parent;
               _loc3_ = _loc2_.globalToLocal(this._relation.localToGlobal(new Point(0,0)));
               this.x = _loc3_.x;
               this.y = _loc3_.y - this.yDistance;
            }
            else
            {
               this.parent.removeChild(this);
            }
         }
         else
         {
            removeListenerOf(this,Event.ENTER_FRAME,this.correctPosition);
         }
      }
      
      function tick(param1:GameEvent) : void
      {
         if(stage != null)
         {
            if(this._delay > 0)
            {
               ++this.ctr;
               if(this.ctr >= this._delay)
               {
                  this.parent.removeChild(this);
               }
            }
         }
      }
      
      public function set relation(param1:MovieClip) : void
      {
         this._relation = param1;
      }
      
      public function get relation() : MovieClip
      {
         return this._relation;
      }
      
      public function set delay(param1:Number) : void
      {
         this._delay = param1;
         if(this._delay > 0)
         {
            this.ctr = 0;
            if(stage != null)
            {
               addListenerOf(stage,GameEvent.GAME_UPDATE,this.tick);
            }
         }
         else if(stage != null)
         {
            removeListenerOf(stage,GameEvent.GAME_UPDATE,this.tick);
         }
      }
      
      public function get delay() : Number
      {
         return this._delay;
      }
      
      public function set iconType(param1:String) : void
      {
         this.iconClip.gotoAndStop(param1);
      }
      
      public function get iconType() : String
      {
         return this.iconClip.currentFrameLabel;
      }
      
      public function set iconSign(param1:String) : void
      {
         var _loc2_:* = this.iconClip.getChildAt(0);
         if(_loc2_ != null)
         {
            if(Utility.hasLabel(_loc2_,param1))
            {
               _loc2_.gotoAndStop(param1);
            }
         }
      }
      
      public function get iconSign() : String
      {
         var _loc1_:* = this.iconClip.getChildAt(0);
         if(_loc1_ != null)
         {
            return _loc1_.currentFrameLabel;
         }
         return null;
      }
      
      public function set yDistance(param1:Number) : void
      {
         this._yDistance = param1;
      }
      
      public function get yDistance() : Number
      {
         return this._yDistance;
      }
   }
}
