package Instance.ui
{
   import flash.display.MovieClip;
   
   public class UI_Clock extends MovieClip
   {
       
      
      public var shortNeedle:MovieClip;
      
      public var daySymbol:MovieClip;
      
      public var longNeedle:MovieClip;
      
      var _hour:int;
      
      var _minute:int;
      
      public function UI_Clock()
      {
         super();
      }
      
      public function set hour(param1:int) : void
      {
         while(param1 >= 24)
         {
            param1 -= 24;
         }
         this._hour = param1;
         this.shortNeedle.rotation = this._hour * 30 + this._minute * 0.5;
         if(this.daySymbol != null)
         {
            if(this._hour >= 17 && this._hour < 19)
            {
               this.daySymbol.alpha = 1 - ((this._hour - 17) / 2 + this._minute * 1 / 120);
            }
            else if(this._hour >= 5 && this._hour < 7)
            {
               this.daySymbol.alpha = (this._hour - 5) / 2 + this._minute * 1 / 120;
            }
            else if(this._hour >= 19 || this._hour < 5)
            {
               this.daySymbol.alpha = 0;
            }
            else
            {
               this.daySymbol.alpha = 1;
            }
         }
      }
      
      public function set minute(param1:int) : void
      {
         while(param1 >= 60)
         {
            param1 -= 60;
         }
         this._minute = param1;
         this.shortNeedle.rotation = this._hour * 30 + this._minute * 0.5;
         this.longNeedle.rotation = this._minute * 6;
         if(this.daySymbol != null)
         {
            if(this._hour >= 17 && this._hour < 19)
            {
               this.daySymbol.alpha = 1 - ((this._hour - 17) / 2 + this._minute * 1 / 120);
            }
            else if(this._hour >= 5 && this._hour < 7)
            {
               this.daySymbol.alpha = (this._hour - 5) / 2 + this._minute * 1 / 120;
            }
            else if(this._hour >= 19 || this._hour < 5)
            {
               this.daySymbol.alpha = 0;
            }
            else
            {
               this.daySymbol.alpha = 1;
            }
         }
      }
      
      public function get hour() : int
      {
         return this._hour;
      }
      
      public function get minute() : int
      {
         return this._minute;
      }
   }
}
