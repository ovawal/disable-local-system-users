#!/bin/bash

# This script disables, deletes, and/or archieves users on the local system. 
# Display the usage and exit


ARCHIVE_DIR='/archive'

usage() {
	# Display usage and exit
	echo -e "Usage: $(basename ${0}) [-drav] USER [USERNAME]..." >&2
	echo 'Disable a local linux account.' >&2
	echo '-d	Deletes user account.' >&2
	echo '-r	Removes the home directory.' >&2
	echo '-a	Archieves the home directory.' >&2
	echo '-v	Verbose mode.' >&2
	exit 1

}	

out() {
	local MESSAGE="${@}"
	if [[ "${VERBOSITY}" -eq 'true' ]];
	then
		echo -e "\n${MESSAGE}"
	fi
}

# Execute scritp with sudo or as root
if [[ ${UID} -ne 0 ]];
then
	echo 'Please run script with sudo or as root.'
	exit 1
fi
# Options of the script
while getopts drav OPTION
do
	case ${OPTION} in
		d) DELETE_USER='true' ;;
		r) REMOVE_OPTION='-r' ;;
		a) ARCHIVE='true'  ;;
		v) VERBOSITY='true' ;;
		?) usage ;;
	esac
done
# Remove the options, leaving the remaining arguments.
shift "$(( OPTIND -1 ))"

# If the user doesn't supply atleast one argument, give them help.
if [[ "${#}" -lt 1 ]]; 
then
	usage
fi

# Loop through all the usernames supplied as arguments.
for USERNAME in "${@}"
do
	echo "Processing user: ${USERNAME}"

	# Make sure the UID of the account is atleast 1000 and user exists.
	USERID=$(id -u ${USERNAME})
	if [[ "${USERID}" -lt 1000 ]];
	then
		echo "Refusing to remove the ${USERNAME} account with UID ${USERID}." >&2
		exit 1
	fi

	# Create an archive if reequired to do so.
	if [[ "${ARCHIVE}" = 'true' ]];
	then
		if [[ ! -d "${ARCHIVE_DIR}" ]];
		then
			echo "Creating ${ARCHIEVE_DIR} directory."
			mkdir -p "${ARCHIVE_DIR}"
			if [[ "${?}" -ne -0 ]];
			then
				echo "The archieve directory ${ARCHIVE_DIR} could not be created." >&2
				exit 1
			else
				echo "Archieve directory ${ARCHIVE_DIR} created."
			fi
		fi


		#Archieve the user's home directory and move it into the ARCHIVE_DIR
		HOME_DIR="/home/${USERNAME}"
		ARCHIVE_FILE="${ARCHIVE_DIR}/${USERNAME}.tgz"
		if [[ -d "${HOME_DIR}" ]];
		then
			echo "Archiving ${HOME_DIR} to ${ARCHIVE_FILE}"
			tar -zcf ${ARCHIVE_FILE} ${HOME_DIR}&> /dev/null
			if [[ "${?}" -ne 0 ]];
			then
				echo "Could not create ${ARCHIVE_FILE}." >&2
				exit 1
			fi
		else
			echo "${HOME_DIR} does not exist or is not a directory." >&2
			exit 1
		fi
	fi

	if [[ "${DELETE_USER}" = 'true' ]]; 
	then
		# Delete the user
		userdel ${REMOVE_OPTION} ${USERNAME}

		 # Check to exit status of the userdel command.
		if  [[ "${?}" -ne 0 ]];
		then
			echo "The account ${USERNAME} was NOT deleted. " >&2
			exit 1
		else
			echo "The account ${USERNAME} was deleted."
		fi
	else
		chage -E 0 ${USERNAME}
		if  [[ "${?}" -ne 0 ]];
		then
			echo "The account ${USERNAME} was NOT disabled." >&2
			exit 1
		else
			echo "The account ${USERNAME} was disabled." >&2
		fi
	fi
done

exit 0
