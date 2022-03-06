package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.property.HumanStat;
   
   public class Gollum extends SpecialVisitor
   {
      
      static const SEARCH_DESTINATION = [["What has roots as nobody sees,\nis taller than trees,\nUp, up it goes,\nAnd yet never grows?"],["We need to foresee our precious."],["My precious!!!\nHuh, its the replica.."],["It\'s there!! Our precious!\ninside one of it"],["We need sumtin to prevent hairloss"],["We need energy to search our precious"],["We need to sharpen our teeth"],["So bright... so beautiful... ah, Precious."],["My precious hair.."],["Maybe a chain loincloth looks good.."],["We need new precious loincloth"],["Is there any new teeth?"],["We must curse the one who hold our precious!!"],["Maybe I need other ugly friend"],["Those livestock.. They eat it!\nOur precious!!"],["We need new stone bed"],["We can searh our precious faster with that"],["Sir Meugoll is hungry..."],["Sir Meugoll is hungry..."],["Sir Meugoll is hungry..."],["Sir Meugoll is hungry..."],["Sir Meugoll is hungry..."],["Sir Meugoll is thirsty..."],["Sir Meugoll is hungry..."],["We need information\nto search our precious"],["Sir Meugoll is tired.."],["Sir Meugoll want to take a bath"],["Sir Meugoll Need relax a bit in a spa."],["Sir Meugoll want to play"],["Sir Meugoll want to dance"],["I\'ll bites them all like fish!"]];
       
      
      public function Gollum()
      {
         super();
         _model = "Gollum";
         _codeName = "GOLLUM";
         _extraDescription = "Garbage doesn\'t drop his mood.";
         maxMoodCome = 50;
      }
      
      override function generateConversation() : void
      {
         var _loc2_:* = undefined;
         super.generateConversation();
         _singleConversation.noTradingPost = ["Someone stole my precious."];
         _singleConversation.tradingPost = ["Someone stole my precious."];
         _singleConversation.goingHome = new Array();
         _singleConversation.goingHome[0] = ["Sir Meugoll  is free!"];
         _singleConversation.goingHome[1] = ["Sir Meugoll  is free!"];
         _singleConversation.goingHome[2] = ["Sir Meugoll  is free!"];
         _singleConversation.goingHome[3] = ["Sir Meugoll  is free!"];
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
         _singleConversation.noDestination = ["I\'m coming for you my precious!"];
      }
      
      override function initPurse() : void
      {
         _initialPurse = 500;
         _purse = _initialPurse;
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.speed = 5;
         _stat.stamina = 35;
         _stat.sight = 45;
         _stat.hygine = 10;
         _stat.entertain = 35;
         _stat.characterName = "Sir Meugoll";
         restRoomIncrementChance = 4 * ((100 - _stat.hygine) / 100) + 5;
      }
      
      override function setFavoriteList() : void
      {
         var _loc1_:* = new Array();
         _loc1_.push("Gem Shop");
         _loc1_.push("Gem Shop");
         _loc1_.push("Gem Shop");
         _loc1_.push("Pottery");
         _loc1_.push("Pottery");
         _loc1_.push("Pottery");
         _loc1_.push("Jewellry");
         _loc1_.push("Jewellry");
         _loc1_.push("Spa");
         _loc1_.push("(none)");
         sortFavorite(_loc1_);
      }
      
      override public function initData() : void
      {
         this.setFavoriteList();
         _gender = 1;
         this.generateConversation();
      }
      
      override function trashCheck() : void
      {
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
                     hourCome = Math.floor(Math.random() * 3) + 13;
                     minuteCome = Math.floor(Math.random() * 60);
                  }
               }
            }
         }
         super.updateInHome(param1);
      }
   }
}
