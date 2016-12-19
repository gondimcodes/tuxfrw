# ----------------------------------------------------------------------------
# TuxFrw 4.2
# Copyright (C) 2001-2016 Marcelo Gondim (http://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_OUTPUT.mod - TuxFrw main rules module
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
# OUTPUT chain
#

# accept output packets with allowed state
$IPTABLES -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
# uncomment this line for RELATED helper if you need ftp in OUTPUT.
#$IPTABLES -A OUTPUT -m conntrack --ctstate RELATED -m helper --helper ftp -p tcp --dport 1024: -j ACCEPT

# accept output packets from LO_IFACE
$IPTABLES -A OUTPUT -o $LO_IFACE -j ACCEPT

# accept unmatched OUTPUT packets
# - To enhance security, comment out this line after tests.
$IPTABLES -A OUTPUT -j ACCEPT

# accept ICMP output packets (from the firewall to any other host)
# $IPTABLES -A OUTPUT -p icmp -j ACCEPT

# ICMP rules
#$IPTABLES -A OUTPUT -p icmp -j ACCEPT
$IPTABLES -A OUTPUT -p icmp --icmp-type host-unreachable           -j ACCEPT
$IPTABLES -A OUTPUT -p icmp --icmp-type port-unreachable           -j ACCEPT
$IPTABLES -A OUTPUT -p icmp --icmp-type fragmentation-needed       -j ACCEPT
$IPTABLES -A OUTPUT -p icmp --icmp-type time-exceeded              -j ACCEPT
$IPTABLES -A OUTPUT -p icmp --icmp-type echo-reply                 -j ACCEPT
$IPTABLES -A OUTPUT -p icmp --icmp-type echo-request               -j ACCEPT
#==============================================================================
# Place your rules below
#==============================================================================










#==============================================================================
# reject all the unmatched packets (won't work if output is totally accepted)
$IPTABLES -A OUTPUT -m limit --limit 1/m --limit-burst 5 -j LOG --log-prefix "tuxfrw: OUTPUT! "
