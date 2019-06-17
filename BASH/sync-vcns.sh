# Resync vCloud Network and Security vShield App Service VMs
# By Greg Carriger
#
# Get the array values by connecting to vCenter with PowerCLI and running (Get-VMHost).id
# the proxy needs to be disabled for this to work. Feel free to comment out the export line if this is not an issue for you.
#
user="user-name"
pass="enter-password-here"
vcnsip="enter-vCNS-IP-here"
export HTTPS_PROXY=''
array=(10 20 30 40 50 60)
for i in ${array[@]}
do
    curl -k -u $user:$pass -X POST "https://"$vcnsip"/api/1.0/zones/host-"$i"/forceSync"
    echo "Completed sync for Host Id "$i
done
pass=""
echo "Sync complete."
