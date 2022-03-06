package
{
   import flash.display.MovieClip;
   
   public dynamic class MissionMark extends MovieClip
   {
       
      
      public function MissionMark()
      {
         super();
         addFrameScript(45,this.frame46,52,this.frame53);
      }
      
      function frame46() : *
      {
         stop();
      }
      
      function frame53() : *
      {
         stop();
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
