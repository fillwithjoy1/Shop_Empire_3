package ShopEmpire3_fla
{
   import flash.display.MovieClip;
   
   public dynamic class UI_877 extends MovieClip
   {
       
      
      public var btnPanel1:UIToggleButtonSector;
      
      public var amountPanel0:MovieClip;
      
      public var btnPanel0:UIToggleButtonSector;
      
      public var amountPanel1:MovieClip;
      
      public var amountPanel2:MovieClip;
      
      public var btnPanel2:UIToggleButtonSector;
      
      public function UI_877()
      {
         super();
         this.__setProp_btnPanel0_UI();
         this.__setProp_btnPanel2_UI();
         this.__setProp_btnPanel1_UI();
      }
      
      function __setProp_btnPanel0_UI() : *
      {
         try
         {
            this.btnPanel0["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnPanel0.enabled = true;
         this.btnPanel0.icon = "locked";
         this.btnPanel0.isActive = false;
         try
         {
            this.btnPanel0["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnPanel2_UI() : *
      {
         try
         {
            this.btnPanel2["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnPanel2.enabled = true;
         this.btnPanel2.icon = "locked";
         this.btnPanel2.isActive = false;
         try
         {
            this.btnPanel2["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      function __setProp_btnPanel1_UI() : *
      {
         try
         {
            this.btnPanel1["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnPanel1.enabled = true;
         this.btnPanel1.icon = "locked";
         this.btnPanel1.isActive = false;
         try
         {
            this.btnPanel1["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
