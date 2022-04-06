module SSDriver (input [0:3] a, input enable, output [0:6] b);
	
			//~a~b~cd + ~ab~c~d + a~bcd + ab~cd
	assign b[0] = ~enable | 
			((~a[0] & ~a[1] & ~a[2] & a[3]) | 
			(~a[0] & a[1] & ~a[2] & ~a[3]) |
			(a[0] & ~a[1] & a[2] & a[3]) |
			(a[0] & a[1] & ~a[2] & a[3]));
			
			//~ab~cd + bc~d + ab~c~d + abc + acd
	assign b[1] = ~enable | 
			(((~a[0] & a[1] & ~a[2] & a[3]) | 
			(a[1] & a[2] & ~a[3]) |
			(a[0] & a[1] & ~a[2] & ~a[3]) |
			(a[0] & a[1] & a[2]) |
			(a[0] & a[2] & a[3])));

			//~a~bc~d + ab~c~d + abc
	assign b[2] = ~enable | 
			(((~a[0] & ~a[1] & a[2] & ~a[3]) |
			(a[0] & a[1] & ~a[2] & ~a[3]) |
			(a[0] & a[1] & a[2])));

		//~a~b~cd + ~ab~c~d + a~bc~d + bcd
	assign b[3] = ~enable | 
			(((~a[0] & ~a[1] & ~a[2] & a[3]) |
			(~a[0] & a[1] & ~a[2] & ~a[3]) |
			(a[0] & ~a[1] & a[2] & ~a[3]) |
			(a[1] & a[2] & a[3])));

		//~ad + ~ab~c + ~b~cd
	assign b[4] = ~enable | 
			(((~a[0] & a[3]) |
			(~a[0] & a[1] & ~a[2]) |
			(~a[1] & ~a[2] & a[3])));

		//~a~bd + ~a~bc + ~acd + ab~cd
	assign b[5] = ~enable | 
			(((~a[0] & ~a[1] & a[3]) |
			(~a[0] & ~a[1] & a[2]) |
			(~a[0] & a[2] & a[3]) |
			(a[0] & a[1] & ~a[2] & a[3])));

		//~a~b~c + ~abcd + ab~c~d
	assign b[6] = ~enable | 
			(((~a[0] & ~a[1] & ~a[2]) |
			(~a[0] & a[1] & a[2] & a[3]) |
			(a[0] & a[1] & ~a[2] & ~a[3])));
	
endmodule

/**
truth table
a b c d | 0 1 2 3 4 5 6 ~ 0 1 2 3 4 5 6
--------|---------------|--------------
0 0 0 0 | 1 1 1 1 1 1 0 | 0 0 0 0 0 0 1
0 0 0 1 | 0 1 1 0 0 0 0 | 1 0 0 1 1 1 1
0 0 1 0 | 1 1 0 1 1 0 1 | 0 0 1 0 0 1 0
0 0 1 1 | 1 1 1 1 0 0 1 | 0 0 0 0 1 1 0
0 1 0 0 | 0 1 1 0 0 1 1 | 1 0 0 1 1 0 0
0 1 0 1 | 1 0 1 1 0 1 1 | 0 1 0 0 1 0 0
0 1 1 0 | 1 0 1 1 1 1 1 | 0 1 0 0 0 0 0
0 1 1 1 | 1 1 1 0 0 0 0 | 0 0 0 1 1 1 1
1 0 0 0 | 1 1 1 1 1 1 1 | 0 0 0 0 0 0 0
1 0 0 1 | 1 1 1 1 0 1 1 | 0 0 0 0 1 0 0
1 0 1 0 | 1 1 1 0 1 1 1 | 0 0 0 1 0 0 0
1 0 1 1 | 0 0 1 1 1 1 1 | 1 1 0 0 0 0 0
1 1 0 0 | 1 0 0 1 1 1 0 | 0 1 1 0 0 0 1
1 1 0 1 | 0 1 1 1 1 0 1 | 1 0 0 0 0 1 0
1 1 1 0 | 1 0 0 1 1 1 1 | 0 1 1 0 0 0 0
1 1 1 1 | 1 0 0 0 1 1 1 | 0 1 1 1 0 0 0
*/

/**
algebraic reductions

f0 = ~a~b~cd + ~ab~c~d + a~bcd + ab~cd

f1 = ~ab~cd + ~abc~d + a~bcd + ab~c~d + abc~d + abcd  
	= '' + abcd + abc~d
	= ~ab~cd + bc~d(~a + a) + ab~c~d + abc(~d + d) + acd(~b + b)
	= ~ab~cd + bc~d + ab~c~d + abc + acd

f2 = ~a~bc~d + ab~c~d + abc~d + abcd
	= ~a~bc~d + ab~c~d + abc(~d + d)
	= ~a~bc~d + ab~c~d + abc

f3 = ~a~b~cd + ~ab~c~d + ~abcd + a~bc~d + abcd
	= ~a~b~cd + ~ab~c~d + a~bc~d + bcd(~a + a)
	= ~a~b~cd + ~ab~c~d + a~bc~d + bcd

f4 = ~a~b~cd + ~a~bcd + ~ab~c~d + ~ab~cd + ~abcd + a~b~cd
	= '' + ~ab~cd + ~a~b~cd
	= ~ad(~b~c + ~bc + b~c + bc) + ~ab~c(~d + d) + ~b~cd(~a + a)
	= ~ad((~b + b)(~c + c)) + ~ab~c + ~b~cd
	= ~ad ~ab~c + ~b~cd

f5 = ~a~b~cd + ~a~bc~d + ~a~bcd + ~abcd + ab~cd
	= '' ~a~bcd + ~a~bcd
	= ~a~bd(c + ~c) + ~a~bc(~d + d) + ~acd(~b + b) + ab~cd
	= ~a~bd + ~a~bc + ~acd + ab~cd

f6 = ~a~b~c~d + ~a~b~cd + ~abcd + ab~c~d
	= ~a~b~c(~d + d) + ~abcd + ab~c~d
	= ~a~b~c + ~abcd + ab~c~d


*/