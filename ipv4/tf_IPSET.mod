# ----------------------------------------------------------------------------
# TuxFrw 4.4
# Copyright (C) 2001-2018 Marcelo Gondim (https://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_IPSET.mod - TuxFrw IPSET rules module
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

# Please create list in tf_BASE.mod

ipset add bogons_v4 0.0.0.0/8 comment "BOGONS"
ipset add bogons_v4 10.0.0.0/8 comment "BOGONS"
ipset add bogons_v4 172.16.0.0/12 comment "BOGONS"
ipset add bogons_v4 192.168.0.0/16 comment "BOGONS"
ipset add bogons_v4 224.0.0.0/3 comment "BOGONS"
ipset add bogons_v4 169.254.0.0/16 comment "BOGONS"
ipset add bogons_v4 192.0.2.0/24 comment "BOGONS"
ipset add bogons_v4 240.0.0.0/5 comment "BOGONS"
