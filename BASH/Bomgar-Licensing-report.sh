#!/bin/bash
# Author Greg Carriger
# Rep Console Usage v1
## Collect Data
wget --no-check-certificate https://portal.domain.com/api/command.ns?username=exampleuser\&password=examplepassword\&action=get_logged_in_reps
grep display_name command.ns* > user1
rm command.ns*
wget --no-check-certificate https://portal2.domain.com/api/command.ns?username=exampleuser\&password=examplepassword\&action=get_logged_in_reps
grep display_name command.ns* > user2
rm command.ns*
usert=$(cat user1 user2 | sort -u | wc -l)
user1=$(cat user1 | wc -l)
user2=$(cat user2 | wc -l)
time=$(date +%s)
## Write Data
echo $usert $user1 $user2 > tempstats
cat tempstats | sed '$s|^|'"$time"' |' >> stats
## Clean up
rm user1 user2 tempstats
