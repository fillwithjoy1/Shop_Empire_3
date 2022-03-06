package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.events.HumanEvent;
   import Instance.events.LoopEvent;
   import Instance.property.Elevator;
   import Instance.property.FacilityElevatorBody;
   import Instance.property.FacilityStairs;
   import Instance.property.HumanStat;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class Kratos extends SpecialVisitor
   {
      
      static const SEARCH_DESTINATION = [["I want to read something."],["I need to find a way to defeat Zeus."],["I don\'t know what is it but it looks shiny."],["I have destroyed a collosus.\nI need to replace with a new one."],["I need an antidote."],["Need a energy drink."],["I have to sharpen my Blade of Chaos"],["A gem needed to complete olympus puzzle"],["I know I\'m bald but I have\nbeard to take a treatment"],["I never wear armor but\nmaybe I need one this time."],["Need boots of Hermes."],["Need a Blade of Athena.","Need a Blade of Exile.","Need an Olympus Sword."],["Need more gorgon eyes."],["Need a pet. I wish they don\'t betray me."],["There is something at Live Stock?"],["Need a shelf for Head of Helios."],["Need a Wood"],["I\'m hungry..."],["I\'m hungry..."],["I\'m hungry..."],["I\'m hungry..."],["I\'m hungry..."],["I\'m thristy..."],["I\'m hungry..."],["After killing to many gods\nI\'m hungry right now."],["I\'m tired."],["I want to take a bath"],["Need relax a bit in a spa."],["I want to throw human head."],["What a Music?"],["I want to watch a chaos","Actually I want perform a fight."]];
       
      
      var toKill;
      
      public function Kratos()
      {
         super();
         _model = "Kratos";
         _codeName = "KRATOS";
         _extraDescription = "He will punish anyone who curse him.";
         maxMoodCome = 40;
      }
      
      override protected function Initialize(param1:Event) : void
      {
         super.Initialize(param1);
         addListenerOf(_world,HumanEvent.CAST_SPELL,this.whenSomeoneCurseMe);
      }
      
      function whenSomeoneCurseMe(param1:HumanEvent) : void
      {
         if(param1.tag == this)
         {
            this.toKill = param1.target;
         }
      }
      
      override function behavior(param1:HumanEvent) : void
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         if(this.toKill != null)
         {
            if(!_passive)
            {
               _loc2_ = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
               if(this.toKill.stage == null)
               {
                  this.toKill = null;
               }
               else if(this.toKill is Wizard && _world.wizardList.indexOf(this.toKill) < 0)
               {
                  this.toKill = null;
               }
               else
               {
                  _loc3_ = _world.mainContainer.globalToLocal(this.toKill.localToGlobal(new Point(0,0)));
                  if((_loc4_ = Math.abs(_loc3_.y - _loc2_.y)) >= 126)
                  {
                     this.toKill = null;
                  }
                  else if((_loc5_ = Math.abs(_loc3_.x - _loc2_.x)) >= getSight() * 1.5)
                  {
                     this.toKill = null;
                  }
                  if(this.toKill.isCaught)
                  {
                     this.toKill = null;
                  }
                  else if(this.toKill.inside is Elevator)
                  {
                     this.toKill = null;
                  }
               }
            }
         }
         else
         {
            super.behavior(param1);
         }
      }
      
      override function initPurse() : void
      {
         _initialPurse = 800;
         _purse = _initialPurse;
      }
      
      override function movingCheck(param1:LoopEvent) : void
      {
         if(!_passive)
         {
            if(this.toKill != null)
            {
               this.pursueTheTarget(this.toKill);
               _run = true;
            }
            else if(_restRoomPercentage < 85)
            {
               if(_world.deepRain && _world.weather <= -20)
               {
                  _run = !insideMall;
               }
               else
               {
                  _run = false;
               }
            }
         }
         super.movingCheck(param1);
      }
      
      function pursueTheTarget(param1:*) : void
      {
         var _loc9_:* = undefined;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc2_:* = param1.onFloor;
         var _loc3_:* = onFloor;
         var _loc4_:* = _world.mainContainer.globalToLocal(this.localToGlobal(new Point(0,0)));
         var _loc5_:* = _world.mainContainer.globalToLocal(param1.localToGlobal(new Point(0,0)));
         var _loc6_:* = Math.abs(_loc5_.x - _loc4_.x);
         var _loc7_:* = false;
         var _loc8_:* = false;
         if(_inside is FacilityStairs)
         {
            if(param1.inside == _inside)
            {
               if(_loc6_ > 20)
               {
                  _movePoint = this.parent.globalToLocal(_world.mainContainer.localToGlobal(new Point(_loc5_.x,_loc5_.y)));
               }
               else
               {
                  _movePoint = null;
                  _loc7_ = true;
               }
            }
            else if(param1.inside == null || param1.inside is FacilityElevatorBody)
            {
               if(_floorTarget != _loc2_)
               {
                  _floorTarget = _loc2_;
                  _floorPoint = new Point(_loc5_.x,_loc5_.y);
                  _movePoint = null;
                  _destinationTransport = null;
                  if(_transportQueue.length > 1 && _transportQueue[0] != _inside)
                  {
                     _transportQueue = [_inside];
                  }
                  insideStairsCheck();
               }
            }
         }
         else
         {
            if(_inside is FacilityElevatorBody)
            {
               if(_transportQueue.length == 0 || _transportQueue[0] != _inside)
               {
                  _inside.removePerson(this);
                  if((_loc9_ = _inside.queueLine.indexOf(this)) in _inside.queueLine)
                  {
                     _inside.queueLine.splice(_loc9_,1);
                  }
                  if((_loc10_ = _inside.elevatorLink) != null)
                  {
                     if((_loc11_ = _loc10_.passanger.indexOf(this)) in _loc10_.passanger)
                     {
                        _loc10_.passanger.splice(_loc11_,1);
                     }
                  }
                  _inside = null;
               }
            }
            if(_inside == null)
            {
               if(param1.inside == null || param1.inside is FacilityElevatorBody)
               {
                  if(_loc2_ == _loc3_)
                  {
                     if(_loc6_ > 20)
                     {
                        _movePoint = new Point(_loc5_.x,_loc5_.y);
                     }
                     else
                     {
                        _movePoint = null;
                        _loc7_ = true;
                     }
                     _destinationTransport = null;
                     _transportQueue = new Array();
                  }
                  else if(_floorTarget != _loc2_)
                  {
                     _destinationTransport = null;
                     _transportQueue = new Array();
                     _floorTarget = _loc2_;
                     _floorPoint = new Point(_loc5_.x,_loc5_.y);
                  }
               }
               else if(param1.inside is FacilityStairs)
               {
                  if((_loc12_ = param1.inside.entrancePosition(_loc4_.y)) != null)
                  {
                     if(_transportQueue.length != 1 || _transportQueue[0] != param1.inside)
                     {
                        _destinationTransport = null;
                        _transportQueue = [param1.inside];
                        _floorTarget = null;
                     }
                  }
               }
               else if(!(param1.inside is Elevator))
               {
                  _loc8_ = true;
                  if(_destination != param1.inside)
                  {
                     _destination = param1.inside;
                     super.destinationTargetCheck();
                  }
               }
            }
         }
         if(!_loc8_)
         {
            if(_destination != null)
            {
               _destination = null;
            }
         }
         if(_loc7_)
         {
            param1.caught();
            param1.dispatchEvent(new GameEvent(GameEvent.ARRESTED));
            this.toKill = null;
         }
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.speed = 65;
         _stat.stamina = 100;
         _stat.sight = 75;
         _stat.hygine = 20;
         _stat.entertain = 30;
         _stat.characterName = "God of War";
         restRoomIncrementChance = 3 * ((100 - _stat.hygine) / 100) + 4;
      }
      
      override function setFavoriteList() : void
      {
         var _loc1_:* = new Array();
         _loc1_.push("Weaponry");
         _loc1_.push("Weaponry");
         _loc1_.push("Weaponry");
         _loc1_.push("Blacksmith");
         _loc1_.push("Blacksmith");
         _loc1_.push("Blacksmith");
         _loc1_.push("Tavern");
         _loc1_.push("Tavern");
         _loc1_.push("Colloseum");
         _loc1_.push("(none)");
         sortFavorite(_loc1_);
      }
      
      override public function initData() : void
      {
         this.setFavoriteList();
         _gender = 1;
         this.generateConversation();
      }
      
      override function generateConversation() : void
      {
         var _loc2_:* = undefined;
         super.generateConversation();
         _singleConversation.toilet = ["Release me from\nthis torment of my life."];
         _singleConversation.noToilet[0] = ["No toilet? Release me from\nthis torment of my life."];
         _singleConversation.noToilet[1] = ["No toilet? Release me from\nthis torment of my life."];
         _singleConversation.noToilet[2] = ["No toilet? Release me from\nthis torment of my life."];
         _singleConversation.noToilet[3] = ["No toilet? Release me from\nthis torment of my life."];
         _singleConversation.noTradingPost = ["If I brought more money."];
         _singleConversation.tradingPost = ["I need to sell a minotaur\nhorn that I killed yesterday."];
         _singleConversation.goingHome = new Array();
         _singleConversation.goingHome[0] = ["ARES! DESTROY THIS MALL.\nAnd my life is yours."];
         _singleConversation.goingHome[1] = ["Hydra stomatch better than here."];
         _singleConversation.goingHome[2] = ["I\'m home now!"];
         _singleConversation.goingHome[3] = ["I\'m home now!\nI\'m here next time."];
         _singleConversation.booth = new Object();
         var _loc1_:* = 0;
         while(_loc1_ < BuildingData.BUILDING_LIST.length)
         {
            if(_loc1_ in SEARCH_DESTINATION)
            {
               _loc2_ = BuildingData.BUILDING_LIST[_loc1_];
               _singleConversation.booth[_loc2_] = SEARCH_DESTINATION[_loc1_].concat();
            }
            _loc1_++;
         }
         _singleConversation.noDestination = ["Lets walking around"];
      }
      
      override function updateInHome(param1:GameEvent) : void
      {
         var _loc2_:* = undefined;
         if(_inHome)
         {
            if(favoriteUnlock(70))
            {
               _loc2_ = param1.tag;
               if(_loc2_.hour == 10 && _loc2_.minute == 0)
               {
                  if(moodCheck())
                  {
                     hourCome = Math.floor(Math.random() * 6) + 11;
                     minuteCome = Math.floor(Math.random() * 60);
                     trace("datang jam " + hourCome + ":" + minuteCome);
                  }
               }
            }
         }
         super.updateInHome(param1);
      }
   }
}
