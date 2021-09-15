Pre-requisites
==============

Pre-requisites for the F5 ACI ServiceCenter:

- F5 ACI ServiceCenter application should be a part of the default security domain for proper functioning.
- The Cisco APIC user accessing the App must have admin privileges to the APIC.
- All BIG-IP devices added to the F5 ACI ServiceCenter should have https support.
- To enable and use the L4-L7 App Services tab, use the BIG-IP Configuration utility to install the f5-appsvcs package version 3.19.1+ on the BIG-IP device. Follow the installation steps from https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html
- To enable and use basic subtab of the L4-L7 App Services tab, use the BIG-IP Configuration utility to install f5-appsvcs-templates package version 1.8.1+ on the BIG-IP device. Follow the installation steps from https://clouddocs.f5.com/products/extensions/f5-appsvcs-templates/latest/userguide/install-uninstall.html
- To view the Virtual Server statistics on the Visibility VIP Dashboard, you must install the Telemetry Streaming plugin version 1.17 or higher on the BIG-IP device. Follow the installation steps and the default pull consumer configuration details from https://clouddocs.f5.com/f5-aci-servicecenter/latest/navigate.html#configure-telemetry 
- To enable and view discovered devices in F5 ACI ServiceCenter, enable the LLDP protocol on both the BIG-IP as well as on the APIC. Make sure management IP of the BIG-IP is present in the LLDP attributes on BIG-IP(Network->Interfaces->Interfaces List-><interface_id>).
- To configure and manage the Cisco ACI fabric use the APIC GUI/API, example: to add a logical device, to add a end point group etc. The F5 ACI ServiceCenter has read-only privileges to the Cisco APIC.
- BIG-IP Plugin versions currently supported by the F5 ACI ServiceCenter:

  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | Package Version             | AS3 Version            | Telemetry Version              | FAST Version                          |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.5                         | 3.19.1+                | NA                             |  NA                                   |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.6                         | 3.19.1+                | NA                             |  NA                                   |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.7                         | 3.19.1+                | 1.17.0+                        |  NA                                   |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.8                         | 3.19.1+                | 1.17.0+                        |  1.8.1+                               |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+
  | 2.9                         | 3.19.1+                | 1.17.0+                        |  1.8.1+                               |
  +-----------------------------+------------------------+--------------------------------+---------------------------------------+


