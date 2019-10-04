Release Notes (Version 2.0)
===========================

General
-------

**F5 ACI ServiceCenter Upgrade is not supported from Version 1.0 to Version 2.0**

The F5 ACI ServiceCenter application does not have upgrade support from Version 1.0 to Version 2.0. In order to install a new version of the app the steps to be followed are:
1. Uninstall the existing Version 1.0 of the application from APIC Apps tab.
2. Install and enable Version 2.0 of the application by downloading it from https://dcappcenter.cisco.com/
Note: App upgrades will be supported in version 2.0 and higher


L2-L3 Network Management
------------------------

**Error “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“**

getldevinfo.json and createbigipvlan.json APIs will show an error of the type “Invalid DN <someDn>, wrong rn prefix <somePrefix> at position X/Y“

Root-cause: During vlan creation using createbigipvlan.json API, the VLAN table in the F5 ACI ServiceCenter saves VLAN database entries. One of the fields in the VLAN table is the lifDn which is the Distinguished name of Logical Interface (in the Logical device) on APIC. If during App REST API automation, anyone creates a VLAN using createbigipvlan.json and enters invalid string in lifDn parameter of the API instead of the valid input for lifDn, the app will accept it. And on a subsequent call to getldevinfo.json or createbigipvlan.json throw the aformentioned error.

**Workaround**: Uninstall and re-install the application to clean out the F5 ACI ServiceCenter database.

------


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


L2-L3 stitching
---------------

**Out-of-sync floating self IPs and default route in HA cluster**

When there are two BIG-IP devices in an HA cluster, the application shows them under a cluster name.

If you use the app to configure a floating self IP address on one of the peers of the HA cluster, the floating self IP will sync to the second peer from BIG-IP out-of-band. This is standard BIG-IP HA behavior. But if you log in to the second peer from the app, you will see the newly synced self IP from the first peer in the ‘Out-of-sync’ link. You must manually sync it to the app’s database. There is no automatic sync for floating IPs.

This same behavior is true for default gateways in an HA cluster.
   
**Workaround**: After the HA route or floating self IP is seen as Out-of-sync on the VLAN card, click the link and sync it to the application.   

**Update for v2.0**: This has been fixed in app version 2.0 and the floating self IP will not be seen as Out-of-sync provided the peer device is also logged in from app UI.

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



