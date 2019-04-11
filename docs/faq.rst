FAQ
---

**Q1. Why is my L4-L7 Configuration tab disabled?**

The f5-appsvcs RPM version 3.7.0 or later is required for the L4-L7
configuration tab to work correctly. Please follow the installation steps
here: https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html#installation

**Q2. Why is there a warning about "f5-appsvcs package" installation
when I log in to my BIG-IP device?**

See answer to FAQ Q1.

**Q3. Why do VLANs disappear from the F5 ACI ServiceCenter application visibility
table if I destroy and re-create the service graph template of my
VIRTUAL Logical Device on Cisco APIC?**

For virtual ADC logical devices, if you:
1. Take a snapshot.
2. Delete the service graph template.
3. Revert to snapshot config.

The VLAN encap values associated with logical interfaces of the LDEV change and do not remain the same.

The application will detect this change and show a warning on the L2-L3
stitching LDEV info page that displays VLANs. You can click the warning to update the VLAN tag. This leads to deletion
and re-creation of VLAN and associated self IPs, and there will be traffic loss.

After the VLAN tag is updated on BIG-IP, the visibility VLAN table will start showing the VLANs again.

**Q4. Why don’t I see the pre-existing VLANs and self IPs from BIG-IP; the ones that have a different naming convention than the application?**

The application does not support pre-existing VLAN network
configuration (L2-L3 configuration), which has a different naming
convention than ones created through the App. Hence, it will only be able to detect those VLANs
that were created and managed from the application. 

After uninstalling and reinstalling an application, if the app database
is lost, the application can detect the previously created
VLANs by reading BIG-IP information and will show them as Out-of-sync VLANs.
You will be able to sync it to the application to rebuild the App
database. See Release Note 1 for more details.

The application displays APIC VLAN tags for a particular Logical Device
Cluster on the L2-L3 stitching page. If there is an out-of-band VLAN
with different naming convention but same VLAN tag, on the BIG-IP
device, the application will detect it and show it in the Out-of-sync
information too. But the only action available for such a VLAN or Self
IP will be deletion of that object from BIG-IP. It will not be allowed
to sync to application, since it has a different naming convention.
Also, the application will not detect such out-of-band information for
any of the other VLAN tags which are not a part of APIC VLAN list.

**Q5. For L4-L7 App Service tab, why does the partition get deleted
when I delete the last application belonging to that partition?**

If there is a single application in a particular partition, and
if that application is deleted through the application. The
corresponding partition which has no other applications under it, will
also get deleted from the BIG-IP device. This is the standard F5 BIG-IP
behavior. The user will be warned about this in the delete confirmation
prompt with an info alert.

**Q6. What is the best way to delete LDEV from APIC ?**

Please don’t delete self IPs, VLANs and devices from the APIC
directly. Instead, as a first step, delete SelfIPs, VLANs and routes
from the BIG-IP device using the application. Once done, you can delete
the Logical Device from APIC. This will ensure that there are no stale
SelfIP, VLAN and route entries on BIG-IP.

**Q7. Why did I see the following error on app “BIG-IP session timed
out? Please login again.”?**

Every BIG-IP session on the app has an operation-idle time out
of 10 minutes. Hence, if the user does not carry out any operations on a
BIG-IP session of the application for 10 minutes, the user will see the
above error. This timeout check is triggered only on tab switch, or on
left-hand menu item click for logged in BIG-IP devices.

**Q8. If my database is corrupted, how can I recover the data?**

1. Configure a tech-support policy for the F5 ACI ServiceCenter application as explained here: :doc:`Tech Support Policies and Logs <other_workflows>`. This ensures that the application database is backed up periodically.  
2. Disable the application from APIC UI.
3. Replace the application db file located at /data2/gluster/gv0/F5Networks_F5ACIServiceCenter/f5.db with the correct f5.db backup file from tech-support.
4. Enable the application from APIC UI.
5. Check that the application is brought up correctly and there are no database related SQLite Errors.

.. note::
   APIC root credentials are required for replacing the f5.db file.
