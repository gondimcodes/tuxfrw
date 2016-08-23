# ----------------------------------------------------------------------------
# TuxFrw 4.1
# Copyright (C) 2001-2016 Marcelo Gondim (http://tuxfrw.linuxinfo.com.br/)
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
$IPTABLES -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# ICMP rules
#$IPTABLES -A FORWARD -p icmp -j ACCEPT
$IPTABLES -A FORWARD -p icmp --icmp-type host-unreachable     -j ACCEPT
$IPTABLES -A FORWARD -p icmp --icmp-type port-unreachable     -j ACCEPT
$IPTABLES -A FORWARD -p icmp --icmp-type fragmentation-needed -j ACCEPT
$IPTABLES -A FORWARD -p icmp --icmp-type time-exceeded        -j ACCEPT
$IPTABLES -A FORWARD -p icmp --icmp-type echo-reply           -j ACCEPT
$IPTABLES -A FORWARD -p icmp --icmp-type echo-request         -j ACCEPT

# accept the forwardings of the nets
if [ "$DMZ_IFACE" != "" ]; then $IPTABLES -A FORWARD -i $DMZ_IFACE -o $DMZ_IFACE -j ACCEPT; fi
if [ "$INT_IFACE" != "" ]; then $IPTABLES -A FORWARD -i $INT_IFACE -o $INT_IFACE -j ACCEPT; fi
if [ "$EXT_IFACE" != "" ]; then $IPTABLES -A FORWARD -i $EXT_IFACE -o $EXT_IFACE -j ACCEPT; fi

# "link" the available networks together
if [ "$INT_IFACE" != "" -a "$DMZ_IFACE" != "" ]; then
  $IPTABLES -A FORWARD -i $INT_IFACE -o $DMZ_IFACE -j INT2DMZ
  $IPTABLES -A FORWARD -i $DMZ_IFACE -o $INT_IFACE -j DMZ2INT
fi
if [ "$INT_IFACE" != "" -a "$EXT_IFACE" != "" ]; then
  $IPTABLES -A FORWARD -i $INT_IFACE -o $EXT_IFACE -j INT2EXT
  $IPTABLES -A FORWARD -i $EXT_IFACE -o $INT_IFACE -j EXT2INT
fi
if [ "$DMZ_IFACE" != "" -a "$EXT_IFACE" != "" ]; then
  $IPTABLES -A FORWARD -i $DMZ_IFACE -o $EXT_IFACE -j DMZ2EXT
  $IPTABLES -A FORWARD -i $EXT_IFACE -o $DMZ_IFACE -j EXT2DMZ
fi
if [ "$INT_IFACE" != "" -a "$PPTP_IFACE" != "" ]; then
  $IPTABLES -A FORWARD -i $INT_IFACE -o $PPTP_IFACE -j INT2VPN
  $IPTABLES -A FORWARD -i $PPTP_IFACE -o $INT_IFACE -j VPN2INT
fi
if [ "$EXT_IFACE" != "" -a "$PPTP_IFACE" != "" ]; then
  $IPTABLES -A FORWARD -i $EXT_IFACE -o $PPTP_IFACE -j EXT2VPN
  $IPTABLES -A FORWARD -i $PPTP_IFACE -o $EXT_IFACE -j VPN2EXT
fi
if [ "$DMZ_IFACE" != "" -a "$PPTP_IFACE" != "" ]; then
  $IPTABLES -A FORWARD -i $DMZ_IFACE -o $PPTP_IFACE -j DMZ2VPN
  $IPTABLES -A FORWARD -i $PPTP_IFACE -o $DMZ_IFACE -j VPN2DMZ
fi
if [ "$INT_IFACE" != "" -a "$OpenVPN_IFACE" != "" ]; then
  $IPTABLES -A FORWARD -i $INT_IFACE -o $OpenVPN_IFACE -j INT2VPN
  $IPTABLES -A FORWARD -i $OpenVPN_IFACE -o $INT_IFACE -j VPN2INT
fi
if [ "$EXT_IFACE" != "" -a "$OpenVPN_IFACE" != "" ]; then
  $IPTABLES -A FORWARD -i $EXT_IFACE -o $OpenVPN_IFACE -j EXT2VPN
  $IPTABLES -A FORWARD -i $OpenVPN_IFACE -o $EXT_IFACE -j VPN2EXT
fi
if [ "$DMZ_IFACE" != "" -a "$OpenVPN_IFACE" != "" ]; then
  $IPTABLES -A FORWARD -i $DMZ_IFACE -o $OpenVPN_IFACE -j DMZ2VPN
  $IPTABLES -A FORWARD -i $OpenVPN_IFACE -o $DMZ_IFACE -j VPN2DMZ
fi

