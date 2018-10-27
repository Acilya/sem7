#!/bin/bash

echo '
if 2==2 then
	if 3==3 then
		if 4==4 then y=7;
		end
	end
	if 3==4 then
		y=4; end
end
print(y);
' | ./../leks
