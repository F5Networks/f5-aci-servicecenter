Install and Uninstall
=====================

Install F5 ACI ServiceCenter 
----------------------------

1. Download F5 ACI ServiceCenter from https://dcappcenter.cisco.com/f5-aci-servicecenter.html

2. Log in to the APIC.

3. Click the Apps tab.

4. Click the upload icon in the top right corner.

5. Select the F5 ACI ServiceCenter .aci package from the file browser.

6. Click :guilabel:`Upload`.

7. After the upload completes, enable the app by clicking :guilabel:`Enable`.
   
   Do not change the security domain that is selected by default.

8. After the app is enabled, to open and access it, click :guilabel:`Open`.


Uninstall F5 ACI ServiceCenter 
------------------------------

1. Log in to the APIC.

2. Click the Apps tab.

3. Click the **Disable** icon to disable the F5 ACI ServiceCenter. This stops and removes the app container.

4. Click the **Delete** icon to uninstall the F5 ACI ServiceCenter.

.. note::

  - It is important to disable the F5 ACI ServiceCenter first and then delete it, in order to clean out all the filesystem folders related to the application. To check whether the deletion of the app has happened correctly, please check /data2/gluster/gv0/ folder and ensure that it does not contain F5Networks_F5ACIServiceCenter folder on any of the APIC nodes. Not disabling the app first may lead to 'InvalidPaddingError' errors when performing app operations.

  - If the error 'InvalidPaddingError' is observed, uninstall and re-install the application by following the aforementioned steps. If the database is to be retained, export the database, uninstall and re-install, and then import the database. For more details check the **Database Export and Import** section.

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

APIC 4.1(1k)+
-------------

1. F5 ACI ServiceCenter v2 should already be running on APIC version 4.1(1k)
  
2. Close the application UI tab. 
  
3. APIC --> Apps tab shows the F5 ACI ServiceCenter app. 
  
4. Click on the :guilabel:`Upgrade` icon in the top right corner. This opens a file browser. 
  
5. Select the F5Networks-F5ACIServiceCenter-2.1.aci or any other higher version which has been downloaded from appcenter https://dcappcenter.cisco.com/ 
  
6. APIC will upgrade the application from v2.0 to v2.1+ version and also retain the database. 
  
7. Open the app and check whether the added BIG-IP devices list is visible. The user will have to re-login to the BIG-IP devices using the upgraded app.
 

APIC 3.2(7f)+ (All supported 3.2.X versions)
--------------------------------------------

1. APIC 3.2.X versions do not support application upgrades. Hence a manual backup of the database is required as mentioned in the steps below.
  
2. SSH into the APIC server which has the F5 ACI ServiceCenter app container running.
  
3. Change directories using the following command: cd /data2/gluster/gv0/F5Networks_F5ACIServiceCenter
  
4. Copy the f5.db file from this location to your local system to create the database backup.
  
5. Uninstall the current app and re-install the F5 ACI ServiceCenter v2.1+ as specified in the installation steps.
  
6. Open the new upgraded version of the app. Click the drop-down --> Import DB on the top right corner of F5 ACI ServiceCenter.
  
7. Select the f5.db file from your local system which you saved in step 4 and then click Submit.
  
8. The application restores the selected database file and the upgrade process is complete.
  
.. note::
   The APIC on which the ap container is running can be found by going to System --> Controllers --> Controllers --> (APIC name) --> Containers and checking if the F5Networks_F5ACIServiceCenter container is present.
   
Adding/Deleting BIG-IP Devices in FASC
=======================================

Add a new BIG-IP device (Device Login)
--------------------------------------

1. In the top left of the F5 ACI ServiceCenter, click :guilabel:`+ NEW DEVICE`. A login prompt appears.

2. Enter the BIG-IP device credentials.

3. The newly-added device is displayed under the left menu bar.

   - If the device is standalone, it is visible under :guilabel:`Standalone BIG-IP Devices`.

   - If the device is part of a highly-available (HA) pair, the F5 ACI ServiceCenter prompts for a cluster name. After you enter a cluster name, the device and its peer are added under the cluster name on the left menu bar. The peer device is in a logged-out state and you must log in to it separately.
   
   - If the device is a part of an HA pair to which the user wants to login to using hostnames instead of IPs, there will be an additional prompt for peer BIG-IP's hostname and credentials. Once they are entered in the displayed form, both the devices will be logged-in from the F5 ACI ServiceCenter. 
   
   - The active device will be indicated using a Green icon. The standby device will be indicated using a Yellow icon. A logged out device or any device for which failover state cannot be determined will be displayed with a Gray icon. Any device for which the failover state is not Active OR Standby will be indicated with a Green icon.

