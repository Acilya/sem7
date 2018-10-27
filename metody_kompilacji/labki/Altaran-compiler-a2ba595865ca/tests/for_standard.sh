#!/bin/bash

echo '
y=0;
for i=0 i+=1 i<5 then
	y=y+2;	
	printi(i);
	prints("   ");
	printi(y);
	prints("\n");
end
' | ./../leks
