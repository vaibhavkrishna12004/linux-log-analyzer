#!/bin/bash

show_header() {
    echo "================================="
    echo " LINUX INCIDENT RESPONSE TOOLKIT "
    echo "================================="
    echo ""
}

show_privilege_findings() {

    echo "================================="
    echo " PRIVILEGE FINDINGS "
    echo "================================="

    SUDO_COUNT=$(sudo journalctl | grep "COMMAND=" | wc -l)

    echo ""
    echo "Total Sudo Commands: $SUDO_COUNT"
    echo ""

    echo "Top 10 Most Common Commands:"
    echo ""

    sudo journalctl | grep "COMMAND=" | awk -F'COMMAND=' '{print $2}' | sort | uniq -c | sort -nr | head -10

    echo ""

    if sudo journalctl | grep "COMMAND=" | grep -Eq "usermod|groupmod|passwd"; then
        echo "[WARNING] Account modification activity detected"
    else
        echo "[INFO] No account modification activity detected"
    fi

    echo ""
}

show_authentication_findings() {

    echo "================================="
    echo " AUTHENTICATION FINDINGS "
    echo "================================="

    echo ""
    echo "[COMING SOON]"
    echo ""
}

show_network_findings() {

    echo "================================="
    echo " NETWORK FINDINGS "
    echo "================================="

    echo ""
    echo "[COMING SOON]"
    echo ""
}

show_overall_assessment() {

    echo "================================="
    echo " OVERALL ASSESSMENT "
    echo "================================="

    if sudo journalctl | grep "COMMAND=" | grep -Eq "usermod|groupmod|passwd"; then
        echo "STATUS: REVIEW RECOMMENDED"
    else
        echo "STATUS: NO CRITICAL FINDINGS"
    fi

    echo ""
}

show_header
show_privilege_findings
show_authentication_findings
show_network_findings
show_overall_assessment
