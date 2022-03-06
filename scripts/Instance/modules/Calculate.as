package Instance.modules
{
   import flash.geom.Point;
   
   public class Calculate
   {
       
      
      public function Calculate()
      {
         super();
      }
      
      public static function chance(param1:Number) : Boolean
      {
         var _loc2_:* = Math.random() * 100;
         return _loc2_ <= param1;
      }
      
      public static function countDistance(param1:Point, param2:Point) : Number
      {
         var _loc3_:* = (param1.x - param2.x) * (param1.x - param2.x);
         var _loc4_:* = (param1.y - param2.y) * (param1.y - param2.y);
         return Math.sqrt(_loc3_ + _loc4_);
      }
      
      public static function countDotToLineDistance(param1:Point, param2:Point, param3:Point) : Number
      {
         var _loc4_:* = param3.y - param2.y;
         var _loc5_:* = param3.x - param2.x;
         var _loc6_:* = param2.y * _loc5_;
         var _loc7_:* = param2.x * _loc4_;
         var _loc8_:* = _loc6_ - _loc7_;
         var _loc9_:* = _loc4_;
         var _loc10_:* = -_loc5_;
         var _loc11_:* = _loc8_;
         return Math.abs(_loc9_ * param1.x + _loc10_ * param1.y + _loc11_) / Math.sqrt(_loc9_ * _loc9_ + _loc10_ * _loc10_);
      }
      
      public static function getXFromPoint(param1:Point, param2:Point, param3:Number) : Number
      {
         var _loc4_:* = param2.y - param1.y;
         var _loc5_:* = param2.x - param1.x;
         var _loc6_:*;
         var _loc7_:* = (_loc6_ = _loc4_ / _loc5_) * param1.x;
         var _loc8_:* = _loc6_;
         var _loc9_:* = param1.y - _loc7_;
         return (param3 - _loc9_) / _loc8_;
      }
      
      public static function getPointDirectionFromLine(param1:Point, param2:Point, param3:Point) : int
      {
         var _loc4_:* = param3.y - param2.y;
         var _loc5_:* = param3.x - param2.x;
         var _loc6_:*;
         var _loc7_:* = (_loc6_ = _loc4_ / _loc5_) * param2.x;
         var _loc8_:* = _loc6_;
         var _loc9_:* = param2.y - _loc7_;
         var _loc10_:* = param1.y;
         var _loc11_:* = param1.x * _loc8_ + _loc9_;
         return _loc10_ == _loc11_ ? 0 : (_loc10_ < _loc11_ ? -1 : 1);
      }
   }
}
