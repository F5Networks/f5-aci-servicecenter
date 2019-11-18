FAQ
===

Application Errors
------------------

**Q. Why do I see an error "Failed to reach the container" on the application GUI?**

The application back end is running as a Docker container on ACI’s APIC server. 

For legacy apps, the health-thread APIC checks the health of Gluster-FS (APIC filesystem). If it passes, it checks to ensure the app’s Docker container is able to access it's data folder under Gluster-FS. If it is not able, it restarts the application container. 

There are a few other reasons why the ACI app framework might restart an app’s backend container. In these cases, the application GUI will show the error "Failed to reach the container." 

After the container restarts, a new container runs the application’s back end. The application does a stateful restart and any data available before the restart should be available when the new container is launched. As a result, even though the application might be momentarily unavailable during the restart and show the error, it should recover gracefully. 

Expected downtime:

- If an APIC cluster size changes and the APIC cluster node - Hosting Application container - reboots, you can expect up to three minutes of downtime for the application. It takes three minutes for APIC cluster to bring up a new container on the other currently available APIC nodes. The same thing happens when the APIC node undergoes Commission/Decommission.

- If all APIC cluster nodes are rebooted accidentlly at the same time, it may take up to twenty minutes for the application to be up.

------

**Q. In the app, why do I see the error “BIG-IP session timed out. Please log in again.”?**

Every BIG-IP session on the app has an operation-idle time out of 10 minutes. If you do not carry out any operations on a BIG-IP session of the application for 10 minutes, you will see the above error. This timeout check is triggered only on tab switch, or on left-hand menu item click for logged in BIG-IP devices.

------

**Q. In the app, why do I see the error “ERROR : Request failed due to server side error” on APIC?**

If App UI is accessed from 2 parallel browser tabs with certificate warnings enabled from only one of the tabs, it may generate this error: “Error: Request failed due to server side error”

**Workaround:** Login to APIC again

Visibility
----------

**Q. Why do VLANs from the F5 ACI ServiceCenter application visibility table vanish if I destroy and re-create service graph template of my VIRTUAL Logical Device on Cisco APIC?**

For virtual ADC logical devices, if you did the following steps 

-  Take snapshot 

-  Delete service graph template 

-  Revert to snapshot config

The VLAN encap values associated with logical interfaces of the LDEV change and do not remain the same. The application detects this change and shows a warning on the L2-L3 stitching LDEV info page that displays VLANs. You can click the warning to update the VLAN tag. 

After a VLAN tag is updated on BIG-IP, the visibility vlan table will start showing the VLANs again.

L2-L3 stitching
---------------

**Q. Why do I get an error for VLAN/self IP delete operation from the App?**

This is a known issue for BIG-IP v 12.x. If a pool with nodes is associated with a self IP of the same subnet, BIG-IP doesn’t allow user to delete that self IP. As a result, the VLAN delete operation also fails with the error.

**Workaround:**

- Delete the corresponding pool member from BIG-IP.

- Perform the VLAN/self IP delete from App.

- Recreate the pool member on BIG-IP.

------

**Q. When I try to stitch a VLAN tag, why do I see “VLAN not available for stitching”? Not able to configure the VLAN.**

For a single BIG-IP device, after a VLAN tag is stitched for a particular logical device (say LDEV1), the same VLAN tag is not available for stitching again for a different Logical device (say LDEV2). This is because the VLAN tag is already present on the BIG-IP device and re-creating it for a different logical device is not allowed. In order to proceed with stitching, delete the original VLAN from the stitched LDEV, which is mentioned in this VLAN card’s info message. 

.. note::
   For a different BIG-IP login, this stitched VLAN tag will still be available for configuration. 

------

**Q. Why don’t I see the pre-existing BIG-IP VLANs and self IPs that have a different naming convention than the application?**

The application does not support pre-existing VLANs that have a different naming convention than the app. It is able to detect VLANs that have been created and managed from the application only. 

Although, after uninstalling and reinstalling the application, if the app database is lost, the application will be able to detect the previously created application VLANs by reading BIG-IP information and show them as Out-of-sync VLANs. The users will also be able to sync them to the application to rebuild App Database.

The application displays APIC VLAN tags for a particular Logical Device Cluster on the L2-L3 stitching page. If there is an out-of-band VLAN with different naming convention but same VLAN tag on the BIG-IP device, the application detects it and shows it in the Out-of-sync information too. But the only action available for such a VLAN or self IP will be deletion of that object from BIG-IP. It cannot sync to application, since it has a different naming convention. The application also does not detect out-of-band information for any of the other VLAN tags that are not a part of APIC VLAN list. 

L4-L7 Application Services
--------------------------

**Q. Why is my L4-L7 Configuration tab disabled?**

For the L4-L7 configuration tab to work correctly, f5-appsvcs RPM version 3.14.0 or later is required. Installation steps are available here: https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html#installation

------

**Q. Why is there a warning about "f5-appsvcs package" installation when I log in to my BIG-IP device?**

See above.

------

**Q. I deleted an application services declaration from the F5 ACI ServiceCenter application. Why do I still see partitions in the declaration?**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the AS3 configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration gets removed from the BIG-IP device.

Workaround: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

------

**Q. For L4-L7 App Service tab, why does the partition get deleted when I delete the last application belonging to that partition?**

