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

showFronter() {
	# http://manpages.ubuntu.com/manpages/bionic/man1/fbi.1.html
	sudo fbi --noverbose -a -d /dev/fb${FB} -T ${TTY} images/${1}.png
}

showFronter ${current}
sleep 2

while : ; do
	new=$(curl https://api.lmhd.me/v1/fronter.json | jq -r .members[0].name)

	if [[ ${fronter} == "null" ]]; then
		new=system
	fi

	if [[ "${new}" != "${current}" ]]; then
		echo "New Fronter: ${new}"
		if [[ ${current} != "system" ]]; then
		showFronter system
			sleep 2
		fi
		showFronter ${new}

		current=${new}
	fi

	sleep 1
done
