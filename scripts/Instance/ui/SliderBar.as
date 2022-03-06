package Instance.ui
{
   import Instance.events.SliderBarEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SliderBar extends MovieClip
   {
       
      
      public var slideArea:MovieClip;
      
      public var slideIndicator:MovieClip;
      
      public var indicatorSign:MovieClip;
      
      public const HORIZONTAL = "horizontal";
      
      public const VERTICAL = "vertical";
      
      var _slideMode:String;
      
      var _grid:int;
      
      public function SliderBar()
      {
         super();
         this._slideMode = this.HORIZONTAL;
         this._grid = 0;
         this.slideArea.buttonMode = true;
         this.slideArea.tabEnabled = false;
         this.slideIndicator.buttonMode = true;
         this.slideIndicator.tabEnabled = false;
         this.slideIndicator.addEventListener(MouseEvent.MOUSE_DOWN,this.dragIndicator);
         this.slideArea.addEventListener(MouseEvent.MOUSE_DOWN,this.holdDown);
         addEventListener(Event.ADDED_TO_STAGE,this.Initialize);
      }
      
      function dragIndicator(param1:MouseEvent) : void
      {
         if(this.enabled)
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.moveIndicator);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.releaseIndicator);
         }
      }
      
      function holdDown(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         if(this.enabled)
         {
            if(this._slideMode == this.HORIZONTAL)
            {
               this.slideIndicator.x = mouseX;
               if(this._grid > 0)
               {
                  _loc2_ = this.slideArea.width / this._grid;
                  this.slideIndicator.x = this.slideArea.x + Math.round((this.slideIndicator.x - this.slideArea.x) / _loc2_) * _loc2_;
               }
            }
            else
            {
               this.slideIndicator.y = mouseY;
               if(this._grid > 0)
               {
                  _loc2_ = this.slideArea.height / this._grid;
                  this.slideIndicator.y = this.slideArea.y + Math.round((this.slideIndicator.y - this.slideArea.y) / _loc2_) * _loc2_;
               }
            }
            dispatchEvent(new SliderBarEvent(SliderBarEvent.CHANGE_POSITION));
            this.dragIndicator(param1);
         }
      }
      
      function moveIndicator(param1:MouseEvent) : void
      {
         if(this._slideMode == this.HORIZONTAL)
         {
            this.slideIndicator.x = mouseX;
         }
         else
         {
            this.slideIndicator.y = mouseY;
         }
         this.correctPosition();
         dispatchEvent(new SliderBarEvent(SliderBarEvent.CHANGE_POSITION));
      }
      
      function releaseIndicator(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveIndicator);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.releaseIndicator);
      }
      
      public function getPosition() : Number
      {
         var _loc1_:* = 0;
         if(this._slideMode == this.HORIZONTAL)
         {
            _loc1_ = (this.slideIndicator.x - this.slideArea.x) / this.slideArea.width;
         }
         else if(this._slideMode == this.VERTICAL)
         {
            _loc1_ = (this.slideIndicator.y - this.slideArea.y) / this.slideArea.height;
         }
         if(this._grid > 0)
         {
            _loc1_ = Math.round(_loc1_ * this._grid);
         }
         return _loc1_;
      }
      
      function Initialize(param1:Event) : void
      {
         this.correctPosition();
         addEventListener(Event.REMOVED_FROM_STAGE,this.Removed);
      }
      
      function Removed(param1:Event) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveIndicator);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.releaseIndicator);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.Removed);
      }
      
      function correctPosition() : void
      {
         var _loc1_:* = undefined;
         if(this._slideMode == this.HORIZONTAL)
         {
            this.slideIndicator.x = this.slideIndicator.x < this.slideArea.x ? Number(this.slideArea.x) : (this.slideIndicator.x > this.slideArea.x + this.slideArea.width ? Number(this.slideArea.x + this.slideArea.width) : Number(this.slideIndicator.x));
            this.slideIndicator.y = this.slideArea.y;
            if(this._grid > 0)
            {
               _loc1_ = this.slideArea.width / this._grid;
               this.slideIndicator.x = this.slideArea.x + Math.round((this.slideIndicator.x - this.slideArea.x) / _loc1_) * _loc1_;
            }
         }
         else
         {
            this.slideIndicator.x = this.slideArea.x;
            this.slideIndicator.y = this.slideIndicator.y < this.slideArea.y ? Number(this.slideArea.y) : (this.slideIndicator.y > this.slideArea.y + this.slideArea.height ? Number(this.slideArea.y + this.slideArea.height) : Number(this.slideIndicator.y));
            if(this._grid > 0)
            {
               _loc1_ = this.slideArea.height / this._grid;
               this.slideIndicator.y = this.slideArea.y + Math.round((this.slideIndicator.y - this.slideArea.y) / _loc1_) * _loc1_;
            }
         }
      }
      
      public function setPosition(param1:Number) : void
      {
         if(this._slideMode == this.HORIZONTAL)
         {
            if(this._grid > 0)
            {
               this.slideIndicator.x = this.slideArea.x + this.slideArea.width * param1 / this._grid;
            }
            else
            {
               this.slideIndicator.x = this.slideArea.x + this.slideArea.width * param1;
            }
         }
         else if(this._grid > 0)
         {
            this.slideIndicator.y = this.slideArea.y + this.slideArea.height * param1 / this._grid;
         }
         else
         {
            this.slideIndicator.y = this.slideArea.y + this.slideArea.height * param1;
         }
         this.correctPosition();
         dispatchEvent(new SliderBarEvent(SliderBarEvent.CHANGE_POSITION));
      }
      
      public function set grid(param1:int) : void
      {
         this._grid = param1;
      }
      
      public function get grid() : int
      {
         return this._grid;
      }
      
      public function set slideMode(param1:String) : *
      {
         this._slideMode = param1;
         this.correctPosition();
      }
   }
}
