package Instance.ui
{
   import Instance.SEMovieClip;
   import Instance.constant.ColorCode;
   import Instance.constant.UpgradeData;
   import Instance.events.CommandEvent;
   import Instance.events.GameEvent;
   import Instance.gameplay.World;
   import Instance.modules.Utility;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextField;
   import greensock.TweenLite;
   
   public class ExtraUpgradeBox extends SEMovieClip
   {
       
      
      public var upgradeIcon:MovieClip;
      
      public var upgradeName:TextField;
      
      public var purchasedSign:MovieClip;
      
      public var upgradeDescription:TextField;
      
      public var upgradeCostInfo:TextField;
      
      public var newIndicator:MovieClip;
      
      public var btnCreatePost:SimpleButton;
      
      public var btnPurchase:SimpleButton;
      
      var _upgradeRelation;
      
      var _world:World;
      
      public function ExtraUpgradeBox()
      {
         super();
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         if(this._upgradeRelation != null)
         {
            this.updateData(this._upgradeRelation);
         }
         addListenerOf(this.btnPurchase,MouseEvent.CLICK,this.btnPurchasedOnClick);
         addListenerOf(this.btnCreatePost,MouseEvent.CLICK,this.createGuardPost);
         addListenerOf(stage,GameEvent.UPDATE_BUDGET,this.whenBudgetUpdated);
         addListenerOf(stage,GameEvent.AFTER_UPGRADE_PURCHASED,this.whenUpgradePurchased);
      }
      
      function whenUpgradePurchased(param1:GameEvent) : void
      {
         if(param1.tag == this._upgradeRelation)
         {
            this.newIndicator.visible = false;
         }
      }
      
      function createGuardPost(param1:MouseEvent) : void
      {
         var tParent:* = undefined;
         var e:MouseEvent = param1;
         var target:* = e.currentTarget;
         if(target.enabled)
         {
            var hideMe:Function = function():void
            {
               tParent.visible = false;
            };
            dispatchEvent(new CommandEvent(CommandEvent.BEGIN_BUILD,{"icon":"guardpost"}));
            tParent = this.parent;
            TweenLite.killTweensOf(tParent,true);
            TweenLite.to(tParent,0.4,{
               "scaleX":0,
               "scaleY":0,
               "alpha":0,
               "y":500,
               "onComplete":hideMe
            });
         }
      }
      
      function whenBudgetUpdated(param1:GameEvent) : void
      {
         if(this._upgradeRelation != null)
         {
            this.updateCostShown(this._upgradeRelation);
         }
      }
      
      function btnPurchasedOnClick(param1:MouseEvent) : void
      {
         var _loc2_:* = param1.currentTarget;
         if(_loc2_.enabled)
         {
            if(this._upgradeRelation != null)
            {
               dispatchEvent(new GameEvent(GameEvent.PURCHASE_UPGRADE,this._upgradeRelation));
            }
         }
      }
      
      function updateCostShown(param1:*) : void
      {
         var _loc2_:* = true;
         if(param1.requirement != null)
         {
            if(!this._world.isUpgradePurchased(param1.requirement))
            {
               this.upgradeCostInfo.visible = true;
               this.upgradeCostInfo.text = "Req: " + UpgradeData.getNameOf(param1.requirement);
               this.upgradeCostInfo.textColor = ColorCode.REQUIREMENT_COLOR;
               _loc2_ = false;
            }
         }
         if(_loc2_)
         {
            if(!param1.purchased)
            {
               this.upgradeCostInfo.visible = true;
               this.upgradeCostInfo.text = "" + Utility.numberToMoney(param1.cost) + " G";
               if(this._world != null && this._world.main != null)
               {
                  if(this._world.main.isEnough(param1.cost))
                  {
                     this.upgradeCostInfo.textColor = ColorCode.POSITIVE_CASH_ANIMATION;
                  }
                  else
                  {
                     this.upgradeCostInfo.textColor = ColorCode.NEGATIVE_CASH_ANIMATION;
                  }
               }
               this.btnCreatePost.visible = false;
            }
            else
            {
               this.upgradeCostInfo.visible = false;
               this.btnCreatePost.visible = param1.towerCheck > 0;
               this.btnCreatePost.enabled = this._world.guardPostList.length == param1.towerCheck - 1;
               if(this.btnCreatePost.enabled)
               {
                  this.btnCreatePost.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
               }
               else
               {
                  this.btnCreatePost.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
               }
            }
            this.btnPurchase.enabled = !param1.purchased;
         }
         else
         {
            this.btnCreatePost.visible = false;
            this.btnPurchase.enabled = false;
         }
         this.btnPurchase.visible = !param1.purchased;
         if(this.btnPurchase.enabled)
         {
            this.btnPurchase.transform.colorTransform = new ColorTransform(1,1,1,1,0,0,0,0);
         }
         else
         {
            this.btnPurchase.transform.colorTransform = new ColorTransform(0.6,0.6,0.6,1,0,0,0,0);
         }
      }
      
      function updateData(param1:*) : void
      {
         var _loc2_:* = undefined;
         if(param1 != null)
         {
            _loc2_ = UpgradeData.getFrameOf(param1.code);
            if(Utility.hasLabel(this.upgradeIcon,_loc2_))
            {
               this.upgradeIcon.gotoAndStop(_loc2_);
            }
            this.upgradeName.text = param1.upgradeName.toUpperCase();
            this.upgradeDescription.text = param1.description;
            this.updateCostShown(param1);
            this.purchasedSign.visible = param1.purchased;
         }
      }
      
      public function set upgradeRelation(param1:*) : void
      {
         this._upgradeRelation = param1;
         this.updateData(this._upgradeRelation);
      }
      
      public function get upgradeRelation() : *
      {
         return this._upgradeRelation;
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function get world() : World
      {
         return this._world;
      }
   }
}
