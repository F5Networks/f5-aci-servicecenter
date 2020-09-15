Release Notes (Version 2.6)
===========================

General
-------

**File system convergence**

APIC Filesystem Glusterfs takes 15 to 20 Minutes to recover when APIC cluster goes unhealthy.

During APIC operations like APIC reboot, upgrade, or decommission/recommission, the APIC filesystem needs some time to recover and resume.

Symptoms users may see:
1. Application operations throw a (sqlite3.OperationalError) disk I/O error
2. Users may not find previously added BIG-IP entries in the application
3. New Application installation may fail

**Workaround**: Wait for 20 minutes and try to access the application again. The Glusterfs should recover automatically and the application should be accessible again.

------

**Floating IP auto sync and Default Gateway auto sync will not work when hosts are added in an HA cluster using hostnames**

**Workaround:** Manually sync the Floating IPs and Default Gateway to Application DB by clicking **Sync To DB**

------

**Export db does not work on APIC version 5.0.1**

The user menu on the top-right corner of the F5 ACI ServiceCenter has an option for exporting F5 ACI ServiceCenter database (**Export/Import DB > Export DB**). This option does not work on APIC versions 5.0.1. This is working as expected on prior versions of the APIC and also on versions 5.0(2e) and higher. 

**Workaround:** Backup the F5 ACI ServiceCenter database via the following steps:
1. Login to the APIC server via SSH.

2. Change directories to F5Networks_F5ACIServiceCenter: **cd /data2/gluster/gv0/F5Networks_F5ACIServiceCenter**.

3. Use scp, winscp or any other preferred tool to copy out the f5.db file from this location. 

------

**Non-default docker0 configuration on APIC may affect the connection to the management IP of Virtual BIG-IP**

The default docker0 bridge IP has the address **172.17.0.1**. If the docker0 bridge IP is updated to a non-default IP followed by APIC cluster reboot, the Virtual BIG-IP login (connection to management IP) will fail from the F5 ACI ServiceCenter.

**Workaround:** After APIC reboots, once again change the docker0 bridge IP to a new value.

------

**Hostname vCMP HA peer login during unassign VLANs does not update the login color to Green/Yellow in the side menu**

On a vCMP Host, if a user clicks the **L2-L3 Network Management > vCMP Guest** and selects a vCMP Guest and moves a few VLANs from **Selected** menu to **Available** menu and clicks **Submit**, F5 ACI ServiceCenter logs into the vCMP Guest if it is not already logged in. In this case, the side menu does not show the Green/Yellow color indicator correctly. 

**Workaround:** Click the side menu **Refresh BIG-IP List** icon to update the login status of the vCMP Guest.

------

**If a vCMP Guest has been logged in using hostname, vCMP Guest auto-login during VLAN unassignment may result in an error**

The error message observed is: "<IP_Address> is already added as <Hostname>. To add <IP_Address>, delete BIG-IP device <Hostname> and retry."

The steps that may lead to this error are:

- Login to a vCMP Guest using hostname.

- Login to the corresponding vCMP Host and click **L2-L3 Network Management > vCMP Guest tab**. 

- From the **vCMP Guest** drop-down, select the vCMP Guest IP corresponding to the aformentioned vCMP Guest. 

- Unassign one or more VLANs by moving them from **Selected** menu to **Available** menu, and click **Submit**. 

**Workaround:** Delete the vCMP Guest BIG-IP which has been logged in using <Hostname>, and re-add it to FASC using <IP_Address>.

------

**Zoom In/Out for Device Discovery Topology diagrams may get stuck on Internet Explorer**

When you click the Topology icon in any one of the tabs (Visibility, Network Management, and L4-L7 App Services), the Topology diagrams may get stuck when zooming in and out. The position of the topology diagram can also not be changed once this issue is observed. 

**Workaround:** Use a different browser than IE.


Visibility
----------

**Visibility report downloads do not work in the Chrome browser version 83 and higher (Fixed in APIC 4.2(4p)+ and 5.0(2e)+)**

F5 ACI ServiceCenter's Visibility tab has a **Download Report** icon for downloading VLAN, VIP and Node table data in CSV format. This download functionality does not work in the Chrome browser version 83 and higher, due to a new security check added by Chrome: https://developers.google.com/web/updates/2020/04/chrome-83-deps-rems#disallow_downloads_in_sandboxed_iframes 

**Fix:** This has been fixed in APIC versions 4.2(4p)+ and 5.0(2e)+.

**Workaround:** To download visibility reports, use a different browser, like Mozilla Firefox, or an earlier version of Google Chrome.

------

**Visibility table fast scrolling on Mozilla Firefox for scale configs may result in a blank screen**

This is a known ag-grid issue on the Mozilla Firefox browser: https://github.com/ag-grid/ag-grid/issues/2841

**Workaround:** Scroll slowly to prevent this issue. But if this issue is observed, the possible workarounds are:

1. Switch tabs from Visibility tab to one of the other tabs and then switch back. 

