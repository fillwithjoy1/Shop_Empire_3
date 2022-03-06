package Instance.property
{
   public class StatisticItem
   {
       
      
      var _relation;
      
      var _numberVisitor:int;
      
      var _revenue:int;
      
      var _expenditure:int;
      
      var _showVisitor:Boolean;
      
      var _showRevenue:Boolean;
      
      var _showExpenditure:Boolean;
      
      public function StatisticItem()
      {
         super();
         this._numberVisitor = 0;
         this._revenue = 0;
         this._expenditure = 0;
         this._showVisitor = false;
         this._showRevenue = false;
         this._showExpenditure = false;
      }
      
      public function set relation(param1:*) : void
      {
         this._relation = param1;
      }
      
      public function get relation() : *
      {
         return this._relation;
      }
      
      public function set numberVisitor(param1:int) : void
      {
         this._numberVisitor = param1;
      }
      
      public function get numberVisitor() : int
      {
         return this._numberVisitor;
      }
      
      public function set revenue(param1:int) : void
      {
         this._revenue = param1;
      }
      
      public function get revenue() : int
      {
         return this._revenue;
      }
      
      public function set expenditure(param1:int) : void
      {
         this._expenditure = param1;
      }
      
      public function get expenditure() : int
      {
         return this._expenditure;
      }
      
      public function set showVisitor(param1:Boolean) : void
      {
         this._showVisitor = param1;
      }
      
      public function get showVisitor() : Boolean
      {
         return this._showVisitor;
      }
      
      public function set showRevenue(param1:Boolean) : void
      {
         this._showRevenue = param1;
      }
      
      public function get showRevenue() : Boolean
      {
         return this._showRevenue;
      }
      
      public function set showExpenditure(param1:Boolean) : void
      {
         this._showExpenditure = param1;
      }
      
      public function get showExpenditure() : Boolean
      {
         return this._showExpenditure;
      }
   }
}
