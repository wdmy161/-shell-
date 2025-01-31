#!/bin/bash

# 定义颜色输出
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# 输出服务器概要信息
echo -e "\n${GREEN}服务器概要信息${NC}"
echo "-------------------------"
hostname
uname -a

# 内存使用情况
echo -e "\n${GREEN}内存使用情况${NC}"
echo "-------------------------"
free -m | grep -v + | awk '{print $1, $2, $3, $4, $5, $6, $7}'

# CPU使用情况
echo -e "\n${GREEN}CPU使用情况${NC}"
echo "-------------------------"
top -b -n 1 | grep -i "cpu(s)" | awk '{print $2, $3, $4, $5}'

# 进程占用情况
echo -e "\n${GREEN}进程占用情况${NC}"
echo "-------------------------"
ps aux | awk '{print $1, $2, $3, $4, $5, $6, $7, $8, $9}'

# 网络活动状态
echo -e "\n${GREEN}网络活动状态${NC}"
echo "-------------------------"
netstat -tuln | awk '{print $1, $2, $3, $4}'

# SSH登录状态
echo -e "\n${GREEN}SSH登录状态${NC}"
echo "-------------------------"
last | head -n 10

# 硬盘使用情况
echo -e "\n${GREEN}硬盘使用情况${NC}"
echo "-------------------------"
df -h | awk '{print $1, $2, $3, $4, $5, $6}'

# 内存占用情况
echo -e "\n${GREEN}内存占用情况${NC}"
echo "-------------------------"
free -m | grep -v + | awk '{print $1, $2, $3, $4, $5, $6, $7}'

# CPU占用情况
echo -e "\n${GREEN}CPU占用情况${NC}"
echo "-------------------------"
top -b -n 1 | grep -i "cpu(s)" | awk '{print $2, $3, $4, $5}'

# 硬盘占用情况
echo -e "\n${GREEN}硬盘占用情况${NC}"
echo "-------------------------"
df -h | awk '{print $1, $2, $3, $4, $5, $6}'

# 内存情况
echo -e "\n${GREEN}内存情况${NC}"
echo "-------------------------"
free -m | grep -v + | awk '{print $1, $2, $3, $4, $5, $6, $7}'

# CPU使用情况
echo -e "\n${GREEN}CPU使用情况${NC}"
echo "-------------------------"
top -b -n 1 | grep -i "cpu(s)" | awk '{print $2, $3, $4, $5}'