2. Select a different entry from the Visibility table drop-downs (either Partition or Table) and switch back to the intended combination.

3. Close and re-open the FASC app UI.

------

**Visibility table status icons render few seconds after data for scale configs.**

**Workaround:** None

------

L4-L7 App Services
------------------

**Application services declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the Application Services configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration gets removed from the BIG-IP device.

**Workaround**: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

-------


Dynamic Endpoint Attach Detach
------------------------------

**Dynamic Endpoint attach/detach is not supported for BIG-IP High Availability configurations**

Dynamic Endpoint attach/detach using the "Manage Endpoint Mappings" button is not supported for BIG-IP devices which are in an HA pair. If used, the behavior is unknown and users may experience BIG-IP service restarts and hang ups.

**Workaround:** None

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/238

------

**Error on EPG mapping delete operation**

When a dynamic endpoint mapping is added to an application using **Manage Endpoint Mappings**, the application gets created on the BIG-IP. If this mapping is deleted using the **RESET** button on **Manage Endpoint Mappings** form, users may encounter an error "The requested Pool Member (/Partition/App/Pool /NodePartition/NodeIP) was not found."

**Workaround:** Click the **Submit** button again, and the mapping will be reset properly without any errors. 

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/185
 
------

**AS3 applications can either have static nodes or dynamic nodes but not both**

AS3 applications will support either static nodes or dynamic nodes (using the **Manage Endpoint Mappings** button) but not both. 

------

**Dynamic endpoints will not be discovered if any of the dynamic endpoint IPs already belong to the static nodes on the BIG-IP**

Dynamic endpoints are the endpoints present in APIC Endpoint Group. The app automatically updates this in the BIG-IP application’s pool members provided the correct association is configured via the application. But if this dynamic endpoint list consists of an IP which has previously been added as a static node on the BIG-IP, none of the dynamic endpoints will get updated in the application. 

**Workaround:** Ensure that the APIC endpoint subnet/IPs are different from the static endpoint IPs on the BIG-IP.

------

**Using the same Dynamic endpoint mappings on two separate partitions of a BIG-IP are not supported**

For a single BIG-IP device, if two AS3 applications belonging to two different partitions are associated with the same APIC Endpoint Group (Tenant|Application|EPG), the dynamic discovery of nodes will not work for either of the AS3 applications. 

**Workaround:** If you want to use the same endpoint mapping for two AS3 applications belonging to two different partitions, use the **shareNodes** option as described in https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/declarations/miscellaneous.html#using-sharenodes-to-reuse-nodes-across-tenants. 

To enable shareNodes,

1. Go to L4-L7 App Services --> Application --> Advanced.

2. Create a new partition/application.

3. Set dynamic endpoint mappings via **Manage Endpoint Mappings**, by selecting the Tenant|Application|EPG and port and click **Save**.

4. Update the members section to add the **shareNodes** property. For example:

Example: "members": [
            {
                "addressDiscovery": "event",
                
                "servicePort": 80,
                
                "shareNodes": true
            }
         ]

Another possible workaround is to remove the erroneous applications and recreate them with different mappings so that each AS3 application will have a separate set of nodes.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/187

------

**BIG-IP reboots OR BIG-IP services restart if more than 60 endpoints are dynamically discovered in an APIC EPG**

If an APIC endpoint group has more than 60 endpoints attached, then the endpoint list will not get reflected on the BIG-IP, and users may experience service restarts on BIG-IP. 

**Workaround:** For any dynamic endpoint mapping, ensure that the number of endpoints in the corresponding APIC endpoint group never exceeds 60.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/188

------

**Nodes are not removed from the BIG-IP pool when the node IP is a substring of some other node's IP**

If a node (for example a node with IP 1.2.3.4) is deleted from APIC, and there is also another node 1.2.3.40 of which the original IP is a substring, it may be possible that the dynamic end point attach detach feature is not able to delete 1.2.3.4 from BIG-IP. Note: The pool members will get deleted as expected. 

**Workaround:** Login to the BIG-IP UI and delete the problematic node.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/244

------

**Dynamic EP discovery does not work if a duplicate IP already exists on a different partition.**

If an APIC Tenant|App|EPG mapped to a BIG-IP pool has an endpoint with an IP address which already exists on the BIG-IP but in a different partition, then the APIC endpoint will not get added to BIG-IP pool. Also any successive configurations and endpoints also will not be discovered/deleted from this BIG-IP pool. 

Workaround: Remove the duplicate IPs from the endpoint list on APIC and retry a manual sync of Endpoints from L4-L7 App Services --> Application Inventory --> Sync EPs icon. 

Note: Similar issues might be seen with other erronous configurations such as unsupported IPv4 formats like 1.2.3.4/24 instead of 1.2.3.4

AS3 Defect: https://github.com/F5Networks/f5-appsvcs-extension/issues/287

------

**Pool members deleted or added directly to BIG-IP don't get updated automatically after clicking "Sync EPs".**

