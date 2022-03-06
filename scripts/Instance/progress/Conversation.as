package Instance.progress
{
   import Instance.events.GameEvent;
   import Instance.gameplay.World;
   import Instance.sprite.Animation;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Conversation
   {
       
      
      var speaker1:MovieClip;
      
      var speaker2:MovieClip;
      
      var sentenceList;
      
      var speakerList;
      
      var tipsList;
      
      var delayList;
      
      var _world:World;
      
      var bubbleText:MovieClip;
      
      var _inTerrace:MovieClip;
      
      public function Conversation(param1:MovieClip, param2:MovieClip)
      {
         this.sentenceList = new Array();
         this.speakerList = new Array();
         this.tipsList = new Array();
         this.delayList = new Array();
         super();
         this.speaker1 = param1;
         this.speaker2 = param2;
         this.bubbleText = null;
      }
      
      public function addText(param1:String, param2:MovieClip, param3:String = null, param4:Number = 7) : void
      {
         this.sentenceList.push(param1);
         this.speakerList.push(param2);
         this.tipsList.push(param3);
         this.delayList.push(param4);
      }
      
      public function run() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         if(this._world != null)
         {
            if(this.speaker1 != null && this.speaker2 != null)
            {
               _loc2_ = Math.abs(this.speaker1.x - this.speaker2.x);
               _loc3_ = this._world.getFloorAt(this.speaker1.y);
               if(_loc2_ < 20 || _loc2_ > 30)
               {
                  _loc5_ = (_loc4_ = this.speaker1.x > this.speaker2.x ? this.speaker2 : this.speaker1) == this.speaker1 ? this.speaker2 : this.speaker1;
                  _loc6_ = _loc4_.x + (_loc5_.x - _loc4_.x) / 2;
                  _loc7_ = false;
                  _loc8_ = 2;
                  while(_loc8_ > 0 && !_loc7_)
                  {
                     _loc7_ = true;
                     _loc9_ = _loc6_ - (_loc2_ < 20 ? 10 : 15);
                     if(_loc3_ != null)
                     {
                        if(_loc9_ < _loc3_.left)
                        {
                           _loc11_ = _loc3_.left - _loc9_;
                           _loc9_ = _loc3_.left;
                           _loc6_ += _loc11_;
                           _loc8_--;
                           _loc7_ = false;
                        }
                     }
                     _loc10_ = _loc6_ + (_loc2_ < 20 ? 10 : 15);
                     if(_loc3_ != null)
                     {
                        if(_loc10_ > _loc3_.right)
                        {
                           _loc11_ = _loc10_ - _loc3_.right;
                           _loc10_ = _loc3_.right;
                           _loc6_ -= _loc11_;
                           _loc8_--;
                           _loc7_ = false;
                        }
                     }
                  }
                  _loc4_.movePoint = new Point(_loc9_,_loc4_.y);
                  _loc5_.movePoint = new Point(_loc10_,_loc5_.y);
               }
               else
               {
                  this.speaker1.movePoint = null;
                  this.speaker2.movePoint = null;
                  this.speaker1.currentAnimation = Animation.IDLE;
                  this.speaker2.currentAnimation = Animation.IDLE;
               }
            }
            _loc1_ = 0;
            while(_loc1_ < this.sentenceList.length)
            {
               if(_loc1_ in this.speakerList)
               {
                  this.speakerList[_loc1_].dispatchEvent(new GameEvent(GameEvent.ADD_CHAT_LOG,this.sentenceList[_loc1_]));
               }
               _loc1_++;
            }
            this._world.stage.addEventListener(GameEvent.GAME_UPDATE,this.runConversation);
            this._world.addEventListener(Event.REMOVED_FROM_STAGE,this.worldIsRemove);
         }
      }
      
      function worldIsRemove(param1:Event) : void
      {
         var _loc2_:* = this.speaker1.friendList.indexOf(this.speaker1.meetFriend);
         if(_loc2_ in this.speaker1.friendList)
         {
            this.speaker1.friendList.splice(_loc2_,1);
         }
         this.speaker1.meetFriend = null;
         _loc2_ = this.speaker2.friendList.indexOf(this.speaker2.meetFriend);
         if(_loc2_ in this.speaker2.friendList)
         {
            this.speaker2.friendList.splice(_loc2_,1);
         }
         this.speaker2.meetFriend = null;
         if(this._inTerrace != null)
         {
            this._inTerrace.hasConversation = false;
         }
         this._world.stage.removeEventListener(GameEvent.GAME_UPDATE,this.runConversation);
         this._world.removeEventListener(Event.REMOVED_FROM_STAGE,this.worldIsRemove);
      }
      
      function createBubbleText() : void
      {
         var _loc1_:* = undefined;
         if(this.sentenceList.length > 0 && this.speakerList.length > 0)
         {
            if(this._world != null && this.speakerList[0].parent != null)
            {
               this.bubbleText = new LegendDialogTextBox();
               _loc1_ = this._world.globalToLocal(this.speakerList[0].parent.localToGlobal(new Point(this.speakerList[0].x,this.speakerList[0].y)));
               this.bubbleText.yDistance = this.speakerList[0].dialogIconBox.yDistance;
               this.bubbleText.animate = false;
               this.bubbleText.text = this.sentenceList[0];
               this.bubbleText.relation = this.speakerList[0];
               this._world.conversationContainer.addChild(this.bubbleText);
            }
            else
            {
               this.bubbleText = null;
            }
         }
         else
         {
            this.bubbleText = null;
         }
      }
      
      function runConversation(param1:GameEvent) : void
      {
         var _loc2_:* = undefined;
         if(this.speaker1.movePoint == null && this.speaker2.movePoint == null)
         {
            this.speaker1.scaleX = this.speaker1.x < this.speaker2.x ? Number(1) : Number(-1);
            this.speaker2.scaleX = this.speaker2.x < this.speaker1.x ? Number(1) : Number(-1);
            if(this.bubbleText == null)
            {
               this.createBubbleText();
               if(this.bubbleText == null)
               {
                  _loc2_ = this.speaker1.friendList.indexOf(this.speaker1.meetFriend);
                  if(_loc2_ in this.speaker1.friendList)
                  {
                     this.speaker1.friendList.splice(_loc2_,1);
                  }
                  this.speaker1.meetFriend = null;
                  _loc2_ = this.speaker2.friendList.indexOf(this.speaker2.meetFriend);
                  if(_loc2_ in this.speaker2.friendList)
                  {
                     this.speaker2.friendList.splice(_loc2_,1);
                  }
                  this.speaker2.meetFriend = null;
                  this._world.stage.removeEventListener(GameEvent.GAME_UPDATE,this.runConversation);
                  this._world.removeEventListener(Event.REMOVED_FROM_STAGE,this.worldIsRemove);
               }
            }
            else if(this.bubbleText.getShownText().length >= this.bubbleText.text.length)
            {
               if(this.delayList[0]-- <= 0)
               {
                  this.sentenceList.shift();
                  this.speakerList.shift();
                  this.tipsList.shift();
                  this.delayList.shift();
                  this.bubbleText.parent.removeChild(this.bubbleText);
                  this.createBubbleText();
               }
            }
         }
      }
      
      public function set world(param1:World) : void
      {
         this._world = param1;
      }
      
      public function set inTerrace(param1:MovieClip) : void
      {
         this._inTerrace = param1;
         if(this._inTerrace != null)
         {
            this._inTerrace.hasConversation = true;
         }
      }
   }
}
