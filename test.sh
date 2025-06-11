#!/bin/bash
RED='\033[1;31m'
GRN='\033[1;32m'
BLU='\033[1;34m'
YEL='\033[1;33m'
PUR='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'

clear
echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════╗"
echo -e "║            ${YEL}Welcome to ShengeKeJi Script${CYAN}              ║"
echo -e "║         ${GRN}MDM Check & AutoBypass for macOS${CYAN}             ║"
echo -e "║              Powered by ${RED}申哥技术支持${CYAN}                   ║"
echo -e "║              Website: ${BLU}shengekeji.cn${CYAN}                  ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

PS3=$'\n请选择一个操作（输入序号）: '
options=("一键绕过 MDM (恢复模式)" "重启 Mac")
select opt in "${options[@]}"; do
	case $opt in
	"一键绕过 MDM (恢复模式)")
		echo -e "${GRN}正在进入恢复模式绕过流程..."
		if [ -d "/Volumes/Macintosh HD - Data" ]; then
   			diskutil rename "Macintosh HD - Data" "Data"
		fi

		echo -e "\n${GRN}请输入新用户信息（默认用户名为 Apple，密码为 1234）：${NC}"
		read -p "用户昵称（Real Name）: " realName
  		realName="${realName:=Apple}"

    	read -p "系统登录名（英文无空格）: " username
		username="${username:=Apple}"

    	read -p "密码: " passw
      	passw="${passw:=1234}"

		dscl_path='/Volumes/Data/private/var/db/dslocal/nodes/Default' 
        echo -e "${GRN}创建用户中..."
  		dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username"
      	dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UserShell "/bin/zsh"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" RealName "$realName"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" UniqueID "501"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" PrimaryGroupID "20"
		mkdir "/Volumes/Data/Users/$username"
	    dscl -f "$dscl_path" localhost -create "/Local/Default/Users/$username" NFSHomeDirectory "/Users/$username"
	    dscl -f "$dscl_path" localhost -passwd "/Local/Default/Users/$username" "$passw"
	    dscl -f "$dscl_path" localhost -append "/Local/Default/Groups/admin" GroupMembership $username

		echo -e "${YEL}正在屏蔽 MDM 服务器..."
		echo "0.0.0.0 deviceenrollment.apple.com" >> /Volumes/Macintosh\ HD/etc/hosts
		echo "0.0.0.0 mdmenrollment.apple.com" >> /Volumes/Macintosh\ HD/etc/hosts
		echo "0.0.0.0 iprofiles.apple.com" >> /Volumes/Macintosh\ HD/etc/hosts
        echo -e "${GRN}Host 屏蔽完成。"

		echo -e "${BLU}清理配置文件..."
  		touch /Volumes/Data/private/var/db/.AppleSetupDone
        rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigHasActivationRecord
		rm -rf /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordFound
		touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigProfileInstalled
		touch /Volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/.cloudConfigRecordNotFound

		echo -e "\n${CYAN}✅ 绕过成功！请退出终端并重启 Mac 以完成设置。${NC}"
		break
		;;

	"重启 Mac")
 		echo -e "${YEL}系统即将重启，请稍候...${NC}"
		reboot
		break
		;;

	*) 
		echo -e "${RED}无效的选项：$REPLY，请重新选择。${NC}" 
		;;
	esac
done
