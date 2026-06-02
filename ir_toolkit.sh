#!/bin/bash

show_header() {
    echo "======================================"
    echo "      LINUX INCIDENT RESPONSE TOOLKIT"
    echo "======================================"
    echo ""
}

show_host_info() {
    echo "======================================"
    echo "HOST INFORMATION"
    echo "======================================"
    echo ""

    echo "Hostname: $(hostname)"
    echo "Current User: $(whoami)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo "Date: $(date)"
    echo ""
}

show_privilege_findings() {

    echo "======================================"
    echo "PRIVILEGE FINDINGS"
    echo "======================================"
    echo ""

    SUDO_COUNT=$(sudo journalctl | grep "COMMAND=" | wc -l)

    echo "Total Sudo Commands: $SUDO_COUNT"
    echo ""

    echo "Top 10 Most Common Commands:"
    echo ""

    sudo journalctl | grep "COMMAND=" \
    | awk -F'COMMAND=' '{print $2}' \
    | sort | uniq -c | sort -nr | head -10

    echo ""

    if sudo journalctl | grep "COMMAND=" | grep -Eq "usermod|groupmod|passwd"; then

        echo "[WARNING] Account modification activity detected"
        echo ""

        sudo journalctl | grep "COMMAND=" \
        | grep -E "usermod|groupmod|passwd" \
        | tail -10

    else
        echo "[INFO] No account modification activity detected"
    fi

    echo ""
}

show_authentication_findings() {

    echo "======================================"
    echo "AUTHENTICATION FINDINGS"
    echo "======================================"
    echo ""

    FAILED=$(sudo grep -i "failed password" /var/log/auth.log 2>/dev/null | wc -l)

    echo "Failed Login Attempts: $FAILED"
    echo ""

    echo "Recent Failed Logins:"
    echo ""

    sudo grep -i "failed password" /var/log/auth.log 2>/dev/null | tail -5

    echo ""
    echo "Recent Successful Logins:"
    echo ""

    who 
    echo ""
}

show_network_findings() {

    echo "======================================"
    echo "NETWORK FINDINGS"
    echo "======================================"
    echo ""

    echo "Listening Ports:"
    echo ""

    sudo ss -tulpn | head -15

    echo ""
    echo "Active Connections:"
    echo ""

    sudo ss -tunp | head -15

    echo ""
}

show_user_findings() {

    echo "======================================"
    echo "USER FINDINGS"
    echo "======================================"
    echo ""

    echo "Users With Interactive Shells:"
    echo ""

    grep "/bin/bash\|/bin/sh" /etc/passwd

    echo ""
}

show_sudo_users() {

    echo "======================================"
    echo "SUDO USERS"
    echo "======================================"
    echo ""

    getent group sudo

    echo ""
}

show_process_findings() {

    echo "======================================"
    echo "PROCESS FINDINGS"
    echo "======================================"
    echo ""

    echo "Top Memory Consuming Processes:"
    echo ""

    ps aux --sort=-%mem | head -10

    echo ""
}

show_world_writable() {

    echo "======================================"
    echo "WORLD WRITABLE FILES"
    echo "======================================"
    echo ""

    find / -type f -perm -0002 2>/dev/null | head -20

    echo ""
}

generate_report() {

    mkdir -p reports

    REPORT_FILE="reports/ir-report-$(date +%F-%H%M%S).txt"

    {
        show_header
        show_host_info
        show_privilege_findings
        show_authentication_findings
        show_network_findings
        show_user_findings
        show_sudo_users
        show_process_findings
        show_world_writable
        show_overall_assessment
    } > "$REPORT_FILE"

    echo ""
    echo "[INFO] Report saved to: $REPORT_FILE"
    echo ""
}

show_overall_assessment() {

    echo "======================================"
    echo "OVERALL ASSESSMENT"
    echo "======================================"

    if sudo journalctl | grep "COMMAND=" | grep -Eq "usermod|groupmod|passwd"; then
        echo "STATUS: REVIEW RECOMMENDED"
    else
        echo "STATUS: NO CRITICAL FINDINGS"
    fi

    echo ""
}

show_header
show_host_info
show_privilege_findings
show_authentication_findings
show_network_findings
show_user_findings
show_sudo_users
show_process_findings
show_world_writable
show_overall_assessment

generate_report
