(* Nick Kitchel *)
(* CS 210 *)
(* HearthStone Assignment *)

val (Health, AIHealth) = (ref (0, false, "Health", 0, 30), ref (0, false, "AIHealth", 0, 30) );
val turn = ref 1;
val mana = ref 1;
val cost = 1;				(*Starting cost*)
val AImana = ref 1;			(*Mana and computer mana with turn information*)

val empty = ref(0, false, "empty", 0 , 0);
val (peasant, diver) = ( ref(1, false, "peasant" , 2, 4), ref(1, false, "diver", 2, 3) );
val (merchant, sailor) = ( ref(2, false, "merchant", 3, 5), ref(2, false, "sailor", 7, 1) );
val (jugler, ranger) = ( ref(3, false, "jugler", 2, 8), ref(3, false, "ranger", 6, 7) );
val (soldier, thief) = ( ref(4, false, "soldier", 8, 8), ref(4, false, "thief", 10, 7) );
val (knight, wizard) = ( ref(5, false, "knight", 11, 9), ref(5, false, "wizard", 12, 9) );
val (guard, horseman) = ( ref(6, false, "guard", 6, 13), ref(6, false, "horseman", 14, 8) );
val (prince, king) = ( ref(8, false, "prince", 13, 14), ref(10, false, "king", 14, 14) );
val (waterball, fireball) = ( ref(2, true, "waterball", 5, 0), ref(4, true, "fireball", 7, 0) );
val (moat, bomb) = ( ref(6, true, "moat", 9, 0), ref(8, true, "bomb", 10, 0) );

val hand = ref [!empty, !peasant, !diver, !merchant]; 
val deck = ref [!sailor, !jugler, !ranger, !soldier, !thief, !knight, 
			!wizard, !guard, !horseman, !prince, !king, !waterball, !fireball, !moat, !bomb];
			(*This is your hand, and the extra cards that can be drawn*)

val (lexie, gullma) = ( ref(1, false, "lexie", 3, 1), ref(1, false, "gullma", 1, 2) );
val (elvan, quanto) = ( ref(2, false, "elvan", 4, 2), ref(2, false, "quanton", 1, 6) );
val (muta, ahoka) = ( ref(3, false, "muta", 8, 1), ref(3, false, "ahoka", 4, 8) );
val (moom, odesy) = ( ref(4, false, "moom", 2, 10), ref(4, false, "odesy", 6, 3) );
val (jetta, yumo) = ( ref(5, false, "jetta", 6, 8), ref(5, false, "yumo", 5, 5) );
val (pnom, cromp) = ( ref(6, false, "pnom", 8, 6), ref(6, false, "cromp", 6, 12) );
val (darty, wowi) = ( ref(8, false, "darty", 10, 10), ref(10, false, "wowi", 12, 10) );
val AIhand = ref [!empty, !lexie, !gullma, !elvan];
val AIdeck = ref [!quanto, !muta, !ahoka, !moom, !odesy, !jetta, !yumo,
			!pnom, !cromp, !darty, !wowi];
			(*This is the AIhand and deck for extra cards*)

val Minions = ref [(0, false, "Empty", 0, 0)];
val Monsters = ref [(0, false, "Empty", 0, 0)];

fun delete (list) = tl list;		(*removing the head of a list*)

fun new_card (list, (q,w,e,r,t)) =	(*Adding a card to your hand from deck*)
	list@[(q,w,e,r,t)];

fun remove ((q,w,e,r,t), list) =	(*Removes one minion from a list if its a match*)
    case list of
	 []=> [] | 
	 (y,u,k,l,p)::ys => (if e = k
				then remove((q,w,e,r,t),ys)
				else (y,u,k,l,p)::(remove((q,w,e,r,t),ys)));

fun eliminate ((q,w,e,r,t)::xs) =	
			if (e = "Empty" andalso xs = []) then [(q,w,e,r,t)]
			else if (e = "Empty" andalso xs <> []) then [(q,w,e,r,t)]@eliminate(xs)
			else if (t > 0 andalso xs = []) then [(q,w,e,r,t)]
			else if (t <= 0 andalso xs = []) then []
			else if t <= 0 then	[]@eliminate (xs)	
			else [(q,w,e,r,t)]@eliminate (xs); 
			(*This function removes all cards from a list that
			  have a zero health remaining*)		

