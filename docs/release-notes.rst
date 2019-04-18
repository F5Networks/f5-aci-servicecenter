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

**L2-L3 Stitching - VLAN naming convention and its affect on VLAN tag change**

.. note::
   At any point in time, if a VLAN tag is changed through the application, it may overwrite a pre-existing VLAN on the BIG-IP device.

The application auto-generates names for VLANs, self IPs, and default gateways.

The naming conventions is:

VLANs: ``apic-vlan-<Logical Device Name>-<VLAN tag>``

Self IPs: ``apic-vlan-<Logical Device Name>-<Logical Interface Name>-<Self
IP Address>``

Default Gateway: ``apic-default-gateway``

When APIC VLAN tag changes on the APIC for some logical interface
(either due to manual change by administrator or due to APIC
snapshot-revert or any other reason), the app detects this change and
displays a warning for the corresponding VLAN. If you decide to change
the VLAN tag from the application for this VLAN to match the APIC VLAN, the
application deletes and recreates the VLAN/self IPs with the new name and
tag to match the above VLAN naming convention. There will be traffic
loss during this configuration change.

------

**BIG-IP version 12.1 behavior for deleting VLANs**

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

**Out-of-sync cases for same APIC logical device name under different
tenants with same VLAN tag**

*Example 1:* There are two logical devices with the name ``ldevCommon``, one
under TenantA and one under TenantB. Also, ``ldevCommon`` has the same set of
VLANs configured: ``internal: vlan-24``, ``external: vlan-25``. Both these
logical devices can be seen in L2-L3 stitching list and can be
selected for stitching with BIG-IP. TenantA LDEV is stitched to BIG-IP,
the names of the VLANs created on the BIG-IP will be:

``apic-vlan-ldevCommon-24``

``apic-vlan-ldevCommon-25``

Because these are the same as names that would have been generated for
TenantB LDEV vlans as well, they will appear as Out-of-sync on the other
LDEV list for that BIG-IP login. If synced to App, the VLAN from the
app database will be moved from one LDEV to other.

*Example 2:* In the above case, the self IPs configured with one LDEV
may appear as Out-of-band self IPs on the second LDEV list for the
same BIG-IP device.

*Example 3:* There are two logical devices with different names that
share the same VLAN tag, say ``vlan-24``, and the VLAN is stitched for one of
the LDEVs. The other LDEV’s info page will show the first VLAN as an
out-of-band VLAN.

.. note::
   To avoid this, the LDEV VLANs that are to be stitched with the same BIG-IP device should have a
   different set of VLAN tags, because BIG-IP only supports one set of VLAN
   tags.

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
