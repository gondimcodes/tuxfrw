# ----------------------------------------------------------------------------
# TuxFrw 4.1
# Copyright (C) 2001-2016 Marcelo Gondim (http://tuxfrw.linuxinfo.com.br/)
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

$IP6TABLES -A DMZ2EXT -p udp -s $IP6_DNS1 --dport 53 -j ACCEPT
$IP6TABLES -A DMZ2EXT -p tcp -s $IP6_DNS1 --dport 53 -j ACCEPT
$IP6TABLES -A DMZ2EXT -p udp -s $IP6_DNS2 --dport 53 -j ACCEPT
$IP6TABLES -A DMZ2EXT -p tcp -s $IP6_DNS2 --dport 53 -j ACCEPT
$IP6TABLES -A DMZ2EXT -p tcp -s $IP6_SMTP --dport 25 -j ACCEPT

# log and reject all the unmatched packets
$IP6TABLES -A DMZ2EXT -j LOG --log-prefix "tuxfrw: DMZ->EXT! "
