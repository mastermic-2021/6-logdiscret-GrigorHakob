g = Mod(6, 682492462409094395392022581537473179285250139967739310024802121913471471);
A = 245036439927702828116237663546936021015004354074422410966568949608523157;

\\ Baby Step Giant Step

baby_giant(A,g,n) = {
  if(A==1,return(0));
  B = sqrtint(n)+1;

  my(baby);
  baby = Map();
  gp=g;
  mapput( baby, 1, 0);
  mapput( baby, g, 1);
  for(i = 2 , B-1 , gp=gp*g; mapput(baby, gp, i));
  G = ( g^B )^(-1);
  retour=0;

  \\Puis on cherche les collisions 
  for(i=0, B+1,
  	   power = A*(G)^i;
  	   test = mapisdefined(baby, power, &retour);
 	   if( test == 1 , return( i*B + retour )));
}
\\ diviseur de n-1,
inside_lemme_chinois(g, p, e, a)={
	somme=0;
	gi = g^(p^(e-1));
	for(i=0 , e-1 ,
		ai = (a*g^(-somme))^(p^(e-i-1));
		tmp = baby_giant(ai, gi, p);
		somme = somme + tmp*(p^i));
	somme;
}
\\  Pohlig Hellman
\\ lemme chinois sur l'ordre du groupe
lemme_chinois(A,g,n,m)={
	m=factor(682492462409094395392022581537473179285250139967739310024802121913471471-1);
	k=0;
	tab=vector(4);
	mi=0;
	for(i=1, 4, \\ nombre de facteurs premiers de n
	pi=m[i,1]^m[i,2];
	mi=n/pi;
	apow=A^mi;
	gpow=g^mi;
	tab[i]=Mod(inside_lemme_chinois(gpow,m[i,1],m[i,2],lift(apow)),pi)
	);
	solution=lift(Mod(lift(chinese(tab)),n+1));
	solution;
}

n=682492462409094395392022581537473179285250139967739310024802121913471471 ;
A=Mod(A,n);
a=lemme_chinois(A,g,n-1,m);
print(a);

