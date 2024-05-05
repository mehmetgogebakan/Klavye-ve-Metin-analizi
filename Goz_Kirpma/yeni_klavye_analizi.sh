#!/bin/bash

#Klasördeki harf istatistiği olan dosyaları liste olarak al
dosya_listesi=$(ls | grep "_istatistik.txt")

# Dosya listesini döngüye sok
for dosya in $dosya_listesi; do
    echo "Dosya: $dosya"
    kitap=$(echo $dosya | sed 's/_harf_istatistik.txt//')
#Her bir istatistik dosyasını döngüye sok
    while IFS=";" read -r harf kac_harf_var
    do
        kac_goz_kirpma=$(grep -w "$harf" yeni_harf_goz_kirpma.txt | cut -d ";" -f 2)
        carpim=$(echo "$kac_harf_var * $kac_goz_kirpma" | bc)
        echo "$harf;$carpim" >> "${kitap}-toplam_goz_kirpma.txt"
    done < "$dosya"
    
    toplam=$(awk -F ';' '{topla += $2} END {print topla}' "${kitap}-toplam_goz_kirpma.txt")
    echo "Toplam Göz Kırpma:$toplam"
    echo "Toplam;$toplam" >> "${kitap}-toplam_goz_kirpma.txt"
done
