#!/bin/bash
csv="baza.csv"
bigReg="^[a-zA-Z]{2,},([1-9]|10),(([A-Za-z0-9]+((\.|\-|\_|\+)?[A-Za-z0-9]?)*[A-Za-z0-9]+)|[A-Za-z0-9]+)@(([A-Za-z0-9]+)+((\.|\-|\_)?([A-Za-z0-9]+)+)*)+\.([A-Za-z]{2,})+$"


sortare(){
  clear
  awk -F',' '{ if (NR>1) print $3 "\t" $2}' $csv | sort -n -r | head -n 3
}

stergere(){
  clear
  read -p "Introdu id-ul studentului de sters: " id
  if [[ ! $(sed -n -e "/^$id/p" $csv) ]]
  then
    echo "id-ul nu a fost gasit"
  else
    sed -i "/^$id/d" $csv
  fi
  return
}

editare(){
  clear
  read -p "Introduceti id-ul studentului a carui date urmeaza sa fie actualizate: " existingId
  if [[ $(sed -n -e "/^$existingId/p" $csv) ]]
  then
    repl=$(sed -n -e "/^$existingId/p" $csv) #te am gasit hehe
    echo $repl
    read -p "Introdu campurile noi lipite urmate de ',' (fara id): " str
  while [[ ! $str =~ $bigReg ]]
  do
    echo "ai introdus campurile gresit"
    read -p "Introdu campurile noi lipite urmate de ',' (fara id)" str
  done
  final=$existingId','$str
  # echo $final
  sed -i -e "s/$repl/$final/" $csv
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
        read -p "Introdu campurile noi lipite urmate de ',' (fara id): " str
        while [[ ! $str =~ $bigReg ]]
        do
          echo "ai introdus campurile gresit"
          read -p "Introdu campurile noi lipite urmate de ',' (fara id)" str
        done
        final=$existingId','$str
        sed -i "$existingId a $final" $csv
      else
        exit
      fi
    else
      echo "... si nici nu se poate adauga"
    fi
  fi
  return  
}

adaugare(){
  clear
  while IFS="," read -r id nume nota mail #IFS = internal field separator
    do
    #   echo -e "$id $nume $nota $mail"
      if [[ $id =~ ^[0-9]+$ ]]
      then
        newId=$((id+1))
      else
        newId=1
      fi
  done < <(tail -n -1 $csv)
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
  done < <(tail -n +1 $csv) 
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
'afisare' - afisare csv,\n
'adaugare' - adaugare student,\n
'editare' - editare/inserare ;) studenti urmat de id,\n
'stergere' - stergere studenti urmat de id,\n
'sortare' - sortare studenti descrescator in functie de nota (afisare primii 3),\n
'*orice altceva*' - pt a inchide scriptul"
read -p "Introduceti operatia dorita: " inp

while true
do
  case "$inp" in
  afisare) afisare;;
  adaugare) adaugare;;
  editare) editare;;
  stergere) stergere;;
  sortare) sortare;;
  *) exit 1;;
  esac
  echo -e "Operatii disponibile: \n
  'afisare' - afisare csv,\n
  'adaugare' - adaugare student,\n
  'editare' - editare/inserare ;) studenti urmat de id,\n
  'stergere' - stergere studenti urmat de id,\n
  'sortare' - sortare studenti descrescator in functie de nota (afisare primii 3),\n
  '*orice altceva*' - pt a inchide scriptul"
  read -p "Introduceti operatia dorita: " inp
done