#!/bin/bash
echo -ne "\033]10;#00fff2\007"
echo -ne "\033]11;#353535\007"
mwv="\e[92m"
wtl="\e[91m"
yvt="\e[93m"
ism="\e[95m"
blank="\e[39m"
lrj="\e[34m"
fs="\e[96m"
cyan='\e[0;36m'
lightgreen='\e[1;32m'
BlueF='\e[1;34m'
RESET=$(tput sgr0)
title="Kathedral"
mwv="\e[92m"
wtl="\e[91m"
yvt="\e[93m"
ism="\e[95m"
blank="\e[39m"
lrj="\e[34m"
fs="\e[96m"
myip=`curl -s ifconfig.io`
reset

if [ "$BASH_SOURCE" = "" ]; then
    echo "წარმოიქმნა სინტაქსური შეცდომა!"
    exit 1
fi
blank=39
shv=30
ttr=97
wtl=31
mwv=32
yvt=33
lrj=34
ncr=37
drawClear() {
    $ESC_WRITE "\033c"
}
drawColour() {
    local colour=$blank
    local bgColour=$((blank+10))
    if [[ ! -z "$1" && "$1" != "" ]]; then
        colour="$1"
    fi
    if [[ ! -z "$2" && "$2" != "" ]]; then
        bgColour="$2"
    fi
    $ESC_ECHO "\033c\033[H\033[J\033[${colour};${bgColour}m\033[J"
}
drawPlain() {
    if [[ -z "$2" || "$2" -eq 0 ]]; then
        $ESC_WRITE "$1"
    else
        $ESC_ECHO "$1"
    fi
}
drawSpecial() {
    [[ -z "$2" ]] && newLine=0 || newLine="$2"
    draw_SetDrawMode
    drawPlain "$1" "$newLine"
    draw_SetWriteMode
}
drawHighlight() {
    [[ -z "$2" ]] && newLine=0 || newLine="$2"
    draw_StartHighlight
    drawPlain "$1" "$newLine"
    draw_EndHighlight
}
drawPlainAt() {
    [[ -z "$4" ]] && newLine=0 || newLine="$4"
    draw_MoveTo $1 $2
    drawPlain "$3" "$newLine"
}
drawHighlightAt() {
    [[ -z "$4" ]] && newLine=0 || newLine="$4"
    draw_StartHighlight
    drawPlainAt "$1" "$2" "$3" "$newLine"
    draw_EndHighlight
}
ESC_WRITE='echo -en'
ESC_ECHO='echo -e'
draw_MoveTo() {
    $ESC_WRITE "\033[${1};${2}H"
}
draw_StartHighlight() {
    $ESC_WRITE "\033[7m"
}
draw_EndHighlight() {
    $ESC_WRITE "\033[27m"
}
draw_SetDrawMode() {
    $ESC_WRITE "\033%@\033(0"
}
draw_SetWriteMode() {
    $ESC_WRITE "\033(B"
}
if [ "$BASH_SOURCE" = "" ]; then
    echo "დაიკარგა სისტემური ძრავის ნაწილები"
    exit 1
