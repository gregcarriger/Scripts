# This is an example to batch update config files. You will need a trusted jumpbox with shared ssh keys. 
# Run the get-esxips.ps1 to grab all the ESX IPs and transfer the IPs to the linux server.

################################
# Separate ESX hosts by monitor version and clean IP list
################################
# move esxips.txt from Windows server to linux jumpbox
# This depends on the PowerCLI script to get all ESX host IPs

# Check for monitor version
for i in $( cat esxips ); do
    ssh $i 'hostname | tail -n+3 /etc/monitor.conf | head -n1' >> cloud-monitor-check.log
done

################################
# Remove ssh login banners and warnings
grep -i '10.\|v3.' cloud-monitor-check.log | grep -v 'Warning' > cloud-monitor-check2.log
# separate IPs and versions
grep 'v3.12.0' cloud-monitor-check2.log -B 1 > 3.12.0
grep 'v3.13.0' cloud-monitor-check2.log -B 1 > 3.13.0
grep 'v3.14.0' cloud-monitor-check2.log -B 1 > 3.14.0
grep 'v3.15.0' cloud-monitor-check2.log -B 1 > 3.15.0
grep 'v3.9.0' cloud-monitor-check2.log -B 1 > 3.9.0
# condense to IPs
cat 3.9.0 | sort | uniq > 3.9.0-clean
cat 3.12.0 | sort | uniq > 3.12.0-clean
cat 3.13.0 | sort | uniq > 3.13.0-clean
cat 3.14.0 | sort | uniq > 3.14.0-clean
cat 3.15.0 | sort | uniq > 3.15.0-clean
# Use vi to remove any lines from the cleaned text files that are not IPs. They will be at the top and bottom of the files.
Prepare Files for Update
cp ~/3.*-clean /var/tmp/
chmod 777 /var/tmp/3.*-clean
cp ~/eventlist.cfg.3.9 /var/tmp/eventlist.cfg.3.9
cp ~/eventlist.cfg.3.12 /var/tmp/eventlist.cfg.3.12
cp ~/eventlist.cfg.3.13 /var/tmp/eventlist.cfg.3.13
cp ~/eventlist.cfg.3.14 /var/tmp/eventlist.cfg.3.14
cp ~/eventlist.cfg.3.15 /var/tmp/eventlist.cfg.3.15
chmod 777 /var/tmp/eventlist.cfg.3.*
 
################################
# Batch Update monitor config
################################
# Backup, Copy, Enable New Config on remote hosts with monitor
# By Greg Carriger with assistance from the talented Will Trudo and the venerable Max Neumann
#
# Copy this script into monitor-update.sh
#
# Example is for 3.9. Replace 1st two variables accordingly.
# Set IPs and config
config=/var/tmp/eventlist.cfg.3.9
ips=~/3.9.0-clean
# Clear log
echo "" > cloud-monitor-change.log
# Copy and replace config, restart monitor
for i in $( cat $ips ); do
    scp $config $i:$config >> cloud-monitor-change.log
    ssh $i -qt 'sudo rm -f /usr/local/monitor/eventlist.cfg' >> cloud-monitor-change.log
    ssh $i -qt 'sudo cp '"$config"' /usr/local/monitor/eventlist.cfg' >> cloud-monitor-change.log
    ssh $i -qt 'sudo /etc/init.d/monitor config_restart' >> cloud-monitor-change.log
    echo "completed $i" >> cloud-monitor-change.log
    date +%s >> cloud-monitor-change.log
done
Save output and attach to VMAC

################################
# Save output file
cp  cloud-monitor-change.log cloud-monitor-change.3.9.log
# Use winscp to copy to a windows machine. Copy file to VMAC.
 
################################
# Changes for other monitor versions
################################
# Set IPs and config
config=/var/tmp/eventlist.cfg.3.12
ips=~/3.12.0-clean
# Set IPs and config
config=/var/tmp/eventlist.cfg.3.13
ips=~/3.13.0-clean
# Set IPs and config
config=/var/tmp/eventlist.cfg.3.14
ips=~/3.14.0-clean
# Set IPs and config
config=/var/tmp/eventlist.cfg.3.15
ips=~/3.15.0-clean
