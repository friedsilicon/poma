# BGP State Model Comparison: Nokia vs OpenConfig

This document provides a detailed comparison between Nokia SROS and OpenConfig BGP state models for operational monitoring and telemetry.

## Overview

| Aspect | Nokia SROS 25.7 | OpenConfig |
|--------|------------------|------------|
| **Model Type** | Vendor-specific operational state | Vendor-neutral operational state |
| **Primary Model** | `nokia-state-router-bgp.yang` | `openconfig-bgp.yang` |
| **Architecture** | Submodule of main Nokia state tree | Standalone with modular imports |
| **Standards** | Nokia SROS-specific extensions | IETF + OpenConfig standards |

## Model Structure Comparison

### Nokia BGP State Model
```
nokia-state-router-bgp (submodule)
├── belongs-to: nokia-state
├── router/
│   └── bgp/
│       ├── neighbor/          # BGP neighbor state
│       ├── group/             # BGP peer group state  
│       ├── rib/               # Routing table state
│       ├── statistics/        # BGP statistics
│       └── policy/            # Applied policy state
```

### OpenConfig BGP State Model
```
openconfig-bgp
├── bgp/
│   ├── global/                # Global BGP state
│   │   ├── state/
│   │   ├── afi-safis/
│   │   └── graceful-restart/
│   ├── neighbors/             # Neighbor state
│   │   └── neighbor[]/
│   │       ├── state/
│   │       ├── timers/
│   │       └── afi-safis/
│   └── peer-groups/           # Peer group state
│       └── peer-group[]/
```

## Key State Categories

### 1. Global BGP State

#### Nokia SROS
```yang
// Path: /state/router/bgp
container bgp {
    leaf router-id;
    leaf local-as;
    leaf admin-state;
    leaf oper-state;
    container statistics {
        leaf total-paths;
        leaf total-prefixes;
        // Nokia-specific counters
    }
}
```

#### OpenConfig
```yang
// Path: /bgp/global/state
container state {
    leaf as;
    leaf router-id;
    leaf total-paths;
    leaf total-prefixes;
    // Standard operational counters
}
```

**Key Differences:**
- Nokia: Includes admin-state/oper-state distinction
- OpenConfig: Focuses on operational data only
- Nokia: More detailed Nokia-specific statistics
- OpenConfig: Standardized cross-vendor counters

### 2. Neighbor State

#### Nokia SROS
```yang
container neighbor {
    list neighbor {
        key "ip-address";
        leaf ip-address;
        leaf peer-as;
        leaf admin-state;
        leaf oper-state;
        leaf session-state;
        container statistics {
            leaf messages-sent;
            leaf messages-received;
            leaf prefixes-received;
            leaf prefixes-active;
            // Nokia-specific metrics
        }
    }
}
```

#### OpenConfig
```yang
container neighbors {
    list neighbor {
        key "neighbor-address";
        leaf neighbor-address;
        container state {
            leaf peer-as;
            leaf session-state;
            leaf established-transitions;
            leaf supported-capabilities;
        }
        container timers {
            container state {
                leaf uptime;
                leaf negotiated-hold-time;
            }
        }
    }
}
```

**Key Differences:**
- Nokia: Admin vs operational state separation
- OpenConfig: Combined operational state view
- Nokia: More granular statistics per neighbor
- OpenConfig: Standardized timer information

### 3. Address Family (AFI/SAFI) State

#### Nokia SROS
```yang
container family {
    list family {
        key "afi safi";
        leaf afi;
        leaf safi;
        leaf admin-state;
        leaf oper-state;
        container statistics {
            leaf prefixes-received;
            leaf prefixes-active;
            leaf prefixes-sent;
        }
    }
}
```

#### OpenConfig
```yang
container afi-safis {
    list afi-safi {
        key "afi-safi-name";
        leaf afi-safi-name;
        container state {
            leaf active;
        }
        container prefixes {
            container state {
                leaf received;
                leaf sent;
                leaf installed;
            }
        }
    }
}
```

## Monitoring Use Cases

### 1. Session Monitoring

