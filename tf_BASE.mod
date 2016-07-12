# ----------------------------------------------------------------------------
# TuxFrw 4.0
# Copyright (C) 2001-2016 Marcelo Gondim (http://tuxfrw.linuxinfo.com.br/)
# ----------------------------------------------------------------------------
#
# tf_BASE.mod - TuxFrw base functions module
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
# Flush, delete and zero all chains
#
clear_rules()
{
  $IPTABLES -t mangle -F;
  $IPTABLES -t nat -F;
  $IPTABLES -t filter -F;
  $IPTABLES -t raw -F;
  $IPTABLES -t mangle -X;
  $IPTABLES -t nat -X;
  $IPTABLES -t filter -X;
  $IPTABLES -t raw -X;
  $IPTABLES -t mangle -Z;
  $IPTABLES -t nat -Z;
  $IPTABLES -t filter -Z;
  $IPTABLES -t raw -Z;
  $IP6TABLES -t mangle -F;
  $IP6TABLES -t nat -F;
  $IP6TABLES -t filter -F;
  $IP6TABLES -t raw -F;
  $IP6TABLES -t mangle -X;
  $IP6TABLES -t nat -X;
  $IP6TABLES -t filter -X;
  $IP6TABLES -t raw -X;
  $IP6TABLES -t mangle -Z;
  $IP6TABLES -t nat -Z;
  $IP6TABLES -t filter -Z;
  $IP6TABLES -t raw -Z;
}

#
# Initialize IPSet list
#
reset_ipset_list()
{
   if ipset list bogons_v4 &>/dev/null; then
      ipset flush bogons_v4
      ipset destroy bogons_v4 &> /dev/null
   fi
   ipset create bogons_v4 hash:net family inet comment &> /dev/null

   if ipset list bogons_v6 &>/dev/null; then
      ipset flush bogons_v6
      ipset destroy bogons_v6 &> /dev/null
   fi 
   ipset create bogons_v6 hash:net family inet6 comment &> /dev/null
}

#
# Set firewall to default ACCEPT policy
#
apply_accept_policy()
{
  # Define default policies for default chains
  $IPTABLES -t filter -P INPUT ACCEPT
  $IPTABLES -t filter -P FORWARD ACCEPT
  $IPTABLES -t filter -P OUTPUT ACCEPT
  $IPTABLES -t raw -P PREROUTING ACCEPT
  $IPTABLES -t raw -P OUTPUT ACCEPT
  $IPTABLES -t nat -P PREROUTING ACCEPT
  $IPTABLES -t nat -P POSTROUTING ACCEPT
  $IPTABLES -t nat -P OUTPUT ACCEPT
  $IPTABLES -t mangle -P PREROUTING ACCEPT
  $IPTABLES -t mangle -P POSTROUTING ACCEPT
  $IPTABLES -t mangle -P INPUT ACCEPT
  $IPTABLES -t mangle -P OUTPUT ACCEPT
  $IPTABLES -t mangle -P FORWARD ACCEPT
  $IP6TABLES -t filter -P INPUT ACCEPT
  $IP6TABLES -t filter -P FORWARD ACCEPT
  $IP6TABLES -t filter -P OUTPUT ACCEPT
  $IP6TABLES -t raw -P OUTPUT ACCEPT
  $IP6TABLES -t raw -P PREROUTING ACCEPT
  $IP6TABLES -t nat -P PREROUTING ACCEPT
  $IP6TABLES -t nat -P POSTROUTING ACCEPT
  $IP6TABLES -t nat -P OUTPUT ACCEPT
  $IP6TABLES -t mangle -P PREROUTING ACCEPT
  $IP6TABLES -t mangle -P POSTROUTING ACCEPT
  $IP6TABLES -t mangle -P INPUT ACCEPT
  $IP6TABLES -t mangle -P OUTPUT ACCEPT
  $IP6TABLES -t mangle -P FORWARD ACCEPT
}

