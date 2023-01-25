#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"


if [[ -z $1 ]]
then
echo "Please provide an element as an argument."
else

 if [[ $1 =~  ^[0-9]+$ ]]
   then
   ELEMENT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1")
   else
   ELEMENT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1' OR name='$1'")
 fi

 if [[ -z $ELEMENT ]]
 then
  echo "I could not find that element in the database."
 else
 echo "$ELEMENT" | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME MASS MELTING_POINT BOILING_POINT TYPE   
   do
   echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
   done
 fi
fi