1. If BIG-IP pool members automatically get added by the **Dynamic endpoint discovery** feature, but then few endpoints are deleted directly from the BIG-IP (i.e. out of band); these endpoints do not get created again on clicking **L4-L7 App Services --> Application Inventory --> Sync EPs** for that application. 

2. Similarly, when a few pool members are added directly to the BIG-IP (i.e. out of band), these extra members are not deleted after clicking **L4-L7 App Services --> Application Inventory --> Sync EPs**

**Workaround:** Manually add/delete the pool members from BIG-IP. 

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/293

------

Release Notes (Version 2.5)
===========================

General
-------

**File system convergence**

APIC Filesystem Glusterfs takes 15 to 20 Minutes to recover when APIC cluster goes unhealthy

During APIC operations like APIC reboot, upgrade, or decommission/recommission, the APIC filesystem needs some time to recover and resume.

Symptoms users may see:
1. Application operations throw a (sqlite3.OperationalError) disk I/O error
2. Users may not find previously added BIG-IP entries in the application
3. New Application installation may fail

**Workaround**: Wait for 20 minutes and try to access the application again. The Glusterfs should recover automatically and the application should be accessible again.

------

**F5 ACI ServiceCenter HA clusters show IPs even if the devices are added using hostnames**

For BIG-IP devices in an HA cluster, when one BIG-IP with hostname is added to F5 ACI ServiceCenter, the IP corresponding to that hostname also gets added in the side menu. The application warns the user about this, and displays a deletion prompt for retaining only the hostname version of the BIG-IP. 

**Workaround:** Users may click **Delete** to proceed with deletion of the additional IP version of the device added to the app. OR
Users may skip the prompt and manually delete the device which got added using IP by clicking on the delete (X) icon next to the IP of the device. Repeat the same process for the peer of this device - now both devices should be seen inside the cluster with hostname.

------

**Floating IP auto sync and Default Gateway auto sync will not work when hosts are added in an HA cluster using hostnames**

**Workaround:** Manually sync the Floating IPs and Default Gateway to Application DB by clicking on **Sync To DB**

------

**Export db does not work on APIC version 5.0.X**

The user menu on the top-right corner of the F5 ACI ServiceCenter has an option **Export/Import DB > Export DB**, for exporting the F5 ACI ServiceCenter database. This option does not work on APIC versions 5.0.X and higher. This is working as expected on prior versions of the APIC. 

**Workaround:** Backup the F5 ACI ServiceCenter database via the following steps:
1. Login to the APIC server via SSH

2. cd /data2/gluster/gv0/F5Networks_F5ACIServiceCenter

3. Use scp, winscp or any other preferred tool to copy out the f5.db file from this location. 

------

**Non-default docker0 configuration on APIC may affect connection to the management IP of Virtual BIG-IP**

The default docker0 bridge IP has the address **172.17.0.1**. If the docker0 bridge IP is updated to a non-default IP followed by APIC cluster reboot, the Virtual BIG-IP login (connection to management IP) will fail from the F5 ACI ServiceCenter.

**Workaround:** After APIC reboots, once again change the docker0 bridge IP to a new value.

------

**Alert text spills outside the alert window on Internet Explorer**

On Internet Explorer, the text for longer alert messages (errors, warnings, success messages), may spill outside the alert window.

**Workaround:** User a different browser like Google Chrome or Mozilla Firefox. 

------

Visibility
----------

**Visibility report downloads do not work in the Chrome browser version 83 and higher**

F5 ACI ServiceCenter's Visibility tab has a **Download Report** icon for downloading VLAN, VIP and Node table data in CSV format. This download functionality does not work in the Chrome browser version 83 and higher, due to a new security check added by Chrome: https://developers.google.com/web/updates/2020/04/chrome-83-deps-rems#disallow_downloads_in_sandboxed_iframes 

**Workaround:** To download visibility reports, use a different browser, like Mozilla Firefox, or an earlier version of Google Chrome.

------



L2-L3 Network Management
------------------------

**Error “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“**

getldevinfo.json and createbigipvlan.json APIs will show an error of the type “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“

Root-cause: During VLAN creation using createbigipvlan.json API, the VLAN table in the F5 ACI ServiceCenter saves VLAN database entries. One of the fields in the VLAN table is the lifDn which is the Distinguished name of Logical Interface (in the Logical device) on APIC. If during App REST API automation, anyone creates a VLAN using createbigipvlan.json and enters an invalid string in lifDn parameter of the API instead of the valid input for lifDn, the app will accept it. And on a subsequent call to getldevinfo.json or createbigipvlan.json, it throws the aformentioned error.

**Workaround**: Uninstall and re-install the application to clean out the F5 ACI ServiceCenter database.

------


L4-L7 App Services
------------------

**Application services declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the Application Services configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration gets removed from the BIG-IP device.

**Workaround**: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

-------


Dynamic Endpoint Attach Detach
------------------------------

