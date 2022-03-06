package Instance.constant
{
   import Instance.gameplay.StaffEntertainer;
   import Instance.gameplay.StaffGuard;
   import Instance.gameplay.StaffHandyman;
   import Instance.gameplay.StaffJanitor;
   import Instance.modules.Utility;
   
   public class HumanData
   {
      
      public static const AVAILABLE_MALE_MODEL = ["littleboy1","littleboy2","nobleman","commonerMale","artistMale","viking","oldman1","oldman2","priest"];
      
      public static const AVAILABLE_FEMALE_MODEL = ["noblewoman1","noblewoman2","noblewoman3","littlegirl1","littlegirl2","oldLadyNoble","oldLadyCommon"];
      
      public static const AVAILABLE_JOB_CLASS = [StaffJanitor,StaffHandyman,StaffEntertainer,StaffGuard];
      
      public static const AVAILABLE_JOB_TYPE = ["Janitor","Handyman","Entertainer","Guard"];
      
      public static const JOB_SALARY = [[30,40,50],[35,50,65],[40,60,80],[45,80,105]];
      
      public static const PROMOTION_INFO = ["That staff also cleans the garbage faster.","That staff also repairs the damaged building faster.","Increase mood gain by visitor and they might give more bonus.","That staff consume less vitality when doing ability."];
      
      public static const STAFF_INFO = ["Keep the mall clean. Higher hygine level make cleaning faster.","Repair the broken booth. Consume very much energy while repairing.","Make the visitor in good mood. If they happy enough sometime they will give a coin. Pick bonus drop in his sight.","Protect the mall from the thief and saboteur. Keep safe your mall."];
      
      public static const AVAILABLE_MALE_NAME = ["Aluin","Archaimbaud","Benediktus","Brennen","Brentan","Devan","Ditmar","Dragan","Elten","Emersen","Ewald","Garryson","Gary","Gill","Giso","Giuseppe","Harald","Herman","Jarred","Jayson","John","Jordan","Kenton","Knut","Lutz","Marius","Marko","Markus","Milton","Nuran","Orvil","Otmar","Ourson","Per","Ransley","Raoul","Roch","Roland","Samir","Santino","Silvius","Sixtus","Stein","Thurmon","Valentin","Waller","Willy","Yadiel","Yasin","York"];
      
      public static const AVAILABLE_FEMALE_NAME = ["Abelia","Buffy","Carina","Carole","Colette","Deasia","Didina","Dionne","Dylan","Edsel","Elyssa","Faithe","Frances","Franja","Geneva","Georgine","Gisele","Golda","Gundula","Ilonka","Janette","Jeanette","Joelyn","Kacie","Kaylyn","Lauretta","Lavernia","Livie","Lorena","Lucille","Mackenzie","Mallorie","Marcelle","Marcelle","Marene","Mateja","Minta","Nikoletta","Pandora","Pierrette","Robin","Sabrina","Salome","Serafina","Solvig","Sonia","Stella","Tania","Velda","Vinka"];
      
      public static const AVAILABLE_FAMILY_NAME = ["Bonesun","Caskbluff","Caskmaul","Clearglade","Cragriver","Cresttree","Crystalglide","Crystalsteel","Dayshine","Dragoncrest","Eagleshine","Evenchaser","Farstrength","Flametail","Fullbringer","Hallowswift","Havenwillow","Hillcloud","Iceward","Laughingwhisk","Mastergleam","Mistriver","Noblewound","Orbgrain","Peacewolf","Phoenixrun","Plainsnow","Ravenwoods","Runesteel","Seahide","Shadeflayer","Shadefury","Silvercreek","Simplespire","Skulldoom","Smartmaw","Softbeam","Spiritridge","Springdew","Stagfollower","Starsplitter","Starthorne","Tuskbough","Twoflower","Wheatbeard","Whitbreaker","Whiteripper","Wildmark","Wisedust","Wyvernlord"];
      
      public static const AVAILABLE_WIZARD_NAME = [];
       
      
      public function HumanData()
      {
         super();
      }
      
      public static function randomModel() : String
      {
         var _loc1_:* = "";
         var _loc2_:* = AVAILABLE_MALE_MODEL.concat(AVAILABLE_FEMALE_MODEL);
         Utility.shuffle(_loc2_);
         return _loc2_.shift();
      }
      
      public static function getGender(param1:String) : int
      {
         var _loc2_:* = 0;
         var _loc3_:* = AVAILABLE_MALE_MODEL.indexOf(param1);
         var _loc4_:* = AVAILABLE_FEMALE_MODEL.indexOf(param1);
         if(_loc3_ >= 0 && _loc4_ < 0)
         {
            _loc2_ = 1;
         }
         else if(_loc3_ < 0 && _loc4_ >= 0)
         {
            _loc2_ = -1;
         }
         else if(_loc3_ >= 0 && _loc4_ >= 0)
         {
            _loc2_ = Math.floor(Math.random() * 2) * 2 - 1;
         }
         return _loc2_;
      }
      
      public static function getJobSalary(param1:*) : int
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = Utility.getClass(param1);
         if(_loc3_ != null)
         {
            if((_loc4_ = AVAILABLE_JOB_CLASS.indexOf(_loc3_)) in JOB_SALARY)
            {
               _loc5_ = JOB_SALARY[_loc4_];
               if(param1.level - 1 in _loc5_)
               {
                  _loc2_ = _loc5_[param1.level - 1];
               }
            }
         }
         return _loc2_;
      }
      
      public static function getStaffInfo(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = AVAILABLE_JOB_TYPE.indexOf(param1);
         if(_loc3_ in STAFF_INFO)
         {
            _loc2_ = STAFF_INFO[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getPromotionInfo(param1:*) : String
      {
         var _loc4_:* = undefined;
         var _loc2_:* = "";
         var _loc3_:* = Utility.getClass(param1);
         if(_loc3_ != null)
         {
            if((_loc4_ = AVAILABLE_JOB_CLASS.indexOf(_loc3_)) in PROMOTION_INFO)
            {
               _loc2_ = "Promoted staff has higher vitality, longer sight and faster movement speed. " + PROMOTION_INFO[_loc4_];
            }
         }
         return _loc2_;
      }
      
      public static function getRandomCharacterName(param1:int) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = new Array();
         if(param1 > 0)
         {
            _loc3_ = AVAILABLE_MALE_NAME.concat();
         }
         else if(param1 < 0)
         {
            _loc3_ = AVAILABLE_FEMALE_NAME.concat();
         }
         else
         {
            _loc3_ = AVAILABLE_MALE_NAME.concat(AVAILABLE_FEMALE_NAME);
         }
         var _loc4_:* = AVAILABLE_FAMILY_NAME.concat();
         Utility.shuffle(_loc3_);
         Utility.shuffle(_loc4_);
         return _loc3_.shift() + " " + _loc4_.shift();
      }
   }
}
