package Instance.ui
{
   import Instance.events.ToggleButtonEvent;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ToggleButton extends MovieClip
   {
       
      
      var _isActive:Boolean;
      
      var _group:Array;
      
      var _icon:String;
      
      public function ToggleButton()
      {
         super();
         this.buttonMode = true;
         this.tabChildren = false;
         this.tabEnabled = false;
         this._isActive = false;
         this._group = new Array();
         stop();
         addEventListener(Event.ADDED_TO_STAGE,this.Initialize);
         this.checkCurrentIcon();
      }
      
      function Initialize(param1:Event) : void
      {
         addEventListener(MouseEvent.CLICK,this.DoToggle);
         addEventListener(MouseEvent.ROLL_OVER,this.DoOver);
         addEventListener(MouseEvent.ROLL_OUT,this.DoOut);
         addEventListener(Event.REMOVED_FROM_STAGE,this.Removed);
         this.checkCurrentIcon();
      }
      
      function Removed(param1:Event) : void
      {
         removeEventListener(MouseEvent.CLICK,this.DoToggle);
         removeEventListener(MouseEvent.ROLL_OVER,this.DoOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.DoOut);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.Removed);
      }
      
      function DoToggle(param1:MouseEvent) : void
      {
         if(this.enabled)
         {
            this._isActive = !this._isActive;
            if(this._isActive)
            {
               if(this.totalFrames >= 4)
               {
                  gotoAndStop(4);
               }
               else
               {
                  gotoAndStop(2);
               }
               this.checkCurrentIcon();
               dispatchEvent(new ToggleButtonEvent(ToggleButtonEvent.ACTIVATE));
            }
            else
            {
               if(this.totalFrames >= 3)
               {
                  gotoAndStop(3);
               }
               else
               {
                  gotoAndStop(1);
               }
               this.checkCurrentIcon();
               dispatchEvent(new ToggleButtonEvent(ToggleButtonEvent.DEACTIVATE));
            }
         }
      }
      
      function checkCurrentIcon() : void
      {
         var _loc1_:* = undefined;
         if(numChildren > 0)
         {
            _loc1_ = getChildAt(0);
            if("icon" in _loc1_)
            {
               if(Utility.hasLabel(_loc1_.icon,this._icon))
               {
                  _loc1_.icon.visible = true;
                  _loc1_.icon.gotoAndStop(this._icon);
               }
               else
               {
                  _loc1_.icon.visible = false;
               }
            }
         }
      }
      
      function DoOver(param1:MouseEvent) : void
      {
         if(enabled)
         {
            if(!this._isActive)
            {
               if(this.totalFrames >= 3)
               {
                  if(this.currentFrame != 3)
                  {
                     gotoAndStop(3);
                  }
               }
            }
            else if(this.totalFrames >= 4)
            {
               if(this.currentFrame != 4)
               {
                  gotoAndStop(4);
               }
            }
            this.checkCurrentIcon();
         }
      }
      
      function DoOut(param1:MouseEvent) : void
      {
         if(enabled)
         {
            if(!this._isActive)
            {
               gotoAndStop(1);
            }
            else
            {
               gotoAndStop(2);
            }
            this.checkCurrentIcon();
         }
      }
      
      public function set isActive(param1:Boolean) : void
      {
         this._isActive = param1;
         if(this._isActive)
         {
            gotoAndStop(2);
            this.checkCurrentIcon();
            dispatchEvent(new ToggleButtonEvent(ToggleButtonEvent.FORCE_ACTIVATE));
         }
         else
         {
            gotoAndStop(1);
            this.checkCurrentIcon();
            dispatchEvent(new ToggleButtonEvent(ToggleButtonEvent.FORCE_DEACTIVATE));
         }
      }
      
      public function get isActive() : Boolean
      {
         return this._isActive;
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         buttonMode = super.enabled;
         mouseChildren = super.enabled;
      }
      
      public function set icon(param1:String) : void
      {
         this._icon = param1;
         this.checkCurrentIcon();
      }
      
      public function get icon() : String
      {
         return this._icon;
      }
   }
}
