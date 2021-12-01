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
	sudo fbi --noverbose -a -d /dev/fb${FB} -T ${TTY} ${1}.jpg
}
showFronter ${current}
sleep 1

while : ; do

	# TODO: curl API to get current fronter
	# For now, use file...
	new=$(cat fronter)
	if [[ "${new}" != "${current}" ]]; then
		echo "New Fronter: ${new}"
		showFronter ${new}

		current=${new}
	fi

	sleep 1
done
