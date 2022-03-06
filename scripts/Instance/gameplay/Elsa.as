package Instance.gameplay
{
   import Instance.constant.BuildingData;
   import Instance.events.GameEvent;
   import Instance.property.HumanStat;
   
   public class Elsa extends SpecialVisitor
   {
      
      static const SEARCH_DESTINATION = [["I want to read something."],["Is someone know my secret?\nI have to ask the fortune teller."],["My little sister must\nbe like some necklace."],["Is nice statue sold here?\nIs it made by ice?"],["My mistake hitting my sister with\nmy ice power. Need a medicine."],["Need some potion."],["It\'s weird to blacksmith but I want\nto see something good there.","Maybe i can craft clacial sword here"],["Is ice gem exist?"],["Need to braid my hair."],["It\'s wierd to armory but I want\nto see something good there."],["The snow glows white on the\nmountain tonight. Need a winter coat.","The wind is howling like this\nswirling storm inside. Need a mantle.","My gloves missing. Need a new one\nto cover my secret."],["I don\'t care what they\'re\ngoing to say but\nI will go to Weaponry"],["Need some craft to control my ice magic."],["They sell animal? I\'ll buy one\nand then let it go."],["There is something at Live Stock?"],["Need some wooden chair.\nice chair made my clothes wet"],["My little sister broke the iceman\'s cart.\nI will buy a new one for compensation."],["An Elegant food is fruit."],["Need some meat."],["Need a pie."],["Need some soup."],["Need a steak."],["I\'m thristy."],["I\'m hungry."],["What made an adventurer\ngather at Tavern?"],["Let me sleep, Let me sleep.\nDon\'t bother me anymore."],["A hot spring. Cold\nnever bothered me anyway."],["Covering my ice power make me\ntired. Need a treatment."],["Can I use an ice ball to play?"],["I want to watch a music\nperformance. I can sing too.","I can\'t stop humming from my little sister\'s song.\nDo you want to build a snowman..."],["This time to see what I can do\nto test the limit and breaktrough."]];
       
      
      public function Elsa()
      {
         super();
         _model = "Elsa";
         _codeName = "ELSA";
         _extraDescription = "Whenever someone curse her, she will froze herself and the caster.";
      }
      
      override function initPurse() : void
      {
         _initialPurse = 1000;
         _purse = _initialPurse;
      }
      
      override function initStat() : void
      {
         _stat = new HumanStat();
         _stat.speed = 35;
         _stat.stamina = 45;
         _stat.sight = 55;
         _stat.hygine = 100;
         _stat.entertain = 35;
         _stat.characterName = "Snow Queen";
         restRoomIncrementChance = 2;
      }
      
      override function generateConversation() : void
      {
         var _loc2_:* = undefined;
         super.generateConversation();
         _singleConversation.toilet = ["Let it go, let it go.\nCan\'t hold it back anymore."];
         _singleConversation.noToilet[0] = ["Let it go, let it go.\nCan\'t hold it back anymore."];
         _singleConversation.noToilet[1] = ["Let it go, let it go.\nCan\'t hold it back anymore."];
         _singleConversation.noToilet[2] = ["Let it go, let it go.\nCan\'t hold it back anymore."];
         _singleConversation.noToilet[3] = ["Let it go, let it go.\nCan\'t hold it back anymore."];
         _singleConversation.noTradingPost = ["My money runs out."];
         _singleConversation.tradingPost = ["Sorry my snowman doll. I have\nto sell you to get more money."];
         _singleConversation.goingHome = new Array();
         _singleConversation.goingHome[0] = ["Let me go! Let me go!\nI won\'t going here anymore."];
         _singleConversation.goingHome[1] = ["No right, no wrong,\nno rules for me.\nI\'m free."];
         _singleConversation.goingHome[2] = ["This mall never bothered me anyway."];
         _singleConversation.goingHome[3] = ["Should I invite my little\nsister here next time?"];
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
         _singleConversation.noDestination = ["Where am I going? Not a footprint to be seen."];
      }
      
      override function setFavoriteList() : void
      {
         var _loc1_:* = new Array();
         _loc1_.push("Wardrobe");
         _loc1_.push("Wardrobe");
         _loc1_.push("Wardrobe");
         _loc1_.push("Witchcraft");
         _loc1_.push("Witchcraft");
         _loc1_.push("Witchcraft");
         _loc1_.push("Jewellry");
         _loc1_.push("Jewellry");
         _loc1_.push("Music Hall");
         _loc1_.push("(none)");
         sortFavorite(_loc1_);
      }
      
      override public function initData() : void
      {
         this.setFavoriteList();
         _gender = -1;
         this.generateConversation();
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
                     hourCome = Math.floor(Math.random() * 5) + 10;
                     if(hourCome == 10)
                     {
                        minuteCome = 30 + Math.floor(Math.random() * 30);
                     }
                     else
                     {
                        minuteCome = Math.floor(Math.random() * 60);
                     }
                  }
               }
            }
         }
         super.updateInHome(param1);
      }
   }
}
