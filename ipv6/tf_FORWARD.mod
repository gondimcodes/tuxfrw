# ----------------------------------------------------------------------------
# TuxFrw 4.4
# Copyright (C) 2001-2021 Marcelo Gondim (https://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_FORWARD.mod - TuxFrw main rules module
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
# FORWARD chain
#

# accept forward packets with allowed state
$IP6TABLES -A FORWARD -m state --state ESTABLISHED -j ACCEPT
# uncomment this line for RELATED helper if you need ftp in FORWARD.
#$IP6TABLES -A FORWARD -m conntrack --ctstate RELATED -m helper --helper ftp -p tcp --dport 1024: -j ACCEPT

# ICMPv6 rules
#$IP6TABLES -A FORWARD -p icmpv6 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type echo-request -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type echo-reply -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type destination-unreachable -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type packet-too-big -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type ttl-zero-during-transit -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type ttl-zero-during-reassembly -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type unknown-option -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type unknown-header-type -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type bad-header -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 133 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 134 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 135 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 136 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 141 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 142 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 130 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 131 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 132 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 143 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 148 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 149 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 151 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 152 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 153 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 144 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 145 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 146 -j ACCEPT
$IP6TABLES -A FORWARD -p icmpv6 --icmpv6-type 147 -j ACCEPT

# accept the forwardings of the nets
if [ "$DMZ_IFACE" != "" ]; then $IP6TABLES -A FORWARD -i $DMZ_IFACE -o $DMZ_IFACE -j ACCEPT; fi
if [ "$INT_IFACE" != "" ]; then $IP6TABLES -A FORWARD -i $INT_IFACE -o $INT_IFACE -j ACCEPT; fi
if [ "$EXT_IFACE" != "" ]; then $IP6TABLES -A FORWARD -i $EXT_IFACE -o $EXT_IFACE -j ACCEPT; fi

# "link" the available networks together
if [ "$INT_IFACE" != "" -a "$DMZ_IFACE" != "" ]; then
  $IP6TABLES -A FORWARD -i $INT_IFACE -o $DMZ_IFACE -j INT2DMZ
  $IP6TABLES -A FORWARD -i $DMZ_IFACE -o $INT_IFACE -j DMZ2INT
fi
if [ "$INT_IFACE" != "" -a "$EXT_IFACE" != "" ]; then
  $IP6TABLES -A FORWARD -i $INT_IFACE -o $EXT_IFACE -j INT2EXT
  $IP6TABLES -A FORWARD -i $EXT_IFACE -o $INT_IFACE -j EXT2INT
fi
if [ "$DMZ_IFACE" != "" -a "$EXT_IFACE" != "" ]; then
  $IP6TABLES -A FORWARD -i $DMZ_IFACE -o $EXT_IFACE -j DMZ2EXT
  $IP6TABLES -A FORWARD -i $EXT_IFACE -o $DMZ_IFACE -j EXT2DMZ
fi
if [ "$INT_IFACE" != "" -a "$PPTP_IFACE" != "" ]; then
  $IP6TABLES -A FORWARD -i $INT_IFACE -o $PPTP_IFACE -j INT2VPN
  $IP6TABLES -A FORWARD -i $PPTP_IFACE -o $INT_IFACE -j VPN2INT
fi
if [ "$EXT_IFACE" != "" -a "$PPTP_IFACE" != "" ]; then
  $IP6TABLES -A FORWARD -i $EXT_IFACE -o $PPTP_IFACE -j EXT2VPN
  $IP6TABLES -A FORWARD -i $PPTP_IFACE -o $EXT_IFACE -j VPN2EXT
fi
if [ "$DMZ_IFACE" != "" -a "$PPTP_IFACE" != "" ]; then
  $IP6TABLES -A FORWARD -i $DMZ_IFACE -o $PPTP_IFACE -j DMZ2VPN
  $IP6TABLES -A FORWARD -i $PPTP_IFACE -o $DMZ_IFACE -j VPN2DMZ
fi
if [ "$INT_IFACE" != "" -a "$OpenVPN_IFACE" != "" ]; then
  $IP6TABLES -A FORWARD -i $INT_IFACE -o $OpenVPN_IFACE -j INT2VPN
  $IP6TABLES -A FORWARD -i $OpenVPN_IFACE -o $INT_IFACE -j VPN2INT
fi
if [ "$EXT_IFACE" != "" -a "$OpenVPN_IFACE" != "" ]; then
  $IP6TABLES -A FORWARD -i $EXT_IFACE -o $OpenVPN_IFACE -j EXT2VPN
  $IP6TABLES -A FORWARD -i $OpenVPN_IFACE -o $EXT_IFACE -j VPN2EXT
fi
if [ "$DMZ_IFACE" != "" -a "$OpenVPN_IFACE" != "" ]; then
  $IP6TABLES -A FORWARD -i $DMZ_IFACE -o $OpenVPN_IFACE -j DMZ2VPN
  $IP6TABLES -A FORWARD -i $OpenVPN_IFACE -o $DMZ_IFACE -j VPN2DMZ
fi

