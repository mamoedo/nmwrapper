#!/bin/bash

MY_NAME="nmwrapper"
BSSID=""
CONNAME=""
PASS=""
KEYMGMT=""
BAND=""
ACTION=""

function delete {
        echo "[INFO] Deleting hotspot $BSSID connection ..."
        sudo nmcli connection down $CONNAME
        sudo nmcli connection delete $CONNAME
}

function create {
		echo "[INFO] Creating $KEYMGMT hotspot $BSSID (Pass: $PASS)(Connection name: $CONNAME) ..."
		if [[ $KEYMGMT = "wpa-psk" ]]
		then
			sudo nmcli connection add type wifi ifname wlp2s0 con-name $CONNAME ssid $BSSID
			sudo nmcli connection modify $CONNAME 802-11-wireless.mode ap 802-11-wireless.band $BAND ipv4.method shared
			sudo nmcli connection modify $CONNAME wifi-sec.key-mgmt $KEYMGMT
			sudo nmcli connection modify $CONNAME wifi-sec.psk $PASS
		elif [[ $KEYMGMT = "wep" ]]
		then
			sudo nmcli connection add type wifi ifname wlp2s0 con-name $CONNAME ssid $BSSID
			sudo nmcli connection modify $CONNAME 802-11-wireless.mode ap 802-11-wireless.band $BAND ipv4.method shared
			sudo nmcli connection modify $CONNAME wifi-sec.key-mgmt none
			sudo nmcli connection modify $CONNAME wifi-sec.wep-key0 $PASS
        elif [[ $KEYMGMT = "open" ]]
		then
			sudo nmcli connection add type wifi ifname wlp2s0 con-name $CONNAME ssid $BSSID
			sudo nmcli connection modify $CONNAME 802-11-wireless.mode ap 802-11-wireless.band $BAND ipv4.method shared
		else
			echo "[WARNING] Missing -k argument. Impossible to create hotspot. Aborting..."
			exit
		fi
}

function up {
		echo "[INFO] Activating hotspot $BSSID ..."
		sudo nmcli connection up $CONNAME
}

function down {
		echo "[INFO] Desactivating hotspot $BSSID ..."
		sudo nmcli connection down $CONNAME
}

function show_help {
	echo "Usage: $MY_NAME [ACTION] [OPTIONS]"
	echo -e "\nActions:"
	echo -e "\t-create\t(Requires all options)"
	echo -e "\t-delete\t(Requires connection name)"
	echo -e "\t-up\t(Requires connection name)"
	echo -e "\t-down\t(Requires connection name)"
	echo -e "\nOptions:"
	echo -e "\n\t-b=\tBand (a: 5GHz, bg: 2.4GHz)"
	echo -e "\t-bssid=\tBSSID"
	echo -e "\t-c=\tConnection name"
	echo -e "\t-k=\tKey management (open, wpa-psk, wep)"
	echo -e "\t-p=\tPassword\n"
}

for i in "$@"
do
case $i in
    -b=*)
    BAND="${i#*=}"
    shift
    ;;
	-bssid=*)
    BSSID="${i#*=}"
    shift
    ;;
    -k=*)
    KEYMGMT="${i#*=}"
    shift
    ;;
	-c=*)
    CONNAME="${i#*=}"
    shift
    ;;
	-p=*)
    PASS="${i#*=}"
    shift
    ;;
	-create)
    ACTION="create"
    shift
    ;;
	-delete)
    ACTION="delete"
    shift
    ;;
	-up)
    ACTION="up"
    shift
    ;;
	-down)
    ACTION="down"
    shift
    ;;
    -h | --help)
    show_help
    exit
    ;;
    *)
	echo -e "[WARNING] Action not defined\n"
	show_help
    exit
    ;;
esac
done

if [[ -z "$ACTION" ]]
then
	if [[ "$ACTION" != "create" ]] || [[ "$ACTION" != "delete" ]] || [[ "$ACTION" != "up" ]] || [[ "$ACTION" != "down" ]]
	then
		echo -e "[WARNING] Action not defined\n"
		show_help
		exit
	fi
else
	if [[ "$ACTION" = "create" ]]
	then
		if [[ -z "$CONNAME" ]] || [[ -z "$PASS" ]] || [[ -z "$BSSID" ]] || [[ -z "$KEYMGMT" ]] || [[ -z "$BAND" ]]
		then
			echo "[WARNING] Missing parameters for action create"
			exit
		else
			create
		fi
	else
		if [[ -z "$CONNAME" ]]
		then
			echo "[WARNING] Missing parameters for action $ACTION"
		elif [[ "$ACTION" = "delete" ]]
		then
			delete
		elif [[ "$ACTION" = "up" ]]
		then
			up
		elif [[ "$ACTION" = "down" ]]
		then
			down
		fi
	fi
fi
	
exit
