loop-parameters
===============

I needed a way to give any bash script I made some parameters in the following format:

# script.sh --parameter1 yes --parameter2 username --parameter3 password

The script interprets the --parameter1 and makes it a variable $parameter1 with value "yes" and variable $parameter2 with value "username" etc.


This repo includes two bash scripts:

script.sh
include.sh

The script.sh script includes the include.sh script using "source /path/to/file"
