package Instance.constant
{
   import flash.ui.Keyboard;
   
   public class Config
   {
      
      public static const SCROLL_LEFT = "Scroll_Left";
      
      public static const SCROLL_RIGHT = "Scroll_Right";
      
      public static const SCROLL_UP = "Scroll_Up";
      
      public static const SCROLL_DOWN = "Scroll_Down";
      
      public static const SCROLL_KEY = [Keyboard.A,Keyboard.W,Keyboard.S,Keyboard.D,Keyboard.LEFT,Keyboard.UP,Keyboard.DOWN,Keyboard.RIGHT];
      
      public static const SCROLL_CODE = [SCROLL_LEFT,SCROLL_UP,SCROLL_DOWN,SCROLL_RIGHT,SCROLL_LEFT,SCROLL_UP,SCROLL_DOWN,SCROLL_RIGHT];
       
      
      public function Config()
      {
         super();
      }
      
      public static function getScrollCode(param1:uint) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = SCROLL_KEY.indexOf(param1);
         if(_loc3_ in SCROLL_CODE)
         {
            _loc2_ = SCROLL_CODE[_loc3_];
         }
         return _loc2_;
      }
   }
}
