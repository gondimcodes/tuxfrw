# ----------------------------------------------------------------------------
# TuxFrw 4.1
# Copyright (C) 2001-2016 Marcelo Gondim (http://tuxfrw.linuxinfo.com.br/)
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
if [ "$PROXY_PORT" != "" -a "$INT_IFACE" != "" ]; then
   $IPTABLES -t raw -A PREROUTING -p tcp -m tcp --syn --dport $PROXY_PORT -i $INT_IFACE -j CT --notrack
fi
if [ "$OpenVPN_IP" != "" -a "$OpenVPN_PORT" != "" ]; then
   $IPTABLES -t raw -A PREROUTING -s $OpenVPN_IP -p tcp -m tcp --syn --dport $OpenVPN_PORT -j CT --notrack
fi
if [ "$PPTP_IP" != "" ]; then
   $IPTABLES -t raw -A PREROUTING -s $PPTP_IP -p tcp -m tcp --syn --dport 1723 -j CT --notrack
fi
  

