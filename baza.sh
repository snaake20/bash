#!/bin/bash
csv="baza.txt"

# sortare(){

# }

stergere(){
  clear
  read -p "Introdu id-ul studentului de sters: " id
  sed -i "/^$id/d" $csv
  return
}

editare(){
  clear
  read -p "Introduceti id-ul studentului a carui date urmeaza sa fie actualizate: " existingId
  repl=$(sed -n -e "/^$existingId/p" $csv) #te am gasit hehe
  echo $repl
  read -p "Introdu campurile noi lipite urmate de ',' (fara id): " str
  while [[ ! $str =~ ^[a-zA-Z]{2,},([1-9]|10),(([A-Za-z0-9]+((\.|\-|\_|\+)?[A-Za-z0-9]?)*[A-Za-z0-9]+)|[A-Za-z0-9]+)@(([A-Za-z0-9]+)+((\.|\-|\_)?([A-Za-z0-9]+)+)*)+\.([A-Za-z]{2,})+$ ]]
  do
    echo "ai introdus campurile gresit"
    read -p "Introdu campurile noi lipite urmate de ',' (fara id)" str
  done
  final=$existingId','$str
  # echo $final
  sed -i -e "s/$repl/$final/" $csv
  return  
}

adaugare(){
  clear
  while IFS="," read -r id nume nota mail #IFS = internal field separator
    do
    #   echo -e "$id $nume $nota $mail"
      newId=$((id+1))
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

sleepy() {
	sleep 1
    # perc=$1*25
    if [[ $1 -eq 4 ]]
    then
      echo "Loading: 99%"
    else
	  echo "Loading: $(($1*25))%"
    fi
	return
}

loading(){
  for ((i=0; i<5; i++))
  do
    sleepy $i #& #comparat cu varianta fara & # sync vs async
  done
  sleep 1
  echo "Loading: DONE!!!"
  sleep 2
  clear
  return
}

init(){
  echo -e "Pseudo-baza de date :)\n"
  echo -e "----------------------\n"
  if [[ ! -f $csv ]]
  then
    echo "fisierul nu exista, dar va fi creat" # 1 creeare fisier CSV
    touch $csv
    echo "ID,nume,nota SO,email" > $csv
    loading
  else
    loading
  fi
  return
}

init

echo -e "Operatii disponibile: \n
'afisare' - afisare csv,\n
'adaugare' - adaugare student,\n
'editare' - editare studenti urmat de id,\n
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
  *) exit 1;;
  esac
  echo -e "Operatii disponibile: \n
  'afisare' - afisare csv,\n
  'adaugare' - adaugare student,\n
  'editare' - editare studenti urmat de id,\n
  'stergere' - stergere studenti urmat de id,\n
  'sortare' - sortare studenti descrescator in functie de nota (afisare primii 3),\n
  '*orice altceva*' - pt a inchide scriptul"
  read -p "Introduceti operatia dorita: " inp
done




