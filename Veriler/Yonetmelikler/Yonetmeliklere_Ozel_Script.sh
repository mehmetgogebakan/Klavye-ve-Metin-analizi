#!/bin/bash

#Tüm Yönetmelikleri tek dosyaya topluyoruz:
cat *.txt >> Yonetmelik_1000_adet.txt

#Tüm büyük harfleri küçük harflere çeviriyoruz
sed -i 's/.*/\L&/' Yonetmelik_1000_adet.txt

#Sıkça tekrar eden standart sözcüklerin geçtiği tüm kelimeleri kaldırıyoruz, örneğin “hakkında”, “yönetmelik” gibi:
kelimeler=$(cat <<EOF
hakkında
yönetme
birinci
ikinci
üçüncü
dördüncü
beşinci
bölüm
madde
amaç
kapsam
kısaltma
yürürlü
yürütme
sayılı
ilişkin
değişik
çeşitli
fıkra
genel
gazete
geçici
hükmü
hüküm
ilgili
mülga
resmi
resmî
md.
tanım
tarih
vergi
yayım
EOF
)

while IFS=, read kelime; do
    sed -i 's/'$kelime'\w*//g' Yonetmelik_1000_adet.txt
done <<< $kelimeler

