#!/bin/bash

tor_start(){

	echo -e "[!] მიმდინარეობს კავშირის დამყარება "
	sleep 0.5
	echo -e "[!] ამას შეიძლება დაჭირდეს მაქსიმუმ 1 წუთი!"

	service tor start
	service tor restart


}

tor_start

sleep 2 


NON_TOR="192.168.1.0/24 192.168.0.0/24"

TOR_UID="43"

TRANS_PORT="9040"
iptables -F
iptables -t nat -F
iptables -t nat -A OUTPUT -m owner --uid-owner $TOR_UID -j RETURN
iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 5353
for NET in $NON_TOR 127.0.0.0/9 127.128.0.0/10; do
 iptables -t nat -A OUTPUT -d $NET -j RETURN
done
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports $TRANS_PORT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
for NET in $NON_TOR 127.0.0.0/8; do
 iptables -A OUTPUT -d $NET -j ACCEPT
done
iptables -A OUTPUT -m owner --uid-owner $TOR_UID -j ACCEPT
iptables -A OUTPUT -j REJECT


sleep 3


if [[ -n "$(curl -s https://check.torproject.org/ | grep 'Congratulations.')" ]];
then
	echo -en "
	\n[+] ტუნელირება წარმატებით დასრულდა
	\n[!] თქვენს ანონიმურობაზე ზრუნავს TOR
	\n[+] თქვენი ამჟამინდელი IP => $(curl -s ifconfig.me)
	"
else
	echo "[-] ნაბოზარი TOR\n[*]დაკავშირება ვერ მოხერხდა"
fi

