package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.CommandEvent;
   import Instance.progress.StairBuildProgress;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   
   public class UI_InfoBuild extends SEMovieClip
   {
       
      
      public var btnFlip:SimpleButton;
      
      public var buildingCost:TextField;
      
      public var btnClose:SimpleButton;
      
      public var rightCompatibility:ThumbSign;
      
      public var buildingName:TextField;
      
      public var leftCompatibility:ThumbSign;
      
      public var buildingIcon:MovieClip;
      
      var _toBuild;
      
      public function UI_InfoBuild()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this.btnFlip,MouseEvent.CLICK,this.flipProgress);
         addListenerOf(this.btnClose,MouseEvent.CLICK,this.cancelBuild);
      }
      
      function cancelBuild(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.CANCEL_BUILD));
         if(this._toBuild != null)
         {
            this._toBuild.source.isActive = false;
         }
      }
      
      function flipProgress(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            if(this._toBuild != null)
            {
               this._toBuild.flipBuilding();
            }
         }
      }
      
      public function set toBuild(param1:*) : void
      {
         this._toBuild = param1;
         this.btnFlip.enabled = this._toBuild is StairBuildProgress;
         if(this.btnFlip.enabled)
         {
            this.btnFlip.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         else
         {
            this.btnFlip.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
         }
      }
      
      public function get toBuild() : *
      {
         return this._toBuild;
      }
   }
}
