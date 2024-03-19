#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"
echo -e "\n~~~~~ Welcome to number guessing game ~~~~~\n"

GAME_START(){
# Get username from user
  echo "Enter your username:"
  read USERNAME

# Get user_info
  GET_USER_INFO

# If doesn't have user_id
  if [[ -z $USER_ID ]]
    then
  # Insert new user info
    INSERT_RESULT=$($PSQL "insert into users(username,games_played,best_game) values('$USERNAME',0,999)")

    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  
    else
  # Display user info
    echo -e "\nWelcome back, $USERNAME! You have played $( echo $GAMES_PLAYED | sed -E 's/^ *| *$//g') games, and your best game took $( echo $BEST_GAME | sed -E 's/^ *| *$//g') guesses."

  fi
  # Games played counter
  NEW_GAMES_PLAY=$((GAMES_PLAYED+1));
}

GUESSING(){

  # Generate random number form 1-1000
  RANDOM_NUM=$(($RANDOM%1000+1))
  
  # Get user guess
  echo "Guess the secret number between 1 and 1000:"
  read USER_GUESS

  # Guesses counter
  declare -i GUESS_COUNT=0
  ((GUESS_COUNT++))
  INPUT_INT_CHECKER

  # If correct
  while [[ $USER_GUESS != $RANDOM_NUM ]]
  do
    # If guess is higher than the random number
    if [[ $USER_GUESS < $RANDOM_NUM ]]
      then    
      echo "It's higher than that, guess again:"
      read USER_GUESS
      INPUT_INT_CHECKER

      # Guesses counter increment
      ((GUESS_COUNT++))
    
      else
      echo "It's lower than that, guess again:"
      read USER_GUESS
      INPUT_INT_CHECKER

      # Guesses counter increment
      ((GUESS_COUNT++))
    
    fi
  done


  echo "You guessed it in $GUESS_COUNT tries. The secret number was $RANDOM_NUM. Nice job!"
  GET_USER_INFO
  if [[ $GUESS_COUNT < $BEST_GAME ]]
    then
      BEST_GAME=$(($GUESS_COUNT))
  fi
  UPDATE_RECORD_RESULT=$($PSQL "update users set games_played = $NEW_GAMES_PLAY, best_game = $BEST_GAME where username = '$USERNAME'")
}

INPUT_INT_CHECKER(){
  while [[ ! $USER_GUESS =~ ^[0-9]+$ ]]
    do
      echo That is not an integer, guess again:
      read USER_GUESS
      ((GUESS_COUNT++))
    done
}

GET_USER_INFO(){
  USER_ID=$($PSQL "select user_id from users where username='$USERNAME'")
  GAMES_PLAYED=$($PSQL "select games_played from users where username='$USERNAME'")
  BEST_GAME=$($PSQL "select best_game from users where username='$USERNAME'")
}


GAME_START
GUESSING

