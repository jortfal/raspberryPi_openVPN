#!/bin/sh

#PATH='/sbin'

# Flush previous rules, delete chains and reset counters
iptables -F
iptables -X
iptables -Z
iptables -t nat -F
#iptables -t nat -X
#iptables -t mangle -F
#iptables -t mangle -X

# Default policy to drop 'everything' but our output to internet
iptables -P INPUT   DROP
iptables -P FORWARD ACCEPT
iptables -P OUTPUT  DROP

# Enable loopback traffic
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Enable icmp (ping) traffic
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p icmp -m icmp --icmp-type 0 -m state --state RELATED,ESTABLISHED -j ACCEPT

### filter table

	## INPUT
		
		# Incoming ssh from the LAN
		iptables -A INPUT -i eth0 -s 0.0.0.0/0 \
		                  -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

		# Incoming openVPN server from the LAN
		iptables -A INPUT -i eth0 -s 0.0.0.0/0 \
		                  -p udp --dport 55513 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

		# Incoming dns 
		iptables -A INPUT -i eth0 -s 0.0.0.0/0 \
		                  -p tcp --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

		iptables -A INPUT -i eth0 -s 0.0.0.0/0 \
		                  -p udp --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

		# Incoming http 
		iptables -A INPUT -i eth0 -s 0.0.0.0/0 \
		                  -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

		iptables -A INPUT -i eth0 -s 0.0.0.0/0 \
		                  -p udp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
		# Incoming https 
		iptables -A INPUT -i eth0 -s 0.0.0.0/0 \
		                  -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

		iptables -A INPUT -i eth0 -s 0.0.0.0/0 \
		                  -p udp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

	## OUTPUT

		# ssh 
		iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

		# openVPN 
		iptables -A OUTPUT -p udp --sport 55513 -m conntrack --ctstate ESTABLISHED -j ACCEPT

		# dns
		iptables -A OUTPUT -p tcp --sport 53 -m conntrack --ctstate ESTABLISHED -j ACCEPT
		iptables -A OUTPUT -p udp --sport 53 -m conntrack --ctstate ESTABLISHED -j ACCEPT

		# http
		iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
		iptables -A OUTPUT -p udp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT

		# https
		iptables -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
		iptables -A OUTPUT -p udp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

	## FORWARD

		# Allow traffic initiated from LAN to access VPN
		#iptables -I FORWARD -i eth0 -o tun0 -s 0.0.0.0/0 \
							#-m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

		# Allow traffic initiated from VPN to access LAN
		#iptables -I FORWARD -i tun0 -o eth0 -s 10.8.0.0/24 \
		                    #-m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT

### nat table
	
	## PREROUTING

	## INPUT
	
	## OUTPUT
	
	## POSTROUTING

		iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE

### LOGGING

	#iptables -A INPUT   -j LOG  --log-prefix "iptables_INPUT: " --log-level 4
	#iptables -A OUTPUT  -j LOG  --log-prefix "iptables_OUTPUT: " --log-level 4
	#iptables -A FORWARD -j LOG  --log-prefix "iptables_INPUT: " --log-level 4