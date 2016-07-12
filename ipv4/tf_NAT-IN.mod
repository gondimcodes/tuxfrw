# ----------------------------------------------------------------------------
# TuxFrw 4.0
# Copyright (C) 2001-2016 Marcelo Gondim (http://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_NAT-IN.mod - TuxFrw NAT rules module
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
# create NAT_IN rules
#

# Makes 1:1 NAT with public and private IP
# Don't forget to create eth0 aliases for the public IPs

# Rule for Transparent Proxy
if [ "$PROXY_PORT" != "" -a "$INT_IFACE" != "" -a "$PROXY_T" -eq 1 ]; then
   $IPTABLES -A PREROUTING -t nat -p tcp --dport 80 -i $INT_IFACE -j REDIRECT --to-ports $PROXY_PORT
fi

$IPTABLES -A PREROUTING -t nat -d $IP_DNS1_NAT -j DNAT --to $IP_DNS1
$IPTABLES -A PREROUTING -t nat -d $IP_DNS2_NAT -j DNAT --to $IP_DNS2
$IPTABLES -A PREROUTING -t nat -d $IP_WWW1_NAT -j DNAT --to $IP_WWW1
$IPTABLES -A PREROUTING -t nat -d $IP_SMTP_NAT -j DNAT --to $IP_SMTP
