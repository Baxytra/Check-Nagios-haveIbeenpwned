#!/bin/bash

API_URL=""
EMAIL_LIST=""
CRIT_COUNT=0

function check_jq {
	jq_cmd=`which jq`
	if [ ! -e ${jq_cmd} ];then
		echo "jq not installed, please run apt install jq"
		exit 95
	fi
}

function check_git {
	git_cmd=`which git`
	if [ ! -e ${git_cmd} ];then
		echo "git not instaleld, please run apt install git"
		exit 95
	fi
}

function log {
	logger -t "check_have-I-been-pwned.sh" "pid=$$ Msg=$*"
}

function get_remote_list {
	rm -rf /tmp/haveibeenpwned/
	git clone $GIT_MAILLIST /tmp/haveibeenpwned/
	EMAIL_LIST="/tmp/haveibeenpwned/email.list"
}

while getopts iu:e:g: flag; do
case $flag in
    u)
        API_URL=$OPTARG
        ;;
    e)
        EMAIL_LIST=$OPTARG
        ;;
    g)
	GIT_MAILLIST=$OPTARG
	;;
  esac
done

if [ "x${API_URL}" == "x" ] || [ "x${EMAIL_LIST}" == "x" ] && [ "x${GIT_MAILLIST}" == "x"  ];then
	echo "Missing input parameter"
	echo "Usage: $0 -u <api url> -e <path to email list> -g <git repo containing email.list>"
	exit 96
fi

check_jq

if [ ! -z $GIT_MAILLIST ];then
	check_git
	get_remote_list
fi

while read email
do
	email_breach_info=$(curl --silent -H 'Accept: application/json' "${API_URL}/unifiedsearch/${email}" | jq '.Breaches' | tee /tmp/email_breach.json)
	email_breach_nb=$(jq length /tmp/email_breach.json)
	
	if [ ! -z $email_breach_nb ];then
		echo "Email account ${email} has been pwned ${email_breach_nb} times"
		CRIT_COUNT=$CRIT_COUNT+1
	fi

	log "${email} analysed"

done < $EMAIL_LIST

if [ $CRIT_COUNT > 0 ];then
	log "EXIT_CODE=2"
	exit 2
else
	log "EXIT_CODE=0"
	exit 0
fi



