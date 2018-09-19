#!/bin/bash
# ------------------------------------------------
# Author: ninewb
# ------------------------------------------------
# - This script is setup to easily control our
# - repository.  The available actions are:
# -	> push
# -	> pull
#
# - Pass comment, hostname is fallback
#
# - Script assumes ./core/profile is sourced
# - Token needs to be defined
# ------------------------------------------------

GIT_COMMENT=$2

if [[ -z "${GIT_TOKEN}" ]]; then
	printf "${_GHEAD} TOKEN is not defined.  Please define it and we can operate properly... \n"
	exit 1
fi

function push() {
	cd ${GIT_HOME}
	if [[ -z "${GIT_COMMENT}" ]]; then
		GIT_COMMENT=`hostname`
	fi
	git add -u * >/dev/null 2>&1
	git commit -m "${GIT_COMMENT}" >/dev/null 2>&1
	git push https://${GIT_USER}:${GIT_TOKEN}@${GIT_REPO} master >/dev/null 2>&1
	printf "${_GHEAD} Git repository push was completed. \n\n"
	printf "#-----------------------------\n"
	git log --pretty="%h - %s" --shortstat --since="1 minute ago" --no-merges
	printf "#-----------------------------\n"
}

function pull() {
	cd ${GIT_HOME}
	git pull https://${GIT_USER}:${GIT_TOKEN}@${GIT_REPO} >/dev/null 2>&1
        printf "${_GHEAD} Git repository pull was completed. \n\n"
        printf "#-----------------------------\n"
        git log --pretty="%h - %s" --shortstat --since="1 minute ago" --no-merges
        printf "#-----------------------------\n"
}

# ---- Decision Tree ----
while getopts "py" opt; do
case "${opt}" in

        p)
            push
            ;;
        y)
            pull
            ;;
        *)
			printf  "\t Does not compute... \n"
            ;;
        esac
done
