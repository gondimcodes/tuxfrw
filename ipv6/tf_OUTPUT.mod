# ----------------------------------------------------------------------------
# TuxFrw 4.4
# Copyright (C) 2001-2018 Marcelo Gondim (https://tuxfrw.linuxinfo.com.br/)
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
$IP6TABLES -A OUTPUT -m state --state ESTABLISHED -j ACCEPT
# uncomment this line for RELATED helper if you need ftp in OUTPUT.
#$IP6TABLES -A OUTPUT -m conntrack --ctstate RELATED -m helper --helper ftp -p tcp --dport 1024: -j ACCEPT

# accept output packets from LO_IFACE
$IP6TABLES -A OUTPUT -o $LO_IFACE -j ACCEPT

# accept link local address
$IP6TABLES -A OUTPUT -s fe80::/64 -j ACCEPT
$IP6TABLES -A OUTPUT -s ::/128 -j ACCEPT

# accept unmatched OUTPUT packets
# - To enhance security, comment out this line after tests.
$IP6TABLES -A OUTPUT -j ACCEPT

# ICMPv6 rules
#$IP6TABLES -A OUTPUT -p icmpv6 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type echo-request -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type echo-reply -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type destination-unreachable -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type packet-too-big -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type ttl-zero-during-transit -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type ttl-zero-during-reassembly -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type unknown-option -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type unknown-header-type -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type bad-header -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 133 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 134 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 135 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 136 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 141 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 142 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 130 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 131 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 132 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 143 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 148 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 149 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 151 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 152 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 153 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 144 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 145 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 146 -j ACCEPT
$IP6TABLES -A OUTPUT -p icmpv6 --icmpv6-type 147 -j ACCEPT
#==============================================================================
# Place your rules below
#==============================================================================









#==============================================================================
# reject all the unmatched packets (won't work if output is totally accepted)
#$IP6TABLES -A OUTPUT -m limit --limit 1/m --limit-burst 5 -j LOG --log-prefix "tuxfrw: OUTPUT! "
