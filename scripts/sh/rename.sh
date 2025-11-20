#!/usr/bin/env bash
for i in data/editions/*.xml ;do
	filenam=`echo $i |cut -d / -f 3`
	A=`echo ${filenam:0:4}`
	B=`echo ${filenam:4}`
	mv ${i} data/editions/v__${A}_${B}
done
