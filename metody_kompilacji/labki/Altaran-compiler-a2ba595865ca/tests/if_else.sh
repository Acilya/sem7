#!/bin/bash

echo '
if 2==3
	then y=10;
else
	y=5;	
end
print(y);
' | ./../leks
