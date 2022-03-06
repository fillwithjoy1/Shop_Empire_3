package Instance.constant
{
   public class AchievementList
   {
      
      public static const ACHIEVEMENT_NAME_LIST = ["A good start","Hail Goondolf!","Clumsy Guard","Shiny Market","Business is Good","Zoo Empire","Nice, Handyman","Mega Market","Special Facility","Happy Mall","Innovative Market","Effective Market","Modern Market","Millionaire","Billionaire","Max Security","Famous Market","Your Highness","Sporty market","Perfect leader"];
      
      public static const ACHIEVEMENT_DESC_LIST = ["Have 10 or more visitors in your mall.","Goondolf cured total 15 visitors.","10 or more thieves that success rob your mall escape.","Visited by 5 special visitors.","50 visitors came to your mall.","20 visitors turned into critter by sorcerer.","Repaired 25 broken or damaged booths.","Have 5 large booths.","Have 12 restroom, trading post and terrace in total","Popularity reach 75% or greater.","Have 15 booths upgraded to maximum.","Have 6 pairs of good-relation-booths.","Have any number elevator with 10 or more room connection in total.","Have 1,000,000 G or more.","Have 10,000,000 G or more.","Catch total 100 thieves and saboteurs in total.","All special visitors have come to your market.","Complete all missions.","Have 10 stairs.","Purchase 17 extra upgrades."];
      
      public static const ACHIEVEMENT_HISTORY_VAR = ["visitor","cureVisitor","escapeThief","specialVisitor","visitor","critter","repair","largeBooth",["restroom","tradingPost","terrace"],"popularity","maxUpgradeBooth","combo","elevator","cash","cash","arrested","specialVisitor","missionComplete","stairs","extraUpgrade"];
      
      public static const ACHIEVEMENT_HISTORY_CHECK = [10,15,10,5,50,20,25,5,12,75,15,6,10,1000000,10000000,100,"allSpecialVisitor",1,10,17];
      
      public static const FRAME_CHECK = ["a-good-start","hail-gundalf","clumsy-security","shiny-market","business-is-good","is-it-a-zoo?","nice,handyman!","mega-market","special-facility","superb-market","innovative-market","effective-market","modern-market","the-milionaire","the-billionaire","max-security","famous-market","your-highness","sporty-market","perfect-leader"];
       
      
      public function AchievementList()
      {
         super();
      }
      
      public static function generateAchievement() : Array
      {
         var _loc3_:* = undefined;
         var _loc1_:* = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < ACHIEVEMENT_NAME_LIST.length)
         {
            _loc3_ = new Object();
            _loc3_.codeName = ACHIEVEMENT_NAME_LIST[_loc2_];
            _loc3_.description = ACHIEVEMENT_DESC_LIST[_loc2_];
            _loc3_.varCheck = ACHIEVEMENT_HISTORY_VAR[_loc2_];
            _loc3_.amountCheck = ACHIEVEMENT_HISTORY_CHECK[_loc2_];
            _loc3_.frameCheck = FRAME_CHECK[_loc2_];
            _loc3_.aquired = false;
            _loc1_.push(_loc3_);
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