fi
declare -a menuItems
declare -a menuActions
menuHeaderText=""
menuFooterText=""
menuBorderText=""
menuTop=2
menuLeft=27
menuWidth=42
menuMargin=5
menuItems[0]="Exit"
menuActions[0]="return 0"
menuItemCount=1
menuLastItem=0
menuColour=$ttr
menuHighlight=$mwv
menuInit() {
  borderup="\033[0m\033[0;32m\e[92m┌──────────────────────────────────────────────────────────┐"
  centerA="\e[92m│                                                          │"
#  centerB="\e[92m│ \e[92mშექმნილია „\e[91mკიბერ უსაფრთხოების ჯგუფის\e[92m“ პენ-ტესტერებისთვის\e[92m │"
  centerC="\e[92m│                \e[93mპროექტის ავტორი: \e[92mPwn\e[91m3Xpert\e[92m                │"
  centerD="\e[92m│                                                          │"
  borderdown="└──────────────────────────────────────────────────────────┘"
    menuItemCount=${#menuItems[@]}
    menuLastItem=$((menuItemCount-1))
    menuHeaderText=`printf "%-${menuWidth}s" "\e[92m${borderup}\n    │$menuTitle│"`
    menuFooterText=`printf "%-${menuWidth}s" "\033[0m\033[0;92m│$menuFooter\n    \033[0m\033[0;32m$centerD\n    \033[0m\033[0;32m$centerC\n    ${borderdown}\n"`
    local marginSpaces=$((menuMargin-1))
    local menuSpaces=$((menuWidth-2))
    local leftGap=`printf "%${marginSpaces}s" ""`
    local midGap=`printf "%${menuSpaces}s" ""`
    menuBorderText="${leftGap}x${midGap}x"
}
menu_Display() {
    local menuSize=$((menuItemCount+2))
    local menuEnd=$((menuSize+menuTop+1))
    drawClear
    drawColour $menuColour $menuHighlight
    drawHighlightAt $menuTop $menuMargin "$menuHeaderText" 1
    for row in $(seq 1 $menuSize); do
    drawSpecial "$menuBorderText" 1
    done
    drawHighlightAt $menuEnd $menuMargin "$menuFooterText" 1
    for item in $(seq 0 $menuLastItem); do
    menu_ClearItem $item
    done
}
menu_ClearItem() {
    local item=$1
    local top=$((menuTop+item+2))
    local menuText=${menuItems[$item]}

    drawPlainAt $top $menuLeft "$menuText"
}
menu_HighlightItem() {
    local item=$1
    local top=$((menuTop+item+2))
    local menuText=${menuItems[$item]}
    drawHighlightAt $top $menuLeft "$menuText"
}
menu_HandleInput() {
    local choice=$1
    local after=$((choice+1))
    [[ $after -gt $menuLastItem ]] && after=0
    local before=$((choice-1))
    [[ $before -lt 0 ]] && before=$menuLastItem
    menu_ClearItem $before
    menu_ClearItem $after
    menu_HighlightItem $choice
    local key=""
    local extra=""
    read -s -n1 key 2> /dev/null >&2
    while read -s -n1 -t .05 extra 2> /dev/null >&2 ; do
        key="$key$extra"
    done
    local delete=`echo -en "\033[3~"`
    local escKey=`echo -en "\033"`
    local upKey=`echo -en "\033[A"`
    local downKey=`echo -en "\033[B"`
    if [[ $key = $upKey ]]; then
        return $before
    elif [[ $key = $downKey ]]; then
        return $after
   
    elif [[ $key = $delete ]]; then
        if [[ $choice -eq $menuLastItem ]]; then
            key=""
        else
            menu_ClearItem $choice
            return $menuLastItem
        fi         

    elif [[ $key = $escKey ]]; then
        if [[ $choice -eq $menuLastItem ]]; then
            key=""
        else
            menu_ClearItem $choice
            return $menuLastItem
        fi
    elif [[ ${#key} -eq 1 ]]; then
        for index in $(seq 0 $menuLastItem) ; do
            local item=${menuItems[$index]}
            local startChar=${item:0:1}
            if [[ "$key" = "$startChar" ]]; then
                menu_ClearItem $choice
                return $index
            fi
        done
    fi
    if [[ "$key" = "" ]]; then
        return 255
    fi
    return $choice
}
menuLoop() {
    local choice=0
    local running=1
    menu_Display
    while [[ $running -eq 1 ]]; do
        local caseMatch=`shopt -p nocasematch`
        shopt -s nocasematch
        menu_HandleInput $choice
        local newChoice=$?
        $caseMatch
        if [[ $newChoice -eq 255 ]]; then
            drawClear
            action=${menuActions[$choice]}
            $action
            running=$?
            [[ $running -eq 1 ]] && menu_Display
        elif [[ $newChoice -lt $menuItemCount ]]; then
            choice=$newChoice
        fi
    done
    drawClear
}

K-CLI() {
engine () {
oops(){
    echo "" > /dev/null
}
ctrl
clear
exit='echo -ne "\033]110;\007\033]111;\007";""exit'
mwv="\e[92m"
wtl="\e[91m"
yvt="\e[93m"
ism="\e[95m"
blank="\e[39m"
lrj="\e[34m"
fs="\e[96m"
cyan='\e[0;36m'
lightgreen='\e[1;32m'
BlueF='\e[1;34m'
RESET=$(tput sgr0)
title="Kathedral"
func=""
hostorip=``
ttr='\033[0;37m'
who=`whoami`
param(){
  echo -e " მაგ. use pentest
  $wtl  │$blank
  $wtl  │$blank
  $wtl  └──$mwv pentest$yvt >$blank
  $wtl         ├──$mwv webscan$blank
  $wtl         ├──$mwv iprange$blank
  $wtl         ├──$mwv portscan$blank
  $wtl         ├──$mwv vuln$blank
  $wtl         └──$mwv subdomain$blank
"
}
paramw(){
  echo -e " მაგ. use pentest param
  $wtl  │$blank
  $wtl  │$blank
  $wtl  └──$mwv pentest$yvt >$blank
  $wtl         ├──$mwv webscan$blank
  $wtl         ├──$mwv iprange$blank
  $wtl         ├──$mwv portscan$blank
  $wtl         ├──$mwv vuln$blank
  $wtl         └──$mwv subdomain$blank
"
}

paramd(){
  echo -e " მაგ. use database param 
  $wtl  │$blank
  $wtl  │$blank
  $wtl  └──$mwv pentest$yvt >$blank
"
}
set_module(){
echo -e "
$mwv[+]$RESET მოდულები:
"
echo -e $mwv"┌────────────┬────────────────────────────────────────────────────┐"
echo -e $mwv"│$wtl ip$mwv         │ $yvtდაამატეთ აიპი მისამართები როგორც შიდა ისე გარე$mwv     │"
echo -e $mwv"│$wtl url$mwv        │ $yvtდაამატეთ სრული ბმული გარდა პროტოკოლისა მაგ.$wtl site.ge$mwv│"
echo -e $mwv"└────────────┴────────────────────────────────────────────────────┘"

}

modules(){
echo -e "
$mwv[+]$RESET მოდულები:
"
echo -e $wtl" [წითელი]========> pentest"
echo -e $lrj" [ლურჯი]=========> database"
echo ""
echo -e $mwv"┌────────────┬────────────────────────────────────────────────────┐"
echo -e $mwv"│$wtl webscan$mwv    │ $yvtდიაპაზონის სკანირება კავშირზე$mwv                      │"
echo -e $mwv"│$wtl iprange$mwv    │ $yvtდიაპაზონის სკანირება კავშირზე$mwv                      │"
echo -e $mwv"│$wtl portscan$mwv   │ $yvtგახსნილი პორტების სკანირება $wtl(დიაპაზონზე)$mwv           │"
echo -e $mwv"│$wtl hostinfo$mwv   │ $yvtსაბაზისო ინფორმაცია დომეინზე$mwv                       │"
echo -e $mwv"│$wtl vuln$mwv       │ $yvtსისუსტეებზე მორგებული ექსპლოიტების სია$mwv             │"
echo -e $mwv"│$wtl subdomain$mwv  │ $yvtქვედომაინების ძებნა $wtl(Google)$mwv                       │"
#echo -e $mwv"│$wtl cloudflare$mwv │ $yvtქლაუდფლაერიდან რეალური აიპი მისამართის დადგენა$mwv     │"
echo -e $mwv"└────────────┴────────────────────────────────────────────────────┘"

}
help(){

echo -e "
$mwv[+]$RESET ფუნქციები: [არგუმენტი]"
echo ""
echo -e $mwv"┌────────────┬────────────────────────────────────────────────────┐"
echo -e $mwv"│$wtl help$mwv       │ $yvtდახმარება$mwv                                          │"
echo -e $mwv"│$wtl show$mwv       │ $yvtმაჩვენე პროგრამის მოდულები$mwv                         │"
echo -e $mwv"│$wtl use$mwv        │ $yvtმოდულის არჩევა$mwv                                     │"
echo -e $mwv"│$wtl set$mwv        │ $yvtპარამეტრის არჩევა$mwv                                  │"
echo -e $mwv"│$wtl run$mwv        │ $yvtმოდულის გაშვებაა$mwv                                   │"
echo -e $mwv"│$wtl scan$mwv       │ $yvtსაიტის სკანირება$mwv                                   │"
echo -e $mwv"│$wtl clear$mwv      │ $yvtეკრანის დასუფთავება$mwv                                │"
echo -e $mwv"│$wtl exit$mwv       │ $yvtპროგრამის გათიშვა$mwv                                  │"
echo -e $mwv"└────────────┴────────────────────────────────────────────────────┘"
echo ""
}
banner(){
  reset
echo -e "
                            ▄▄▄▄▄▄▄▄
                          ▄██████████▄
                          ████████████
                         ██    ██    ██
                         ██$wtl▄$blank   ██$wtl▄$blank   ██
                         ██████████████
                         ███████▄██████ 
                         ██████████████
                         ██████████████ 
                         ██████████████ 
                         ██████████████
                         █████████▐▌██▌
                         $wtl▐▀$blank▐ ▌▀█▀ $wtl▐$blank █
                               $wtl▐    ▌$blank     "
sleep 0.1
clear
echo -e "
                            ▄▄▄▄▄▄▄▄
                          ▄██████████▄
                          ████████████
                         ██$wtl▄$blank   ██$wtl▄$blank   ██
                         ██    ██    ██
                         ██████████████
                         ██████▄███████ 
                         ██████████████
                         ██████████████ 
                         ██████████████ 
                         ██████████████
                         █████████▐▌██▌
                         $wtl▐▀$blank▐ ▌▀█▀ $wtl▐$blank █
                               $wtl▐    ▌$blank    "
sleep 0.1
clear
echo -e "
                            ▄▄▄▄▄▄▄▄
                          ▄██████████▄
                          ████████████
                         ██    ██    ██
                         ██ $wtl▄$blank  ██ $wtl▄$blank  ██
                         ██████████████
                         ███████▄██████ 
                         ██████████████
                         ██████████████ 
                         ██████████████ 
                         ██████████████
                         █████████▐▌██▌
                         $wtl▐▀$blank▐ ▌▀█▀ $wtl▐$blank █
                               $wtl▐    ▌$blank     "
sleep 0.1
clear
echo  -e "
                            ▄▄▄▄▄▄▄▄
                          ▄██████████▄
                          ████████████
                         ██    ██    ██
                         ██  $wtl▄$blank ██ $wtl▄$blank  ██
                         ██████████████
                         ██████████████ 
                         ██████████████
                         ██████████████ 
                         ██████████████ 
                         ██████████████
                         █████████▐▌██▌
                         $wtl▐▀$blank▐ ▌▀█▀ $wtl▐$blank █
                               $wtl▐    ▌$blank "
sleep 0.1
clear
echo -e "
                            ▄▄▄▄▄▄▄▄
                          ▄██████████▄
                          ████████████
                         ██    ██    ██
                         ██  $wtl▄$blank ██ $wtl▄$blank  ██
                         ██████████████
                         ██████████████ 
                         ███        ███
                         ███▄      ▄███ 
                         ██████████████ 
                         ██████████████
                         █████████▐▌██▌
                         $wtl▐▀$blank▐ ▌▀█▀ $wtl▐$blank █
                               $wtl▐    ▌$blank "       
sleep 0.1
clear
echo -e "
                            ▄▄▄▄▄▄▄▄
                          ▄██████████▄
                          ████████████
                         ██▀▀██████▀▀██
                         ██  $wtl▄$blank ██ $wtl▄$blank  ██
                         ██████████████
                         ██████████████ 
                         ███        ███
                         ███▄      ▄███ 
                         ██████████████ 
                         ██████████████
                         █████████▐▌██▌
                         $wtl▐▀$blank▐ ▌▀█▀ $wtl▐$blank █
                               $wtl▐    ▌$blank " 
sleep 0.1
clear                       
echo -e "
                            $blank▄▄▄▄▄▄▄▄
                    $wtl  █$blank   ▄██████████▄
                    $wtl █▐ $blank  ████████████
                    $wtl ▌$blank▐  ██▀▀██████▀▀██
                    $wtl▐$blank┼▐  ██  $wtl▄$blank ██ $wtl▄$blank  ██
                    $wtl▐┼$blank▐  ██████████████
                    ▐▄▐████ ▀$wtl▐$blank▐▀█ █ $wtl▌$blank▐██▄ 
                      █████          ▐███▌
                      █▀▀██▄$wtl█$blank ▄   $wtl▐$blank ▄███▀ 
                      █  ███████▄██████ 
                         ██████████████
                         █████████▐▌██▌
                         $wtl▐▀$blank▐ ▌▀█▀ $wtl▐$blank █
                               $wtl▐    ▌ "
sleep 0.1
reset
echo -e "
                            $blank▄▄▄▄▄▄▄▄
                      $wtl█$blank   ▄██████████▄
                     $wtl█▐$blank   ████████████
                     $wtl▌$blank▐  ██▀▀██████▀▀██
                    $wtl▐$blank┼▐  ██  $wtl▄$blank ██ $wtl▄$blank  ██
                    $wtl▐┼$blank▐  ██████████████
                    ▐▄▐████ ▀$wtl▐$blank▐▀█ █ $wtl▌$blank▐██▄ 
                      █████          ▐███▌
                      █▀▀██▄$wtl█$blank ▄   $wtl▐$blank ▄███▀ 
                      █  ███████▄██████ 
                         ██████████████
                         █████████▐▌██▌
                         $wtl▐▀$blank▐ ▌▀█▀ $wtl▐$blank █
                               $wtl▐$blank    $wtl▌$blank 
     $wtl       ___  _____        ____ _____   _____  ___       $blank
     $wtl|___/ |___|   |   |____| ____ |    \ |____/ |___| |    $blank
     $wtl|   \ |   |   |   |    | ____ |____/ |   \_ |   | |____$blank
     0x4B 0x61 0x74 0x68 0x65 0x64 0x72 0x61 0x6C 0x56 0x32
   $mwv[$wtl---------------------------------------------------------$mwv]$blank
   $mwv[$wtl---$mwv]$wtl                   $mwv Kathedral$wtl v2                 $mwv[$wtl---$mwv]$blank 
   $mwv[$wtl---$mwv]$wtl                $mwv კოდერი:$wtl Pwn3Xpert               $mwv[$wtl---$mwv]$blank
   $mwv[$wtl---$mwv]$wtl   $mwv შექმნილია „კიბერ უსაფრთხოების ჯგუფის“ მიერ$wtl   $mwv[$wtl---$mwv]$blank
   $mwv[$wtl---------------------------------------------------------$mwv]$blank"
}
number() {
echo -ne "$yvt[$wtl$title$yvt]@[$wtl$who$yvt]=(ნომერი)>$blank "
read number
export number
echo -e "$mwv[+] დაემატა ნომერი."
}
host() {
echo -ne "$yvt[$wtl$title$yvt]@[$wtl$who$yvt]=(აიპი)>$blank "
read host
export host
echo -e "$mwv[+] დაემატა აიპი მისამართი."
}
domain() {
echo -ne "$yvt[$wtl$title$yvt]@[$wtl$who$yvt]=(დომეინი)>$blank "
read ip_domain
export ip_domain
echo -e "$mwv[+] დაემატა დომეინი."
}
ctrl(){
trap ctrl_c INT
ctrl_c() {
echo -e $wtl"
[*] დაფიქსირდა კლავიატურაზე (Ctrl + C), ნამდვილად გსურთ კათედრალის გათიშვა? დააჭირე კლავიატურაზე (Ctrl + Z)-ს"
exit
}
}
ctrl
exit() {
$(exit)
`exit`
}
scanning() {
ctrl(){
trap ctrl_c INT
ctrl_c() {
echo -e $wtl"
[*] დაფიქსირდა კლავიატურაზე (Ctrl + C), ნამდვილად გსურთ კათედრალის გათიშვა? დააჭირე კლავიატურაზე (Ctrl + Z)-ს"
rm spider.tmp
exit
}
}
echo > spider.tmp
mwv="\e[92m"
wtl="\e[91m"
yvt="\e[93m"
ism="\e[95m"
ttr="\e[97m"
blank="\e[39m"
lrj="\e[34m"
fs="\e[96m"
cyan='\e[0;36m'
lightgreen='\e[1;32m'
BlueF='\e[1;34m'
tmp="spider.tmp"
title="Kathedral"
app="Cron0s"
null="/dev/null"
time=$(date '+%H:%M:%S')
randomagent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0"


################################################################
#ძრავი{

function checking() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${mwv}[${yvt}Connecting${mwv}]:${blank} მიმდინარეობს კავშირის დამყარება $mwv($ttr$ip_domain$mwv)${blank}-საიტზე$blank"
checker=`echo "$ip_domain" | sed 's/http:\/\///g;s/https:\/\///g'`
ip=`dig +short ${checker}`
if [[  ! -z $(dig +short ${checker}) ]]
then
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${mwv}[Connected]:${blank} კავშირი წარმატებით დამყარდა საიტთან. $mwv($ttr$ip_domain$mwv)$blank"
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${mwv}[IP]:${blank} მისამართი: ${mwv}(${wtl}${ip}${mwv})"
else
checker=`echo "$ip_domain" | sed 's/http:\/\///g;s/https:\/\///g'`
if [[  ! -z $(curl -s "http://http://api.hackertarget.com//reversedns/?q=${checker}") ]]
then
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${mwv}[Connected]:${blank} კავშირი წარმატებით დამყარდა საიტთან. $mwv($ttr$ip_domain$mwv)$blank"
robots
else
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${yvt}[${wtl}WhyRuGay?${yvt}]:${blank} მსგავსი ტიპის  დომეინი არ არსებობს !${blank}"
exit
fi
fi
}
sqlbanner() {
  echo -e "
 $wtl ______  _____        $mwv _ _  _  _ ____ ____ ___ _ ____ _  _
 $wtl|______ |     | |      $mwv| |\ |  | |___ |     |  | |  | |\ |
 $wtl _____| |____\| |_____ $mwv| | \| _| |___ |___  |  | |__| | \|
               $wtl\ 
"
}
xssbanner() {
echo -e "
${wtl}##     ##  ######   ######   ${ttr}#######  ${mwv}########${blank}  
 ${wtl}##   ##  ##    ## ##    ## ${ttr}##     ## ${mwv}##     ##${blank} 
  ${wtl}## ##   ##       ##              ${ttr}## ${mwv}##     ##${blank} 
   ${wtl}###     ######   ######   ${ttr}#######  ${mwv}########${blank}  
  ${wtl}## ##         ##       ##        ${ttr}## ${mwv}##   ##${blank}   
 ${wtl}##   ##  ##    ## ##    ## ${ttr}##     ## ${mwv}##    ##${blank}  
${wtl}##     ##  ######   ######   ${ttr}#######  ${mwv}##     ##${blank} "
}
function robots() {
if [[  ! -z $(curl -sLI "$ip_domain/robots.txt" | grep -e "text/plain" -e "Content-Type: text/plain" -e "content-type: text/plain") ]]
then
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[R0B075]:${blank} ნაპოვნია ${mwv}($ttr$ip_domain/robots.txt$mwv)$blank"
else
if [[  ! -z $(curl -sIL "$ip_domain/robots.txt" | grep -e "text/plain" -e "Content-Type: text/plain" -e "content-type: text/plain") ]]
then
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[R0B075]:${blank} ნაპოვნია ${mwv}($ttr$ip_domain/robots.txt$mwv)$blank"
crawl
$(crawl)
else
echo "" > $null
fi
fi
}
function git() {
if [[  ! -z $(curl -sLI "$ip_domain/.git/"| grep -e "200" -e "text/html") ]]
then
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[617]:${blank} ნაპოვნია ${mwv}($ttr$ip_domain/.gitt$mwv) განყოფილება$blank"
else
if [[  ! -z $(curl -sIL "$ip_domain/.git/ | grep 'Index of /.git'") ]]
then
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[617]:${blank} ნაპოვნია ${mwv}($ttr$ip_domain/.git$mwv) განყოფილება$blank"
crawl
$(crawl)
else
echo "" > $null
fi
fi
}

function kathbugcontactauthor() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[${wtl}BUG$mwv]:$wtl ვერ მოხდა საიტის სტრუქტურის შესწავლა.. (${ttr}KathBUG-011${wtl})"
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[${wtl}საიტი$mwv]:$wtl >>> (${ttr}https://kathedral.cybsecgroup.com${wtl}) <<< ${mwv}#გაწერე$wtl [CSG@WebTerm]=> ${mwv}cat kathbug"
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[${wtl}ინფო$mwv]:$wtl ეწვიეთ ოფიციალურ საიტს და მოძებნე კოდი: (${ttr}KathBUG-011${wtl}) და გაიგე მისი მნიშვნელობა"
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $wtlმიმდინარეობს ავარიული გათიშვა"
exit
}
fast() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[${wtl}N00b$mwv]:${blank} თქვენ აირჩიეთ სწრაფი რეჟიმი.. ალბათ ითვალისწინებთ იმ ფაქტსაც რომ შესაძლოა ობობას გამორჩეს მნიშვნელოვანი ბმულები...$blank"
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} მიმდინარეობს ბმულების ძიება შესაძლოა ამას დასჭირდეს რამოდენიმე წუთიც...$blank"
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} გთხოვთ დაელოდოთ, მიმდინარეობს სტრუქტურის ზედაპირული შესწალა...$blank"
wget --spider $ip_domain --recursive --output-file $tmp
cat $tmp | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq | grep -w -v -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "eot" -e "svg" -e "ttf" -e "woff" -e "css" > metadata.tmp
robots
}

proff() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} მიმდინარეობს ბმულების ძიება შესაძლოა ამას დასჭირდეს რამოდენიმე წუთიც...$blank"
echo -ne "$mwv[$yvtინფო$mwv]:${blank} გთხოვთ დაელოდოთ, მიმდინარეობს სტრუქტურის სიღრმისეული შესწავლა...$blank"
wget --spider $ip_domain --recursive --output-file $tmp
cat $tmp | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq | grep -w -v -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "eot" -e "svg" -e "ttf" -e "woff" -e "css" > metadata.tmp

for one in $(curl -sL "$ip_domain" | grep -o "<[^>]*>" | grep -o -e 'action="[^"]*"' -e 'action='\''[^"]*'\''' -e 'href="[^"]*"' -e 'href='\''[^"]*'\''' | sed 's/action=//g;s/href=//g;s/"//g;s/'\''//g' | grep -w -v -e "eot" -e "svg" -e "ttf" -e "woff" -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "css")
do
echo "$ip_domain/${one}" >> $tmp
cat ${tmp} | grep "$ip_domain/$ip_domain" | sed -e "s~$ip_domain\/$ip_domain~$ip_domain~g" | awk '!a[$0]++' >> spider.tmp
cat crawling.txt spider.tmp | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq | grep -w -v -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "css" | sed "s~$ip_domain//~$ip_domain/~g" | awk '!a[$0]++' > metadata.tmp
for two in $(curl -sL "$ip_domain/${one}" | grep -o "<[^>]*>" | grep -o -e 'action="[^"]*"' -e 'action='\''[^"]*'\''' -e 'href="[^"]*"' -e 'href='\''[^"]*'\''' | sed 's/action=//g;s/href=//g;s/"//g;s/'\''//g' | grep -w -v -e "#" -e "eot" -e "svg" -e "ttf" -e "woff" -e "data" -e "javascript" -e "tel" -e "mailto" -e "css")
do
echo "$ip_domain/${two}" >> $tmp
cat ${tmp} | grep "$ip_domain/$ip_domain" | sed -e "s~$ip_domain\/$ip_domain~$ip_domain~g" | awk '!a[$0]++' >> spider.tmp
cat crawling.txt spider.tmp | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq | grep -w -v -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "css" | sed "s~$ip_domain//~$ip_domain/~g" | awk '!a[$0]++' > metadata.tmp
for three in $(curl -sL "$ip_domain/${two}" | grep -o "<[^>]*>" | grep -o -e 'action="[^"]*"' -e 'action='\''[^"]*'\''' -e 'href="[^"]*"' -e 'href='\''[^"]*'\''' | sed 's/action=//g;s/href=//g;s/"//g;s/'\''//g' | grep -w -v -e "#" -e "data" -e "eot" -e "svg" -e "ttf" -e "woff" -e "javascript" -e "tel" -e "mailto" -e "css")
do
echo "$ip_domain/${three}" >> $tmp
cat ${tmp} | grep "$ip_domain/$ip_domain" | sed -e "s~$ip_domain\/$ip_domain~$ip_domain~g" | awk '!a[$0]++' >> spider.tmp
cat crawling.txt spider.tmp | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq | grep -w -v -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "css" | sed "s~$ip_domain//~$ip_domain/~g" | awk '!a[$0]++' > metadata.tmp
done
done
done
count=`cat $tmp | wc -l`
if [ $count -eq 1 ]
then
kathbugcontactauthor
else
echo ""
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} ობობამ დაასრულა სტრუქტურის შესწავლა, მიმდინარეობს გადახარისხება.${blank}"
wget --spider $ip_domain --recursive --output-file crawling.txt
cat crawling.txt spider.tmp | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq | grep -w -v -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "css" | sed "s~$ip_domain//~$ip_domain/~g" | awk '!a[$0]++' > metadata.tmp
fi
}

noob() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} მიმდინარეობს ბმულების ძიება შესაძლოა ამას დასჭირდეს რამოდენიმე წუთიც...$blank"
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} გთხოვთ დაელოდოთ ...$blank"
for one in $(curl -sL "$ip_domain" | grep -o "<[^>]*>" | grep -o -e 'action="[^"]*"' -e 'action='\''[^"]*'\''' -e 'href="[^"]*"' -e 'href='\''[^"]*'\''' | sed 's/action=//g;s/href=//g;s/"//g;s/'\''//g' | grep -w -v -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "css")
do
echo "$ip_domain/${one}" >> $tmp
cat ${tmp} | grep "$ip_domain/$ip_domain" | sed -e "s~$ip_domain\/$ip_domain~$ip_domain~g" | awk '!a[$0]++' >> spider.tmp
for two in $(curl -sL "$ip_domain/${one}" | grep -o "<[^>]*>" | grep -o -e 'action="[^"]*"' -e 'action='\''[^"]*'\''' -e 'href="[^"]*"' -e 'href='\''[^"]*'\''' | sed 's/action=//g;s/href=//g;s/"//g;s/'\''//g' | grep -w -v -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "css")
do
echo "$ip_domain/${two}" >> $tmp
cat ${tmp} | grep "$ip_domain/$ip_domain" | sed -e "s~$ip_domain\/$ip_domain~$ip_domain~g" | awk '!a[$0]++' >> spider.tmp
for three in $(curl -sL "$ip_domain/${two}" | grep -o "<[^>]*>" | grep -o -e 'action="[^"]*"' -e 'action='\''[^"]*'\''' -e 'href="[^"]*"' -e 'href='\''[^"]*'\''' | sed 's/action=//g;s/href=//g;s/"//g;s/'\''//g' | grep -w -v -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "css")
do
echo "$ip_domain/${three}" >> $tmp
cat ${tmp} | grep "$ip_domain/$ip_domain" | sed -e "s~$ip_domain\/$ip_domain~$ip_domain~g" | awk '!a[$0]++' >> spider.tmp
done
done
done
count=`cat $tmp | wc -l`
if [ $count -eq 1 ]
then
kathbugcontactauthor
else
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} ობობამ დაასრულა სტრუქტურის შესწავლა, მიმდინარეობს გადახარისხება."
#ერთიდაიგივე ბმულების ამოშლა
cat spider.tmp | awk '!a[$0]++' > metadata.tmp
fi

}
pro() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${wtl}ამჟამად მიუწვდომელია"
count=`cat $tmp | wc -l`
if [ $count -eq 1 ]
then
kathbugcontactauthor
else
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} ობობამ დაასრულა სტრუქტურის შესწავლა, მიმდინარეობს გადახარისხება."
fi
}
hacker() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${wtl}ამჟამად მიუწვდომელია"
count=`cat $tmp | wc -l`
if [ $count -eq 1 ]
then
kathbugcontactauthor
exit
else
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} ობობამ დაასრულა სტრუქტურის შესწავლა, მიმდინარეობს გადახარისხება."
fi
}
pwner() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${wtl}ამჟამად მიუწვდომელია"
count=`cat $tmp | wc -l`
if [ $count -eq 1 ]
then
kathbugcontactauthor
exit
else
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} ობობამ დაასრულა სტრუქტურის შესწავლა, მიმდინარეობს გადახარისხება."
fi
}
function crawltype() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} მიმდინარეობს ბმულების ძიება შესაძლოა ამას დასჭირდეს რამოდენიმე წუთიც...$blank"
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} აირჩიეთ სკანირების ტიპი.
${wtl}(${ttr}1${wtl}) ${mwv}[${yvt}სწრაფი${mwv}]${blank} საიტის სტრუქტურის ზედაპირული შესწავლა ${wtl}*${mwv}
${wtl}(${ttr}2${wtl}) ${mwv}[${yvt}ნელი${mwv}]${blank} საიტის სტრუქტურის სიღრმისეული შესწავლა"

#echo "${wtl}(${ttr}2${wtl}) ${yvt}დასკანირდეს ყველა ქვე-დომეინი ${wtl}(${ttr}დაურსრულებელი${wtl})
#${wtl}(${ttr}3${wtl}) ${yvt}დასკანირდეს ამავე ჰოსტზე განთავსებული ყველა ქვე-დომეინი. ${wtl}(${ttr}დაურსრულებელი${wtl})
#${wtl}(${ttr}4${wtl}) ${yvt}დასკანირდეს ამავე ჰოსტზე განთავსებული ყველა საიტი. ${wtl}(${ttr}დაურსრულებელი${wtl})" 
echo -ne "$mwv(${ttr}1/2${mwv})>$blank "
read scantype
case $scantype in
1) fast;;
2) proff;;
*) fast;;
esac
}

runningspidermenu() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]: აირჩიეთ სკანირების ტიპი.
${wtl}(${ttr}1${wtl}) ${blank}დასკანირდეს მხოლოდ ჩემს მიერ მითითებული ბმული ${wtl}*${mwv}
${wtl}(${ttr}2${wtl}) ${blank}დასკანირდეს ყველა ქვე-დომეინი ${wtl}(${ttr}დაურსრულებელი${wtl})
${wtl}(${ttr}3${wtl}) ${blank}დასკანირდეს ამავე ჰოსტზე განთავსებული ყველა ქვე-დომეინი. ${wtl}(${ttr}დაურსრულებელი${wtl})
${wtl}(${ttr}4${wtl}) ${blank}დასკანირდეს ამავე ჰოსტზე განთავსებული ყველა საიტი. ${wtl}(${ttr}დაურსრულებელი${wtl})
" 
echo -ne "$mwv(${ttr}1/4${mwv})>$blank "
read scantype
echo ""
case $scantype in
1) noob;;
2) pro;;
3) hacker;;
4) pwner;;
*) noob;;
esac
}

function sqli(){
tamper=( "%27" "\/" "~" "$" )
sqlbanner
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$yvtინფო$mwv]:${blank} მიმდინარეობს SQL ინექციაზე ბმულების ტესტირება შესაძლოა ამას დასჭირდეს რამოდენიმე წამი..."
tmp="metadata.tmp"
diff=$(awk '!a[$0]++' ${tmp} | uniq | grep -w -v -i -e "jpg" -e "css" -e "js" | sed 's/\/\//\//g')
tester=$(echo "$diff" | grep '?' )
for (( i = 0; i < ${#tamper[@]}; ++i )); do
for sqlinj in $(echo "$tester" | sort | uniq | sed "s/=\([a-zA-Z0-9]*\)$/=\1${tamper[i]}/g" ); do
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${yvt}[*]${blank} მიმდინარეობს URL-ის ინექციაზე ტესტირება ${sqlinj}${blank}" | sed 's/http:\/\/testphp.vulnweb.com\///g'
curl -skL --connect-timeout 5 --max-time 5 -A "$randomagent" "${sqlinj}" | grep 'Warning' > /dev/null
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $mwv[$wtlკრიტიკული$mwv]:${blank} SQLi ინექცირებადი ბმული ${mwv}($ttr${sqlinj}$mwv) ფეილოადი ($wtl${tamper[i]}$mwv)$blank"
done
done
}
function cve() {
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${yvt}[${wtl}Pwn3r${yvt}]:${blank} მიმდინარეობს მორგრებადი CVE ექსპლოიტების ძიება${blank}"
if [[ $(nmap --script nmap-vulners -sV -T5 ${ip} | grep -w -v "Starting Nmap 7.70" | grep -w -v "Warning:" |sed "s/Service detection performed. Please report any incorrect results at https:\/\/nmap.org\/submit\/ .//g;s/Nmap scan report for /ჰოსტის სახელი: /g" | grep -w -v Host | grep -w -v "Not shown" | grep -w -v "Nmap done: 1 IP address" | sed "s/vulners:/მორგებადი ექსპლოიტები:/g;s/ open / გახსნილი /g;s/PORT/პორტი/g;s/STATE/სტატუსი/g;s/SERVICE/პროტოკოლი/g;s/VERSION/ვერსია/g;s/|//g;s/_/ /g;s/https:\/\/vulners.com\/cve\//https:\/\/cxsecurity.com\/cveshow\//g" | grep "CVE" | uniq | sort | sed 's/\t/ /g') ]]; then
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${mwv}[${yvt}Pwn1n6${yvt}]:${blank} მორგებადი ექსპლოიტები ნაპოვნია.. მიმდინარეობს ტესტირება და იდენტიპიკაცია..."
nmap --script nmap-vulners -sV -T5 ${ip} | grep -w -v "Starting Nmap 7.70" | grep -w -v "Warning:" |sed "s/Service detection performed. Please report any incorrect results at https:\/\/nmap.org\/submit\/ .//g;s/Nmap scan report for /ჰოსტის სახელი: /g" | grep -w -v Host | grep -w -v "Not shown" | grep -w -v "Nmap done: 1 IP address" | sed "s/vulners:/მორგებადი ექსპლოიტები:/g;s/ open / გახსნილი /g;s/PORT/პორტი/g;s/STATE/სტატუსი/g;s/SERVICE/პროტოკოლი/g;s/VERSION/ვერსია/g;s/|//g;s/_/ /g;s/https:\/\/vulners.com\/cve\//https:\/\/cxsecurity.com\/cveshow\//g" | grep "CVE" | uniq | sort | sed 's/\t/ /g'
else
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${wtl}[!]: ექსპლოიტები ვერ მოიძებნა"
fi

}

#}
################################################################


ctrl
#echo -ne "$yvt[$wtl$title$yvt]@[$wtl$app$yvt]=>$blank "
#read url
echo -e "${mwv}[+] მიმდინარეობს (${ttr}${ip_domain}${mwv}) საიტის სკანირება..."
echo ""
ctrl
#პროტოკოლის ჩეკერი
if [[ -z $ip_domain ]]
then
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${mwv}[ინფო]:${yvt} გაუწერეთ  სასურველი საიტის ბმული"
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} ${mwv}[ინფო]:${yvt} მაგ.: ${mwv}http(${wtl}s${mwv})://url.domain$blank $yvt($wtlაუცილებლად გაუწერეთ პროტოკოლი$yvt)$blank"

exit
elif [[ -z $(echo "$ip_domain" | grep ^"\(http\|https\)://") ]]
then
echo -e "${ttr}[${wtl}$(date '+%H:%M:%S')${ttr}]${blank} $wtl[!] გაუწერეთ პროტოკოლი ($ttr$ip_domain$wtl) [${mwv}HTTP/HTTPS$wtl] ან წაუშალეთ ბოლოში (${ttr}სლეში${wtl}) სამაგალითოდ: (${ttr}http://site.ge${wtl})"
exit
fi
checking
robots
git
cve
crawltype

#runningspidermenu
#noob
sqli
#xss
}
webscan() {
running=$(scanning)
}
iprange(){
running=$(if [[ $host =~ ^([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.([0-9]{1,2}|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$ ]]; then for i in {1..254} ;do (ping ${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}.$i -c 1 -w 5  >/dev/null && echo "${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}.$i" &) ;done; else     echo "$wtl[-] დიაპაზონს ვერ დაასკანირებთ სანამ აიპ მისამართს არ დაამატებთ!"; fi)
echo -e "$mwv[+] დაემატა მოდული"
}
vuln(){
running=$(nmap --script nmap-vulners -sV -T5 ${host} | grep -w -v "Starting Nmap 7.70" | grep -w -v "Warning:" |sed "s/Service detection performed. Please report any incorrect results at https:\/\/nmap.org\/submit\/ .//g;s/Nmap scan report for /ჰოსტის სახელი: /g" | grep -w -v Host | grep -w -v "Not shown" | grep -w -v "Nmap done: 1 IP address" | sed "s/vulners:/მორგებადი ექსპლოიტები:/g;s/ open / გახსნილი /g;s/PORT/პორტი/g;s/STATE/სტატუსი/g;s/SERVICE/პროტოკოლი/g;s/VERSION/ვერსია/g;s/|//g;s/_/ /g;s/https:\/\/vulners.com\/cve\//https:\/\/cxsecurity.com\/cveshow\//g" | grep "CVE" | uniq | sort | sed 's/\t/ /g')
echo -e "$mwv[+] დაემატა მოდული"
}
subdomain(){
running=$(dmitry -s $url | awk -F/ '{print $2}' | awk "/Google/"> /dev/null 2>&1 ; png="$?" ; if [ $png == "0" ] ; then dmitry -s $url | sed "s/HostName://g;s/$url/$url<\/br>/g;s/ERROR: Unable to locate Host IP addr. for -s/თქვენ უკვე სკანირების ლიმიტს გადააცილეთ,/g;s/Continuing with limited modules/სცადეთ მოგვიანებით./g;/^$/d" | grep -w -v -e "-s" -e "HostIP" -e "All" -e "Gathered Subdomain information for" -e "Deepmagic" -e "\"There" -e "---------------------------------" -e " Gathered" -e "Searching" -e "Found" -e "Searched" | sed '/^$/d' | sed 's/HostName:$url//g' ; elif [ $png == "1" ] ; then echo -e $yvt "ქვე-დომეინი ვერ მოიძებნა" ; elif [ $png == "2" ] ; then echo -e $wtl "წარმოიქმნა გაუთვალისწინებელი შეცდომა"; fi)
echo -e "$mwv[+] დაემატა მოდული"
}
crimeflare() {
curl "https://raw.githubusercontent.com/r00tk17/crimeflare/master/[1-6]" -s > cloudflare
running=$(cat cloudflare | grep $(${url}))
echo -e "$mwv[+] დაემატა მოდული"
}
portscan(){
running=$(nmap $host --open -oG - | grep -w -v -e "#" | awk '/open/{ s = ""; for (i = 5; i <= NF-4; i++) s = s substr($i,1,length($i)-4) "\n"; print $2 " " $3 "\n" s}' | grep -w -v "${host}" | sed "s/\// > /g;s/>  >/>/g" | awk -F ',' '{ printf "[%s]",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16;print ""}' | sed 's/\[]//g;s/open/გახსნილია/g') 
echo -e "$mwv[+] დაემატა მოდული"
}
run() {
echo "$running"
}
howto(){
clear
echo -e "
                            $blank▄▄▄▄▄▄▄▄
                      $wtl█$blank   ▄██████████▄
                     $wtl█▐$blank   ████████████
                     $wtl▌$blank▐  ██▀▀██████▀▀██
                    $wtl▐$blank┼▐  ██  $wtl▄$blank ██ $wtl▄$blank  ██
                    $wtl▐┼$blank▐  ██████████████
                    ▐▄▐████ ▀$wtl▐$blank▐▀█ █ $wtl▌$blank▐██▄ 
                      █████          ▐███▌
                      █▀▀██▄$wtl█$blank ▄   $wtl▐$blank ▄███▀ 
                      █  ███████▄██████ 
                         ██████████████
                         █████████▐▌██▌
                         $wtl▐▀$blank▐ ▌▀█▀ $wtl▐$blank █
                               $wtl▐$blank    $wtl▌$blank 
     $wtl       ___  _____        ____ _____   _____  ___       $blank
     $wtl|___/ |___|   |   |____| ____ |    \ |____/ |___| |    $blank
     $wtl|   \ |   |   |   |    | ____ |____/ |   \_ |   | |____$blank
     
   $mwv[$wtl---------------------------------------------------------$mwv]$blank
   $mwv[$wtl---$mwv]$wtl                   $mwv Kathedral$wtl v2                 $mwv[$wtl---$mwv]$blank 
   $mwv[$wtl---$mwv]$wtl                $mwv კოდერი:$wtl Pwn3Xpert               $mwv[$wtl---$mwv]$blank
   $mwv[$wtl---$mwv]$wtl   $mwv შექმნილია „კიბერ უსაფრთხოების ჯგუფის“ მიერ$wtl   $mwv[$wtl---$mwv]$blank
   $mwv[$wtl---------------------------------------------------------$mwv]$blank
   $mwv[$wtl---$mwv]$wtl          (${ttr}1${wtl}) ${mwv}საიტის სკანირება${wtl}                   $mwv[$wtl---$mwv]$blank 
   $mwv[$wtl---$mwv]$wtl          (${ttr}2${wtl}) ${mwv}პორტის სკანირება${wtl}                   $mwv[$wtl---$mwv]$blank 
   $mwv[$wtl---$mwv]$wtl          (${ttr}3${wtl}) ${mwv}აიპი-დიაპაზონის სკანირება${wtl}          $mwv[$wtl---$mwv]$blank 
   $mwv[$wtl---$mwv]$wtl          (${ttr}4${wtl}) ${mwv}ექსპლოიტების ძებნა${wtl}                 $mwv[$wtl---$mwv]$blank 
   $mwv[$wtl---$mwv]$wtl          (${ttr}5${wtl}) ${mwv}ქვე-დომეინების სკანირება${wtl}           $mwv[$wtl---$mwv]$blank 
   $mwv[$wtl---$mwv]$wtl          (${ttr}6${wtl}) ${mwv}ნომრის ძებნა${wtl}                       $mwv[$wtl---$mwv]$blank 
   $mwv[$wtl---------------------------------------------------------$mwv]$blank
   "
echo -ne "$yvt[$wtl$title$yvt]@[${wtl}ნავიგაცია${yvt}]=>$blank "
read navigation
case $navigation in
1) asciinema play https://asciinema.org/a/8pGNf2HbUZCPr36cyaaQElxHt ;;
2) asciinema play https://asciinema.org/a/xw589brZj3Rd8XHAllXDBXnSs ;;
3) asciinema play https://asciinema.org/a/ORobpViCt4ZeVE4Kt7AKO1mwp ;;
4) asciinema play https://asciinema.org/a/SW8dKqhvyt7dgy55YeSvLjzEN;;
5) ;;
6) ;;
esac
}
args="$ip_domain"
cmd='curl -s "http://api.hackertarget.com/reverseiplookup/?q=$args" | egrep -o "[a-z]+\.[a-z]+$" | awk "NR==2 {print; exit}"'
ipcmd="dig +short $args"
url="$(eval $cmd)"
host="$(eval $ipcmd)"

