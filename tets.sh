#!/bin/bash

# 设置颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 设置日志文件
LOG_FILE="monitor_$(date +'%Y-%m-%d_%H-%M-%S').log"

# 设置阈值
CPU_THRESHOLD=80
MEM_THRESHOLD=85

# 清理终端
clear

# 主监控函数
monitor_system() {
    echo -e "${GREEN}===================================== 系统监控中心 =====================================${NC}"
    echo

    # 系统信息
    echo -e "${BLUE}=== 系统信息 ===${NC}"
    echo -e "🖥️ 主机名: $(hostname)"
    echo -e "📦 系统版本: $(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2)"
    echo -e "🔧 内核版本: $(uname -r)"
    echo

    # 资源使用情况
    echo -e "${BLUE}=== 资源使用情况 ===${NC}"
    CPU_USAGE=$(top -b -n 1 | grep 'Cpu(s)' | awk '{print $2}' | awk '{print 100 - $1}')
    MEM_USAGE=$(free -m | grep Mem | awk '{print ($3 / $2) * 100}' | awk '{printf "%.2f%%", $0}')
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')

    echo -e "💻 CPU使用率: ${CPU_USAGE}%"
    echo -e "📖 内存使用: ${MEM_USAGE}"
    echo -e "💾 硬盘使用: ${DISK_USAGE}%"
    echo

    # 进程和网络
    echo -e "${BLUE}=== 进程和网络 ===${NC}"
    MAX_CPU_PROCESS=$(ps aux --sort=-%cpu | head -n 1 | awk '{print $11}')
    MAX_MEM_PROCESS=$(ps aux --sort=-%mem | head -n 1 | awk '{print $11}')
    SSH_CONNECTIONS=$(netstat -tuln | grep ':22' | wc -l)

    echo -e "📈 最大CPU进程: ${MAX_CPU_PROCESS}"
    echo -e "📊 最大内存进程: ${MAX_MEM_PROCESS}"
    echo -e "🌐 SSH连接数: ${SSH_CONNECTIONS}"
    echo

    # 磁盘和网络IO
    echo -e "${BLUE}=== 磁盘和网络IO ===${NC}"
    DISK_IO=$(iostat -dx | awk '{print $4 + $5}')
    NETWORK_TRAFFIC=$(ss -s | grep '总计' | awk '{print $3}')

    echo -e "📀 磁盘读写: ${DISK_IO} KB/s"
    echo -e "🌐 网络流量: ${NETWORK_TRAFFIC} KB/s"
    echo

    # 告警检查
    if [ $(echo "${CPU_USAGE} > ${CPU_THRESHOLD}" | bc) -eq 1 ]; then
        echo -e "${RED}⚠️ 警告：CPU使用率过高，当前使用率为${CPU_USAGE}%${NC}"
    fi

    if [ $(echo "${MEM_USAGE} > ${MEM_THRESHOLD}" | bc) -eq 1 ]; then
        echo -e "${RED}⚠️ 警告：内存使用率过高，当前使用率为${MEM_USAGE}%${NC}"
    fi
}

# 生成HTML报告
generate_html_report() {
    echo -e "<html><head><title>Server Monitor</title></head><body>" > report.html
    echo -e "<h1>服务器监控报告</h1>" >> report.html
    echo -e "<h2>系统信息</h2>" >> report.html
    echo -e "<p>主机名: $(hostname)</p>" >> report.html
    echo -e "<p>系统版本: $(cat /etc/os-release | grep PRETTY_NAME | cut -d '=' -f2)</p>" >> report.html
    echo -e "<p>内核版本: $(uname -r)</p>" >> report.html
    echo -e "<h2>资源使用情况</h2>" >> report.html
    echo -e "<p>CPU使用率: ${CPU_USAGE}%</p>" >> report.html
    echo -e "<p>内存使用: ${MEM_USAGE}</p>" >> report.html
    echo -e "<p>硬盘使用: ${DISK_USAGE}%</p>" >> report.html
    echo -e "<h2>进程和网络</h2>" >> report.html
    echo -e "<p>最大CPU进程: ${MAX_CPU_PROCESS}</p>" >> report.html
    echo -e "<p>最大内存进程: ${MAX_MEM_PROCESS}</p>" >> report.html
    echo -e "<p>SSH连接数: ${SSH_CONNECTIONS}</p>" >> report.html
    echo -e "<h2>磁盘和网络IO</h2>" >> report.html
    echo -e "<p>磁盘读写: ${DISK_IO} KB/s</p>" >> report.html
    echo -e "<p>网络流量: ${NETWORK_TRAFFIC} KB/s</p>" >> report.html
    echo -e "</body></html>" >> report.html
}

# 记录日志
record_log() {
    echo -e "[$(date +'%Y-%m-%d %H:%M:%S')] ${1}" >> ${LOG_FILE}
}

# 主函数
main() {
    while true; do
        clear
        monitor_system
        record_log "监控信息更新"
        generate_html_report
        echo -e "${GREEN}===================================== 监控完成 =====================================${NC}"
        echo -e "${YELLOW}⏰ 执行时间: $(date)${NC}"
        sleep 5
    done
}

# 运行主函数
main
