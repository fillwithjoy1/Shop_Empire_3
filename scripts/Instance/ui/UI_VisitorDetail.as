package Instance.ui
{
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.gameplay.Visitor;
   import Instance.gameplay.World;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class UI_VisitorDetail extends UI_InfoPanel
   {
       
      
      public var prevPage:SimpleButton;
      
      public var nextPage:SimpleButton;
      
      public var chatBox2:MovieClip;
      
      public var box1:VisitorBox;
      
      public var chatBox3:MovieClip;
      
      public var box2:VisitorBox;
      
      public var pageInfo:TextField;
      
      public var chatBox0:MovieClip;
      
      public var box3:VisitorBox;
      
      public var chatBox1:MovieClip;
      
      public var box4:VisitorBox;
      
      public var deactiveTab0:MovieClip;
      
      public var box5:VisitorBox;
      
      public var deactiveTab1:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var deactiveTab2:MovieClip;
      
      public var activateTab:MovieClip;
      
      public var chatBox4:MovieClip;
      
      public var chatBox5:MovieClip;
      
      public var box0:VisitorBox;
      
      const FRAME_JOB = ["normal","special","villain"];
      
      var boxList:Array;
      
      var chatBoxList:Array;
      
      var _world:World;
      
      var _page:int;
      
      var _hasUpdate:Boolean;
      
      var _delayForUpdate:int;
      
      public function UI_VisitorDetail()
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         super();
         this.boxList = new Array();
         this.chatBoxList = new Array();
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.letterSpacing = -1;
         var _loc2_:* = 0;
         while(getChildByName("box" + _loc2_))
         {
            _loc3_ = getChildByName("box" + _loc2_);
            _loc4_ = getChildByName("chatBox" + _loc2_);
            _loc3_.mouseChildren = false;
            _loc3_.buttonMode = true;
            this.boxList.push(_loc3_);
            _loc4_.commentInfo.defaultTextFormat = _loc1_;
            this.chatBoxList.push(_loc4_);
            _loc2_++;
         }
         this._delayForUpdate = 0;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         var _loc3_:* = undefined;
         super.Initialize(param1);
         if(this._world != null)
         {
            addListenerOf(this._world,GameEvent.HUMAN_ADDED,this.whenHumanUpdated);
            addListenerOf(this._world,HumanEvent.EXILE,this.whenHumanUpdated);
         }
         var _loc2_:* = 0;
         while(_loc2_ < this.boxList.length)
         {
            _loc3_ = this.boxList[_loc2_];
            addListenerOf(_loc3_,MouseEvent.CLICK,this.boxOnClick);
            _loc2_++;
         }
         addListenerOf(this,Event.ENTER_FRAME,this.delayUpdate);
         addListenerOf(this.prevPage,MouseEvent.CLICK,this.changePage);
         addListenerOf(this.nextPage,MouseEvent.CLICK,this.changePage);
      }
      
      function boxOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.related != null)
         {
            _loc2_.related.dispatchEvent(new CommandEvent(CommandEvent.HUMAN_ON_SELECT));
         }
      }
      
      function changePage(param1:MouseEvent) : void
      {
         var _loc2_:* = this.FRAME_JOB[_activeTab];
         var _loc3_:Array = this.getShownVisitor(_loc2_);
         var _loc4_:* = Math.max(1,Math.ceil(_loc3_.length / this.boxList.length));
         var _loc5_:*;
         if((_loc5_ = param1.currentTarget) == this.prevPage)
         {
            --this._page;
            if(this._page < 0)
            {
               this._page = _loc4_ - 1;
            }
         }
         else if(_loc5_ == this.nextPage)
         {
            ++this._page;
            if(this._page >= _loc4_)
            {
               this._page = 0;
            }
         }
         this.checkActiveTab();
      }
      
      function delayUpdate(param1:Event) : void
      {
         if(this._delayForUpdate > 0)
         {
            --this._delayForUpdate;
         }
         else if(this._hasUpdate)
         {
            this.checkActiveTab();
         }
         this.writeComment();
      }
      
      function writeComment() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this.boxList.length)
         {
            if(this.boxList[_loc1_].visible)
            {
               _loc2_ = this.boxList[_loc1_].related;
               if(_loc2_ is Visitor)
               {
                  _loc3_ = this.chatBoxList[_loc1_];
                  _loc4_ = (_loc4_ = _loc2_.chatComment).replace(/\n/g," ");
                  this.chatBoxList[_loc1_].commentInfo.text = _loc4_;
               }
            }
            _loc1_++;
         }
      }
      
      function whenHumanUpdated(param1:Event) : void
      {
         this._hasUpdate = true;
      }
      
      function getShownVisitor(param1:*) : Array
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:* = new Array();
         if(param1 == "normal")
         {
            _loc2_ = this._world.currentVisitorList.concat();
            _loc3_ = 0;
            while(_loc3_ < this._world.specialVisitorList.length)
            {
               _loc4_ = this._world.specialVisitorList[_loc3_];
               if((_loc5_ = _loc2_.indexOf(_loc4_)) in _loc2_)
               {
                  _loc2_.splice(_loc5_,1);
               }
               _loc3_++;
            }
         }
         else if(param1 == "special")
         {
            _loc3_ = 0;
            while(_loc3_ < this._world.currentVisitorList.length)
            {
               _loc6_ = this._world.currentVisitorList[_loc3_];
               if((_loc5_ = this._world.specialVisitorList.indexOf(_loc6_)) in this._world.specialVisitorList)
               {
                  _loc2_.push(_loc6_);
               }
               _loc3_++;
            }
         }
         else if(param1 == "villain")
         {
            _loc3_ = 0;
            while(_loc3_ < this._world.humanList.length)
            {
               _loc7_ = this._world.humanList[_loc3_];
               _loc8_ = this._world.litterList.indexOf(_loc7_);
               _loc9_ = this._world.wizardList.indexOf(_loc7_);
               if(_loc8_ in this._world.litterList || _loc9_ in this._world.wizardList)
               {
                  _loc2_.push(_loc7_);
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      override function checkActiveTab() : void
      {
         var _loc6_:* = undefined;
         super.checkActiveTab();
         var _loc1_:* = this.FRAME_JOB[_activeTab];
         var _loc2_:Array = this.getShownVisitor(_loc1_);
         var _loc3_:* = Math.max(1,Math.ceil(_loc2_.length / this.boxList.length));
         if(this._page >= _loc3_)
         {
            this._page = _loc3_ - 1;
         }
         this.pageInfo.text = "" + (this._page + 1) + "/" + _loc3_;
         var _loc4_:* = this._page * this.boxList.length;
         var _loc5_:* = 0;
         while(_loc5_ < this.boxList.length)
         {
            this.boxList[_loc5_].visible = _loc4_ + _loc5_ in _loc2_;
            if(this.boxList[_loc5_].visible)
            {
               this.boxList[_loc5_].related = _loc2_[_loc4_ + _loc5_];
            }
            if(this.boxList[_loc5_].visible)
            {
               if(this.boxList[_loc5_].related is Visitor)
               {
                  this.chatBoxList[_loc5_].visible = true;
                  _loc6_ = (_loc6_ = this.boxList[_loc5_].related.chatComment).replace(/\n/g," ");
                  this.chatBoxList[_loc5_].commentInfo.text = _loc6_;
               }
               else
               {
                  this.chatBoxList[_loc5_].visible = false;
               }
            }
            else
            {
               this.chatBoxList[_loc5_].visible = false;
            }
            _loc5_++;
         }
         this._hasUpdate = false;
         this._delayForUpdate = 5;
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
   }
}
