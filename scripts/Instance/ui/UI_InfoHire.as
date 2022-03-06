package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.CommandEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class UI_InfoHire extends SEMovieClip
   {
       
      
      public var statSymbolEntertain:MovieClip;
      
      public var statSymbolStamina:MovieClip;
      
      public var statSymbolHygine:MovieClip;
      
      public var statSymbolSpeed:MovieClip;
      
      public var speedBar:MovieClip;
      
      public var btnClose:SimpleButton;
      
      public var statSymbolSight:MovieClip;
      
      public var sightBar:MovieClip;
      
      public var staminaBar:MovieClip;
      
      public var staffIcon:MovieClip;
      
      public var workTimeCombo:WorkTimeCombobox;
      
      public var staffName:TextField;
      
      public var hireJobDesk:TextField;
      
      public var entertainBar:MovieClip;
      
      public var hireCost:TextField;
      
      public var hygineBar:MovieClip;
      
      var _toHire;
      
      var _statSymbolList:Array;
      
      public function UI_InfoHire()
      {
         super();
         this.workTimeCombo.addItem("Day");
         this.workTimeCombo.addItem("Night");
         this.workTimeCombo.addItem("Day & Night");
         this._statSymbolList = new Array();
         this._statSymbolList.push(this.statSymbolStamina);
         this._statSymbolList.push(this.statSymbolHygine);
         this._statSymbolList.push(this.statSymbolEntertain);
         this._statSymbolList.push(this.statSymbolSight);
         this._statSymbolList.push(this.statSymbolSpeed);
         var _loc1_:* = 0;
         while(_loc1_ < this._statSymbolList.length)
         {
            this._statSymbolList[_loc1_].gotoAndStop(_loc1_ + 1);
            _loc1_++;
         }
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this.btnClose,MouseEvent.CLICK,this.cancelBuild);
         this.updateStatView();
      }
      
      function updateStatView() : void
      {
         var _loc1_:* = undefined;
         if(this._toHire != null)
         {
            _loc1_ = this._toHire.stat;
            if(_loc1_ != null)
            {
               this.staminaBar.maskBar.scaleX = _loc1_.stamina / 100;
               this.hygineBar.maskBar.scaleX = _loc1_.hygine / 100;
               this.entertainBar.maskBar.scaleX = _loc1_.entertain / 100;
               this.sightBar.maskBar.scaleX = _loc1_.sight / 100;
               this.speedBar.maskBar.scaleX = _loc1_.speed / 100;
               this.staffName.text = _loc1_.characterName;
            }
         }
      }
      
      function cancelBuild(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.CANCEL_BUILD));
      }
      
      function flipProgress(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            if(this._toHire != null)
            {
               this._toHire.flipBuilding();
            }
         }
      }
      
      public function set toHire(param1:*) : void
      {
         this._toHire = param1;
         this.updateStatView();
      }
      
      public function get toHire() : *
      {
         return this._toHire;
      }
   }
}
