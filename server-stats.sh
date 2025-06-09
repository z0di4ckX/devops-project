#!/bin/bash
# Project: server-stats.sh - Script to analyze server performances stats
# File Created: 2025-08-06
# Author: xR0n1n

echo "==========================="
echo "📊 Server Performance Stats"
echo "==========================="

echo ""
echo "🧠 CPU Usage:"
top -bn1 | awk -F',' '/Cpu\(s\)/ { 
  split($1,a,"%"); 
  split($2,b,"%"); 
  split($4,d,"%"); 
  print "User: " a[1] "%, System: " b[1] "%, Idle: " d[1] "%"
}'

echo ""
echo "💾 Memory Usage:"
free -m | awk 'NR==2{
    used=$3; 
    free=$4; 
    total=$2; 
    printf "Used: %s MB, Free: %s MB (%.2f%% used)\n", used, free, (used/total)*100
}'

echo ""
echo "📦 Disk Usage:"
df -h / | awk 'NR==2{
    printf "Used: %s, Free: %s (%s used)\n", $3, $4, $5
}'

echo ""
echo "🔥 Top 5 processes by CPU usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

echo ""
echo "📈 Top 5 processes by Memory usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

echo ""
echo "🛠️ OS Version:"
if command -v lsb_release >/dev/null 2>&1; then
  lsb_release -d
else
  grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'
fi

echo ""
echo "⏳ Uptime:"
uptime -p


echo ""
echo "📉 Load Average (1min, 5min, 15min):"
uptime | awk -F'load average: ' '{print $2}'

echo ""
echo "👥 Logged-in Users:"
who | awk '{print $1}' | sort | uniq -c

echo ""
echo "🚨 Failed Login Attempts:"
if [ -f /var/log/auth.log ]; then
  grep "Failed password" /var/log/auth.log | wc -l
elif [ -f /var/log/secure ]; then
  grep "Failed password" /var/log/secure | wc -l
else
  echo "Log file not found or no permission to read."
fi