banner
    while /bin/true
        do
            echo -ne "$yvt[$wtl$title$yvt]@[$wtl$who$yvt]=>$blank " ;tput sgr0 ;read cnt_1 cnt_2 cnt_3
            if   [[ $cnt_1 == "help" ]];then
                help
            elif [[ $cnt_1 == "howto" ]];then
                howto
            elif [[ $cnt_1 == "clear" ]] || [[ $cnt_1 == "cls" ]] || [[ $cnt_1 == "c" ]];then
                clear
            elif [[ $cnt_1 == "set" ]] && [[ $cnt_2 == "ip" ]];then
                host
            elif [[ $cnt_1 == "set" ]] && [[ $cnt_2 == "url" ]];then
                domain
            elif [[ $cnt_1 == "set" ]] && [[ $cnt_2 == "number" ]];then
                number
            elif [[ $cnt_1 == "set" ]];then
                set_module
            elif [[ $cnt_1 == "set" ]] && [[ $cnt_2 == $cnt_2 ]];then
                param
            elif [[ $cnt_1 == "scan" ]];then
                scan
            elif [[ $cnt_1 == "run" ]];then
                run 
            elif [[ $cnt_1 == "show" ]];then
                modules
            elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == "pentest" ]] && [[ $cnt_3 == "webscan" ]];then
                scanning
            elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == "pentest" ]] && [[ $cnt_3 == "iprange" ]];then
                iprange
            elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == "pentest" ]] && [[ $cnt_3 == "vuln" ]];then
                vuln
            elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == "pentest" ]] && [[ $cnt_3 == "subdomain" ]];then
                subdomain
            #elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == "pentest" ]] && [[ $cnt_3 == "cloudflare" ]];then
            #    crimeflare
            elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == "pentest" ]] && [[ $cnt_3 == "portscan" ]];then
                portscan
            elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == "pentest" ]];then
                paramw
            elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == "pentest" ]] && [[ $cnt_3 == $cnt_3 ]];then
                paramw
            elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == "database" ]];then
                paramd
            elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == "database" ]] && [[ $cnt_3 == $cnt_3 ]];then
                paramd
            elif [[ $cnt_1 == "use" ]] && [[ $cnt_2 == $cnt_2 ]];then
                param
            elif [[ $cnt_1 == "use" ]];then
                modules     
            elif [[ $cnt_1 == "exit" ]];then 
                exit
            else
                oops
            fi
            #unset ip_addr
        done
        }
