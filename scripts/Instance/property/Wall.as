package Instance.property
{
   import Instance.SEMovieClip;
   import Instance.modules.Utility;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class Wall extends SEMovieClip
   {
       
      
      public var wallSprite:MovieClip;
      
      var _left:Number;
      
      var _right:Number;
      
      var realBody:Sprite;
      
      public function Wall()
      {
         super();
         this.wallSprite.parent.removeChild(this.wallSprite);
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.updateWall();
      }
      
      function updateWall() : void
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
            _loc1_ = Utility.crop(this.wallSprite,0,-this.wallSprite.height,this.wallSprite.width,this.wallSprite.height).bitmapData;
            this.realBody = new Sprite();
            this.realBody.graphics.beginBitmapFill(_loc1_);
            this.realBody.graphics.drawRect(this._left,-_loc1_.height,this._right - this._left,_loc1_.height);
            this.realBody.graphics.endFill();
            addChildAt(this.realBody,0);
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
         this.updateWall();
      }
      
      public function get left() : Number
      {
         return this._left;
      }
      
      public function set right(param1:Number) : void
      {
         this._right = param1;
         this.updateWall();
      }
      
      public function get right() : Number
      {
         return this._right;
      }
   }
}
