#!/bin/bash
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
Ç;c
Ş;s
Ü;u
Ğ;g
Ö;o
EOF
)
while IFS=";" read turkce eng; do
    sed -i 's/'$turkce'/'$eng'/g' metin.txt
done <<< $harfler

#Tüm büyük harfleri küçük harflere çeviriyoruz
sed -i 's/.*/\L&/' metin.txt
