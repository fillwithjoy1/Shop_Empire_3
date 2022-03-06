package Instance.ui
{
   import Instance.Gameplay;
   import Instance.SEMovieClip;
   import Instance.constant.TipsList;
   import Instance.events.CommandEvent;
   import Instance.events.SliderBarEvent;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class HintPanel extends SEMovieClip
   {
       
      
      public var prevPage:SimpleButton;
      
      public var nextPage:SimpleButton;
      
      public var pageInfo:TextField;
      
      public var scrollBar:TipsPanelSlideBar;
      
      public var btnClose:SimpleButton;
      
      public var maskInfo:MovieClip;
      
      public var tipsHeader:TextField;
      
      public var tipsInfo:TextField;
      
      var _page:int;
      
      var _main:Gameplay;
      
      public function HintPanel()
      {
         super();
         this._page = 1;
         this.scrollBar.slideMode = this.scrollBar.VERTICAL;
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.letterSpacing = -1;
         this.tipsInfo.defaultTextFormat = _loc1_;
         this.tipsInfo.mouseEnabled = false;
         this.tipsInfo.autoSize = TextFieldAutoSize.LEFT;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(this.btnClose,MouseEvent.CLICK,this.btnMouseOnClick);
         addListenerOf(this.nextPage,MouseEvent.CLICK,this.changePage);
         addListenerOf(this.prevPage,MouseEvent.CLICK,this.changePage);
         addListenerOf(this.scrollBar,SliderBarEvent.CHANGE_POSITION,this.sliderBarChangePosition);
         this.readCategory();
      }
      
      function readCategory() : void
      {
         var _loc1_:* = TipsList.getTipsAt(this._page - 1);
         if(_loc1_ != null)
         {
            if(this._main != null)
            {
               this.tipsHeader.text = "??????";
               this.tipsInfo.text = "??????";
               this.tipsHeader.text = _loc1_.header;
               this.tipsInfo.text = _loc1_.note;
            }
            else
            {
               this.tipsHeader.text = _loc1_.header;
               this.tipsInfo.text = _loc1_.note;
            }
         }
         this.pageInfo.text = "(" + this._page + "/" + TipsList.CODE_LIST.length + ")";
         this.scrollBar.setPosition(0);
         this.scrollBar.visible = this.tipsInfo.height > this.maskInfo.height - 2;
      }
      
      public function changePage(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_ == this.nextPage)
         {
            ++this._page;
         }
         else if(_loc2_ == this.prevPage)
         {
            --this._page;
         }
         var _loc3_:* = TipsList.CODE_LIST.length;
         if(this._page < 1)
         {
            this._page = _loc3_;
         }
         if(this._page > _loc3_)
         {
            this._page = 1;
         }
         this.readCategory();
      }
      
      function btnMouseOnClick(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.PANEL_NEED_TO_CLOSE));
      }
      
      function sliderBarChangePosition(param1:SliderBarEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         this.tipsInfo.y = this.maskInfo.y + 1 - _loc2_.getPosition() * (this.tipsInfo.height - (this.maskInfo.height - 2));
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
