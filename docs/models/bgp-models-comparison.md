# BGP Root Tree Analysis - Nokia vs OpenConfig

## Overview

This document provides a comparative analysis of the BGP root tree structures between Nokia SROS and OpenConfig BGP YANG models.

## Nokia BGP Root Structure

**Source**: `nokia-state-router-bgp.yang`
**Main Container**: `/state/router/bgp`

### Key Structure
```
state/
├── router/
    └── bgp/
        ├── autonomous-system?          uint32
        ├── router-id?                  yang:dotted-quad
        ├── graceful-restart-enabled?   boolean
        ├── multipath-ebgp-enabled?     boolean
        ├── multipath-ibgp-enabled?     boolean
        ├── dynamic-neighbor/
        │   └── interface* [interface-name]
        ├── group* [group-name]
        │   ├── type?                   group-type
        │   ├── admin-state?            admin-state
        │   ├── peer-as?                uint32
        │   ├── local-as?               local-as-union
        │   ├── local-address?          yang:ip-address
        │   ├── family/
        │   │   ├── evpn
        │   │   ├── ipv4
        │   │   ├── ipv6
        │   │   ├── label-ipv4
        │   │   ├── label-ipv6
        │   │   ├── mcast-ipv4
        │   │   ├── vpn-ipv4
        │   │   └── vpn-ipv6
        │   ├── import/
        │   ├── export/
        │   ├── next-hop-self?          boolean
        │   ├── remove-private-as/
        │   ├── cluster/
        │   ├── confederation/
        │   ├── graceful-restart/
        │   ├── keepalive?              uint32
        │   ├── hold-time?              uint32
        │   ├── connect-retry?          uint32
        │   ├── min-route-advertisement? uint32
        │   ├── damping?                boolean
        │   ├── preference?             uint32
        │   ├── loop-detect?            loop-detect-option
        │   ├── advertise-inactive?     boolean
        │   ├── rapid-withdrawal?       boolean
        │   ├── rapid-update/
        │   ├── peer-tracking?          boolean
        │   ├── disable-client-reflect? boolean
        │   ├── disable-communities?    boolean
        │   ├── remove-private-as/
        │   ├── bfd-liveness?           boolean
        │   ├── authentication-key?    string
        │   ├── tcp-mss?                uint32
        │   ├── passive?                boolean
        │   ├── multihop?               uint32
        │   ├── local-preference?       uint32
        │   ├── med-out?                med-out-union
        │   ├── enforce-first-as?       boolean
        │   ├── aigp-metric?            boolean
        │   ├── disable-fast-external-failover? boolean
        │   ├── disable-capabilities-negotiation? boolean
        │   ├── ttl-security?           uint32
        │   ├── split-horizon?          boolean
        │   ├── origin-validation/
        │   ├── flowspec/
        │   ├── send-default/
        │   ├── segment-routing/
        │   ├── add-paths/
        │   ├── best-path-selection/
        │   ├── error-handling/
        │   ├── prefix-limit/
        │   ├── orf/
        │   ├── long-lived-graceful-restart/
        │   └── neighbor* [ip-address]
        └── statistics/
            ├── total-paths?            uint32
            ├── total-paths-used?       uint32
            ├── total-prefixes?         uint32
            ├── total-prefixes-used?    uint32
            └── memory-used?            uint32
```

### Nokia BGP Features
- **Comprehensive Group Management**: Rich peer group configuration with inheritance
- **Nokia-Specific Features**: Origin validation, flowspec, segment routing, long-lived graceful restart
- **Address Family Support**: IPv4/IPv6 unicast, labeled unicast, VPN, multicast, EVPN
- **Operational Statistics**: Detailed memory usage and path statistics
- **State-focused Model**: Read-only operational state data

## OpenConfig BGP Root Structure

**Source**: `openconfig-bgp.yang`
**Main Grouping**: `bgp-top`
**Main Container**: `bgp`

