#!/bin/bash

echo ==========
echo Starting...
echo ==========
script_dir=$(dirname "$0")
echo script dir: ${script_dir}
cd ${script_dir}
echo running in... $PWD

while : ; do
	fronter=$(curl https://api.lmhd.me/v1/fronter.json | jq -r .members[0].name)

	if [[ ${fronter} == "null" ]]; then
		fronter=system
	fi

	echo ${fronter} > fronter

	sleep 60
done
