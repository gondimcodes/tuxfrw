# ----------------------------------------------------------------------------
# TuxFrw 4.4
# Copyright (C) 2001-2021 Marcelo Gondim (https://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_INT-EXT.mod - TuxFrw INT->EXT rules module
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
# INT->EXT directional chains
#

$IP6TABLES -A INT2EXT -m conntrack --ctstate RELATED -m helper --helper ftp -p tcp --dport 1024: -j ACCEPT
$IP6TABLES -A INT2EXT -p tcp -m multiport --dports 80,443,21,25,110,53 -j ACCEPT
$IP6TABLES -A INT2EXT -p udp --dport 53  -j ACCEPT

# log and reject all the unmatched packets
#$IP6TABLES -A INT2EXT -j LOG --log-prefix "tuxfrw: INT->EXT! "
