package Instance.property
{
   import Instance.Gameplay;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.events.MissionEvent;
   import Instance.events.ToggleButtonEvent;
   import Instance.events.TutorialEvent;
   import Instance.ui.TutorialPanel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import greensock.TweenLite;
   
   public class Tutorial
   {
       
      
      public const RELATIVE_IS_ACTIVATED = "relativeIsActivated";
      
      public const RELATIVE_IS_CLICKED = "relativeIsClicked";
      
      public const BUILDING_CREATED = "buildingCreated";
      
      public const STAFF_HIRED = "staffHired";
      
      public const INTRODUCTION = "Introduction";
      
      public const INTRO_NOTE = " Hello my king. Welcome to the medieval era. Welcome to &blShop Empire 3%ft!!";
      
      public const SHOWING_BUILDING_LIST = "ShowingBuildingList";
      
      public const SHOW_BUILD_NOTE = "Let\'s &grbuild the first booth%ft. Click on one of these buttons.";
      
      public const BUILD_BOOTH = "BuildBooth";
      
      public const BUILD_BOOTH_NOTE = "Select a booth to build. &grHold the mouse cursor%ft on a button to view it\'s description.";
      
      public const BUILD_BOOTH_2 = "BuildBoothPart2";
      
      public const BUILD_BOOTH_NOTE_2 = "Put the booth on the upper floor";
      
      public const END_BUILD_BOOTH = "EndBuildBooth";
      
      public const END_BUILD_BOOTH_NOTE = "Remember, booths are the &grmain income%ft. More booths will generate &grmore income%ft";
      
      public const BUILD_ELEVATOR = "BuildElevator";
      
      public const BUILD_ELEVATOR_NOTE = "An elevator is needed to &blconnect the new floor%ft. Click the facility button.";
      
      public const BUILD_ELEVATOR_2 = "BuildElevator2";
      
      public const BUILD_ELEVATOR_NOTE_2 = "Click on this elevator button. And &grplace it%ft somewhere between both floors.";
      
      public const HIRE_PROGRESS = "HireProgress";
      
      public const HIRE_PROGRESS_NOTE = "You need &blstaff members%ft to run the mall properly. Click here to hire somebody.";
      
      public const HIRE_JANITOR = "HireJanitor";
      
      public const HIRE_JANITOR_NOTE = "Now click on this button to hire a &grjanitor%ft, it\'s also your &blcurrent quest%ft!";
      
      public const HIRE_JANITOR_2 = "HireJanitor2";
      
      public const HIRE_JANITOR_NOTE_2 = "Each member has &bldifferent stats%ft, choose wisely. Click this button to hire.";
      
      public const HIRE_JANITOR_3 = "HireJanitor3";
      
      public const HIRE_JANITOR_NOTE_3 = "Click somewhere to place the new staff member inside the mall.";
      
      public const END_HIRE_JANITOR = "EndHireJanitor";
      
      public const END_HIRE_JANITOR_NOTE = "This should get you going, good luck my king!";
      
      public var TUTOR_INTRO;
      
      public var TUTOR_SHOW_BUILD;
      
      public var TUTOR_BUILD_BOOTH;
      
      public var TUTOR_BUILD_BOOTH_2;
      
      public var TUTOR_END_BUILD_BOOTH;
      
      public var TUTOR_BUILD_ELEVATOR;
      
      public var TUTOR_BUILD_ELEVATOR_2;
      
      public var TUTOR_HIRE_PROGRESS;
      
      public var TUTOR_HIRE_JANITOR;
      
      public var TUTOR_HIRE_JANITOR_2;
      
      public var TUTOR_HIRE_JANITOR_3;
      
      public var TUTOR_END_HIRE_JANITOR;
      
      public const TUTORIAL_HEADER = [this.INTRODUCTION,this.SHOWING_BUILDING_LIST,this.BUILD_BOOTH,this.BUILD_BOOTH_2,this.END_BUILD_BOOTH,this.BUILD_ELEVATOR,this.BUILD_ELEVATOR_2,this.HIRE_PROGRESS,this.HIRE_JANITOR,this.HIRE_JANITOR_2,this.HIRE_JANITOR_3,this.END_HIRE_JANITOR];
      
      public const TUTORIAL_PROGRESS = [this.TUTOR_INTRO,this.TUTOR_SHOW_BUILD,this.TUTOR_BUILD_BOOTH,this.TUTOR_BUILD_BOOTH_2,this.TUTOR_END_BUILD_BOOTH,this.TUTOR_BUILD_ELEVATOR,this.TUTOR_BUILD_ELEVATOR_2,this.TUTOR_HIRE_PROGRESS,this.TUTOR_HIRE_JANITOR,this.TUTOR_HIRE_JANITOR_2,this.TUTOR_HIRE_JANITOR_3,this.TUTOR_END_HIRE_JANITOR];
      
      var _main:Gameplay;
      
      var _passed:Array;
      
      var _currentTutor;
      
      var _tutorialMode:Boolean;
      
      var _tutorialPanel;
      
      var _tutorArrow:Array;
      
      var _inCover:Array;
      
      var _inProgress:Boolean;
      
      var _checkListener:Array;
      
      var _tutorialOnQueue:Array;
      
      var myTween:TweenLite;
      
      public function Tutorial()
      {
         this.TUTOR_INTRO = {
            "tutorHeader":this.INTRODUCTION,
            "tutorNote":this.INTRO_NOTE,
            "tutorDelay":90,
            "tutorNext":this.SHOWING_BUILDING_LIST
         };
         this.TUTOR_SHOW_BUILD = {
            "tutorHeader":this.SHOWING_BUILDING_LIST,
            "tutorNote":this.SHOW_BUILD_NOTE,
            "tutorDelay":90,
            "skipWhen":this.RELATIVE_IS_ACTIVATED,
            "tutorNext":this.BUILD_BOOTH
         };
         this.TUTOR_BUILD_BOOTH = {
            "tutorHeader":this.BUILD_BOOTH,
            "tutorNote":this.BUILD_BOOTH_NOTE,
            "tutorDelay":90,
            "skipWhen":this.RELATIVE_IS_ACTIVATED,
            "tutorNext":this.BUILD_BOOTH_2
         };
         this.TUTOR_BUILD_BOOTH_2 = {
            "tutorHeader":this.BUILD_BOOTH_2,
            "tutorNote":this.BUILD_BOOTH_NOTE_2,
            "tutorDelay":90,
            "skipWhen":this.BUILDING_CREATED,
            "tutorNext":this.END_BUILD_BOOTH
         };
         this.TUTOR_END_BUILD_BOOTH = {
            "tutorHeader":this.END_BUILD_BOOTH,
            "tutorNote":this.END_BUILD_BOOTH_NOTE,
            "tutorDelay":90
         };
         this.TUTOR_BUILD_ELEVATOR = {
            "tutorHeader":this.BUILD_ELEVATOR,
            "tutorNote":this.BUILD_ELEVATOR_NOTE,
            "tutorDelay":90,
            "skipWhen":this.RELATIVE_IS_ACTIVATED,
            "tutorNext":this.BUILD_ELEVATOR_2
         };
         this.TUTOR_BUILD_ELEVATOR_2 = {
            "tutorHeader":this.BUILD_ELEVATOR_2,
            "tutorNote":this.BUILD_ELEVATOR_NOTE_2,
            "tutorDelay":90,
            "skipWhen":this.RELATIVE_IS_ACTIVATED
         };
         this.TUTOR_HIRE_PROGRESS = {
            "tutorHeader":this.HIRE_PROGRESS,
            "tutorNote":this.HIRE_PROGRESS_NOTE,
            "tutorDelay":90,
            "skipWhen":this.RELATIVE_IS_ACTIVATED,
            "tutorNext":this.HIRE_JANITOR
         };
         this.TUTOR_HIRE_JANITOR = {
            "tutorHeader":this.HIRE_JANITOR,
            "tutorNote":this.HIRE_JANITOR_NOTE,
            "tutorDelay":90,
            "skipWhen":this.RELATIVE_IS_ACTIVATED,
            "tutorNext":this.HIRE_JANITOR_2
         };
         this.TUTOR_HIRE_JANITOR_2 = {
            "tutorHeader":this.HIRE_JANITOR_2,
            "tutorNote":this.HIRE_JANITOR_NOTE_2,
            "tutorDelay":90,
            "skipWhen":this.RELATIVE_IS_CLICKED,
            "tutorNext":this.HIRE_JANITOR_3
         };
         this.TUTOR_HIRE_JANITOR_3 = {
            "tutorHeader":this.HIRE_JANITOR_3,
            "tutorNote":this.HIRE_JANITOR_NOTE_3,
            "tutorDelay":90,
            "skipWhen":this.STAFF_HIRED,
            "tutorNext":this.END_HIRE_JANITOR
         };
         this.TUTOR_END_HIRE_JANITOR = {
            "tutorHeader":this.END_HIRE_JANITOR,
            "tutorNote":this.END_HIRE_JANITOR_NOTE,
            "tutorDelay":90
         };
         super();
         this._passed = new Array();
         this._tutorArrow = new Array();
         this._inCover = new Array();
         this._checkListener = new Array();
         this._tutorialPanel = new TutorialPanel();
         this._inProgress = false;
         this._tutorialOnQueue = new Array();
      }
      
      public function runTutorial() : void
      {
         this.setRelative();
         this.checkTutorAvailable();
         this._main.addListenerOf(this._main,MissionEvent.MISSION_SET,this.whenNewMissionSet);
         this._main.addListenerOf(this._tutorialPanel,TutorialEvent.TUTORIAL_SKIP_ALL,this.skipCurrentTutor);
      }
      
      function skipCurrentTutor(param1:TutorialEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this._currentTutor != null)
         {
            this._inProgress = false;
            this._main.GUI.dispatchEvent(new CommandEvent(CommandEvent.SPEED_CHANGE,null));
            _loc2_ = this._currentTutor;
            while(_loc2_ != null)
            {
               if(_loc2_.replace != null)
               {
                  if(this._passed.indexOf(_loc2_.replace) < 0)
                  {
                     this._passed.push(_loc2_.replace);
                  }
               }
               if(this._passed.indexOf(_loc2_.tutorHeader) < 0)
               {
                  this._passed.push(_loc2_.tutorHeader);
               }
               if(_loc2_.tutorNext != null)
               {
                  _loc2_ = this.getTutorial(_loc2_.tutorNext);
               }
               else
               {
                  _loc2_ = null;
               }
            }
            this.removeAllArrow();
            if(this._main.getChildByName(this._tutorialPanel.name) != null)
            {
               this.myTween = TweenLite.to(this._tutorialPanel,0.4,{
                  "x":700 + this._tutorialPanel.width,
                  "onComplete":this._main.removeChild,
                  "onCompleteParams":[this._tutorialPanel]
               });
            }
            while(this._checkListener.length > 0)
            {
               _loc3_ = this._checkListener.shift();
               this._main.removeListenerOf(_loc3_.target,_loc3_.listener,this.gotoNextTutor);
            }
            this._currentTutor = null;
            this.checkAvailable();
            if(this._tutorialOnQueue.length > 0)
            {
               if(this._tutorialPanel.stage == null)
               {
                  this.showTutorial(this._tutorialOnQueue.shift(),true);
               }
               else
               {
                  this._main.addListenerOf(this._tutorialPanel,Event.REMOVED_FROM_STAGE,this.checkNextTutor);
               }
            }
         }
      }
      
      function whenNewMissionSet(param1:MissionEvent) : void
      {
         var _loc2_:* = undefined;
         if(this._main.mission.currentProgress in this._main.mission.MISSION_LIST)
         {
            _loc2_ = this._main.mission.MISSION_LIST[this._main.mission.currentProgress];
            switch(_loc2_.targetCheck)
            {
               case "elevatorList":
                  if(this._passed.indexOf(this.BUILD_ELEVATOR) < 0)
                  {
                     this.showTutorial(this.BUILD_ELEVATOR,true);
                  }
                  break;
               case "janitorList":
                  if(this._passed.indexOf(this.HIRE_PROGRESS) < 0)
                  {
                     this.showTutorial(this.HIRE_PROGRESS,true);
                  }
            }
         }
      }
      
      function setRelative() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.TUTOR_SHOW_BUILD.relative = [this._main.GUI.btnBooth,this._main.GUI.btnFood];
         this.TUTOR_SHOW_BUILD.arrowList = [{
            "posX":14,
            "posY":0,
            "angle":-67,
            "relative":this._main.GUI.btnBooth
         },{
            "posX":14,
            "posY":0,
            "angle":-67,
            "relative":this._main.GUI.btnFood
         }];
         var _loc1_:* = [this._main.GUI.generalStorePanel,this._main.GUI.foodCenterPanel];
         this.TUTOR_BUILD_BOOTH.relative = new Array();
         this.TUTOR_BUILD_BOOTH.arrowList = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = 0;
            while(_loc1_[_loc2_].getChildByName("btnPanel" + _loc3_))
            {
               if((_loc4_ = _loc1_[_loc2_].getChildByName("btnPanel" + _loc3_)).enabled)
               {
                  this.TUTOR_BUILD_BOOTH.relative.push(_loc4_);
                  this.TUTOR_BUILD_BOOTH.arrowList.push({
                     "posX":14,
                     "posY":0,
                     "angle":-113,
                     "relative":_loc4_
                  });
               }
               _loc3_++;
            }
            _loc2_++;
         }
         this.TUTOR_BUILD_ELEVATOR.relative = [this._main.GUI.btnFacility];
         this.TUTOR_BUILD_ELEVATOR.arrowList = [{
            "posX":14,
            "posY":0,
            "angle":-67,
            "relative":this._main.GUI.btnFacility
         }];
         this.TUTOR_BUILD_ELEVATOR_2.relative = new Array();
         this.TUTOR_BUILD_ELEVATOR_2.arrowList = new Array();
         _loc3_ = 0;
         while(this._main.GUI.facilityPanel.getChildByName("btnPanel" + _loc3_))
         {
            if((_loc4_ = this._main.GUI.facilityPanel.getChildByName("btnPanel" + _loc3_)).enabled && _loc4_.icon == "facility - elevator")
            {
               this.TUTOR_BUILD_ELEVATOR_2.relative.push(_loc4_);
               this.TUTOR_BUILD_ELEVATOR_2.arrowList.push({
                  "posX":14,
                  "posY":0,
                  "angle":-67,
                  "relative":_loc4_
               });
               break;
            }
            _loc3_++;
         }
         this.TUTOR_HIRE_PROGRESS.relative = [this._main.GUI.btnStaff];
         this.TUTOR_HIRE_PROGRESS.arrowList = [{
            "posX":14,
            "posY":0,
            "angle":-67,
            "relative":this._main.GUI.btnStaff
         }];
         this.TUTOR_HIRE_JANITOR.relative = new Array();
         this.TUTOR_HIRE_JANITOR.arrowList = new Array();
         _loc3_ = 0;
         while(this._main.GUI.staffPanel.getChildByName("btnPanel" + _loc3_))
         {
            if((_loc4_ = this._main.GUI.staffPanel.getChildByName("btnPanel" + _loc3_)).icon == "staff - janitor")
            {
               this.TUTOR_HIRE_JANITOR.relative.push(_loc4_);
               this.TUTOR_HIRE_JANITOR.arrowList.push({
                  "posX":14,
                  "posY":0,
                  "angle":-67,
                  "relative":_loc4_
               });
               break;
            }
            _loc3_++;
         }
         this.TUTOR_HIRE_JANITOR_2.relative = [this._main.GUI.hirePanel.hireTab0.btnHire];
         this.TUTOR_HIRE_JANITOR_2.arrowList = [{
            "posX":0,
            "posY":-10,
            "angle":-173,
            "relative":this._main.GUI.hirePanel.hireTab0.btnHire
         }];
      }
      
      function checkTutorAvailable() : void
      {
         if(this._passed.indexOf(this.INTRODUCTION) < 0)
         {
            this.showTutorial(this.INTRODUCTION,true);
         }
      }
      
      public function gotoNextTutor(param1:Event) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this._currentTutor != null)
         {
            _loc2_ = false;
            _loc3_ = param1;
            if(!_loc2_)
            {
               this.removeAllArrow();
               while(this._checkListener.length > 0)
               {
                  _loc4_ = this._checkListener.shift();
                  this._main.removeListenerOf(_loc4_.target,_loc4_.listener,this.gotoNextTutor);
               }
               this._main.removeListenerOf(param1.currentTarget,param1.type,this.gotoNextTutor);
               if(this._currentTutor.tutorNext == null)
               {
                  this._tutorialPanel.bubbleText.visible = false;
                  if(this._main.getChildByName(this._tutorialPanel.name) != null)
                  {
                     this.myTween = TweenLite.to(this._tutorialPanel,0.4,{
                        "x":700 + this._tutorialPanel.width,
                        "onComplete":this._main.removeChild,
                        "onCompleteParams":[this._tutorialPanel]
                     });
                  }
                  if(this._inProgress)
                  {
                     this._inProgress = false;
                     this._main.GUI.dispatchEvent(new CommandEvent(CommandEvent.SPEED_CHANGE,null));
                  }
                  this._currentTutor = null;
                  this.checkAvailable();
                  if(this._tutorialOnQueue.length > 0)
                  {
                     if(this._tutorialPanel.stage == null)
                     {
                        this.showTutorial(this._tutorialOnQueue.shift(),true);
                     }
                     else
                     {
                        this._main.addListenerOf(this._tutorialPanel,Event.REMOVED_FROM_STAGE,this.checkNextTutor);
                     }
                  }
               }
               else
               {
                  _loc5_ = this._currentTutor;
                  this._currentTutor = null;
                  this.showTutorial(_loc5_.tutorNext,true);
               }
            }
         }
         else
         {
            this._main.removeListenerOf(param1.currentTarget,param1.type,this.gotoNextTutor);
         }
      }
      
      function checkNextTutor(param1:Event) : void
      {
         this._main.removeListenerOf(this._tutorialPanel,Event.REMOVED_FROM_STAGE,this.checkNextTutor);
         this.myTween = TweenLite.to(this._tutorialPanel,0.2,{
            "onComplete":this.showTutorial,
            "onCompleteParams":[this._tutorialOnQueue.shift(),true]
         });
      }
      
      function showArrowList(param1:*) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(param1.arrowList != null)
         {
            _loc2_ = 0;
            while(_loc2_ < param1.arrowList.length)
            {
               _loc3_ = new Tutorial_Arrow();
               if(param1.arrowList[_loc2_].relative == null)
               {
                  _loc3_.x = param1.arrowList[_loc2_].posX;
                  _loc3_.y = param1.arrowList[_loc2_].posY;
               }
               else
               {
                  _loc4_ = this._main.globalToLocal(param1.arrowList[_loc2_].relative.localToGlobal(new Point(param1.arrowList[_loc2_].posX,param1.arrowList[_loc2_].posY)));
                  _loc3_.x = _loc4_.x;
                  _loc3_.y = _loc4_.y;
               }
               this._main.addListenerOf(_loc3_,Event.ENTER_FRAME,this.checkRelativePosition);
               _loc3_.rotation = param1.arrowList[_loc2_].angle;
               _loc3_.mouseEnabled = false;
               _loc3_.mouseChildren = false;
               this._main.addChild(_loc3_);
               this._tutorArrow.push(_loc3_);
               _loc2_++;
            }
         }
      }
      
      function checkRelativePosition(param1:Event) : void
      {
         var _loc4_:Point = null;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this._tutorArrow.indexOf(_loc2_);
         if(_loc3_ in this._currentTutor.arrowList)
         {
            _loc2_.visible = this._currentTutor.arrowList[_loc3_].relative != null && this._currentTutor.arrowList[_loc3_].relative.stage != null;
            if(this._currentTutor.arrowList[_loc3_].relative != null && this._currentTutor.arrowList[_loc3_].relative.parent != null)
            {
               _loc4_ = new Point();
               _loc4_ = this._currentTutor.arrowList[_loc3_].relative.localToGlobal(new Point(this._currentTutor.arrowList[_loc3_].posX,this._currentTutor.arrowList[_loc3_].posY));
               _loc2_.x = _loc4_.x;
               _loc2_.y = _loc4_.y;
            }
         }
      }
      
      function removeAllArrow() : void
      {
         var _loc1_:* = undefined;
         while(this._tutorArrow.length > 0)
         {
            _loc1_ = this._tutorArrow.shift();
            this._main.removeListenerOf(_loc1_,Event.ENTER_FRAME,this.checkRelativePosition);
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
      }
      
      function showTutorial(param1:String, param2:Boolean = false) : *
      {
         var _loc3_:* = this.getTutorial(param1);
         if(_loc3_ != null)
         {
            if(this._currentTutor == null)
            {
               if(_loc3_.tutorDelay >= 0)
               {
                  this._currentTutor = _loc3_;
                  this._tutorialPanel.clearText();
                  this._tutorialPanel.text = _loc3_.tutorNote;
                  this._tutorialPanel.tutorDelay = _loc3_.tutorDelay;
                  if(this._main.getChildByName(this._tutorialPanel.name) == null)
                  {
                     this._main.addChild(this._tutorialPanel);
                     this._tutorialPanel.x = 700 + this._tutorialPanel.width;
                     this._tutorialPanel.y = this._main.GUI.tutorialPanel.y;
                     this.myTween = TweenLite.to(this._tutorialPanel,0.4,{
                        "x":this._main.GUI.tutorialPanel.x,
                        "onComplete":this._tutorialPanel.showText
                     });
                  }
                  else
                  {
                     this._tutorialPanel.showText();
                  }
                  if(!this._inProgress)
                  {
                     this._inProgress = true;
                     this._main.GUI.dispatchEvent(new CommandEvent(CommandEvent.SPEED_CHANGE,null));
                  }
               }
               if(_loc3_.skipWhen == null)
               {
                  if(_loc3_.tutorDelay >= 0)
                  {
                     this._main.addListenerOf(this._tutorialPanel,TutorialEvent.TUTORIAL_SKIP,this.gotoNextTutor);
                  }
               }
               else
               {
                  this.generateSkipProgress(_loc3_);
               }
               this.showArrowList(_loc3_);
               if(param2)
               {
                  this._passed.push(_loc3_.tutorHeader);
                  if(_loc3_.tutorReplace != null)
                  {
                     this._passed.push(_loc3_.tutorReplace);
                  }
               }
               this.checkAvailable();
            }
            else if(this._tutorialOnQueue.indexOf(_loc3_.tutorHeader) < 0)
            {
               this._tutorialOnQueue.push(_loc3_.tutorHeader);
            }
         }
      }
      
      function checkAvailable() : void
      {
      }
      
      function createCover(param1:*) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:* = undefined;
         var _loc2_:* = param1.parent;
         if(_loc2_.getChildByName(param1.name + "Cover") == null)
         {
            _loc3_ = new MovieClip();
            _loc3_.graphics.clear();
            _loc3_.graphics.beginFill(16777215,0);
            _loc3_.graphics.drawRect(-param1.width / 2,-param1.height / 2,param1.width,param1.height);
            _loc3_.graphics.endFill();
            _loc3_.x = param1.x;
            _loc3_.y = param1.y;
            (_loc4_ = new SymbolLocked()).scaleX = 0.7;
            _loc4_.scaleY = 0.7;
            _loc4_.x = _loc3_.width / 2 - _loc3_.width / 8;
            _loc4_.y = _loc3_.height / 2 - _loc3_.height / 8;
            _loc3_.addChild(_loc4_);
            _loc3_.name = param1.name + "Cover";
            param1.parent.addChild(_loc3_);
         }
      }
      
      function removeCover(param1:*) : void
      {
         var _loc2_:* = param1.parent.getChildByName(param1.name + "Cover");
         if(_loc2_ != null)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
      }
      
      function generateSkipProgress(param1:*) : void
      {
         var _loc2_:* = undefined;
         switch(param1.skipWhen)
         {
            case this.RELATIVE_IS_ACTIVATED:
               if(param1.relative != null)
               {
                  if(param1.relative is Array)
                  {
                     _loc2_ = 0;
                     while(_loc2_ < param1.relative.length)
                     {
                        this._checkListener.push({
                           "target":param1.relative[_loc2_],
                           "listener":ToggleButtonEvent.ACTIVATE
                        });
                        this._checkListener.push({
                           "target":param1.relative[_loc2_],
                           "listener":ToggleButtonEvent.FORCE_ACTIVATE
                        });
                        this._main.addListenerOf(param1.relative[_loc2_],ToggleButtonEvent.ACTIVATE,this.gotoNextTutor);
                        this._main.addListenerOf(param1.relative[_loc2_],ToggleButtonEvent.FORCE_ACTIVATE,this.gotoNextTutor);
                        _loc2_++;
                     }
                  }
               }
               else
               {
                  this._main.addListenerOf(this._tutorialPanel,TutorialEvent.TUTORIAL_SKIP,this.gotoNextTutor);
               }
               break;
            case this.RELATIVE_IS_CLICKED:
               if(param1.relative != null)
               {
                  if(param1.relative is Array)
                  {
                     _loc2_ = 0;
                     while(_loc2_ < param1.relative.length)
                     {
                        this._checkListener.push({
                           "target":param1.relative[_loc2_],
                           "listener":MouseEvent.CLICK
                        });
                        this._main.addListenerOf(param1.relative[_loc2_],MouseEvent.CLICK,this.gotoNextTutor);
                        _loc2_++;
                     }
                  }
               }
               else
               {
                  this._main.addListenerOf(this._tutorialPanel,TutorialEvent.TUTORIAL_SKIP,this.gotoNextTutor);
               }
               break;
            case this.BUILDING_CREATED:
               this._main.addListenerOf(this._main.world,GameEvent.BUILDING_CREATED,this.gotoNextTutor);
               break;
            case this.STAFF_HIRED:
               this._main.addListenerOf(this._main.world,GameEvent.HIRE_STAFF,this.gotoNextTutor);
         }
      }
      
      function getTutorial(param1:String) : *
      {
         var _loc2_:* = null;
         var _loc3_:* = this.TUTORIAL_HEADER.indexOf(param1);
         if(_loc3_ in this.TUTORIAL_PROGRESS)
         {
            _loc2_ = this.TUTORIAL_PROGRESS[_loc3_];
         }
         return _loc2_;
      }
      
      public function pauseTutor() : void
      {
         this._tutorialPanel.pauseTutor();
         if(this.myTween != null)
         {
            this.myTween.pause();
         }
      }
      
      public function resumeTutor() : void
      {
         this._tutorialPanel.resumeTutor();
         if(this.myTween != null)
         {
            this.myTween.resume();
         }
      }
      
      public function get passed() : Array
      {
         return this._passed;
      }
      
      public function set main(param1:Gameplay) : void
      {
         this._main = param1;
      }
      
      public function get main() : Gameplay
      {
         return this._main;
      }
      
      public function get inProgress() : Boolean
      {
         return this._inProgress;
      }
   }
}
