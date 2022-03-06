package Instance.property
{
   import Instance.constant.BuildingData;
   import Instance.constant.UpgradeData;
   import Instance.events.AchievementEvent;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.MissionEvent;
   import Instance.gameplay.Litter;
   import Instance.gameplay.Thief;
   import Instance.gameplay.World;
   import Instance.modules.Utility;
   import Instance.ui.UI_InGame;
   import flash.events.Event;
   
   public class Mission
   {
       
      
      const MISSION_LIST = [{
         "note":"Build 1st booth",
         "targetCheck":"boothList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":100,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Build an elevator",
         "targetCheck":"elevatorList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":100,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Hire first janitor",
         "targetCheck":"janitorList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":100,
         "checkEvent":[GameEvent.HIRE_STAFF,GameEvent.FIRE]
      },{
         "note":"Hire first handyman",
         "targetCheck":"handymanList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":100,
         "checkEvent":[GameEvent.HIRE_STAFF,GameEvent.FIRE]
      },{
         "note":"Got 1st customer",
         "targetCheck":"visitorList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":100,
         "checkEvent":GameEvent.HUMAN_ADDED
      },{
         "note":"Build second booth",
         "targetCheck":"boothList",
         "targetOpt":">=",
         "targetValue":2,
         "rewardText":"3 New Booths",
         "rewardType":"unlockBuild",
         "rewardValue":["Book Store","Medicine","Snack"],
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Hire first guard",
         "targetCheck":"guardList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":150,
         "checkEvent":[GameEvent.HIRE_STAFF,GameEvent.FIRE]
      },{
         "note":"Build first rest room",
         "targetCheck":"restroomList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":200,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Have 2 or more janitor",
         "targetCheck":"janitorList",
         "targetOpt":">=",
         "targetValue":2,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":150,
         "checkEvent":[GameEvent.HIRE_STAFF,GameEvent.FIRE]
      },{
         "note":"Hire first entertainer",
         "targetCheck":"entertainerList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":100,
         "checkEvent":[GameEvent.HIRE_STAFF,GameEvent.FIRE]
      },{
         "note":"Build 3 or more booth",
         "targetCheck":"boothList",
         "targetOpt":">=",
         "targetValue":3,
         "rewardText":"Unlock Ex Upgrade",
         "rewardType":"unlockUpgrade",
         "rewardValue":[UpgradeData.CUTE_WAITER],
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Purchase any extra upgrade",
         "targetCheck":"purchasedExtra",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Unlock stairs",
         "rewardType":"unlockBuild",
         "rewardValue":["Stairs"],
         "checkEvent":[GameEvent.PURCHASE_UPGRADE]
      },{
         "note":"Build any building at 2nd floor",
         "targetCheck":"buildingFloor",
         "additionalCheck":2,
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Popularity +5%",
         "rewardType":"popularity",
         "rewardValue":5,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Have one or more stairs",
         "targetCheck":"stairList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Unlock 3 upgrades",
         "rewardType":"unlockUpgrade",
         "rewardValue":[UpgradeData.BLOOMY_ORCHID,UpgradeData.SANDALWOOD,UpgradeData.MASSIVE_BIN],
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Earn &target G in a day",
         "targetCheck":"profit",
         "targetOpt":">=",
         "targetValue":1000,
         "rewardText":"Expand area",
         "rewardType":"worldLevel",
         "rewardValue":1,
         "checkEvent":[GameEvent.SHOW_REPORT]
      },{
         "note":"Fix on the booth (&amount of 1)",
         "targetCheck":"special",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Build EXP +5%",
         "rewardType":"buildingExpBonus",
         "rewardValue":5,
         "checkEvent":[GameEvent.BUILDING_REPAIRED]
      },{
         "note":"Catch a thief (&amount of 1)",
         "targetCheck":"special",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Unlock Ex Upgrade",
         "rewardType":"unlockUpgrade",
         "rewardValue":[UpgradeData.CRYSTAL_BALL,UpgradeData.WANTED_POSTER],
         "checkEvent":[GameEvent.ARRESTED],
         "additionalEventCheck":["target is Thief"],
         "thiefMod":1.5
      },{
         "note":"Have upgraded janitor",
         "targetCheck":"janitorList",
         "additionalCheck":2,
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":300,
         "checkEvent":[HumanEvent.SUCCESFULLY_PROMOTED]
      },{
         "note":"Have upgraded booth",
         "targetCheck":"boothList",
         "additionalCheck":2,
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"3 New Booths",
         "rewardType":"unlockBuild",
         "rewardValue":["Potion Shop","BBQ","Bowling"],
         "checkEvent":[GameEvent.BUILDING_SUCCESSFULLY_UPGRADE]
      },{
         "note":"Have upgraded handyman",
         "targetCheck":"handymanList",
         "additionalCheck":2,
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Unlock Ex Upgrade",
         "rewardType":"unlockUpgrade",
         "rewardValue":[UpgradeData.ANTI_TERMINE],
         "checkEvent":[HumanEvent.SUCCESFULLY_PROMOTED]
      },{
         "note":"Have an good compatibility combo (&amount of 1)",
         "targetCheck":"haveCombo",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Unlock Ex Upgrade",
         "rewardType":"unlockUpgrade",
         "rewardValue":[UpgradeData.GENIUS_MANAGER,UpgradeData.BASEMENT_II],
         "checkEvent":[GameEvent.BUILDING_CREATED]
      },{
         "note":"Have upgraded guard",
         "targetCheck":"guardList",
         "additionalCheck":2,
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Unlock Ex Upgrade",
         "rewardType":"unlockUpgrade",
         "rewardValue":[UpgradeData.PROHIBITION_SIGN,UpgradeData.GUARD_TOWER],
         "checkEvent":[HumanEvent.SUCCESFULLY_PROMOTED]
      },{
         "note":"Have upgraded elevator",
         "targetCheck":"elevatorList",
         "additionalCheck":2,
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Unlock Ex Upgrade",
         "rewardType":"unlockUpgrade",
         "rewardValue":[UpgradeData.LARGE_ELEVATOR,UpgradeData.STRONG_ROPE],
         "checkEvent":[GameEvent.BUILDING_SUCCESSFULLY_UPGRADE]
      },{
         "note":"Purchase any 3 extra upgrades",
         "targetCheck":"purchasedExtra",
         "targetOpt":">=",
         "targetValue":3,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":750,
         "checkEvent":[GameEvent.PURCHASE_UPGRADE]
      },{
         "note":"Have good compatibility combos (&amount of 2)",
         "targetCheck":"haveCombo",
         "targetOpt":">=",
         "targetValue":2,
         "rewardText":"Unlock Ex Upgrade",
         "rewardType":"unlockUpgrade",
         "rewardValue":[UpgradeData.MAGIC_REPELMENT],
         "checkEvent":[GameEvent.BUILDING_CREATED]
      },{
         "note":"Build any building at 3rd floor",
         "targetCheck":"buildingFloor",
         "additionalCheck":2,
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":800,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Have a lodging room",
         "targetCheck":"innList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Popularity +5%",
         "rewardType":"popularity",
         "rewardValue":5,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Any visitor stay overnight",
         "targetCheck":"staying",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Unlock Ex Upgrade",
         "rewardType":"unlockUpgrade",
         "rewardValue":[UpgradeData.EXPERT_ACCOUNTANT],
         "checkEvent":[GameEvent.GAME_UPDATE]
      },{
         "note":"Have a bath house",
         "targetCheck":"boothByType",
         "additionalCheck":"Bath House",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":500,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Have at least two restroom",
         "targetCheck":"restroomList",
         "targetOpt":">=",
         "targetValue":2,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":500,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Have 10 or more employee",
         "targetCheck":"staffList",
         "additionalCheck":2,
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":800,
         "checkEvent":[GameEvent.HIRE_STAFF,GameEvent.FIRE]
      },{
         "note":"Have a spa",
         "targetCheck":"boothByType",
         "additionalCheck":"Spa",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"Unlock Ex Upgrade",
         "rewardType":"unlockUpgrade",
         "rewardValue":[UpgradeData.BASEMENT_III],
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Counter from wizard spell",
         "targetCheck":"special",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":1000,
         "checkEvent":[HumanEvent.COUNTER_SPELL]
      },{
         "note":"Earn &target G in a day",
         "targetCheck":"profit",
         "targetOpt":">=",
         "targetValue":5000,
         "rewardText":"Build EXP +10%",
         "rewardType":"buildingExpBonus",
         "rewardValue":10,
         "checkEvent":[GameEvent.SHOW_REPORT]
      },{
         "note":"Have at least one trading post",
         "targetCheck":"tradingPostList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":1500,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Catch 5 thieves in one night (&amount of 5)",
         "targetCheck":"special",
         "targetOpt":">=",
         "targetValue":5,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":2000,
         "checkEvent":[GameEvent.ARRESTED],
         "additionalEventCheck":["target is Thief"],
         "resetSpecial":{
            "hour":6,
            "minute":0
         },
         "thiefMod":2.5
      },{
         "note":"Have 3 lodging rooms",
         "targetCheck":"innList",
         "targetOpt":">=",
         "targetValue":3,
         "rewardText":"Popularity +10%",
         "rewardType":"popularity",
         "rewardValue":10,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Visited by 5 special visitor in a day (&amount of 5)",
         "targetCheck":"special",
         "initSpecial":"numberSpecialVisitor",
         "targetOpt":">=",
         "targetValue":5,
         "rewardText":"Unlock Witchcraft",
         "rewardType":"unlockBuild",
         "rewardValue":["Witchcraft"],
         "checkEvent":GameEvent.SPECIAL_VISITOR_COME,
         "resetSpecial":{
            "hour":6,
            "minute":0
         }
      },{
         "note":"Have 5 upgraded booth",
         "targetCheck":"boothList",
         "additionalCheck":2,
         "targetOpt":">=",
         "targetValue":5,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":5000,
         "checkEvent":GameEvent.BUILDING_SUCCESSFULLY_UPGRADE
      },{
         "note":"Have 3 max upgraded booth",
         "targetCheck":"boothList",
         "additionalCheck":3,
         "targetOpt":">=",
         "targetValue":3,
         "rewardText":"Populariy +10%",
         "rewardType":"popularity",
         "rewardValue":10,
         "checkEvent":GameEvent.BUILDING_SUCCESSFULLY_UPGRADE
      },{
         "note":"Build at least 3 building at 3rd floor",
         "targetCheck":"buildingFloor",
         "additionalCheck":3,
         "targetOpt":">=",
         "targetValue":3,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":2500,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Have at least 3 lodging room with full lodger",
         "targetCheck":"fullLodge",
         "targetOpt":">=",
         "targetValue":3,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":3000,
         "checkEvent":GameEvent.GAME_UPDATE
      },{
         "note":"Have 50 visitor in your mall",
         "targetCheck":"visitorList",
         "targetOpt":">=",
         "targetValue":50,
         "rewardText":"Expand area",
         "rewardType":"worldLevel",
         "rewardValue":1,
         "checkEvent":GameEvent.HUMAN_ADDED
      },{
         "note":"Reach 50% popularity",
         "targetCheck":"popularity",
         "targetOpt":">=",
         "targetValue":50,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":8000,
         "checkEvent":GameEvent.UPDATE_POPULARITY
      },{
         "note":"Have good compatibility combos (&amount of 5)",
         "targetCheck":"haveCombo",
         "targetOpt":">=",
         "targetValue":5,
         "rewardText":"Populariy +10%",
         "rewardType":"popularity",
         "rewardValue":10,
         "checkEvent":[GameEvent.BUILDING_CREATED]
      },{
         "note":"Get at least &target G from a single booth a day",
         "targetCheck":"boothIncome",
         "targetOpt":">=",
         "targetValue":1500,
         "rewardText":"Build EXP +15%",
         "rewardType":"buildingExpBonus",
         "rewardValue":15,
         "checkEvent":[GameEvent.SHOW_REPORT]
      },{
         "note":"Catch 5 saboteur in one day (&amount of 5)",
         "targetCheck":"special",
         "targetOpt":">=",
         "targetValue":5,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":2000,
         "checkEvent":[GameEvent.ARRESTED],
         "additionalEventCheck":["target is Saboteur"],
         "resetSpecial":{
            "hour":6,
            "minute":0
         }
      },{
         "note":"Earn &target G in a day",
         "targetCheck":"profit",
         "targetOpt":">=",
         "targetValue":10000,
         "rewardText":"Populariy +15%",
         "rewardType":"popularity",
         "rewardValue":15,
         "checkEvent":[GameEvent.SHOW_REPORT]
      },{
         "note":"Have at least 1 guard post",
         "targetCheck":"guardPostList",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":1000,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Have 75 visitor in your mall",
         "targetCheck":"visitorList",
         "targetOpt":">=",
         "targetValue":50,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":2000,
         "checkEvent":GameEvent.HUMAN_ADDED
      },{
         "note":"Catch 10 thieves in one night (&amount of 10)",
         "targetCheck":"special",
         "targetOpt":">=",
         "targetValue":10,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":5000,
         "checkEvent":[GameEvent.ARRESTED],
         "additionalEventCheck":["target is Thief"],
         "resetSpecial":{
            "hour":6,
            "minute":0
         },
         "thiefMod":2.8
      },{
         "note":"Have 10 upgraded booth",
         "targetCheck":"boothList",
         "additionalCheck":2,
         "targetOpt":">=",
         "targetValue":10,
         "rewardText":"Popularity +15%",
         "rewardType":"cash",
         "rewardValue":15,
         "checkEvent":GameEvent.BUILDING_SUCCESSFULLY_UPGRADE
      },{
         "note":"Have at least 10 entertainers",
         "targetCheck":"entertainerList",
         "targetOpt":">=",
         "targetValue":10,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":3000,
         "checkEvent":[GameEvent.HIRE_STAFF,GameEvent.FIRE]
      },{
         "note":"Have all kind of general store booth",
         "targetCheck":"boothCompletion",
         "additionalCheck":BuildingData.GENERAL,
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":2500,
         "checkEvent":GameEvent.BUILDING_CREATED
      },{
         "note":"Have good compatibility combos (&amount of 8)",
         "targetCheck":"haveCombo",
         "targetOpt":">=",
         "targetValue":8,
         "rewardText":"Populariy +15%",
         "rewardType":"popularity",
         "rewardValue":15,
         "checkEvent":[GameEvent.BUILDING_CREATED]
      },{
         "note":"Have at least 10 stairs",
         "targetCheck":"stairList",
         "targetOpt":">=",
         "targetValue":10,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":2500,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Build at least 3 building at 4th floor",
         "targetCheck":"buildingFloor",
         "additionalCheck":4,
         "targetOpt":">=",
         "targetValue":3,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":3500,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Have 8 max upgraded booth",
         "targetCheck":"boothList",
         "additionalCheck":3,
         "targetOpt":">=",
         "targetValue":8,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":4500,
         "checkEvent":GameEvent.BUILDING_SUCCESSFULLY_UPGRADE
      },{
         "note":"Have 10 max upgraded booth",
         "targetCheck":"boothList",
         "additionalCheck":3,
         "targetOpt":">=",
         "targetValue":10,
         "rewardText":"Populariy +20%",
         "rewardType":"popularity",
         "rewardValue":20,
         "checkEvent":GameEvent.BUILDING_SUCCESSFULLY_UPGRADE
      },{
         "note":"Have all kind of booth",
         "targetCheck":"boothCompletion",
         "targetOpt":">=",
         "targetValue":1,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":5000,
         "checkEvent":GameEvent.BUILDING_CREATED
      },{
         "note":"Have at least 5 max upgraded lodging room",
         "targetCheck":"innList",
         "additionalCheck":3,
         "targetOpt":">=",
         "targetValue":5,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":5000,
         "checkEvent":GameEvent.BUILDING_SUCCESSFULLY_UPGRADE
      },{
         "note":"Earn &target G in a day",
         "targetCheck":"profit",
         "targetOpt":">=",
         "targetValue":20000,
         "rewardText":"Build EXP +15%",
         "rewardType":"buildingExpBonus",
         "rewardValue":15,
         "checkEvent":[GameEvent.SHOW_REPORT]
      },{
         "note":"Upgrade your halte to max level",
         "targetCheck":"halteLevel",
         "targetOpt":">=",
         "targetValue":3,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":2000,
         "checkEvent":GameEvent.BUILDING_SUCCESSFULLY_UPGRADE
      },{
         "note":"Have at least 2 guard post",
         "targetCheck":"guardPostList",
         "targetOpt":">=",
         "targetValue":2,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":5000,
         "checkEvent":[GameEvent.BUILDING_CREATED,GameEvent.BUILDING_DESTROYED]
      },{
         "note":"Have at least 6 max upgraded restroom",
         "targetCheck":"restroomList",
         "additionalCheck":3,
         "targetOpt":">=",
         "targetValue":6,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":5000,
         "checkEvent":GameEvent.BUILDING_SUCCESSFULLY_UPGRADE
      },{
         "note":"Catch 15 thieves in one night (&amount of 15)",
         "targetCheck":"special",
         "targetOpt":">=",
         "targetValue":15,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":5000,
         "checkEvent":[GameEvent.ARRESTED],
         "additionalEventCheck":["target is Thief"],
         "resetSpecial":{
            "hour":6,
            "minute":0
         },
         "thiefMod":3
      },{
         "note":"Purchase all extra upgrades",
         "targetCheck":"purchasedExtra",
         "targetOpt":">=",
         "targetValue":UpgradeData.UPGRADE_CODE.length,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":10000,
         "checkEvent":[GameEvent.PURCHASE_UPGRADE]
      },{
         "note":"Catch 15 saboteur in one day (&amount of 15)",
         "targetCheck":"special",
         "targetOpt":">=",
         "targetValue":15,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":5000,
         "checkEvent":[GameEvent.ARRESTED],
         "additionalEventCheck":["target is Saboteur"],
         "resetSpecial":{
            "hour":6,
            "minute":0
         }
      },{
         "note":"Reach 100% popularity",
         "targetCheck":"popularity",
         "targetOpt":">=",
         "targetValue":100,
         "rewardText":"+&reward G",
         "rewardType":"cash",
         "rewardValue":15000,
         "checkEvent":GameEvent.UPDATE_POPULARITY
      },{
         "note":"Have &target G",
         "targetCheck":"cash",
         "targetOpt":">=",
         "targetValue":1000000,
         "rewardText":"Final Mission",
         "rewardType":"finalMission",
         "rewardValue":0,
         "checkEvent":GameEvent.UPDATE_BUDGET
      }];
      
      var _world:World;
      
      var _GUI:UI_InGame;
      
      var _currentProgress:int;
      
      var _checkedVar;
      
      var _missionSet:Boolean;
      
      var _currentSuccess:Boolean;
      
      var _specialCheck:int;
      
      public function Mission()
      {
         super();
         this._currentProgress = 0;
         this._missionSet = false;
         this._currentSuccess = false;
         this._specialCheck = 0;
      }
      
      public static function checkMission(param1:*, param2:*) : Boolean
      {
         var _loc3_:* = false;
         switch(param2.targetOpt)
         {
            case "==":
               _loc3_ = param1 == param2.targetValue;
               break;
            case ">":
               _loc3_ = param1 > param2.targetValue;
               break;
            case "<":
               _loc3_ = param1 < param2.targetValue;
               break;
            case ">=":
               _loc3_ = param1 >= param2.targetValue;
               break;
            case "<=":
               _loc3_ = param1 <= param2.targetValue;
               break;
            case "!=":
               _loc3_ = param1 != param2.targetValue;
         }
         return _loc3_;
      }
      
      function setReward() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = "-";
         if(this.currentProgress in this.MISSION_LIST)
         {
            _loc2_ = this.MISSION_LIST[this.currentProgress].rewardValue;
            _loc1_ = this.MISSION_LIST[this.currentProgress].rewardText;
            if(_loc2_ is Number)
            {
               _loc1_ = _loc1_.replace(/&reward/g,Utility.numberToMoney(_loc2_));
            }
            else
            {
               _loc1_ = _loc1_.replace(/&reward/g,_loc2_);
            }
         }
         this.GUI.rewardPanel.setReward(_loc1_);
      }
      
      function setMission() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.currentProgress in this.MISSION_LIST)
         {
            _loc1_ = this.MISSION_LIST[this.currentProgress].targetValue;
            _loc2_ = this.MISSION_LIST[this.currentProgress].note;
            if(_loc1_ is Number)
            {
               _loc2_ = _loc2_.replace(/&target/g,Utility.numberToMoney(_loc1_));
            }
            else
            {
               _loc2_ = _loc2_.replace(/&target/g,_loc1_);
            }
            if(this.MISSION_LIST[this.currentProgress].targetCheck == "special")
            {
               _loc2_ = _loc2_.replace(/&amount/g,"" + this._specialCheck + "");
            }
            else
            {
               _loc2_ = _loc2_.replace(/&amount/g,"" + this.checkVariableMission(this.MISSION_LIST[this._currentProgress]) + "");
            }
            this.GUI.missionPanel.setMission(_loc2_);
            _loc3_ = this._world.root;
            if(_loc3_.hacked > 0)
            {
               this.GUI.hackedMessage.visible = this.currentProgress > 15;
               this.GUI.hackedMessage.text = _loc3_.hackedMessage;
            }
         }
         else
         {
            this.GUI.missionPanel.setMission("Visit gamesfree.com to play more cool games");
         }
      }
      
      public function runMission() : void
      {
         this._world.addListenerOf(this.GUI,MissionEvent.MISSION_SET,this.missionIsSet);
         this._world.addListenerOf(this.GUI,MissionEvent.SET_NEW_MISSION,this.changeMission);
         this._world.addListenerOf(this._world,MissionEvent.MISSION_SUCCESS,this.whenMissionSuccess);
         this.setMission();
         this.setReward();
      }
      
      function changeMission(param1:MissionEvent) : void
      {
         this._currentSuccess = false;
         ++this._currentProgress;
         if(this._currentProgress in this.MISSION_LIST)
         {
            if(this.MISSION_LIST[this._currentProgress].initSpecial == null)
            {
               this._specialCheck = 0;
            }
            else
            {
               this._specialCheck = this.checkVariable(this.MISSION_LIST[this._currentProgress].initSpecial);
            }
         }
         else
         {
            this._specialCheck = 0;
         }
         this.setMission();
         this.setReward();
      }
      
      function whenMissionSuccess(param1:MissionEvent) : void
      {
         var _loc4_:* = undefined;
         this._missionSet = false;
         this._currentSuccess = true;
         var _loc2_:* = this.MISSION_LIST[this._currentProgress].checkEvent;
         if(_loc2_ is String)
         {
            this._world.removeListenerOf(this._world.stage,_loc2_,this.missionCheck);
         }
         else if(_loc2_ is Array)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.length)
            {
               this._world.removeListenerOf(this._world.stage,_loc2_[_loc4_],this.missionCheck);
               _loc4_++;
            }
         }
         var _loc3_:* = this.MISSION_LIST[this._currentProgress].resetSpecial;
         if(_loc3_ != null)
         {
            this._world.removeListenerOf(this._world.main,GameEvent.GAME_UPDATE,this.resetCheck);
         }
         if(this._currentProgress >= this.MISSION_LIST.length - 1)
         {
            if("missionComplete" in this._world.main.history)
            {
               if(this._world.main.history["missionComplete"] == 0)
               {
                  this._world.main.history["missionComplete"] = 1;
               }
            }
            else
            {
               this._world.main.history["missionComplete"] = 1;
            }
            this._world.dispatchEvent(new AchievementEvent(AchievementEvent.UPDATE_HISTORY,"missionComplete"));
         }
      }
      
      function missionIsSet(param1:MissionEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this._currentProgress in this.MISSION_LIST)
         {
            if(!this.successMission())
            {
               _loc2_ = this.MISSION_LIST[this._currentProgress].checkEvent;
               if(_loc2_ is String)
               {
                  this._world.addListenerOf(this._world.stage,_loc2_,this.missionCheck);
               }
               else if(_loc2_ is Array)
               {
                  _loc4_ = 0;
                  while(_loc4_ < _loc2_.length)
                  {
                     this._world.addListenerOf(this._world.stage,_loc2_[_loc4_],this.missionCheck);
                     _loc4_++;
                  }
               }
               _loc3_ = this.MISSION_LIST[this._currentProgress].resetSpecial;
               if(_loc3_ != null)
               {
                  this._world.addListenerOf(this._world.main,GameEvent.GAME_UPDATE,this.resetCheck);
               }
               this._missionSet = true;
            }
            else
            {
               this._world.dispatchEvent(new MissionEvent(MissionEvent.MISSION_SUCCESS));
            }
         }
         else
         {
            this.GUI.missionPanel.setLinkable();
         }
      }
      
      function checkAdditionalEventCheck(param1:Event, param2:*) : Boolean
      {
         var _loc3_:* = false;
         var _loc4_:* = param1.target;
         if(param2 != null)
         {
            switch(param2)
            {
               case "target is Thief":
                  _loc3_ = _loc4_ is Thief;
                  break;
               case "target is Saboteur":
                  _loc3_ = _loc4_ is Litter;
            }
         }
         return _loc3_;
      }
      
      function resetCheck(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = this.MISSION_LIST[this._currentProgress].resetSpecial;
         if(_loc2_ != null)
         {
            _loc3_ = param1.tag;
            if(_loc3_.hour == _loc2_.hour && _loc3_.minute == _loc2_.minute)
            {
               if(this.MISSION_LIST[this._currentProgress].initSpecial == null)
               {
                  this._specialCheck = 0;
               }
               else
               {
                  this._specialCheck = this.checkVariable(this.MISSION_LIST[this._currentProgress].initSpecial);
               }
               _loc4_ = this.MISSION_LIST[this.currentProgress].targetValue;
               _loc5_ = this.MISSION_LIST[this.currentProgress].note;
               if(_loc4_ is Number)
               {
                  _loc5_ = _loc5_.replace(/&target/g,Utility.numberToMoney(_loc4_));
               }
               else
               {
                  _loc5_ = _loc5_.replace(/&target/g,_loc4_);
               }
               if(this.MISSION_LIST[this.currentProgress].targetCheck == "special")
               {
                  _loc5_ = _loc5_.replace(/&amount/g,"" + this._specialCheck + "");
               }
               else
               {
                  _loc5_ = _loc5_.replace(/&amount/g,"" + this.checkVariableMission(this.MISSION_LIST[this._currentProgress]) + "");
               }
               this.GUI.missionPanel.changeText(_loc5_);
            }
         }
      }
      
      function missionCheck(param1:Event) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = this.MISSION_LIST[this.currentProgress].note;
         var _loc3_:* = this.MISSION_LIST[this.currentProgress].targetValue;
         if(_loc3_ is Number)
         {
            _loc2_ = _loc2_.replace(/&target/g,Utility.numberToMoney(_loc3_));
         }
         else
         {
            _loc2_ = _loc2_.replace(/&target/g,_loc3_);
         }
         if(this.MISSION_LIST[this.currentProgress].targetCheck == "special")
         {
            _loc4_ = this.MISSION_LIST[this.currentProgress].checkEvent.indexOf(param1.type);
            _loc5_ = this.MISSION_LIST[this.currentProgress].additionalEventCheck;
            _loc6_ = null;
            if(_loc5_ != null)
            {
               if(_loc4_ in _loc5_)
               {
                  _loc6_ = _loc5_[_loc4_];
               }
            }
            if(_loc6_ == null || this.checkAdditionalEventCheck(param1,_loc6_))
            {
               ++this._specialCheck;
               _loc2_ = _loc2_.replace(/&amount/g,"" + this._specialCheck + "");
               this.GUI.missionPanel.changeText(_loc2_);
            }
         }
         else
         {
            _loc2_ = _loc2_.replace(/&amount/g,"" + this.checkVariableMission(this.MISSION_LIST[this._currentProgress]) + "");
            this.GUI.missionPanel.changeText(_loc2_);
         }
         if(this.successMission())
         {
            this._world.dispatchEvent(new MissionEvent(MissionEvent.MISSION_SUCCESS));
         }
      }
      
      function checkVariable(param1:*) : *
      {
         var _loc2_:* = this.MISSION_LIST[this._currentProgress];
         var _loc3_:* = 0;
         switch(param1)
         {
            case "boothList":
               if(_loc2_.additionalCheck != null)
               {
                  _loc3_ = this.countBuildingWithLevel(_loc2_.additionalCheck,this._world.boothList);
               }
               else
               {
                  _loc3_ = this._world.boothList.length;
               }
               break;
            case "innList":
               if(_loc2_.additionalCheck != null)
               {
                  _loc3_ = this.countBuildingWithLevel(_loc2_.additionalCheck,this._world.innList);
               }
               else
               {
                  _loc3_ = this._world.innList.length;
               }
               break;
            case "boothByType":
               if(_loc2_.additionalCheck != null)
               {
                  if(_loc2_.additionalCheck in this._world.boothListByType)
                  {
                     _loc3_ = this._world.boothListByType[_loc2_.additionalCheck].length;
                  }
                  else
                  {
                     _loc3_ = 0;
                  }
               }
               else
               {
                  _loc3_ = 0;
               }
               break;
            case "staying":
               _loc3_ = this.getStayingVisitor();
               break;
            case "buildingFloor":
               if(_loc2_.additionalCheck != null)
               {
                  _loc3_ = this.getNumberBuildAtFloor(_loc2_.additionalCheck);
               }
               else
               {
                  _loc3_ = 0;
               }
               break;
            case "elevatorList":
               if(_loc2_.additionalCheck != null)
               {
                  _loc3_ = this.countBuildingWithLevel(_loc2_.additionalCheck,this._world.elevatorList);
               }
               else
               {
                  _loc3_ = this._world.elevatorList.length;
               }
               break;
            case "stairList":
               _loc3_ = this._world.stairList.length;
               break;
            case "restroomList":
               if(_loc2_.additionalCheck != null)
               {
                  _loc3_ = this.countBuildingWithLevel(_loc2_.additionalCheck,this._world.restRoomList);
               }
               else
               {
                  _loc3_ = this._world.restRoomList.length;
               }
               break;
            case "tradingPostList":
               _loc3_ = this._world.tradingPostList.length;
               break;
            case "janitorList":
               if(_loc2_.additionalCheck == null)
               {
                  _loc3_ = this.countStaff("janitor");
               }
               else
               {
                  _loc3_ = this.countStaff("janitor",_loc2_.additionalCheck);
               }
               break;
            case "handymanList":
               if(_loc2_.additionalCheck == null)
               {
                  _loc3_ = this.countStaff("handyman");
               }
               else
               {
                  _loc3_ = this.countStaff("handyman",_loc2_.additionalCheck);
               }
               break;
            case "entertainerList":
               if(_loc2_.additionalCheck == null)
               {
                  _loc3_ = this.countStaff("entertainer");
               }
               else
               {
                  _loc3_ = this.countStaff("entertainer",_loc2_.additionalCheck);
               }
               if(this._world.main.unlockedStaff.indexOf("entertainer") < 0)
               {
                  this._world.main.unlockedStaff.push("entertainer");
                  this._world.main.dispatchEvent(new GameEvent(GameEvent.UNLOCK_NEW_BUILDING));
               }
               break;
            case "guardList":
               if(_loc2_.additionalCheck == null)
               {
                  _loc3_ = this.countStaff("guard");
               }
               else
               {
                  _loc3_ = this.countStaff("guard",_loc2_.additionalCheck);
               }
               break;
            case "staffList":
               _loc3_ = this.countStaff("janitor") + this.countStaff("handyman") + this.countStaff("entertainer") + this.countStaff("guard");
               break;
            case "visitorList":
               _loc3_ = this._world.currentVisitorList.length;
               break;
            case "profit":
               _loc3_ = this.GUI.statisticPanel.statistic.totalProfit;
               break;
            case "purchasedExtra":
               _loc3_ = this._world.numberPurchasedExtraUpgrade;
               break;
            case "special":
               _loc3_ = this._specialCheck;
               break;
            case "haveCombo":
               _loc3_ = this._world.countCombo(true);
               break;
            case "numberSpecialVisitor":
               _loc3_ = this._world.countCurrentSpecialVisitor();
               break;
            case "fullLodge":
               _loc3_ = this.countFullLodge();
               break;
            case "popularity":
               _loc3_ = this._world.popularity;
               break;
            case "boothIncome":
               _loc3_ = this.getHighestIncome(this.GUI.statisticPanel.statistic);
               break;
            case "guardPostList":
               _loc3_ = this._world.guardPostList.length;
               break;
            case "boothCompletion":
               if(_loc2_.additionalCheck == null)
               {
                  _loc3_ = this.checkBoothCompletion();
               }
               else
               {
                  _loc3_ = this.checkBoothCompletion(_loc2_.additionalCheck);
               }
               break;
            case "halteLevel":
               _loc3_ = this._world.halte.level;
               break;
            case "cash":
               _loc3_ = this._world.main.budget;
         }
         return _loc3_;
      }
      
      function checkBoothCompletion(param1:String = "") : int
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = false;
         if(!_loc3_)
         {
            _loc4_ = 0;
            while(_loc4_ < BuildingData.BUILDING_LIST.length)
            {
               _loc5_ = BuildingData.BUILDING_LIST[_loc4_];
               if((_loc6_ = BuildingData.getCategoryOf(_loc5_)) != BuildingData.FACILITY)
               {
                  if(param1 == "" || param1 == _loc6_)
                  {
                     if(!(_loc5_ in this._world.boothListByType))
                     {
                        _loc3_ = true;
                        break;
                     }
                     if(this._world.boothListByType[_loc5_].length == 0)
                     {
                        _loc3_ = true;
                        break;
                     }
                  }
               }
               _loc4_++;
            }
         }
         if(!_loc3_)
         {
            _loc2_ = 1;
         }
         return _loc2_;
      }
      
      function getHighestIncome(param1:Statistic) : int
      {
         var _loc4_:StatisticItem = null;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(_loc3_ < param1.boothStatistic.length)
         {
            if((_loc4_ = param1.boothStatistic[_loc3_] as StatisticItem) != null)
            {
               _loc2_ = Math.max(_loc2_,_loc4_.revenue);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      function checkVariableMission(param1:*) : *
      {
         var _loc2_:* = 0;
         return this.checkVariable(param1.targetCheck);
      }
      
      public function countFullLodge() : int
      {
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this._world.innList.length)
         {
            _loc3_ = this._world.innList[_loc2_];
            if(_loc3_.isFull)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getStayingVisitor() : int
      {
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this._world.currentVisitorList.length)
         {
            _loc3_ = this._world.currentVisitorList[_loc2_];
            if(_loc3_.stayingAt != null)
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function countBuildingWithLevel(param1:int, param2:*) : int
      {
         var _loc5_:* = undefined;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < param2.length)
         {
            if((_loc5_ = param2[_loc4_]).level >= param1)
            {
               _loc3_++;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getNumberBuildAtFloor(param1:int) : int
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         while(_loc3_ < this._world.buildingList.length)
         {
            if(!((_loc4_ = this._world.buildingList[_loc3_]) is FacilityElevatorBody))
            {
               if((_loc5_ = this._world.getFloorAt(_loc4_.y)) != null)
               {
                  if((_loc6_ = this._world.floorList.indexOf(_loc5_)) == param1)
                  {
                     _loc2_++;
                  }
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function countStaff(param1:*, param2:int = 1) : Number
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc3_:* = 0;
         if(param1 in this._world.staffList)
         {
            _loc4_ = 0;
            while(_loc4_ < this._world.staffList[param1].length)
            {
               if((_loc5_ = this._world.staffList[param1][_loc4_]).level >= param2)
               {
                  if(this._world.staffList.unshown.indexOf(_loc5_) < 0)
                  {
                     _loc3_++;
                  }
               }
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      function successMission() : Boolean
      {
         var _loc1_:* = false;
         var _loc2_:* = this.checkVariableMission(this.MISSION_LIST[this._currentProgress]);
         return checkMission(_loc2_,this.MISSION_LIST[this._currentProgress]);
      }
      
      public function set currentProgress(param1:int) : void
      {
         this._currentProgress = param1;
      }
      
      public function get currentProgress() : int
      {
         return this._currentProgress;
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
      
      public function set GUI(param1:UI_InGame) : void
      {
         this._GUI = param1;
      }
      
      public function get GUI() : UI_InGame
      {
         return this._GUI;
      }
      
      public function set specialCheck(param1:int) : void
      {
         this._specialCheck = param1;
      }
      
      public function get specialCheck() : int
      {
         return this._specialCheck;
      }
      
      public function get rewardType() : String
      {
         return this.MISSION_LIST[this._currentProgress].rewardType;
      }
      
      public function get reward() : *
      {
         return this.MISSION_LIST[this._currentProgress].rewardValue;
      }
      
      public function get thiefMod() : *
      {
         if(this._currentProgress in this.MISSION_LIST)
         {
            return this.MISSION_LIST[this._currentProgress].thiefMod;
         }
         return null;
      }
      
      public function get currentSuccess() : Boolean
      {
         return this._currentSuccess;
      }
      
      public function get missionSet() : Boolean
      {
         return this._missionSet;
      }
   }
}
