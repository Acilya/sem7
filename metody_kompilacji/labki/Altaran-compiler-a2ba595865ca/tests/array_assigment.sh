#!/bin/bash

echo '
int arr[20];
arr[0]=1;
arr[1]=1;
for i=2 i+=1 i<10 then
	arr[i]=arr[i-1]+arr[i-2];
end
for i=0 i+=1 i<10 then
	x=arr[i];
	printi(x);
	prints(" ");
end
' | ./../leks
