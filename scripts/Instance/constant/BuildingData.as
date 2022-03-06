package Instance.constant
{
   import Instance.modules.Utility;
   import Instance.property.BoothColloseum;
   import Instance.property.BoothEatery;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityGuardPost;
   import Instance.property.FacilityRestRoom;
   import Instance.property.FacilityStairs;
   import Instance.property.FacilityTerrace;
   import Instance.property.FacilityTradingPost;
   
   public class BuildingData
   {
      
      public static const GENERAL = "buildingTypeGeneralStore";
      
      public static const FOOD = "buildingTypeFoodCenter";
      
      public static const INN = "buildingTypeInn";
      
      public static const ENTERTAINMENT = "buildingTypeEntertainment";
      
      public static const FACILITY = "buildingTypeFacility";
      
      public static const SALE = "buildingModeSale";
      
      public static const SERVICE = "buildingModeService";
      
      public static const ENTRY = "buildingModeEntry";
      
      public static const TRANSPORT = "buildingModeTransport";
      
      public static const OTHER = "buildingModeOther";
      
      public static const BUILDING_LIST = ["Book Store","Fortune Teller","Jewellry","Pottery","Medicine","Potion Shop","Blacksmith","Gem Shop","Barbershop","Armory","Wardrobe","Weaponry","Witchcraft","Beastiary","Live Stock","Furniture","Wagon","Fruit Stall","Butcher","Snack","Soup","BBQ","Brewery","Eatery","Tavern","Lodge","Bath House","Spa","Bowling","Music Hall","Colloseum","Restroom","Stairs","Elevator","Trading Post","Terrace","Guard Post"];
      
      public static const BUILDING_CATEGORY = [GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,GENERAL,FOOD,FOOD,FOOD,FOOD,FOOD,FOOD,FOOD,FOOD,INN,INN,INN,ENTERTAINMENT,ENTERTAINMENT,ENTERTAINMENT,FACILITY,FACILITY,FACILITY,FACILITY,FACILITY,FACILITY];
      
      public static const POPULARITY_UNLOCK = [-1,10,10,10,-1,-1,30,30,0,30,0,0,-1,35,35,40,40,0,0,-1,20,-1,30,40,45,20,-1,-1,-1,45,-1,0,-1,0,20,35,-1];
      
      public static const BUILDING_SERVE_MODE = [SALE,SERVICE,SALE,SALE,SALE,SALE,SALE,SALE,SERVICE,SALE,SALE,SALE,SALE,SALE,SALE,SALE,SALE,SALE,SALE,SALE,SALE,SALE,SALE,SALE,SALE,OTHER,ENTRY,SERVICE,ENTRY,ENTRY,ENTRY,OTHER,TRANSPORT,TRANSPORT,SERVICE,OTHER,OTHER];
      
      public static const BUILDING_COST = [[4000,3000,5000],[3000,2250,3750],[6000,4500,7500],[4000,3000,5000],[8000,6000,10000],[8000,6000,10000],[10000,7500,12500],[15000,12000,18500],[7500,5500,9500],[10000,7500,12500],[10000,7500,12500],[12000,9000,15000],[12000,9000,15000],[20000,15000,25000],[18000,13500,22500],[24000,15000,25000],[25000,18000,32000],[3000,2250,3750],[4000,3000,5000],[3000,2250,3750],[4000,3000,5000],[10000,7500,12500],[12000,9000,15000],[12000,9000,15000],[20000,15000,25000],[8000,6000,1000],[12000,9000,15000],[15000,12000,18500],[10000,7500,12500],[22000,16500,27500],[28000,21000,35000],[1000,750,1250],[500],[2500,2000,3000],[4500,3000,5000],[800],[2500]];
      
      public static const CAPACITY_LIST = [[3,4,5],[Infinity,Infinity,Infinity],[3,4,5],[3,4,5],[5,7,9],[5,7,9],[5,7,9],[5,7,9],[Infinity,Infinity,Infinity],[5,7,9],[5,7,9],[5,7,9],[5,7,9],[8,11,14],[8,11,14],[8,11,14],[8,11,14],[3,4,5],[3,4,5],[3,4,5],[3,4,5],[5,7,9],[5,7,9],[5,7,9],[8,11,14],[3,4,5],[2,3,5],[5,5,5],[5,7,9],[8,12,16],[8,12,16],[3,4,5],[Infinity],[10,15,20],[Infinity,Infinity,Infinity],[8],[1]];
      
      public static const PRICE_LIST = [[1,2,3,4,5,6],[50],[7,8,9,11,12,18],[5,6,7,9,10,16],[5,6,10,11,16,17],[5,6,10,11,16,17],[7,8,14,15,19,20],[7,8,14,15,19,20],[90,92,94,98,100],[7,8,14,15,19,20],[5,6,10,11,16,17],[7,8,14,15,19,20],[9,10,11,14,15,20],[15,16,20,23],[15,16,20,23],[15,20,22,23],[20,25,28,30],[1,2,3,4,5,6],[5,6,7,9,10,15],[3,4,6,10,11,15],[3,4,6,10,11,15],[5,6,9,10,15,16],[5,6,9,10,15,16],[5,6,9,10,15,16],[7,8,12,14,20,23],[180],[90],[100],[80],[120],[180],[0],[0],[0],[0],[0],[0]];
      
      public static var ITEM_TRESHOLD = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
      
      public static const SERVICE_TIME = [0,15,0,0,0,0,0,0,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,45,0,0,0,0,0,0,0,0,0,0,0,0];
      
      public static const SERVICE_REDUCTION = [0,3,0,0,0,0,0,0,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,0,0,0,0,0,0,0,0,0,0,0,0];
      
      public static const MOOD_GAIN_MODIFIER = [0.8,1,1,0.6,1,1,0.8,1.2,1.8,0.8,0.8,0.8,1.2,1.4,1,1.3,1,1,1,1,1,1.2,1.4,1.5,1.6,1,2.4,2.2,2.8,2.8,3.2,0,0,0,0,2,0];
      
      public static const MOOD_LOSS_MODIFIER = [0.4,0.4,1.5,0.3,1,1,0.4,1.5,2.1,0.4,0.4,0.4,0.8,0.8,1,0.9,0.8,0.5,0.5,0.5,0.5,0.8,1,1.2,1.6,0,3.2,2.4,1.5,1.5,1.8,0,0,0,0.6,0,0];
      
      public static const BUILDING_ICON_CODE = ["booth - book store","booth - fortune teller","booth - jewelry","booth - pottery","booth - medicine","booth - potion","booth - blacksmith","booth - gem shop","booth - barber","booth - armory","booth - wardrobe","booth - weaponry","booth - witchcraft","booth - beastiary","booth - live stock","booth - furniture","booth - wagon","food - fruit shop","food - butcher","food - snack","food - soup","food - baberque","food - brewery","food - eatry","food - tavern","inn - room","inn - bath house","inn - spa","entertainment - bowling","entertainment - music hall","entertainment - colloseum","facility - rest room","facility - stairs","facility - elevator","facility - trading post","facility - terrace","guardpost"];
      
      public static const BUILDING_SYMBOL_CODE = ["bookstore","fortuneteller","jewelry","pottery","medicine","potion","blacksmith","gemshop","barbershop","armory","wardrobe","weaponry","witchcraft","beastiary","livestock","furniture","wagon","fruit","butcher","snack","soup","baberque","brewery","eatry","tavern","room","bathhouse","spa","bowling","musichall","colloseum","restroom","stairs","elevator","tradingpost","terrace","guardpost"];
      
      public static const BUILDING_CLASS = [BoothBookstore,BoothFortuneTeller,BoothJewellry,BoothPottery,BoothMedicine,BoothPotion,BoothBlackSmith,BoothGemShop,BoothBarberShop,BoothArmory,BoothWardrobe,BoothWeaponry,BoothWitchCraft,BoothBeastiary,BoothLivestock,BoothFurniture,BoothWagon,BoothFruitStall,BoothButcher,BoothSnack,BoothSoup,BoothBBQ,BoothBrewery,BoothEatery,BoothTavern,BoothLodging,BoothBathHouse,BoothSpa,BoothBowling,BoothMusicHall,BoothColloseum,FacilityRestRoom,FacilityStairs,FacilityElevatorBody,FacilityTradingPost,FacilityTerrace,FacilityGuardPost];
      
      public static const SHOPKEEPER_TYPE = [[["shopkeeperBreadman"]],[["shopkeeperHoodie"]],[["shopkeeperGirl"]],[["shopkeeperHatboy"]],[["shopkeeperGirl"]],[["shopkeeperHoodie"]],[["shopkeeperBreadman"]],[["noblewoman2"]],[["shopkeeperMan","shopkeeperOldman","shopkeeperBreadman"]],[["shopkeeperOldman"]],[["shopkeeperWoman"]],[["shopkeeperBreadman"]],[["shopkeeperHoodie"]],[["shopkeeperMan"]],[["shopkeeperHatboy"]],[["nobleman","shopkeeperBreadman"],[],["commonerMale"]],[["shopkeeperHatboy"]],[["shopkeeperWoman"]],[["shopkeeperBreadman"]],[["shopkeeperWoman"]],[["shopkeeperWoman"]],[["shopkeeperHatboy"]],[["shopkeeperWoman"]],[["shopkeeperBreadman","shopkeeperBreadman"]],[["shopkeeperMan","shopkeeperWoman"],["shopkeeperGirl"],["shopkeeperBreadman"]],null,null,[["shopkeeperGirl","shopkeeperGirl","shopkeeperHatboy"]],[["shopkeeperBreadman"]],[["shopkeeperBreadman","littlegirl1","shopkeeperHatboy"]],[["shopkeeperBreadman","shopkeeperBreadman"],["shopkeeperBreadman","shopkeeperBreadman"]],null,null,null,[["shopkeeperBreadman"]],null,null];
      
      public static const ENTERANCE_RANGE = [25,10,0,20,70,70,85,0,50,0,0,80,90,140,140,140,140,0,0,0,0,0,0,0,0,0,0,80,20,80,80,0,0,0,0,120,0];
      
      public static const BUILD_DESCRIPTION = ["Sell magazine, poetry, novel, newspapper and many kind of books.","The place to consult about future of finance, fate, love and talent.","Sell necklace, ring, bracelet and earring just for fashion.","Sell jar, pot and artistic statue.","Sell herbal medicine and antidote that use for medical treatment.","Sell chemistry item that use for bomb or wierd effect.","Make raw material made from iron to a usable weapon, armor or another tool.","Sell gemstone that believed has special power on it.","The place to change hair model and change the style.","Sell usable armor, war helmet, iron glove and greaves.","Sell cloth and leather armor. Also sell hat, glove and shoes","Sell usable sword, knife, staff, bow, axe and hammer.","Sell item that was used for sorcery. Also sell voodoo doll.","Sell familiar and beast to support fighter in hunting.","Sell farming item and animal for farming.","Sell chair, table, mirror, closet and shelf.","Sell and make body part of wagon. Also sell raw wood material.","Sell fresh fruit likes apple, orange, banana and grapes.","Sell fresh meat of beef, pork and chicken.","Sell bread and cookies.","Sell gravy and sauced food.","Sell roast and grilled meat.","Sell wine and alcoholic drinks.","Casual restaurant that sell many kind of food.","Place for spent time before or after quest. Delicious food provided.","Visitors may stay here overnight instead of going home to keep their good mood at the next day.","Relaxment place with hot spring.","Relaxment place to get a massage for body treatment.","A place where visitors want to exercise.","A place for music lover to hear beautiful music.","A battleground for fighter contest. Unbreakable.","Support building. Visitors don\'t need to leave mall when they need to go.","Support building. Connection between two floors. People still need to walk. This building is unupgradeable.","Support building. Connection between multiple floors. Faster then stairs but limited capacity.","Support building. Visitors don\'t need to leave mall when their money has run out. They can refill here.","Support building. Visitors might stay here when they have no destination to regain some mood. This building is unupgradeable.","Place additioal golden knight to guard your mall. The knight standby in guard post. Only allowed one in one floor. This building is unupgradeable"];
      
      public static const UPGRADE_DESCRIPTION = ["visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might give more tips, visitors gain slightly more mood, damaged progress slower and serving progress faster.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might make more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might give more tips, visitors gain slightly more mood, damaged progress slower and serving progress faster.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more items, damaged progress slower and capacity limit is increased.","visitors might buy more food, damaged progress slower and capacity limit is increased.","visitors might buy more food, damaged progress slower and capacity limit is increased.","visitors might buy more food, damaged progress slower and capacity limit is increased.","visitors might buy more food, damaged progress slower and capacity limit is increased.","visitors might buy more food, damaged progress slower and capacity limit is increased.","visitors might buy more food, damaged progress slower and capacity limit is increased.","visitors might buy more food, damaged progress slower and capacity limit is increased.","visitors might buy more food, damaged progress slower and capacity limit is increased.","visitors might give more tips and capacity limit is increased.","visitors might give more tips, visitors gain more mood and capacity limit is increased.","visitors might give more tips, visitors gain slightly more mood and serving progress faster.","visitors might give more tips, visitors gain more mood, damaged progress slower and capacity limit is increased.","visitors might give more tips, visitors gain more mood, damaged progress slower and capacity limit is increased.","visitors might give more tips, visitors gain more mood and capacity limit is increased.","both male and female room capacity limit is increased.","This building is unupgradeable.","the room moving faster and capacity limit is increased.","serving progress faster and damaged progress slower.","This building is unupgradeable.","This building is unupgradeable."];
      
      public static const SALE_DESCRIPTION = "Visitors might buy more than one items each visit.";
      
      public static const SERVICE_DESCRIPTION = "One time services but visitors might give tips after served.";
      
      public static const ENTRY_DESCRIPTION = "Visitors paid before enter and they might give tips when exit.";
       
      
      public function BuildingData()
      {
         super();
      }
      
      public static function getDescription(param1:String) : String
      {
         var _loc4_:* = undefined;
         var _loc2_:* = "";
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in BUILD_DESCRIPTION)
         {
            _loc2_ += BUILD_DESCRIPTION[_loc3_];
         }
         if(_loc3_ in BUILDING_SERVE_MODE && _loc3_ in BUILDING_CATEGORY)
         {
            if(BUILDING_CATEGORY[_loc3_] != FACILITY)
            {
               if((_loc4_ = BUILDING_SERVE_MODE[_loc3_]) == SALE)
               {
                  _loc2_ += " " + SALE_DESCRIPTION;
               }
               else if(_loc4_ == SERVICE)
               {
                  _loc2_ += " " + SERVICE_DESCRIPTION;
               }
               else if(_loc4_ == ENTRY)
               {
                  _loc2_ += " " + ENTRY_DESCRIPTION;
               }
            }
         }
         return _loc2_;
      }
      
      public static function getUpgradeInfo(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in UPGRADE_DESCRIPTION)
         {
            if(UPGRADE_DESCRIPTION[_loc3_] != "This building is unupgradeable.")
            {
               _loc2_ = "When upgrade " + UPGRADE_DESCRIPTION[_loc3_];
            }
            else
            {
               _loc2_ = UPGRADE_DESCRIPTION[_loc3_];
            }
         }
         return _loc2_;
      }
      
      public static function getPopularityUnlock(param1:String) : Number
      {
         var _loc2_:* = 0;
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in POPULARITY_UNLOCK)
         {
            _loc2_ = POPULARITY_UNLOCK[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getIconListOf(param1:String) : Array
      {
         var _loc2_:* = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < BUILDING_CATEGORY.length)
         {
            if(BUILDING_CATEGORY[_loc3_] == param1)
            {
               if(_loc3_ in BUILDING_ICON_CODE)
               {
                  _loc2_.push(BUILDING_ICON_CODE[_loc3_]);
               }
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function getIconOf(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in BUILDING_ICON_CODE)
         {
            _loc2_ = BUILDING_ICON_CODE[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getBuildingSymbolOf(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in BUILDING_SYMBOL_CODE)
         {
            _loc2_ = BUILDING_SYMBOL_CODE[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getCategoryOf(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in BUILDING_CATEGORY)
         {
            _loc2_ = BUILDING_CATEGORY[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getServeMode(param1:String) : String
      {
         var _loc2_:* = OTHER;
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in BUILDING_SERVE_MODE)
         {
            _loc2_ = BUILDING_SERVE_MODE[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getServiceTime(param1:*) : int
      {
         var _loc2_:* = 0;
         var _loc3_:* = returnClassTo(Utility.getClass(param1));
         var _loc4_:* = BUILDING_LIST.indexOf(_loc3_);
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         if(_loc4_ in SERVICE_TIME)
         {
            _loc5_ = SERVICE_TIME[_loc4_];
         }
         if(_loc4_ in SERVICE_REDUCTION)
         {
            _loc6_ = SERVICE_REDUCTION[_loc4_];
         }
         return _loc5_ - _loc6_ * param1.level;
      }
      
      public static function getCapacity(param1:*) : Number
      {
         var _loc5_:* = undefined;
         var _loc2_:* = 0;
         var _loc3_:* = returnClassTo(Utility.getClass(param1));
         var _loc4_:*;
         if((_loc4_ = BUILDING_LIST.indexOf(_loc3_)) in CAPACITY_LIST)
         {
            if((_loc5_ = param1.level - 1) in CAPACITY_LIST[_loc4_])
            {
               _loc2_ = CAPACITY_LIST[_loc4_][_loc5_];
            }
         }
         return _loc2_;
      }
      
      public static function getBuildingCost(param1:String, param2:int = 0) : Number
      {
         var _loc3_:* = 0;
         var _loc4_:*;
         if((_loc4_ = BUILDING_LIST.indexOf(param1)) in BUILDING_COST)
         {
            if(param2 in BUILDING_COST[_loc4_])
            {
               _loc3_ = BUILDING_COST[_loc4_][param2];
            }
         }
         else
         {
            _loc3_ = Infinity;
         }
         return _loc3_;
      }
      
      public static function getRelocateCost(param1:*) : int
      {
         var _loc2_:* = returnClassTo(Utility.getClass(param1));
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         while(_loc4_ < param1.level)
         {
            _loc3_ += getBuildingCost(_loc2_,_loc4_);
            _loc4_++;
         }
         var _loc5_:* = (_loc4_ - 1) * 0.25;
         return Math.round(_loc3_ + _loc3_ * _loc5_);
      }
      
      public static function getPriceList(param1:String) : Array
      {
         var _loc2_:* = [0];
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in PRICE_LIST)
         {
            _loc2_ = PRICE_LIST[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getMoodGain(param1:String) : Number
      {
         var _loc2_:* = 0;
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in MOOD_GAIN_MODIFIER)
         {
            _loc2_ = MOOD_GAIN_MODIFIER[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getMoodLoss(param1:String) : Number
      {
         var _loc2_:* = 0;
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in MOOD_LOSS_MODIFIER)
         {
            _loc2_ = MOOD_LOSS_MODIFIER[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getItemTreshold(param1:String) : int
      {
         var _loc2_:* = 0;
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in ITEM_TRESHOLD)
         {
            _loc2_ = ITEM_TRESHOLD[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getClassOf(param1:String) : Class
      {
         var _loc2_:* = null;
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in BUILDING_CLASS)
         {
            _loc2_ = BUILDING_CLASS[_loc3_];
         }
         return _loc2_;
      }
      
      public static function returnIconTo(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = BUILDING_ICON_CODE.indexOf(param1);
         if(_loc3_ in BUILDING_LIST)
         {
            _loc2_ = BUILDING_LIST[_loc3_];
         }
         return _loc2_;
      }
      
      public static function returnBuildingSymbolTo(param1:String) : String
      {
         var _loc2_:* = "";
         var _loc3_:* = BUILDING_SYMBOL_CODE.indexOf(param1);
         if(_loc3_ in BUILDING_LIST)
         {
            _loc2_ = BUILDING_LIST[_loc3_];
         }
         return _loc2_;
      }
      
      public static function returnClassTo(param1:Class) : String
      {
         var _loc2_:* = null;
         var _loc3_:* = BUILDING_CLASS.indexOf(param1);
         if(_loc3_ in BUILDING_LIST)
         {
            _loc2_ = BUILDING_LIST[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getShopkeeperOf(param1:String) : Array
      {
         var _loc2_:* = new Array();
         var _loc3_:* = BUILDING_LIST.indexOf(param1);
         if(_loc3_ in SHOPKEEPER_TYPE)
         {
            _loc2_ = SHOPKEEPER_TYPE[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getEnteranceRange(param1:*) : Number
      {
         var _loc2_:* = 0;
         var _loc3_:* = Utility.getClass(param1);
         var _loc4_:*;
         if((_loc4_ = BUILDING_CLASS.indexOf(_loc3_)) in ENTERANCE_RANGE)
         {
            _loc2_ = ENTERANCE_RANGE[_loc4_];
         }
         return _loc2_;
      }
   }
}
