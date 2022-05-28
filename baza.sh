#!/bin/bash
csv="./baza.csv"

sortare(){
  clear
  # note=()
  # note+=$(awk -F',' '{ if (NR>1) print $3}' $csv)
  # nume=()
  # nume+=$(awk -F',' '{ if (NR>1) print $2}' $csv)
  # for i in $note
  # do
  #   echo $i
  # done
  # for j in $nume
  # do
  #   echo $j
  # done
  awk -F',' '{ if (NR>1) print $3 "\t" $2}' $csv | sort -n -r | head -n 3
  
  return
}

stergere(){
  clear
  read -p "Introdu id-ul studentului de sters: " id
  if [[ ! $(sed -n "/^$id/p" $csv) ]]
  then
    echo "id-ul nu a fost gasit"
  else
    sed -i "/^$id\b/d" $csv
    echo "student sters"
  fi
  return
}

editareNume(){
  read -p "noul nume: " replace
  while [[ ! "$replace" =~ ^[a-zA-Z]{2,}$ ]]
  do
    echo "nume invalid (cel putin 2 caractere si fara numere)"
    read -p "Reintroduceti nume: " nume
  done
  id=$1
  awk -F',' -v id="$id" -v nume="$replace" 'BEGIN { OFS = FS } $1 == id { $2 = nume }1' $csv > tmpfile && mv tmpfile "$csv"
}

editareNota(){
  read -p "noua nota: " replace
  while [[ ! $replace =~ ^([1-9]|10)$ ]]
  do
    echo "nota invalida"
    read -p "Reintroduceti nota: " replace
  done
  id=$1
  awk -F',' -v id="$id" -v nota="$replace" 'BEGIN { OFS = FS } $1 == id { $3 = nota }1' $csv > tmpfile && mv tmpfile "$csv"
  # sed -i -E "s/^$id\,.\,([1-9]|10)\,.$/$replace/" $csv
  return
}

editareMail(){
  read -p "noul mail: " replace
  while [[ ! "$replace" =~ ^(([A-Za-z0-9]+((\.|\-|\_|\+)?[A-Za-z0-9]?)*[A-Za-z0-9]+)|[A-Za-z0-9]+)@(([A-Za-z0-9]+)+((\.|\-|\_)?([A-Za-z0-9]+)+)*)+\.([A-Za-z]{2,})+$ ]]
  do
    echo "adresa de email invalida"
    read -p "Reintroduceti email-ul: " mail
  done
  id=$1
  awk -F',' -v id="$id" -v email="$replace" 'BEGIN { OFS = FS } $1 == id { $4 = email }1' $csv > tmpfile && mv tmpfile "$csv"
}

editareTot() {
  clear
  id=$1
  toBeReplaced=$2
  read -p "Introduceti numele: " nume
  while [[ ! "$nume" =~ ^[a-zA-Z]{2,}$ ]]
  do
    echo "nume invalid (cel putin 2 caractere si fara numere)"
    read -p "Reintroduceti nume: " nume
  done
  read -p "Introduceti nota SO: " nota
  while [[ ! $nota =~ ^([1-9]|10)$ ]]
  do
    echo "nota invalida"
    read -p "Reintroduceti nota: " nota
  done
  read -p "Introduceti email-ul: " mail
  while [[ ! "$mail" =~ ^(([A-Za-z0-9]+((\.|\-|\_|\+)?[A-Za-z0-9]?)*[A-Za-z0-9]+)|[A-Za-z0-9]+)@(([A-Za-z0-9]+)+((\.|\-|\_)?([A-Za-z0-9]+)+)*)+\.([A-Za-z]{2,})+$ ]]
  do
    echo "adresa de email invalida"
    read -p "Reintroduceti email-ul: " mail
  done
  str="$nume,$nota,$mail"
  final=$id','$str
  echo $final
  sed -i -e "s/$toBeReplaced/$final/" $csv
}

nrCif(){
  nr=$1
  k=0
  while [[ ! $nr -eq 0 ]]
  do
    nr=$(($nr/10))
    ((k++))
  done
  return $k
}