**Dynamic Endpoint attach/detach is not supported for BIG-IP High Availability configurations**

Dynamic Endpoint attach/detach using the "Manage Endpoint Mappings" button is not supported for BIG-IP devices which are in an HA pair. If used, the behavior is unknown and users may experience BIG-IP service restarts and hang ups.

**Workaround:** None

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/238

------

**Error on EPG mapping delete operation**

When a dynamic endpoint mapping is added to an application using **Manage Endpoint Mappings**, the application gets created on the BIG-IP. If this mapping is deleted using the **RESET** button on **Manage Endpoint Mappings** form, users may encounter an error "The requested Pool Member (/Partition/App/Pool /NodePartition/NodeIP) was not found"

**Workaround:** Click the **Submit** button again, and the mapping will be reset properly without any errors. 

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/185
 
------

**AS3 application can either have static nodes or dynamic nodes but not both**

AS3 applications will support either static nodes or dynamic nodes (using the **Manage Endpoint Mappings** button) but not both. 

------

**Dynamic endpoints will not be discovered if any of the dynamic endpoint IPs already belong to the static nodes on the BIG-IP**

Dynamic endpoints are the endpoints present in APIC Endpoint Group. The app automatically updates this in the BIG-IP application’s pool members provided the correct association is configured via the application. But if this dynamic endpoint list consists of an IP which has previously been added as a static node on the BIG-IP, none of the dynamic endpoints will get updated in the application. 

**Workaround:** Ensure that the APIC endpoint subnet/IPs are different from the static endpoint IPs on the BIG-IP.

------

**Same Dynamic endpoint mappings on two separate partitions of a BIG-IP are not supported**

For a single BIG-IP device, if two AS3 applications belonging to two different partitions are associated with the same APIC Endpoint Group (Tenant|Application|EPG), the dynamic discovery of nodes will not work for either of the AS3 applications. 

**Workaround:** If you want to use the same endpoint mapping for two AS3 applications belonging to two different partitions, use the **shareNodes** option as described in https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/declarations/miscellaneous.html#using-sharenodes-to-reuse-nodes-across-tenants. 

To enable shareNodes,

1. Go to L4-L7 App Services --> Application --> Advanced.

2. Create a new partition/application.

3. Set dynamic endpoint mappings via **Manage Endpoint Mappings**, by selecting the Tenant|Application|EPG and port and click **Save**.

4. Update the members section as below to add the shareNodes property:

Example: "members": [
            {
                "addressDiscovery": "event",
                
                "servicePort": 80,
                
                "shareNodes": true
            }
         ]

Another possible workaround is to remove the erroneous applications and recreate them with different mappings so that each AS3 application will have a separate set of nodes.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/187

------

**BIG-IP reboots OR BIG-IP services restart if more than 60 endpoints are dynamically discovered in an APIC EPG**

If an APIC endpoint group has more than 60 endpoints attached, then the endpoint list will not get reflected on the BIG-IP, and users may experience service restarts on BIG-IP. 

**Workaround:** For any dynamic endpoint mapping, ensure that the number of endpoints in the corresponding APIC endpoint group never exceeds 60.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/188

------

**Node not removed from BIG-IP pool when node IP is a substring of some other node's IP**

If a node (for example a node with IP 1.2.3.4) is deleted from APIC, and there is also another node 1.2.3.40 of which the original IP is a substring, it may be possible that the dynamic end point attach detach feature is not able to delete 1.2.3.4 from BIG-IP. Note: The pool members will get deleted as expected. 

**Workaround:** Login to the BIG-IP UI and delete the problematic node

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/244

------

**Dynamic EP discovery does not work if duplicate IP already exists on a different partition.**

If an APIC Tenant|App|EPG mapped to a BIG-IP pool has an endpoint with an IP address which already exists on the BIG-IP but in a different partition, then the APIC endpoint will not get added to BIG-IP pool. Also any successive configurations and endpoints also will not be discovered/deleted from this BIG-IP pool. 

Workaround: Remove the duplicate IPs from the endpoint list on APIC and retry a manual sync of Endpoints from L4-L7 App Services --> Application Inventory --> Sync EPs icon. 

Note: Similar issues might be seen with other erronous configurations such as unsupported IPv4 formats like 1.2.3.4/24 instead of 1.2.3.4

AS3 Defect: https://github.com/F5Networks/f5-appsvcs-extension/issues/287

------

**Pool members deleted or added directly to BIG-IP don't get updated automatically after clicking "Sync EPs".**

1. If BIG-IP pool members automatically get added by the **Dynamic endpoint discovery** feature, but then few endpoints are deleted directly from the BIG-IP (i.e. out of band); these endpoints do not get created again on clicking **L4-L7 App Services --> Application Inventory --> Sync EPs** for that application. 

2. Similarly, when a few pool members are added directly to the BIG-IP (i.e. out of band), these extra members are not deleted after clicking **L4-L7 App Services --> Application Inventory --> Sync EPs**

