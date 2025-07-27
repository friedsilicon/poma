# Model Incompatibilities and Migration Challenges

This document provides side-by-side comparisons of Nokia and OpenConfig BGP models, highlighting key incompatibilities and migration challenges.

## Overview

When working with both Nokia and OpenConfig BGP models, several fundamental differences create incompatibilities that require careful consideration during migration or integration projects.

## 1. Address Family Naming Incompatibility

### Side-by-Side Comparison

| Address Family | Nokia YANG | OpenConfig YANG |
|----------------|------------|-----------------|
| **IPv4 Unicast** | `family/ipv4/unicast` | `afi-safi-name="IPV4_UNICAST"` |
| **IPv6 Unicast** | `family/ipv6/unicast` | `afi-safi-name="IPV6_UNICAST"` |
| **L3VPN IPv4** | `family/vpn-ipv4/unicast` | `afi-safi-name="L3VPN_IPV4_UNICAST"` |
| **EVPN** | `family/evpn` | `afi-safi-name="L2VPN_EVPN"` |

### NETCONF XML Examples

#### Nokia Address Family Configuration
```xml
<family xmlns="urn:nokia.com:sros:ns:yang:sr:state">
  <ipv4>
    <unicast>
      <advertise-inactive>false</advertise-inactive>
      <damping>true</damping>
    </unicast>
  </ipv4>
  <vpn-ipv4>
    <unicast>
      <advertise-inactive>false</advertise-inactive>
    </unicast>
  </vpn-ipv4>
  <evpn>
    <advertise-inactive>false</advertise-inactive>
  </evpn>
</family>
```

#### OpenConfig Address Family Configuration
```xml
<afi-safis xmlns="http://openconfig.net/yang/bgp">
  <afi-safi>
    <afi-safi-name xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:IPV4_UNICAST</afi-safi-name>
    <config>
      <afi-safi-name xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:IPV4_UNICAST</afi-safi-name>
      <enabled>true</enabled>
    </config>
    <ipv4-unicast>
      <config>
        <send-default-route>false</send-default-route>
      </config>
    </ipv4-unicast>
  </afi-safi>
  <afi-safi>
    <afi-safi-name xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:L3VPN_IPV4_UNICAST</afi-safi-name>
    <config>
      <afi-safi-name xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:L3VPN_IPV4_UNICAST</afi-safi-name>
      <enabled>true</enabled>
    </config>
  </afi-safi>
</afi-safis>
```

### Migration Challenge
**Problem**: Direct mapping impossible due to different naming conventions and structures.
**Solution**: Require mapping tables and transformation logic.

## 2. Peer Group Structure Incompatibility

### Side-by-Side Comparison

#### Nokia: Groups Under BGP Container
```
state/router/bgp/
├── group* [group-name]
│   ├── type?                   # external/internal
│   ├── peer-as?               # uint32
│   ├── neighbor* [ip-address] # neighbors under group
│   └── family/                # AF config under group
```

#### OpenConfig: Separate Containers
```
bgp/
├── peer-groups/
│   └── peer-group* [peer-group-name]
│       ├── config/
│       └── afi-safis/         # AF config under peer-group
└── neighbors/
    └── neighbor* [neighbor-address]
        ├── config/
        │   └── peer-group?    # reference to peer-group
        └── afi-safis/         # can override peer-group AF config
```

### NETCONF XML Examples

#### Nokia Peer Group and Neighbor
```xml
<bgp xmlns="urn:nokia.com:sros:ns:yang:sr:state">
  <group>
    <group-name>EBGP-PEERS</group-name>
    <type>external</type>
    <peer-as>65002</peer-as>
    <family>
      <ipv4>
        <unicast>
          <advertise-inactive>false</advertise-inactive>
        </unicast>
      </ipv4>
    </family>
    <!-- Neighbors are directly under the group -->
    <neighbor>
      <ip-address>192.168.1.1</ip-address>
      <admin-state>enable</admin-state>
      <session-state>established</session-state>
    </neighbor>
    <neighbor>
      <ip-address>192.168.1.2</ip-address>
      <admin-state>enable</admin-state>
      <session-state>idle</session-state>
    </neighbor>
  </group>
</bgp>
```

