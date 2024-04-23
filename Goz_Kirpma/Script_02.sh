#!/bin/bash

#Alfabedeki harfler haricindeki tüm karakterleri kaldırır:
sed -iE 's/[^a-z ]//g' nutuk.txt