**Workaround:** Manually add/delete the pool members from BIG-IP. 

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/293

------

Release Notes (Version 2.4)
===========================

General
-------

**F5 ACI ServiceCenter Upgrade is not supported from Version 1.0 to Version 2.4**

The F5 ACI ServiceCenter application does not have upgrade support from Version 1.0 to Version 2.4. In order to install a new version of the app, use the following steps:
1. Uninstall the existing Version 1.0 of the application from APIC Apps tab.
2. Install and enable Version 2.4 of the application by downloading it from https://dcappcenter.cisco.com/

Note: App upgrades are supported in version 2.0 and higher

------

**File system convergence**

APIC Filesystem Glusterfs takes 15 to 20 Minutes to recover when APIC cluster goes unhealthy

During the APIC operations like APIC reboot, upgrade, or decommission/recommission, the APIC filesystem needs some time to recover and resume.

Symptoms users may see:
1. Application operations throw a (sqlite3.OperationalError) disk I/O error
2. User may not find previously added BIG-IP entries in the application
3. New Application installation may fail

**Workaround**: Wait for 20 minutes and try to access the application again. The Glusterfs should recover automatically and the application should be accessible again.

------

**F5 ACI ServiceCenter HA clusters show IPs even if the devices are added using hostnames**

For BIG-IP devices in an HA cluster, when one BIG-IP with hostname is added to F5 ACI ServiceCenter, the IP corresponding to that hostname also gets added in the side menu. 

**Workaround:** Delete the device which got added using IP by clicking on the delete (X) icon next to the IP of the host. Repeat the same process for the peer of this device - now both devices should be seen inside the cluster with hostname.  

------

**Floating IP auto sync and Default Gateway auto sync will not work when hosts are added in an HA cluster using hostnames**

**Workaround:** Manually sync the Floating IPs and Default Gateway to Application DB by clicking on **Sync To DB**

------

L2-L3 Network Management
------------------------

**Error “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“**

getldevinfo.json and createbigipvlan.json APIs will show an error of the type “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“

Root-cause: During VLAN creation using createbigipvlan.json API, the VLAN table in the F5 ACI ServiceCenter saves VLAN database entries. One of the fields in the VLAN table is the lifDn which is the Distinguished name of Logical Interface (in the Logical device) on APIC. If during App REST API automation, anyone creates a VLAN using createbigipvlan.json and enters invalid string in lifDn parameter of the API instead of the valid input for lifDn, the app will accept it. And on a subsequent call to getldevinfo.json or createbigipvlan.json throw the aformentioned error.

**Workaround**: Uninstall and re-install the application to clean out the F5 ACI ServiceCenter database.

------


L4-L7 App Services
------------------

**Application services declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the Application Services configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration gets removed from the BIG-IP device.

**Workaround**: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

-------


Dynamic Endpoint Attach Detach
------------------------------

**Dynamic Endpoint attach/detach is not supported for BIG-IP High Availability setups**

Dynamic Endpoint attach/detach using the "Manage Endpoint Mappings" button is not supported for BIG-IP devices which are in HA pair. If used, the behavior is unknown and user may experience BIG-IP service restarts and hang up.

**Workaround:** None

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/238

------

**Error on EPG mapping delete operation**

When a dynamic endpoint mapping is added to an application using **Manage Endpoint Mappings**, the application gets created on the BIG-IP. If this mapping is deleted using the **RESET** button on **Manage Endpoint Mappings** form, user may encounter an error "The requested Pool Member (/Partition/App/Pool /NodePartition/NodeIP) was not found"

**Workaround:** Click the **Submit** button again, and the mapping will be reset properly without any errors. 

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/185
 
------

**AS3 application can either have static nodes or dynamic nodes but not both**

AS3 applications will support either static nodes or dynamic nodes (using the **Manage Endpoint Mappings** button) but not both. 

------

**Dynamic endpoints will not be discovered if any of the dynamic endpoint IPs already belong to the static nodes on the BIG-IP**

Dynamic endpoints are the endpoints present in APIC Endpoint Group. The app automatically updates this in the BIG-IP application’s pool members provided the correct association is configured via the application. But if this dynamic endpoint list consists of an IP which has already been added as a static node on the BIG-IP previously, none of the dynamic endpoints will get updated in the application. 

**Workaround:** Ensure that the APIC endpoint subnet/IPs are different from the static endpoint IPs on the BIG-IP.

------

**Same Dynamic endpoint mappings on 2 separate partitions of a BIG-IP are not supported**

For a single BIG-IP device, if 2 AS3 applications belonging to 2 different partitions are associated with the same APIC Endpoint Group (Tenant|Application|EPG), the dynamic discovery of nodes will not work for either of the AS3 applications. 

**Workaround:** If you want to use the same endpoint mapping for 2 AS3 applications belonging to 2 different partitions, use the **shareNodes** option as described in https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/declarations/miscellaneous.html#using-sharenodes-to-reuse-nodes-across-tenants. 