4. Log in to the BIG-IP device. The device hostname, redundancy state, and config sync state are displayed at the top of the page, along with three tabs: Visibility, L2-L3 Stitching, and L4-L7 Configuration.

5. F5 ACI ServiceCenter (v2.9+) supports LDAP authentication for BIG-IP login. Admin LDAP users will be able to use all the features of the application.

.. note::
   
   - If you create an HA pair from two standalone BIG-IP devices in the F5 ACI ServiceCenter, you must log out of the BIG-IP device in the F5 ACI ServiceCenter UI. When you log back in, the F5 ACI ServiceCenter moves the device and its peer under the specified cluster name in the side menu bar.

   - If you change the configuration such that the BIG-IP devices are no longer part of an HA pair, you must log out of the device from within the F5 ACI ServiceCenter UI and log back in, for the F5 ACI ServiceCenter to recognize the changes and remove the cluster from the FASC UI. The devices are then displayed under Standalone BIG-IP Devices.
   
   - **Non-Admin** local as well as LDAP users can access F5 ACI ServiceCenter with limited access.


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

 
Self Discovery of BIG-IP Devices (Supported in v2.3+)
=====================================================

F5 ACI ServiceCenter displays all the discovered BIG-IPs attached to APIC fabric and adds them to "Discovered Devices" list on the left hand side menu. 

Users may click on any of the discovered devices and login to the device. Once login is successful the BIG-IP entry will shift to the appropriate section on the side menu namely Standalone or HA.  

.. note:: 

    - This feature does not discover VEs or vCMP guests but only Physical and vCMP hosts. 

    - In order for the BIG-IP devices to be discovered via LLDP protocol, LLDP needs to be enabled on the BIG-IPs as well as on APIC. To enable LLDP on BIG-IP:

      1. Log in to the BIG-IP.

      2. Click Interfaces → LLDP → General

      3. Select 'Enabled' for the LLDP property

      4. Click :guilabel:`Update`


View Global Topology
--------------------

1. Click on top right corner menu → Topology

2. A popup opens which displays a graphical view of all the BIG-IPs and their connectivity to ACI Leaf Switches.

.. note::

    - LLDP needs to be enabled on the BIG-IP for this topology view to be seen. 


View BIG-IP Connectivity
------------------------

1. Login to BIG-IP.

2. Click on any of the 3 tabs (Visibility OR L2-L3 Network Management or L4-L7 App Services).

3. Click on the topology icon with tooltip "View BIG-IP Connectivity".

4. A popup opens which displays a graphical view of this BIG-IP’s port connectivity to ACI Leaf Switches.

.. note::

   - LLDP needs to be enabled on the BIG-IP for this topology view to be seen.
   
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

------

Frequently Asked Questions (FAQ)
------------------------------------

**Q. Why do I see an error "Failed to reach the container" on the application GUI?**

The application back end is running as a Docker container on ACI’s APIC server. 

For legacy apps, the health-thread APIC checks the health of Gluster-FS (APIC filesystem). If it passes, it checks to ensure the app’s Docker container is able to access it's data folder under Gluster-FS. If it is not able, it restarts the application container. 

There are a few other reasons why the ACI app framework might restart an app’s backend container. In these cases, the application GUI will show the error "Failed to reach the container." 

After the container restarts, a new container runs the application’s back end. The application does a stateful restart and any data available before the restart should be available when the new container is launched. As a result, even though the application might be momentarily unavailable during the restart and show the error, it should recover gracefully. 

Expected downtime:

- If an APIC cluster size changes and the APIC cluster node - Hosting Application container - reboots, you can expect up to three minutes of downtime for the application. It takes three minutes for APIC cluster to bring up a new container on the other currently available APIC nodes. The same thing happens when the APIC node undergoes Commission/Decommission.

- If all APIC cluster nodes are rebooted accidentlly at the same time, it may take up to twenty minutes for the application to be up.

------

**Q. In the app, why do I see the error “BIG-IP session timed out. Please log in again.”?** (Only applicable to v1.0)

Every BIG-IP session on the app has an operation-idle time out of 10 minutes. If you do not carry out any operations on a BIG-IP session of the application for 10 minutes, you will see the above error. This timeout check is triggered only on tab switch, or on left-hand menu item click for logged in BIG-IP devices.

------

**Q. In the app, why do I see the error “ERROR : Request failed due to server side error” on APIC?**

If App UI is accessed from 2 parallel browser tabs with certificate warnings enabled from only one of the tabs, it may generate this error: “Error: Request failed due to server side error”

**Workaround:** Login to APIC again

------

**Q. For an app operation, why do I see a ConnectTimeout or Timeout error?**

