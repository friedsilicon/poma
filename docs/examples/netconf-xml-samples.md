# NETCONF XML Examples for BGP Models

This document provides comprehensive NETCONF XML examples for both Nokia and OpenConfig BGP YANG models, demonstrating typical configuration and state retrieval operations.

## Overview

The examples show:
- **Nokia BGP Configuration**: Complete BGP setup using Nokia SROS models
- **OpenConfig BGP Configuration**: Standards-based BGP configuration
- **Nokia BGP State Queries**: Read-only operational state queries
- **NETCONF Operations**: `get`, `edit-config` with realistic BGP scenarios

## Complete Configuration Examples

For complete, ready-to-use NETCONF configuration samples, see:

- **[OpenConfig BGP Configuration](netconf/openconfig-bgp-config.xml)** - Full BGP setup using OpenConfig models
- **[Nokia SROS BGP Configuration](netconf/nokia-bgp-config.xml)** - Complete Nokia BGP configuration
- **[NETCONF Samples README](netconf/README.md)** - Usage instructions and customization guide

These samples include:
- Global BGP configuration (AS numbers, router-id)
- Peer group templates and neighbor configuration
- Address family enablement (IPv4/IPv6)
- Route reflector setup
- Policy configuration (Nokia) and AFI-SAFI settings (OpenConfig)

## Nokia BGP State Model Examples

### Basic State Query

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rpc message-id="101" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <get>
    <filter type="subtree">
      <state xmlns="urn:nokia.com:sros:ns:yang:sr:state">
        <router>
          <bgp>
            <autonomous-system/>
            <router-id/>
            <group>
              <group-name>EBGP-PEERS</group-name>
              <type/>
              <admin-state/>
              <peer-as/>
              <neighbor>
                <ip-address>192.168.1.1</ip-address>
                <session-state/>
                <connection-state/>
              </neighbor>
            </group>
          </bgp>
        </router>
      </state>
    </filter>
  </get>
</rpc>
```

### Nokia State Response

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rpc-reply message-id="101" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <data>
    <state xmlns="urn:nokia.com:sros:ns:yang:sr:state">
      <router>
        <bgp>
          <autonomous-system>65001</autonomous-system>
          <router-id>10.0.0.1</router-id>
          <group>
            <group-name>EBGP-PEERS</group-name>
            <type>external</type>
            <admin-state>enable</admin-state>
            <peer-as>65002</peer-as>
            <family>
              <ipv4>
                <unicast>
                  <advertise-inactive>false</advertise-inactive>
                </unicast>
              </ipv4>
              <vpn-ipv4>
                <unicast>
                  <advertise-inactive>false</advertise-inactive>
                </unicast>
              </vpn-ipv4>
            </family>
            <neighbor>
              <ip-address>192.168.1.1</ip-address>
              <session-state>established</session-state>
              <connection-state>established</connection-state>
              <last-state-change>2025-07-26T10:30:45Z</last-state-change>
            </neighbor>
          </group>
          <statistics>
            <total-paths>15420</total-paths>
            <total-prefixes>8942</total-prefixes>
            <memory-used>52428800</memory-used>
          </statistics>
        </bgp>
      </router>
    </state>
  </data>
</rpc-reply>
```

## OpenConfig BGP Model Examples

### Basic Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rpc message-id="201" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <edit-config>
    <target>
      <candidate/>
    </target>
    <config>
      <bgp xmlns="http://openconfig.net/yang/bgp">
        <global>
          <config>
            <as>65001</as>
            <router-id>10.0.0.1</router-id>
          </config>
          <afi-safis>
            <afi-safi>
              <afi-safi-name xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:IPV4_UNICAST</afi-safi-name>
              <config>
                <afi-safi-name xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:IPV4_UNICAST</afi-safi-name>
                <enabled>true</enabled>
              </config>
            </afi-safi>
          </afi-safis>
        </global>
        <peer-groups>
          <peer-group>
            <peer-group-name>EBGP-PEERS</peer-group-name>
            <config>
              <peer-group-name>EBGP-PEERS</peer-group-name>
              <peer-as>65002</peer-as>
              <peer-type xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:EXTERNAL</peer-type>
            </config>
          </peer-group>
        </peer-groups>
        <neighbors>
          <neighbor>
            <neighbor-address>192.168.1.1</neighbor-address>
            <config>
              <neighbor-address>192.168.1.1</neighbor-address>
              <peer-group>EBGP-PEERS</peer-group>
              <enabled>true</enabled>
            </config>
          </neighbor>
        </neighbors>
      </bgp>
    </config>
  </edit-config>
</rpc>
```

### OpenConfig State Query

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rpc message-id="202" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <get>
    <filter type="subtree">
      <bgp xmlns="http://openconfig.net/yang/bgp">
        <global>
          <state>
            <as/>
            <router-id/>
          </state>
        </global>
        <neighbors>
          <neighbor>
            <neighbor-address>192.168.1.1</neighbor-address>
            <state>
              <session-state/>
              <established-transitions/>
            </state>
          </neighbor>
        </neighbors>
      </bgp>
    </filter>
  </get>
</rpc>
```

### OpenConfig State Response

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rpc-reply message-id="202" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <data>
    <bgp xmlns="http://openconfig.net/yang/bgp">
      <global>
        <state>
          <as>65001</as>
          <router-id>10.0.0.1</router-id>
          <total-paths>15420</total-paths>
          <total-prefixes>8942</total-prefixes>
        </state>
      </global>
      <neighbors>
        <neighbor>
          <neighbor-address>192.168.1.1</neighbor-address>
          <state>
            <neighbor-address>192.168.1.1</neighbor-address>
            <peer-group>EBGP-PEERS</peer-group>
            <enabled>true</enabled>
            <peer-as>65002</peer-as>
            <session-state xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:ESTABLISHED</session-state>
            <established-transitions>3</established-transitions>
            <messages>
              <sent>
                <UPDATE>245</UPDATE>
                <KEEPALIVE>1440</KEEPALIVE>
              </sent>
              <received>
                <UPDATE>8942</UPDATE>
                <KEEPALIVE>1438</KEEPALIVE>
              </received>
            </messages>
          </state>
        </neighbor>
      </neighbors>
    </bgp>
  </data>
</rpc-reply>
```

## Key XML Structure Differences

| Aspect | Nokia | OpenConfig |
|--------|--------|------------|
| **Root Path** | `/state/router/bgp` | `/bgp` |
| **Namespace** | `urn:nokia.com:sros:ns:yang:sr:state` | `http://openconfig.net/yang/bgp` |
| **Operations** | `get` only | `get`, `edit-config` |
| **Config/State** | State only | Separate config/state containers |
| **Peer Groups** | Under main BGP | Separate peer-groups container |
| **Address Families** | `family/ipv4/unicast` | `afi-safi-name="IPV4_UNICAST"` |

## Usage Patterns

### Nokia Model Usage
- **Monitoring**: Operational state monitoring
- **Read-only**: No configuration operations
- **Group-focused**: Rich group-based organization

### OpenConfig Model Usage  
- **Configuration**: Full BGP configuration management
- **Standards-based**: Vendor-neutral approach
- **Modular**: Clean separation of concerns

---

*For more complex examples and detailed analysis, see the incompatibility examples in the next section.*
