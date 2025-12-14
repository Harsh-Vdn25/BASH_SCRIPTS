echo -e "\nThe one who reaches the finish line first wins"
echo -e "\nYou can roll the die by pressing the number 1 and advance "
echo -e "\nGood luck"
RACE_LENGTH=30
USER_A=0
USER_B=0
CHANCE=0
GAME_FINISHED=0
WINNER=""
function rollTheDie(){
	VALUE=$(shuf -i 1-100 -n 1)
	VALUE=$(echo "scale=2; $VALUE / 100" | bc)
	DECIMAL=$(echo " scale=2; $VALUE * 6" |bc)
	RESULT=$(awk '{print($1 == int($1)?int($1):int($1)+1)}' <<<"$DECIMAL")
	echo $RESULT
}
function PlayGame(){
	while [ $GAME_FINISHED -eq 0 ]; do 
		if [ $CHANCE -eq 0 ]; then
			echo -e "User 1 should roll the die\n"
			read -p "please roll the die:" USER_INPUT
			if [ $USER_INPUT -eq 1 ];then
				DIE=$(rollTheDie)
				echo -e "=== User1 die value $DIE ===\n"
				if [ $(($DIE + $USER_A)) -gt $RACE_LENGTH ];then
					echo -e "\nYou cant advance ,you need exact $(($RACE_LENGTH - $USER_A)) to advance"
				else
					USER_A=$((USER_A + DIE))
				fi
				CHANCE=1
			else
				echo -e "\nYou can't advance so try again "
			fi
		else
			echo -e "User 2 should roll the die\n" 
			read -p "please roll the die:" USER_INPUT
			if [ $USER_INPUT -eq 1 ];then
				DIE=$(rollTheDie)
				echo -e "=== User2 die value $DIE ===\n"
				if [ $(($DIE + $USER_B)) -gt $RACE_LENGTH ];then
					echo -e "\nYou cant advance ,you need exact $(($RACE_LENGTH - $USER_B)) to advance"
				else
					USER_B=$((USER_B + DIE))
				fi
				CHANCE=0
			else
				echo "You can't advance so try again "
			fi
		fi
		if [[ $USER_A -eq 30 || $USER_B -eq 30 ]]; then
			GAME_FINISHED=1
			if [ $USER_A -gt $USER_B ];then
				WINNER="USER_A"
			else
				WINNER="USER_B"
			fi
			echo -e "\n🎉 $WINNER won the game 🎉"
		else
      		echo -e "\n========= SCORES ========="
      		echo -e "   USER A: $USER_A | USER B: $USER_B"
      		echo -e "==========================\n"
		fi
		done
}
PlayGame

