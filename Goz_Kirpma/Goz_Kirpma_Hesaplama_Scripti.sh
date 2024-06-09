#!/bin/bash

# Metin dosyasının adı
echo "Analiz Edilecek TXT Metin Dosyası Adını Giriniz:"

read metin
# Dosya ismindeki boşlukları _ ile değiştiriyoruz ve analiz için yeni bir kopyasını oluşturuyoruz:
METIN_DOSYASI=$(echo $metin | sed 's/ /_/g')
cp "$metin" "$METIN_DOSYASI"

#Başlangıç Zamanı
starttime=$(date +"%s")

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
#İlgili metindeki harf istatistiğini çıkarıyoruz:

for harf in {a..z}
do
sayi=$(tr -cd "$harf" < $METIN_DOSYASI | wc -c)
echo "$harf;$sayi" >> $METIN_DOSYASI-harf_istatistik.txt
done

#Her bir harf için kaç defa göz kırpılması gerektiğini hesaplıyoruz ve toplam_goz_kirpma dosyasına yazıyoruz:
while IFS=";" read -r harf kac_harf_var
do
 kac_goz_kirpma=$(grep -w "$harf" harf_goz_kirpma.txt | cut -d ";" -f 2)
 carpim=$(echo "$kac_harf_var * $kac_goz_kirpma" | bc)
 echo "$harf;$carpim" >> $METIN_DOSYASI-toplam_goz_kirpma.txt
done < $METIN_DOSYASI-harf_istatistik.txt

#Tüm metin için toplam göz kırpma sayısı:
topla=$(awk -F ';' '{topla += $2} END {print topla}' "$METIN_DOSYASI-toplam_goz_kirpma.txt")
echo "$METIN_DOSYASI için Toplam Göz Kırpma Sayısı: $topla"
echo "Toplam;$topla" >> "$METIN_DOSYASI-toplam_goz_kirpma.txt"

endtime=$(date +"%s")
math=$((endtime-starttime))
echo "Analiz için çalıştırdığımız script $math saniye sürdü"
