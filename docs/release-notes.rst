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

**Workaround**: On a scaled BIG-IP setup, wait a few minutes after performing an AS3 API call through the app. This allows the AS3 update to be reflected in the GET call of the AS3 declaration. 
