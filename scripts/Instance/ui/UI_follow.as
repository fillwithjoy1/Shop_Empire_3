package Instance.ui
{
   import Instance.Gameplay;
   import Instance.SEMovieClip;
   import Instance.events.GameEvent;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class UI_follow extends SEMovieClip
   {
       
      
      public var likeLGBefore:SimpleButton;
      
      public var likeLGWait:SimpleButton;
      
      public var likeLGAfter:SimpleButton;
      
      public var likeGamesfreeBefore:SimpleButton;
      
      public var btnClose:SimpleButton;
      
      public var likeGamesfreeAfter:SimpleButton;
      
      public var likeGamesfreeWait:SimpleButton;
      
      var _main:Gameplay;
      
      public function UI_follow()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(!("likeLG" in this._main.history))
         {
            this.likeLGBefore.visible = true;
            this.likeLGAfter.visible = false;
            this.likeLGWait.visible = false;
         }
         else
         {
            this.likeLGBefore.visible = this._main.history["likeLG"] == 0;
            this.likeLGWait.visible = this._main.history["likeLG"] == 1;
            this.likeLGAfter.visible = this._main.history["likeLG"] == 2;
         }
         if(!("likeGamesfree" in this._main.history))
         {
            this.likeGamesfreeBefore.visible = true;
            this.likeGamesfreeWait.visible = false;
            this.likeGamesfreeAfter.visible = false;
         }
         else
         {
            this.likeGamesfreeBefore.visible = this._main.history["likeGamesfree"] == 0;
            this.likeGamesfreeWait.visible = this._main.history["likeGamesfree"] == 1;
            this.likeGamesfreeAfter.visible = this._main.history["likeGamesfree"] == 2;
         }
         addListenerOf(this.likeLGAfter,MouseEvent.CLICK,this.linkToLGFacebook);
         addListenerOf(this.likeLGBefore,MouseEvent.CLICK,this.linkToLGFacebook);
         addListenerOf(this.likeGamesfreeAfter,MouseEvent.CLICK,this.linkToGamesfreeFacebook);
         addListenerOf(this.likeGamesfreeBefore,MouseEvent.CLICK,this.linkToGamesfreeFacebook);
         var _loc2_:* = this._main.world.popularity;
         if("popularity" in this._main.history)
         {
            _loc2_ = Math.max(this._main.history["popularity"],this._main.world.popularity);
         }
         if(_loc2_ < 10)
         {
            addListenerOf(stage,GameEvent.UPDATE_POPULARITY,this.whenPopularityUpdated);
         }
      }
      
      function whenPopularityUpdated(param1:Event) : void
      {
         var _loc2_:* = this._main.world.popularity;
         if("popularity" in this._main.history)
         {
            _loc2_ = Math.max(this._main.history["popularity"],this._main.world.popularity);
         }
         if(_loc2_ >= 10)
         {
            if(this._main.history["likeLG"] == 1)
            {
               this.likeLGWait.visible = false;
               this.likeLGAfter.visible = true;
            }
            if(this._main.history["likeGamesfree"] == 1)
            {
               this.likeGamesfreeWait.visible = false;
               this.likeGamesfreeAfter.visible = true;
            }
         }
      }
      
      function linkToLGFacebook(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:URLRequest = new URLRequest("https://www.facebook.com/Littlegiantworld");
         navigateToURL(_loc2_,"_blank");
         if(!("likeLG" in this._main.history) || this._main.history["likeLG"] == 0)
         {
            _loc3_ = this._main.world.popularity;
            if("popularity" in this._main.history)
            {
               _loc3_ = Math.max(this._main.history["popularity"],this._main.world.popularity);
            }
            this.likeLGBefore.visible = false;
            if(_loc3_ >= 10)
            {
               this._main.history["likeLG"] = 2;
               this.likeLGWait.visible = false;
               this.likeLGAfter.visible = true;
            }
            else
            {
               this._main.history["likeLG"] = 1;
               this.likeLGWait.visible = true;
               this.likeLGAfter.visible = false;
            }
            if(this._main.history["likeLG"] >= 2)
            {
               this._main.cashReward(5000);
            }
         }
      }
      
      function linkToGamesfreeFacebook(param1:MouseEvent) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:URLRequest = new URLRequest("https://www.facebook.com/pages/Games-Free/112783725420705");
         navigateToURL(_loc2_,"_blank");
         if(!("likeGamesfree" in this._main.history) || this._main.history["likeGamesfree"] == 0)
         {
            _loc3_ = this._main.world.popularity;
            if("popularity" in this._main.history)
            {
               _loc3_ = Math.max(this._main.history["popularity"],this._main.world.popularity);
            }
            this.likeGamesfreeBefore.visible = false;
            if(_loc3_ >= 10)
            {
               this._main.history["likeGamesfree"] = 2;
               this.likeGamesfreeWait.visible = false;
               this.likeGamesfreeAfter.visible = true;
            }
            else
            {
               this._main.history["likeGamesfree"] = 1;
               this.likeGamesfreeWait.visible = true;
               this.likeGamesfreeAfter.visible = false;
            }
            if(this._main.history["likeGamesfree"] >= 2)
            {
               this._main.cashReward(5000);
            }
         }
      }
      
      public function set main(param1:Gameplay) : void
      {
         this._main = param1;
      }
      
      public function get main() : Gameplay
      {
         return this._main;
      }
   }
}
