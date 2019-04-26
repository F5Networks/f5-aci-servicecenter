Install and Uninstall
=====================

Install F5 ACI ServiceCenter 
----------------------------

1. Log in to the APIC.

2. Click the Apps tab.

3. Click the upload icon in the top right corner.

4. Select the F5 ACI ServiceCenter .aci package from the file browser.

5. Click :guilabel:`Upload`.

6. After the upload completes, enable the app by clicking :guilabel:`Enable`.
   
   Do not change the security domain that is selected by default.

7. After the app is enabled, to open and access it, click :guilabel:`Open`.


Add a new BIG-IP device (Device Login)
--------------------------------------

1. In the top left of the F5 ACI ServiceCenter, click :guilabel:`+ NEW DEVICE`. A login prompt appears.

2. Enter the BIG-IP device credentials.

3. The newly-added device is displayed under the left menu bar.

   - If the device is standalone, it is visible under :guilabel:`Standalone BIG-IP Devices`.

   - If the device is part of a highly-available (HA) pair, the F5 ACI ServiceCenter prompts for a cluster name. After you enter a cluster name, the device and its peer are added under the cluster name on the left menu bar. The peer device is in a logged-out state and you must log in to it separately.

4. Log in to the BIG-IP device. The device hostname, redundancy state, and config sync state are displayed at the top of the page, along with three tabs: Visibility, L2-L3 Stitching, and L4-L7 Configuration.

.. note::
   
   - If you create an HA pair from two BIG-IP devices in the F5 ACI ServiceCenter, you must log out of the BIG-IP device in the F5 ACI ServiceCenter. When you log back in, the F5 ACI ServiceCenter moves the device and its peer under the cluster name in the left menu bar.

   - If you change the configuration so the BIG-IP devices are no longer part of an HA pair, you must log out of the device from within the F5 ACI ServiceCenter, then log back in for the F5 ACI ServiceCenter to recognize the changes and remove the cluster. The devices are then displayed under Standalone BIG-IP Devices.


Log out of a BIG-IP device
--------------------------

1. Click the BIG-IP device host name or IP on the menu bar on the left.

2. In the top right, click :guilabel:`Log Out`.

3. After you log out, you should see the login page again.

Delete a BIG-IP device
----------------------

1. Log out of the BIG-IP device.

2. On the left menu bar, hover over the BIG-IP device Hostname/IP.

3. Click the X to delete this device from the F5 ACI ServiceCenter.

Uninstall F5 ACI ServiceCenter 
------------------------------

1. Log in to the APIC.

2. Click the Apps tab.

3. Click X to disable the F5 ACI ServiceCenter.

4. Click X again to delete the F5 ACI ServiceCenter.


Reinstall F5 ACI ServiceCenter
------------------------------

When you uninstall the F5 ACI ServiceCenter, the data from the database is removed, and VLANs, self IPs, routes, and the BIG-IP device list are no longer available. If you reinstall the ACI ServiceCenter, it cannot retrieve the application data.

However, if the VLANs and self IPs, which were created through the F5 ACI ServiceCenter, are still intact on the corresponding BIG-IP devices, you can click :guilabel:`Out-of-sync` to view your resources and sync them back to the F5 ACI ServiceCenter, and the application database is rebuilt.

.. note::
   You might encounter L2-L3 operation errors due to BIG-IP's existing configuration. If you do, use `Sync Workflows <https://clouddocs.f5networks.net/f5-aci-servicecenter/latest/l2-l3.html#sync-tasks>`_ wherever applicable. If errors persist, delete the VLAN, self IP, and route entries from the BIG-IP device by logging in to the BIG-IP Configuration utility directly (rather than using the F5 ACI ServiceCenter).