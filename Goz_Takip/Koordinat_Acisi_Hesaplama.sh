#!/bin/bash

#Scriptin başladığı zamanı not alıyoruz
starttime=$(date +"%s")

#Koordinatların yazıldığı dosyayı okuyoruz ve harflere karşılık gelen satırlardaki koordinatları diziye atıyoruz
koordinatlar=($(tail -n 26 harf_koordinat.txt))

#İhtiyacımız olan bazı sabit değerler:
#Pi değeri:
pi=$(echo "4*a(1)" | bc -l)
#Radyandan dereceye çevirmek için sabit değer:
radyan_to_derece=$(echo "scale=10; 180/$pi" | bc -l)

##Her bir koordinatı ve boyutlarını (x, y, z) ayrıştırmak için AWK kullanıyoruz. Bu for döngüsüyle, tüm harfleri ve koordinatlarını değişkenlere atamış olacağız. Örneğin a harfi için x, y ve z koordinatları sırasıyla: ${x[0]}  ${y[0]}  ${z[0]} şeklinde değişken içerisine almış oluyoruz. Ayrıca harf ismini de ${harf_ismi[0]} şeklinde tanımlamış olacağız:
x=()
y=()
z=()
harf_ismi=()
for koordinat in "${koordinatlar[@]}"
do
harf_ismi+=($(echo $koordinat | awk -F ";" '{print $1}'))
               x+=($(echo $koordinat | awk -F ";" '{print $2}'))
               y+=($(echo $koordinat | awk -F ";" '{print $3}'))
               z+=($(echo $koordinat | awk -F ";" '{print $4}'))
done

#Sonuçları yazdıracağımız dosyayı oluşturuyoruz, var ise içini temizliyoruz:
> sonuclar_derece.txt

#Her noktanın diğer noktalarla olan açısını hesaplamak için iki döngü iç içe kullanıyoruz. 26 harf var, Döngü 0 ile başlayacak. Bundan dolayı 25 adet döngü kullanmalıyız. 
#Her bir harfi temsil eden vektörü A ve B olarak tanımlıyoruz, ve bunların x, y ve z koordinatları ile hesaplama yapıyoruz:
for A in {0..25}
do
    for B in {0..25}
    do
#Aynı noktalar arasındaki açı sıfırdır, bundan dolayı birbirinden farklı noktaların açısını hesaplayacağız:
    if [[ $A -ne $B ]]
    then
#Vektörlerin skaler çarpımı
        skaler_carpim=$(echo "(${x[$A]}*${x[$B]})+(${y[$A]}*${y[$B]})+(${z[$A]}*${z[$B]})" | bc)
#Vektörlerin uzunlukları:
        uzunluk_A=$(echo "scale=10;sqrt((${x[$A]})^2+(${y[$A]})^2+(${z[$A]})^2)" | bc)
        uzunluk_B=$(echo "scale=10;sqrt((${x[$B]})^2+(${y[$B]})^2+(${z[$B]})^2)" | bc)
#Vektör uzunlukları çarpımı:
        uzunluk_carpimi=$(echo "scale=10;$uzunluk_A*$uzunluk_B" | bc)
#Teta açısı radyan cinsinden:
        cos_teta_radyan=$(echo "scale=10;$skaler_carpim/$uzunluk_carpimi" | bc)
#Tetanın Arkkosinüsünü buluyoruz
        teta_radyan=$(perl -e "use POSIX;printf '%.10f', acos($cos_teta_radyan)")
#Teta radyan açısını dereceye çeviriyoruz:
        teta_derece=$(echo "scale=10;$teta_radyan*$radyan_to_derece" | bc)
#Bulduğumuz sonucu sonuclar_derece.txt dosyasına yazdırıyoruz:      
        echo "${harf_ismi[$A]}${harf_ismi[$B]}:$teta_derece" >> sonuclar_derece.txt
#Eğer aynı noktalar olursa, doğrudan 0 olarak derecesini yazdırıyoruz:
    else
        echo "${harf_ismi[$A]}${harf_ismi[$B]}:0" >> sonuclar_derece.txt
    fi
    done
done

endtime=$(date +"%s")

math=$((endtime-starttime))
echo “Script  $math saniye sürdü”

