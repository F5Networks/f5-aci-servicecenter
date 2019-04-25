Release Notes 
-------------

Version 1.0
```````````

**I/O Error**

When you try to access the App through the UI you might see the following error: ``disk I/O error (sqlite OperationError)``. You will not be able to perform any additional actions. 

To fix this issue, the underlying server must be restarted and the file system remounted. These actions require root access to the APIC.

`Create an issue on GitHub <https://github.com/F5Networks/f5-aci-servicecenter/issues>`_ for assistance. 



------

**L2-L3 Stitching - Out-of-sync floating self IPs and default route in HA cluster**

When there are two BIG-IP devices in an HA cluster, the application shows them under a cluster name.

If you use the app to configure a floating self IP address on one of the peers of the HA cluster, the floating self IP will sync to the second peer from BIG-IP out-of-band. This is standard BIG-IP HA behavior. But if you log in to the second peer from the app, you will see the newly synced self IP from the first peer in the ‘Out-of-sync’ link. You must manually sync it to the app’s database. There is no automatic sync for floating IPs.

This same bevavior is true for default gateways in an HA cluster.
   
**Workaround**: After the HA route or floating self IP is seen as Out-of-sync on the VLAN card, click the link and sync it to the application.   

------

**BIG-IP version 12.1 behavior for deleting VLANs** (To be discussed)

In the above scenario of VLAN tag change, if a VLAN has an associated self IP of ``192.168.10.10/24`` and there are pool members in the same subnet with IP ``192.168.10.X``, then you will see an error similar to: `“Cannot delete IP 192.168.10.10 because it would leave a pool member (pool Common/web-pool) unreachable”`. 

This error is due to the VLAN/self IP delete and recreate during VLAN change and BIG-IP not allowing original self IP create because it has pool members in the same subnet. This is specific to BIG-IP version 12.X and will not be seen in BIG-IP releases 13.1 and above. 

**Workaround**: 

1. Delete the corresponding pool member from BIG-IP.

2. Do the VLAN tag change from app.

3. Recreate the pool member on BIG-IP.

.. note::
   The VLAN naming convention has the VLAN tag since that is
   the only uniquely identifying property for a VLAN, since the Logical
   Device Cluster name can be shared by multiple such VLANs. Also, the
   BIG-IP devices have a restriction of 64 characters for VLAN names, and
   hence other unique properties from APIC such as Ldev+Logical Interface
   or Ldev + Logical Interface Context cannot be included in the name since
   they have longer Max Lengths than 64 characters.

------

**L4-L7 App Services - AS3 declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the AS3 configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration gets removed from the BIG-IP device.

**Workaround**: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)


------

**Application GUI stops showing loader before API call returns**

On certain app UI operations, like tab switch, or log in to a new BIG-IP device, multiple REST API calls are triggered simultaneously from the GUI. Until the API calls return a response, the app shows “Loading” and a message stating “Retrieving information from APIC and F5 BIG-IP. This may take a few seconds.” Currently, as soon as one of the simultaneous API calls returns a response, the application stops showing the “Loading” message even before some of the page is populated.

**Workaround**: Wait a few more seconds for the page to load. This may be especially true on scale setups:

- With large numbers of APIC logical devices on the L2-L3 Stitching page
- With large numbers of BIG-IP partitions on the Applications sub-tab of L4-L7 App Services page

------

**Operations on “L4-L7 App Services” tab of a scale setup**

AS3 3.7.0 introduces new behavior for asynchronous mode. Even if you have asynchronous mode set to false (which is the mode used by the F5 ACI ServiceCenter application), after 45 seconds, AS3 sets asynchronous mode to true, and returns an async response. This typically occurs only with very large declarations to BIG-IP; if the declaration completes in less than 45 seconds, AS3 does not fall back to asynchronous mode. 

Currently the application is not handling this async AS3 behavior. For example, in scale setups with 100 partitions in the AS3 declaration, it might take more than 45 seconds to delete the AS3 declaration through the application. In this case, the :guilabel:`Partition` list of L4-L7 App Services may show an old set of partitions, or the :guilabel:`View Declaration` button of the tab may show the old declaration. 

Check this site for more details on the async behavior:
https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/as3-api.html

**Workaround**: On a scaled BIG-IP setup, wait a few minutes after performing an AS3 API call through the app. This allows the AS3 update to be reflected in the GET call of the AS3 declaration. 

---------

**Simultaneous editing of multiple BIG-IP's through a browser**

If 2 different BIG-IPs A and B are being accessed on neighbouring browser tabs, it is possible that the A's tab will display data from B. 

**Workaround**: Use separate browser windows to work on separate BIG-IP devices in parallel. 
