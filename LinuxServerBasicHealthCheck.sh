#!/bin/bash
#####
# Date: 29/10/2018
# Version: 1.02a ;), so still developing
# Function: Produce a Redhat Linux Server Check Report report
# - Execute using the root uid
# - Can be run from a collector using ssh-keys to authenticate
# -- or can be executed using the Linux crond scheduler service.
# - 97% of code will run on any Linux distribution.
#####

date
uname -n
cat /etc/redhat-release

#### Memory, CPU and Processes
echo -e "\n\n#### Memory, CPU and Processes\n"
uptime; echo
free -m; echo
top -b -n 1 | head -n 20; echo
pstree; echo
# Check - Process consuming most memory
ps -eo pmem,pcpu,pid,ppid,user,stat,args | sort -k 1 -r | head -6|sed 's/$/\n/'
# Check - Process consuming most Virtual Memory
ps -eo 'vsz pid ruser cpu time args' | sort -nr | head -25; echo
# Check - Process consuming most CPU resources
ps -eo pcpu,pmem,pid,ppid,user,stat,args | sort -k 1 -r | head -6|sed 's/$/\n/'
# Check - Zombie process
ps -eo stat,pid,user,cmd|grep -w Z|awk '{print $2}'; echo
# Display CPU Stats using mpstat
mpstat 1 10; echo
# Display CPU Stats using vmstat
vmstat 1 10; echo
# Display 2ndry Storage IO Stats using io stats
iostat -c 1 10; echo

#### Disks and File Systems Checks
echo -e "\n\n#### File Systems Checks\n"
df -h; echo
mount; echo
# Check - FS RO mounted
mount|egrep -iw "ext4|ext3|xfs|gfs|gfs2|btrfs"|sort -u -t' ' -k1,2
lsblk; echo
vgdisplay -v; echo

#### Network Systems Check
echo -e "\n\n#### Network Systems Check\n"
ip addr; echo
ip route; echo
ntpq -pn; echo
dig $(uname -n); echo
netstat -aln | grep 'LISTEN '; echo

#### Log Files Checks
echo -e "\n\n#### Log Files Checks\n"
ls -lth /var/log/messages*
if ! grep -i error /var/log/messages; then
    echo -e "\n**** NO ERRORS FOUND IN /var/log/messages"
fi

#### Use open source server profiling tools
# - No point re-inventing the wheel
# Add code to execute RHEL sosreport and cfg2html
