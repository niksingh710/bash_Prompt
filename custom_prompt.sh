# Custom Bash Prompt for Bash Shell (Just Sourcing PS1 as zsh is not good for my work flow).
# Created by niksingh710 (https://t.me/niksingh710)

# Variables
aNormal="\e[0m"
aBold="\e[1m"
cMagenta="\e[35m"
cLGreen="\e[92m"
cLGrey="\e[37m"
cDGrey="\e[90m"
cYellow="\e[33m"
cLYellow="\e[93m"
cLRed="\e[91m"
cLCyan="\e[96m"

cGREETING="$cLGrey $aBold$cLGreen$(whoami)$aNormal$cLYellow$cDGrey $(date +"%A %B %Y %Z")$aNormal\n"
echo -e "$cGREETING"
alias clear='clear && echo -e "$cGREETING"'

# Functions

getStatus() {
	echo "\`
        if [[ \$? = 0 ]];then
            echo \[$cLCyan\]🚀;
        else echo \[$cLRed\]💥;
    fi
    \`"
}

getIcon() {
	echo "\`
        if [[ \$(pwd) = "$HOME" ]];then
            echo ;
        elif [[ \$(pwd) = "/" ]];then
         echo ;
        else echo ;
    fi
    \`"
}

# online Git Copy
function parse_git_branch() {
	BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${BRANCH}" == "" ]; then
		STAT=$(parse_git_dirty)
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty() {
	status=$(git status 2>&1 | tee)
	dirty=$(
		echo -n "${status}" 2>/dev/null | grep "modified:" &>/dev/null
		echo "$?"
	)
	untracked=$(
		echo -n "${status}" 2>/dev/null | grep "Untracked files" &>/dev/null
		echo "$?"
	)
	ahead=$(
		echo -n "${status}" 2>/dev/null | grep "Your branch is ahead of" &>/dev/null
		echo "$?"
	)
	newfile=$(
		echo -n "${status}" 2>/dev/null | grep "new file:" &>/dev/null
		echo "$?"
	)
	renamed=$(
		echo -n "${status}" 2>/dev/null | grep "renamed:" &>/dev/null
		echo "$?"
	)
	deleted=$(
		echo -n "${status}" 2>/dev/null | grep "deleted:" &>/dev/null
		echo "$?"
	)
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

export PS1="$(getStatus) $(getIcon) $aNormal$cLCyan$aBold\W$aNormal $aBold$cLYellow\`parse_git_branch\`$cLCyan$aNormal \@\n>"
