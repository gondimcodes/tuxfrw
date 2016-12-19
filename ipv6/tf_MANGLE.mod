# ----------------------------------------------------------------------------
# TuxFrw 4.2
# Copyright (C) 2001-2016 Marcelo Gondim (http://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_MANGLE.mod - TuxFrw MANGLE rules module
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

$IP6TABLES -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP

$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
$IP6TABLES -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

if [ "$EXT_IFACE" != "" ]; then $IP6TABLES -t mangle -A PREROUTING -m set --match-set bogons_v6 src -i $EXT_IFACE -j DROP; fi

# Block SSDP
$IP6TABLES -t mangle -A PREROUTING -p udp --sport 1900 -j DROP
$IP6TABLES -t mangle -A PREROUTING -p udp --dport 1900 -j DROP

# SPOOF_CHECK packets
if [ "$EXT_IFACE" != "" -a "$EXT_IP6"  != "" ]; then $IP6TABLES -t mangle -A PREROUTING -s $EXT_IP6  -j DROP; fi
if [ "$EXT_IFACE" != "" -a "$EXT_NET6" != "" ]; then $IP6TABLES -t mangle -A PREROUTING -s $EXT_NET6 ! -i $EXT_IFACE -j DROP; fi
if [ "$INT_IFACE" != "" -a "$INT_IP6"  != "" ]; then $IP6TABLES -t mangle -A PREROUTING -s $INT_IP6  -j DROP; fi
if [ "$INT_IFACE" != "" -a "$INT_NET6" != "" ]; then $IP6TABLES -t mangle -A PREROUTING -s $INT_NET6 ! -i $INT_IFACE -j DROP; fi
if [ "$DMZ_IFACE" != "" -a "$DMZ_IP6"  != "" ]; then $IP6TABLES -t mangle -A PREROUTING -s $DMZ_IP6  -j DROP; fi
if [ "$DMZ_IFACE" != "" -a "$DMZ_NET6" != "" ]; then $IP6TABLES -t mangle -A PREROUTING -s $DMZ_NET6 ! -i $DMZ_IFACE -j DROP; fi
