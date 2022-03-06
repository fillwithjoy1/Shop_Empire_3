package Instance.property
{
   import Instance.SEMovieClip;
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class Trash extends SEMovieClip
   {
       
      
      public var trashHitBody:MovieClip;
      
      var _dirtyLevel:Number;
      
      var _onFloor:MovieClip;
      
      var _cleaner;
      
      public function Trash()
      {
         super();
         this._dirtyLevel = 0;
         this._cleaner = null;
         priority = 1;
         stop();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.checkDirtyLevel();
      }
      
      function checkDirtyLevel() : void
      {
         if(this._dirtyLevel > 90)
         {
            gotoAndStop("Max Dirty");
         }
         else if(this._dirtyLevel > 70)
         {
            gotoAndStop("Very Dirty");
         }
         else if(this._dirtyLevel > 50)
         {
            gotoAndStop("Dirty");
         }
         else if(this._dirtyLevel > 30)
         {
            gotoAndStop("Looks Dirty");
         }
         else if(this._dirtyLevel > 20)
         {
            gotoAndStop("Little Dirty");
         }
         else
         {
            gotoAndStop("Not Dirty");
         }
         this.visible = this._dirtyLevel > 10;
      }
      
      public function set dirtyLevel(param1:Number) : *
      {
         this._dirtyLevel = Math.min(param1,100);
         this.checkDirtyLevel();
      }
      
      public function get dirtyLevel() : Number
      {
         return this._dirtyLevel;
      }
      
      public function set onFloor(param1:MovieClip) : *
      {
         this._onFloor = param1;
      }
      
      public function get onFloor() : MovieClip
      {
         return this._onFloor;
      }
      
      public function set cleaner(param1:*) : void
      {
         this._cleaner = param1;
      }
      
      public function get cleaner() : *
      {
         return this._cleaner;
      }
   }
}
