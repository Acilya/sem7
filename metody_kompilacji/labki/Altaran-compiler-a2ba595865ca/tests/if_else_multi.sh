#!/bin/bash

echo '
x=2;
y=3;
if x==y then
	y=10;
	if 2==2 then
		y=11;
	end
else
	if 3==3 then
		if 4==4 then
			y=50;
		end
		z=60;
	end
end
print(y);
sprint("HelloWorld!\n");
print(z);
sprint("Hello2!\n");
' | ./../leks