fun play (a, (q,w,e,r,t)::xs) = if (xs = [] andalso a <> e) then [(0,false, "Empty", 0, 0)]
		else if a = e then [(q,w,e,r,t)]
		else play (a, xs);
		(*Finds a minion if it is going to be played*)

fun attack_hero ((y,u,i,l,p),(q,w,e,r,t)) = 
	if q < 1 then (print "Can't attack with this minion yet, maybe next turn\n")
	else if r > 0 then (AIHealth := (0, false, "AIHealth", 0, (p - r)))
	else (AIHealth := (y,u,i,l,p));
		(*Function decides if a minion can attack, if it can 
		  then it will deal damage to the AIHealth*)

fun attack_heroAI ((y,u,i,l,p),(q,w,e,r,t)) = 
	if r > 0 then (Health := (0, false, "Health", 0, (p - r)))
	else ();
		(*This is a function to attack the enemy hero*)

fun attack ((y,u,i,l,p), (g,h,j,n,m), (q,w,e,r,t)::xs) =
	if g = 0 then (print "Can't attack with this minion yet, maybe next turn\n" ; (q,w,e,r,t)::xs)
	else if (xs = [] andalso j <> e) then [(q,w,e,r,t)] 
	else if (xs = [] andalso j = e) then [(0,w,e,r, (m-l))]
	else if j = e then [(0,w,e,r,(m-l))]@(attack ((y,u,i,l,p), (g,h,j,n,m), xs))
	else [(q,w,e,r,t)]@(attack ((y,u,i,l,p), (g,h,j,n,m), xs));
		(*Finds a minion to attack if all the requirements are all met*)

fun attackAI ((y,u,i,l,p), (g,h,j,n,m), (q,w,e,r,t)::xs) =
	if (xs = [] andalso j <> e) then [(q,w,e,r,t)] 
	else if (xs = [] andalso j = e) then [(q,w,e,r, (m-l))]
	else if j = e then [(q,w,e,r,(m-l))]@(attackAI ((y,u,i,l,p), (g,h,j,n,m), xs))
	else [(q,w,e,r,t)]@(attackAI ((y,u,i,l,p), (g,h,j,n,m), xs));
		(*Finds a minion to attack if all the requirements are all met*)
		
fun length x = 
	case x of
		[] => 0 |
		_ => 1 + length (tl x);
			(*Finds the length of a list of cards*)

fun minion_mana (x1, x2, x3, x4, x5) = x1;	(*Mana of a minion*)

fun left x = x - cost;		(*This will be the leftover mana after playing one*)

fun find (a, (q,w,e,r,t)::xs) = if (xs = [] andalso a <> e) then (0, false, "", 0, 0)
		else if a = e then (q,w,e,r,t)
		else find (a, xs);
			(*This finds a minion if it is in the list and the requirements are met*)

fun spell_hero ((q,w,e,r,t), (y,u,i,l,p)) = 
	if r > 0 then (y,u,i,l,p-r)
	else (y,u,i,l,p);
		(*Casts a spell on the hero*)
	
fun spell_use ((q,w,e,r,t)::xs, (y,u,k,l,p)) = 
	if (k = e) then [(q,w,e,r,(t-l))]@xs
	else if (k <> e andalso xs <> []) then spell_use (xs, (y,u,k,l,p))
	else if ( k = e andalso xs = []) then [(q,w,e,r,t - p)]
	else [(q,w,e,r,t - l)];
		(*Finds the minion to place the spell on, then affects it
		  and rebuilds the list*)

fun crystals (x, h, (q,w,e,r,t)) =
	if (r  <= 0 andalso t <= 0) then ()
	else (
		let	
			val cost = x - q
			val list = (0,w,e,r,t)::[]
		in
			if (cost < 0) then print "Not enough Mana, try something else or endturn!"
			else (print ("Perfect Move!") ; (hand := remove((q,w,e,r,t), !hand)) ; (Minions := (!Minions)@list) ; (mana := cost))
		end);
			(*This function is called to decide what to play and if it can be played.
			  If it can then call other functions to change results*)

