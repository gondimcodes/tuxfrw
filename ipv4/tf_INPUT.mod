# ----------------------------------------------------------------------------
# TuxFrw 4.1
# Copyright (C) 2001-2016 Marcelo Gondim (http://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_INPUT.mod - TuxFrw main rules module
#
# ----------------------------------------------------------------------------
#
# This file is part of TuxFrw
#
# TuxFrw is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
# ----------------------------------------------------------------------------

#
# INPUT chains
#

# accept input packets with allowed state
$IPTABLES -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# accept input packets from LO_IFACE
$IPTABLES -A INPUT -i $LO_IFACE -j ACCEPT

# accept SSH input from remote administrator IP
if [ "$RMT_ADMIN_IP" != "" ]; then
   $IPTABLES -A INPUT -p tcp -m tcp -s $RMT_ADMIN_IP --dport $SSH_PORT -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
fi

# ICMP rules
#$IPTABLES -A INPUT -p icmp -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type host-unreachable     -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type port-unreachable     -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type fragmentation-needed -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type time-exceeded        -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type echo-reply           -j ACCEPT
$IPTABLES -A INPUT -p icmp --icmp-type echo-request         -j ACCEPT

# accept UNIX Traceroute Requests
# $IPTABLES -A INPUT -p udp --dport 33434 -j ACCEPT

# Proxy access - authorization
if [ "$PROXY_PORT" != "" -a "$INT_IFACE" != "" ]; then
   $IPTABLES -A INPUT -p tcp -m tcp --dport $PROXY_PORT -i $INT_IFACE -j ACCEPT
fi

# accept OpenVPN between this firewall and another
if [ "$OpenVPN_IP" != "" -a "$OpenVPN_PORT" != "" ]; then
   $IPTABLES -A INPUT -p tcp -m tcp --dport $OpenVPN_PORT -s $OpenVPN_IP -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
fi

# accept VPN between this firewall and another (using PPTP)
if [ "$PPTP_IP" != "" ]; then
   $IPTABLES -A INPUT -p 47  -s $PPTP_IP -j ACCEPT
   $IPTABLES -A INPUT -p tcp -m tcp --dport 1723 -s $PPTP_IP -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
fi
#==============================================================================
# Place your rules below
#==============================================================================









#==============================================================================
$IPTABLES -A INPUT -m conntrack --ctstate INVALID -j DROP

# reject all the unmatched packets. Insert your rules above this line.
$IPTABLES -A INPUT -m limit --limit 1/m --limit-burst 5 -j LOG --log-prefix "tuxfrw: INPUT! "
