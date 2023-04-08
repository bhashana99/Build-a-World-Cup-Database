#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "truncate games,teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do
  if [[ $YEAR != "year"  ]]
  then
    #get team id
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")

    #if not found
      if [[ -z $WINNER_ID ]]
      then
      INSERT_WINNER=$($PSQL "insert into teams(name) values ('$WINNER')")
        if [[ $INSERT_WINNER == "INSERT 0 1" ]]
        then
          echo Inserted into team WIN, $WINNER
       
        fi
      fi

      #get team id
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")

    #if not found
      if [[ -z $OPPONENT_ID ]]
      then
        INSERT_OPPONENT=$($PSQL "insert into teams(name) values ('$OPPONENT')")
       if [[ $INSERT_OPPONENT == "INSERT 0 1" ]]
        then
          echo Inserted into team OPPO, $OPPONENT  
        fi
      fi

      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
      OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
      
      INSERT_GAMES=$($PSQL "insert into games( winner_id, opponent_id, year, round, winner_goals, opponent_goals) values( $WINNER_ID, $OPPONENT_ID, $YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS)")
        

   

  fi
done
