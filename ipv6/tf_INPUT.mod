# ----------------------------------------------------------------------------
# TuxFrw 4.4
# Copyright (C) 2001-2021 Marcelo Gondim (https://tuxfrw.linuxinfo.com.br/)
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
$IP6TABLES -A INPUT -m state --state ESTABLISHED -j ACCEPT
# uncomment this line for RELATED helper if you need ftp in INPUT.
#$IP6TABLES -A INPUT -m conntrack --ctstate RELATED -m helper --helper ftp -p tcp --dport 1024: -j ACCEPT

# accept input packets from LO_IFACE
$IP6TABLES -A INPUT -i $LO_IFACE -j ACCEPT

# accept link local address
$IP6TABLES -A INPUT -d fe80::/64 -j ACCEPT
$IP6TABLES -A INPUT -d ff00::/8 -j ACCEPT

# accept SSH input from remote administrator IP
if [ "$RMT_ADMIN_IP6" != "" ]; then
   $IP6TABLES -A INPUT -p tcp -m tcp -s $RMT_ADMIN_IP6 --dport $SSH_PORT -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
fi

# ICMPv6 rules
#$IP6TABLES -A INPUT -p icmpv6 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type echo-reply -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type destination-unreachable -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type packet-too-big -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type ttl-zero-during-transit -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type ttl-zero-during-reassembly -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type unknown-option -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type unknown-header-type -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type bad-header -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 133 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 134 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 135 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 136 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 141 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 142 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 130 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 131 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 132 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 143 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 148 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 149 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 151 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 152 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 153 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 144 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 145 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 146 -j ACCEPT
$IP6TABLES -A INPUT -p icmpv6 --icmpv6-type 147 -j ACCEPT

# accept UNIX Traceroute Requests
# $IP6TABLES -A INPUT -p udp --dport 33434 -j ACCEPT

# Proxy access - authorization
if [ "$PROXY_PORT" != "" -a "$INT_IFACE" != "" ]; then
   $IP6TABLES -A INPUT -p tcp -m tcp --dport $PROXY_PORT -m conntrack --ctstate INVALID,UNTRACKED -i $INT_IFACE -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
fi

# accept OpenVPN between this firewall and another
if [ "$OpenVPN_IP6" != "" -a "$OpenVPN_PORT" != "" ]; then
   $IP6TABLES -A INPUT -p tcp -m tcp --dport $OpenVPN_PORT -s $OpenVPN_IP6 -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
fi

# accept VPN between this firewall and another (using PPTP)
if [ "$PPTP_IP6" != "" ]; then
   $IP6TABLES -A INPUT -p 47 -s $PPTP_IP6 -j ACCEPT
fi
#==============================================================================
# Place your rules below
#==============================================================================










#==============================================================================
$IP6TABLES -A INPUT -m conntrack --ctstate INVALID -j DROP

# reject all the unmatched packets. Insert your rules above this line.
#$IP6TABLES -A INPUT -m limit --limit 1/m --limit-burst 5 -j LOG --log-prefix "tuxfrw: INPUT! "