| Capability | Nokia | OpenConfig | Notes |
|------------|-------|------------|-------|
| Session state | ✅ Enhanced | ✅ Standard | Nokia provides admin/oper separation |
| Uptime tracking | ✅ | ✅ | Both provide session uptime |
| State transitions | ✅ | ✅ | OpenConfig has standardized counter |
| Flap detection | ✅ Nokia-specific | ✅ Standard | Different approaches |

### 2. Route Monitoring

| Capability | Nokia | OpenConfig | Notes |
|------------|-------|------------|-------|
| Prefix counts | ✅ Detailed | ✅ Standard | Nokia more granular breakdown |
| RIB statistics | ✅ Per-table | ✅ Per-AFI | Different organization |
| Best path info | ✅ | ✅ | Both support best path tracking |
| Route origin | ✅ Enhanced | ✅ Standard | Nokia provides more detail |

### 3. Performance Metrics

| Capability | Nokia | OpenConfig | Notes |
|------------|-------|------------|-------|
| Message counters | ✅ Comprehensive | ✅ Standard | Nokia more detailed |
| Error tracking | ✅ Nokia-specific | ✅ Standard | Different error categorization |
| Queue statistics | ✅ | ⚠️ Limited | Nokia provides more queue details |
| Memory usage | ✅ | ⚠️ Limited | Nokia-specific memory tracking |

## Data Collection Examples

### Nokia SROS State Query
```bash
# Get BGP neighbor state
pyang -f tree --tree-path /state/router/bgp/neighbor \
  nokia/bgp/nokia-state-router-bgp.yang

# Example telemetry path
/state/router[router-name="Base"]/bgp/neighbor[ip-address="192.168.1.1"]/statistics
```

### OpenConfig State Query
```bash
# Get BGP neighbor state  
pyang -f tree --tree-path /bgp/neighbors \
  openconfig/bgp/openconfig-bgp.yang

# Example telemetry path
/bgp/neighbors/neighbor[neighbor-address="192.168.1.1"]/state
```

## Telemetry Integration

### Nokia SROS
- **Protocol**: gNMI, NETCONF, Nokia MDM
- **Encoding**: JSON, XML, GPB
- **Streaming**: Subscription-based with Nokia extensions
- **Path Style**: Nokia-specific hierarchical paths

### OpenConfig  
- **Protocol**: gNMI (primary), NETCONF
- **Encoding**: JSON, GPB (protobuf)
- **Streaming**: Standard gNMI subscriptions
- **Path Style**: OpenConfig standardized paths

## Migration Considerations

### From Nokia to OpenConfig
```yaml
# Nokia path mapping to OpenConfig
Nokia: /state/router/bgp/neighbor[ip-address="X"]/session-state
OpenConfig: /bgp/neighbors/neighbor[neighbor-address="X"]/state/session-state

Nokia: /state/router/bgp/statistics/total-prefixes  
OpenConfig: /bgp/global/state/total-prefixes
```

### Advantages of Each Approach

#### Nokia SROS State Models
- ✅ **Rich operational detail**: More granular statistics and state information
- ✅ **Admin vs operational**: Clear separation of configured vs actual state  
- ✅ **Nokia-specific features**: Access to SROS-specific BGP capabilities
- ✅ **Integrated monitoring**: Part of comprehensive Nokia state tree
- ❌ **Vendor lock-in**: Nokia-specific paths and data structures

#### OpenConfig State Models  
- ✅ **Vendor neutrality**: Same model works across multiple vendors
- ✅ **Industry standard**: Widely adopted in network automation
- ✅ **Simplified integration**: Consistent across different vendors
- ✅ **Tool ecosystem**: Better tooling and community support
- ❌ **Less detail**: May lack vendor-specific operational insights

## Recommendations

### Use Nokia State Models When:
- Deep operational visibility into Nokia SROS needed
- Nokia-specific features and statistics required
- Single-vendor environment with Nokia expertise
- Advanced troubleshooting and performance analysis needed

### Use OpenConfig State Models When:
- Multi-vendor environment requiring consistency
- Network automation across different platforms
- Integration with OpenConfig-based tools
- Industry-standard telemetry pipelines preferred

## Conclusion

Both models serve different operational needs:
- **Nokia models** provide deeper, SROS-specific operational visibility
- **OpenConfig models** offer standardized, cross-vendor operational monitoring

Choose based on your operational requirements: depth vs standardization.
