#!/bin/bash

#İlgili metindeki harf istatistiğini çıkarıyoruz:
metin="Analiz edilecek dosya"
for harf in {a..z}
do
sayi=$(tr -cd "$harf" < $metin | wc -c)
echo "$harf;$sayi" >> $metin-harf_istatistik.txt
done

#Her bir harf için kaç defa göz kırpılması gerektiğini hesaplıyoruz ve toplam_goz_kirpma dosyasına yazıyoruz:
while IFS=";" read -r harf kac_harf_var
do
 kac_goz_kirpma=$(grep -w "$harf" harf_goz_kirpma.txt | cut -d ";" -f 2)
 carpim=$(echo "$kac_harf_var * $kac_goz_kirpma" | bc)
 echo "$harf;$carpim" >> $metin-toplam_goz_kirpma.txt
done < $metin-harf_istatistik.txt

#Tüm metin için toplam göz kırpma sayısı:
awk -F ';' '{topla += $2} END {print "Toplam Göz Kırpma Sayısı: " topla}' $metin-toplam_goz_kirpma.txt