engine

}
function Kweb_ui() {
echo ""
echo " ||   /            ||    '||                ||                 '||" 
echo " ||  /             ||     ||                ||                  ||  "
echo " ||<<     '''|.  ''||''   ||''|, .|''|, .|''||  '||''|  '''|.   ||  "
echo " ||  \   .|''||    ||     ||  || ||..|| ||  ||   ||    .|''||   ||  "
echo ".||   \  ||..||.   ||..' .||  || ||...  ||..||. .||.   ||..||. .||. "
echo ""
echo "            Kathedral We{B}ash Interface Coded By Pwn3Xpert"
echo ""
echo -e "${yvt}[*] მიმდინარეობს სერვერთან კავშირის გადამოწმება"
echo -e "${mwv}[+] სერვერთან კავშირი წარმატებით დამყარდა."
echo -e "${mwv}[+] შენი ტუნელირებადი აიპია: ${wtl}$myip"
echo -e "${mwv}[+] მისამართი: ${wtl}http://127.0.0.1:$PORT"
}
Cronos() {
anonymousing() {
if [[ $(systemctl status tor | grep "Active: active") ]]; then
echo -e "${mwv}ანონიმურობა დაცულია  "
else
echo -e "${blink_start}$wtlანონიმურობა დაუცველია${blink_stop}"
fi
}

ctrl(){
trap ctrl_c INT
ctrl_c() {
echo -e $wtl"
[*] დაფიქსირდა კლავიატურაზე (Ctrl + C), ნამდვილად გსურთ კათედრალის გათიშვა? დააჭირე კლავიატურაზე (Ctrl + Z)-ს"
rm spider.tmp
exit
}
}
tmp="spider.tmp"
title="Kathedral"
app="Cron0s"
null="/dev/null"
randomagent="Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0"
echo > spider.tmp
bold=$(tput bold)
norm=$(tput sgr0)
mwv="\e[1;92m"
wtl="\e[1;91m"
lrj="\e[1;34m"
ncr="\e[1;37m"
yvt="\e[1;93m"
ism="\e[1;95m"
ttr="\e[1;97m"
blank="\e[1;39m"
fs="\e[1;96m"

blink_start="\033[1;5m"
blink_stop="\033[0m"
loading(){
    bar="===================================="
    barlength=${#bar}
    i=0
    while ((i < 100)); do
        n=$((i*barlength / 100))
        printf "\e[00;32m\r[%-${barlength}s]\e[00m" "${bar:0:n}"
        ((i += RANDOM%5+2))
  sleep 0.1
    done
    echo -e ""
}
#ბაგები და შეცდომები
function kathbugcontactauthor() {
echo -e "$mwv[${wtl}BUG$mwv]:$wtl ვერ მოხდა საიტის სტრუქტურის შესწავლა.. (${ttr}KathBUG-011${wtl})"
echo -e "$mwv[${wtl}საიტი$mwv]:$wtl >>> (${ttr}https://kathedral.cybsecgroup.com${wtl}) <<< ${mwv}#გაწერე$wtl [CSG@WebTerm]=> ${mwv}cat kathbug"
echo -e "$mwv[${wtl}ინფო$mwv]:$wtl ეწვიეთ ოფიციალურ საიტს და მოძებნე კოდი: (${ttr}KathBUG-011${wtl}) და გაიგე მისი მნიშვნელობა"
echo -e "$wtlმიმდინარეობს ავარიული გათიშვა"
exit
}
#კავშირგაბმულობა
function checking() {
echo -e "${mwv}[$yvtმოწმდება$mwv]: მიმდინარეობს კავშირის დამყარება ($ttr${url}$mwv)-საიტზე$blank"
checker=`echo "${url}" | sed 's/http:\/\///g;s/https:\/\///g'`
ip=`dig +short ${checker}`
if [[  ! -z $(dig +short ${checker}) ]]
then
echo -e "${wtl}$bold[$ttr+$wtl]$mwv: კავშირი წარმატებით დამყარდა საიტთან. ($ttr${url}$mwv)$blank$norm"
echo -e "${wtl}$bold[$ttr+$wtl]$mwv: მისამართი: (${wtl}${ip}${mwv})$norm"
else
checker=`echo "${url}" | sed 's/http:\/\///g;s/https:\/\///g'`
if [[  ! -z $(curl "http://http://api.hackertarget.com//reversedns/?q=${checker}" -H "$randomagent") ]]
then
echo -e "${wtl}$bold[$ttr+$wtl]$mwv: კავშირი წარმატებით დამყარდა საიტთან. ($ttr${url}$mwv)$blank"
else
echo -e "${yvt}[${wtl}WhyRuGay?${yvt}]: მსგავსი ტიპის  დომეინი არ არსებობს !${blank}"
exit
fi
fi
}
#ობობები
quick_crawl() {
  echo -e "${wtl}                         /\\\

                    ____/ /
     _             / ___ \\\\\\
     \\\\\\_!_________(_/_/ \ \\\\\\
     <#|=====|______ / /__/
    / C|=====|---' \__/
   /   |-|-|~
  /    /---'
 /    /
|_____|
"
echo -e "$mwv[${wtl}n00b$mwv]:$mwv თქვენ აირჩიეთ სწრაფი რეჟიმი.. ${blink_start}${wtl}ალბათ ითვალისწინებთ იმ ფაქტსაც რომ შესაძლოა ობობას გამორჩეს მნიშვნელოვანი ბმულები...${blink_stop}$blank"
echo -e "$mwv[$yvtინფო$mwv]:$mwv მიმდინარეობს ბმულების ძიება შესაძლოა ამას დასჭირდეს რამოდენიმე წუთიც...$blank"
echo -e "$mwv[$yvtინფო$mwv]:$mwv გთხოვთ დაელოდოთ, მიმდინარეობს სტრუქტურის ზედაპირული შესწალა...$blank"
curl "http://web.archive.org/cdx/search/cdx?url=${url}/*&output=json&collapse=urlkey&fl=original" -s  -H "$randomagent" | sed "s/\[\"//g;s/]//g;s/\"//g;s/,//g" | grep "http" >> ${tmp}
echo -e "${wtl}[$ttr+$wtl]$mwv: სკანირება დასრულდა."
}
subdomain_crawl() {
  echo -e "${wtl} 
   ____________ _________________ 
  /_   \_____  \\\\\\_____  \______  \\\\
   |   | _(__  <  _(__  <   /    /
   |   |/       \/       \ /    / 
   |___/______  /______  //____/  
              \/       \/ 
${lrj}00110001 00110011 00110011 00110111 
       ${ytv}0x49 0x51 0x51 0x55 
                     "
echo -e "$mwv[${wtl}1337$mwv]:$mwv მიმდინარეობს ბმულების ძიება შესაძლოა ამას დასჭირდეს რამოდენიმე წუთიც...$blank"
echo -e "$mwv[$yvtინფო$mwv]:$mwv გთხოვთ დაელოდოთ, მიმდინარეობს სტრუქტურის ზედაპირული შესწალა...$blank"
for urlist in $(curl -s "https://otx.alienvault.com/api/v1/indicators/hostname/${url}/passive_dns" -H "$randomagent" | sed "s/,/\n/g" | grep "\"hostname\":" | sed 's/"hostname"://g;s/"//g;s/ //g')
do
curl "http://web.archive.org/cdx/search/cdx?url=${urlist}/*&output=json&collapse=urlkey&fl=original" -s -H "$randomagent" | sed "s/\[\"//g;s/]//g;s/\"//g;s/,//g" | grep "http" >> ${tmp}
done
echo -e "${wtl}[$ttr+$wtl]$mwv: სკანირება დასრულდა."
}
subhost_crawl() {
echo -e "${wtl}       _______ _____         ______ ______       
      |   |   |  |  |.--.--.|      |      |.----.
      |       |__    |_   _||  --  |  --  ||   _|
      |___|___|  |__||__.__||______|______||__|
${lrj}01001000 00110100 01111000 00110000 00110000 01110010 
           ${yvt}0x72 0x52 0x120 0x48 0x48 0x114 
                                     "
echo -e "$mwv[${wtl}H4X00R$mwv]:$mwv მიმდინარეობს ამავე ჰოსტზე განთავსებული ყველა ქვე-დომეინის ძიება შესაძლოა ამას დასჭირდეს რამოდენიმე წუთიც...$blank"
echo -e "$mwv[$yvtინფო$mwv]:$mwv გთხოვთ დაელოდოთ.$blank"
for urlist in $(curl -s "https://otx.alienvault.com/api/v1/indicators/hostname/${ip}/passive_dns" -H "$randomagent" | sed "s/,/\n/g" | grep "\"hostname\":" | sed 's/"hostname"://g;s/"//g;s/ //g')
do
curl "http://web.archive.org/cdx/search/cdx?url=${urlist}/*&output=json&collapse=urlkey&fl=original" -s -H "$randomagent"| sed "s/\[\"//g;s/]//g;s/\"//g;s/,//g" | grep "http" >> ${tmp}
done
echo -e "${wtl}[$ttr+$wtl]$mwv: სკანირება დასრულდა."

}
everything_crawl() {
echo -e "${wtl}
       ______ ___ ___                    __   
      |__    |   |   |.-----.-----.----.|  |_ 
      |__    |-     -||  _  |  -__|   _||   _|
      |______|___|___||   __|_____|__|  |____|
                      |__|                    
${lrj}00110011 01011000 01110000 01100101 01110010 01110100 
          ${yvt}0x51 0x88 0x112 0x101 0x114 0x116 "


echo -e "$mwv[${wtl}3Xpert$mwv]:$mwv მიმდინარეობს ამავე ჰოსტზე განთავსებული ყველა ქვე-დომეინის ძიება შესაძლოა ამას დასჭირდეს რამოდენიმე წუთიც...$blank"
echo -e "$mwv[$yvtინფო$mwv]:$mwv გთხოვთ დაელოდოთ.$blank"
for urlist in $(curl -s "https://api.hackertarget.com/reverseiplookup/?q=${ip}" -H "$randomagent")
do
curl "http://web.archive.org/cdx/search/cdx?url=${urlist}/*&output=json&collapse=urlkey&fl=original" -s -H "$randomagent" | sed "s/\[\"//g;s/]//g;s/\"//g;s/,//g" | grep "http"  >> ${tmp}
done

echo -e "${wtl}[$ttr+$wtl]$mwv: სკანირება დასრულდა."
}
function transformation() {
echo -e "$mwv[$yvtინფო$mwv]:$mwv მიმდინარეობს ბმულების გადახარისხება."
cat $tmp | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*" | sort | uniq | grep -w -v -e "#" -e "data" -e "javascript" -e "tel" -e "mailto" -e "eot" -e "jpg" -e "js" -e "svg" -e "ttf" -e "woff" -e "css" > metadata.tmp
echo -e "${wtl}$bold[$ttr+$wtl]$mwv: ბმულები გადახარისხებულია."
}
#ობობის ფუნქციონალი
crawltype() {
echo -e "$mwv[$yvtინფო$mwv]:$ttr აირჩიეთ სკანირების ტიპი.$norm
${wtl}(${ttr}1${wtl}) ${wtl}[${ttr}n00b${wtl}]   ${ncr}დასკანირდეს მხოლოდ ჩემს მიერ მითითებული ბმული. ${wtl}*${mwv}
${wtl}(${ttr}2${wtl}) ${wtl}[${ttr}1337${wtl}]   ${ncr}დასკანირდეს ყველა ქვე-დომეინი.
${wtl}(${ttr}3${wtl}) ${wtl}[${ttr}H4X00R${wtl}] ${ncr}დასკანირდეს ამავე ჰოსტზე განთავსებული ყველა ქვე-დომეინი.
${wtl}(${ttr}4${wtl}) ${wtl}[${ttr}3Xpert${wtl}] ${ncr}დასკანირდეს ამავე ჰოსტზე განთავსებული ყველა საიტი."
echo -ne "$mwv(${ttr}1/4${mwv})>$blank "
read scantype
case $scantype in
1) quick_crawl;; #noob
2) subdomain_crawl;; #leet
3) subhost_crawl;; #haxoor
4) everything_crawl;; #expert
*) quick_crawl;; #default_noob
esac
}