#
# Set firewall to DROP policy
#
apply_drop_policy()
{
  # Define policies for default chains
  $IPTABLES -t filter -P INPUT DROP
  $IPTABLES -t filter -P FORWARD DROP
  $IPTABLES -t filter -P OUTPUT DROP
  $IPTABLES -t raw -P OUTPUT ACCEPT
  $IPTABLES -t raw -P PREROUTING ACCEPT
  $IPTABLES -t nat -P PREROUTING ACCEPT
  $IPTABLES -t nat -P POSTROUTING ACCEPT
  $IPTABLES -t nat -P OUTPUT ACCEPT
  $IPTABLES -t mangle -P PREROUTING ACCEPT
  $IPTABLES -t mangle -P POSTROUTING ACCEPT
  $IPTABLES -t mangle -P INPUT ACCEPT
  $IPTABLES -t mangle -P OUTPUT ACCEPT
  $IPTABLES -t mangle -P FORWARD ACCEPT
  $IP6TABLES -t filter -P INPUT DROP
  $IP6TABLES -t filter -P FORWARD DROP
  $IP6TABLES -t filter -P OUTPUT DROP
  $IP6TABLES -t raw -P OUTPUT ACCEPT
  $IP6TABLES -t raw -P PREROUTING ACCEPT
  $IP6TABLES -t nat -P PREROUTING ACCEPT
  $IP6TABLES -t nat -P POSTROUTING ACCEPT
  $IP6TABLES -t nat -P OUTPUT ACCEPT
  $IP6TABLES -t mangle -P PREROUTING ACCEPT
  $IP6TABLES -t mangle -P POSTROUTING ACCEPT
  $IP6TABLES -t mangle -P INPUT ACCEPT
  $IP6TABLES -t mangle -P OUTPUT ACCEPT
  $IP6TABLES -t mangle -P FORWARD ACCEPT
}

#
# List 'filter' table
#
list_filter()
{
  $IPTABLES -t filter -L -v -n
}
list_filter6()
{
  $IP6TABLES -t filter -L -v -n
}

#
# List 'nat' table
#
list_nat()
{
  $IPTABLES -t nat -L -v -n
}

#
# List 'nat' table v6
#
list_nat6()
{
  $IP6TABLES -t nat -L -v -n
}

#
# List 'mangle' table
#
list_mangle()
{
  $IPTABLES -t mangle -L -v -n
}
list_mangle6()
{
  $IP6TABLES -t mangle -L -v -n
}

#
# List 'raw' table
#
list_raw()
{
  $IPTABLES -t raw -L -v -n
}
list_raw6()
{
  $IP6TABLES -t raw -L -v -n
}

