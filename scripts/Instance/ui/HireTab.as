package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.CommandEvent;
   import Instance.modules.Utility;
   import Instance.property.HumanStat;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class HireTab extends SEMovieClip
   {
       
      
      public var hireCostInfo:TextField;
      
      public var statSymbolEntertain:MovieClip;
      
      public var statSymbolStamina:MovieClip;
      
      public var statSymbolHygine:MovieClip;
      
      public var staffSymbol:MovieClip;
      
      public var btnDecline:SimpleButton;
      
      public var statSymbolSpeed:MovieClip;
      
      public var speedBar:MovieClip;
      
      public var statSymbolSight:MovieClip;
      
      public var btnHire:SimpleButton;
      
      public var sightBar:MovieClip;
      
      public var staminaBar:MovieClip;
      
      public var workTimeCombo:WorkTimeCombobox;
      
      public var staffName:TextField;
      
      public var entertainBar:MovieClip;
      
      public var hygineBar:MovieClip;
      
      var _statData:HumanStat;
      
      var _statSymbolList:Array;
      
      var _hireCost:int;
      
      public function HireTab()
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
         addListenerOf(this.btnHire,MouseEvent.CLICK,this.btnHireOnClick);
         addListenerOf(this.btnDecline,MouseEvent.CLICK,this.btnDeclineOnClick);
         this.updateStatView();
      }
      
      function updateStatView() : void
      {
         if(this._statData != null)
         {
            this.staminaBar.maskBar.scaleX = this._statData.stamina / 100;
            this.hygineBar.maskBar.scaleX = this._statData.hygine / 100;
            this.entertainBar.maskBar.scaleX = this._statData.entertain / 100;
            this.sightBar.maskBar.scaleX = this._statData.sight / 100;
            this.speedBar.maskBar.scaleX = this._statData.speed / 100;
            this.staffName.text = this._statData.characterName;
         }
      }
      
      function btnHireOnClick(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            _loc3_ = this.workTimeCombo.comboItem.indexOf(this.workTimeCombo.text);
            dispatchEvent(new CommandEvent(CommandEvent.ON_HIRE,{
               "stat":this._statData,
               "workTimeIndex":_loc3_,
               "cost":this._hireCost
            }));
         }
      }
      
      function btnDeclineOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            dispatchEvent(new CommandEvent(CommandEvent.DECLINE_HIRE,this._statData));
         }
      }
      
      function updateHireCost() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this._statData != null)
         {
            _loc1_ = this._statData.stamina + this._statData.hygine + this._statData.entertain + this._statData.sight + this._statData.speed;
            switch(this.staffSymbol.currentFrameLabel)
            {
               case "janitor":
                  _loc1_ += this._statData.stamina * 0.4;
                  _loc1_ += this._statData.hygine * 1;
                  _loc1_ += this._statData.entertain * 0;
                  _loc1_ += this._statData.sight * 0.3;
                  _loc1_ += this._statData.speed * 0.5;
                  break;
               case "handyman":
                  _loc1_ += this._statData.stamina * 1.2;
                  _loc1_ += this._statData.hygine * 0;
                  _loc1_ += this._statData.entertain * 0;
                  _loc1_ += this._statData.sight * 0.3;
                  _loc1_ += this._statData.speed * 0.5;
                  break;
               case "entertainer":
                  _loc1_ += this._statData.stamina * 0.2;
                  _loc1_ += this._statData.hygine * 0;
                  _loc1_ += this._statData.entertain * 1.2;
                  _loc1_ += this._statData.sight * 0.1;
                  _loc1_ += this._statData.speed * 0.2;
                  break;
               case "guard":
                  _loc1_ += this._statData.stamina * 0.6;
                  _loc1_ += this._statData.hygine * 0;
                  _loc1_ += this._statData.entertain * 0;
                  _loc1_ += this._statData.sight * 0.8;
                  _loc1_ += this._statData.speed * 1;
            }
            _loc2_ = _loc1_ + _loc1_ * this._statData.hireCostDifference;
            this._hireCost = Math.round(_loc2_);
         }
         else
         {
            this._hireCost = 0;
         }
         this.hireCostInfo.text = "" + Utility.numberToMoney(this._hireCost) + " G";
      }
      
      public function set statData(param1:HumanStat) : void
      {
         this._statData = param1;
         this.updateHireCost();
         this.updateStatView();
      }
      
      public function get statData() : HumanStat
      {
         return this._statData;
      }
      
      public function get hireCost() : int
      {
         return this._hireCost;
      }
   }
}
