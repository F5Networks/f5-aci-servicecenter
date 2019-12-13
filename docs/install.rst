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
   
   
Upgrade
=======
Upgrade F5 ACI ServiceCenter from v1.0 to v2.0+
-----------------------------------------------
Upgrade from v1.0 to v2.0+ is not supported. Users can manually uninstall and re-install the higher version (Data will not be retained).

Upgrade F5 ACI ServiceCenter from v2.0 to v2.1+
-----------------------------------------------
APIC 4.1(1k) 

  1. F5 ACI ServiceCenter v2 should already be running on APIC version 4.1(1k)
  
  2. Close the application UI tab. 
  
  3. APIC --> Apps tab shows the F5 ACI ServiceCenter app. 
  
  4. Click on the :guilabel:`Upgrade` icon in the top right corner. This opens a file browser. 
  
  5. Select the F5Networks-F5ACIServiceCenter-2.1.aci or any other higher version which has been downloaded from appcenter https://dcappcenter.cisco.com/ 
  
  6. APIC will upgrade the application from v2.0 to v2.1+ version and also retain the database. 
  
  7. Please open the app and check whether the added BIG-IP devices list is visible. User will have to re-login to the BIG-IP devices using the upgraded app.
 

APIC 3.2(7f)+ (All supported 3.2.X versions)

  1. APIC 3.2.X versions do not support application upgrades. Hence a manual backup of the database is required as mentioned in the steps below.
  
  2. SSH into the APIC server which has the F5 ACI ServiceCenter app container running.
  
  3. cd /data2/gluster/gv0/F5Networks_F5ACIServiceCenter
  
  4. Copy out the f5.db file from this location to your local system to create the database backup.
  
  5. Uninstall the current app and re-install the F5 ACI ServiceCenter v2.1+ as specified in the installation steps.
  
  6. Open the new upgraded version of the app. Click the drop-down --> Import DB on the top right corner of F5 ACI ServiceCenter.
  
  7. Select the f5.db file from your local system which you saved in step 4. and click Submit.
  
  8. The application restores the selected database file and the upgrade process is complete.
  
.. note::
   The APIC on which the ap container is running can be found by going to System --> Controllers --> Controllers --> (APIC name) --> Containers and checking if the F5Networks_F5ACIServiceCenter container is present.
 
 
Database Export and Import (Supported in v2.1+)
===============================================

Export DB
---------

1. Open F5 ACI ServiceCenter.

2. Click on the drop-down menu in top-right corner.

3. Click on Export DB. This will save a zip file with f5.db file inside it, on your local system. You can use this option to backup the database at any point in time.


Import DB
---------

1. Open F5 ACI ServiceCenter.

2. Click on the drop-down menu in top-right corner.
 
3. Click on Import DB. This opens a file browser dialog box. Select one of the previously saved F5 ACI ServiceCenter database files of interest. 

4. Your current database will be completely replaced by this new database file. Hence this operation should only be done in case of application upgrades, otherwise you might lose your app data. 
