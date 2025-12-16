echo -e "\nThe one who reaches the finish line first wins"
echo -e "\nYou can roll the die by pressing the number 1 and advance "
echo -e "\nGood luck"
RACE_LENGTH=30
USER_A=0
USER_B=0
CHANCE=0
GAME_FINISHED=0
WINNER=""
OBSTACLES=(5 10 15 20 25)
FINE=(2 5 7 10 12)
function rollTheDie(){
	VALUE=$(shuf -i 1-100 -n 1)
	VALUE=$(echo "scale=2; $VALUE / 100" | bc)
	DECIMAL=$(echo " scale=2; $VALUE * 6" |bc)
	RE=$(awk '{print($1 == int($1)?int($1):int($1)+1)}' <<<"$DECIMAL")
	echo -e "|$RE|\n">&2
	echo $RE
}

function obstacleHit(){
	USER_PLACE=$(($1 + $2))
	FINED=0
	i=0
	for VAL in "${OBSTACLES[@]}";do
		i=$((i+1))
		if [ $USER_PLACE -eq $VAL ];then 
			RES=$((USER_PLACE-"${FINE[$i]}"))
			USER_PLACE=$(awk '{print($1 > 0)?$1:0}' <<< "$RES")
			echo -e "\n the value of userplace is this $USER_PLACE">&2
			echo -e "You've hit the obstacle\n">&2
			FINED=1
		break
		fi
	done
	if [ $FINED -eq 1 ];then
		echo "$USER_PLACE"
	else
		echo "$USER_PLACE"
	fi
}

function Advance(){
	POS=$1
	RACER=$2
	p=0
	echo "$RACER"
	while [ $p -lt $POS ];do 
		echo -n "= "
		p=$(($p+1))
		if [ $p -eq $POS ];then
			echo -n "🚓"
		fi
	done
	echo -e "\n"
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
					USER_A=$(obstacleHit "$USER_A" "$DIE")
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
					USER_B=$(obstacleHit "$USER_B" "$DIE")
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
      		echo -e "\n========= RACE ========="
			Advance $USER_A "A"
			Advance $USER_B "B"
			echo -e "\n"
		fi
		done
}
PlayGame