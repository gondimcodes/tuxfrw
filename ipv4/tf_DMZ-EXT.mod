# ----------------------------------------------------------------------------
# TuxFrw 4.4
# Copyright (C) 2001-2018 Marcelo Gondim (https://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_DMZ-EXT.mod - TuxFrw DMZ->EXT rules module
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
# DMZ->EXT directional chain
#

$IPTABLES -A DMZ2EXT -p udp -s $IP_DNS1 --dport 53 -j ACCEPT
$IPTABLES -A DMZ2EXT -p tcp -s $IP_DNS1 --dport 53 -j ACCEPT
$IPTABLES -A DMZ2EXT -p udp -s $IP_DNS2 --dport 53 -j ACCEPT
$IPTABLES -A DMZ2EXT -p tcp -s $IP_DNS2 --dport 53 -j ACCEPT
$IPTABLES -A DMZ2EXT -p tcp -s $IP_SMTP --dport 25 -j ACCEPT

# log and reject all the unmatched packets
#$IPTABLES -A DMZ2EXT -j LOG --log-prefix "tuxfrw: DMZ->EXT! "
