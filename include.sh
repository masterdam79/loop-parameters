#!/bin/bash

ECHORED()	{
	echo "`tput setaf 1`${1}`tput setaf 7`"
}

ECHOYELLOW()	{
	echo "`tput setaf 3`${1}`tput setaf 7`"
}

ECHOGREEN()	{
	echo "`tput setaf 2`${1}`tput setaf 7`"
}

ASKFORIT() {
	local __VARIABLE=$1
	local __REQUEST=$2
	local __PROMPTED=""
	
	echo -n "Input your ${__REQUEST}: "
	# Put input in array
	read __PROMPTED[${__VARIABLE}]
	# Check if prompt was left empty
	if [ -e ${__PROMPTED[${__VARIABLE}]} ]
	then
		echo "RETRY: no ${__REQUEST} entered"
		exit
	else
		eval ${__VARIABLE}="'${__PROMPTED[${__VARIABLE}]}'"
	fi
}

SHOWIFVERBOSE() {
	if [ ${verbose} ]
	then
		if [ ${verbose} = "y" ]
		then
			#echo -e "\e[00;32m`hostname -s`:`pwd`# ${1}\e[00m"
			#echo "`tput setaf 3``hostname -s`:`pwd`# ${1}`tput setaf 7`"
			ECHOGREEN "`hostname -s`:`pwd`# ${1}"
		fi	
	fi	
}

DRYRUNOREXECUTE() {
	# If dryrun is set
	if [ ${dryrun} ]
	then
		# If dryrun = n
		if [ ${dryrun} = "n" ]
		then
			eval $*
		else
			ECHOYELLOW "`hostname -s`:`pwd`# $*"
		fi
	else
		eval $*
	fi
}

LOGOREXECUTE() {
	if [ ${log} ]
	then
		if [ ${log} = "y" ]
		then
			eval $* >> ~/${timestamp}.log
			ECHOYELLOW "cat ~/${timestamp}.log"
		fi
	else
		eval $*
	fi
}

LOOPPARAMETERS() {
	REQUIREDELEMENTS=${#aREQUIRED[@]}
	# Loop the required elements
	for (( i=0;i<$REQUIREDELEMENTS;i++)); do
		# COUNT is the amount of arguments given after the command
		if [ ${i} -eq 0 ]; then
			COUNT=$#
		fi
		
		# Loop the given parameters
		for (( j=1;j<=${COUNT};j++)); do
			# Check if current parameter = "--help"
			if [ "${ARRAY[0]}" = "--help" ] ; then
				ECHOGREEN "Required parameters: ${aREQUIRED[*]}"
				ECHOGREEN "Optional parameters: ${aOPTIONAL[*]}"
				ECHOGREEN "Explanation: ${EXPLANATION}"
				exit
			fi
			
			# Check if current requirement matches current parameter
			if [ ${ARRAY[0]} = ${aREQUIRED[${i}]} ] ; then
				# This will be useed later to fetch required parameters which have not been fillend in.
				REQUIREMENTMET[${i}]="TRUE"
				
				# Put parameters in variables
				PARAMETER=`echo ${ARRAY[0]} | cut -c3-`
				IDENTIFIER=`echo ${ARRAY[0]} | cut -c1-2`
				if [ "${IDENTIFIER}" = "--" ]; then
					# Make a variable with the (stripped) name of the parameter and assign value of parameter to the new variable
					eval ${PARAMETER}=\${ARRAY[1]}
				fi
			else
				# Put parameters in variables
				PARAMETER=`echo ${ARRAY[0]} | cut -c3-`
				IDENTIFIER=`echo ${ARRAY[0]} | cut -c1-2`
				if [ "${IDENTIFIER}" = "--" ]; then
					# Make a variable with the (stripped) name of the parameter and assign value of parameter to the new variable
					eval ${PARAMETER}=\${ARRAY[1]}
				fi			
			fi
			
			# Shuffle array (tried shift, but this didn't work with multiple loops)
			arr_push ${ARRAY[0]}
			arr_unshift
			
		done
		
		# Ask for missing operator
		if [ -e ${REQUIREMENTMET[${i}]} ];
		then
			PARAMETER=`echo ${aREQUIRED[${i}]} | cut -c3-`
			ASKFORIT ${PARAMETER} ${aREQUIRED[${i}]}
		fi
	done
}

ARRAY=($@)

# These small functions are from rootninja: http://rootninja.com/how-to-push-pop-shift-and-unshift-arrays-in-bash/

arr_push() {
	PLACEHOLDER=${ARRAY[@]}
	ARRAY=("${ARRAY[@]}" "$1")
}

arr_unshift() {
	PLACEHOLDER=${ARRAY[@]}
	unset ARRAY[0]
	ARRAY=("${ARRAY[@]}")
}

# Variables
now=`date +"%Y-%m-%d%t%H:%M:%S"`
timestamp=`date +"%Y%m%d%H%M%S"`
today=`date +"%Y-%m-%d"`
todayReadable=`date +"%d-%m-%Y"`
yesterday=`date -d "-1 day" +"%Y-%m-%d"`
tomorrow=`date -d "+1 day" +"%Y-%m-%d"`
fourdaysago=`date -d "-4 day" +"%Y-%m-%d"`
sevendaysago=`date -d "-7 day" +"%Y-%m-%d"`
twentyonedaysago=`date -d "-21 day" +"%Y-%m-%d"`

