# NETCONF Sample Requests

This directory contains sample NETCONF requests demonstrating BGP configuration using different YANG models.

## Files

### OpenConfig BGP Configuration
- **File**: `openconfig-bgp-config.xml`
- **Description**: Sample NETCONF edit-config request using OpenConfig BGP models
- **Features**:
  - Global BGP configuration (AS number, router-id)
  - IPv4 and IPv6 address family support
  - eBGP and iBGP neighbor configuration
  - Route reflector client configuration
  - Peer group templates with timers

### Nokia SROS BGP Configuration
- **File**: `nokia-bgp-config.xml`
- **Description**: Sample NETCONF edit-config request using Nokia SROS BGP models
- **Features**:
  - Router and BGP instance configuration
  - BGP groups for external and internal peers
  - Neighbor configuration with descriptions
  - Route reflector setup
  - Policy-based import/export configuration
  - BGP timers and administrative states

## Usage

These samples can be used with any NETCONF client to configure BGP on devices supporting the respective YANG models.

### Example with netconf-console (Python)
```bash
# For OpenConfig model
netconf-console --host <device-ip> --port 830 --user <username> --password <password> \
  --rpc openconfig-bgp-config.xml

# For Nokia SROS model  
netconf-console --host <device-ip> --port 830 --user <username> --password <password> \
  --rpc nokia-bgp-config.xml
```

### Example with ncclient (Python)
```python
from ncclient import manager

# Read the XML configuration
with open('openconfig-bgp-config.xml', 'r') as f:
    config = f.read()

# Connect and configure
with manager.connect(host='device-ip', port=830, username='user', password='pass') as m:
    result = m.edit_config(target='candidate', config=config)
    m.commit()
```

## Notes

- These samples use the `candidate` datastore. Commit the configuration after edit-config.
- Modify IP addresses, AS numbers, and other parameters to match your network topology.
- Ensure the target device supports the YANG models used in each sample.
- The Nokia sample assumes SROS 25.7 or later for full model compatibility.
- Some advanced features may require additional licensing or configuration on the target device.

## Related Documentation

- [BGP State Comparison](../models/bgp-state-comparison.md)
- [BGP Configuration Comparison](../models/bgp-config-comparison.md)
- [Nokia Models Overview](../models/nokia.md)
- [OpenConfig Models Overview](../models/openconfig.md)