#### OpenConfig Peer Group and Neighbors
```xml
<bgp xmlns="http://openconfig.net/yang/bgp">
  <!-- Separate peer-groups container -->
  <peer-groups>
    <peer-group>
      <peer-group-name>EBGP-PEERS</peer-group-name>
      <config>
        <peer-group-name>EBGP-PEERS</peer-group-name>
        <peer-as>65002</peer-as>
        <peer-type xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:EXTERNAL</peer-type>
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
    </peer-group>
  </peer-groups>
  
  <!-- Separate neighbors container with references -->
  <neighbors>
    <neighbor>
      <neighbor-address>192.168.1.1</neighbor-address>
      <config>
        <neighbor-address>192.168.1.1</neighbor-address>
        <peer-group>EBGP-PEERS</peer-group>  <!-- Reference to peer-group -->
        <enabled>true</enabled>
      </config>
      <state>
        <session-state xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:ESTABLISHED</session-state>
      </state>
    </neighbor>
    <neighbor>
      <neighbor-address>192.168.1.2</neighbor-address>
      <config>
        <neighbor-address>192.168.1.2</neighbor-address>
        <peer-group>EBGP-PEERS</peer-group>  <!-- Reference to peer-group -->
        <enabled>true</enabled>
      </config>
      <state>
        <session-state xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:IDLE</session-state>
      </state>
    </neighbor>
  </neighbors>
</bgp>
```

### Migration Challenge
**Problem**: Fundamental structural difference in how neighbors relate to groups.
**Solution**: Requires restructuring data relationships during conversion.

## 3. Configuration vs State Model Incompatibility

### Side-by-Side Comparison

#### Nokia: State-Only Model
```xml
<!-- Nokia: Only GET operations supported -->
<rpc message-id="101" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <get>
    <filter type="subtree">
      <state xmlns="urn:nokia.com:sros:ns:yang:sr:state">
        <router>
          <bgp>
            <!-- READ-ONLY operational state -->
            <autonomous-system/>  <!-- Current AS number -->
            <group>
              <group-name>PEERS</group-name>
              <admin-state/>      <!-- Current admin state -->
              <connection-state/> <!-- Current connection state -->
            </group>
          </bgp>
        </router>
      </state>
    </filter>
  </get>
</rpc>
```

#### OpenConfig: Config/State Separation
```xml
<!-- OpenConfig: Configuration with edit-config -->
<rpc message-id="201" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <edit-config>
    <target><candidate/></target>
    <config>
      <bgp xmlns="http://openconfig.net/yang/bgp">
        <global>
          <config>
            <as>65001</as>        <!-- INTENDED configuration -->
            <router-id>10.0.0.1</router-id>
          </config>
        </global>
        <neighbors>
          <neighbor>
            <neighbor-address>192.168.1.1</neighbor-address>
            <config>
              <enabled>true</enabled>  <!-- INTENDED state -->
            </config>
          </neighbor>
        </neighbors>
      </bgp>
    </config>
  </edit-config>
</rpc>

<!-- OpenConfig: State retrieval with get -->
<rpc message-id="202" xmlns="urn:ietf:params:xml:ns:netconf:base:1.0">
  <get>
    <filter type="subtree">
      <bgp xmlns="http://openconfig.net/yang/bgp">
        <global>
          <state>
            <as/>                 <!-- OPERATIONAL state -->
            <router-id/>
          </state>
        </global>
        <neighbors>
          <neighbor>
            <neighbor-address>192.168.1.1</neighbor-address>
            <state>
              <session-state/>    <!-- OPERATIONAL state -->
            </state>
          </neighbor>
        </neighbors>
      </bgp>
    </filter>
  </get>
</rpc>
```

### Migration Challenge
**Problem**: Nokia provides only operational state; OpenConfig expects configuration intent.
**Solution**: Cannot directly configure Nokia via YANG - requires separate configuration mechanism.

## 4. Vendor-Specific Features Incompatibility

### Nokia-Only Features

