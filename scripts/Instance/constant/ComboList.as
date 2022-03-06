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
   import Instance.property.HalteWagon;
   
   public class ComboList
   {
      
      public static const GROUP_FORGING = [BoothArmory,BoothWeaponry,BoothBlackSmith];
      
      public static const GROUP_SORCERY = [BoothPotion,BoothWitchCraft,BoothFortuneTeller,BoothGemShop];
      
      public static const GROUP_RESTAURANT = [BoothBBQ,BoothBrewery,BoothEatery,BoothTavern];
      
      public static const GROUP_BEAUTY = [BoothWardrobe,BoothBarberShop,BoothJewellry];
      
      public static const GROUP_CRAFT = [BoothFurniture,BoothWagon,BoothPottery];
      
      public static const GROUP_RELAX = [BoothBookstore,BoothMedicine,FacilityTerrace];
      
      public static const GROUP_EXERCISE = [BoothBowling,BoothColloseum,BoothBeastiary];
      
      public static const GROUP_FACILITY = [FacilityElevatorBody,FacilityRestRoom];
      
      public static const GROUP_MARKET = [BoothFruitStall,BoothButcher,BoothLivestock,BoothSoup];
      
      public static const TRADING_POST_EXCEPTION = [FacilityRestRoom,FacilityElevatorBody,FacilityTradingPost,FacilityTerrace,BoothColloseum,HalteWagon,BuildingInnEnterance,FacilityGuardPost,FacilityStairs];
      
      public static const RESTROOM_CONTRAST = {
         "toCheck":[FacilityRestRoom],
         "checkGroup":[GROUP_RESTAURANT]
      };
      
      public static const POISON_CONTRAST = {
         "toCheck":GROUP_SORCERY,
         "checkGroup":[GROUP_RESTAURANT,GROUP_MARKET]
      };
      
      public static const NOISY_CONTRAST = {
         "toCheck":GROUP_RELAX,
         "checkGroup":[GROUP_FORGING,GROUP_EXERCISE]
      };
      
      public static const RIVALY_CONTRAST = {
         "toCheck":GROUP_BEAUTY,
         "checkGroup":[GROUP_CRAFT]
      };
      
      public static const POSITIVE_GROUP_CHECK = [GROUP_FORGING,GROUP_SORCERY,GROUP_RESTAURANT,GROUP_BEAUTY,GROUP_CRAFT,GROUP_RELAX,GROUP_EXERCISE,GROUP_FACILITY,GROUP_MARKET];
      
      public static const NEGATIVE_GROUP_CHECK = [RESTROOM_CONTRAST,POISON_CONTRAST,NOISY_CONTRAST,RIVALY_CONTRAST];
       
      
      public function ComboList()
      {
         super();
      }
      
      public static function checkComboRelation(param1:*, param2:*) : int
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc3_:* = 0;
         var _loc4_:* = Utility.getClass(param1);
         var _loc5_:* = Utility.getClass(param2);
         if(_loc4_ != _loc5_)
         {
            if(_loc4_ == FacilityTradingPost || _loc5_ == FacilityTradingPost)
            {
               _loc6_ = _loc4_ == FacilityTradingPost ? _loc4_ : _loc5_;
               _loc7_ = _loc4_ != FacilityTradingPost ? _loc4_ : _loc5_;
               if(!((_loc8_ = TRADING_POST_EXCEPTION.indexOf(_loc7_)) in TRADING_POST_EXCEPTION))
               {
                  _loc3_ = 1;
               }
            }
            else
            {
               _loc9_ = false;
               _loc10_ = 0;
               while(_loc10_ < POSITIVE_GROUP_CHECK.length)
               {
                  if((_loc11_ = POSITIVE_GROUP_CHECK[_loc10_]).indexOf(_loc4_) >= 0 && _loc11_.indexOf(_loc5_) >= 0)
                  {
                     _loc3_ = 1;
                     _loc9_ = true;
                     break;
                  }
                  _loc10_++;
               }
               _loc10_ = 0;
               while(_loc10_ < NEGATIVE_GROUP_CHECK.length && !_loc9_)
               {
                  _loc12_ = NEGATIVE_GROUP_CHECK[_loc10_];
                  _loc13_ = null;
                  if(_loc12_.toCheck.indexOf(_loc4_) >= 0)
                  {
                     _loc13_ = _loc5_;
                  }
                  else if(_loc12_.toCheck.indexOf(_loc5_) >= 0)
                  {
                     _loc13_ = _loc4_;
                  }
                  if(_loc13_ != null)
                  {
                     _loc14_ = 0;
                     while(_loc14_ < _loc12_.checkGroup.length)
                     {
                        if((_loc15_ = _loc12_.checkGroup[_loc14_]).indexOf(_loc13_) >= 0)
                        {
                           _loc3_ = -1;
                           _loc9_ = true;
                           break;
                        }
                        _loc14_++;
                     }
                  }
                  _loc10_++;
               }
            }
         }
         return _loc3_;
      }
      
      public static function checkComboType(param1:String, param2:String) : int
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc3_:* = 0;
         var _loc4_:* = BuildingData.getClassOf(param1);
         var _loc5_:* = BuildingData.getClassOf(param2);
         if(_loc4_ != _loc5_)
         {
            if(_loc4_ == FacilityTradingPost || _loc5_ == FacilityTradingPost)
            {
               _loc6_ = _loc4_ == FacilityTradingPost ? _loc4_ : _loc5_;
               _loc7_ = _loc4_ != FacilityTradingPost ? _loc4_ : _loc5_;
               if(!((_loc8_ = TRADING_POST_EXCEPTION.indexOf(_loc7_)) in TRADING_POST_EXCEPTION))
               {
                  _loc3_ = 1;
               }
            }
            else
            {
               _loc9_ = false;
               _loc10_ = 0;
               while(_loc10_ < POSITIVE_GROUP_CHECK.length)
               {
                  if((_loc11_ = POSITIVE_GROUP_CHECK[_loc10_]).indexOf(_loc4_) >= 0 && _loc11_.indexOf(_loc5_) >= 0)
                  {
                     _loc3_ = 1;
                     _loc9_ = true;
                     break;
                  }
                  _loc10_++;
               }
               _loc10_ = 0;
               while(_loc10_ < NEGATIVE_GROUP_CHECK.length && !_loc9_)
               {
                  _loc12_ = NEGATIVE_GROUP_CHECK[_loc10_];
                  _loc13_ = null;
                  if(_loc12_.toCheck.indexOf(_loc4_) >= 0)
                  {
                     _loc13_ = _loc5_;
                  }
                  else if(_loc12_.toCheck.indexOf(_loc5_) >= 0)
                  {
                     _loc13_ = _loc4_;
                  }
                  if(_loc13_ != null)
                  {
                     _loc14_ = 0;
                     while(_loc14_ < _loc12_.checkGroup.length)
                     {
                        if((_loc15_ = _loc12_.checkGroup[_loc14_]).indexOf(_loc13_) >= 0)
                        {
                           _loc3_ = -1;
                           _loc9_ = true;
                           break;
                        }
                        _loc14_++;
                     }
                  }
                  _loc10_++;
               }
            }
         }
         return _loc3_;
      }
   }
}
