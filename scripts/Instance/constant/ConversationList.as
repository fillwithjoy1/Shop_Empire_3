package Instance.constant
{
   import Instance.modules.Calculate;
   import Instance.modules.Utility;
   import Instance.property.FacilityTerrace;
   
   public class ConversationList
   {
      
      public static const TRANSPORT_PROBLEM = ["How I can reach &fn.","I can\'t reach my destination yet.","Wierd! There is no elevator\nnor stairs to access &fn."];
      
      public static const CANT_GO_HOME = ["Help me! I was trapped here!","Where the way to go home.","I miss my home.","Please help me to get out\nfrom this wierd mall!"];
      
      public static const SEARCH_TOILET = ["I need to wash my hand.","Nature\'s call. Have to hurry.","I have to go to restroom."];
      
      public static const NO_TOILET = [["Damn! Idiot architect has\nforgot to build more restroom.","This is a suck mall that does not\nconsider the needs of visitor\'s sanitation."],["This mall is suck,\neven toilets are too little.","Weird mall with less restroom."],["I\'ll just go home\nand pee there.","This mall will be good\nif more restrooms exist."],["No more restroom here? Too Bad.","It\'s a great mall\nbut lack of restrooms."]];
      
      public static const NO_TRADING_POST = ["Enough for today.\nI ran out of money.","I wish I brought more money.","I have to save my money.\nBetter go home now."];
      
      public static const SEARCH_TRADING_POST = ["My money has runs out.","I will trade soething\nso I can shop more","Need to take money immediately!"];
      
      public static const WANT_GO_HOME = [["This is the worst place\nI have ever visited","I will never come here anymore\nfor the entire of my life."],["This mall is suck.","Maybe I won\'t come here again\nfor long time."],["Enough for today.","I\'d better to go home now."],["Great mall but\nI have to go home now.","Wonderful. I\'ll come\nback here next time."]];
      
      public static const SEARCH_DESTINATION = [["Going to be a book-o-holic today.","On the mood of reading romance story.","Got to buy cooking magazines.","New novel has been released."],["I need to know\nmy finance for this month.","I have problem with my &girl_boyfriend.\nNeed some consultation","What is my lucky color today?","I\'m jobless. I need to know\nmy suitable job"],["Something shiny wanted.","Need a diamond ring to propose &him_her.","I wan\'t to wear an accesory."],["My jar broken. Need a new one.","Need more pot to my flower.","A statue is good to be placed at my front home."],["I need an antidote.","What is a good herb for health?","Lavender is good for aromateraphy.","I want an aloe vera."],["I need a chemical to\nexplode an blocked boulder.","To many insect in my home.\nI wish a poison gas here.","Any energy drink here to\nincrease my attack power.","Any energy drink here to\nincrease my defense power."],["I found a rare iron.\nCan it be used for wonderful equipment?","I have a malachite.\nIt says good as armor.","This stone is wierd\nIs that usable to weapon?"],["I must slay the kraken.\nNeed a thunder orb.","Salamander weak with ice.\nIce gem was needed.","A plant monster block my way.\nNeed a fire orb.","The only one way to reach\nfloating castle is using wind orb."],["Need to cut my hair immediately.","I want to change my hair model.","I have to change my appearance to disguise.","My hair is too long. It block\nmy view during my quest."],["Need a helmet.","My breastplate is broken.","I lose my half of greaves.","My iron gloves is not strong\nenough. Need a new one."],["I need a hat for the winter.","My leatherpad was ripped","Need a gloves for a grip","My shoe is to heavy. Need the\nlight one to higher jump."],["Need a new sword.","My arrow is runs out.","Axe is better. Maybe.","I prefer a long pole.","I need a spear."],["A scroll of fire needed for my quest.","A scroll of water needed for my quest.","Need a phoenix feather.","What? A voodoo doll?"],["An eagle is good for scout.","Maybe a bear can help my quest.","Need a horse riding.","A lion maybe."],["Need corns for my chicken.","Need some of fertilizer","Need a horse for plow my field.","More pig for more fertilizer please.","How about some egg."],["How many chair I need? Three or four maybe?","Need some table. A table cloth too.","I wish have a mirror to fight Medusa.","Need more storage. Need more closet.","No more space for my book collection.\nMore shelf needed."],["My wagon wheel is broken.","I need a saddle.","There is a hole in a wall of my house.\nNeed a wood to cover it.","Need to buy a board."],["Apple, orange, guava and mango maybe.","Banana, grape, melon and papaya.","Durian........","Need more strawbery to make a juice.","More fruit for salad."],["Hmmm... Fresh Meat....","I want to make steak today.","Pork meat.. Sound delicious","Lamb or beef? It\'s hard to choose."],["Bread for today is a good idea.","I want pie.","Look like some cookies is okay."],["More soup please.","I want something gravy.","What about a stew for today?","Need something sauced."],["I\'d like a grilled meat.","Roasted turkey. Looks delicious.","Rosated or Grilled? Whatever.","I want meat but I\'m lazy to cook today."],["Wine... Please...","I\'m thristy...","Beer is good.","Give me some drink."],["Maybe I eat at restaurant today.","I want casual food.","I want to eat but I don\'t\nknow what to eat yet.","Lunch? Dinner? Breakfast? Whatever.\nWhere is the place with many kind of food."],["Where is Tavern?","I\'m hungry. But I want relax for a bit.","I\'m a bit tired after hunting. Now a a little hungry.","Any quest added? Better tease some meal."],["My home is too far.","Staying here is not bad choice.","I don\'t want to go home.\nLet me here for more time."],["Hot spring is good","I want to enjoy at the warm place.","There is Jacuzzi here? Let me see."],["Need message my body.","My body aches sore.\nNeed a treatment."],["Bored. Need a sport.","Playing bowling is good.","I have to get strike today."],["I want to hear Johann Straus work\nlike Pizzicato Polka","Ludwig Beethoven release Fur Elise\nas his new song.","Where I can hear Rondo Ala Turca song\nmade by Wolfgang Amadeus Mozart?"],["Today I want to see gladiator show.","Who are fight for today?","I wish to see God of War and\nHerkulez fight each other."]];
      
      public static const WALKING_AROUND = ["I still have no destination yet.","Maybe I\'ll just walking around\nbefore decide my next destination.","Let see what available in this mall."];
      
      public static var ANSWER_GREETING_1 = [[{
         "comment":"Perfect!",
         "nextComment":null
      },{
         "comment":"Great!",
         "nextComment":null
      }],[{
         "comment":"I\'m fine!",
         "nextComment":null
      },{
         "comment":"Not bad.",
         "nextComment":null
      }],[{
         "comment":"I\'m not good today.",
         "nextComment":null
      },{
         "comment":"I feel sick!",
         "nextComment":null
      }],[{
         "comment":"Don\'t talk with me now!\nI\'m in bad mood!",
         "nextComment":null
      },{
         "comment":"Do I know you?",
         "nextComment":null
      }]];
      
      public static var ANSWER_GREETING_2 = [[{
         "comment":"Shoping of course.",
         "nextComment":null
      }],[{
         "comment":"I\'m looking something tasty.",
         "nextComment":null
      }],[{
         "comment":"I need relaxment.",
         "nextComment":null
      }],[{
         "comment":"I was stress in home.\nMaybe I can enjoy somewhere else.",
         "nextComment":null
      }],[{
         "comment":"I don\'t know what\nI\'m doing here.",
         "nextComment":null
      }],[{
         "comment":"Just walking around.",
         "nextComment":null
      }]];
      
      public static var ANSWER_GREETING_3 = [[{
         "comment":"I wish to go &ds.&cn",
         "nextComment":null
      }],[{
         "comment":"Nowhere. I just walking around",
         "nextComment":null
      }],[{"comment":"I have to go home now."}]];
      
      public static var TOILET_HURRY = [{
         "comment":"Sorry! I\'m in urgent.",
         "nextComment":null
      },{
         "comment":"Nature\'s call. Sorry!",
         "nextComment":null
      }];
      
      public static var TOILET_ANSWER = [{
         "comment":"I have to go to restroom.",
         "nextComment":null
      },{
         "comment":"Toilet.",
         "nextComment":null
      }];
      
      public static var TRADING_POST_ANSWER = [{
         "comment":"My money is run out\nI need take more.",
         "nextComment":null
      },{
         "comment":"I will go to trading post.",
         "nextComment":null
      }];
      
      public static var GREETING = [{
         "comment":"Hi! How are you?",
         "nextComment":ANSWER_GREETING_1
      },{
         "comment":"Hi pal!\nWhat are you doing here?",
         "nextComment":ANSWER_GREETING_2
      },{
         "comment":"Hello!\nWhere are you going?",
         "nextComment":ANSWER_GREETING_3
      }];
      
      public static var ANSWER_TERRACE_1_1 = [{
         "comment":"That\'s right.",
         "nextComment":[{
            "comment":"When they\'re suitable,\npopularity will be increased.",
            "nextComment":[{
               "comment":"But if they\'re not suitable,\npopularity will be decreased.",
               "nextComment":null
            }]
         }],
         "sameSpeaker":true
      }];
      
      public static var ANSWER_TERRACE_1_2 = [{
         "comment":"Oh really?",
         "nextComment":[{
            "comment":"I wish I can met anyone here",
            "nextComment":null
         }],
         "sameSpeaker":true
      }];
      
      public static var ANSWER_TERRACE_1_3_1 = [{
         "comment":"Don\'t worry about it.",
         "nextComment":[{
            "comment":"They can be neutralized\nby security.",
            "nextComment":null,
            "tipsCode":"antiVillain"
         }],
         "sameSpeaker":true
      }];
      
      public static var ANSWER_TERRACE_1_3 = [{
         "comment":"I often see them throw dump anywhere.",
         "nextComment":ANSWER_TERRACE_1_3_1
      }];
      
      public static var ANSWER_TERRACE_1_4 = [{
         "comment":"Don\'t worry.\nYou can use ATM.",
         "nextComment":null,
         "tipsCode":"atmFunction"
      }];
      
      public static var ANSWER_TERRACE_1_5 = [{
         "comment":"That\'s right. But when hiring staff their\nwork area will be set at the spesific floor.",
         "nextComment":null,
         "tipsCode":"shiftKey"
      }];
      
      public static var ANSWER_TERRACE_1 = [{
         "comment":"Each booth has compatibility one to another.",
         "nextComment":ANSWER_TERRACE_1_1,
         "tipsCode":"boothCompatibility"
      },{
         "comment":"Any celebrities will come this mall\nif several conditions are fulfilled.",
         "nextComment":ANSWER_TERRACE_1_2,
         "tipsCode":"specialVisitorArrival"
      },{
         "comment":"Someone with red bandanda is a bad person.",
         "nextComment":ANSWER_TERRACE_1_3,
         "sameSpeaker":true
      },{
         "comment":"If I bring more money I can spend more.",
         "nextComment":[{
            "comment":"But I\'m afraid to bring too much.",
            "nextComment":ANSWER_TERRACE_1_4
         }],
         "sameSpeaker":true
      },{
         "comment":"By hold SHIFT key when when building or hiring staff\ncan make duplicate repeat the action quickly",
         "nextComment":ANSWER_TERRACE_1_5
      }];
      
      public static var ANSWER_TERRACE_2_1 = [{
         "comment":"Because we can find restroom faster.",
         "nextComment":[{
            "comment":"It\'s waste time if have to go up and down\njust to find a restroom.",
            "nextComment":[{
               "comment":"Hey! You\'re right!",
               "nextComment":null
            }]
         }],
         "sameSpeaker":true,
         "tipsCode":"restroomEffectiveity"
      }];
      
      public static var ANSWER_TERRACE_2_2 = [{
         "comment":"Restroom and food booth is not\nsuitable because of stink or something.",
         "nextComment":[{
            "comment":"Oh.. I see",
            "nextComment":null
         }],
         "tipsCode":"restroomNotCompatible"
      }];
      
      public static var ANSWER_TERRACE_2_3 = [{
         "comment":"They are people you know. They\'re entertainers.\nThey\'re hired to make us happy.",
         "nextComment":[{
            "comment":"Hmmm. I think there are\npeople like that too here.",
            "nextComment":null
         }],
         "tipsCode":"entertainer"
      }];
      
      public static var ANSWER_TERRACE_2 = [{
         "comment":"They build restroom at each floor.\nWhy they\'re doing that?",
         "nextComment":ANSWER_TERRACE_2_1
      },{
         "comment":"They never build restroom and\nfood booth in the adjacent.",
         "nextComment":ANSWER_TERRACE_2_2
      },{
         "comment":"They have many stuffed animals.\nWhat are they anyway?",
         "nextComment":ANSWER_TERRACE_2_3
      }];
      
      public static var ANSWER_TERRACE_3_FIN = [{
         "comment":"Everything has adventage\nand disadventage.",
         "nextComment":null,
         "tipsCode":"elevatorAndEscalator"
      }];
      
      public static var ANSWER_TERRACE_3_1 = [{
         "comment":"But it has limited capacity.",
         "nextComment":ANSWER_TERRACE_3_FIN
      }];
      
      public static var ANSWER_TERRACE_3_2 = [{
         "comment":"But it moves slowly.",
         "nextComment":ANSWER_TERRACE_3_FIN
      }];
      
      public static var ANSWER_TERRACE_3 = [{
         "comment":"Elevator. Because it moves faster.",
         "nextComment":ANSWER_TERRACE_3_1
      },{
         "comment":"Escalator. Because I don\'t need to wait.",
         "nextComment":ANSWER_TERRACE_3_2
      }];
      
      public static var TERRACE = [{
         "comment":"Hey do you know about this?",
         "nextComment":ANSWER_TERRACE_1,
         "sameSpeaker":true
      },{
         "comment":"I heard rumor about\nnext town mall.",
         "nextComment":ANSWER_TERRACE_2,
         "sameSpeaker":true
      },{
         "comment":"Which one do you like better?\nElevator or Escalator?",
         "nextComment":ANSWER_TERRACE_3
      }];
       
      
      public function ConversationList()
      {
         super();
      }
      
      public static function getRandomConversation(param1:Object, param2:Object) : Object
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc3_:* = null;
         var _loc4_:* = null;
         if(param2 == GREETING)
         {
            _loc4_ = param2;
         }
         else if(param2 == ANSWER_GREETING_1)
         {
            if(param1.needToGo)
            {
               _loc4_ = TOILET_HURRY;
            }
            else
            {
               _loc4_ = param2[3 - param1.statification];
            }
         }
         else if(param2 == ANSWER_GREETING_2)
         {
            if(param1.needToGo)
            {
               _loc4_ = TOILET_HURRY;
            }
            else if(param1.destination != "home" && param1.destination != "exit" && param1.destination != null)
            {
               _loc7_ = BuildingData.returnClassTo(Utility.getClass(param1.destination));
               if((_loc8_ = BuildingData.getCategoryOf(_loc7_)) != null)
               {
                  switch(_loc8_)
                  {
                     case BuildingData.GENERAL:
                        _loc4_ = param2[0];
                        break;
                     case BuildingData.FOOD:
                        _loc4_ = param2[1];
                        break;
                     case BuildingData.INN:
                        _loc4_ = param2[2];
                        break;
                     case BuildingData.ENTERTAINMENT:
                        _loc4_ = param2[3];
                        break;
                     default:
                        _loc4_ = param2[5];
                  }
               }
            }
            else if(param1.destinationTargetList.length > 0)
            {
               _loc4_ = param2[4];
            }
            else
            {
               _loc4_ = param2[5];
            }
         }
         else if(param2 == ANSWER_GREETING_3)
         {
            if(param1.destination != null && param1.destination != "home")
            {
               if(param1.destination is FacilityTerrace)
               {
                  if(param1.restRoomTarget == null && param1.tradingPostTarget == null)
                  {
                     _loc4_ = param2[0];
                  }
                  else if(param1.pastDestination != null)
                  {
                     _loc4_ = param2[0];
                  }
                  else if(param1.restRoomTarget != null)
                  {
                     _loc4_ = TOILET_ANSWER;
                  }
                  else
                  {
                     _loc4_ = TRADING_POST_ANSWER;
                  }
               }
               else
               {
                  _loc4_ = param2[1];
               }
            }
            else if(param1.destination == "home")
            {
               _loc4_ = param2[2];
            }
            else if(param1.destinationTargetList.length > 0)
            {
               _loc4_ = param2[0];
            }
            else if(param1.restRoomTarget != null)
            {
               _loc4_ = TOILET_ANSWER;
            }
            else if(param1.tradingPostTarget != null)
            {
               _loc4_ = TRADING_POST_ANSWER;
            }
            else
            {
               _loc4_ = param2[1];
            }
         }
         else
         {
            _loc4_ = param2;
         }
         var _loc5_:*;
         var _loc6_:* = (_loc5_ = Utility.cloning(_loc4_[Math.floor(Math.random() * _loc4_.length)])).comment;
         if(param1.destinationTargetList.length > 0)
         {
            _loc6_ = _loc6_.replace(/&ds/g,"to " + param1.destinationTargetList[0].toLowerCase());
            if(!param1.needToGo)
            {
               if(param1.destination == null || param1.destination is FacilityTerrace)
               {
                  _loc6_ = _loc6_.replace(/&cn/g,"\nBut I have not found it yet.");
               }
               else if(param1.destination is BuildingData.getClassOf(param1.destinationTargetList[0]))
               {
                  _loc6_ = _loc6_.replace(/&cn/g,"\nI need something there");
               }
               else
               {
                  _loc6_ = _loc6_.replace(/&cn/g,"\nBut I have to go somewhere else.");
               }
            }
            else
            {
               _loc6_ = _loc6_.replace(/&cn/g,"\nBut I will search a restroom first.");
            }
         }
         else if(param1.destination != null && !(param1.destination is FacilityTerrace) && param1.destination != "home")
         {
            if(param1.restRoomTarget == null && param1.tradingPostTarget == null)
            {
               if((_loc9_ = BuildingData.returnClassTo(Utility.getClass(param1.destination))) != null)
               {
                  _loc6_ = (_loc6_ = _loc6_.replace(/&ds/g,"to " + _loc9_.toLowerCase())).replace(/&cn/g,"\nThere seems to be something good there.");
               }
            }
            else if(param1.restRoomTarget != null)
            {
               if(param1.pastDestination != null)
               {
                  _loc6_ = _loc6_.replace(/&ds/g,"to " + BuildingData.returnClassTo(Utility.getClass(param1.pastDestination)).toLowerCase());
               }
               _loc6_ = _loc6_.replace(/&cn/g,"\nBut I will search a restroom first.");
            }
            else if(param1.tradingPostTarget != null)
            {
               if(param1.pastDestination != null)
               {
                  _loc6_ = _loc6_.replace(/&ds/g,"to " + BuildingData.returnClassTo(Utility.getClass(param1.pastDestination)).toLowerCase());
               }
               _loc6_ = _loc6_.replace(/&cn/g,"\nBut I need to refund my money in trading post.");
            }
         }
         else if(param1.destination == "home")
         {
            _loc6_ = (_loc6_ = _loc6_.replace(/&ds/g,"home")).replace(/&cn/g,"");
         }
         else
         {
            _loc6_ = (_loc6_ = _loc6_.replace(/&ds/g,"anywhere")).replace(/&cn/g,"");
         }
         _loc5_.comment = _loc6_;
         return _loc5_;
      }
      
      public static function generateConversation(param1:*) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc2_:* = new Object();
         _loc2_.transportProblem = TRANSPORT_PROBLEM.concat();
         _loc2_.cantGoHome = CANT_GO_HOME.concat();
         _loc2_.toilet = SEARCH_TOILET.concat();
         _loc2_.noToilet = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < NO_TOILET.length)
         {
            _loc2_.noToilet.push(NO_TOILET[_loc3_].concat());
            _loc3_++;
         }
         _loc2_.noTradingPost = NO_TRADING_POST.concat();
         _loc2_.tradingPost = SEARCH_TRADING_POST.concat();
         _loc2_.goingHome = new Array();
         _loc3_ = 0;
         while(_loc3_ < WANT_GO_HOME.length)
         {
            _loc2_.goingHome.push(WANT_GO_HOME[_loc3_].concat());
            _loc3_++;
         }
         _loc2_.booth = new Object();
         _loc3_ = 0;
         while(_loc3_ < BuildingData.BUILDING_LIST.length)
         {
            if(_loc3_ in SEARCH_DESTINATION)
            {
               _loc4_ = BuildingData.BUILDING_LIST[_loc3_];
               _loc2_.booth[_loc4_] = SEARCH_DESTINATION[_loc3_].concat();
               _loc5_ = 0;
               while(_loc5_ < _loc2_.booth[_loc4_].length)
               {
                  _loc6_ = (_loc6_ = (_loc6_ = _loc2_.booth[_loc4_][_loc5_]).replace(/&girl_boy/g,param1.gender == 1 ? "girl" : (param1.gender == -1 ? "boy" : ""))).replace(/&him_her/g,param1.gender == 1 ? "her" : (param1.gender == -1 ? "him" : ""));
                  _loc2_.booth[_loc4_][_loc5_] = _loc6_;
                  _loc5_++;
               }
            }
            _loc3_++;
         }
         _loc2_.noDestination = WALKING_AROUND.concat();
         return _loc2_;
      }
      
      public static function getConversationType(param1:String) : Array
      {
         var _loc2_:* = new Array();
         if(param1 == "Greet")
         {
            _loc2_ = GREETING.concat();
         }
         else if(param1 == "Terrace")
         {
            _loc2_ = TERRACE.concat();
            if(Calculate.chance(60))
            {
               if(2 in _loc2_)
               {
                  _loc2_.splice(2,1);
               }
            }
         }
         return _loc2_;
      }
   }
}
