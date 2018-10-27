#!/bin/bash

echo '
if 2==2 then y=5; end
if 2==3 then y=4; end
print(y);
' | ./../leks
