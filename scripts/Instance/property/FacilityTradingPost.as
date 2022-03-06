package Instance.property
{
   import Instance.constant.UpgradeData;
   import Instance.events.GameEvent;
   
   public class FacilityTradingPost extends Booth
   {
       
      
      const GOLD_DIVIDER = [20,50,100];
      
      public function FacilityTradingPost()
      {
         super();
      }
      
      override function serviceCheckTime(param1:GameEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < _serviceTimeList.length)
         {
            if(_loc2_ in _visitorInService)
            {
               if(_loc2_ in _employeeInPosition)
               {
                  if(_employeeInPosition[_loc2_])
                  {
                     if(_visitorInService[_loc2_] != null)
                     {
                        if(Math.abs(_visitorInService[_loc2_].x - _serviceSpotList[_loc2_].x) == 0)
                        {
                           if(_serviceTimeList[_loc2_] > 0)
                           {
                              --_serviceTimeList[_loc2_];
                           }
                           else if(_serviceTimeList[_loc2_] < 0)
                           {
                              _loc3_ = _visitorInService[_loc2_];
                              _loc4_ = Math.max(0,_loc3_.initialPurse - _loc3_.purse);
                              if(_world.isUpgradePurchased(UpgradeData.BAZAAR_TRADER))
                              {
                                 _loc4_ *= 0.5;
                              }
                              _serviceTimeList[_loc2_] = Math.round(_loc4_ / this.GOLD_DIVIDER[_level - 1]);
                           }
                        }
                        gainExp(0.2 * (this.GOLD_DIVIDER[_level - 1] / 10));
                     }
                     else
                     {
                        _serviceTimeList[_loc2_] = -1;
                     }
                  }
               }
            }
            _loc2_++;
         }
      }
   }
}