function robots() {
if [[  ! -z $(curl -sLI "${url}/robots.txt" -H "$randomagent" | grep -e "text/plain" -e "Content-Type: text/plain" -e "content-type: text/plain") ]]
then
echo -e "${wtl}$bold[$ttr+$wtl]$mwv: ნაპოვნია ($ttr${url}/robots.txt$mwv)$blank"
else
echo -e "${wtl}$bold[$ttr-$wtl]$mwv: ($ttr${url}/robots.txt$wtl) ვერ იპოვნა$blank"
fi
}
starting() {
  checking
  robots
  crawltype
  transformation
  SQL_Injection
}
clear

#შეღწევადობაზე ტესტირება
function SQL_Injection(){
tamper=( "%27" "\/" "~" "$" )
  echo -e "
 $wtl ______  _____        $mwv _ _  _  _ ____ ____ ___ _ ____ _  _
 $wtl|______ |     | |      $mwv| |\ |  | |___ |     |  | |  | |\ |
 $wtl _____| |____\| |_____ $mwv| | \| _| |___ |___  |  | |__| | \|
               $wtl\ 
"
echo -e "$mwv[$yvtინფო$mwv]:$yvt მიმდინარეობს SQL ინექციაზე ბმულების ტესტირება შესაძლოა ამას დასჭირდეს რამოდენიმე წამი..."
tmp="metadata.tmp"
diff=$(awk '!a[$0]++' ${tmp} | uniq | grep -w -v -i -e "jpg" -e "css" -e "js" | sed 's/\/\//\//g')
tester=$(echo "$diff" | grep '?' )
for (( i = 0; i < ${#tamper[@]}; ++i )); do
for sqlinj in $(echo "$tester" | sort | uniq | sed "s/=\([a-zA-Z0-9]*\)$/=\1${tamper[i]}/g" ); do
curl -skL --connect-timeout 5 --max-time 5 -H "$randomagent" "${sqlinj}" | grep 'Warning' > /dev/null
echo -e "$mwv[$wtlკრიტიკული$mwv]: SQLi ინექცირებადი ბმული ($ttr${sqlinj}$mwv) ფეილოადი ($wtl${tamper[i]}$mwv)$blank"
done
done
}
echo -e "$blink_start
           ${mwv}█████${wtl}╗${mwv} ██████${wtl}╗${mwv}  █████${wtl}╗${mwv} ███${wtl}╗${mwv}  ██${wtl}╗${mwv} █████${wtl}╗${mwv}  ██████${wtl}╗
          ${mwv}██${wtl}╔══${mwv}██${wtl}╗${mwv}██${wtl}╔══${mwv}██${wtl}╗${mwv}██${wtl}╔══${mwv}██${wtl}╗${mwv}████${wtl}╗ ${mwv}██${wtl}║${mwv}██${wtl}╔══${mwv}██${wtl}╗${mwv}██${wtl}╔════╝
          ${mwv}██${wtl}║  ${mwv}${wtl}╚═╝${mwv}██████${wtl}╔╝${mwv}██${wtl}║  ${mwv}██${wtl}║${mwv}██${wtl}╔${mwv}██${wtl}╗${mwv}██${wtl}║${mwv}██${wtl}║${mwv}  ██${wtl}║╚${mwv}█████${wtl}╗ 
          ${mwv}██${wtl}║  ${mwv}██${wtl}╗${mwv}██${wtl}╔══${mwv}██${wtl}╗${mwv}██${wtl}║  ${mwv}██${wtl}║${mwv}██${wtl}║╚${mwv}████${wtl}║${mwv}██${wtl}║${mwv}  ██${wtl}║${mwv} ${wtl}╚═══${mwv}██${wtl}╗
          ${wtl}╚${mwv}█████${wtl}╔╝${mwv}██${wtl}║  ${mwv}██${wtl}║╚${mwv}█████${wtl}╔╝${mwv}██${wtl}║${mwv} ${wtl}╚${mwv}███${wtl}║╚${mwv}█████${wtl}╔╝${mwv}██████${wtl}╔╝
           ${wtl}╚════╝ ╚═╝  ╚═╝ ╚════╝ ╚═╝  ╚══╝ ╚════╝ ╚═════╝$blink_stop"

echo ""
echo -e " $mwv[$wtl-------------------------------------------------------------$mwv]$blank"
echo -e " $mwv[$wtl---$mwv]$wtl      ${mwv}Cron0s Web-Vuln-Scanner With Kathedral         $mwv[$wtl---$mwv]$blank"
echo -e " $mwv[$wtl---$mwv]$wtl                 $mwv კოდერი:$wtl Pwn3Xpert                  $mwv[$wtl---$mwv]$blank"
echo -e " $mwv[$wtl---$mwv]$wtl    $mwv შექმნილია „კიბერ უსაფრთხოების ჯგუფის“ მიერ$wtl      $mwv[$wtl---$mwv]$blank"
echo -e " $mwv[$wtl-------------------------------------------------------------$mwv]$blank"
echo -e " $mwv[$wtl---$mwv]               $(anonymousing)                 $mwv[$wtl---$mwv]$blank"
echo -e " $mwv[$wtl-------------------------------------------------------------$mwv]$blank"

echo ""
echo -e " $wtlტესტირების ბმულები:"
echo "               (SQLi)==> testphp.vulnweb.com"
echo "               (XSS)===> xss-game.appspot.com"
ctrl
echo -ne "$yvt[$wtl$title$yvt]@[$wtl$app$yvt]=$wtl($ttrმიუთითე ბმული$wtl)$yvt=>$blank "
read url
starting
}

multihopproxy() {
#!/bin/bash
mwv="\e[92m"
wtl="\e[91m"
lrj="\e[34m"
ttr="\e[30m"
yvt="\e[93m"
blank="\e[39m"
app=$0
torrange="192.168.0.0/16 172.16.0.0/12 10.0.0.0/8"
startup=$(echo "$(pwd)/${app}" | sed 's/\/.\//\//g')
echo -e "
$mwv _______               ${wtl}__  $mwv __  __         __   __             __              __ ${blank}
$mwv|_     _|.-----.----.${wtl}_|  |_$mwv|  |/  |.---.-.|  |_|  |--.-----.--|  |.----.---.-.|  |${blank}
$mwv  |   |  |  _  |   _${wtl}|_    _|$mwv     < |  _  ||   _|     |  -__|  _  ||   _|  _  ||  |${blank}
$mwv  |___|  |_____|__|   ${wtl}|__| $mwv|__|\__||___._||____|__|__|_____|_____||__| |___._||__|${blank}

                                ${ttr}███████ ${blank}   
                            ${ttr}▄▄▄▄███████▄▄▄▄${blank}
                               ▐░▀░▀░▀░▌ 
                               ${wtl}▐▄▄▄▄▄▄▄▌${blank}
                         ▄▀▀▀█▒▐░${wtl}▀▀${blank}▄${wtl}▀▀${blank}░▌▒█▀▀▀▄
                         ▌▌▌▌▐▒▄▌░▄▄▄░▐▄▒▌▐▐▐▐
        ${mwv}0x54 0x6F 0x72 ${wtl}[0x2B]$mwv 0x4B 0x61 0x74 0x68 0x65 0x64 0x72 0x61 0x6C${blank} 
        
        $mwv[${wtl}----------------------------------------------------------------$mwv]${blank}  
        $mwv[${wtl}---$mwv]        პროდუქტი წარმოადგენს ${wtl}Kathedral$mwv-ის საკუთრებას    [${wtl}---$mwv]${blank}
        $mwv[${wtl}---$mwv]                 პროექტის ავტორი: Pwn${wtl}3Xpert$mwv             [${wtl}---$mwv]${blank}
        $mwv[${wtl}----------------------------------------------------------------$mwv]${blank}

        $mwv[${yvt}ინფო$mwv]: ${yvt}ნავიგაციის სანახავად გაწერეთ: 

${mwv}-_*${mwv}/${wtl}Kathopia${mwv}/>${wtl}# ${mwv}$0 ${wtl}-h ${mwv}ან ${wtl}--help${blank}"


if [[ ! -z `dpkg -l |grep resolvconf` ]]; then 
    resolvconf_support=true;
else
    resolvconf_support=false;
fi
install() {
if [[ -n $(cat /etc/os-release | grep "kali") ]]
then
    echo "მიმდინარეობს ინსტალაცია გთხოვთ დაიცადოთ..."
    apt  install --force-yes secure-delete tor libecj-java libservlet3.0-java libgetopt-java libservlet3.0-java glassfish-javaee ttf-dejavu libjbigi-jni > /dev/null 2>&1
    wget http://ftp.us.debian.org/debian/pool/main/j/jetty8/libjetty8-java_8.1.16-4_all.deb > /dev/null 2>&1
    dpkg -i libjetty8-java_8.1.16-4_all.deb > /dev/null 2>&1
    apt install -f > /dev/null 2>&1
fi
}
startup() {
read -p "გსურთ დაემატოს სტარტაპში რათა სისტემის ჩატვირთვისთანავე ავტომატურად ჩაიტვირთოს kathopia? მაშინ დააჭირეთ (Y/y)-ს ხოლო თუ გსურთ ამოშალოთ მაშინ დააჭირეთ (N/n)-ს" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
cp {startup} /etc/init.d
fi
}
clearlog() {
       echo -e $yvt "[${wtl}!$yvt]: $wtlმიმდინარეობს ქეშების დასუფთავება. შესაძლოა ამას დასჭირდეს რამოდენიმე წუთი"
       sleep 5
       rm /var/log/auth.log
       truncate -s 0 /var/log/auth.log
       echo '' > /var/log/auth.log
       shred /var/log/auth.log
       rm -rf ~/.BurpSuite
       rm -rf ~/.ssh
       ln /dev/null /var/log/auth.log -sf
       shred -zu /var/log/auth.log
       echo "" > ~/.bash_history
       echo 0  > /proc/sys/vm/oom_dump_tasks
       echo 1  > /proc/sys/vm/oom_kill_allocating_task
       echo 1  > /proc/sys/vm/overcommit_memory
       echo 3  > /proc/sys/vm/drop_caches
       echo 1024 > /proc/sys/vm/min_free_kbytes
       echo '' > /var/log/messages 
       echo '' > /var/log/auth.log 
       echo '' > /var/log/kern.log 
       echo '' > /var/log/cron.log 
       echo '' > /var/log/maillog 
       echo '' > /var/log/boot.log 
       echo '' > /var/log/mysqld.log 
       echo '' > /var/log/qmail 
       echo '' > /var/log/httpd 
       echo '' > /var/log/lighttpd 
       echo '' > /var/log/secure 
       echo '' > /var/log/utmp 
       echo '' > /var/log/wtmp 
       echo '' > /var/log/yum.log
       echo '' > /var/log/system.log 
       echo '' > /var/log/DiagnosticMessages
       echo '' > /Library/Logs 
       echo '' > /Library/Logs/DiagnosticReports
       echo '' > ~/Library/Logs 
       echo '' > ~/Library/Logs/DiagnosticReports
       shred -zu /var/log/messages
       shred -zu /var/log/auth.log 
       shred -zu /var/log/kern.log 
       shred -zu /var/log/cron.log 
       shred -zu /var/log/maillog
       shred -zu /var/log/boot.log 
       shred -zu /var/log/mysqld.log 
       shred -zu /var/log/qmail 
       shred -zu /var/log/httpd 
       shred -zu /var/log/lighttpd 
       shred -zu /var/log/secure
       shred -zu /var/log/utmp
       shred -zu /var/log/wtmp
       shred -zu /var/log/system.log
       shred -zu /var/log/DiagnosticMessages 
       shred -zu /Library/Logs
       shred -zu /Library/Logs/DiagnosticReports
       shred -zu ~/Library/Logs 
       shred -zu ~/Library/Logs/DiagnosticReports 
       sdmem -fllv
       killall -q chrome dropbox iceweasel skype icedove thunderbird firefox chromium xchat transmission deluge pidgin pidgin.orig
       bleachbit -c adobe_reader.cache chromium.cache chromium.current_session chromium.history elinks.history emesene.cache epiphany.cache firefox.url_history flash.cache flash.cookies google_chrome.cache google_chrome.history  links2.history opera.cache opera.search_history opera.url_history &> /dev/null
}
ip() {
myip=$(curl -s "ifconfig.me")
echo -e " ${mwv}[${wtl}+$mwv]: შენი ტუნელირებადი აიპია: ${wtl}${myip}${blank}" 
}

activation() {
    if [ $(id -u) -ne 0 ]; then
        exit 1
    fi
    grep -q -x 'RUN_DAEMON="yes"' /etc/default/tor
    if [ $? -ne 0 ]; then
        echo "მიმდინარეობს TOR-ის კონფიგურირება დასრულების შემდეგ ხელახლა ჩატვირთეთ აპლიკაცია..."
        service tor restart
        exit 1
    fi  
    echo -e "$yvt [${wtl}*$yvt]: თქვენი რეალური აიპი მისამართი შეცვლილია "
    sed -i '/^.*\#Kathopia Has HERE$/d' /etc/sysctl.conf
    echo "net.ipv6.conf.all.disable_ipv6 = 1 #Kathopia Has HERE" >> /etc/sysctl.conf
    echo "net.ipv6.conf.default.disable_ipv6=1 #Kathopia Has HERE" >> /etc/sysctl.conf
    sysctl -p > /dev/null
    if [ ! -e /var/run/tor/tor.pid ]; then
        service network-manager force-reload > /dev/null 2>&1
        killall dnsmasq > /dev/null 2>&1
        killall nscd > /dev/null 2>&1   
        service tor start
        sleep 1
    fi
    if ! [ -f /etc/network/iptables.rules ]; then
        iptables-save > /etc/network/iptables.rules
    fi
    
    iptables -F
    iptables -t nat -F
    
    if [ "$resolvconf_support" = false ] 
    then
        cp /etc/resolv.conf /etc/resolv.conf.bak
        touch /etc/resolv.conf
        echo -e 'nameserver 127.0.0.1\nnameserver 209.222.18.222\nnameserver 209.222.18.218' > /etc/resolv.conf
    else
        cp /etc/resolvconf/resolv.conf.d/head{,.bak}
        echo -e 'nameserver 127.0.0.1\nnameserver 209.222.18.222\nnameserver 209.222.18.218' >> /etc/resolvconf/resolv.conf.d/head
        resolvconf -u
    fi
    echo -e "$yvt [${wtl}*$yvt]: თქვენს ანონიმურობაზე ზრუნავს ${wtl}TOR${yvt}-ი!";

    iptables -t nat -A OUTPUT -m owner --uid-owner debian-tor -j RETURN
    iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 53
    iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 53
    iptables -t nat -A OUTPUT -p udp -m owner --uid-owner debian-tor -m udp --dport 53 -j REDIRECT --to-ports 53
    iptables -t nat -A OUTPUT -p tcp -d 10.192.0.0/10 -j REDIRECT --to-ports 9040
    iptables -t nat -A OUTPUT -p udp -d 10.192.0.0/10 -j REDIRECT --to-ports 9040
    for range in $torrange 127.0.0.0/9 127.128.0.0/10; do
    iptables -t nat -A OUTPUT -d $range -j RETURN
    done
    iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
    iptables -t nat -A OUTPUT -p udp -j REDIRECT --to-ports 9040
    iptables -t nat -A OUTPUT -p icmp -j REDIRECT --to-ports 9040
    iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    for range in $torrange 127.0.0.0/8; do
    iptables -A OUTPUT -d $range -j ACCEPT
    done
    iptables -A OUTPUT -m owner --uid-owner debian-tor -j ACCEPT
    iptables -A OUTPUT -j REJECT
    echo -e "$mwv [${wtl}+$mwv]: თქვენი ამჟამინდელი ტუნელირებადი მისამართია: $wtl $myip"
    echo -e "$mwv [${wtl}+$mwv]: თქვენი ტრაფიკის ტუნელირება წარმატებით დასრულდა თქვენ უკვე ანონიმური ხართ."
}
random() {
service tor reload > /dev/null 2>&1
torreload="$?"
 if [ $torreload == "0" ]
then
    echo -e "$mwv [${yvt}ინფო$mwv]: ${mwv}თქვენი აიპი მისამართი შეიცვალა${blank}"
    ip
elif [ $torreload == "1" ]
then
    echo -e $yvt "[${wtl}!$yvt]: ${wtl}tor.service არარის აქტიური, რომ მოხდეს გადატვირთვა"
fi
}

status() {
if [[ $(service tor status  | grep 'Active: active') ]]
then
    echo -e "$mwv [${yvt}ინფო$mwv]: ${mwv}tor.service აქტიურია${blank}"
else

    echo -e $yvt "[${wtl}!$yvt]: ${wtl}tor.service არარის აქტიური, გთხოვთ გააქტიუროთ ხელით."
fi

}
deactivation() {
    echo -e "$mwv [${wtl}-$mwv]: მიმდინარეობს აპლიკაციის დეაქტივაცია"

    iptables -F
    iptables -t nat -F
    
    if [ -f /etc/network/iptables.rules ]; then
        iptables-restore < /etc/network/iptables.rules
        rm /etc/network/iptables.rules
    fi
    if [ "$resolvconf_support" = false ] 
    then
        if [ -e /etc/resolv.conf.bak ]; then
            rm /etc/resolv.conf
            cp /etc/resolv.conf.bak /etc/resolv.conf
        fi
    else
        mv /etc/resolvconf/resolv.conf.d/head{.bak,}
        resolvconf -u
    fi
    
    service tor stop
    sed -i '/^.*\#Kathopia Has HERE$/d' /etc/sysctl.conf
    sysctl -p 

    service network-manager force-reload > /dev/null 2>&1
    service nscd start > /dev/null 2>&1
    service dnsmasq start > /dev/null 2>&1
    }
checknet() {
        chknet() {
        ping -c 1 8.8.4.4 > /dev/null 2>&1
        png="$?"
         if [ $png == "0" ]
        then
        echo -e $lrj "[${wtl}X$lrj]: წარმოიქმნა სინტაქსური პრობლემა"
        read continue
            sleep 0.5
            exit
        elif [ $png == "1" ]
        then
            echo -e $yvt "[${wtl}!$yvt]: თქვენ ხართ ლოკალურ ქსელში"
            sleep 0.5
            exit
        elif [ $png == "2" ]
        then
        echo -e $wtl "[-]: თქვენ არ ხართ ინტერნეტთან დაკავშირებული!"
        read continue
            sleep 0.5
            exit
        fi
        }
    echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
    echo -e $wtl "[-]: ინტერნეტთან კავშირი : დაუმყარებელია";
    
        sleep 1
    else
    echo -e $mwv "[${wtl}+$mwv]: ინტერნეტთან კავშირი : დამყარებულია";
        sleep 1  
    fi
    }
    deactivation
    sleep 1
    activation
if [[ $* == "-s" ]] || [[ $* == "--start" ]]; then
    activation
    
elif [[ $* == "start" ]] || [[ $* == "--start" ]]; then
    activation
    
elif [[ $* == "stop" ]] || [[ $* == "--stop" ]]; then
    deactivation
    
elif [[ $* == "-x" ]] || [[ $* == "--stop" ]]; then
    deactivation
    
elif [[ $* == "-r" ]] || [[ $* == "--randomip" ]]; then
    random
    
elif [[ $* == "random" ]] || [[ $* == "--randomip" ]]; then
    random
    
elif [[ $* == "-R" ]] || [[ $* == "--restart" ]]; then
    deactivation
    sleep 1
    
    activation
elif [[ $* == "-c" ]] || [[ $* == "--checkmynet" ]]; then
    
     ip
elif [[ $* == "-S" ]] || [[ $* == "--status" ]]; then
    status
elif [[ $* == "status" ]] || [[ $* == "--status" ]]; then
    status
elif [[ $* == "-i" ]] || [[ $* == "--install" ]]; then
    install
elif [[ $* == "-si" ]] || [[ $* == "--startup" ]]; then
    startup
elif [[ $* == "-cl" ]] || [[ $* == "--clearlog" ]]; then
    clearlog
fi
}
update() {
echo "update"
}
exit() {
    pkill socat
    return 0
}

menuItems=(
    "     კათედრალის ტერმინალი     "
    "    კათედრალის ვებ-სკანერი    "
    "      ვირტუალური პროქსი       "
    "           გათიშვა            "
)
menuActions=(
K-CLI
Cronos
multihopproxy
exit
)

menuTitle="\e[92m\033[0m\033[32m \e[91mKathedral #700!$~k17 \e[93mv.2    \e[92mმენიუ    \e[92m[\e[91m0x43\e[92m],[\e[91m0x53\e[92m],[\e[91m0x47\e[92m]\e[92m"
menuFooter="   \e[91mSpace/Enter\e[39m=\e[93mარჩევა, \e[91mUp/Down\e[39m=\e[93mგადასვლა, \e[91mDel/Esc\e[39m=\e[93mგასვლა\e[92m  "
menuWidth=60
menuLeft=21
menuHighlight=$mwv
menuInit
menuLoop
reset
exit 0
