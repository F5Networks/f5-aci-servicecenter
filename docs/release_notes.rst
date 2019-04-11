Release Notes 
-------------

Version 1.0
```````````

**L2-L3 Stitching - Out-of-sync for Floating Self-IPs and Default Route
in HA cluster**

When there are 2 BIG-IP devices in an HA cluster, the application shows
them under a cluster name.

a. If a Floating Self IP is configured on one of the peers of the HA
   cluster through the app, this Self IP will sync to the second peer
   from BIG-IP out of band. This is standard BIG-IP HA behavior. But if
   the user logs in to the second peer from app, they will see this
   newly synced Self IP from first peer in the ‘Out-of-sync’ link. They
   will have to manually sync it to app’s database. I.e. there is no
   automatic sync for Floating IPs.

b. Same behavior as a. will be observed for default gateway in HA
   cluster which are synced between peer devices.
   
Workaround: Once the HA route or floating Self IP is seen as Out-of-sync on the VLAN card, click on the link and sync it to the application    

**L2-L3 Stitching - VLAN Naming Convention and its effect on VLAN tag
change**

.. note::
   At any point in time if VLAN tag is changed through the
   application in an incorrect manner, it is possible that it overwrites
   some other pre-existing VLANs on the BIG-IP device.

The application does not allow users to configure VLAN names, Self IP
names or Default Gateway names, and those are auto generated from
application. The naming conventions are as below:

VLANs: apic-vlan-<Logical Device Name>-<VLAN tag>

Self IPs: apic-vlan-<Logical Device Name>-<Logical Interface Name>-<Self
IP Address>

Default Gateway: apic-default-gateway

When APIC VLAN tag changes on the APIC for some Logical interface
(either due to manual change by administrator) or due to APIC
snapshot-revert or any other reason, the app will detect this change and
display a warning for the corresponding VLAN. If user decides to change
the VLAN tag from application for this VLAN to match the APIC VLAN, the
application will delete and recreate VLAN/Self IPs with the new name and
tag to match the above VLAN naming convention. There will be traffic
loss during such a configuration change.

.. note:: 
   BIG-IP version 12.1 behavior for Delete VLANs
   In the above scenario of VLAN tag change, if VLAN has an associated Self IP say 192.168.10.10/24 and there are pool members in the   
   same subnet with IP 192.168.10.X, then the user will see an error similar to: “Cannot delete IP 192.168.10.10 because it would leave    a pool member (pool Common/web-pool) unreachable”. 

   This error is seen due to the VLAN/Self IP delete and recreate during VLAN change and BIG-IP not allowing original Self IP create    
   because it has pool members in the same subnet. This is specific to BIG-IP version 12.X and will not be seen in BIG-IP releases 13.1 
   and above. 

   Workaround: 
   (1) Delete the corresponding pool member from BIG-IP 
   (2) Do the VLAN tag change from app 
   (3) Recreate the pool member on BIG-IP

.. note::
   The VLAN naming convention has the VLAN tag since that is
   the only uniquely identifying property for a VLAN, since the Logical
   Device Cluster name can be shared by multiple such VLANs. Also, the
   BIG-IP devices have a restriction of 64 characters for VLAN names, and
   hence other unique properties from APIC such as Ldev+Logical Interface
   or Ldev + Logical Interface Context cannot be included in the name since
   they have longer Max Lengths than 64 characters.

**Out-of-sync cases for same APIC Logical device name under different
Tenants with same VLAN tag.**

*Example 1:* There are two Logical devices with name ldevCommon one
under TenantA and one under TenantB. Also, ldevCommon has same set of
VLANs configured: internal: vlan-24, external: vlan-25. Both these
Logical devices can be seen in L2-L3 stitching drop-down and can be
selected for stitching with BIG-IP. TenantA LDEV is stitched to BIG-IP,
the names of the VLANs created on the BIG-IP will be:

apic-vlan-ldevCommon-24

apic-vlan-ldevCommon-25

Since these are the same as names which would have been generated for
TenantB LDEV vlans as well, they will appear as Out-of-sync on the other
LDEV drop-down for that BIG-IP login. If synced to App, the VLAN from
APP DB will be moved from one LDEV to other.

*Example 2:* In the above case, the Self IPs configured with one LDEV
may appear as Out-of-band Self IPs on the second LDEV drop-down for the
same BIG-IP device.

*Example 3:* There are two logical devices with different names which
share the same VLAN tag, say vlan-24, and VLAN is stitched for one of
the LDEVs. The other LDEV’s info page will show the first VLAN as an
out-of-band VLAN.

.. note::
   To avoid such cases, it is advisable that the LDEV VLANs
   which are to be stitched with the same BIG-IP device should have
   different set of VLAN tags, since on BIG-IP only one set of the VLAN
   tags will be supported.

**L4-L7 App Services - AS3 declaration which contains
“optimisticLockKey” mentioned explicitly may lead to the case where the
AS3 configuration is not completely deleted even after multiple attempts
from the Application UI. However, the configuration gets cleaned from
BIG-IP device.**

**Workaround:** This is a known AS3 issue and the workaround for this is to
upload one more AS3 sample declaration to App and then perform Delete
all operation. (Use View AS3 Declaration followed by Delete button
press.)

**Application GUI stops showing loader before API call returns**

On certain app UI operations such as tab switch, or login to a new BIG-IP device, multiple REST API calls are triggered simultaneously from the GUI to load the contents of the page. Until the API calls return the App UI shows the “Loading” sign and also a help message saying “Retrieving information from APIC and F5 BIG-IP. This may take a few seconds.” But the current UI behavior is such that as soon as one of the simultaneous API calls returns, the UI loader stops showing the “Loading” sign even before some of the data (such as drop-down boxes) are populated.

Workaround: Please wait for few more seconds to re-check the data on the page to get updates. This may be especially true on scale setups 
-	With large number of APIC logical devices on the L2-L3 Stitching page
-	With large number of BIG-IP partitions on the Applications sub-tab of L4-L7 App Services page

**Operations on “L4-L7 App Services” tab of a scale setup**

AS3 3.7.0 introduces new behavior for asynchronous mode. Even if you have asynchronous mode set to false (which is the mode used by F5 ACI ServiceCenter application), after 45 seconds AS3 sets asynchronous mode to true, and returns an async response. This typically occurs only with very large declarations to BIG-IP; if the declaration completes in less than 45 seconds, AS3 does not fall back to asynchronous mode. 

Currently the application is not handling this above mentioned async AS3 behavior. For example, in scale setups with 100 partitions in the AS3 declaration, it might take more than 45 seconds to delete the AS3 declaration through the application. In such cases, the partition drop-down list of L4-L7 App Services may show old set of partitions, or the view declaration button of the tab may keep showing the old declaration. 

Please check F5 cloud docs for more details on the async behavior:
https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/refguide/as3-api.html

Workaround: Wait for the few minutes after performing an AS3 API call through the app (on a scaled BIG-IP setup) for the AS3 update to be reflected in the GET call of AS3 declaration. 
