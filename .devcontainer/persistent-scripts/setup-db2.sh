#!/bin/bash

# Add DB2 bin to PATH and set DB2INSTANCE
echo "export PATH=$PATH:/opt/ibm/db2/V11.5/adm" >>  ~/.bashrc
echo "export PATH=$PATH:/database/config/db2inst1/sqllib/bin/" >>  ~/.bashrc
echo "export DB2INSTANCE=db2inst1" >>  ~/.bashrc
source ~/.bashrc

# Keep the container running
tail -f /dev/null