### Key Structure
```
bgp/
├── global/
│   ├── config/
│   │   ├── as           (required)
│   │   └── router-id?
│   ├── state/
│   │   ├── as
│   │   ├── router-id?
│   │   ├── total-paths?
│   │   └── total-prefixes?
│   ├── default-route-distance/
│   ├── confederation/
│   ├── graceful-restart/
│   ├── use-multiple-paths/
│   │   ├── ebgp/
│   │   │   ├── link-bandwidth-ext-community/
│   │   │   └── config/
│   │   │       ├── allow-multiple-as?
│   │   │       └── maximum-paths?
│   │   └── ibgp/
│   │       ├── link-bandwidth-ext-community/
│   │       └── config/
│   │           └── maximum-paths?
│   ├── route-selection-options/
│   ├── afi-safis/
│   │   └── afi-safi* [afi-safi-name]
│   │       ├── graceful-restart/
│   │       ├── route-selection-options/
│   │       ├── use-multiple-paths/
│   │       ├── add-paths/
│   │       ├── ipv4-unicast/
│   │       ├── ipv6-unicast/
│   │       ├── ipv4-labeled-unicast/
│   │       ├── ipv6-labeled-unicast/
│   │       ├── l3vpn-ipv4-unicast/
│   │       ├── l3vpn-ipv6-unicast/
│   │       ├── l3vpn-ipv4-multicast/
│   │       ├── l3vpn-ipv6-multicast/
│   │       ├── l2vpn-vpls/
│   │       ├── l2vpn-evpn/
│   │       ├── srte-policy-ipv4/
│   │       ├── srte-policy-ipv6/
│   │       └── apply-policy/
│   ├── dynamic-neighbor-prefixes/
│   └── apply-policy/
├── neighbors/
│   └── neighbor* [neighbor-address]
│       ├── config/
│       │   ├── peer-group?
│       │   ├── neighbor-address?
│       │   ├── neighbor-port?
│       │   ├── enabled?
│       │   ├── peer-as?
│       │   ├── local-as?
│       │   ├── peer-type?
│       │   ├── auth-password?
│       │   ├── remove-private-as?
│       │   ├── route-flap-damping?
│       │   ├── send-community-type*
│       │   └── description?
│       ├── state/
│       │   ├── (config items)
│       │   ├── session-state?
│       │   ├── last-established?
│       │   ├── established-transitions?
│       │   ├── supported-capabilities*
│       │   ├── messages/
│       │   ├── queues/
│       │   ├── dynamically-configured?
│       │   └── last-prefix-limit-exceeded?
│       ├── timers/
│       ├── transport/
│       ├── error-handling/
│       ├── graceful-restart/
│       ├── logging-options/
│       ├── ebgp-multihop/
│       ├── route-reflector/
│       ├── as-path-options/
│       ├── auto-link-bandwidth/
│       ├── use-multiple-paths/
│       ├── apply-policy/
│       ├── afi-safis/
│       └── enable-bfd/
├── peer-groups/
│   └── peer-group* [peer-group-name]
│       ├── config/
│       ├── state/
│       ├── timers/
│       ├── transport/
│       ├── error-handling/
│       ├── graceful-restart/
│       ├── logging-options/
│       ├── ebgp-multihop/
│       ├── route-reflector/
│       ├── as-path-options/
│       ├── auto-link-bandwidth/
│       ├── use-multiple-paths/
│       ├── apply-policy/
│       ├── afi-safis/
│       └── enable-bfd/
└── rib/
    ├── attr-sets/
    ├── communities/
    ├── ext-communities/
    └── afi-safis/
```

### OpenConfig BGP Features
- **Config/State Separation**: Clear distinction between configuration and operational data
- **Standardized Structure**: Consistent patterns across all configuration elements
- **Rich AFI/SAFI Support**: Comprehensive address family support including SR-TE policies
- **Policy Integration**: Built-in routing policy framework integration
- **BFD Integration**: Bidirectional Forwarding Detection support
- **Multi-path Configuration**: Detailed ECMP and load balancing options
- **BGP RIB Access**: Read-only access to BGP routing information base

## Side-by-Side Structural Comparison

### XML Namespace and Root Structure

| Aspect | Nokia BGP State | OpenConfig BGP |
|--------|-----------------|----------------|
| **XML Namespace** | `urn:nokia.com:sros:ns:yang:sr:state` | `http://openconfig.net/yang/bgp` |
| **Root Path** | `/state/router/bgp` | `/bgp` |
| **Model Type** | State-only (read-only) | Config/State separated |
| **NETCONF Ops** | `get` operations only | `get`, `edit-config`, `delete-config` |

### Neighbor Organization

| Aspect | Nokia Structure | OpenConfig Structure |
|--------|----------------|---------------------|
| **Peer Groups** | `bgp/group*[group-name]` | `bgp/peer-groups/peer-group*[peer-group-name]` |
| **Neighbors** | `bgp/group/neighbor*[ip-address]` | `bgp/neighbors/neighbor*[neighbor-address]` |
| **Group Reference** | Implicit (neighbors under group) | Explicit (`config/peer-group` reference) |
| **Inheritance** | Direct group membership | Template-based inheritance |

### Address Family Configuration

| Family Type | Nokia Path | OpenConfig Path |
|-------------|------------|-----------------|
| **IPv4 Unicast** | `group/family/ipv4/unicast` | `afi-safis/afi-safi[afi-safi-name="IPV4_UNICAST"]` |
| **L3VPN IPv4** | `group/family/vpn-ipv4/unicast` | `afi-safis/afi-safi[afi-safi-name="L3VPN_IPV4_UNICAST"]` |
| **EVPN** | `group/family/evpn` | `afi-safis/afi-safi[afi-safi-name="L2VPN_EVPN"]` |
| **IPv6 Labeled** | `group/family/label-ipv6` | `afi-safis/afi-safi[afi-safi-name="IPV6_LABELED_UNICAST"]` |

### Configuration vs Operational Data

| Data Type | Nokia Approach | OpenConfig Approach |
|-----------|----------------|-------------------|
| **Configuration Intent** | Not available (state-only) | `*/config/*` containers |
| **Operational State** | All data under `/state` | `*/state/*` containers |
| **Mixed Views** | N/A (state-only model) | Both config and state in same structure |
| **Configuration Management** | External (not via YANG) | Native YANG-based configuration |

