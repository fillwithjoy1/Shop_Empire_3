package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.InfoDialogEvent;
   import Instance.modules.Utility;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class UI_InfoDialog extends SEMovieClip
   {
       
      
      var deviation:Point;
      
      var realBodyPart:MovieClip;
      
      var bodyPartData:Object;
      
      var bodyPartList:Object;
      
      var _relation;
      
      public function UI_InfoDialog()
      {
         var _loc2_:* = undefined;
         super();
         this.deviation = null;
         this.bodyPartData = new Object();
         this.bodyPartList = new Object();
         var _loc1_:* = new Object();
         _loc1_.center = getChildByName("bodyPartCenter");
         _loc1_.left = getChildByName("bodyPartLeft");
         _loc1_.right = getChildByName("bodyPartRight");
         _loc1_.bottomCenter = getChildByName("bodyPartBottomCenter");
         _loc1_.bottomLeft = getChildByName("bodyPartBottomLeft");
         _loc1_.bottomRight = getChildByName("bodyPartBottomRight");
         for(_loc2_ in _loc1_)
         {
            if(_loc1_[_loc2_] != null)
            {
               this.bodyPartData[_loc2_] = new Object();
               this.bodyPartData[_loc2_].width = _loc1_[_loc2_].width;
               this.bodyPartData[_loc2_].height = _loc1_[_loc2_].height;
               _loc1_[_loc2_].scaleX = 1;
               _loc1_[_loc2_].scaleY = 1;
               this.bodyPartList[_loc2_] = _loc1_[_loc2_];
               removeChild(_loc1_[_loc2_]);
            }
         }
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.correctBodyPart();
         var _loc2_:* = getChildByName("dragArea");
         this.x = Math.min(Math.max(this.x,this.width / 2),700 - this.width / 2);
         this.y = Math.min(Math.max(this.y,0),500 - this.height);
         if(_loc2_ != null)
         {
            _loc2_.buttonMode = true;
            addListenerOf(_loc2_,MouseEvent.MOUSE_DOWN,this.beginDrag);
         }
         var _loc3_:* = getChildByName("btnClose");
         if(_loc3_ != null)
         {
            addListenerOf(_loc3_,MouseEvent.CLICK,this.btnCloseOnClick);
         }
      }
      
      function btnCloseOnClick(param1:MouseEvent) : void
      {
         if(this.stage != null)
         {
            this.parent.removeChild(this);
         }
      }
      
      function correctBodyPart() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:BitmapData = null;
         if(this.stage != null)
         {
            if(this.realBodyPart != null)
            {
               if(getChildByName(this.realBodyPart.name))
               {
                  removeChild(this.realBodyPart);
               }
               this.realBodyPart = null;
            }
            _loc1_ = {
               "center":0.5,
               "left":0,
               "right":1,
               "bottomCenter":0.5,
               "bottomLeft":0,
               "bottomRight":1
            };
            this.realBodyPart = new MovieClip();
            _loc2_ = new Object();
            for(_loc3_ in this.bodyPartData)
            {
               _loc4_ = -this.bodyPartList[_loc3_].width * _loc1_[_loc3_];
               _loc5_ = -this.bodyPartData[_loc3_].width * _loc1_[_loc3_];
               _loc6_ = Utility.crop(this.bodyPartList[_loc3_],_loc4_,0,this.bodyPartList[_loc3_].width,this.bodyPartList[_loc3_].height).bitmapData;
               _loc2_[_loc3_] = new Sprite();
               _loc2_[_loc3_].graphics.beginBitmapFill(_loc6_);
               _loc2_[_loc3_].graphics.drawRect(_loc5_,0,this.bodyPartData[_loc3_].width,this.bodyPartData[_loc3_].height);
               _loc2_[_loc3_].graphics.endFill();
               _loc2_[_loc3_].x = this.bodyPartList[_loc3_].x;
               _loc2_[_loc3_].y = this.bodyPartList[_loc3_].y;
               this.realBodyPart.addChildAt(_loc2_[_loc3_],0);
            }
            addChildAt(this.realBodyPart,0);
         }
      }
      
      override protected function Removed(param1:Event) : void
      {
         super.Removed(param1);
         if(this.realBodyPart != null)
         {
            if(getChildByName(this.realBodyPart.name))
            {
               removeChild(this.realBodyPart);
            }
            this.realBodyPart = null;
         }
      }
      
      function beginDrag(param1:MouseEvent) : void
      {
         this.deviation = new Point(this.mouseX,this.mouseY);
         dispatchEvent(new InfoDialogEvent(InfoDialogEvent.BEGIN_DRAG));
         addListenerOf(stage,MouseEvent.MOUSE_MOVE,this.moveDialog);
         addListenerOf(stage,MouseEvent.MOUSE_UP,this.endDrag);
      }
      
      function moveDialog(param1:MouseEvent) : void
      {
         var _loc2_:* = this.parent;
         this.x = Math.min(Math.max(_loc2_.mouseX - this.deviation.x,this.width / 2),700 - this.width / 2);
         this.y = Math.min(Math.max(_loc2_.mouseY - this.deviation.y,0),500 - this.height);
      }
      
      function endDrag(param1:MouseEvent) : void
      {
         dispatchEvent(new InfoDialogEvent(InfoDialogEvent.END_DRAG));
         removeListenerOf(stage,MouseEvent.MOUSE_MOVE,this.moveDialog);
         removeListenerOf(stage,MouseEvent.MOUSE_UP,this.endDrag);
      }
      
      public function set relation(param1:*) : void
      {
         this._relation = param1;
      }
      
      public function get relation() : *
      {
         return this._relation;
      }
   }
}
