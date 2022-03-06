package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.events.AudioEvent;
   import Instance.events.ComboEvent;
   import Instance.events.CommandEvent;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class UI_InfoPanel extends SEMovieClip
   {
       
      
      var _tabBarList:Array;
      
      var _activeTab:int;
      
      var _selectedTab;
      
      var _selectedOrder:int;
      
      var _orderByComboBox:UI_Combobox;
      
      public function UI_InfoPanel()
      {
         var _loc2_:* = undefined;
         super();
         this._tabBarList = new Array();
         var _loc1_:* = 0;
         while(getChildByName("deactiveTab" + _loc1_))
         {
            _loc2_ = getChildByName("deactiveTab" + _loc1_);
            _loc2_.buttonMode = true;
            this._tabBarList.push(_loc2_);
            _loc1_++;
         }
         this._selectedTab = getChildByName("activateTab");
         this._activeTab = 0;
         this._selectedOrder = 0;
         this._orderByComboBox = getChildByName("orderByCombo") as UI_Combobox;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         this.checkActiveTab();
         if(this._orderByComboBox != null)
         {
            if(this._orderByComboBox.comboItem.length > 0)
            {
               this._orderByComboBox.text = this._orderByComboBox.comboItem[this._selectedOrder];
            }
            addListenerOf(this._orderByComboBox,ComboEvent.ON_CHANGE,this.changeOrderMode);
         }
         var _loc2_:* = getChildByName("btnClose");
         if(_loc2_ != null)
         {
            addListenerOf(_loc2_,MouseEvent.CLICK,this.closeProgress);
         }
         var _loc3_:* = 0;
         while(_loc3_ < this._tabBarList.length)
         {
            addListenerOf(this._tabBarList[_loc3_],MouseEvent.CLICK,this.tabBarOnClick);
            _loc3_++;
         }
      }
      
      function changeOrderMode(param1:ComboEvent) : void
      {
         this._selectedOrder = param1.selected;
         this.checkActiveTab();
      }
      
      function closeProgress(param1:MouseEvent) : void
      {
         dispatchEvent(new CommandEvent(CommandEvent.PANEL_NEED_TO_CLOSE));
      }
      
      public function onDismiss() : void
      {
      }
      
      function tabBarOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         dispatchEvent(new AudioEvent(AudioEvent.PLAY_SFX,SFX_Page_Flip));
         this._activeTab = this._tabBarList.indexOf(_loc2_);
         this.checkActiveTab();
      }
      
      function checkActiveTab() : void
      {
         if(this._activeTab in this._tabBarList)
         {
            this._selectedTab.x = this._tabBarList[this._activeTab].x;
            this._selectedTab.y = this._tabBarList[this._activeTab].y;
         }
      }
   }
}