editare(){
  clear
  read -p "Introduceti id-ul studentului a carui date urmeaza sa fie actualizate: " existingId
  while [[ ! $existingId =~ ^[0-9]+$ ]]
  do
    echo "id invalid"
    read -p "Reintroduceti id-ul: " existingId
  done
  if [[ $(sed -n "/^$existingId\b/p" $csv) ]]
  then
    repl=$(sed -n "/^$existingId\b/p" $csv) #te am gasit hehe
    echo $repl
    echo -e "Introdu operatia de actualizare:\n
    '1' - editare nume,\n
    '2' - editare nota,\n
    '3' - editare mail,\n
    '4' - editarea tuturor campurilor,\n
    (*orice altceva) - inapoi in meniul principal"
    read -p "Introduceti operatia dorita: " str
    case "$str" in
    1) editareNume $existingId;;
    2) editareNota $existingId;;
    3) editareMail $existingId;;
    4) editareTot $existingId $repl;;
    *) return;;
    esac
    
  else
    echo "id-ul nu exista"
    id=$(awk -F',' 'END { print $1 }' $csv)
    # echo $id
    # echo $existingId
    if [[ $existingId -lt $id ]]
    then
      echo "...dar se poate adauga :)"
      read -p "1 - 'da', 2 - 'nu': " inp
      if [[ inp -eq "1" ]]
      then
        read -p "Introduceti numele: " nume
        while [[ ! "$nume" =~ ^[a-zA-Z]{2,}$ ]]
        do
          echo "nume invalid (cel putin 2 caractere si fara numere)"
          read -p "Reintroduceti nume: " nume
        done
        read -p "Introduceti nota SO: " nota
        while [[ ! $nota =~ ^([1-9]|10)$ ]]
        do
          echo "nota invalida"
          read -p "Reintroduceti nota: " nota
        done
        read -p "Introduceti email-ul: " mail
        while [[ ! "$mail" =~ ^(([A-Za-z0-9]+((\.|\-|\_|\+)?[A-Za-z0-9]?)*[A-Za-z0-9]+)|[A-Za-z0-9]+)@(([A-Za-z0-9]+)+((\.|\-|\_)?([A-Za-z0-9]+)+)*)+\.([A-Za-z]{2,})+$ ]]
        do
          echo "adresa de email invalida"
          read -p "Reintroduceti email-ul: " mail
        done
        str="$nume,$nota,$mail"
        final=$existingId','$str
        searchId=$(awk -v sid="$existingId" -F',' '{if(NR>1 && sid < $1) print NR}' $csv)
        nrCif $existingId
        p=$?
        ((p++))
        # echo $p
        poz=${searchId::$p}
        ((poz--))
        # echo $poz 
        sed -i "$poz a $final" $csv
      else
        return
      fi
    else
      echo "... si nici nu se poate adauga"
    fi
  fi
  return  
}

adaugare(){
  clear
  id=$(awk -F',' 'END { print $1 }' $csv)
  if [[ $id =~ ^[0-9]+$ ]]
  then
    newId=$((id+1))
  else
    newId=1
  fi
  read -p "Introduceti numele: " nume
  while [[ ! "$nume" =~ ^[a-zA-Z]{2,}$ ]]
  do
    echo "nume invalid (cel putin 2 caractere si fara numere)"
    read -p "Reintroduceti nume: " nume
  done
  read -p "Introduceti nota SO: " nota
  while [[ ! $nota =~ ^([1-9]|10)$ ]]
  do
    echo "nota invalida"
    read -p "Reintroduceti nota: " nota
  done
  read -p "Introduceti email-ul: " mail
  while [[ ! "$mail" =~ ^(([A-Za-z0-9]+((\.|\-|\_|\+)?[A-Za-z0-9]?)*[A-Za-z0-9]+)|[A-Za-z0-9]+)@(([A-Za-z0-9]+)+((\.|\-|\_)?([A-Za-z0-9]+)+)*)+\.([A-Za-z]{2,})+$ ]]
  do
    echo "adresa de email invalida"
    read -p "Reintroduceti email-ul: " mail
  done
  echo "$newId,$nume,$nota,$mail" >> $csv
}

afisare(){
  clear
  while IFS="," read -r id nume nota mail #IFS = internal field separator
    do
      echo -e "$id $nume $nota $mail"
  done < $csv 
}

init() {
  echo -e "Pseudo-baza de date :)\n"
  echo -e "----------------------\n"
  if [[ ! -f $csv ]]
  then
    echo "fisierul nu exista, dar va fi creat" # 1 creare fisier CSV
    # touch $csv
    echo "ID,nume,nota SO,email" > $csv
  fi
  return
}

init

echo -e "Operatii disponibile: \n
'1' - afisare csv,\n
'2' - adaugare student,\n
'3' - editare/inserare studenti,\n
'4' - stergere studenti,\n
'5' - sortare studenti descrescator in functie de nota (afisare primii 3),\n
'*orice altceva*' - pt a inchide scriptul"
read -p "Introduceti operatia dorita: " inp

while true
do
  case $inp in
  1) afisare;;
  2) adaugare;;
  3) editare;;
  4) stergere;;
  5) sortare;;
  *) exit 1;;
  esac
  echo -e "Operatii disponibile: \n
  '1' - afisare csv,\n
  '2' - adaugare student,\n
  '3' - editare/inserare studenti,\n
  '4' - stergere studenti,\n
  '5' - sortare studenti descrescator in functie de nota (afisare primii 3),\n
  '*orice altceva*' - pt a inchide scriptul"
  read -p "Introduceti operatia dorita: " inp
done