fun crystalsAI (x, h, (q,w,e,r,t)) =
		let	
			val cost = x - q
			val list = (0,w,e,r,t)::[]
		in
			if (cost < 0) then print "Not enough Mana, try something else or endturn!"
			else (print ("Perfect Move!") ; (AIhand := remove((q,w,e,r,t), !AIhand)) ; (Monsters := (!Monsters)@list) ; (AImana := cost))
		end;
			(*Same function but for the computer because of issues with removing things
			  from the lists*)

fun random_num (z) = 
	if z = 1 then 1 else
		let
			val x = Random.rand (1,1);
			val new = Random.randRange (0, z);
			val y = new x
		in
			y
		end;
			(*Finds a random number that fits the size of the list*)

fun find_minion (x,(q,w,e,r,t)::xs) = 
		if xs = [] then (q,w,e,r,t) else find_minion(x-1,xs);
			(*Finds a minion that is going to fit the given random number.
			  Will traverse the list till its found*)
		
fun AI_attack (x, y) =
		if (length (y) = 0 andalso length (x) = 0) then ()
		else if (length (x) > 0 andalso length (y) = 0) then ()
		else if (length (x) = 0 andalso length (y) > 0) 
		then (attack_heroAI (!Health, hd y) ; AI_attack (tl (!Minions), tl y))
		else
			let
				val t = random_num((length (x)))
				val r = find_minion(t, x)
			in
					(Minions := (attack ((hd y), r, !Minions)) ; 
					Monsters := (attack(r, (hd y), !Monsters)) ;
					Minions := (eliminate(!Minions)) ;
					AI_attack (tl (!Minions), tl y) )
			end;
				(*If the lists have minions then find a random minion to attack,
				  and attacking that minion while changeing the lists to show
				  current results*)

fun final ((q,w,e,r,t)::xs) = 
	if ((e = "Empty" andalso r = 0 andalso xs = []) orelse (e <> "Empty" andalso xs = [])) then ()
	else 
		let
			val t = length (!Minions)
			val r = random_num(t)
			val t = ((q,w,e,r,t)::xs)
		in
			if (r = 1) then attack_heroAI (!Health, hd (tl (t))) 
			else AI_attack(tl (!Minions), tl (!Monsters))
		end;
			(*A function to decide what to attack if that is the hero
			  or the minions, then calls functions based on those results*)

fun AIplay (x,(q,w,e,r,t)::xs) = 
		if ((xs = [] andalso x < q)) then []
		else if (xs = [] andalso x >= q) then (crystalsAI(!AImana, e, (q,w,e,r,t)) ; [])
		else if (xs <> [] andalso x = q) then (crystalsAI(!AImana,e, (q,w,e,r,t)) ; AIplay(x,xs))
		else AIplay (x, xs);
			(*Decides the minion to play then calls crystalsAI in order for 
			  all the effected lists to be updated*)

fun test (x) = 
	if (size (valOf x)) < 18 then print "Illegal" else
	let
		val z = String.tokens Char.isSpace (valOf x);	(*Made the input a string list*)
		val a = hd (tl (z))
		val e = play (a, !hand)
		val i = hd e
		val h = #3 (hd e) 
		val f = !Minions
		val g = find (a, !hand)
		val b = find (a, !Monsters)
		val c = hd (tl (tl (tl z)))			
		val d = find (c, !Minions)		(*Call functions to set temperary varibles*)															
	in																							
		case (hd z) of	(*Select what functions will be called based on input head*)
			"attack" => (print "Attacking..." ; Minions := (attack (b, d, !Minions)) ; 
												Monsters := (attackAI(d, b, !Monsters)) ;
												Minions := (eliminate(!Minions)) ;
												Monsters := (eliminate(!Monsters)) ; use "game.sml" ) |
			"attacking" => (print "Attacking..." ;(attack_hero(!AIHealth, d)) ; use "game.sml" ) |
			"play" => (print "Playing minion..." ; (crystals(!mana, h, i) ; use "game.sml") ) |
			"cast" => (print "Casting spell on..." ; (Monsters := spell_use(tl (!Monsters), i)) ; 
													Monsters := (eliminate(!Monsters)) ; use "game.sml" ) |
			"casting" => (print "Casting spell on AI..." ; AIHealth := spell_hero(g, !AIHealth) ; use "game.sml" ) |
			_ => (use "game.sml" ; print "Not a known command, please read instructions!!" ; () )
	end;
		(*If none of the user inputs is found then print an error command*)

val z = ref 1;
val y = ref 1;