To enable shareNodes,

1. Go to L4-L7 App Services --> Application --> Advanced.

2. Create a new partition/application.

3. Set dynamic endpoint mappings via **Manage Endpoint Mappings**, by selecting the Tenant|Application|EPG and port and click **Save**.

4. Update the members section as below to add the shareNodes property:

Example: "members": [
            {
                "addressDiscovery": "event",
                
                "servicePort": 80,
                
                "shareNodes": true
            }
         ]

Another possible workaround is to remove the erroneous applications and recreate them with different mappings so that each AS3 application will have a separate set of nodes.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/187

------

**BIG-IP reboots OR BIG-IP services restart if more than 60 endpoints are dynamically discovered in an APIC EPG**

If an APIC endpoint group has more than 60 endpoints attached, then the endpoint list will not get reflected on the BIG-IP, and users may experience service restarts on BIG-IP. 

**Workaround:** For any dynamic endpoint mapping, please ensure that the number of endpoints in the corresponding APIC endpoint group never exceeds 60.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/188

------

**Node not removed from BIG-IP pool when node IP is a substring of some other node's IP**

If a node, for example a node with IP 1.2.3.4, is deleted from APIC, and there is also another node 1.2.3.40 of which the original IP is a substring, it may be possible that the dynamic end point attach detach feature is not able to delete 1.2.3.4 from BIG-IP. Note: The pool members will get deleted as expected. 

**Workaround:** Login to the BIG-IP UI and delete the problematic node

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/244

------

Release Notes (Version 2.3)
===========================

General
-------

**F5 ACI ServiceCenter Upgrade is not supported from Version 1.0 to Version 2.3**

The F5 ACI ServiceCenter application does not have upgrade support from Version 1.0 to Version 2.3. In order to install a new version of the app the steps to be followed are:
1. Uninstall the existing Version 1.0 of the application from APIC Apps tab.
2. Install and enable Version 2.3 of the application by downloading it from https://dcappcenter.cisco.com/

Note: App upgrades are supported in version 2.0 and higher

------

**File system convergence**

APIC Filesystem Glusterfs takes 15 to 20 Minutes to recover when APIC cluster goes unhealthy

During the APIC operations like APIC reboot, upgrade, or decommission/recommission, the APIC filesystem needs some time to recover and resume.

Symptoms users may see:
1. Application operations throw a (sqlite3.OperationalError) disk I/O error
2. User may not find previously added BIG-IP entries in the application
3. New Application installation may fail

**Workaround**: Wait for 20 minutes and try to access the application again. The Glusterfs should recover within some time automatically and the application should be accessible again.

------

**F5 ACI ServiceCenter HA clusters show IPs even if the devices are added using hostnames**

For BIG-IP in HA cluster, when one BIG-IP with hostname is added to F5 ACI ServiceCenter, the IP corresponding to that hostname also gets added in the side menu. 

**Workaround:** Delete the device which got added using IP by clicking on the X icon besides the IP of the host. Repeat the same process for the peer of this device as well - now both devices should be seen inside the cluster with hostname.  

------

**Floating IP auto sync and Default Gateway auto sync will not work when hosts are added in an HA cluster using hostnames**

**Workaround:** Manually sync the Floating IPs and Default Gateway to Application DB by clicking on “Sync To DB”

------

L2-L3 Network Management
------------------------

**Error “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“**

getldevinfo.json and createbigipvlan.json APIs will show an error of the type “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“

Root-cause: During vlan creation using createbigipvlan.json API, the VLAN table in the F5 ACI ServiceCenter saves VLAN database entries. One of the fields in the VLAN table is the lifDn which is the Distinguished name of Logical Interface (in the Logical device) on APIC. If during App REST API automation, anyone creates a VLAN using createbigipvlan.json and enters invalid string in lifDn parameter of the API instead of the valid input for lifDn, the app will accept it. And on a subsequent call to getldevinfo.json or createbigipvlan.json throw the aformentioned error.

**Workaround**: Uninstall and re-install the application to clean out the F5 ACI ServiceCenter database.

------


L4-L7 App Services
------------------

**Application services declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the Application Services configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration gets removed from the BIG-IP device.

**Workaround**: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

-------


Dynamic Endpoint Attach Detach
------------------------------

**Dynamic Endpoint attach/detach is not supported for BIG-IP High Availability setups**

Dynamic Endpoint attach/detach using the "Manage Endpoint Mappings" button is not supported for BIG-IP devices which are in HA pair. If used, the behavior is unknown and user may experience BIG-IP service restarts and hang up.

**Workaround:** None

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/238

------

**Error on EPG mapping delete operation**

When a dynamic endpoint mapping is added to an application using the "Manage Endpoint Mappings", the application gets created on BIG-IP. If this mapping is deleted using the "RESET" button on "Manage Endpoint Mappings" form, user may encounter an error "The requested Pool Member (/Partition/App/Pool /NodePartition/NodeIP) was not found"

