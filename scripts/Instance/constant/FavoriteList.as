package Instance.constant
{
   import Instance.modules.Calculate;
   
   public class FavoriteList
   {
      
      public static const VISITOR_MODEL_LIST = ["littleboy1","littleboy2","nobleman","commonerMale","artistMale","viking","oldman1","oldman2","priest","noblewoman1","noblewoman2","noblewoman3","littlegirl1","littlegirl2","oldLadyNoble","oldLadyCommon"];
      
      public static const VISITOR_FAVORITE_LIST = [[{
         "target":"Bowling",
         "chance":40
      },{
         "target":"Beastiary",
         "chance":30
      },{
         "target":"BBQ",
         "chance":10
      },{
         "target":"Armory",
         "chance":10
      }],[{
         "target":"Fruit Stall",
         "chance":40
      },{
         "target":"Beastiary",
         "chance":30
      },{
         "target":"Eatery",
         "chance":10
      },{
         "target":"Weaponry",
         "chance":10
      }],[{
         "target":"Eatery",
         "chance":30
      },{
         "target":"Weaponry",
         "chance":30
      },{
         "target":"Pottery",
         "chance":20
      },{
         "target":"Wagon",
         "chance":10
      }],[{
         "target":"Armory",
         "chance":30
      },{
         "target":"Beastiary",
         "chance":30
      },{
         "target":"Colloseum",
         "chance":20
      },{
         "target":"Tavern",
         "chance":10
      }],[{
         "target":"Blacksmith",
         "chance":30
      },{
         "target":"BBQ",
         "chance":30
      },{
         "target":"Live Stock",
         "chance":20
      },{
         "target":"Barbershop",
         "chance":10
      }],[{
         "target":"Tavern",
         "chance":40
      },{
         "target":"Weaponry",
         "chance":30
      },{
         "target":"BBQ",
         "chance":10
      },{
         "target":"Blacksmith",
         "chance":10
      }],[{
         "target":"Live Stock",
         "chance":30
      },{
         "target":"BBQ",
         "chance":30
      },{
         "target":"Soup",
         "chance":20
      },{
         "target":"Butcher",
         "chance":10
      }],[{
         "target":"Brewery",
         "chance":30
      },{
         "target":"Gem Shop",
         "chance":30
      },{
         "target":"Medicine",
         "chance":20
      },{
         "target":"Book Store",
         "chance":10
      }],[{
         "target":"Book Store",
         "chance":40
      },{
         "target":"Potion Shop",
         "chance":30
      },{
         "target":"Eatery",
         "chance":10
      },{
         "target":"Colloseum",
         "chance":10
      }],[{
         "target":"Music Hall",
         "chance":30
      },{
         "target":"Wardrobe",
         "chance":40
      },{
         "target":"Soup",
         "chance":10
      },{
         "target":"Pottery",
         "chance":10
      }],[{
         "target":"Wardrobe",
         "chance":20
      },{
         "target":"Book Store",
         "chance":40
      },{
         "target":"Jewellry",
         "chance":10
      },{
         "target":"Music Hall",
         "chance":10
      }],[{
         "target":"Jewellry",
         "chance":30
      },{
         "target":"Spa",
         "chance":20
      },{
         "target":"Bath House",
         "chance":20
      },{
         "target":"Eatery",
         "chance":10
      }],[{
         "target":"Snack",
         "chance":40
      },{
         "target":"Music Hall",
         "chance":30
      },{
         "target":"Wardrobe",
         "chance":10
      },{
         "target":"Jewellry",
         "chance":10
      }],[{
         "target":"Pottery",
         "chance":40
      },{
         "target":"Fortune Teller",
         "chance":30
      },{
         "target":"Snack",
         "chance":10
      },{
         "target":"Barbershop",
         "chance":10
      }],[{
         "target":"Furniture",
         "chance":30
      },{
         "target":"Medicine",
         "chance":30
      },{
         "target":"Spa",
         "chance":10
      },{
         "target":"Wardrobe",
         "chance":10
      }],[{
         "target":"Fortune Teller",
         "chance":30
      },{
         "target":"Witchcraft",
         "chance":20
      },{
         "target":"Furniture",
         "chance":20
      },{
         "target":"Gem Shop",
         "chance":20
      }]];
       
      
      public function FavoriteList()
      {
         super();
      }
      
      public static function getRandomFavorite(param1:*) : String
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc2_:* = "(none)";
         if(Calculate.chance(60))
         {
            _loc3_ = VISITOR_MODEL_LIST.indexOf(param1.model);
            _loc4_ = null;
            if(_loc3_ in VISITOR_FAVORITE_LIST)
            {
               _loc4_ = VISITOR_FAVORITE_LIST[_loc3_];
            }
            if(_loc4_ != null)
            {
               _loc5_ = 0;
               _loc6_ = 0;
               while(_loc6_ < _loc4_.length)
               {
                  _loc11_ = _loc4_[_loc6_];
                  _loc5_ += _loc11_.chance;
                  _loc6_++;
               }
               _loc7_ = Math.max(100,_loc5_);
               _loc8_ = Math.random() * _loc7_;
               _loc9_ = 0;
               _loc10_ = -1;
               _loc6_ = 0;
               while(_loc6_ < _loc4_.length)
               {
                  _loc11_ = _loc4_[_loc6_];
                  if(_loc8_ < _loc9_ + _loc11_.chance)
                  {
                     _loc10_ = _loc6_;
                     break;
                  }
                  _loc9_ += _loc11_.chance;
                  _loc6_++;
               }
               if(_loc10_ in _loc4_)
               {
                  _loc2_ = _loc4_[_loc10_].target;
               }
            }
         }
         else if((_loc13_ = (_loc12_ = BuildingData.BUILDING_LIST.concat())[Math.floor(Math.random() * _loc12_.length)]) != "Lodge")
         {
            if((_loc14_ = BuildingData.getCategoryOf(_loc13_)) != BuildingData.FACILITY)
            {
               _loc2_ = _loc13_;
            }
         }
         return _loc2_;
      }
   }
}
