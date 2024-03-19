#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess -t -c"
echo -e "\n~~~~~ Welcome to number guessing game ~~~~~\n"

GAME_START(){
# Get username from user
  echo "Enter your username:"
  read USERNAME

# Get user_id
  USER_INFO=$($PSQL "select * from users where username='$USERNAME'")

# If doesn't have user_id
  if [[ -z $USER_INFO ]]
    then
  # Insert new user info
    INSERT_RESULT=$($PSQL "insert into users(username,games_played,best_game) values('$USERNAME',0,0)")
    if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
    fi
  else
  # Display user info
    echo "$USER_INFO" | while read USER_ID BAR USERNAME BAR GAMES_PLAYED BAR BEST_GAMES
    do
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAMES guesses."
    done
  fi
}

GAME_START

# Generate random number form 1-1000
echo $(($RANDOM%1000+1))

