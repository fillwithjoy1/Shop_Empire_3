package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.gameplay.World;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import greensock.TweenLite;
   
   public class UI_ExtraUpgrade extends SEMovieClip
   {
       
      
      public var prevPage:SimpleButton;
      
      public var nextPage:SimpleButton;
      
      public var extra0:ExtraUpgradeBox;
      
      public var extra1:ExtraUpgradeBox;
      
      public var pageInfo:TextField;
      
      public var extra2:ExtraUpgradeBox;
      
      public var extra3:ExtraUpgradeBox;
      
      public var extra4:ExtraUpgradeBox;
      
      public var btnClose:SimpleButton;
      
      public var extra5:ExtraUpgradeBox;
      
      public var autoClose:CheckBox;
      
      var _world:World;
      
      var _page:int;
      
      var _extraTabList:Array;
      
      var _tempNewUnlocked:Array;
      
      public function UI_ExtraUpgrade()
      {
         super();
         this._extraTabList = new Array();
         this._extraTabList.push(this.extra0);
         this._extraTabList.push(this.extra1);
         this._extraTabList.push(this.extra2);
         this._extraTabList.push(this.extra3);
         this._extraTabList.push(this.extra4);
         this._extraTabList.push(this.extra5);
         this._page = 0;
         this.__setProp_autoClose_UIextraupgrades_Layer2_0();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc2_:* = undefined;
         super.Initialize(param1);
         if(this._world != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this._extraTabList.length)
            {
               this._extraTabList[_loc2_].world = this._world;
               this._extraTabList[_loc2_].newIndicator.visible = false;
               _loc2_++;
            }
         }
         this._tempNewUnlocked = this._world.main.newUnlockedUpgrade.concat();
         addListenerOf(this.btnClose,MouseEvent.CLICK,this.btnMouseOnClick);
         addListenerOf(this.nextPage,MouseEvent.CLICK,this.changePage);
         addListenerOf(this.prevPage,MouseEvent.CLICK,this.changePage);
         addListenerOf(stage,CommandEvent.CANCEL_BUILD,this.whenCanceled);
         this.updateTabIcon();
      }
      
      function whenCanceled(param1:CommandEvent) : void
      {
         visible = true;
         var _loc2_:* = param1.target;
         if(_loc2_ is UI_InfoBuild)
         {
            TweenLite.killTweensOf(this,true);
            TweenLite.to(this,0.4,{
               "scaleX":1,
               "scaleY":1,
               "alpha":1,
               "x":350,
               "y":250
            });
         }
      }
      
      public function changePage(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_ == this.nextPage)
         {
            ++this._page;
         }
         else if(_loc2_ == this.prevPage)
         {
            --this._page;
         }
         var _loc3_:* = this._world.extraUpgradeList.concat();
         this.checkUnlocked(_loc3_);
         var _loc4_:* = Math.max(0,Math.ceil(_loc3_.length / this._extraTabList.length) - 1);
         if(this._page < 0)
         {
            this._page = _loc4_;
         }
         if(this._page > _loc4_)
         {
            this._page = 0;
         }
         this.updateTabIcon();
      }
      
      public function checkUnlocked(param1:Array) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:Array = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            if(this._world.main.unlockedUpgrade.indexOf(_loc4_.code) < 0)
            {
               _loc2_.push(_loc4_);
            }
            _loc3_++;
         }
         while(_loc2_.length > 0)
         {
            _loc5_ = _loc2_.shift();
            if((_loc6_ = param1.indexOf(_loc5_)) in param1)
            {
               param1.splice(_loc6_,1);
            }
         }
      }
      
      public function updateTabIcon() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this.stage != null)
         {
            _loc1_ = this._world.extraUpgradeList.concat();
            this.checkUnlocked(_loc1_);
            _loc2_ = Math.max(0,Math.ceil(_loc1_.length / this._extraTabList.length) - 1);
            _loc3_ = this._page * this._extraTabList.length;
            _loc4_ = false;
            _loc5_ = 0;
            while(_loc5_ < this._extraTabList.length)
            {
               this._extraTabList[_loc5_].visible = _loc3_ + _loc5_ in _loc1_;
               if(this._extraTabList[_loc5_].visible)
               {
                  _loc6_ = _loc1_[_loc3_ + _loc5_];
                  this._extraTabList[_loc5_].upgradeRelation = _loc6_;
                  if(_loc6_.purchased)
                  {
                     this._extraTabList[_loc5_].newIndicator.visible = false;
                  }
                  else if(this._tempNewUnlocked.indexOf(_loc6_.code) < 0)
                  {
                     this._extraTabList[_loc5_].newIndicator.visible = false;
                  }
                  else
                  {
                     this._extraTabList[_loc5_].newIndicator.visible = true;
                  }
                  if((_loc7_ = this._world.main.newUnlockedUpgrade.indexOf(_loc6_.code)) in this._world.main.newUnlockedUpgrade)
                  {
                     this._world.main.newUnlockedUpgrade.splice(_loc7_,1);
                     if(!_loc4_)
                     {
                        _loc4_ = true;
                     }
                  }
               }
               _loc5_++;
            }
            if(_loc4_)
            {
               this._world.main.dispatchEvent(new GameEvent(GameEvent.UNLOCK_NEW_UPGRADE));
            }
            this.pageInfo.text = "" + (this._page + 1) + "/" + (_loc2_ + 1) + "";
         }
      }
      
      function btnMouseOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.PANEL_NEED_TO_CLOSE));
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      function __setProp_autoClose_UIextraupgrades_Layer2_0() : *
      {
         try
         {
            this.autoClose["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.autoClose.enabled = true;
         this.autoClose.isActive = true;
         try
         {
            this.autoClose["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
