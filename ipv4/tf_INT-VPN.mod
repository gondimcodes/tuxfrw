# ----------------------------------------------------------------------------
# TuxFrw 4.2
# Copyright (C) 2001-2016 Marcelo Gondim (http://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_INT-VPN.mod - TuxFrw INT->VPN rules module
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
# INT->VPN directional chain
#

# log and reject all the unmatched packets
$IPTABLES -A INT2VPN -j LOG --log-prefix "tuxfrw: INT->VPN! "
