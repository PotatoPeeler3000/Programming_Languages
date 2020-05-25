fun everything ((z,y,x,w,q)::xs) =	(*Prints everything in the list*)
	 if (xs = []) then 
		let
			val a = (Int.toString z)
			val b = (Bool.toString y)
			val c = x
			val d = (Int.toString w)
			val e = (Int.toString q)
		in
			print ("Minion: " ^ c ^ " == " ^ a ^ " " ^ b ^ " " ^ c ^ " " ^ d ^ " " ^ e ^ "                                                                               ")
		end

	 else if ((w <> 0) andalso (q <> 0)) then
		let
			val a = (Int.toString z)
			val b = (Bool.toString y)
			val c = x
			val d = (Int.toString w)
			val e = (Int.toString q)
		in
			print ("Minion: " ^ c ^ " == " ^ a ^ " " ^ b ^ " " ^ c ^ " " ^ d ^ " " ^ e ^ "\n");
			everything (xs)		(*Repeats till all the minions on board are shown*)
		end
	else everything (xs);

fun everything1 ((z,y,x,w,q)::xs) = (*Does the same thing but for the AI minions*)
	 if (xs = []) then 	
		let
			val a = (Int.toString z)
			val b = (Bool.toString y)
			val c = x
			val d = (Int.toString w)
			val e = (Int.toString q)
		in
			print ("AIMinion: " ^ c ^ " == " ^ a ^ " " ^ b ^ " " ^ c ^ " " ^ d ^ " " ^ e ^ "                                                                             ")
		end
	 else if ((w <> 0) orelse (q <> 0)) then
		let
			val a = (Int.toString z)
			val b = (Bool.toString y)
			val c = x
			val d = (Int.toString w)
			val e = (Int.toString q)
		in
			print ("AIMinion: " ^ c ^ " == " ^ a ^ " " ^ b ^ " " ^ c ^ " " ^ d ^ " " ^ e ^ "\n");
			everything1 (xs)		(*Repeats till nothing is left to print*)
		end
	else everything1 (xs);

fun alive (q,w,e,r,t) = t;

fun fine ((q,w,e,r,t)::xs) = 
		if (e = "Empty"andalso xs = []) then	(*If list is empty print am empty minion*)
			print ("AIMinion: Empty == 0 false Empty 0 0\n")
			else everything1(!Monsters);
				(*Repeat till everything is printed*)

print "\n\n\n             Your current hand is:     ";
everything (!hand);
print "             The AI hand is:     ";
everything1 (!AIhand);
print "\n             Your Minions:       ";
everything (!Minions);
print "\n             Monsters:         ";
fine (!Monsters);

val good = alive(!Health);		(*Show the current health for both heros*)
val bad = alive (!AIHealth);
print ("\n             Your Health: " ^ (Int.toString good) ^ "                                              ");
print ("\n             AI Health: " ^ (Int.toString bad) ^ "                                                 ");