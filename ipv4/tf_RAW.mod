# ----------------------------------------------------------------------------
# TuxFrw 4.4
# Copyright (C) 2001-2018 Marcelo Gondim (https://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_RAW.mod - TuxFrw RAW rules module
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


# SYNPROXY
if [ "$RMT_ADMIN_IP" != "" ]; then
   $IPTABLES -t raw -A PREROUTING -s $RMT_ADMIN_IP -p tcp -m tcp --syn --dport $SSH_PORT -j CT --notrack
fi
if [ "$OpenVPN_IP" != "" -a "$OpenVPN_PORT" != "" ]; then
   $IPTABLES -t raw -A PREROUTING -s $OpenVPN_IP -p tcp -m tcp --syn --dport $OpenVPN_PORT -j CT --notrack
fi
if [ "$PPTP_IP" != "" ]; then
   $IPTABLES -t raw -A PREROUTING -s $PPTP_IP -p tcp -m tcp --dport 1723 -j CT --helper pptp
fi
  
# helper ftp
#$IPTABLES -t raw -A PREROUTING -p tcp --dport 21 -j CT --helper ftp

$IPTABLES -t raw -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP

$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
$IPTABLES -t raw -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

if [ "$EXT_IFACE" != "" ]; then $IPTABLES -t raw -A PREROUTING -m set --match-set bogons_v4 src -i $EXT_IFACE -j DROP; fi
$IPTABLES -t raw -A PREROUTING -s 127.0.0.0/8 ! -i $LO_IFACE -j DROP

# SPOOF_CHECK packets
if [ "$EXT_IFACE" != "" -a "$EXT_IP"  != "" ]; then $IPTABLES -t raw -A PREROUTING -s $EXT_IP  -j DROP; fi
if [ "$EXT_IFACE" != "" -a "$EXT_BRO" != "" ]; then $IPTABLES -t raw -A PREROUTING -s $EXT_BRO -j DROP; fi
if [ "$EXT_IFACE" != "" -a "$EXT_NET" != "" ]; then $IPTABLES -t raw -A PREROUTING -s $EXT_NET ! -i $EXT_IFACE -j DROP; fi
if [ "$INT_IFACE" != "" -a "$INT_IP"  != "" ]; then $IPTABLES -t raw -A PREROUTING -s $INT_IP  -j DROP; fi
if [ "$INT_IFACE" != "" -a "$INT_BRO" != "" ]; then $IPTABLES -t raw -A PREROUTING -s $INT_BRO -j DROP; fi
if [ "$INT_IFACE" != "" -a "$INT_NET" != "" ]; then $IPTABLES -t raw -A PREROUTING -s $INT_NET ! -i $INT_IFACE -j DROP; fi
if [ "$DMZ_IFACE" != "" -a "$DMZ_IP"  != "" ]; then $IPTABLES -t raw -A PREROUTING -s $DMZ_IP  -j DROP; fi
if [ "$DMZ_IFACE" != "" -a "$DMZ_BRO" != "" ]; then $IPTABLES -t raw -A PREROUTING -s $DMZ_BRO -j DROP; fi
if [ "$DMZ_IFACE" != "" -a "$DMZ_NET" != "" ]; then $IPTABLES -t raw -A PREROUTING -s $DMZ_NET ! -i $DMZ_IFACE -j DROP; fi
