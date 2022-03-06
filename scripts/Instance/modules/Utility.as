package Instance.modules
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.display.PixelSnapping;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class Utility
   {
       
      
      public function Utility()
      {
         super();
      }
      
      public static function getClass(param1:Object) : Class
      {
         return Class(getDefinitionByName(getQualifiedClassName(param1)));
      }
      
      public static function cloning(param1:Object) : *
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeObject(param1);
         _loc2_.position = 0;
         return _loc2_.readObject();
      }
      
      public static function copyProperty(param1:*, param2:*) : void
      {
         var tSource:* = undefined;
         var prop:* = undefined;
         var source:* = param1;
         var dest:* = param2;
         tSource = cloning(source);
         for(prop in tSource)
         {
            try
            {
               dest[prop] = tSource[prop];
            }
            catch(e:Error)
            {
               copyProperty(tSource[prop],dest[prop]);
            }
         }
      }
      
      public static function crop(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number) : Bitmap
      {
         var _loc6_:Rectangle = new Rectangle(0,0,param4,param5);
         var _loc7_:Bitmap;
         (_loc7_ = new Bitmap(new BitmapData(param4,param5,true,0),PixelSnapping.ALWAYS,true)).bitmapData.draw(param1,new Matrix(1,0,0,1,-param2,-param3),null,null,_loc6_,true);
         return _loc7_;
      }
      
      public static function numberToOrdinal(param1:int) : String
      {
         var _loc2_:* = "";
         if(param1 % 100 > 10 && param1 < 20)
         {
            _loc2_ = param1 + "th";
         }
         else if(param1 % 10 == 1)
         {
            _loc2_ = param1 + "st";
         }
         else if(param1 % 10 == 2)
         {
            _loc2_ = param1 + "nd";
         }
         else if(param1 % 10 == 3)
         {
            _loc2_ = param1 + "rd";
         }
         else
         {
            _loc2_ = param1 + "th";
         }
         return _loc2_;
      }
      
      public static function numberToMoney(param1:Number) : String
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = "";
         if(Math.abs(param1) >= 1000)
         {
            _loc3_ = Math.floor(Math.abs(param1) / 1000) * (param1 >= 0 ? 1 : -1);
            _loc4_ = Math.abs(param1) % 1000;
            _loc5_ = numberToMoney(_loc3_);
            _loc6_ = _loc4_ + "";
            while(_loc6_.length < 3)
            {
               _loc6_ = "0" + _loc6_;
            }
            _loc2_ = _loc5_ + "," + _loc6_;
         }
         else
         {
            _loc2_ = param1 + "";
         }
         return _loc2_;
      }
      
      public static function numberToDate(param1:Number) : String
      {
         var _loc2_:* = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
         if(param1 in _loc2_)
         {
            return _loc2_[param1];
         }
         return "???";
      }
      
      public static function timeStringConversion(param1:Number, param2:Number) : String
      {
         var _loc3_:* = "";
         var _loc4_:* = param1 >= 12 ? "pm" : "am";
         var _loc5_:* = "" + (param1 > 12 ? param1 - 12 : param1) + "";
         var _loc6_:* = "" + param2 + "";
         while(_loc5_.length < 2)
         {
            _loc5_ = "0" + _loc5_;
         }
         while(_loc6_.length < 2)
         {
            _loc6_ = "0" + _loc6_;
         }
         return _loc5_ + ":" + _loc6_ + "" + _loc4_;
      }
      
      public static function rotateByPoint(param1:DisplayObject, param2:Number, param3:Point = null) : void
      {
         var _loc4_:* = param1.localToGlobal(param3);
         param1.rotation = param2;
         var _loc5_:* = param1.globalToLocal(_loc4_);
         var _loc6_:* = param3.x - _loc5_.x;
         var _loc7_:* = param3.y - _loc5_.y;
         param1.x -= _loc6_;
         param1.y -= _loc7_;
      }
      
      public static function clearArray(param1:Array) : void
      {
         param1 = [];
      }
      
      public static function getIndexOf(param1:Array, param2:Object) : Object
      {
         var _loc4_:* = undefined;
         var _loc3_:* = null;
         for(_loc4_ in param1)
         {
            if(param1[_loc4_] == param2)
            {
               _loc3_ = _loc4_;
               break;
            }
         }
         return _loc3_;
      }
      
      public static function getMinIndex(param1:Array) : int
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = -1;
         if(param1.length > 0)
         {
            _loc3_ = param1[0];
            _loc2_ = 0;
            _loc4_ = 1;
            while(_loc4_ < param1.length)
            {
               if(param1[_loc4_] < _loc3_)
               {
                  _loc3_ = param1[_loc4_];
                  _loc2_ = _loc4_;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public static function polyIsHitEachOther(param1:Point, param2:Point, param3:Point, param4:Point) : Boolean
      {
         var _loc10_:* = undefined;
         var _loc5_:* = false;
         var _loc6_:* = (param2.y - param1.y) / (param2.x - param1.x);
         var _loc7_:* = (param4.y - param3.y) / (param4.x - param3.x);
         var _loc8_:* = param1.y - _loc6_ * param1.x;
         var _loc9_:* = param3.y - _loc7_ * param3.x;
         if(_loc6_ != _loc7_)
         {
            if((_loc10_ = (_loc9_ - _loc8_) / (_loc6_ - _loc7_)) > Math.min(param1.x,param2.x) && _loc10_ < Math.max(param1.x,param2.x) && (_loc10_ > Math.min(param3.x,param4.x) && _loc10_ < Math.max(param3.x,param4.x)))
            {
               _loc5_ = true;
            }
         }
         return _loc5_;
      }
      
      public static function getPointOfPoly(param1:Point, param2:Point, param3:Point, param4:Point) : Point
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc5_:* = null;
         var _loc6_:* = (param2.y - param1.y) / (param2.x - param1.x);
         var _loc7_:* = (param4.y - param3.y) / (param4.x - param3.x);
         var _loc8_:* = param1.y - _loc6_ * param1.x;
         var _loc9_:* = param3.y - _loc7_ * param3.x;
         if(_loc6_ != _loc7_)
         {
            if(Math.abs(_loc6_) != Infinity && Math.abs(_loc7_) != Infinity)
            {
               _loc10_ = (_loc9_ - _loc8_) / (_loc6_ - _loc7_);
               _loc11_ = _loc6_ * _loc10_ + _loc8_;
            }
            else if(Math.abs(_loc6_) == Infinity)
            {
               _loc10_ = param1.x;
               _loc11_ = _loc7_ * _loc10_ + _loc9_;
            }
            else
            {
               _loc10_ = param3.x;
               _loc11_ = _loc6_ * _loc10_ + _loc8_;
            }
            if(_loc10_ >= Math.min(param1.x,param2.x) && _loc10_ <= Math.max(param1.x,param2.x) && (_loc10_ >= Math.min(param3.x,param4.x) && _loc10_ <= Math.max(param3.x,param4.x)) && (_loc11_ >= Math.min(param1.y,param2.y) && _loc11_ <= Math.max(param1.y,param2.y) && (_loc11_ >= Math.min(param3.y,param4.y) && _loc11_ <= Math.max(param3.y,param4.y))))
            {
               _loc5_ = new Point(_loc10_,_loc11_);
            }
         }
         return _loc5_;
      }
      
      public static function getNearestPointOfPoly(param1:Point, param2:Point, param3:Point) : Point
      {
         var _loc4_:* = (param3.y - param2.y) / (param3.x - param2.x);
         var _loc5_:* = param2.y - _loc4_ * param2.x;
         var _loc6_:* = -1 / _loc4_;
         var _loc7_:* = param1.y - _loc6_ * param1.x;
         var _loc8_:*;
         (_loc8_ = new Point()).x = (_loc7_ - _loc5_) / (_loc4_ - _loc6_);
         _loc8_.y = _loc6_ * _loc8_.x + _loc7_;
         return _loc8_;
      }
      
      public static function degreeToRadian(param1:Number) : Number
      {
         return param1 * (Math.PI / 180);
      }
      
      public static function radianToDegree(param1:Number) : Number
      {
         return param1 * (180 / Math.PI);
      }
      
      public static function shuffle(param1:Array) : void
      {
         var _loc4_:* = undefined;
         var _loc2_:* = new Array();
         while(param1.length > 0)
         {
            _loc4_ = Math.floor(Math.random() * param1.length);
            _loc2_.push(param1[_loc4_]);
            param1.splice(_loc4_,1);
         }
         var _loc3_:* = 0;
         while(_loc3_ < _loc2_.length)
         {
            param1.push(_loc2_[_loc3_]);
            _loc3_++;
         }
      }
      
      public static function doMultipleFunction(param1:Array, param2:Array) : void
      {
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] is Function)
            {
               param1[_loc3_].apply(null,param2[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      public static function hasLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc6_:FrameLabel = null;
         var _loc3_:* = false;
         var _loc4_:Array = param1.currentLabels;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(param2 == _loc6_.name)
            {
               _loc3_ = true;
               break;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public static function getLabelIndex(param1:MovieClip, param2:String) : int
      {
         var _loc6_:FrameLabel = null;
         var _loc3_:* = 0;
         var _loc4_:Array = param1.currentLabels;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(param2 == _loc6_.name)
            {
               _loc3_ = _loc6_.frame;
               break;
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function pointInLine(param1:Point, param2:Point, param3:Point) : Boolean
      {
         return param1.x == (param1.y - param2.y) / (param3.y - param2.y) * (param3.x - param2.x) - param2.x;
      }
   }
}
