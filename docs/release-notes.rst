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


Release Notes (Version 2.0)
===========================

General
-------

**F5 ACI ServiceCenter Upgrade is not supported from Version 1.0 to Version 2.0**

The F5 ACI ServiceCenter application does not have upgrade support from Version 1.0 to Version 2.0. In order to install a new version of the app the steps to be followed are:
1. Uninstall the existing Version 1.0 of the application from APIC Apps tab.
2. Install and enable Version 2.0 of the application by downloading it from https://dcappcenter.cisco.com/
Note: App upgrades will be supported in version 2.0 and higher

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

Visibility
----------

**VIP table does not show nodes where node name and node IP are different** (Fixed in v2.1)

Workaround: Ensure that all nodes on the BIG-IP have the name same as it's IP address


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

**Operations on “L4-L7 App Services” tab of a scale setup**

AS3 3.7.0 introduces new behavior for asynchronous mode. Even if you have asynchronous mode set to false (which is the mode used by the F5 ACI ServiceCenter application), after 45 seconds, AS3 sets asynchronous mode to true, and returns an async response for the AS3 operation. This typically occurs only with very large declarations to BIG-IP; if the declaration completes in less than 45 seconds, AS3 does not fall back to asynchronous mode.

Currently the application is not handling this async AS3 behavior. For example, in scale setups with 100 partitions in the AS3 declaration, it might take more than 45 seconds to delete the AS3 declaration through the application. In this case, the Partition list of L4-L7 App Services may show an old set of partitions, or the View Declaration button of the tab may show the old declaration.

Check this site for more details on the async behavior:
https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/as3-api.html

**Workaround**: On a scaled BIG-IP setup, after submitting an AS3 application or AS3 declaration through L4-L7 App Services tab, you may see a warning “BIG-IP is processing the request. Please click 'Refresh' icon on the BIG-IP tab to view the latest AS3 declaration“. When you see this warning, please wait a few minutes after performing any further AS3 API calls through the app. This allows the AS3 update to be reflected in the GET call of the AS3 declaration. After waiting for a few minutes, click on refresh button on the UI screen to check if the changes you submitted got updated in the AS3 declaration.

-------

Release Notes (Version 1.0)
===========================

General
-------

**File system convergence**

APIC Filesystem Glusterfs takes 15 to 20 Minutes to recover when APIC cluster goes unhealthy

During the APIC operations like APIC reboot, upgrade, or decommission/recommission, the APIC filesystem needs some time to recover and resume. 

Symptoms users may see:
1. Application operations throw a (sqlite3.OperationalError) disk I/O error 
2. User may not find previously added BIG-IP entries in the application
3. New Application installation may fail

**Workaround**: Wait for 20 minutes and try to access the application again. The Glusterfs should recover within some time automatically and the application should be accessible again.  

------

**Database locked Error**

When trying to access the App through the UI, following error might occur: "(sqlite3.OperationalError) database is locked". 

**Workaround**: Wait for 10-15 minutes and try to access the application again. This issue should get resolved automatically and the application should be accessible again. 

------

**Custom Docker 0 Bridge IP not supported**

On APIC, if Custom Docker 0 Bridge IP other than 172.17.0.1 is used, F5 ACI ServiceCenter will not be able to support it. It will not be able to communicate with APIC as expected. 

Users will see an error similar to "HTTPSConnectionPool(host='172.17.0.1', port=443): Max retries exceeded with url"

**Workaround**: Use default Docker 0 Bridge IP: 172.17.0.1

**Fix**: Fixed in F5 ACI ServiceCenter v2.2

------



L2-L3 stitching
---------------

**Out-of-sync floating self IPs and default route in HA cluster**

When there are two BIG-IP devices in an HA cluster, the application shows them under a cluster name.

If you use the app to configure a floating self IP address on one of the peers of the HA cluster, the floating self IP will sync to the second peer from BIG-IP out-of-band. This is standard BIG-IP HA behavior. But if you log in to the second peer from the app, you will see the newly synced self IP from the first peer in the ‘Out-of-sync’ link. You must manually sync it to the app’s database. There is no automatic sync for floating IPs.

This same behavior is true for default gateways in an HA cluster.
   
**Workaround**: After the HA route or floating self IP is seen as Out-of-sync on the VLAN card, click the link and sync it to the application.   

**Update for v2.0+**: This has been fixed in app version 2.0 and the floating self IP will not be seen as Out-of-sync provided the peer device is also logged in from app UI.

L4-L7 App Services
------------------

**Application services declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the Application Services configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration gets removed from the BIG-IP device.

**Workaround**: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

-------

**Operations on “L4-L7 App Services” tab of a scale setup**

AS3 3.7.0 introduces new behavior for asynchronous mode. Even if you have asynchronous mode set to false (which is the mode used by the F5 ACI ServiceCenter application), after 45 seconds, AS3 sets asynchronous mode to true, and returns an async response for the AS3 operation. This typically occurs only with very large declarations to BIG-IP; if the declaration completes in less than 45 seconds, AS3 does not fall back to asynchronous mode.

Currently the application is not handling this async AS3 behavior. For example, in scale setups with 100 partitions in the AS3 declaration, it might take more than 45 seconds to delete the AS3 declaration through the application. In this case, the Partition list of L4-L7 App Services may show an old set of partitions, or the View Declaration button of the tab may show the old declaration.

Check this site for more details on the async behavior:
https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/as3-api.html

**Workaround**: On a scaled BIG-IP setup, after submitting an AS3 application or AS3 declaration through L4-L7 App Services tab, you may see a warning “BIG-IP is processing the request. Please click 'Refresh' icon on the BIG-IP tab to view the latest AS3 declaration“. When you see this warning, please wait a few minutes after performing any further AS3 API calls through the app. This allows the AS3 update to be reflected in the GET call of the AS3 declaration. After waiting for a few minutes, click on refresh button on the UI screen to check if the changes you submitted got updated in the AS3 declaration.


