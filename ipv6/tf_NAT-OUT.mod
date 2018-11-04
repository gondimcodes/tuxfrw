# ----------------------------------------------------------------------------
# TuxFrw 4.4
# Copyright (C) 2001-2018 Marcelo Gondim (https://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_NAT-OUT.mod - TuxFrw NAT rules module
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
# create NAT_OUT rules
#

if [ "$DMZ_IFACE" != "" -a "$DMZ_NET6" != "" -a "$DMZ_IP6" != "" ]; then
  $IP6TABLES -A POSTROUTING -t nat -s $DMZ_NET6 -d $DMZ_NET6 -o $DMZ_IFACE -j SNAT --to $DMZ_IP6
fi
if [ "$INT_IFACE" != "" -a "$INT_NET6" != "" -a "$INT_IP6" != "" ]; then
  $IP6TABLES -A POSTROUTING -t nat -s $INT_NET6 -d $INT_NET6 -o $INT_IFACE -j SNAT --to $INT_IP6
fi
