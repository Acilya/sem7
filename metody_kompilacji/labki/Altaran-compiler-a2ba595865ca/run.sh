#!/bin/bash
echo '
if 2==2 then 
	y=5;
else 
	if y==3 then
		y=2+3;	
		end
	if y==4 then
		y=2+2;
		end
end
print(y);
' | ./leks

exit
echo '
if i<5 then
	y=6;
else
	y=7;
end
	' | ./leks