All F5 ACI ServiceCenter operations in-turn perform REST API calls to BIG-IP or APIC. If any of those API calls take longer than 1 minute, the app will timeout those calls and display the timeout error on the UI.

**Workaround:** 1. Try the operation again. 2. Ensure that BIG-IP is up and responding properly to UI login. 

------

**Q. Why do I see a 'Request timeout' error on the F5 ACI ServiceCenter UI?**

The application UI may show the 'Request timeout' error, if the application or APIC is receiving a lot of traffic. You can retry the same operation that displayed the error and it should be successful after one or more retries. 

------

**Q. Why do I see the error "Error from BIG-IP: X-F5-Auth-Token does not exist" when performing a BIG-IP login from FASC app?**

If the version of BIG-IP has changed, and you attempt to re-login to the BIG-IP from the FASC app, you may see this error.

Workaround: Delete the BIG-IP from the FASC app UI and re-login to the BIG-IP.

------

**Q. How can I change the management port of a BIG-IP device which is already added in the F5 ACI ServiceCenter?**

Click the delete (X) icon next to the BIG-IP to delete it. Re-add the BIG-IP to F5 ACI ServiceCenter with the changed port (For example, from the default 443 to 8443). The BIG-IP data will still be retained after the delete and re-add.

------

**Q. F5 ACI SeviceCenter is taking longer time to respond or has hanged.**

If F5 ACI ServiceCenter UI is taking more than 3 minutes to display response, then check f5.log file, which may display a warning:
"Acquiring a bigipdict RWlock has taken more than 180  seconds. Executing reader_release() to unlock the lock". Once this warning is observed, F5 ACI ServiceCenter will resume the stuck operation become responsive again.

------

**Q. F5 ACI ServiceCenter throws ‘Database is locked’ error.**

If F5 ACI ServiceCenter throws database is locked error, then retry the operation that caused this error and the operation should proceed without errors.

------

**Q. What browsers are supported?**

The app has been tested with IE11, Mozilla FireFox 56 and Google Chrome v72.

------

**Q. What scale numbers were tested with the app?**

+-----------------------------------+----------------+
| Particulars                       | Scale          | 
+===================================+================+
| Number of BIG-IPs                 | 60             |
+-----------------------------------+----------------+
| Per BIG-IP paritions              | 100            | 
+-----------------------------------+----------------+ 
| Per BIG-IP Virtual IPs            | 100            |
+-----------------------------------+----------------+
| APIC logical devices              | 60             | 
+-----------------------------------+----------------+ 
| Per BIG-IP nodes members          | 4              | 
+-----------------------------------+----------------+
| Concurrent app operations         | 4 BIG-IPs      | 
+-----------------------------------+----------------+

------

**Q. What is the Compatibility Matrix for the various features supported by F5 ACI ServiceCenter?**

Note:

1. APIC minimum version supported for 3.2.x: 3.2(7f)

2. APIC minimum version supported for 4.1.x: 4.1(1k)

3. APIC minimum version supported for 5.0.x: 5.0(1k)

Note: To enable the L4-L7 App services tab, you must be using AS3 version 3.19.1 or higher.

Note: To enable the Telemetry Statistics, you must be using Telemetry plugin version 1.17.0 or higher.

+--------------------------------+-----------------+------------------------------+--------------------+--------------------------------+
| BIG-IP Type                    | Visibility      | L2-L3 Network Management     | L4-L7 App Services | Dynamic Endpoint Attach Detach |
+================================+=================+==============================+====================+================================+
| Physical/VE Standalone         | Yes             | Yes                          | Yes                | Yes (BIG-IP v13.0 and above)   |                        
+--------------------------------+-----------------+------------------------------+--------------------+--------------------------------+
| Physical/VE High Availability  | Yes             | Yes                          | Yes                | No                             |
+--------------------------------+---+-------------+------------------------------+--------------------+--------------------------------+
| vCMP Host Standalone           | VLAN table only | VLAN only                    | No                 | No                             |  
+--------------------------------+---+-------------+------------------------------+--------------------+--------------------------------+
| vCMP Host High Availability    | No              | No                           | No                 | No                             |
+--------------------------------+-----------------+------------------------------+--------------------+--------------------------------+
| vCMP Guest Standalone          | Yes             | Self IP/Default Gateway only | Yes                | Yes (BIG-IP v13.0 and above)   |
+--------------------------------+-----------------+------------------------------+--------------------+--------------------------------+
| vCMP Guest High Availability   | Yes             | Self IP/Default Gateway only | Yes                | No                             |
+--------------------------------+-----------------+------------------------------+--------------------+--------------------------------+
