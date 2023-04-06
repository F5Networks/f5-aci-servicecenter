Pre-requisites
==============

Pre-requisites for the F5 ACI ServiceCenter:

- F5 ACI ServiceCenter should be a part of the default security domain for proper functioning.
- Cisco APIC users who access F5 ACI ServiceCenter must have admin privileges to the Cisco APIC.
- All BIG-IP devices added to the F5 ACI ServiceCenter should have https support.
- To enable F5 ACI ServiceCenter L4-L7 Application Services tab, use the BIG-IP Configuration utility to install the latest version of AS3 (f5-appsvcs package) and FAST (f5-appsvcs-templates) on the BIG-IP device.
    - AS3 installation https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html
    - Fast Installation https://clouddocs.f5.com/products/extensions/f5-appsvcs-templates/latest/userguide/install-uninstall.html
- To view the Virtual Server statistics on the Visibility VIP Dashboard, you must install the Telemetry Streaming plugin version 1.17 or higher on the BIG-IP device. Follow the installation steps and the default pull consumer configuration details from https://clouddocs.f5.com/f5-aci-servicecenter/latest/navigate.html#configure-telemetry
- To allow self discovery of BIG-IP devices on F5 ACI ServiceCenter, enable LLDP protocol on BIG-IP devices and Cisco APIC.Make sure LLDP attribute ”Management Address” is present in the LLDP attributes send list on BIG-IP devices (Network->Interfaces->Interfaces List-><interface_id>).
- F5 ACI ServiceCenter has read-only privilege to the Cisco APIC.  To configure and manage the Cisco APIC, use the Cisco APIC GUI/API, example: use the Cisco APIC GUI/API to add a logical device or to add an endpoint group etc.
- The minimum BIG-IP Plugin versions supported by the F5 ACI ServiceCenter:

  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | Package Version             | AS3 Version            | Telemetry Version              | FAST Version                          |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.5 (deprecated)            | 3.19.1+                | NA                             |  NA                                   |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.6 (deprecated)            | 3.19.1+                | NA                             |  NA                                   |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.7 (deprecated)            | 3.19.1+                | 1.17.0+                        |  NA                                   |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.8 (deprecated)            | 3.19.1+                | 1.17.0+                        |  1.8.1+                               |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.9 (deprecated)            | 3.19.1+                | 1.17.0+                        |  1.8.1+                               |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.10                        | 3.19.1+                | 1.17.0+                        |  1.8.1+                               |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.11                        | 3.41.1+                | 1.17.0+                        |  1.9.1+                               |
  | 2.11.1                      |                        |                                |                                       |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+

Note:  It is recommended to always install the latest plugin version on the BIG-IP device.
