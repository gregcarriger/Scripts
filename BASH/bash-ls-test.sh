# Testing ls in BASH
# By Greg Carriger
#
# This test was created during a migration where the customer experienced poor storage performance. 
# It tests the local hard drive and in this case the NFS share at /apache
# This test proved that BASH outperformed PHP by a huge margin, and exposed that the PHP code needed to be updated.
#
# Make the /apache dir script
cd /tmp
echo '#!/bin/bash' > nfs-ls.sh
echo 'COUNTER=0' >> nfs-ls.sh
echo 'while [ $COUNTER -lt 10000 ]; do' >> nfs-ls.sh
echo 'ls -pf /apache > /dev/null' >> nfs-ls.sh
echo 'let COUNTER=COUNTER+1' >> nfs-ls.sh
echo 'done' >> nfs-ls.sh
# 
# Make the local storage /etc directory script
echo '#!/bin/bash' > root-ls.sh
echo 'COUNTER=0' >> root-ls.sh
echo 'while [ $COUNTER -lt 10000 ]; do' >> root-ls.sh
echo 'ls -pf /etc > /dev/null' >> root-ls.sh
echo 'let COUNTER=COUNTER+1' >> root-ls.sh
echo 'done' >> root-ls.sh
# 
# fix permissions
chmod 750 nfs-ls.sh
chmod 750 root-ls.sh
# 
# Run test
time /tmp/nfs-ls.sh
time /tmp/root-ls.sh
