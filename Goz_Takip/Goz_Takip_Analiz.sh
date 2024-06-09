#!/bin/bash

# Metin dosyasının adı
echo "Analiz Edilecek TXT Metin Dosyası Adını Giriniz:"

#Başlangıç Zamanı
starttime=$(date +"%s")

read metin
METIN_DOSYASI=$(echo $metin | sed 's/ /_/g')
cp "$metin" "$METIN_DOSYASI"


##########Bölüm-01##########
#Türkçeye özgü harfleri ingilizce harflere çevirmek için:
harfler=$(cat <<EOF
ı;i
ğ;g
ü;u
ş;s
ö;o
ç;c
I;i
İ;i
Ç;C
Ş;S
Ü;U
Ğ;G
Ö;O
â;a
Â;A
EOF
)
while IFS=";" read turkce eng; do
    sed -i 's/'$turkce'/'$eng'/g' $METIN_DOSYASI
done <<< $harfler

#Tüm büyük harfleri küçük harflere çeviriyoruz
sed -i 's/.*/\L&/' $METIN_DOSYASI


##########Bölüm-02##########
#Alfabedeki harfler haricindeki tüm karakterleri kaldırır:
sed -i 's/[^a-z ]//g' $METIN_DOSYASI


##########Bölüm-03##########
# İkili harf analizi
starttime1=$(date +"%s")

dizi=($(echo {a..z}{a..z}))
for i in ${dizi[@]}; do 
    sayi=$(grep -o $i "${METIN_DOSYASI}" | wc -l)
    echo "$i;$sayi" >> "${METIN_DOSYASI}_ikili_harf_analizi.txt"
done

endtime1=$(date +"%s")
math=$((endtime1-starttime1))
echo "İkili harf analizi için çalıştığımız script $math saniye sürdü"

# Derece analizi ve toplam derece hesaplama
starttime2=$(date +"%s")

METIN_ikili_harf_analizi=$(sed '/;0/d' "${METIN_DOSYASI}_ikili_harf_analizi.txt")

while IFS=';' read -r harf_ikilisi kac_kere; do
    kac_derece=$(grep -w "$harf_ikilisi" sonuclar_derece.txt | cut -d ":" -f 2)
    sonuc=$(echo "scale=5;$kac_kere*$kac_derece" | bc)
    echo "$harf_ikilisi;$kac_kere;$kac_derece;$sonuc" >> "${METIN_DOSYASI}_tum_derece_sonuclar.txt"
done <<< $METIN_ikili_harf_analizi

endtime2=$(date +"%s")
math=$((endtime2-starttime2))
echo "İkili harfler için göz açılarının hesaplanması $math saniye sürdü"

toplam=$(cat "${METIN_DOSYASI}_tum_derece_sonuclar.txt" | awk -F ";" '{ topla += $4 } END { printf "%.f\n",topla }')

endtime=$(date +"%s")
math=$((endtime-starttime))
echo "Analiz için çalıştığımız script $math saniye sürdü"


echo "Göz takibinde metni yazdırmak için gereken göz açısı değişimi $toplam derecedir."
echo "Toplam;;;$toplam" >> "${METIN_DOSYASI}_tum_derece_sonuclar.txt"
