package Instance.sprite
{
   import Instance.SEMovieClip;
   
   public class Animation extends SEMovieClip
   {
      
      public static const IDLE = "idle";
      
      public static const WALK = "walk";
       
      
      var _loopNumber:int;
      
      var _speedModifier:Number;
      
      var speedCtr:int;
      
      var loopCtr:int;
      
      public function Animation()
      {
         super();
         this._speedModifier = 1;
         this.speedCtr = 0;
         this.loopCtr = 0;
      }
   }
}
