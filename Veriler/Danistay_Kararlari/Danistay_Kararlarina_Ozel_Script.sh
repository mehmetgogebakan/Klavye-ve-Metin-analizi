#!/bin/bash

#Danıştay Kararlarında bulunan İlk 18 satırı siliyoruz, genel olarak ilk 18 satır karar numara ve daireleri ile ilgili sabit metinlerdir: 
sed -i '1,18d' *.txt

#Sadece büyük harften oluşan kelimeleri silmek için, örneğin "D A N I Ş T A Y" gibi;
sed -i 's/\b[[:upper:]]*\b//g' *.txt
#Büyük harfle başlayan satırlarda : karakterine kadar olan kısımları siliyoruz (örneğin "İSTEMİN ÖZETİ : XXXX" gibi)
sed -i 's/^[[:upper:]].*://g' *.txt
#Tüm karar dosyalarını birleştirelim:
cat *.txt >> 100Bin_Karar.txt
