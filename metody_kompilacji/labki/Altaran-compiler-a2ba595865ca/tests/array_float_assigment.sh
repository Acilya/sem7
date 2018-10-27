#!/bin/bash

echo '
float arr[10];
arr[0]=1.5;
arr[1]=2.5;

for i=2 i+=1 i<10 then
	arr[i]=arr[i-1]+arr[i-2];
end
for i=0 i+=1 i<10 then
	x=arr[i];
	printf(x);
	prints(" ");
end
' | ./../leks
