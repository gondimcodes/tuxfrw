# ----------------------------------------------------------------------------
# TuxFrw 4.4
# Copyright (C) 2001-2022 Marcelo Gondim (https://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_EXT-INT.mod - TuxFrw EXT->INT rules module
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
# EXT->INT directional chain
#

# log and reject all the unmatched packets
#$IPTABLES -A EXT2INT -m limit --limit 1/m --limit-burst 5 -j LOG --log-prefix "tuxfrw: EXT->INT! "
