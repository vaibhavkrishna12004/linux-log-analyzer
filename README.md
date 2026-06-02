# Linux Log Analyzer

A Bash-based Linux security monitoring tool that analyzes Linux system logs and summarizes privileged command activity.

## Features

- Counts sudo command executions
- Displays top 10 most common sudo commands
- Shows recent privileged activity
- Uses journald log analysis

## Usage

chmod +x log_analyzer.sh
./log_analyzer.sh

## Sample Output

=================================
      SUDO ACTIVITY REPORT
=================================

Total Sudo Commands: 307

Top 10 Most Common Sudo Commands:
25 /usr/bin/apt update
16 /usr/sbin/reboot
...
