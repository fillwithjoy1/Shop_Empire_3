package Instance.progress
{
   import Instance.events.ComboEvent;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.modules.Utility;
   import Instance.property.HumanStat;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class StaffHireProgress extends BuildProgress
   {
       
      
      var workTimeList;
      
      var _stat:HumanStat;
      
      var _job:String;
      
      var _workTime:Object;
      
      var _workTimeIndex:int;
      
      public function StaffHireProgress()
      {
         this.workTimeList = [{
            "start":9,
            "end":19
         },{
            "start":19,
            "end":5
         },{
            "start":9,
            "end":5
         }];
         super();
      }
      
      override public function runProgress() : void
      {
         buildSymbol = new ToHireSymbol();
         buildSymbol.gotoAndStop(this._job.toLowerCase());
         buildSymbol.alpha = 0.6;
         this.setBuildSymbolPosition();
         _world.addChild(buildSymbol);
         _world.dispatchEvent(new GameEvent(GameEvent.RUN_BUILD_PROGRESS,this));
         _world.addListenerOf(_world.stage,CommandEvent.SHOW_HIRE_PANEL,this.changeJobPanel);
         _world.addListenerOf(buildSymbol,Event.ENTER_FRAME,UpdatePosition);
         _world.addListenerOf(_world,MouseEvent.CLICK,this.confirmBuild);
      }
      
      override public function stopProgress() : void
      {
         super.stopProgress();
         _world.removeListenerOf(_world.stage,CommandEvent.SHOW_HIRE_PANEL,this.changeJobPanel);
      }
      
      function changeJobPanel(param1:CommandEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = param1.tag;
         this._job = _loc2_.jobdesk;
         buildSymbol.gotoAndStop(this._job.toLowerCase());
         if(this._stat != null)
         {
            _loc3_ = this._stat.stamina + this._stat.hygine + this._stat.entertain + this._stat.sight + this._stat.speed;
            switch(this._job)
            {
               case "janitor":
                  _loc3_ += this._stat.stamina * 0.4;
                  _loc3_ += this._stat.hygine * 1;
                  _loc3_ += this._stat.entertain * 0;
                  _loc3_ += this._stat.sight * 0.3;
                  _loc3_ += this._stat.speed * 0.5;
                  break;
               case "handyman":
                  _loc3_ += this._stat.stamina * 1.2;
                  _loc3_ += this._stat.hygine * 0;
                  _loc3_ += this._stat.entertain * 0;
                  _loc3_ += this._stat.sight * 0.3;
                  _loc3_ += this._stat.speed * 0.5;
                  break;
               case "entertainer":
                  _loc3_ += this._stat.stamina * 0.2;
                  _loc3_ += this._stat.hygine * 0;
                  _loc3_ += this._stat.entertain * 1.2;
                  _loc3_ += this._stat.sight * 0.1;
                  _loc3_ += this._stat.speed * 0.2;
                  break;
               case "guard":
                  _loc3_ += this._stat.stamina * 0.6;
                  _loc3_ += this._stat.hygine * 0;
                  _loc3_ += this._stat.entertain * 0;
                  _loc3_ += this._stat.sight * 0.8;
                  _loc3_ += this._stat.speed * 1;
            }
            _loc4_ = _loc3_ + _loc3_ * this._stat.hireCostDifference;
            _cost = Math.round(_loc4_);
         }
         this.updateToBuildInfo();
      }
      
      override function setBuildSymbolPosition() : void
      {
         var _loc5_:* = undefined;
         var _loc1_:* = _world.mainContainer.globalToLocal(new Point(_world.stage.mouseX,_world.stage.mouseY));
         var _loc2_:* = new Point();
         _loc2_.x = Math.round((_loc1_.x - buildSymbol.width / 2) / 12) * 12 + buildSymbol.width / 2;
         _loc2_.y = 0;
         var _loc3_:* = 0;
         while(_loc3_ < _world.floorList.length - 1)
         {
            if((_loc5_ = _world.floorList[_loc3_]).y >= _loc1_.y)
            {
               if(_loc2_.x >= _loc5_.left && _loc2_.x <= _loc5_.right)
               {
                  _loc2_.y = Math.min(_loc2_.y,_loc5_.y);
               }
            }
            _loc3_++;
         }
         var _loc4_:* = _world.globalToLocal(_world.mainContainer.localToGlobal(_loc2_));
         buildSymbol.x = _loc4_.x;
         buildSymbol.y = _loc4_.y;
      }
      
      override function updateToBuildInfo() : void
      {
         if(_infoToBuild != null)
         {
            _infoToBuild.hireJobDesk.text = "" + this._job.substr(0,1).toUpperCase() + this._job.substr(1).toLowerCase() + "";
            _infoToBuild.staffIcon.gotoAndStop("staff - " + this._job);
            _infoToBuild.toHire = this;
            _infoToBuild.workTimeCombo.text = _infoToBuild.workTimeCombo.comboItem[this._workTimeIndex];
            _infoToBuild.hireCost.text = "HIRE: " + Utility.numberToMoney(_cost) + " G";
            _infoToBuild.addListenerOf(_infoToBuild.workTimeCombo,ComboEvent.ON_CHANGE,this.changeWorkTime);
         }
      }
      
      function changeWorkTime(param1:ComboEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = _loc2_.comboItem.indexOf(_loc2_.text);
         this.workTimeIndex = _loc3_;
      }
      
      override function updateBuildComboInfo() : void
      {
      }
      
      override function confirmBuild(param1:MouseEvent) : void
      {
         var _loc2_:* = undefined;
         if(_world.main.isEnough(_cost))
         {
            _loc2_ = _world.mainContainer.globalToLocal(buildSymbol.localToGlobal(new Point(0,0)));
            _coordinate = _loc2_;
            _flipped = buildSymbol.scaleX;
            _enableToBuild = true;
            world.dispatchEvent(new CommandEvent(CommandEvent.DECIDE_HIRE,this));
         }
         else
         {
            _world.dispatchEvent(new GameEvent(GameEvent.SHOW_NOTIFICATION,"Not Enough Cash"));
         }
      }
      
      override public function flipBuilding() : void
      {
         buildSymbol.scaleX *= -1;
      }
      
      public function set job(param1:String) : void
      {
         this._job = param1;
      }
      
      public function get job() : String
      {
         return this._job;
      }
      
      public function set stat(param1:HumanStat) : void
      {
         this._stat = param1;
      }
      
      public function get stat() : HumanStat
      {
         return this._stat;
      }
      
      public function set workTimeIndex(param1:int) : void
      {
         var _loc2_:* = undefined;
         this._workTimeIndex = param1;
         if(this._workTimeIndex in this.workTimeList)
         {
            _loc2_ = this.workTimeList[this._workTimeIndex];
            this._workTime = _loc2_;
         }
      }
      
      public function get workTimeIndex() : int
      {
         return this._workTimeIndex;
      }
      
      public function get workTime() : Object
      {
         return this._workTime;
      }
   }
}
