package Instance
{
   import Instance.constant.BGMData;
   import Instance.events.AudioEvent;
   import Instance.events.CommandEvent;
   import Instance.events.MessageDialogEvent;
   import Instance.modules.Utility;
   import Instance.ui.Credits;
   import Instance.ui.UI_Confirmation;
   import fl.motion.easing.Back;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.*;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFormat;
   import greensock.TweenLite;
   import greensock.TweenMax;
   
   public class Main_Menu extends SEMovieClip
   {
       
      
      public var buttonTemplate:MovieClip;
      
      public var btnMuteSFX:UIToggleButtonSFXMute;
      
      public var lgLink:SimpleButton;
      
      public var shopEmpireLogo:MovieClip;
      
      public var btnMuteBGM:UIToggleButtonBGMMute;
      
      public var knightAnimation:MovieClip;
      
      public var gamesfreeLogo:SimpleButton;
      
      public var mainMenuBG:MovieClip;
      
      const BACK_TO_HEADER = 0;
      
      const GO_TO_PLAY_GAME = 1;
      
      const GO_TO_SE_SERRIES = 2;
      
      var mainButton:Array;
      
      var buttonList:Array;
      
      var buttonExecute:uint;
      
      var slotList;
      
      var btnDeleteList;
      
      var mainProgram:MainProgram;
      
      var _blankCover:Sprite;
      
      var _inCredit:Boolean;
      
      var alternatePage;
      
      var repeatDelay:int;
      
      public function Main_Menu()
      {
         this.mainButton = new Array();
         this.buttonList = new Array();
         this.slotList = new Array();
         this.btnDeleteList = new Array();
         super();
         this._blankCover = new Sprite();
         this._blankCover.graphics.clear();
         this._blankCover.graphics.beginFill(0,0.3);
         this._blankCover.graphics.drawRect(0,0,700,500);
         this._blankCover.graphics.endFill();
         this._inCredit = false;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.mainProgram = this.parent as MainProgram;
         this.buttonTemplate.stop();
         this.buttonTemplate.visible = false;
         this.shopEmpireLogo.visible = false;
         this.revealTitle();
         this.btnMuteBGM.isActive = this.mainProgram.bgmMute;
         this.btnMuteSFX.isActive = this.mainProgram.sfxMute;
         addListenerOf(this,Event.ENTER_FRAME,this.checkAnimateSFX);
         addListenerOf(this.lgLink,MouseEvent.CLICK,this.linkToLG);
         addListenerOf(this.gamesfreeLogo,MouseEvent.CLICK,this.linkToGamesfree);
         addListenerOf(this.btnMuteBGM,MouseEvent.CLICK,this.toggleMute);
         addListenerOf(this.btnMuteSFX,MouseEvent.CLICK,this.toggleMute);
         dispatchEvent(new AudioEvent(AudioEvent.PLAY_BGM,BGMData.MAIN_MENU));
      }
      
      function toggleMute(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_ == this.btnMuteBGM)
         {
            this.mainProgram.bgmMute = this.btnMuteBGM.isActive;
         }
         if(_loc2_ == this.btnMuteSFX)
         {
            this.mainProgram.sfxMute = this.btnMuteSFX.isActive;
         }
      }
      
      function linkToLG(param1:Event) : void
      {
         var _loc2_:* = root;
         _loc2_.linkToLG();
      }
      
      function linkToGamesfree(param1:Event) : void
      {
         var _loc2_:* = root;
         _loc2_.linkToGamesfree();
      }
      
      function checkAnimateSFX(param1:Event) : void
      {
         if(!this._inCredit)
         {
            if(this.mainMenuBG.horseClip.currentFrameLabel == "horseCome")
            {
               dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Horse_Running,1,0,1250));
            }
            if(this.mainMenuBG.horseClip.currentFrameLabel == "horseLeave")
            {
               dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Horse_Running));
            }
            if(this.mainMenuBG.chickenClip.currentFrameLabel == "chickenAppear")
            {
               dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Chicken_Run));
            }
            if(this.knightAnimation.currentFrameLabel == "climbing" || this.knightAnimation.currentFrameLabel == "desscent")
            {
               dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Knight_Climbing));
            }
            if(this.knightAnimation.currentFrameLabel == "putSign")
            {
               dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Equip));
            }
            if(this.knightAnimation.currentFrameLabel == "drop")
            {
               dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Wooden_Fall));
            }
         }
      }
      
      public function revealTitle() : void
      {
         this.knightAnimation.stop();
         this.shopEmpireLogo.visible = true;
         this.shopEmpireLogo.scaleX = 0;
         this.shopEmpireLogo.scaleY = 0;
         TweenLite.to(this.shopEmpireLogo,1.2,{
            "scaleX":1,
            "scaleY":1,
            "ease":Back.easeOut,
            "onComplete":this.revealMainButton
         });
      }
      
      public function revealMainButton() : void
      {
         var delayToAppear:* = undefined;
         this.knightAnimation.play();
         this.buttonTemplate.gotoAndStop("mainPage");
         this.buttonTemplate.visible = true;
         with(this.buttonTemplate)
         {
            if(insertToButtonList(btnPlayGame))
            {
               addListenerOf(btnPlayGame,MouseEvent.CLICK,btnPlayGameOnClick);
            }
            if(insertToButtonList(btnCredits))
            {
               addListenerOf(btnCredits,MouseEvent.CLICK,btnCreditsOnClick);
            }
            if(insertToButtonList(btnOption))
            {
               addListenerOf(btnOption,MouseEvent.CLICK,btnOptionOnClick);
            }
            if(insertToButtonList(btnShopEmpireGames))
            {
               addListenerOf(btnShopEmpireGames,MouseEvent.CLICK,btnShopEmpireGamesOnClick);
            }
            if(insertToButtonList(btnMoreGames))
            {
               addListenerOf(btnMoreGames,MouseEvent.CLICK,btnMoreGamesOnClick);
            }
         }
         var i:* = 0;
         while(i < this.buttonList.length)
         {
            delayToAppear = Math.ceil(i / 2) * 0.1;
            this.buttonList[i].mouseEnabled = false;
            TweenMax.from(this.buttonList[i],0.4,{
               "scaleY":0,
               "tint":16777215,
               "delay":delayToAppear,
               "onComplete":this.makeButtonEnabled,
               "onCompleteParams":[this.buttonList[i]]
            });
            i++;
         }
         this.repeatDelay = Math.floor(Math.random() * 15) * 10;
         addListenerOf(this,Event.ENTER_FRAME,this.resumeKnightAnimation);
      }
      
      function resumeKnightAnimation(param1:Event) : void
      {
         if(this.knightAnimation.currentFrame >= this.knightAnimation.totalFrames)
         {
            if(this.repeatDelay > 0)
            {
               this.knightAnimation.stop();
               --this.repeatDelay;
            }
            else
            {
               this.knightAnimation.play();
               this.repeatDelay = Math.floor(Math.random() * 15) * 10;
            }
         }
      }
      
      function slotOnOver(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         TweenMax.to(_loc2_,0.01,{"colorTransform":{
            "tint":16777215,
            "tintAmount":0.3
         }});
         addListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.slotOnOut);
      }
      
      function slotOnOut(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         TweenMax.to(_loc2_,0.01,{"removeTint":true});
         removeListenerOf(_loc2_,MouseEvent.ROLL_OUT,this.slotOnOut);
      }
      
      function slotOnClick(param1:MouseEvent) : void
      {
         var index:* = undefined;
         var confirmation:* = undefined;
         var onChoose:Function = null;
         var e:MouseEvent = param1;
         var target:* = e.currentTarget;
         index = this.slotList.indexOf(target);
         dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Select));
         if(this.checkData(index))
         {
            onChoose = function(param1:MessageDialogEvent):void
            {
               removeListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
               if(param1.choice == MessageDialogEvent.CHOICE_YES)
               {
                  dispatchEvent(new CommandEvent(CommandEvent.BEGIN_LOAD_GAME,index));
               }
               confirmation.parent.removeChild(confirmation);
               removeChild(_blankCover);
            };
            confirmation = new UI_Confirmation();
            confirmation.toConfirm = "toLoad";
            confirmation.x = 350;
            confirmation.y = 250;
            addChild(this._blankCover);
            addChild(confirmation);
            addListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
         }
         else
         {
            dispatchEvent(new CommandEvent(CommandEvent.BEGIN_NEW_GAME,index));
         }
      }
      
      function linkToShopEmpireGames(param1:MouseEvent) : void
      {
         var _loc4_:URLRequest = null;
         var _loc2_:* = param1.currentTarget;
         var _loc3_:* = this.slotList.indexOf(_loc2_);
         dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Select));
         switch(_loc3_)
         {
            case 0:
               _loc4_ = new URLRequest("http://www.gamesfree.com/game/shop_empire.html");
               navigateToURL(_loc4_,"_blank");
               break;
            case 1:
               _loc4_ = new URLRequest("http://www.gamesfree.com/game/shop_empire_2.html");
               navigateToURL(_loc4_,"_blank");
               break;
            case 2:
               _loc4_ = new URLRequest("http://www.gamesfree.com/game/shop_empire_rampage.html");
               navigateToURL(_loc4_,"_blank");
         }
      }
      
      function btnDeleteOnClick(param1:MouseEvent) : void
      {
         var index:* = undefined;
         var confirmation:* = undefined;
         var onChoose:Function = null;
         var e:MouseEvent = param1;
         var target:* = e.currentTarget;
         index = this.btnDeleteList.indexOf(target);
         if(this.checkData(index))
         {
            onChoose = function(param1:MessageDialogEvent):void
            {
               removeListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
               if(param1.choice == MessageDialogEvent.CHOICE_YES)
               {
                  dispatchEvent(new CommandEvent(CommandEvent.DELETE_SAVE_DATA,index));
                  slotList[index].headerInfo.text = "EMPTY";
                  btnDeleteList[index].visible = false;
                  slotList[index].saveInfo.gotoAndStop(2);
               }
               confirmation.parent.removeChild(confirmation);
               removeChild(_blankCover);
            };
            confirmation = new UI_Confirmation();
            confirmation.toConfirm = "toDelete";
            confirmation.x = 350;
            confirmation.y = 250;
            addChild(this._blankCover);
            addChild(confirmation);
            dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Select));
            addListenerOf(confirmation,MessageDialogEvent.CHOSEN,onChoose);
         }
      }
      
      function revealChoosingSlot() : void
      {
         var makeSelectable:Function = null;
         var theSlot:* = undefined;
         var theButton:* = undefined;
         var saveData:* = undefined;
         var comeFrom:* = undefined;
         var hourText:* = undefined;
         var timeText:* = undefined;
         var showPopularity:* = undefined;
         var headPop:* = undefined;
         var tailPop:* = undefined;
         var numberStaff:* = undefined;
         var prop:* = undefined;
         var format:TextFormat = null;
         var ii:* = undefined;
         var staffData:* = undefined;
         var theDate:* = undefined;
         var theMonth:* = undefined;
         var theYears:* = undefined;
         var theHour:* = undefined;
         var theMinute:* = undefined;
         var pmam:* = undefined;
         makeSelectable = function(param1:*, param2:*):void
         {
            param1.buttonMode = true;
            addListenerOf(param1,MouseEvent.ROLL_OVER,slotOnOver);
            addListenerOf(param1,MouseEvent.CLICK,slotOnClick);
            addListenerOf(param2,MouseEvent.CLICK,btnDeleteOnClick);
         };
         this.buttonTemplate.gotoAndStop("choosingSlot");
         this.slotList.push(this.buttonTemplate.slot0);
         this.slotList.push(this.buttonTemplate.slot1);
         this.slotList.push(this.buttonTemplate.slot2);
         this.btnDeleteList.push(this.buttonTemplate.btnDelete0);
         this.btnDeleteList.push(this.buttonTemplate.btnDelete1);
         this.btnDeleteList.push(this.buttonTemplate.btnDelete2);
         var bottom:* = this.buttonTemplate.globalToLocal(new Point(0,500));
         var i:* = 0;
         while(i < this.slotList.length)
         {
            theSlot = this.slotList[i];
            theButton = null;
            if(i in this.btnDeleteList)
            {
               theButton = this.btnDeleteList[i];
            }
            theSlot.btnDeletePosition.visible = false;
            theSlot.saveInfo.mouseEnabled = false;
            theSlot.saveInfo.mouseChildren = false;
            saveData = this.mainProgram.getSaveData(i);
            if(saveData == null)
            {
               theSlot.headerInfo.text = "EMPTY";
               theSlot.saveInfo.gotoAndStop(2);
               if(theButton != null)
               {
                  theButton.visible = false;
               }
            }
            else
            {
               theSlot.headerInfo.text = saveData.nameID.toUpperCase();
               theSlot.saveInfo.gotoAndStop(1);
               theSlot.saveInfo.dayPassed.text = "Day " + saveData.dayPassed + "";
               hourText = saveData.gameHour > 12 ? saveData.gameHour - 12 : saveData.gameHour;
               timeText = (String(hourText).length > 1 ? "" : "0") + hourText + ":" + (String(saveData.gameMinute).length > 1 ? "" : "0") + saveData.gameMinute + " " + (saveData.gameHour >= 12 ? "PM" : "AM");
               theSlot.saveInfo.currentTime.text = timeText;
               showPopularity = Math.round(saveData.world.popularity * 10);
               headPop = Math.floor(showPopularity / 10);
               tailPop = showPopularity % 10;
               theSlot.saveInfo.popularity.text = "" + headPop + "" + (tailPop > 0 ? "." + tailPop : "") + "%";
               theSlot.saveInfo.myMoney.text = Utility.numberToMoney(saveData.budget) + " G";
               theSlot.saveInfo.currentVisitor.text = "x" + saveData.visitorList.length + "";
               numberStaff = 0;
               for(prop in saveData.staff)
               {
                  ii = 0;
                  while(ii < saveData.staff[prop].length)
                  {
                     staffData = saveData.staff[prop][ii];
                     if(staffData != null)
                     {
                        if(staffData.guardPost == null)
                        {
                           numberStaff++;
                        }
                     }
                     ii++;
                  }
               }
               theSlot.saveInfo.currentStaff.text = "x" + numberStaff + "";
               theSlot.saveInfo.currentBuilding.text = "x" + (saveData.buildingList.length - saveData.dungeonConnection.length - 2) + "";
               format = new TextFormat();
               format.letterSpacing = -1;
               theSlot.saveInfo.saveTime.defaultTextFormat = format;
               if(saveData.saveDate != null)
               {
                  theDate = "" + saveData.saveDate.date + "";
                  if(theDate.length < 2)
                  {
                     theDate = "0" + theDate;
                  }
                  theMonth = Utility.numberToDate(saveData.saveDate.month);
                  theYears = "" + saveData.saveDate.fullYear + "";
                  theHour = "" + (saveData.saveDate.hours > 12 ? saveData.saveDate.hours - 12 : saveData.saveDate.hours) + "";
                  if(theHour.length < 2)
                  {
                     theHour = "0" + theHour;
                  }
                  theMinute = "" + saveData.saveDate.minutes + "";
                  if(theMinute.length < 2)
                  {
                     theMinute = "0" + theMinute;
                  }
                  pmam = saveData.saveDate.hours >= 12 ? "pm" : "am";
                  theSlot.saveInfo.saveTime.text = "" + theDate + "/" + theMonth + "/" + theYears + "   " + theHour + ":" + theMinute + " " + pmam;
               }
               else
               {
                  theSlot.saveInfo.saveTime.text = "??/??/????  ??:?? ??";
               }
               if(theButton != null)
               {
                  theButton.visible = true;
               }
            }
            comeFrom = bottom.y + theSlot.height / 2 + 20;
            TweenLite.from(theSlot,0.4,{
               "y":comeFrom,
               "delay":i * 0.1,
               "ease":Back.easeOut,
               "onUpdate":this.correctPosition,
               "onUpdateParams":[theSlot,theButton],
               "onComplete":makeSelectable,
               "onCompleteParams":[theSlot,theButton]
            });
            i++;
         }
         with(this.buttonTemplate)
         {
            if(insertToButtonList(btnBack))
            {
               addListenerOf(btnBack,MouseEvent.CLICK,btnBackOnClick);
            }
         }
         this.buttonTemplate.btnBack.mouseEnabled = false;
         TweenMax.from(this.buttonTemplate.btnBack,0.4,{
            "scaleY":0,
            "tint":16777215,
            "delay":this.slotList.length * 0.1,
            "onComplete":this.makeButtonEnabled,
            "onCompleteParams":[this.buttonTemplate.btnBack]
         });
      }
      
      function revealSESerries() : void
      {
         var makeSelectable:Function = null;
         var theSlot:* = undefined;
         var theButton:* = undefined;
         var comeFrom:* = undefined;
         makeSelectable = function(param1:*):void
         {
            param1.buttonMode = true;
            addListenerOf(param1,MouseEvent.ROLL_OVER,slotOnOver);
            addListenerOf(param1,MouseEvent.CLICK,linkToShopEmpireGames);
         };
         this.buttonTemplate.gotoAndStop("seSerries");
         this.slotList.push(this.buttonTemplate.slot0);
         this.slotList.push(this.buttonTemplate.slot1);
         this.slotList.push(this.buttonTemplate.slot2);
         var bottom:* = this.buttonTemplate.globalToLocal(new Point(0,500));
         var i:* = 0;
         while(i < this.slotList.length)
         {
            theSlot = this.slotList[i];
            theButton = null;
            theSlot.thumbnail.mouseEnabled = false;
            theSlot.thumbnail.mouseChildren = false;
            theSlot.thumbnail.gotoAndStop(i + 1);
            comeFrom = bottom.y + theSlot.height / 2 + 20;
            TweenLite.from(theSlot,0.4,{
               "y":comeFrom,
               "delay":i * 0.1,
               "ease":Back.easeOut,
               "onUpdate":this.correctPosition,
               "onUpdateParams":[theSlot,theButton],
               "onComplete":makeSelectable,
               "onCompleteParams":[theSlot]
            });
            i++;
         }
         with(this.buttonTemplate)
         {
            if(insertToButtonList(btnBack))
            {
               addListenerOf(btnBack,MouseEvent.CLICK,btnBackOnClick);
            }
         }
         this.buttonTemplate.btnBack.mouseEnabled = false;
         TweenMax.from(this.buttonTemplate.btnBack,0.4,{
            "scaleY":0,
            "tint":16777215,
            "delay":this.slotList.length * 0.1,
            "onComplete":this.makeButtonEnabled,
            "onCompleteParams":[this.buttonTemplate.btnBack]
         });
      }
      
      function correctPosition(param1:*, param2:*) : void
      {
         var _loc3_:* = undefined;
         if(param2 != null)
         {
            _loc3_ = param1.parent.globalToLocal(param1.btnDeletePosition.localToGlobal(new Point(0,0)));
            param2.x = _loc3_.x;
            param2.y = _loc3_.y;
         }
      }
      
      function makeButtonEnabled(param1:*) : void
      {
         param1.mouseEnabled = true;
      }
      
      function btnPlayGameOnClick(param1:MouseEvent) : void
      {
         this.buttonExecute = this.GO_TO_PLAY_GAME;
         this.removeMainButton();
         this.removeMainPageButtonListener();
      }
      
      function btnCreditsOnClick(param1:MouseEvent) : void
      {
         var afterShowCredits:Function = null;
         var e:MouseEvent = param1;
         afterShowCredits = function():void
         {
            _inCredit = true;
            addListenerOf(alternatePage.btnBack,MouseEvent.CLICK,backAfterCredit);
            addListenerOf(alternatePage.lgBanner,MouseEvent.CLICK,linkToLG);
            addListenerOf(alternatePage.gamesfreeBanner,MouseEvent.CLICK,linkToGamesfree);
         };
         this.removeMainPageButtonListener();
         this.alternatePage = new Credits();
         this.alternatePage.x = 350 - 700;
         this.alternatePage.y = 250;
         addChild(this.alternatePage);
         TweenLite.to(this,0.8,{
            "x":700,
            "onComplete":afterShowCredits
         });
      }
      
      function backAfterCredit(param1:MouseEvent) : void
      {
         this._inCredit = false;
         removeListenerOf(param1.currentTarget,MouseEvent.CLICK,this.backAfterCredit);
         removeListenerOf(this.alternatePage.lgBanner,MouseEvent.CLICK,this.linkToLG);
         removeListenerOf(this.alternatePage.gamesfreeBanner,MouseEvent.CLICK,this.linkToGamesfree);
         TweenLite.to(this,0.8,{
            "x":0,
            "onComplete":this.refreshPageAfterBackAlternatePage
         });
      }
      
      function btnOptionOnClick(param1:MouseEvent) : void
      {
         var afterShowOption:Function = null;
         var e:MouseEvent = param1;
         afterShowOption = function():void
         {
            _inCredit = true;
            addListenerOf(alternatePage.btnBack,MouseEvent.CLICK,backFromOption);
            addListenerOf(alternatePage.optionPanel,CommandEvent.EXIT_OPTION,backFromOption);
         };
         this.removeMainPageButtonListener();
         this.alternatePage = new MainMenuOption();
         this.alternatePage.x = 350 + 700;
         this.alternatePage.y = 250;
         this.alternatePage.optionPanel.mainProgram = this.parent as MainProgram;
         addChild(this.alternatePage);
         TweenLite.to(this,0.8,{
            "x":-700,
            "onComplete":afterShowOption
         });
      }
      
      function refreshPageAfterBackAlternatePage() : void
      {
         this.alternatePage.parent.removeChild(this.alternatePage);
         with(this.buttonTemplate)
         {
            addListenerOf(btnPlayGame,MouseEvent.CLICK,btnPlayGameOnClick);
            addListenerOf(btnCredits,MouseEvent.CLICK,btnCreditsOnClick);
            addListenerOf(btnOption,MouseEvent.CLICK,btnOptionOnClick);
            addListenerOf(btnShopEmpireGames,MouseEvent.CLICK,btnShopEmpireGamesOnClick);
            addListenerOf(btnMoreGames,MouseEvent.CLICK,btnMoreGamesOnClick);
         }
      }
      
      function backFromOption(param1:Event) : void
      {
         this._inCredit = false;
         var _loc2_:* = param1.currentTarget;
         if(_loc2_ == this.alternatePage.btnBack)
         {
            this.alternatePage.optionPanel.cancelChange();
         }
         removeListenerOf(this.alternatePage.btnBack,MouseEvent.CLICK,this.backFromOption);
         removeListenerOf(this.alternatePage.optionPanel,CommandEvent.EXIT_OPTION,this.backFromOption);
         TweenLite.to(this,0.8,{
            "x":0,
            "onComplete":this.refreshPageAfterBackAlternatePage
         });
      }
      
      function btnShopEmpireGamesOnClick(param1:MouseEvent) : void
      {
         this.buttonExecute = this.GO_TO_SE_SERRIES;
         this.removeMainButton();
         this.removeMainPageButtonListener();
      }
      
      function btnMoreGamesOnClick(param1:MouseEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest("http://www.gamesfree.com/");
         navigateToURL(_loc2_,"_blank");
      }
      
      function btnBackOnClick(param1:MouseEvent) : void
      {
         this.buttonExecute = this.BACK_TO_HEADER;
         this.removeChoosingSlot();
         removeListenerOf(param1.currentTarget,MouseEvent.CLICK,this.btnBackOnClick);
      }
      
      function removeMainButton() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this.buttonList.length)
         {
            _loc2_ = Math.ceil(_loc1_ / 2) * 0.1;
            this.buttonList[_loc1_].mouseEnabled = false;
            TweenMax.to(this.buttonList[_loc1_],0.4,{
               "scaleY":0,
               "tint":16777215,
               "delay":_loc2_,
               "onComplete":this.checkButtonAndExecute,
               "onCompleteParams":[this.buttonList[_loc1_]]
            });
            _loc1_++;
         }
      }
      
      function removeChoosingSlot() : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc1_:* = this.buttonTemplate.globalToLocal(new Point(0,500));
         var _loc2_:* = 0;
         while(_loc2_ < this.slotList.length)
         {
            _loc3_ = this.slotList[_loc2_];
            _loc4_ = null;
            if(_loc2_ in this.btnDeleteList)
            {
               _loc4_ = this.btnDeleteList[_loc2_];
            }
            _loc5_ = _loc1_.y + _loc3_.height / 2 + 20;
            _loc3_.buttonMode = false;
            this.buttonList.push(_loc3_);
            removeListenerOf(_loc3_,MouseEvent.ROLL_OVER,this.slotOnOver);
            removeListenerOf(_loc3_,MouseEvent.CLICK,this.slotOnClick);
            removeListenerOf(_loc4_,MouseEvent.CLICK,this.btnDeleteOnClick);
            TweenLite.to(_loc3_,0.4,{
               "y":_loc5_,
               "delay":_loc2_ * 0.1,
               "ease":Back.easeIn,
               "onUpdate":this.correctPosition,
               "onUpdateParams":[_loc3_,_loc4_],
               "onComplete":this.checkButtonAndExecute,
               "onCompleteParams":[this.slotList[_loc2_]]
            });
            _loc2_++;
         }
         while(this.slotList.length > 0)
         {
            this.slotList.shift();
         }
         while(this.btnDeleteList.length > 0)
         {
            this.btnDeleteList.shift();
         }
         this.buttonTemplate.btnBack.mouseEnabled = false;
         TweenMax.to(this.buttonTemplate.btnBack,0.4,{
            "scaleY":0,
            "tint":16777215,
            "onComplete":this.checkButtonAndExecute,
            "onCompleteParams":[this.buttonTemplate.btnBack]
         });
      }
      
      function removeMainPageButtonListener() : void
      {
         with(this.buttonTemplate)
         {
            removeListenerOf(btnPlayGame,MouseEvent.CLICK,btnPlayGameOnClick);
            removeListenerOf(btnCredits,MouseEvent.CLICK,btnCreditsOnClick);
         }
      }
      
      function removeButtonFromList(param1:DisplayObject) : void
      {
         var _loc2_:* = this.buttonList.indexOf(param1);
         if(_loc2_ >= 0)
         {
            removeListenerOf(param1,MouseEvent.CLICK,this.playSoundButton);
            this.buttonList.splice(_loc2_,1);
         }
      }
      
      function checkButtonAndExecute(param1:DisplayObject) : void
      {
         this.removeButtonFromList(param1);
         if(this.buttonList.length <= 0)
         {
            this.execution();
         }
      }
      
      function execution() : void
      {
         switch(this.buttonExecute)
         {
            case this.BACK_TO_HEADER:
               this.revealMainButton();
               break;
            case this.GO_TO_PLAY_GAME:
               this.revealChoosingSlot();
               break;
            case this.GO_TO_SE_SERRIES:
               this.revealSESerries();
         }
      }
      
      function playSoundButton(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Button_Press));
         }
      }
      
      function insertToButtonList(param1:DisplayObject) : Boolean
      {
         var _loc2_:* = false;
         if(this.buttonList.indexOf(param1) < 0)
         {
            this.buttonList.push(param1);
            addListenerOf(param1,MouseEvent.CLICK,this.playSoundButton);
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      function getData(param1:int) : *
      {
         return this.mainProgram.getSaveData(param1);
      }
      
      function checkData(param1:int) : Boolean
      {
         if(this.getData(param1))
         {
            return true;
         }
         return false;
      }
   }
}
