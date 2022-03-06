package Instance.property
{
   import Instance.SEMovieClip;
   import Instance.modules.Utility;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Floor extends SEMovieClip
   {
       
      
      public var bodyFloor:MovieClip;
      
      public var rightFloor:MovieClip;
      
      public var leftFloor:MovieClip;
      
      var _left:Number;
      
      var _right:Number;
      
      var realBody:Sprite;
      
      public function Floor()
      {
         super();
         this.bodyFloor.parent.removeChild(this.bodyFloor);
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.updateBodyFloor();
      }
      
      function updateBodyFloor() : void
      {
         var _loc1_:BitmapData = null;
         if(this.stage != null)
         {
            if(this.realBody != null)
            {
               if(getChildByName(this.realBody.name))
               {
                  removeChild(this.realBody);
               }
               this.realBody = null;
            }
            _loc1_ = Utility.crop(this.bodyFloor,-this.bodyFloor.width / 2,0,this.bodyFloor.width,this.bodyFloor.height).bitmapData;
            this.realBody = new Sprite();
            this.realBody.graphics.beginBitmapFill(_loc1_);
            this.realBody.graphics.drawRect(this._left + this.leftFloor.width,0,this._right - this.rightFloor.width - (this._left + this.leftFloor.width),12);
            this.realBody.graphics.endFill();
            addChildAt(this.realBody,0);
            this.leftFloor.x = this._left;
            this.rightFloor.x = this._right;
         }
      }
      
      override protected function Removed(param1:Event) : void
      {
         super.Removed(param1);
         if(this.realBody != null)
         {
            if(getChildByName(this.realBody.name))
            {
               removeChild(this.realBody);
            }
            this.realBody = null;
         }
      }
      
      public function set left(param1:Number) : void
      {
         this._left = param1;
         this.updateBodyFloor();
      }
      
      public function get left() : Number
      {
         return this._left;
      }
      
      public function set right(param1:Number) : void
      {
         this._right = param1;
         this.updateBodyFloor();
      }
      
      public function get right() : Number
      {
         return this._right;
      }
   }
}
