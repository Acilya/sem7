#!/bin/bash

echo '
y=0;
for i=0 i<5 i+=1 then
	for j=0 j<5 j+=1 then
		y=y+2;	
	end
end
print(y);
' | ./../leks