fun edit x =  (*If they want to quit then they can or they can end turn*)
	if valOf x = "quit\n" then (OS.Process.exit OS.Process.success) 
	else if valOf x = "endturn\n" then 0
	else 1;	
	
fun coin x = if x = 10 then 10 else x + 1;
	(*Never let the mana count go above 10*)

fun set ((q,w,e,r,t)::xs) = 
		if xs = [] then [(1,w,e,r,t)] else [(1,w,e,r,t)]@set(xs);
			(*Sets all the minions on the board to have a playable count on them*)

fun empty_check (x, y) = 
	if (length y) = 1 then [] else AIplay(x,y);
		(*If the lists are empty then it won't play a minion*)

fun work (is, os) =
	while(#5(!AIHealth) > 0 andalso #5(!Health) > 0)	(*Keep going if nobody is dead*)
	do (
		while (print ("\nMana Remaining: " ^ (Int.toString (!mana)) ^ "\n") ; 
				print "\nPlease enter one of the commands( quit ) ( endturn ) ( continue ): ";
				!z <> 0)
			do  (z := edit(TextIO.inputLine is) ; (*Store input in variable*)
				while ( !z <> 0 andalso !y <> 0)	(*Keep repeating instructions*)
				do (
					(print "\nAttack a minion by typing: ( attack \"enemy_minion\" with \"ally_minion\" ) or... \n");
					(print "Attack the enemy hero by typeing: ( attacking AI with \"ally_minion\" ) or... \n");
					(print "Play a minion by typing: ( play \"ally_minion\" on board ) or... \n");
					(print "Play a spell on a minion by typing: ( cast \"spell_name\" on \"minion\" ) or... \n");
					(print "Cast a spell on a hero by typing: ( casting \"spell_name\" on AI ) or... \n");
					(print "Press Enter to return: ");
					y := 0;		(*Exit instructions to mainmenu selection*)
					test(TextIO.inputLine is)	(*Evaluate the input from user*)
					);
					y := 1	(*Return back into instructions each time continue is pressed*)
				) ;
			Minions := set(!Minions) ;		(*Make monsters playable*)
			Monsters := set(!Monsters) ;
			AI_attack (tl (!Minions), tl (!Monsters)) ;	(*Attack with the AI*)
			Monsters := (eliminate(!Monsters)) ;		(*Delete dead minions*)
			empty_check (!AImana, !AIhand) ;		(*Check if hand is empty for AI*)
			hand := new_card(!hand, hd (!deck)) ;
			AIhand := new_card(!AIhand, hd (!AIdeck)) ;	(*Draw a new card for each hand*)
			deck := delete (!deck) ;
			AIdeck := delete (!AIdeck) ;		(*Remove them from the deck*)
			use "game.sml" ;		(*Call the game state*)
			(print "\nYour turn has ended because you ran out of mana!");
			(print "\nAI has selected a command and is making their moves, be patient...\n");
			(print "\nIt is now your turn...\n") ;
			turn := coin(!turn);
			mana := !turn;		(*Update current mana to equal the turn number*)
			AImana := !turn;
			(print ("\nYour starting mana for this turn is: " ^ (Int.toString (!turn)) ^ "\n")) ; 
			z := 1		(*Exit inner loop to see if someone has died*)
		);

use "game.sml";	(*Call the game to print the game state*)

print ("This game is called Hearthstone, your goal is to destroy the opponent hero.\n ");
print ("To attack either minions or the enemy hero you need to play minions onto the board\n ");
print ("You can play minions as much as you want on the board as long as you have the mana to afford it\n ");
print ("Mana is the left most number on the card\n ");
print ("The name is the text in the middle of the card\n ");
print ("Attack is the number directly after the name\n ");
print ("Health is the number on the far right\n ");
print ("You will recieve a new card each turn until you run out of cards\n ");
print ("If each player runs out of cards and neither has one it is a tie\n ");

print(" Your mana is set to: " ^ (Int.toString (!turn)) ^ "\n");

work (TextIO.stdIn, TextIO.stdOut);	(*Calls the main game loop*)

fun AIloser (q,w,e,r,t) =
	if t > 0 then print "The AI has beaten you" 
	else print "You have won the game! good work soldier!!";
		(*Prints whether the user has one or the comptuer has one*)
		
AIloser (!AIHealth);
OS.Process.exit OS.Process.success;