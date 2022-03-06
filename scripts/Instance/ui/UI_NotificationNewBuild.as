package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.constant.BuildingData;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import greensock.TweenLite;
   
   public class UI_NotificationNewBuild extends SEMovieClip
   {
       
      
      public var buildInfo2:TextField;
      
      public var icon0:MovieClip;
      
      public var buildInfo1:TextField;
      
      public var icon1:MovieClip;
      
      public var icon2:MovieClip;
      
      public var buildInfo0:TextField;
      
      public var btnClose:SimpleButton;
      
      public var bodyPartBottomLeft:MovieClip;
      
      public var bodyPartBottomRight:MovieClip;
      
      public var bodyPartCenter:MovieClip;
      
      public var bodyPartBottomCenter:MovieClip;
      
      public var bodyPartRight:MovieClip;
      
      public var bodyPartLeft:MovieClip;
      
      var vanishCtr:int;
      
      var _toShown:Array;
      
      var _iconList:Array;
      
      var _infoList:Array;
      
      public function UI_NotificationNewBuild()
      {
         super();
         this._toShown = new Array();
         this._iconList = new Array();
         this._iconList.push(this.icon0);
         this._iconList.push(this.icon1);
         this._iconList.push(this.icon2);
         this._infoList = new Array();
         this._infoList.push(this.buildInfo0);
         this._infoList.push(this.buildInfo1);
         this._infoList.push(this.buildInfo2);
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.setShown();
         this.vanishCtr = 24 * 5;
         addListenerOf(this.btnClose,MouseEvent.CLICK,this.btnCloseOnClick);
         addListenerOf(this,Event.ENTER_FRAME,this.countdownToVanish);
      }
      
      function setShown() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this._iconList.length)
         {
            if(_loc1_ in this._toShown)
            {
               this._iconList[_loc1_].visible = true;
               this._iconList[_loc1_].gotoAndStop(BuildingData.getIconOf(this._toShown[_loc1_]));
               if(_loc1_ in this._infoList)
               {
                  this._infoList[_loc1_].visible = true;
                  this._infoList[_loc1_].text = this._toShown[_loc1_];
               }
            }
            else
            {
               this._iconList[_loc1_].visible = false;
               if(_loc1_ in this._infoList)
               {
                  this._infoList[_loc1_].visible = false;
               }
            }
            _loc1_++;
         }
      }
      
      function countdownToVanish(param1:Event) : void
      {
         if(this.vanishCtr > 0)
         {
            --this.vanishCtr;
         }
         else
         {
            this.vanish();
         }
      }
      
      function btnCloseOnClick(param1:MouseEvent) : void
      {
         this.vanish();
      }
      
      function vanish() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
         removeListenerOf(this.btnClose,MouseEvent.CLICK,this.btnCloseOnClick);
         removeListenerOf(this,Event.ENTER_FRAME,this.countdownToVanish);
         TweenLite.to(this,0.4,{
            "scaleX":0,
            "scaleY":0,
            "alpha":0,
            "onComplete":this.removeMe
         });
      }
      
      function removeMe() : void
      {
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get toShown() : Array
      {
         return this._toShown;
      }
   }
}
