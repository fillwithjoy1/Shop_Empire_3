package Instance.property
{
   import Instance.constant.BuildingData;
   
   public class Statistic
   {
       
      
      var _boothStatistic:Array;
      
      var _buildBuildingStat:StatisticItem;
      
      var _upgradeBuildingStat:StatisticItem;
      
      var _buildingRelocationStat:StatisticItem;
      
      var _hireStaffStat:StatisticItem;
      
      var _promotionStaffStat:StatisticItem;
      
      var _serveranceStaffStat:StatisticItem;
      
      var _staffSallaries:Object;
      
      var _extraUpgradeStat:StatisticItem;
      
      var _miscStat:StatisticItem;
      
      public function Statistic()
      {
         super();
         this._boothStatistic = new Array();
         this._buildBuildingStat = new StatisticItem();
         this._buildBuildingStat.relation = null;
         this._buildBuildingStat.showVisitor = false;
         this._buildBuildingStat.showRevenue = false;
         this._buildBuildingStat.showExpenditure = true;
         this._upgradeBuildingStat = new StatisticItem();
         this._upgradeBuildingStat.relation = null;
         this._upgradeBuildingStat.showVisitor = false;
         this._upgradeBuildingStat.showRevenue = false;
         this._upgradeBuildingStat.showExpenditure = true;
         this._buildingRelocationStat = new StatisticItem();
         this._buildingRelocationStat.relation = null;
         this._buildingRelocationStat.showVisitor = false;
         this._buildingRelocationStat.showRevenue = false;
         this._buildingRelocationStat.showExpenditure = true;
         this._hireStaffStat = new StatisticItem();
         this._hireStaffStat.relation = null;
         this._hireStaffStat.showVisitor = false;
         this._hireStaffStat.showRevenue = false;
         this._hireStaffStat.showExpenditure = true;
         this._promotionStaffStat = new StatisticItem();
         this._promotionStaffStat.relation = null;
         this._promotionStaffStat.showVisitor = false;
         this._promotionStaffStat.showRevenue = false;
         this._promotionStaffStat.showExpenditure = true;
         this._serveranceStaffStat = new StatisticItem();
         this._serveranceStaffStat.relation = null;
         this._serveranceStaffStat.showVisitor = false;
         this._serveranceStaffStat.showRevenue = false;
         this._serveranceStaffStat.showExpenditure = true;
         this._staffSallaries = new Object();
         this._staffSallaries.janitor = new StatisticItem();
         this._staffSallaries.janitor.relation = "Janitor";
         this._staffSallaries.janitor.showVisitor = false;
         this._staffSallaries.janitor.showRevenue = false;
         this._staffSallaries.janitor.showExpenditure = true;
         this._staffSallaries.handyman = new StatisticItem();
         this._staffSallaries.handyman.relation = "Handyman";
         this._staffSallaries.handyman.showVisitor = false;
         this._staffSallaries.handyman.showRevenue = false;
         this._staffSallaries.handyman.showExpenditure = true;
         this._staffSallaries.entertainer = new StatisticItem();
         this._staffSallaries.entertainer.relation = "Entertainer";
         this._staffSallaries.entertainer.showVisitor = false;
         this._staffSallaries.entertainer.showRevenue = false;
         this._staffSallaries.entertainer.showExpenditure = true;
         this._staffSallaries.guard = new StatisticItem();
         this._staffSallaries.guard.relation = "Guard";
         this._staffSallaries.guard.showVisitor = false;
         this._staffSallaries.guard.showRevenue = false;
         this._staffSallaries.guard.showExpenditure = true;
         this._extraUpgradeStat = new StatisticItem();
         this._extraUpgradeStat.relation = null;
         this._extraUpgradeStat.showVisitor = false;
         this._extraUpgradeStat.showRevenue = false;
         this._extraUpgradeStat.showExpenditure = true;
         this._miscStat = new StatisticItem();
         this._miscStat.relation = "Miscellaneous";
         this._miscStat.showVisitor = false;
         this._miscStat.showRevenue = true;
         this._miscStat.showExpenditure = true;
      }
      
      public function get boothStatistic() : Array
      {
         return this._boothStatistic;
      }
      
      public function get buildBuildingStat() : StatisticItem
      {
         return this._buildBuildingStat;
      }
      
      public function get upgradeBuildingStat() : StatisticItem
      {
         return this._upgradeBuildingStat;
      }
      
      public function get buildingRelocationStat() : StatisticItem
      {
         return this._buildingRelocationStat;
      }
      
      public function get hireStaffStat() : StatisticItem
      {
         return this._hireStaffStat;
      }
      
      public function get promotionStaffStat() : StatisticItem
      {
         return this._promotionStaffStat;
      }
      
      public function get serveranceStaffStat() : StatisticItem
      {
         return this._serveranceStaffStat;
      }
      
      public function get staffSallaries() : Object
      {
         return this._staffSallaries;
      }
      
      public function get extraUpgradeStat() : StatisticItem
      {
         return this._extraUpgradeStat;
      }
      
      public function get miscStat() : StatisticItem
      {
         return this._miscStat;
      }
      
      public function indexOf(param1:*, param2:* = 0) : int
      {
         var _loc3_:* = -1;
         var _loc4_:* = param2;
         while(_loc4_ < this._boothStatistic.length)
         {
            if(this._boothStatistic[_loc4_].relation == param1)
            {
               _loc3_ = _loc4_;
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function get totalProfit() : int
      {
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         while(_loc2_ < this._boothStatistic.length)
         {
            _loc1_ += this._boothStatistic[_loc2_].revenue;
            _loc2_++;
         }
         _loc1_ -= this._buildBuildingStat.expenditure;
         _loc1_ -= this._upgradeBuildingStat.expenditure;
         _loc1_ -= this._buildingRelocationStat.expenditure;
         _loc1_ -= this._hireStaffStat.expenditure;
         _loc1_ -= this._promotionStaffStat.expenditure;
         _loc1_ -= this._serveranceStaffStat.expenditure;
         for(_loc3_ in this._staffSallaries)
         {
            _loc1_ -= this._staffSallaries[_loc3_].expenditure;
         }
         _loc1_ -= this._extraUpgradeStat.expenditure;
         _loc1_ -= this._miscStat.expenditure;
         return _loc1_ + this._miscStat.revenue;
      }
      
      public function loadStatistic(param1:*, param2:*, param3:*) : void
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         this._boothStatistic = new Array();
         var _loc4_:* = 0;
         while(_loc4_ < param1.boothStatistic.length)
         {
            _loc7_ = param1.boothStatistic[_loc4_];
            _loc8_ = new StatisticItem();
            if((_loc9_ = param2.indexOf(_loc7_.relation)) in param3)
            {
               _loc8_.relation = param3[_loc9_];
            }
            else if(_loc7_.relationDestroyed != null)
            {
               if((_loc10_ = BuildingData.getClassOf(_loc7_.relationDestroyed)) != null)
               {
                  _loc8_.relation = new _loc10_();
               }
            }
            if(_loc8_.relation != null)
            {
               _loc8_.numberVisitor = _loc7_.numberVisitor;
               _loc8_.revenue = _loc7_.revenue;
               _loc8_.expenditure = _loc7_.expenditure;
               this._boothStatistic.push(_loc8_);
            }
            _loc4_++;
         }
         var _loc5_:*;
         (_loc5_ = new Array()).push(this._buildBuildingStat);
         _loc5_.push(this._upgradeBuildingStat);
         _loc5_.push(this._buildingRelocationStat);
         _loc5_.push(this._hireStaffStat);
         _loc5_.push(this._promotionStaffStat);
         _loc5_.push(this._serveranceStaffStat);
         _loc5_.push(this._staffSallaries.janitor);
         _loc5_.push(this._staffSallaries.handyman);
         _loc5_.push(this._staffSallaries.entertainer);
         _loc5_.push(this._staffSallaries.guard);
         _loc5_.push(this._extraUpgradeStat);
         _loc5_.push(this._miscStat);
         var _loc6_:*;
         (_loc6_ = new Array()).push(param1.buildBuildingStat);
         _loc6_.push(param1.upgradeBuildingStat);
         _loc6_.push(param1.buildingRelocationStat);
         _loc6_.push(param1.hireStaffStat);
         _loc6_.push(param1.promotionStaffStat);
         _loc6_.push(param1.serveranceStaffStat);
         _loc6_.push(param1.staffSallaries.janitor);
         _loc6_.push(param1.staffSallaries.handyman);
         _loc6_.push(param1.staffSallaries.entertainer);
         _loc6_.push(param1.staffSallaries.guard);
         _loc6_.push(param1.extraUpgradeStat);
         _loc6_.push(param1.miscStat);
         _loc4_ = 0;
         while(_loc4_ < _loc6_.length)
         {
            if(_loc4_ in _loc5_)
            {
               _loc11_ = _loc6_[_loc4_];
               (_loc12_ = _loc5_[_loc4_]).relation = _loc11_.relation;
               _loc12_.numberVisitor = _loc11_.numberVisitor;
               _loc12_.revenue = _loc11_.revenue;
               _loc12_.expenditure = _loc11_.expenditure;
            }
            _loc4_++;
         }
      }
      
      public function saveStatistic() : *
      {
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc1_:* = new Object();
         _loc1_.boothStatistic = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._boothStatistic.length)
         {
            _loc5_ = this._boothStatistic[_loc2_];
            (_loc6_ = new Object()).relation = _loc5_.relation;
            _loc6_.numberVisitor = _loc5_.numberVisitor;
            _loc6_.revenue = _loc5_.revenue;
            _loc6_.expenditure = _loc5_.expenditure;
            _loc1_.boothStatistic.push(_loc6_);
            _loc2_++;
         }
         var _loc3_:* = new Array();
         _loc3_.push(_loc1_.buildBuildingStat = new Object());
         _loc3_.push(_loc1_.upgradeBuildingStat = new Object());
         _loc3_.push(_loc1_.buildingRelocationStat = new Object());
         _loc3_.push(_loc1_.hireStaffStat = new Object());
         _loc3_.push(_loc1_.promotionStaffStat = new Object());
         _loc3_.push(_loc1_.serveranceStaffStat = new Object());
         _loc1_.staffSallaries = new Object();
         _loc3_.push(_loc1_.staffSallaries.janitor = new Object());
         _loc3_.push(_loc1_.staffSallaries.handyman = new Object());
         _loc3_.push(_loc1_.staffSallaries.entertainer = new Object());
         _loc3_.push(_loc1_.staffSallaries.guard = new Object());
         _loc3_.push(_loc1_.extraUpgradeStat = new Object());
         _loc3_.push(_loc1_.miscStat = new Object());
         var _loc4_:*;
         (_loc4_ = new Array()).push(this._buildBuildingStat);
         _loc4_.push(this._upgradeBuildingStat);
         _loc4_.push(this._buildingRelocationStat);
         _loc4_.push(this._hireStaffStat);
         _loc4_.push(this._promotionStaffStat);
         _loc4_.push(this._serveranceStaffStat);
         _loc4_.push(this._staffSallaries.janitor);
         _loc4_.push(this._staffSallaries.handyman);
         _loc4_.push(this._staffSallaries.entertainer);
         _loc4_.push(this._staffSallaries.guard);
         _loc4_.push(this._extraUpgradeStat);
         _loc4_.push(this._miscStat);
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            if(_loc2_ in _loc3_)
            {
               _loc7_ = _loc4_[_loc2_];
               (_loc8_ = _loc3_[_loc2_]).relation = _loc7_.relation;
               _loc8_.numberVisitor = _loc7_.numberVisitor;
               _loc8_.revenue = _loc7_.revenue;
               _loc8_.expenditure = _loc7_.expenditure;
            }
            _loc2_++;
         }
         return _loc1_;
      }
   }
}
