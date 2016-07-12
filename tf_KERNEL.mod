# ----------------------------------------------------------------------------
# TuxFrw 4.0
# Copyright (C) 2001-2016 Marcelo Gondim (http://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_KERNEL.mod - TuxFrw kernel configuration module
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
# Firewall modules autoloader
#
load_kernel_modules()
{
  MODPROBE=`type -p modprobe`

  $MODPROBE nf_conntrack_ftp
  $MODPROBE nf_nat_ftp

  if [ "$PPTP_IFACE" != "" ]; then
    $MODPROBE nf_conntrack_pptp
    $MODPROBE nf_nat_pptp
    $MODPROBE ip_gre
    $MODPROBE ip6_gre
  fi
}

#
# sysctl tuning - recommended parameters
#
# ( Some of this code has been "stolen" from https://javapipe.com/iptables-ddos-protection
#   Thanks to Constantin Oesterling )
#
set_sysctl()
{

  SYSCTL=`type -p sysctl`

  # Enabling forwarding
  if [ "$FORWARDING" -eq 0 ]; then
    $SYSCTL net.ipv4.conf.all.forwarding=0
    $SYSCTL net.ipv6.conf.all.forwarding=0
  else
    $SYSCTL net.ipv4.conf.all.forwarding=1
    $SYSCTL net.ipv6.conf.all.forwarding=1
  fi
  

  # --------( Sysctl Tuning - SYN Parameters )--------

  $SYSCTL kernel.printk="4 4 1 7"
  $SYSCTL kernel.panic=10
  $SYSCTL kernel.sysrq=0
  $SYSCTL kernel.shmmax=4294967296
  $SYSCTL kernel.shmall=4194304
  $SYSCTL kernel.core_uses_pid=1
  $SYSCTL kernel.msgmnb=65536
  $SYSCTL kernel.msgmax=65536
  $SYSCTL vm.swappiness=20
  $SYSCTL vm.dirty_ratio=80
  $SYSCTL vm.dirty_background_ratio=5
  $SYSCTL fs.file-max=2097152
  $SYSCTL net.core.netdev_max_backlog=262144
  $SYSCTL net.core.rmem_default=31457280
  $SYSCTL net.core.rmem_max=67108864
  $SYSCTL net.core.wmem_default=31457280
  $SYSCTL net.core.wmem_max=67108864
  $SYSCTL net.core.somaxconn=65535
  $SYSCTL net.core.optmem_max=25165824
  $SYSCTL net.ipv4.neigh.default.gc_thresh1=4096
  $SYSCTL net.ipv4.neigh.default.gc_thresh2=8192
  $SYSCTL net.ipv4.neigh.default.gc_thresh3=16384
  $SYSCTL net.ipv4.neigh.default.gc_interval=5
  $SYSCTL net.ipv4.neigh.default.gc_stale_time=120
  $SYSCTL net.netfilter.nf_conntrack_max=10000000
  $SYSCTL net.netfilter.nf_conntrack_tcp_loose=0
  $SYSCTL net.netfilter.nf_conntrack_tcp_timeout_established=1800
  $SYSCTL net.netfilter.nf_conntrack_tcp_timeout_close=10
  $SYSCTL net.netfilter.nf_conntrack_tcp_timeout_close_wait=10
  $SYSCTL net.netfilter.nf_conntrack_tcp_timeout_fin_wait=20
  $SYSCTL net.netfilter.nf_conntrack_tcp_timeout_last_ack=20
  $SYSCTL net.netfilter.nf_conntrack_tcp_timeout_syn_recv=20
  $SYSCTL net.netfilter.nf_conntrack_tcp_timeout_syn_sent=20
  $SYSCTL net.netfilter.nf_conntrack_tcp_timeout_time_wait=10
  $SYSCTL net.ipv4.tcp_slow_start_after_idle=0
  $SYSCTL net.ipv4.ip_local_port_range="1024 65000"
  $SYSCTL net.ipv4.ip_no_pmtu_disc=1
  $SYSCTL net.ipv4.route.flush=1
  $SYSCTL net.ipv4.route.max_size=8048576
  $SYSCTL net.ipv4.icmp_echo_ignore_broadcasts=1
  $SYSCTL net.ipv4.icmp_ignore_bogus_error_responses=1
  $SYSCTL net.ipv4.tcp_congestion_control=htcp
  $SYSCTL net.ipv4.tcp_mem="65536 131072 262144"
  $SYSCTL net.ipv4.udp_mem="65536 131072 262144"
  $SYSCTL net.ipv4.tcp_rmem="4096 87380 33554432"
  $SYSCTL net.ipv4.udp_rmem_min=16384
  $SYSCTL net.ipv4.tcp_wmem="4096 87380 33554432"
  $SYSCTL net.ipv4.udp_wmem_min=16384
  $SYSCTL net.ipv4.tcp_max_tw_buckets=1440000
  $SYSCTL net.ipv4.tcp_tw_recycle=0
  $SYSCTL net.ipv4.tcp_tw_reuse=1
  $SYSCTL net.ipv4.tcp_max_orphans=400000
  $SYSCTL net.ipv4.tcp_window_scaling=1
  $SYSCTL net.ipv4.tcp_rfc1337=1
  $SYSCTL net.ipv4.tcp_syncookies=1
  $SYSCTL net.ipv4.tcp_synack_retries=1
  $SYSCTL net.ipv4.tcp_syn_retries=2
  $SYSCTL net.ipv4.tcp_max_syn_backlog=16384
  $SYSCTL net.ipv4.tcp_timestamps=1
  $SYSCTL net.ipv4.tcp_sack=1
  $SYSCTL net.ipv4.tcp_fack=1
  $SYSCTL net.ipv4.tcp_ecn=2
  $SYSCTL net.ipv4.tcp_fin_timeout=10
  $SYSCTL net.ipv4.tcp_keepalive_time=600
  $SYSCTL net.ipv4.tcp_keepalive_intvl=60
  $SYSCTL net.ipv4.tcp_keepalive_probes=10
  $SYSCTL net.ipv4.tcp_no_metrics_save=1
  $SYSCTL net.ipv4.conf.all.accept_redirects=0
  $SYSCTL net.ipv4.conf.all.send_redirects=0
  $SYSCTL net.ipv4.conf.all.accept_source_route=0
  $SYSCTL net.ipv4.conf.all.rp_filter=1

}