#
# Create and load the rules and chains
#
create_rules()
{

  # load kernel modules
  if [ "$KERN_MOD" != "0" ]; then
    load_kernel_modules
  fi

  # set /proc options
  set_sysctl

  # setup ipset
  . $CONF_DIR/ipv4/tf_IPSET.mod 2> /tmp/tf_error
  echo -n "Loading IPSET Address list IPv4"
  evaluate_retval
  . $CONF_DIR/ipv6/tf_IPSET.mod 2> /tmp/tf_error
  echo -n "Loading IPSET Address list IPv6"
  evaluate_retval

  # setup raw
  . $CONF_DIR/ipv4/tf_RAW.mod 2> /tmp/tf_error
  echo -n "Loading RAW IPv4"
  evaluate_retval
  . $CONF_DIR/ipv6/tf_RAW.mod 2> /tmp/tf_error
  echo -n "Loading RAW IPv6"
  evaluate_retval
  
# setup mangle
  . $CONF_DIR/ipv4/tf_MANGLE.mod 2> /tmp/tf_error
  echo -n "Loading MANGLE IPv4"
  evaluate_retval
  . $CONF_DIR/ipv6/tf_MANGLE.mod 2> /tmp/tf_error
  echo -n "Loading MANGLE IPv6"
  evaluate_retval

  # setup NAT
  if   [ "$NAT" -eq 1 ]; then
    . $CONF_DIR/ipv4/tf_NAT-OUT.mod 2> /tmp/tf_error
    echo -n "Loading NAT-OUT IPv4" 
    evaluate_retval
    . $CONF_DIR/ipv6/tf_NAT-OUT.mod 2> /tmp/tf_error
    echo -n "Loading NAT-OUT IPv6" 
    evaluate_retval
  elif [ "$NAT" -eq 2 ]; then
    . $CONF_DIR/ipv4/tf_NAT-IN.mod 2> /tmp/tf_error
    echo -n "Loading NAT-IN IPv4" 
    evaluate_retval
    . $CONF_DIR/ipv6/tf_NAT-IN.mod 2> /tmp/tf_error
    echo -n "Loading NAT-IN IPv6" 
    evaluate_retval
    . $CONF_DIR/ipv4/tf_NAT-OUT.mod 2> /tmp/tf_error
    echo -n "Loading NAT-OUT IPv4" 
    evaluate_retval
    . $CONF_DIR/ipv6/tf_NAT-OUT.mod 2> /tmp/tf_error
    echo -n "Loading NAT-OUT IPv6" 
    evaluate_retval
  elif [ "$NAT" -eq 3 ]; then
    . $CONF_DIR/ipv4/tf_NAT-IN.mod 2> /tmp/tf_error
    echo -n "Loading NAT-IN IPv4" 
    evaluate_retval
    . $CONF_DIR/ipv6/tf_NAT-IN.mod 2> /tmp/tf_error
    echo -n "Loading NAT-IN IPv6" 
    evaluate_retval
  fi

  # base I/O rules
  . $CONF_DIR/ipv4/tf_INPUT.mod 2> /tmp/tf_error
  echo -n "Loading INPUT IPv4" 
  evaluate_retval
  . $CONF_DIR/ipv6/tf_INPUT.mod 2> /tmp/tf_error
  echo -n "Loading INPUT IPv6" 
  evaluate_retval
  . $CONF_DIR/ipv4/tf_OUTPUT.mod 2> /tmp/tf_error
  echo -n "Loading OUTPUT IPv4"
  evaluate_retval
  . $CONF_DIR/ipv6/tf_OUTPUT.mod 2> /tmp/tf_error
  echo -n "Loading OUTPUT IPv6"
  evaluate_retval

  # INT<->DMZ rules
  if [ "$INT_IFACE" != "" -a "$DMZ_IFACE" != "" ]; then
    $IPTABLES -N INT2DMZ
    $IPTABLES -N DMZ2INT
    $IP6TABLES -N INT2DMZ
    $IP6TABLES -N DMZ2INT
    . $CONF_DIR/ipv4/tf_INT-DMZ.mod 2> /tmp/tf_error
    echo -n "Loading INT->DMZ IPv4"
    evaluate_retval
    . $CONF_DIR/ipv6/tf_INT-DMZ.mod 2> /tmp/tf_error
    echo -n "Loading INT->DMZ IPv6"
    evaluate_retval
    . $CONF_DIR/ipv4/tf_DMZ-INT.mod 2> /tmp/tf_error
    echo -n "Loading DMZ->INT IPv4"
    evaluate_retval
    . $CONF_DIR/ipv6/tf_DMZ-INT.mod 2> /tmp/tf_error
    echo -n "Loading DMZ->INT IPv6"
    evaluate_retval
  fi

  # DMZ<->EXT rules
  if [ "$DMZ_IFACE" != "" -a "$EXT_IFACE" != "" ]; then
    $IPTABLES -N DMZ2EXT
    $IPTABLES -N EXT2DMZ
    $IP6TABLES -N DMZ2EXT
    $IP6TABLES -N EXT2DMZ
    . $CONF_DIR/ipv4/tf_DMZ-EXT.mod 2> /tmp/tf_error
    echo -n "Loading DMZ->EXT IPv4"
    evaluate_retval
    . $CONF_DIR/ipv6/tf_DMZ-EXT.mod 2> /tmp/tf_error
    echo -n "Loading DMZ->EXT IPv6"
    evaluate_retval
    . $CONF_DIR/ipv4/tf_EXT-DMZ.mod 2> /tmp/tf_error
    echo -n "Loading EXT->DMZ IPv4"
    evaluate_retval
    . $CONF_DIR/ipv6/tf_EXT-DMZ.mod 2> /tmp/tf_error
    echo -n "Loading EXT->DMZ IPv6"
    evaluate_retval
  fi

  # INT<->EXT rules
  if [ "$INT_IFACE" != "" -a "$EXT_IFACE" != "" ]; then
    $IPTABLES -N INT2EXT
    $IPTABLES -N EXT2INT
    $IP6TABLES -N INT2EXT
    $IP6TABLES -N EXT2INT
    . $CONF_DIR/ipv4/tf_INT-EXT.mod 2> /tmp/tf_error
    echo -n "Loading INT->EXT IPv4"
    evaluate_retval
    . $CONF_DIR/ipv6/tf_INT-EXT.mod 2> /tmp/tf_error
    echo -n "Loading INT->EXT IPv6"
    evaluate_retval
    . $CONF_DIR/ipv4/tf_EXT-INT.mod 2> /tmp/tf_error
    echo -n "Loading EXT->INT IPv4"
    evaluate_retval
    . $CONF_DIR/ipv6/tf_EXT-INT.mod 2> /tmp/tf_error
    echo -n "Loading EXT->INT IPv6"
    evaluate_retval
  fi

  # INT<->VPN rules
  if [ "$INT_IFACE" != "" ]; then
     if [ "$PPTP_IFACE" != "" -o "$OpenVPN_IFACE" != "" ]; then
        $IPTABLES -N INT2VPN
        $IPTABLES -N VPN2INT
        $IP6TABLES -N INT2VPN
        $IP6TABLES -N VPN2INT
        . $CONF_DIR/ipv4/tf_INT-VPN.mod 2> /tmp/tf_error
        echo -n "Loading INT->VPN IPv4"
        evaluate_retval
        . $CONF_DIR/ipv6/tf_INT-VPN.mod 2> /tmp/tf_error
        echo -n "Loading INT->VPN IPv6"
        evaluate_retval
        . $CONF_DIR/ipv4/tf_VPN-INT.mod 2> /tmp/tf_error
        echo -n "Loading VPN->INT IPv4"
        evaluate_retval
        . $CONF_DIR/ipv6/tf_VPN-INT.mod 2> /tmp/tf_error
        echo -n "Loading VPN->INT IPv6"
        evaluate_retval
     fi
  fi
  
  # EXT<->VPN rules
  if [ "$EXT_IFACE" != "" ]; then
     if [ "$PPTP_IFACE" != "" -o "$OpenVPN_IFACE" != "" ]; then
        $IPTABLES -N EXT2VPN
        $IPTABLES -N VPN2EXT
        $IP6TABLES -N EXT2VPN
        $IP6TABLES -N VPN2EXT
        . $CONF_DIR/ipv4/tf_EXT-VPN.mod 2> /tmp/tf_error
        echo -n "Loading EXT->VPN IPv4"
        evaluate_retval
        . $CONF_DIR/ipv6/tf_EXT-VPN.mod 2> /tmp/tf_error
        echo -n "Loading EXT->VPN IPv6"
        evaluate_retval
        . $CONF_DIR/ipv4/tf_VPN-EXT.mod 2> /tmp/tf_error
        echo -n "Loading VPN->EXT IPv4"
        evaluate_retval
        . $CONF_DIR/ipv6/tf_VPN-EXT.mod 2> /tmp/tf_error
        echo -n "Loading VPN->EXT IPv6"
        evaluate_retval
     fi
  fi

  # DMZ<->VPN rules
  if [ "$DMZ_IFACE" != "" ]; then
     if [ "$PPTP_IFACE" != "" -o "$OpenVPN_IFACE" != "" ]; then
        $IPTABLES -N DMZ2VPN
        $IPTABLES -N VPN2DMZ
        $IP6TABLES -N DMZ2VPN
        $IP6TABLES -N VPN2DMZ
        . $CONF_DIR/ipv4/tf_DMZ-VPN.mod 2> /tmp/tf_error
        echo -n "Loading DMZ->VPN IPv4"
        evaluate_retval
        . $CONF_DIR/ipv6/tf_DMZ-VPN.mod 2> /tmp/tf_error
        echo -n "Loading DMZ->VPN IPv6"
        evaluate_retval
        . $CONF_DIR/ipv4/tf_VPN-DMZ.mod 2> /tmp/tf_error
        echo -n "Loading VPN->DMZ IPv4"
        evaluate_retval
        . $CONF_DIR/ipv6/tf_VPN-DMZ.mod 2> /tmp/tf_error
        echo -n "Loading VPN->DMZ IPv6"
        evaluate_retval
     fi
  fi

  # create forward rules :-)
  . $CONF_DIR/ipv4/tf_FORWARD.mod 2> /tmp/tf_error
  echo -n "Loading FORWARD IPv4"
  evaluate_retval
  . $CONF_DIR/ipv6/tf_FORWARD.mod 2> /tmp/tf_error
  echo -n "Loading FORWARD IPv6"
  evaluate_retval
}