**Workaround:** Click on the "Submit" button again, and the mapping will be reset properly without any errors. 

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/185
 
------

**AS3 application can either have static nodes or dynamic nodes but not both**

AS3 applications will support either static nodes or dynamic nodes (Using Manage Endpoint Mappings button) but not both. 

------

**Dynamic endpoints will not be discovered if any of the dynamic endpoint IPs already belong to the static nodes on the BIG-IP**

Dynamic endpoints are the endpoints present in APIC Endpoint Group. The app automatically updates this in the BIG-IP application’s pool members provided the correct association is configured via the application. But if this dynamic endpoint list consists of an IP which has already been added as a static node on the BIG-IP previously, none of the dynamic endpoints will get updated in the application. 

**Workaround:** Ensure that the APIC endpoint subnet/IPs are different from the static endpoint IPs on the BIG-IP.

------

**Same Dynamic endpoint mappings on 2 separate partitions of a BIG-IP are not supported**

For a single BIG-IP device, if 2 AS3 applications belonging to 2 different partitions are associated with the same APIC Endpoint Group (Tenant|Application|EPG), the dynamic discovery of nodes will not work for either of the AS3 applications. 

**Workaround:** Remove erroneous applications and recreate with different mappings

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/187

------

**BIG-IP reboots OR BIG-IP services restart if more than 60 endpoints are dynamically discovered in an APIC EPG**

If an APIC endpoint group has more than 60 endpoints attached, then the endpoint list will not get reflected on the BIG-IP, and users may experience service restarts on BIG-IP. 

**Workaround:** For any dynamic endpoint mapping, please ensure that the number of endpoints in the corresponding APIC endpoint group never crosses 60.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/188

------

Release Notes (Version 2.2)
===========================

General
-------

**F5 ACI ServiceCenter Upgrade is not supported from Version 1.0 to Version 2.2**

The F5 ACI ServiceCenter application does not have upgrade support from Version 1.0 to Version 2.2. In order to install a new version of the app the steps to be followed are:
1. Uninstall the existing Version 1.0 of the application from APIC Apps tab.
2. Install and enable Version 2.2 of the application by downloading it from https://dcappcenter.cisco.com/

Note: App upgrades are supported in version 2.0 and higher

------

**File system convergence**

APIC Filesystem Glusterfs takes 15 to 20 Minutes to recover when APIC cluster goes unhealthy

During the APIC operations like APIC reboot, upgrade, or decommission/recommission, the APIC filesystem needs some time to recover and resume.

Symptoms users may see:
1. Application operations throw a (sqlite3.OperationalError) disk I/O error
2. User may not find previously added BIG-IP entries in the application
3. New Application installation may fail

**Workaround**: Wait for 20 minutes and try to access the application again. The Glusterfs should recover within some time automatically and the application should be accessible again.


L2-L3 Network Management
------------------------

**Error “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“**

getldevinfo.json and createbigipvlan.json APIs will show an error of the type “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“

Root-cause: During vlan creation using createbigipvlan.json API, the VLAN table in the F5 ACI ServiceCenter saves VLAN database entries. One of the fields in the VLAN table is the lifDn which is the Distinguished name of Logical Interface (in the Logical device) on APIC. If during App REST API automation, anyone creates a VLAN using createbigipvlan.json and enters invalid string in lifDn parameter of the API instead of the valid input for lifDn, the app will accept it. And on a subsequent call to getldevinfo.json or createbigipvlan.json throw the aformentioned error.

**Workaround**: Uninstall and re-install the application to clean out the F5 ACI ServiceCenter database.

------

**F5 ACI ServiceCenter does not allow duplicate Self IP creation even after deleting it from BIG-IP**

If VLAN and Self IPs are created using F5 ACI ServiceCenter, and then deleted out of band from the BIG-IP GUI/CLI directly, stale entries remain within the F5 ACI ServiceCenter state. Hence, if the same Self IPs are created from the app later, user encounters a duplicate error for the Self IPs even if they are not present anymore on the BIG-IP.

**Workaround**: If any L2-L3 configuration is created using the F5 ACI ServiceCenter to stitch an APIC Logical Device with a BIG-IP, ensure that this configuration is deleted from the ServiceCenter UI itself, before making any further changes or deletions from APIC Logical Device or BIG-IP. 

------


L4-L7 App Services
------------------

**Application services declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the Application Services configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration gets removed from the BIG-IP device.

**Workaround**: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

-------

**L4-L7 App Services 'Pending Tasks' table does not update task status**

When AS3 declaration submission goes into asynchronous mode, the task is tracked by the F5 ACI ServiceCenter and its status is updated in 'Pending Tasks' table which is available on the L4-L7 App Services Tab. If such pending tasks exist on multiple BIG-IPs at once, it is possible that the status of such pending tasks is not updated properly in the UI.

**Workaround**: Wait for a maximum of 2 minutes to see if the pending task status gets updated. If not, the workarounds to try are: 1. Switch the tab and come back to L4-L7 App Services and check the task status. 2. Re-login to the BIG-IP where the pending task status is not updated. 