## Key Differences

### Architectural Approach

| Aspect | Nokia | OpenConfig |
|--------|--------|------------|
| **Model Type** | State-focused (read-only) | Config/State separated |
| **Structure** | Hierarchical under router | Standalone BGP container |
| **Grouping** | Groups under main BGP container | Separate peer-groups container |
| **Inheritance** | Implicit through groups | Explicit through peer-group references |

### Feature Coverage

| Feature | Nokia | OpenConfig |
|---------|--------|------------|
| **Basic BGP** | ✅ Full | ✅ Full |
| **Address Families** | ✅ EVPN, VPN, Labeled | ✅ L3VPN, L2VPN, SR-TE |
| **Policy Framework** | ✅ Nokia-specific | ✅ OpenConfig routing-policy |
| **Statistics** | ✅ Detailed memory/path stats | ✅ Basic counters |
| **BFD Integration** | ✅ Basic liveness | ✅ Full configuration |
| **Graceful Restart** | ✅ Including long-lived GR | ✅ Standard GR |
| **Route Reflection** | ✅ With cluster support | ✅ Standard RR |
| **Multipath** | ✅ EBGP/IBGP flags | ✅ Detailed configuration |
| **Origin Validation** | ✅ Nokia-specific | ❌ Not present |
| **Flowspec** | ✅ Nokia-specific | ❌ Not present |
| **Segment Routing** | ✅ Nokia-specific | ✅ SR-TE policies |

### Address Family Naming

| Address Family | Nokia | OpenConfig |
|----------------|--------|------------|
| IPv4 Unicast | `ipv4` | `ipv4-unicast` |
| IPv6 Unicast | `ipv6` | `ipv6-unicast` |
| IPv4 Labeled | `label-ipv4` | `ipv4-labeled-unicast` |
| IPv6 Labeled | `label-ipv6` | `ipv6-labeled-unicast` |
| IPv4 VPN | `vpn-ipv4` | `l3vpn-ipv4-unicast` |
| IPv6 VPN | `vpn-ipv6` | `l3vpn-ipv6-unicast` |
| IPv4 Multicast | `mcast-ipv4` | `l3vpn-ipv4-multicast` |
| EVPN | `evpn` | `l2vpn-evpn` |
| VPLS | ❌ | `l2vpn-vpls` |
| SR-TE IPv4 | ❌ | `srte-policy-ipv4` |
| SR-TE IPv6 | ❌ | `srte-policy-ipv6` |

## Usage Patterns

### Nokia Model
- **Operational Focus**: Primarily for monitoring and troubleshooting
- **Group-Centric**: Configuration inheritance through group membership
- **Vendor-Specific**: Optimized for Nokia SROS features and terminology
- **Comprehensive Statistics**: Detailed operational metrics

### OpenConfig Model
- **Configuration Management**: Designed for configuration and state retrieval
- **Template-Based**: Peer groups as configuration templates
- **Vendor-Neutral**: Standardized across multiple vendors
- **Policy Integration**: Deep integration with routing policy framework

## Recommendations

1. **For Configuration Management**: Use OpenConfig for vendor-neutral configuration
2. **For Monitoring**: Nokia state model provides richer operational data
3. **For Multi-Vendor**: OpenConfig ensures consistency across platforms
4. **For Nokia-Specific Features**: Use Nokia model for origin validation, flowspec
5. **For Policy Management**: OpenConfig provides better policy framework integration

## Conclusion

Both models serve different purposes and have fundamental incompatibilities:

- **Nokia**: Operational state monitoring with vendor-specific features and rich statistics
- **OpenConfig**: Standardized configuration and state management with vendor-neutral approach

### Key Incompatibilities

1. **Structural Differences**: Different peer group organization and addressing family naming
2. **Operational Model**: Nokia state-only vs OpenConfig config/state separation  
3. **Feature Gaps**: Vendor-specific features not available in the other model
4. **Data Granularity**: Different levels of operational statistics and monitoring data

### Migration Complexity

Direct model-to-model migration is challenging due to:
- Incompatible XML structures requiring transformation logic
- Feature parity gaps requiring alternative implementations
- Different operational paradigms (state-only vs configuration management)

The choice depends on use case: operational monitoring vs. configuration management, vendor-specific vs. vendor-neutral requirements.

## Detailed Examples and Analysis

For comprehensive NETCONF XML examples and detailed incompatibility analysis, see:

- **[NETCONF XML Examples](../examples/netconf-xml-samples.md)** - Complete XML samples for both models
- **[Model Incompatibilities](../examples/model-incompatibilities.md)** - Side-by-side comparisons and migration challenges

---

## Analysis Tools

For generating detailed tree structures and performing ad-hoc analysis, temporary scripts and outputs are available in the `tmp/` directory:

- `tmp/analyze-openconfig-bgp.sh` - Comprehensive OpenConfig BGP analysis script
- `tmp/openconfig-bgp-tree-analysis.txt` - Full tree structure output (4987 lines)

These tools were used to generate the analysis in this document but are not part of the permanent toolset.
