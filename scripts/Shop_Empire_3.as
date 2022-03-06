package
{
   import Instance.Preloader;
   import Instance.constant.BuildingData;
   import flash.display.MovieClip;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.net.navigateToURL;
   import flash.system.Security;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   public class Shop_Empire_3 extends MovieClip
   {
       
      
      public var preloader:Preloader;
      
      var urlvars:URLVariables;
      
      var url:String;
      
      var urlreq:URLRequest;
      
      var loaderx:URLLoader;
      
      var _hacked:int;
      
      var _hackedMessage:String;
      
      public function Shop_Empire_3()
      {
         this.urlvars = new URLVariables();
         this.url = loaderInfo.loaderURL;
         this.urlreq = new URLRequest("http://gamedata.gamesfree.com/api-shop-empire-3.php");
         this.loaderx = new URLLoader(this.urlreq);
         super();
         addFrameScript(3,this.frame4);
         var _loc1_:ContextMenu = new ContextMenu();
         _loc1_.hideBuiltInItems();
         var _loc2_:* = new ContextMenuItem("LITTLEGIANTWORLD");
         _loc2_.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.lgLink);
         _loc1_.customItems.push(_loc2_);
         contextMenu = _loc1_;
         tabEnabled = false;
         tabChildren = false;
         this.gBot();
         this.panggil();
         addEventListener(Event.ADDED_TO_STAGE,this.Initialize);
      }
      
      function siteLock() : void
      {
         var testsitelock:Function = function(param1:*):*
         {
            var _loc5_:* = undefined;
            var _loc6_:* = undefined;
            var _loc2_:* = true;
            var _loc3_:* = loaderInfo.url.split("://");
            var _loc4_:* = _loc3_[1].split("/");
            while(_loc4_[0] == "")
            {
               _loc3_[1] = _loc3_[1].substr(1,_loc3_[1].length);
               _loc4_ = _loc3_[1].split("/");
            }
            for(_loc5_ in param1)
            {
               if(param1[_loc5_] == _loc4_[0])
               {
                  _loc2_ = false;
               }
            }
            _loc6_ = getChildByName("preloader");
            runPreloader();
         };
         var urls_allowed:* = ["game.gamesfree.com","gamesfree.com","littlegiantworld.com","www.littlegiantworld.com"];
         testsitelock(urls_allowed);
      }
      
      function runPreloader() : void
      {
         this.loaderInfo.addEventListener(ProgressEvent.PROGRESS,this.loading);
         this.loaderInfo.addEventListener(Event.COMPLETE,this.completes);
      }
      
      function gBot() : void
      {
         var _loc1_:URLVariables = null;
         var _loc2_:URLRequest = null;
         var _loc3_:URLLoader = null;
         if(loaderInfo.url.substring(0,4) != "file")
         {
            Security.allowDomain("*");
            Security.loadPolicyFile("http://track.g-bot.net/crossdomain.xml");
            _loc1_ = new URLVariables();
            _loc1_.id = "shopempire3";
            _loc1_.ui = loaderInfo.url;
            _loc2_ = new URLRequest("http://track.g-bot.net/track.php");
            _loc2_.method = "POST";
            _loc2_.data = _loc1_;
            _loc3_ = new URLLoader();
            _loc3_.load(_loc2_);
         }
      }
      
      function panggil() : void
      {
         this.urlvars.flash = "1";
         this.urlvars.alamat = this.url;
         this.urlreq.method = URLRequestMethod.POST;
         this.urlreq.data = this.urlvars;
         this.loaderx.dataFormat = URLLoaderDataFormat.TEXT;
         this.loaderx.addEventListener(Event.COMPLETE,this.completed);
         this.loaderx.load(this.urlreq);
      }
      
      function Initialize(param1:Event) : void
      {
         stop();
         this.siteLock();
      }
      
      function loading(param1:ProgressEvent) : void
      {
         var _loc2_:Number = param1.bytesLoaded;
         var _loc3_:Number = param1.bytesTotal;
         var _loc4_:Number = _loc2_ / _loc3_ * 100;
         var _loc5_:*;
         if((_loc5_ = getChildByName("preloader")) != null)
         {
            _loc5_.percent = _loc4_;
         }
      }
      
      function completes(param1:Event) : void
      {
         this.loaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.loading);
         this.loaderInfo.removeEventListener(Event.COMPLETE,this.completes);
      }
      
      function completed(param1:Event) : void
      {
         var _loc7_:* = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         this._hacked = 0;
         var _loc2_:String = String(param1.target.data);
         _loc2_ = _loc2_.replace("\n","");
         var _loc3_:* = 0;
         _loc3_ = _loc2_.search("<br>");
         var _loc4_:String = _loc2_.substring(0,_loc2_.search("<br>"));
         var _loc5_:String = _loc2_.substring(_loc3_ + "<br>".length,_loc2_.length);
         var _loc6_:*;
         if((_loc6_ = MD5.encrypt(_loc4_)) == _loc5_)
         {
            _loc7_ = _loc4_.substring(0,_loc4_.search(";")) + ",";
            _loc8_ = _loc4_.substring(_loc4_.search(";") + 1,_loc2_.length);
            _loc9_ = new Array();
            _loc10_ = false;
            while(_loc7_.length > 0)
            {
               _loc11_ = _loc7_.substring(0,_loc7_.search(","));
               _loc12_ = int(_loc11_);
               if(!_loc10_)
               {
                  if(_loc12_ > 0)
                  {
                     _loc10_ = true;
                  }
               }
               _loc9_.push(_loc12_);
               _loc7_ = _loc7_.substring(_loc7_.search(",") + 1,_loc7_.length);
            }
            BuildingData.ITEM_TRESHOLD = _loc9_;
            if(!_loc10_)
            {
               this._hacked = 2;
            }
            else
            {
               this._hacked = _loc8_ != "abaikan" ? 1 : 0;
            }
            this._hackedMessage = _loc8_;
         }
         else
         {
            this._hacked = 2;
         }
      }
      
      function lgLink(param1:Event) : void
      {
         this.linkToLG();
      }
      
      public function linkToLG() : void
      {
         var _loc1_:URLRequest = new URLRequest("http://www.littlegiantworld.com");
         navigateToURL(_loc1_,"_blank");
      }
      
      public function linkToGamesfree() : void
      {
         var _loc1_:URLRequest = new URLRequest("http://www.gamesfree.com");
         navigateToURL(_loc1_,"_blank");
      }
      
      public function get hacked() : int
      {
         return this._hacked;
      }
      
      public function get hackedMessage() : String
      {
         return this._hackedMessage;
      }
      
      function frame4() : *
      {
         stop();
      }
   }
}