-------

**Success message for AS3 declaration submission is hidden behind the UI loader**

For big AS3 declarations with multiple partitions or applications, it is observed that the success response message is observed in the background of the UI loader. 

**Workaround**: Check the L4-L7 App Services --> Application Inventory sub-tab to see if the application add/remove/update operation was successful. If the submitted applications are not added/removed from application inventory as expected, please click on the "Pending Tasks" icon to see if the task is still being processed by the BIG-IP.

-------


Release Notes (Version 2.1)
===========================

General
-------

**F5 ACI ServiceCenter Upgrade is not supported from Version 1.0 to Version 2.1**

The F5 ACI ServiceCenter application does not have upgrade support from Version 1.0 to Version 2.1. In order to install a new version of the app the steps to be followed are:
1. Uninstall the existing Version 1.0 of the application from APIC Apps tab.
2. Install and enable Version 2.1 of the application by downloading it from https://dcappcenter.cisco.com/
Note: App upgrades are supported in version 2.0 and higher

------

**File system convergence**

APIC Filesystem Glusterfs takes 15 to 20 Minutes to recover when APIC cluster goes unhealthy

During the APIC operations like APIC reboot, upgrade, or decommission/recommission, the APIC filesystem needs some time to recover and resume.

Symptoms users may see:
1. Application operations throw a (sqlite3.OperationalError) disk I/O error
2. User may not find previously added BIG-IP entries in the application
3. New Application installation may fail

**Workaround**: Wait for 20 minutes and try to access the application again. The Glusterfs should recover within some time automatically and the application should be accessible again.

------

**Custom Docker 0 Bridge IP not supported**

On APIC, if Custom Docker 0 Bridge IP other than 172.17.0.1 is used, F5 ACI ServiceCenter will not be able to support it. It will not be able to communicate with APIC as expected. 

Users will see an error similar to "HTTPSConnectionPool(host='172.17.0.1', port=443): Max retries exceeded with url"

**Workaround**: Use default Docker 0 Bridge IP: 172.17.0.1

**Fix**: Fixed in F5 ACI ServiceCenter v2.2

------

L2-L3 Network Management
------------------------

**Error “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“**

getldevinfo.json and createbigipvlan.json APIs will show an error of the type “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“

Root-cause: During vlan creation using createbigipvlan.json API, the VLAN table in the F5 ACI ServiceCenter saves VLAN database entries. One of the fields in the VLAN table is the lifDn which is the Distinguished name of Logical Interface (in the Logical device) on APIC. If during App REST API automation, anyone creates a VLAN using createbigipvlan.json and enters invalid string in lifDn parameter of the API instead of the valid input for lifDn, the app will accept it. And on a subsequent call to getldevinfo.json or createbigipvlan.json throw the aformentioned error.

**Workaround**: Uninstall and re-install the application to clean out the F5 ACI ServiceCenter database.

------

**F5 ACI ServiceCenter does not allow duplicate Self IP creation even after deleting it from BIG-IP**

If VLAN and Self IPs are created using F5 ACI ServiceCenter, and then deleted out of band from the BIG-IP GUI/CLI directly, stale entries remain within the F5 ACI ServiceCenter state. Hence, if the same Self IPs are created from the app later, user encounters a duplicate error for the Self IPs even if they are not present anymore on the BIG-IP.

**Workaround**: If any L2-L3 configuration is created using the F5 ACI ServiceCenter to stitch an APIC Logical Device with a BIG-IP, ensure that this configuration is deleted from the ServiceCenter UI itself, before making any further changes or deletions from APIC Logical Device or BIG-IP. 

------


L4-L7 App Services
------------------

**Application services declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the Application Services configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration gets removed from the BIG-IP device.

**Workaround**: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

-------

**L4-L7 App Services 'Pending Tasks' table does not update task status**

When AS3 declaration submission goes into asynchronous mode, the task is tracked by the F5 ACI ServiceCenter and its status is updated in 'Pending Tasks' table which is available on the L4-L7 App Services Tab. If such pending tasks exist on multiple BIG-IPs at once, it is possible that the status of such pending tasks is not updated properly in the UI.

**Workaround**: Wait for a maximum of 2 minutes to see if the pending task status gets updated. If not, the workarounds to try are: 1. Switch the tab and come back to L4-L7 App Services and check the task status. 2. Re-login to the BIG-IP where the pending task status is not updated. 

-------

**Success message for AS3 declaration submission is hidden behind the UI loader**

For big AS3 declarations with multiple partitions or applications, it is observed that the success response message is observed in the background of the UI loader. 

**Workaround**: Check the L4-L7 App Services --> Application Inventory sub-tab to see if the application add/remove/update operation was successful. If the submitted applications are not added/removed from application inventory as expected, please click on the "Pending Tasks" icon to see if the task is still being processed by the BIG-IP.

-------

