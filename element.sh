#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

echo -e "\nPlease provide an element as an argument"
read INPUT

if [[ $INPUT =~  ^[0-9]+$ ]]
then
ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$INPUT'")
  if [[ -z $ATOMIC_NUMBER ]]
  then
     echo -e "\nI could not find that element in the database." 
  else
  RESULT=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON types.type_id=properties.type_id WHERE elements.atomic_number='$INPUT'") 

  echo "$RESULT" | while IFS="|" read ATOMIC_NUMBER ELEMENT_NAME ELEMENT_SYMBOL ELEMENT_TYPE ELEMENT_MASS MELTING_POINT BOILING_POINT
    do
    echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done
  fi
elif [[ ! $INPUT =~  ^[0-9]+$ ]]
then
INPUT_LENGTH=$(echo $INPUT | wc -c)
 if [[ $INPUT_LENGTH -le 3 ]]
 then
   ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$INPUT'")
   if [[ -z $ELEMENT_SYMBOL ]]
   then
     echo -e "\nI could not find that element in the database."  
   else 
     echo $($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON types.type_id=properties.type_id WHERE elements.symbol='$INPUT'") | while IFS="|" read ATOMIC_NUMBER ELEMENT_NAME ELEMENT_SYMBOL ELEMENT_TYPE ELEMENT_MASS MELTING_POINT BOILING_POINT 
     do
     echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
     done
   fi
  else
  ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE name='$INPUT'")
  if [[ -z $ELEMENT_NAME ]]
  then
     echo -e "\nI could not find that element in the database." 
  else
  echo $($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties ON elements.atomic_number=properties.atomic_number FULL JOIN types ON types.type_id=properties.type_id WHERE elements.name='$INPUT'") | while IFS="|" read ATOMIC_NUMBER ELEMENT_NAME ELEMENT_SYMBOL ELEMENT_TYPE ELEMENT_MASS MELTING_POINT BOILING_POINT 
  do
  echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
  fi   
 fi
fi