#
# Load the NAT rules
#
create_natopen()
{

  # load kernel modules
  if [ "$KERN_MOD" != "0" ]; then
    load_kernel_modules
  fi

  # set /proc options
  set_sysctl

  # setup NAT
  if   [ "$NAT" -eq 1 ]; then
    . $CONF_DIR/ipv4/tf_NAT-OUT.mod 2> /tmp/tf_error
    echo -n "Loading NAT-OUT IPv4" 
    evaluate_retval
    . $CONF_DIR/ipv6/tf_NAT-OUT.mod 2> /tmp/tf_error
    echo -n "Loading NAT-OUT IPv6" 
    evaluate_retval
  elif [ "$NAT" -eq 2 ]; then
    . $CONF_DIR/ipv4/tf_NAT-IN.mod 2> /tmp/tf_error
    echo -n "Loading NAT-IN IPv4" 
    evaluate_retval
    . $CONF_DIR/ipv6/tf_NAT-IN.mod 2> /tmp/tf_error
    echo -n "Loading NAT-IN IPv6" 
    evaluate_retval
    . $CONF_DIR/ipv4/tf_NAT-OUT.mod 2> /tmp/tf_error
    echo -n "Loading NAT-OUT IPv4" 
    evaluate_retval
    . $CONF_DIR/ipv6/tf_NAT-OUT.mod 2> /tmp/tf_error
    echo -n "Loading NAT-OUT IPv6" 
    evaluate_retval
  elif [ "$NAT" -eq 3 ]; then
    . $CONF_DIR/ipv4/tf_NAT-IN.mod 2> /tmp/tf_error
    echo -n "Loading NAT-IN IPv4" 
    evaluate_retval
    . $CONF_DIR/ipv6/tf_NAT-IN.mod 2> /tmp/tf_error
    echo -n "Loading NAT-IN IPv6" 
    evaluate_retval
  fi
}