If there is a single application in a particular partition, and if that application is deleted through the application, the partition that has no other applications under it will be deleted from the BIG-IP device. This is standard F5 BIG-IP behavior. You will be warned about this in the delete confirmation prompt.

------

**Q. When I create an AS3 application using the L4-L7 Application Services → Application → Basic tab, I don’t see this application listed under L4-L7 Application Services → Application → Advanced tab. How shall I view the raw JSON of this AS3 application?**

The Basic and Advanced sub-tabs of 'L4-L7 Application Services → Application' tab list only the applications created from the respective tabs. If you wish to view details (raw JSON) of any AS3 application, please go to L4-L7 Application Services → Application Inventory tab which lists all the applications. Traverse to row with the application of interest and click on the “View Application JSON” icon in the “Action” column to view the raw JSON.

------

**Q. When I create an AS3 application using the L4-L7 Application Services → Application → Basic tab, can I update this application via Application Services → BIG-IP tab?**

The application created through the L4-L7 Application Services → Application → Basic tab should be updated through the same tab. If for some reason it needs to be updated via the BIG-IP tab; For example, if the virtual server address is to be updated from X to Y, then the same value needs to get updated from X to Y in the Constants → appsvcsFormData section of the application JSON from the BIG-IP tab. If the constants section is not updated, it will show inconsistent values when traversed back to Basic tab.

------

**Q. When new endpoints get added on APIC, why aren't the endpoints getting updated on BIG-IP device.** (Applicable to Version 2.1+)

There is a websocket connection between the F5 ACI ServiceCenter and APIC to listen to new endpoint creation and endpoint deletion. If there is an issue with the websocket or the endpoint notification subscriptions, those errors will get logged in the log files on APIC. So please check the files for more details about end point attach detach.

- User may observe the error ““Unrecoverable error occurred while creating APIC webosocket….” in websocket error log file: /data2/logs/F5Networks_F5ACIServiceCenter/f5_apic_websocket.log

OR

- User may observe the error: “Failed to get a new subscription. Subscription Refresh Thread stopped for APIC for…“ in subscription errors log file: /data2/logs/F5Networks_F5ACIServiceCenter/f5_apic_subscription.log

**Workaround**: For any of the above errors in log files: please disable and re-enable the F5 ACI ServiceCenter application to fix the dynamic endpoint attach detach functionality. This will not affect the state of the F5 ACI ServiceCenter and all the data and configuration will still be intact after the disable and re-enable steps.

OR

- User may observe the error: "Websocket error: [SSL: DH_KEY_TOO_SMALL] dh key too small (_ssl.c:727)"

**Workaround**: Decomission and recomission the APIC on which F5 ACI ServiceCenter is running. The APIC on which the app is running can be found by going to System --> Controllers --> Controllers --> (APIC name) --> Containers and checking if the F5Networks_F5ACIServiceCenter is present. 

------


Other
-----

**Q. F5 ACI SeviceCenter is taking longer time to respond or has hanged.**

If F5 ACI ServiceCenter UI is taking more than 3 minutes to display response, then check f5.log file, which may display a warning:
"Acquiring a bigipdict RWlock has taken more than 180  seconds. Executing reader_release() to unlock the lock". Once this warning is observed, F5 ACI ServiceCenter will resume the stuck operation become responsive again.

------

**Q. F5 ACI ServiceCenter throws ‘Database is locked’ error.**

If F5 ACI ServiceCenter throws database is locked error, then retry the operation that caused this error and the operation should proceed without errors.

------

**Q. What is the best way to delete LDEV from APIC?**

Do not delete Logical devices from APIC directly. Instead, as a first step, delete self IPs, VLANs and routes from the BIG-IP device by using the application. When you are done, you can delete the Logical Device from APIC. This ensures there are no stale self IP, VLAN, and route entries on BIG

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

Note: For L4-L7 App Services tab to get enabled, minimum AS3 plugin version required is 3.14

Note: Endpoint attach detach feature is supported only for BIG-IP v13.0 and higher

+--------------------------------+-----------------+------------------------------+--------------------+------------------------+
| BIG-IP Type                    | Visibility      | L2-L3 Network Management     | L4-L7 App Services | Endpoint Attach Detach |
+================================+=================+==============================+====================+========================+
| Physical/VE Standalone         | Yes             | Yes                          | Yes                | Yes (Version 2.1+)     |
+--------------------------------+-----------------+------------------------------+--------------------+------------------------+
| Physical/VE High Availability  | Yes             | Yes                          | Yes                | No                     |
+--------------------------------+---+-------------+------------------------------+--------------------+------------------------+
| vCMP Host Standalone           | VLAN table only | VLAN only                    | No                 | No                     |
+--------------------------------+---+-------------+------------------------------+--------------------+------------------------+
| vCMP Host High Availability    | No              | No                           | No                 | No                     |
+--------------------------------+-----------------+------------------------------+--------------------+------------------------+
| vCMP Guest Standalone          | Yes             | Self IP/Default Gateway only | Yes                | Yes (Version 2.1+)     |
+--------------------------------+-----------------+------------------------------+--------------------+------------------------+
| vCMP Guest High Availability   | Yes             | Self IP/Default Gateway only | Yes                | No                     |
+--------------------------------+-----------------+------------------------------+--------------------+------------------------+