#### Nokia Origin Validation
```xml
<group xmlns="urn:nokia.com:sros:ns:yang:sr:state">
  <group-name>EBGP-PEERS</group-name>
  <origin-validation>
    <enabled>true</enabled>
    <send-validity>true</send-validity>
  </origin-validation>
</group>
```

#### Nokia Flowspec
```xml
<group xmlns="urn:nokia.com:sros:ns:yang:sr:state">
  <group-name>FLOWSPEC-PEERS</group-name>
  <flowspec>
    <enabled>true</enabled>
    <validate>true</validate>
  </flowspec>
</group>
```

### OpenConfig Equivalent: Not Available
```xml
<!-- OpenConfig has NO equivalent for these Nokia features -->
<peer-group xmlns="http://openconfig.net/yang/bgp">
  <peer-group-name>EBGP-PEERS</peer-group-name>
  <!-- origin-validation: NOT SUPPORTED -->
  <!-- flowspec: NOT SUPPORTED -->
</peer-group>
```

### OpenConfig-Only Features

#### OpenConfig SR-TE Policies
```xml
<afi-safis xmlns="http://openconfig.net/yang/bgp">
  <afi-safi>
    <afi-safi-name xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:SRTE_POLICY_IPV4</afi-safi-name>
    <config>
      <afi-safi-name xmlns:oc-bgp-types="http://openconfig.net/yang/bgp-types">oc-bgp-types:SRTE_POLICY_IPV4</afi-safi-name>
      <enabled>true</enabled>
    </config>
  </afi-safi>
</afi-safis>
```

### Nokia Equivalent: Not Available
```xml
<!-- Nokia model has NO direct equivalent for SR-TE policy AFI/SAFI -->
<family xmlns="urn:nokia.com:sros:ns:yang:sr:state">
  <!-- srte-policy: NOT SUPPORTED as separate AF -->
  <segment-routing>
    <!-- Different Nokia-specific SR implementation -->
  </segment-routing>
</family>
```

### Migration Challenge
**Problem**: Feature parity gaps in both directions.
**Solution**: Feature mapping tables and alternative implementations required.

## 5. Statistics and Monitoring Incompatibility

### Side-by-Side Comparison

#### Nokia: Rich Statistics
```xml
<statistics xmlns="urn:nokia.com:sros:ns:yang:sr:state">
  <total-paths>15420</total-paths>
  <total-paths-used>12833</total-paths-used>
  <total-prefixes>8942</total-prefixes>
  <total-prefixes-used>7891</total-prefixes-used>
  <memory-used>52428800</memory-used>          <!-- Nokia-specific -->
  <active-peers>145</active-peers>             <!-- Nokia-specific -->
  <established-peers>142</established-peers>    <!-- Nokia-specific -->
</statistics>
```

#### OpenConfig: Basic Counters
```xml
<state xmlns="http://openconfig.net/yang/bgp">
  <total-paths>15420</total-paths>
  <total-prefixes>8942</total-prefixes>
  <!-- memory-used: NOT AVAILABLE -->
  <!-- active-peers: NOT AVAILABLE -->  
  <!-- established-peers: NOT AVAILABLE -->
</state>
```

### Migration Challenge
**Problem**: Nokia provides richer operational data than OpenConfig standard.
**Solution**: Some operational insights lost when migrating to OpenConfig-only monitoring.

## Summary of Migration Challenges

| Challenge | Impact | Mitigation Strategy |
|-----------|--------|-------------------|
| **Address Family Naming** | High | Create mapping tables and transformation logic |
| **Peer Group Structure** | High | Restructure data relationships during conversion |
| **Config vs State Model** | Critical | Use separate configuration mechanisms for Nokia |
| **Vendor-Specific Features** | Medium | Feature gap analysis and alternative implementations |
| **Statistics Granularity** | Low | Accept reduced monitoring granularity or use vendor extensions |

## Recommended Migration Approach

1. **Hybrid Architecture**: Use both models during transition
2. **Feature Mapping**: Document equivalent and missing features
3. **Data Transformation**: Implement bidirectional transformation logic
4. **Monitoring Strategy**: Plan for operational data differences
5. **Testing**: Extensive validation of transformed configurations

---

*This analysis demonstrates why direct model-to-model migration is complex and requires careful planning and custom transformation logic.*
