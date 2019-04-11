FAQ
---

**Q1. Why do I see an error “Failed to reach the container” on the application GUI?**

The application backend is running as a docker container on ACI’s APIC server. 

For the legacy apps, the health-thread APIC at first checks the health of Gluster-FS (APIC filesystem), and if it passes, then it checks if the app’s docker container is able to access it’s data folder under Gluster-FS, and if it is not the case it restarts the application container. There can be few other reasons due to which ACI app framework can restart app’s backend container. In such cases the application GUI will show the error “Failed to reach the container”. 

After the container restart, a new container will run the application’s backend. The application will do a stateful restart and any data available before the restart should be available post new container launch. As a result the even though application might be momentarily unavailable during the restart and show the above error, it should be able to recover from it gracefully. 

.. note::
   Downtime in case of APIC cluster size change:
   Users may observe upto 3 minutes of downtime for the Application if the APIC cluster node - Hosting Application container- is rebooted. In this case, it takes 3 minutes for APIC Cluster to bring up new container on the other currently available APIC nodes. The same behavior is observed when the APIC node undergoes Commission/Decommission steps.

   If All APIC cluster nodes are rebooted accidently at the same time, it may take upto 20 minutes for the Application to be up after all nodes rebooted.

**Q2. Why is my L4-L7 Configuration tab disabled?**

f5-appsvcs RPM of version 3.7.0  or higher is required for L4-L7 configuration tab to work correctly. Please follow installation steps from https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html#installation

**Q3. Why is there a warning about "f5-appsvcs package" installation when I log in to my BIG-IP device?**

See answer to FAQ Q1

**Q4. Why do I still see partitions in the AS3 declaration after deleting the entire declaration from F5 ACI ServiceCenter application?**

AS3 declaration which contains “optimisticLockKey” mentioned explicitly may lead to the case where the AS3 configuration is not completely deleted even after multiple attempts from the Application UI. However, the configuration gets cleaned from BIG-IP device.

Workaround: This is a known AS3 issue and the workaround for this is to upload one more AS3 sample declaration to App and then perform Delete all operation. (Use View AS3 Declaration followed by Delete button press.)

**Q5. When I try to stitch a VLAN tag, why do I see “VLAN not available for stitching”? I’m not able to configure the VLAN.**

For a single BIG-IP device, once a VLAN tag is stitched for a particular Logical device (say ldev1), the same VLAN tag is not available for stitching again for a different Logical device (say ldev2). This is because, the VLAN tag is already present on the mentioned BIG-IP device hence re-creating it for a different logical device is not allowed. In order to proceed with stitching, please delete the original VLAN from the stitched LDEV, which is mentioned in this VLAN card’s info message. 

.. note::
   For a different BIG-IP login, this stitched VLAN tag will still be available for configuration. 

**Q6. Why do VLANs from F5 ACI ServiceCenter application visibility table vanish if I destroy and re-create service graph template of my VIRTUAL Logical Device on Cisco APIC?**

For virtual ADC logical devices, in case of the following steps 1. Take snapshot 2. Delete service graph template 3. Revert to snapshot config, it is observed that the VLAN encap values associated with logical interfaces of the LDEV change and do not remain same. 

The application will detect this change and show a warning on the L2-L3 stitching LDEV info page which displays VLANs. User will be able to click on the warning to update the VLAN tag. This will lead to delete and re-create of VLAN and associated Self IPs and there will be traffic loss. 

Once VLAN tag is updated on BIG-IP, the visibility vlan table will start showing the VLANs again. 

**Q7. Why don’t I see the pre-existing VLANs and Self IPs from BIG-IP which have a different naming convention than the application?**

The application does not support pre-existing VLANs Network configuration (L2-L3 configuration) which have a different naming convention than App. Hence, it will only be able to detect those VLANs which have been created and managed from the application. Although, after uninstalling and reinstalling an application, if the app database is lost, the application will be able to detect the previously created VLANs by reading BIG-IP information and show them as Out-of-sync VLANs. They will also be able to sync it to the application to rebuild App Database. Please see Release Note 1. For more details.

The application displays APIC VLAN tags for a particular Logical Device Cluster on the L2-L3 stitching page. If there is an out-of-band VLAN with different naming convention but same VLAN tag, on the BIG-IP device, the application will detect it and show it in the Out-of-sync information too. But the only action available for such a VLAN or Self IP will be deletion of that object from BIG-IP. It will not be allowed to sync to application, since it has a different naming convention. Also the application will not detect such out-of-band information for any of the other VLAN tags which are not a part of APIC VLAN list. 

**Q8. For L4-L7 App Service tab, why does the partition get deleted when I delete the last application belonging to that partition?**

If there is a single application in a particular partition, and if that application is deleted through the application. The corresponding partition which has no other applications under it, will also get deleted from the BIG-IP device. This is the standard F5 BIG-IP behavior. The user will be warned about this in the delete confirmation prompt with an info alert.

**Q9. What is the best way to delete LDEV from APIC ?**

Please don’t delete SelfIPs, VLANs and Device from APIC directly. Instead, as a first step, delete SelfIPs, VLANs and routes from the BIG-IP device using the application. Once done, you can delete the Logical Device from APIC. This will ensure that there are no stale SelfIP, VLAN and route entries on BIG-IP.

**Q10. Why did I see the following error on app “BIG-IP session timed out. Please login again.”?**

Every BIG-IP session on the app has an operation-idle time out of 10 minutes. Hence, if the user does not carry out any operations on a BIG-IP session of the application for 10 minutes, the user will see the above error. This timeout check is triggered only on tab switch, or on left-hand menu item click for logged in BIG-IP devices.

**Q11. Why do I get error for VLAN tag change/VLAN Delete/SelfIP Delete operation from the App?**

This is a known issue for BIG-IP v12.X. If a pool with nodes is associated with a SelfIP of the same subnet, BIG-IP doesn’t allow user to delete that Self IP and as a result, the VLAN delete operation also fails with the error.

**Q12. Which browsers are supported?**

The app has been tested with IE11, Mozilla FireFox 56 and Google Chrome v72.

**Q13. What are the scale numbers tested with the App?**

+-----------------------------------+----------------+
| Particulars                       | Scale          | 
+===================================+================+
| Number of BIG-IPs                 | 60             |
+-----------------------------------+----------------+
| Per BIG-IP paritions              | 100            | 
+-----------------------------------+----------------+ 
| Per BIG-IP Virtual IPs            | 100            |
+-----------------------------------+----------------+
| APIC Logical devices              | 60             | 
+-----------------------------------+----------------+ 
| Per BIG-IP nodes members          | 4              | 
+-----------------------------------+----------------+
| Concurrent App operations         | 4 BIG-IPs      | 
+-----------------------------------+----------------+  
