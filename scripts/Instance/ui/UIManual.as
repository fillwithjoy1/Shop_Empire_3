package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.constant.BuildingData;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.SliderBarEvent;
   import Instance.gameplay.World;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class UIManual extends SEMovieClip
   {
       
      
      public var HeaderTitle:TextField;
      
      public var btnClose:SimpleButton;
      
      public var combinationList:MovieClip;
      
      public var specialVisitorInfo:MovieClip;
      
      public var dialogBoxInfo:MovieClip;
      
      var _world:World;
      
      var _iconList:Array;
      
      var _spVisitorList:Array;
      
      var _goodTierList:Array;
      
      var _badTierList:Array;
      
      public function UIManual()
      {
         super();
         this.specialVisitorInfo.removeChild(this.specialVisitorInfo.leftPos);
         this.specialVisitorInfo.removeChild(this.specialVisitorInfo.rightPos);
         this.specialVisitorInfo.removeChild(this.specialVisitorInfo.bottomPos);
         this.combinationList.goodThumb.gotoAndStop("good");
         this.combinationList.badThumb.gotoAndStop("bad");
         this._iconList = new Array();
         this._spVisitorList = new Array();
         this._goodTierList = new Array();
         this._badTierList = new Array();
         this.dialogBoxInfo.visible = true;
         this.specialVisitorInfo.visible = false;
         this.combinationList.visible = false;
         this.HeaderTitle.text = "DIALOG BOX INFORMATION";
         this.combinationList.shownTier.removeChild(this.combinationList.shownTier.upperPos);
         this.combinationList.shownTier.removeChild(this.combinationList.shownTier.lowerPos);
         this.combinationList.shownTier.removeChild(this.combinationList.shownTier.badPos);
         this.combinationList.scrollBar.slideMode = this.combinationList.scrollBar.VERTICAL;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this.btnClose,MouseEvent.CLICK,this.btnCloseOnClick);
         addListenerOf(this.dialogBoxInfo.toSpecialVisitorList,MouseEvent.CLICK,this.openSpecialVisitorPage);
         addListenerOf(this.dialogBoxInfo.toCombinationList,MouseEvent.CLICK,this.openCombinationListPage);
         addListenerOf(this.specialVisitorInfo.toDialogInformation,MouseEvent.CLICK,this.openDialogInfoPage);
         addListenerOf(this.specialVisitorInfo.toCombinationList,MouseEvent.CLICK,this.openCombinationListPage);
         addListenerOf(this.combinationList.toDialogInformation,MouseEvent.CLICK,this.openDialogInfoPage);
         addListenerOf(this.combinationList.toSpecialVisitorList,MouseEvent.CLICK,this.openSpecialVisitorPage);
         addListenerOf(this.combinationList.scrollBar,SliderBarEvent.CHANGE_POSITION,this.scrollCombination);
         addListenerOf(this._world,GameEvent.HUMAN_ADDED,this.whenSomebodyComing);
         addListenerOf(this._world,GameEvent.UNLOCK_NEW_BUILDING,this.whenBuildingUnlocked);
         this.checkSpecialVisitor();
         this.checkCombination();
      }
      
      function checkCombination() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._world.combination.good.length)
         {
            if(_loc1_ in this._goodTierList)
            {
               _loc2_ = this._world.combination.good[_loc1_];
               _loc3_ = this._goodTierList[_loc1_];
               if(_loc2_.unlocked)
               {
                  _loc3_.icon0.gotoAndStop(BuildingData.getIconOf(this._world.combination.good[_loc1_].tier1));
                  _loc3_.icon1.gotoAndStop(BuildingData.getIconOf(this._world.combination.good[_loc1_].tier2));
                  _loc3_.combinationDesc.text = "" + this._world.combination.good[_loc1_].tier1 + " + " + this._world.combination.good[_loc1_].tier2 + "";
               }
               else
               {
                  _loc3_.icon0.gotoAndStop("locked");
                  _loc3_.icon1.gotoAndStop("locked");
                  _loc3_.combinationDesc.text = "????? + ?????";
               }
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this._world.combination.bad.length)
         {
            if(_loc1_ in this._badTierList)
            {
               _loc2_ = this._world.combination.bad[_loc1_];
               _loc3_ = this._badTierList[_loc1_];
               if(_loc2_.unlocked)
               {
                  _loc3_.icon0.gotoAndStop(BuildingData.getIconOf(this._world.combination.bad[_loc1_].tier1));
                  _loc3_.icon1.gotoAndStop(BuildingData.getIconOf(this._world.combination.bad[_loc1_].tier2));
                  _loc3_.combinationDesc.text = "" + this._world.combination.bad[_loc1_].tier1 + " + " + this._world.combination.bad[_loc1_].tier2 + "";
               }
               else
               {
                  _loc3_.icon0.gotoAndStop("locked");
                  _loc3_.icon1.gotoAndStop("locked");
                  _loc3_.combinationDesc.text = "????? + ?????";
               }
            }
            _loc1_++;
         }
      }
      
      function scrollCombination(param1:SliderBarEvent) : void
      {
         var diff:* = undefined;
         var e:SliderBarEvent = param1;
         var target:* = e.currentTarget;
         with(this.combinationList)
         {
            if(shownTier.height > 235)
            {
               var diff:* = shownTier.height - 235;
               shownTier.y = 29 - diff * target.getPosition();
            }
         }
      }
      
      function whenSomebodyComing(param1:GameEvent) : void
      {
         var _loc2_:* = param1.target;
         var _loc3_:* = this._spVisitorList.indexOf(_loc2_);
         if(_loc3_ in this._iconList)
         {
            this.writeSpecialVisitor(_loc3_);
         }
      }
      
      function whenBuildingUnlocked(param1:GameEvent) : void
      {
         this.checkSpecialVisitor();
      }
      
      function openDialogInfoPage(param1:MouseEvent) : void
      {
         this.dialogBoxInfo.visible = true;
         this.specialVisitorInfo.visible = false;
         this.combinationList.visible = false;
         this.HeaderTitle.text = "DIALOG BOX INFORMATION";
      }
      
      function openSpecialVisitorPage(param1:MouseEvent) : void
      {
         this.dialogBoxInfo.visible = false;
         this.specialVisitorInfo.visible = true;
         this.combinationList.visible = false;
         this.HeaderTitle.text = "SPECIAL VISITOR LIST";
      }
      
      function openCombinationListPage(param1:MouseEvent) : void
      {
         this.dialogBoxInfo.visible = false;
         this.specialVisitorInfo.visible = false;
         this.combinationList.visible = true;
         this.HeaderTitle.text = "COMBINATION LIST";
      }
      
      function checkSpecialVisitor() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this._spVisitorList.length)
         {
            this.writeSpecialVisitor(_loc1_);
            _loc1_++;
         }
      }
      
      function writeSpecialVisitor(param1:*) : void
      {
         var _loc2_:* = this._spVisitorList[param1];
         if(param1 in this._iconList)
         {
            this._iconList[param1].questionMark.visible = !_loc2_.hasCome;
            if(_loc2_.hasCome)
            {
               this._iconList[param1].humanIcon.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
               this._iconList[param1].specialName.text = _loc2_.stat.characterName;
            }
            else
            {
               this._iconList[param1].humanIcon.transform.colorTransform = new ColorTransform(0,0,0,1,0,0,0,0);
               this._iconList[param1].specialName.text = "?????";
            }
            this._iconList[param1].favorite.text = "Favorite: " + this.writeFavorite(_loc2_);
         }
      }
      
      function writeFavorite(param1:*) : String
      {
         var _loc5_:* = undefined;
         var _loc2_:* = null;
         var _loc3_:* = "";
         var _loc4_:* = 0;
         while(_loc4_ < param1.favoriteList.length)
         {
            if((_loc5_ = param1.favoriteList[_loc4_]) != "(none)")
            {
               if(_loc5_ != _loc2_)
               {
                  if(_loc3_.length > 0)
                  {
                     _loc3_ += ", ";
                  }
                  if(this._world.main.unlockedBuilding.indexOf(_loc5_) >= 0 || param1.hasCome)
                  {
                     _loc3_ += _loc5_;
                  }
                  else
                  {
                     _loc3_ += "?????";
                  }
                  _loc2_ = _loc5_;
               }
            }
            _loc4_++;
         }
         if(_loc3_.length == 0)
         {
            _loc3_ = "(none)";
         }
         return _loc3_;
      }
      
      function btnCloseOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.RESUME_GAME));
      }
      
      function sortByStatus(param1:Array, param2:String, param3:Boolean = false) : void
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc4_:* = 0;
         while(_loc4_ < param1.length - 1)
         {
            _loc5_ = _loc4_ + 1;
            while(_loc5_ < param1.length)
            {
               if(param2 in param1[_loc4_].stat && param2 in param1[_loc5_].stat)
               {
                  _loc6_ = param1[_loc4_].stat[param2];
                  _loc7_ = param1[_loc5_].stat[param2];
                  _loc8_ = false;
                  if(param3)
                  {
                     _loc8_ = _loc6_ < _loc7_;
                  }
                  else
                  {
                     _loc8_ = _loc6_ > _loc7_;
                  }
                  if(_loc8_)
                  {
                     _loc9_ = param1[_loc4_];
                     param1[_loc4_] = param1[_loc5_];
                     param1[_loc5_] = _loc9_;
                  }
               }
               _loc5_++;
            }
            _loc4_++;
         }
      }
      
      function setDefaultSpecialVisitor() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:TextFormat = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         while(this._iconList.length > 0)
         {
            _loc1_ = this._iconList.shift();
            _loc1_.parent.removeChild(_loc1_);
         }
         this._spVisitorList = new Array();
         if(this._world != null)
         {
            _loc2_ = new TextFormat();
            _loc2_.letterSpacing = -1;
            _loc3_ = this._world.specialVisitorList.concat();
            this.sortByStatus(_loc3_,"characterName");
            _loc4_ = this.specialVisitorInfo.rightPos.x - this.specialVisitorInfo.leftPos.x;
            _loc5_ = this.specialVisitorInfo.bottomPos.y - this.specialVisitorInfo.leftPos.y;
            _loc6_ = 0;
            while(_loc6_ < _loc3_.length)
            {
               (_loc7_ = new SpecialVisitorLegend()).x = this.specialVisitorInfo.leftPos.x + _loc4_ * (_loc6_ % 2);
               _loc7_.y = this.specialVisitorInfo.leftPos.y + _loc5_ / 4 * Math.floor(_loc6_ / 2);
               _loc7_.humanIcon.gotoAndStop(_loc3_[_loc6_].model);
               _loc7_.favorite.defaultTextFormat = _loc2_;
               this.specialVisitorInfo.addChild(_loc7_);
               this._iconList.push(_loc7_);
               _loc6_++;
            }
            this._spVisitorList = _loc3_;
         }
      }
      
      function generateCombination() : void
      {
         this.generateGoodCombination();
         this.generateBadCombination();
      }
      
      function generateGoodCombination() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:TextFormat = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         while(this._goodTierList.length > 0)
         {
            _loc1_ = this._goodTierList.shift();
            _loc1_.parent.removeChild(_loc1_);
         }
         if(this._world != null)
         {
            _loc2_ = new TextFormat();
            _loc2_.letterSpacing = -1;
            _loc3_ = this.combinationList.shownTier.lowerPos.y - this.combinationList.shownTier.upperPos.y;
            _loc4_ = 0;
            while(_loc4_ < this._world.combination.good.length)
            {
               (_loc5_ = new CommbinationTier()).x = this.combinationList.shownTier.upperPos.x;
               _loc5_.y = this.combinationList.shownTier.upperPos.y + _loc4_ * (_loc3_ / 12);
               _loc5_.combinationDesc.defaultTextFormat = _loc2_;
               _loc5_.icon0.gotoAndStop(BuildingData.getIconOf(this._world.combination.good[_loc4_].tier1));
               _loc5_.icon1.gotoAndStop(BuildingData.getIconOf(this._world.combination.good[_loc4_].tier2));
               _loc5_.combinationDesc.text = "" + this._world.combination.good[_loc4_].tier1 + " + " + this._world.combination.good[_loc4_].tier2 + "";
               this.combinationList.shownTier.addChild(_loc5_);
               this._goodTierList.push(_loc5_);
               _loc4_++;
            }
         }
      }
      
      function generateBadCombination() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:TextFormat = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         while(this._badTierList.length > 0)
         {
            _loc1_ = this._badTierList.shift();
            _loc1_.parent.removeChild(_loc1_);
         }
         if(this._world != null)
         {
            _loc2_ = new TextFormat();
            _loc2_.letterSpacing = -1;
            _loc3_ = this.combinationList.shownTier.lowerPos.y - this.combinationList.shownTier.upperPos.y;
            _loc4_ = 0;
            while(_loc4_ < this._world.combination.bad.length)
            {
               (_loc5_ = new CommbinationTier()).x = this.combinationList.shownTier.badPos.x;
               _loc5_.y = this.combinationList.shownTier.badPos.y + _loc4_ * (_loc3_ / 12);
               _loc5_.icon0.gotoAndStop(BuildingData.getIconOf(this._world.combination.bad[_loc4_].tier1));
               _loc5_.icon1.gotoAndStop(BuildingData.getIconOf(this._world.combination.bad[_loc4_].tier2));
               _loc5_.combinationDesc.defaultTextFormat = _loc2_;
               _loc5_.combinationDesc.text = "" + this._world.combination.bad[_loc4_].tier1 + " + " + this._world.combination.bad[_loc4_].tier2 + "";
               this.combinationList.shownTier.addChild(_loc5_);
               this._badTierList.push(_loc5_);
               _loc4_++;
            }
         }
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
         this.setDefaultSpecialVisitor();
         this.generateCombination();
      }
      
      public function get world() : World
      {
         return this._world;
      }
   }
}
