Before You Install
==================

Before you install the F5 ACI ServiceCenter, read the following information:

- To enable and use the L4-L7 Configuration tab, use the BIG-IP Configuration utility to install the f5-appsvcs package version 3.19.1+ on the BIG-IP. Follow the installation steps from https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html
- To enable and view discovered devices in FASC left side pane, enable LLDP on both BIG-IP as well as on APIC and make sure management IP of the BIG-IP is present in the LLDP attributes on BIG-IP(Network->Interfaces->Interfaces List -> <<interface_id>>).
- You must use APIC GUI to add a logical device. The F5 ACI ServiceCenter does not provide this functionality.
- For each BIG-IP device added to the F5 ACI ServiceCenter, only one BIG-IP user can log in at a time.
- Multiple APIC admin users will see the same view of the app (the same list of BIG-IP devices with the same application data).
- All BIG-IP devices added to the F5 ACI ServiceCenter should have https support.
- To view the Virtual Server statistics on the Visibility VIP Dashboard, you must install the Telemetry Streaming plugin version 1.17 or higher on the BIG-IP device.
 - Follow the installation steps from https://clouddocs.f5.com/products/extensions/f5-telemetry-streaming/latest/installation.html
 - Create a default pull consumer configuration via a POST request to the BIG-IP. Follow the TS post configuration from ***Visibility Tab F5 ACI ServiceCenter*** section from this user guide.
- User must have admin privileges to APIC and should be part of default security domain for proper functioning of FASC.

|

|

