package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.constant.ColorCode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   
   public class TutorialBaloonText extends SEMovieClip
   {
       
      
      public var commentInfo:TextField;
      
      var _text:String;
      
      var _appearSpeed:Number;
      
      var _animated:Boolean;
      
      var _completed:Boolean;
      
      var _charList:Array;
      
      var _charInFrame:Array;
      
      var delayCtr:Number;
      
      var pauseMode:Boolean;
      
      public function TutorialBaloonText()
      {
         super();
         this._appearSpeed = 1.8;
         this._animated = false;
         this._charList = new Array();
         this._charInFrame = new Array();
         this.delayCtr = 0;
         this.pauseMode = false;
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      function showText(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:TextField = null;
         var _loc5_:Rectangle = null;
         var _loc6_:* = undefined;
         if(!this.pauseMode)
         {
            this.delayCtr += this._appearSpeed;
            while(this.delayCtr >= 1)
            {
               if(this._charList.length > 0)
               {
                  _loc2_ = this._charList.shift();
                  if(_loc2_.ch != null)
                  {
                     if(_loc2_.pos != null)
                     {
                        _loc3_ = this.commentInfo.defaultTextFormat;
                        _loc3_.align = TextFormatAlign.LEFT;
                        (_loc4_ = new TextField()).defaultTextFormat = _loc3_;
                        _loc4_.text = _loc2_.ch;
                        _loc4_.embedFonts = true;
                        _loc4_.selectable = false;
                        _loc4_.x = -_loc4_.width / 2;
                        _loc4_.y = -_loc4_.height / 2;
                        if(_loc2_.color != null)
                        {
                           _loc4_.textColor = _loc2_.color;
                        }
                        _loc5_ = (_loc4_ as TextField).getCharBoundaries(0);
                        (_loc6_ = new Sprite()).addChild(_loc4_);
                        _loc6_.x = _loc2_.pos.x + _loc4_.width / 2 - _loc5_.x;
                        _loc6_.y = _loc2_.pos.y + _loc4_.height / 2 - _loc5_.y;
                        addChild(_loc6_);
                        this._charInFrame.push(_loc6_);
                     }
                  }
                  else if(_loc2_.delay != null)
                  {
                     this.delayCtr -= _loc2_.delay;
                  }
               }
               else
               {
                  this._completed = true;
                  removeListenerOf(this,Event.ENTER_FRAME,this.showText);
               }
               --this.delayCtr;
            }
         }
      }
      
      function createBubbleBorder() : void
      {
         var _loc11_:Point = null;
         var _loc12_:Point = null;
         var _loc1_:* = this._text;
         _loc1_ = _loc1_.replace(/&gr/g,"<font color = \'#28ea24\'>");
         _loc1_ = _loc1_.replace(/&rd/g,"<font color = \'#FF0033\'>");
         _loc1_ = _loc1_.replace(/&bl/g,"<font color = \'#" + ColorCode.VALID_CASH.toString(16) + "\'>");
         _loc1_ = _loc1_.replace(/%ft/g,"</font>");
         this.commentInfo.autoSize = TextFieldAutoSize.LEFT;
         this.commentInfo.htmlText = _loc1_;
         var _loc2_:* = this.commentInfo.height + 3;
         var _loc3_:Point = new Point(this.commentInfo.x + this.commentInfo.width + 5,-20);
         var _loc4_:Point = new Point(this.commentInfo.x + this.commentInfo.width + 5,-5);
         var _loc5_:Array = new Array();
         var _loc6_:Point = new Point(_loc3_.x,_loc3_.y + 10);
         var _loc7_:Point = new Point(_loc3_.x / 2,_loc4_.y + 5);
         if(this.commentInfo.y + _loc2_ < _loc3_.y)
         {
            _loc3_.x = this.commentInfo.x + this.commentInfo.width - 25;
            _loc3_.y = this.commentInfo.y + _loc2_ + 5;
            _loc5_.push(new Point(this.commentInfo.x + this.commentInfo.width + 5,this.commentInfo.y + _loc2_ + 5));
            _loc6_.x = _loc3_.x;
            _loc6_.y = _loc3_.y + 10;
         }
         _loc5_.push(new Point(this.commentInfo.x + this.commentInfo.width + 5,this.commentInfo.y - 5));
         _loc5_.push(new Point(this.commentInfo.x - 5,this.commentInfo.y - 5));
         _loc5_.push(new Point(this.commentInfo.x - 5,this.commentInfo.y + _loc2_ + 5));
         if(this.commentInfo.y + _loc2_ < _loc4_.y)
         {
            _loc4_.x = _loc3_.x - 23;
            _loc4_.y = this.commentInfo.y + _loc2_ + 5;
            _loc7_.x = _loc4_.x / 2 - 15;
            _loc7_.y = _loc4_.y / 2 + 15;
         }
         else
         {
            _loc5_.push(new Point(this.commentInfo.x + this.commentInfo.width + 5,this.commentInfo.y + _loc2_ + 5));
         }
         this.graphics.clear();
         this.graphics.lineStyle(2,0);
         this.graphics.beginFill(16777215);
         this.graphics.moveTo(0,0);
         var _loc8_:* = _loc3_.x;
         var _loc9_:* = _loc3_.y;
         this.graphics.curveTo(_loc6_.x,_loc6_.y,_loc8_,_loc9_);
         var _loc10_:* = 0;
         while(_loc10_ < _loc5_.length)
         {
            _loc11_ = new Point();
            _loc12_ = new Point();
            if(_loc8_ == _loc5_[_loc10_].x)
            {
               _loc11_.x = _loc5_[_loc10_].x;
               _loc11_.y = _loc5_[_loc10_].y + (_loc5_[_loc10_].y < _loc9_ ? 10 : -10);
               _loc12_.x = _loc5_[_loc10_].x - (_loc5_[_loc10_].y < _loc9_ ? 10 : -10);
               _loc12_.y = _loc5_[_loc10_].y;
            }
            else if(_loc9_ == _loc5_[_loc10_].y)
            {
               _loc11_.x = _loc5_[_loc10_].x + (_loc5_[_loc10_].x < _loc8_ ? 10 : -10);
               _loc11_.y = _loc5_[_loc10_].y;
               _loc12_.x = _loc5_[_loc10_].x;
               _loc12_.y = _loc5_[_loc10_].y + (_loc5_[_loc10_].x < _loc8_ ? 10 : -10);
            }
            else
            {
               _loc11_.x = _loc5_[_loc10_].x;
               _loc11_.y = _loc5_[_loc10_].y;
            }
            _loc8_ = _loc5_[_loc10_].x;
            _loc9_ = _loc5_[_loc10_].y;
            this.graphics.lineTo(_loc11_.x,_loc11_.y);
            this.graphics.curveTo(_loc8_,_loc9_,_loc12_.x,_loc12_.y);
            _loc10_++;
         }
         this.graphics.lineTo(_loc4_.x,_loc4_.y);
         this.graphics.curveTo(_loc7_.x,_loc7_.y,0,0);
         this.graphics.endFill();
         this.commentInfo.visible = !this._animated;
         if(this._animated)
         {
            this._completed = false;
            this.makeCharListFromText();
            addListenerOf(this,Event.ENTER_FRAME,this.showText);
         }
      }
      
      function skipAnimatedProgress() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:TextField = null;
         var _loc4_:Rectangle = null;
         var _loc5_:* = undefined;
         while(this._charList.length > 0)
         {
            _loc1_ = this._charList.shift();
            if(_loc1_.ch != null)
            {
               if(_loc1_.pos != null)
               {
                  _loc2_ = this.commentInfo.defaultTextFormat;
                  _loc2_.align = TextFormatAlign.LEFT;
                  _loc3_ = new TextField();
                  _loc3_.defaultTextFormat = _loc2_;
                  _loc3_.text = _loc1_.ch;
                  _loc3_.x = _loc1_.pos.x;
                  _loc3_.y = _loc1_.pos.y;
                  _loc3_.embedFonts = true;
                  _loc3_.selectable = false;
                  _loc3_.x = -_loc3_.width / 2;
                  _loc3_.y = -_loc3_.height / 2;
                  if(_loc1_.color != null)
                  {
                     _loc3_.textColor = _loc1_.color;
                  }
                  _loc4_ = (_loc3_ as TextField).getCharBoundaries(0);
                  (_loc5_ = new Sprite()).addChild(_loc3_);
                  _loc5_.x = _loc1_.pos.x + _loc3_.width / 2 - _loc4_.x;
                  _loc5_.y = _loc1_.pos.y + _loc3_.height / 2 - _loc4_.y;
                  addChild(_loc5_);
                  this._charInFrame.push(_loc5_);
               }
            }
         }
      }
      
      public function forceSkip() : void
      {
         if(this._animated)
         {
            this.skipAnimatedProgress();
         }
         else
         {
            this.delayCtr = 0;
         }
         this._completed = true;
      }
      
      function clearText() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:* = [this._charList,this._charInFrame];
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            while(_loc3_.length > 0)
            {
               if((_loc4_ = _loc3_.shift()).parent != null)
               {
                  _loc4_.parent.removeChild(_loc4_);
               }
            }
            _loc2_++;
         }
      }
      
      function makeCharListFromText() : void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:Rectangle = null;
         var _loc9_:* = undefined;
         var _loc1_:* = this._text;
         var _loc2_:* = 0;
         var _loc3_:* = this.commentInfo.text;
         var _loc4_:* = this.commentInfo.textColor;
         var _loc5_:* = new Array();
         while(_loc1_.length > 0)
         {
            _loc6_ = "";
            if(_loc1_.search("&gr") == 0 || _loc1_.search("&rd") == 0 || _loc1_.search("&bl") == 0 || _loc1_.search("%ft") == 0)
            {
               if(_loc1_.search("&gr") == 0)
               {
                  _loc6_ = "&gr";
                  _loc5_.unshift(3832356);
               }
               else if(_loc1_.search("&rd") == 0)
               {
                  _loc6_ = "&rd";
                  _loc5_.unshift(16711731);
               }
               else if(_loc1_.search("&bl") == 0)
               {
                  _loc6_ = "&bl";
                  _loc5_.unshift(ColorCode.VALID_CASH);
               }
               else if(_loc1_.search("%ft") == 0)
               {
                  _loc6_ = "%ft";
                  _loc5_.shift();
               }
               if(_loc5_.length > 0)
               {
                  _loc4_ = _loc5_[0];
               }
               else
               {
                  _loc4_ = this.commentInfo.textColor;
               }
            }
            else
            {
               if((_loc6_ = _loc1_.charAt(0)) == "&")
               {
                  if(this._text.length > 1)
                  {
                     if((_loc7_ = _loc1_.charAt(1)) == "d")
                     {
                        _loc6_ += _loc7_;
                     }
                  }
               }
               if(_loc6_ != "&d")
               {
                  if(_loc6_ != " " && _loc6_ != "\n")
                  {
                     _loc8_ = (this.commentInfo as TextField).getCharBoundaries(_loc2_);
                     this._charList.push({
                        "ch":_loc6_,
                        "pos":{
                           "x":_loc8_.x + this.commentInfo.x,
                           "y":_loc8_.y + this.commentInfo.y
                        },
                        "color":_loc4_,
                        "delay":(_loc6_ == "." ? 3 : null)
                     });
                  }
                  else if((_loc9_ = this._charList[this._charList.length - 1]) != null)
                  {
                     if(_loc9_.ch == ".")
                     {
                        this._charList.push({
                           "ch":null,
                           "delay":(_loc6_ == "\n" ? 10 : null)
                        });
                     }
                  }
                  else
                  {
                     this._charList.push({"ch":null});
                  }
                  _loc2_++;
               }
               else
               {
                  this._charList.push({
                     "ch":null,
                     "delay":5
                  });
               }
            }
            _loc1_ = _loc1_.substr(_loc6_.length);
         }
      }
      
      public function pauseAnimation() : void
      {
         this.pauseMode = true;
      }
      
      public function resumeAnimation() : void
      {
         this.pauseMode = false;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         this.createBubbleBorder();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set animated(param1:Boolean) : void
      {
         this._animated = param1;
      }
      
      public function get animated() : Boolean
      {
         return this._animated;
      }
      
      public function get completed() : Boolean
      {
         return this._completed;
      }
   }
}
