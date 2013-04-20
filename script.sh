#!/bin/bash


# Required Variables
aREQUIRED=( --parameter1 --parameter2 )

# Optional Variables
aOPTIONAL=( --verbose --dryrun)

# This will show when parameter --help is given
EXPLANATION="
*** REQUIRED ***
--parameter1	- string	- 	a string, domainname, no spaces
--parameter2	- string	- 	a string, domainname, no spaces
*** OPTIONAL ***              
--verbose	- y/n		-	Show commands while executing
--dryrun	- y/n		-	Just show list of commands, do nothing
"

# Include
source include.sh

# Required call
LOOPPARAMETERS $@


# Your script


# You can echo the value of the variable $parameter1 of $parameter2 now or any other name you have given the parameter.

# This can probably be improved because it nowtakesthree lines to make the --verbose or --dryrun work:

# Echo parameter 1
command="echo ${parameter1}"
SHOWIFVERBOSE "${command}"	
DRYRUNOREXECUTE ${command}




