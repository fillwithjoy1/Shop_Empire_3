package Instance.property
{
   public class BoothColloseum extends Booth
   {
       
      
      var _fightingClip:Array;
      
      public function BoothColloseum()
      {
         this._fightingClip = new Array();
         super();
      }
      
      override function createEmployeeList() : void
      {
         var _loc1_:* = undefined;
         super.createEmployeeList();
         if(body != null)
         {
            _loc1_ = 0;
            while(body.getChildByName("fighting" + _loc1_))
            {
               if(_loc1_ in this._fightingClip)
               {
                  this._fightingClip[_loc1_] = body.getChildByName("fighting" + _loc1_);
               }
               else
               {
                  this._fightingClip.push(body.getChildByName("fighting" + _loc1_));
               }
               _loc1_++;
            }
         }
      }
      
      function checkFighterList() : void
      {
         var _loc1_:* = 0;
         while(_loc1_ < this._fightingClip.length)
         {
            if(_loc1_ * 2 in _employeeInPosition && _loc1_ * 2 + 1 in _employeeInPosition)
            {
               if(!this._fightingClip[_loc1_].visible)
               {
                  this._fightingClip[_loc1_].gotoAndStop(1);
               }
               this._fightingClip[_loc1_].visible = _employeeInPosition[_loc1_ * 2] && _employeeInPosition[_loc1_ * 2 + 1];
               if(_employeeInPosition[_loc1_ * 2])
               {
                  _employeeClipList[_loc1_ * 2].visible = !this._fightingClip[_loc1_].visible;
               }
               else
               {
                  _employeeClipList[_loc1_ * 2].visible = false;
               }
               if(_employeeInPosition[_loc1_ * 2 + 1])
               {
                  _employeeClipList[_loc1_ * 2 + 1].visible = !this._fightingClip[_loc1_].visible;
               }
               else
               {
                  _employeeClipList[_loc1_ * 2 + 1].visible = false;
               }
            }
            _loc1_++;
         }
      }
      
      override function checkEmployeeList() : void
      {
         super.checkEmployeeList();
         this.checkFighterList();
      }
      
      public function openCloseCheck() : void
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc1_:* = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this._fightingClip.length)
         {
            _loc1_.push(0);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _shopkeeperAbsense.length)
         {
            _loc4_ = _shopkeeperAbsense[_loc2_];
            _loc5_ = _shopkeeperList.indexOf(_loc4_);
            if(Math.floor(_loc5_ / 2) in _loc1_)
            {
               ++_loc1_[Math.floor(_loc5_ / 2)];
            }
            _loc2_++;
         }
         var _loc3_:* = false;
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_] >= 2)
            {
               _loc3_ = true;
               break;
            }
            _loc2_++;
         }
         if(_loc3_)
         {
            if(!_open)
            {
               open = true;
            }
         }
         else if(_open)
         {
            open = false;
         }
         this.checkFighterList();
      }
   }
}
