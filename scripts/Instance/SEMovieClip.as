package Instance
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public class SEMovieClip extends MovieClip
   {
       
      
      var listenerList:Array;
      
      var _priority:int;
      
      public function SEMovieClip()
      {
         this.listenerList = new Array();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.Initialize);
      }
      
      protected function Initialize(param1:Event) : void
      {
         addEventListener(Event.REMOVED_FROM_STAGE,this.Removed);
      }
      
      protected function Removed(param1:Event) : void
      {
         var _loc2_:* = undefined;
         while(this.listenerList.length > 0)
         {
            _loc2_ = this.listenerList.shift();
            _loc2_.target.removeEventListener(_loc2_.listener,_loc2_.module);
         }
         removeEventListener(Event.REMOVED_FROM_STAGE,this.Removed);
      }
      
      public function addListenerOf(param1:*, param2:String, param3:Function) : void
      {
         var _loc6_:* = undefined;
         var _loc4_:* = false;
         var _loc5_:* = 0;
         while(_loc5_ < this.listenerList.length)
         {
            if((_loc6_ = this.listenerList[_loc5_]).target == param1 && _loc6_.listener == param2 && _loc6_.module == param3)
            {
               _loc4_ = true;
               break;
            }
            _loc5_++;
         }
         if(!_loc4_)
         {
            param1.addEventListener(param2,param3);
            this.listenerList.push({
               "target":param1,
               "listener":param2,
               "module":param3
            });
         }
      }
      
      public function removeListenerOf(param1:*, param2:String, param3:Function) : void
      {
         var _loc5_:* = undefined;
         var _loc4_:* = 0;
         while(_loc4_ < this.listenerList.length)
         {
            if((_loc5_ = this.listenerList[_loc4_]).target == param1 && _loc5_.listener == param2 && _loc5_.module == param3)
            {
               param1.removeEventListener(param2,param3);
               this.listenerList.splice(_loc4_,1);
               break;
            }
            _loc4_++;
         }
      }
      
      public function set priority(param1:int) : void
      {
         this._priority = param1;
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
   }
}
