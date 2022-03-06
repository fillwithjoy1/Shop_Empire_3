package Instance.property
{
   import Instance.events.CommandEvent;
   import flash.display.BlendMode;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class FacilityTerrace extends Building
   {
       
      
      var _spotList:Array;
      
      var _visitorInSpot:Array;
      
      var _visitorList:Array;
      
      var body;
      
      public function FacilityTerrace()
      {
         super();
         this._spotList = new Array();
         this._visitorInSpot = new Array();
         this._visitorList = new Array();
         this.body = getChildAt(0) as MovieClip;
         this.createServiceSpot();
         this.createHumanContainer();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.checkSpotList();
      }
      
      function checkSpotList() : void
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this._spotList.length)
         {
            if(_loc1_ in this._visitorInSpot)
            {
               _loc2_ = this._visitorInSpot[_loc1_];
               this._spotList[_loc1_].visible = _loc2_ != null;
               if(_loc2_ != null)
               {
                  this._spotList[_loc1_].gotoAndStop(_loc2_.model);
               }
            }
            _loc1_++;
         }
      }
      
      function createServiceSpot() : void
      {
         var _loc1_:* = undefined;
         if(this.body != null)
         {
            _loc1_ = 0;
            while(this.body.getChildByName("spot" + _loc1_))
            {
               if(_loc1_ in this._spotList)
               {
                  this._spotList[_loc1_] = this.body.getChildByName("spot" + _loc1_);
               }
               else
               {
                  this._spotList.push(this.body.getChildByName("spot" + _loc1_));
                  this._visitorInSpot.push(null);
               }
               _loc1_++;
            }
         }
      }
      
      function createHumanContainer() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(this.body != null)
         {
            _loc1_ = this.body.getChildByName("insideClip");
            if(_loc1_ != null)
            {
               _insideRegion = _loc1_;
               _loc2_ = this.body.getChildIndex(_loc1_);
               _humanContainer.visible = _loc1_.blendMode == BlendMode.NORMAL;
               this.body.addChildAt(_humanContainer,_loc2_ + 1);
               this.body.removeChild(_loc1_);
            }
         }
      }
      
      override function buildingOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.BOOTH_ON_SELECT));
      }
      
      override public function addPerson(param1:*, param2:Boolean = false) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         super.addPerson(param1);
         if(!param2)
         {
            _loc3_ = _humanContainer.globalToLocal(param1.localToGlobal(new Point(0,0)));
            _loc4_ = _humanContainer.globalToLocal(param1.localToGlobal(new Point(1,0)));
            param1.x = _loc3_.x;
            param1.y = _loc3_.y;
            if(_loc4_.x > _loc3_.x)
            {
               param1.scaleX = 1;
            }
            else
            {
               param1.scaleX = -1;
            }
         }
         _humanContainer.addChild(param1);
         if(_world.currentVisitorList.indexOf(param1) >= 0)
         {
            this._visitorList.push(param1);
         }
      }
      
      override public function removePerson(param1:*) : void
      {
         super.removePerson(param1);
         var _loc2_:* = this._visitorList.indexOf(param1);
         if(_loc2_ in this._visitorList)
         {
            this._visitorList.splice(_loc2_,1);
         }
      }
      
      public function overload(param1:*) : Boolean
      {
         return this._visitorList.indexOf(param1) >= _capacity;
      }
      
      override public function get numberPeople() : int
      {
         return this._visitorList.length;
      }
      
      public function get isFull() : Boolean
      {
         return this._visitorList.length >= _capacity;
      }
      
      public function get open() : Boolean
      {
         return true;
      }
      
      public function get visitorInSpot() : Array
      {
         return this._visitorInSpot;
      }
      
      public function get spotList() : Array
      {
         return this._spotList;
      }
      
      public function get visitorList() : Array
      {
         return this._visitorList;
      }
   }
}
