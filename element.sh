#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  # check if par is number or char
  case $1 in
    ''|*[!0-9]*) FIND_ELEMENT=$($PSQL "select atomic_number, symbol, name from elements where symbol='$1' OR name='$1'") ;;
    *) FIND_ELEMENT=$($PSQL "select atomic_number, symbol, name from elements where atomic_number=$1") ;;
esac

  

if [[ -z $FIND_ELEMENT ]]
then
  echo "I could not find that element in the database."
else
  echo $FIND_ELEMENT | while IFS=" | " read ATOMIC_NUMBER ELEMENT_SYMBOL ELEMENT_NAME
  do
    FIND_PROPERTIES=$($PSQL "select type, atomic_mass, melting_point_celsius, boiling_point_celsius from properties inner join types on properties.type_id=types.type_id where atomic_number=$ATOMIC_NUMBER");

    echo $FIND_PROPERTIES | while IFS=" | " read TYPE ATOMIC_MASS MELTING_POINT BOILING_POINT
    do
      OUTPUT="The element with atomic number $ATOMIC_NUMBER is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $ELEMENT_NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."

      echo "$OUTPUT"
    done
  done
fi

fi

