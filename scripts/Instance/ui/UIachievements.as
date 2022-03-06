package Instance.ui
{
   import Instance.Gameplay;
   import Instance.SEMovieClip;
   import Instance.constant.AchievementList;
   import Instance.events.CommandEvent;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class UIachievements extends SEMovieClip
   {
       
      
      public var tempUR:UIAchievementsIcon;
      
      public var btnClose:SimpleButton;
      
      public var tempBL:UIAchievementsIcon;
      
      public var achievementInfo:MovieClip;
      
      public var tempUL:UIAchievementsIcon;
      
      var _main:Gameplay;
      
      var _iconList:Array;
      
      var wDifference:Number;
      
      var hDifference:Number;
      
      public function UIachievements()
      {
         var _loc4_:* = undefined;
         super();
         removeChild(this.tempUL);
         removeChild(this.tempUR);
         removeChild(this.tempBL);
         var _loc1_:* = this.tempUR.x - this.tempUL.x;
         var _loc2_:* = this.tempBL.y - this.tempUL.y;
         this._iconList = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < AchievementList.ACHIEVEMENT_NAME_LIST.length)
         {
            (_loc4_ = new UIAchievementsIcon()).x = this.tempUL.x + _loc1_ / 4 * (_loc3_ % 5);
            _loc4_.y = this.tempUL.y + _loc2_ / 3 * Math.floor(_loc3_ / 5);
            _loc4_.stop();
            addChild(_loc4_);
            this._iconList.push(_loc4_);
            _loc3_++;
         }
         this.achievementInfo.mouseEnabled = false;
         this.achievementInfo.mouseChildren = false;
         removeChild(this.achievementInfo);
         this.wDifference = 0;
         this.hDifference = 0;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this.btnClose,MouseEvent.CLICK,this.btnCloseOnClick);
         var _loc2_:* = 0;
         while(_loc2_ < this._iconList.length)
         {
            addListenerOf(this._iconList[_loc2_],MouseEvent.ROLL_OVER,this.showAchievementDetail);
            _loc2_++;
         }
         this.updateView();
         addListenerOf(this,Event.ENTER_FRAME,this.correctInfoPosition);
      }
      
      public function updateView() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._iconList.length)
         {
            if(_loc1_ in this._main.achievement)
            {
               _loc2_ = this._main.achievement[_loc1_];
               if(_loc2_.aquired)
               {
                  if(Utility.hasLabel(this._iconList[_loc1_],_loc2_.frameCheck))
                  {
                     this._iconList[_loc1_].gotoAndStop(_loc2_.frameCheck);
                  }
               }
            }
            _loc1_++;
         }
      }
      
      function correctInfoPosition(param1:Event) : void
      {
         if(mouseX < -64)
         {
            this.wDifference = 0;
         }
         else if(mouseX > 64)
         {
            this.wDifference = this.achievementInfo.width;
         }
         this.achievementInfo.x = this.mouseX - this.wDifference;
         if(mouseY < -32)
         {
            this.hDifference = 0;
         }
         else if(mouseY > 32)
         {
            this.hDifference = this.achievementInfo.height;
         }
         this.achievementInfo.y = this.mouseY - this.hDifference;
      }
      
      function showAchievementDetail(param1:MouseEvent) : void
      {
         if(getChildByName(this.achievementInfo.name) == null)
         {
            addChild(this.achievementInfo);
         }
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this._iconList.indexOf(_loc2_);
         if(_loc3_ in this._main.achievement)
         {
            this.achievementInfo.achievementTitle.text = this._main.achievement[_loc3_].codeName.toUpperCase();
            this.achievementInfo.achievementNote.text = this._main.achievement[_loc3_].description;
         }
         addListenerOf(param1.target,MouseEvent.ROLL_OUT,this.hideAchievementDetail);
      }
      
      function hideAchievementDetail(param1:MouseEvent) : void
      {
         if(getChildByName(this.achievementInfo.name))
         {
            removeChild(this.achievementInfo);
         }
         removeListenerOf(param1.target,MouseEvent.ROLL_OUT,this.hideAchievementDetail);
      }
      
      function btnCloseOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.RESUME_GAME));
      }
      
      public function set main(param1:Gameplay) : void
      {
         this._main = param1;
      }
      
      public function get main() : Gameplay
      {
         return this._main;
      }
   }
}
