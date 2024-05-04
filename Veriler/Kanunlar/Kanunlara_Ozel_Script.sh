#!/bin/bash

#Tüm kararları tek dosyada topluyoruz:
cat *.txt >> Kanun_500_adet.txt

#Tüm büyük harfleri küçük harflere çeviriyoruz
sed -i 's/.*/\L&/' Kanun_500_adet.txt

#Sıkça tekrar eden standart sözcüklerin geçtiği tüm kelimeleri kaldırıyoruz, örneğin “hükmü”, “hükmünü”, “hükmüne”, “hükmünde” gibi:
kelimeler=$(cat <<EOF
amaç
bağlı
bölüm
çeşitli
değişik
fıkra
gazete
genel
geçerli
geçici
hakkında
hükmü
hüküm
ilgili
ilişkin
kabul
kanun
kapsam
karar
khk
kurum
madde
md.
mülga
resmi
resmî
sayılı
son
tanım
tarih
vergi
yayım
yürürlü
yürütme
EOF
)

while IFS=, read kelime; do
    sed -i 's/'$kelime'\w*//g' Kanun_500_adet.txt
done <<< $kelimeler
