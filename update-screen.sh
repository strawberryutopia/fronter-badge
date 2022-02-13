#!/bin/bash

echo ==========
echo Starting...
echo ==========
script_dir=$(dirname "$0")
echo script dir: ${script_dir}
cd ${script_dir}
echo running in... $PWD

TTY=1
FB=0

current=system

showImage() {
	# http://manpages.ubuntu.com/manpages/bionic/man1/fbi.1.html
	sudo fbi --noverbose -a -d /dev/fb${FB} -T ${TTY} images/${1}.*
}

while : ; do
	if ping -q -w 1 -c 1 api.lmhd.me > /dev/null ; then
		echo We have internet
		break
	else
		echo No internet
		sleep 15
	fi
done



showImage ${current}
sleep 2

while : ; do
	if ping -q -w 1 -c 1 api.lmhd.me > /dev/null ; then
		echo We still have internet
	else
		echo No internet
		showImage no-internet
		sleep 15
		continue
	fi

	new=$(curl -s https://api.lmhd.me/v1/fronter.json | jq -r .members[0].name)

	if [[ ${fronter} == "null" ]]; then
		new=system
		continue
	fi

	if [[ "${new}" != "${current}" ]]; then
		echo "New Fronter: ${new}"
		if [[ ${current} != "system" ]]; then
		showImage system
			sleep 2
		fi
		showImage ${new}

		current=${new}
	fi

	sleep 15
done
