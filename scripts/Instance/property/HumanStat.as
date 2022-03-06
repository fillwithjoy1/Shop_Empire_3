package Instance.property
{
   public class HumanStat
   {
       
      
      var _speed:int;
      
      var _stamina:int;
      
      var _sight:int;
      
      var _hygine:int;
      
      var _entertain:int;
      
      var _hireCostDifference:Number;
      
      var _characterName:String;
      
      public function HumanStat()
      {
         super();
         this._characterName = "";
      }
      
      public function countSpeed() : Number
      {
         return 2 + 2 * (this._speed / 100);
      }
      
      public function countSight() : Number
      {
         return 180 + 5 * this._sight;
      }
      
      public function set speed(param1:int) : void
      {
         this._speed = param1;
      }
      
      public function get speed() : int
      {
         return this._speed;
      }
      
      public function set stamina(param1:int) : void
      {
         this._stamina = param1;
      }
      
      public function get stamina() : int
      {
         return this._stamina;
      }
      
      public function set sight(param1:int) : void
      {
         this._sight = param1;
      }
      
      public function get sight() : int
      {
         return this._sight;
      }
      
      public function set hygine(param1:int) : void
      {
         this._hygine = param1;
      }
      
      public function get hygine() : int
      {
         return this._hygine;
      }
      
      public function set entertain(param1:int) : void
      {
         this._entertain = param1;
      }
      
      public function get entertain() : int
      {
         return this._entertain;
      }
      
      public function get average() : Number
      {
         return (this._stamina + this._hygine + this._entertain + this._sight + this._speed) / 5;
      }
      
      public function set hireCostDifference(param1:Number) : void
      {
         this._hireCostDifference = param1;
      }
      
      public function get hireCostDifference() : Number
      {
         return this._hireCostDifference;
      }
      
      public function set characterName(param1:String) : void
      {
         this._characterName = param1;
      }
      
      public function get characterName() : String
      {
         return this._characterName;
      }
   }
}
