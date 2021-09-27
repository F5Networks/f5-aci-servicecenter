Release Notes (Version 2.9)
===========================

General
-------

**File system convergence**

APIC Filesystem Glusterfs takes 15 to 20 minutes to recover when the APIC cluster goes unhealthy.

During APIC operations like APIC reboot, upgrade, or decommission/recommission, the APIC filesystem needs some time to recover and resume.

Symptoms users may see:
1. Application operations throw a (sqlite3.OperationalError) disk I/O error
2. Users may not find previously added BIG-IP entries in the application
3. New Application installation may fail

**Workaround**: Wait for 20 minutes and try to access the application again. The Glusterfs should recover automatically and the application should be accessible again.

------

**Export db does not work on APIC version 5.0.1**

The User menu on the top-right corner of the F5 ACI ServiceCenter has an option for exporting the F5 ACI ServiceCenter database (**Export/Import DB > Export DB**). This option does not work on APIC versions 5.0.1. This is working as expected on prior versions of the APIC and also on versions 5.0(2e) and higher. 

**Workaround:** Backup the F5 ACI ServiceCenter database using the following steps:
1. Login to the APIC server via SSH.

2. Change directories to F5Networks_F5ACIServiceCenter: **cd /data2/gluster/gv0/F5Networks_F5ACIServiceCenter**.

3. Use scp, winscp or any other preferred tool to copy the f5.db file from this location. 

------

**Non-default docker0 configuration on APIC may affect the connection to the management IP of Virtual BIG-IP**

The default docker0 bridge IP has the address **172.17.0.1**. If the docker0 bridge IP is updated to a non-default IP followed by APIC cluster reboot, the Virtual BIG-IP login (connection to management IP) will fail from the F5 ACI ServiceCenter.

**Workaround:** After APIC reboots, once again change the docker0 bridge IP to a new value.

------

**Zoom In/Out for Device Discovery Topology diagrams may get stuck on Internet Explorer**

When you click the Topology icon in any one of the tabs (Visibility, Network Management, and L4-L7 App Services), the Topology diagrams may get stuck when zooming in and out. The position of the topology diagram can also not be changed once this issue is observed. 

**Workaround:** Use a different browser than IE.

------

**BIG-IP version may not be displayed correctly in FASC when the BIG-IP version is upgraded or downgraded**

The BIG-IP version when hovering over the BIG-IP IP address may not be displayed correctly when BIG-IP is upgraded or downgraded.

**Workaround:** Log-out and re-login to the BIG-IP device in the FASC application.

------

**For non-admin BIG-IP users, Default Gateway CRUD operations show success even though the corresponding operation on the BIG-IP is not permitted and failed**

Non-admin BIG-IP users have restricted access to F5 ACI ServiceCenter, however due to an Ansible defect, users might see success messages for Default Gateway operations despite those operations failing on the BIG-IP. 

**Ansible Defect:** https://github.com/F5Networks/f5-ansible/issues/2088

**Workaround:** Use the BIG-IP admin account for F5 ACI ServiceCenter Default Gateway operations.

------

**BIG-IP LDAP User with role "No-Access" can login to F5 ACI ServiceCenter with limited access**

Access to the F5 ACI ServiceCenter operations for LDAP users depends upon whether the user is admin or non-admin. F5 ACI ServiceCenter is not able to distinguish between non-admin access roles such as operator, guest, no access and so on, hence users with role **No-Access** might be able to login to F5 ACI ServiceCenter with limited access.

**Workaround:** Use the BIG-IP admin account for F5 ACI ServiceCenter operations. 

------


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

1. Switch tabs from the Visibility tab to one of the other tabs and then switch back. 

2. Select a different entry from the Visibility table drop-downs (either Partition or Table) and switch back to the intended combination.

3. Close and re-open the FASC app UI.

------

**Visibility table status icons render few seconds after data for scale configs**

**Workaround:** None

------

**BIG-IP v12 displays BIG-IP logs in local timezone**

**Visibility Dashboard → View Logs** (for both VIP and Node) will display logs in UTC. But for BIG-IP v12, the logs are displayed in local timezone (timezone of the BIG-IP).

**Workaround:** Upgrade BIG-IP to v13 or higher.

------

**Visibility Dashboard filter may display additional logs with interface filter**

**Visibility Dashboard → BIG-IP Endpoint Details → Interface → View Logs** (for BIG-IP interfaces) displays interface logs. By default it applies the filter of interface name (for example: 1.1 or 1.2); and hence only the logs with interface name in them are displayed. This filtering logic may not work as expected and display additional logs which have interface names as a substring (For example: **1.2** is a substring in the log "Pool /Partition/Application/web_pool member **/Partition/12.14.1.2:8080** monitor status down").

**Workaround:** None.

------

L4-L7 App Services
------------------

**Application services declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the Application Services configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration is removed from the BIG-IP device.

**Workaround**: Upload an AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

-------

**Once all Pool Member cards are removed from the template form, adding a new pool member card fails on FASC FAST templates UI**

If a user clicks the "-" sign in front of the pool members card and tries to add pool member card again by clicking the "+" icon, then the pool member card is not populated in template form.

**Workaround:** Refresh the basic subtab on the L4-L7 tab

------

**Dynamic hide/show of sub-forms is not supported for FAST templates**

Functionality releated to displaying a sub-form based on some checkbox selection is not supported by FAST forms on F5 ACI ServiceCenter. Currently all the templates are displayed in a completely expanded layout.

**Workaround:** User already has the completely expanded form available on FASC’s FAST UI.

------

**A Text input field is wrongly displayed for 'Notice: Beta Test' in 'bigip-fast-templates/microsoft adfs' and 'bigip-fast-templates/microsoft exchange' FAST templates**

'bigip-fast-templates/microsoft adfs' and 'bigip-fast-templates/microsoft exchange' FAST templates display a text input against the 'Notice: Beta Test' field. An error will be seen if this entry is filled during the form submission.

**Workaround:** Leave the 'Notice: Beta Test' field blank during form submission.

------

**'bigip-fast-templates/microsoft_exchange' template is not supported in F5 ACI ServiceCenter**

If **bigip-fast-templates/microsoft_exchange** template is used from the Basic sub-tab of **L4-L7 App Services --> Application**, you may receive a 'Null exception' from BIG-IP.

**Workaround:** Create the Microsoft Exchange FAST application from BIG-IP's FAST UI.

------

Dynamic Endpoint Attach Detach
------------------------------


**Error on EPG mapping delete operation**

When a dynamic endpoint mapping is added to an application using **Manage Endpoint Mappings**, the application is created on the BIG-IP. If this mapping is deleted using the **RESET** button on **Manage Endpoint Mappings** form, users may encounter an error "The requested Pool Member (/Partition/App/Pool /NodePartition/NodeIP) was not found."

**Workaround:** Click the **Submit** button again, and the mapping will be reset properly without any errors. 

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/185
 
------

**AS3 applications can either have static nodes or dynamic nodes but not both**

AS3 applications will support either static nodes or dynamic nodes (using the **Manage Endpoint Mappings** button) but not both.

**Workaround:** None


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

**Nodes are not removed from the BIG-IP pool when the node IP is a substring of some other node's IP**

If a node (for example a node with IP 1.2.3.4) is deleted from APIC, and there is also another node 1.2.3.40 of which the original IP is a substring, it may be possible that the dynamic end point attach detach feature is not able to delete 1.2.3.4 from BIG-IP. Note: The pool members will get deleted as expected. 

**Workaround:** Login to the BIG-IP UI and delete the problematic node.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/244

------

**Dynamic EP discovery does not work if a duplicate IP already exists on a different partition**

If an APIC Tenant|App|EPG mapped to a BIG-IP pool has an endpoint with an IP address which already exists on the BIG-IP but in a different partition, then the APIC endpoint will not get added to BIG-IP pool. Also any successive configurations and endpoints also will not be discovered/deleted from this BIG-IP pool. 

Workaround: Remove the duplicate IPs from the endpoint list on APIC and retry a manual sync of Endpoints from L4-L7 App Services --> Application Inventory --> Sync EPs icon. 

Note: Similar issues might be seen with other erroneous configurations such as unsupported IPv4 formats like 1.2.3.4/24 instead of 1.2.3.4

AS3 Defect: https://github.com/F5Networks/f5-appsvcs-extension/issues/287

------

**Pool members deleted or added directly to BIG-IP don't get updated automatically after clicking "Sync EPs"**

1. If BIG-IP pool members are automatically added by the **Dynamic endpoint discovery** feature, but then a few endpoints are deleted directly from the BIG-IP (i.e. out of band); these endpoints do not get created again when clicking **L4-L7 App Services --> Application Inventory --> Sync EPs** for that application. 

2. Similarly, when a few pool members are added directly to the BIG-IP (i.e. out of band), these extra members are not deleted after clicking **L4-L7 App Services --> Application Inventory --> Sync EPs**

**Workaround:** Manually add/delete the pool members from BIG-IP. 

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/293

------

**Pool members are not synced on AS3 service discovery REST API endpoint for HA devices**

AS3 Service Discovery REST API endpoint on both HA devices should display the same pool member list for the specified pool path (For. ex. https://BIG-IP/mgmt/shared/service-discovery/task/~Partition~Application~Pool). But AS3 service discovery fails to perform this sync between the HA devices.

**Workaround:** None.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/385

------


Release Notes (Version 2.8)
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

**Export db does not work on APIC version 5.0.1**

The user menu on the top-right corner of the F5 ACI ServiceCenter has an option for exporting F5 ACI ServiceCenter database (**Export/Import DB > Export DB**). This option does not work on APIC versions 5.0.1. This is working as expected on prior versions of the APIC and also on versions 5.0(2e) and higher. 

**Workaround:** Backup the F5 ACI ServiceCenter database using the following steps:
1. Login to the APIC server via SSH.

2. Change directories to F5Networks_F5ACIServiceCenter: **cd /data2/gluster/gv0/F5Networks_F5ACIServiceCenter**.

3. Use scp, winscp or any other preferred tool to copy out the f5.db file from this location. 

------

**Non-default docker0 configuration on APIC may affect the connection to the management IP of Virtual BIG-IP**

The default docker0 bridge IP has the address **172.17.0.1**. If the docker0 bridge IP is updated to a non-default IP followed by APIC cluster reboot, the Virtual BIG-IP login (connection to management IP) will fail from the F5 ACI ServiceCenter.

**Workaround:** After APIC reboots, once again change the docker0 bridge IP to a new value.

------

**Zoom In/Out for Device Discovery Topology diagrams may get stuck on Internet Explorer**

When you click the Topology icon in any one of the tabs (Visibility, Network Management, and L4-L7 App Services), the Topology diagrams may get stuck when zooming in and out. The position of the topology diagram can also not be changed once this issue is observed. 

**Workaround:** Use a different browser than IE.

------

**BIG-IP version may not be displayed correctly in FASC when BIG-IP version is upgraded or downgraded.**

The BIG-IP version displayed on hover over the BIG-IP IP address may not be displayed correctly when BIG-IP is upgraded or downgraded.

**Workaround:** Log-out and re-login the BIG-IP device in the FASC application.

------

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

1. Switch tabs from the Visibility tab to one of the other tabs and then switch back. 

2. Select a different entry from the Visibility table drop-downs (either Partition or Table) and switch back to the intended combination.

3. Close and re-open the FASC app UI.

------

**Visibility table status icons render few seconds after data for scale configs.**

**Workaround:** None

------

**BIG-IP v12 displays BIG-IP logs in local timezone.**

**Visibility Dashboard → View Logs** (for both VIP and Node) will display logs in UTC. But for BIG-IP v12, the logs are displayed in local timezone (timezone of the BIG-IP).

**Workaround:** Upgrade BIG-IP to v13 or higher.

------

**Visibility Dashboard filter may display additional logs with interface filter.**

**Visibility Dashboard → BIG-IP Endpoint Details → Interface → View Logs** (for BIG-IP interfaces) displays interface logs. By default it applies the filter of interface name (for example: 1.1 or 1.2); and hence only the logs with interface name in them are displayed. This filtering logic may not work as expected and display additional logs which have interface name as a substring (For example: **1.2** is a substring in the log "Pool /Partition/Application/web_pool member **/Partition/12.14.1.2:8080** monitor status down").

**Workaround:** None.

------

L4-L7 App Services
------------------

**Application services declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the Application Services configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration is removed from the BIG-IP device.

**Workaround**: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

-------

**Once all Pool Member cards are removed from template form, adding a new pool member card fails on FASC FAST templates UI**

If user clicks on "-" sign in front on pool members card and tries to add pool member card again by clicking on "+" icon then then pool member card is not populated in template form.

**Workaround:** Refresh the basic subtab on L4-L7 tab

------

**Dynamic hide/show of sub-forms is not supported for FAST templates**

Functionality releated to displaying a sub-form based on some checkbox selection is not supported by FAST forms on F5 ACI ServiceCenter. Currently all the templates are displayed in a completely expanded layout.

**Workaround:** User already has the completely expanded form available on FASC’s FAST UI.

------

**TextBox field displayed for 'Notice: Beta Test' field in 'bigip-fast-templates/microsoft adfs' and 'bigip-fast-templates/microsoft exchange' FAST templates.**

'bigip-fast-templates/microsoft adfs' and 'bigip-fast-templates/microsoft exchange' FAST templates display a text against the 'Notice: Beta Test' field. An error will be seen if this entry is filled in the form submission.

**Workaround:** Leave the 'Notice: Beta Test' field blank during form submission.

------

**‘Create new partition’ workflow does not work when users select ‘Upload new template set’ without actually uploading the new template set**

**Create new partition** workflow does not work with the following steps:

1. Select ‘Upload new template set’ 

2. Do not actually upload a new template set.

3. Trying to click the ‘Create new partition’ option from Partition drop-down will not work.

**Workaround**: Click the **Reset** button and then select **Create new partition** selection from the **Partition** drop-down

------

**'bigip-fast-templates/microsoft_exchange' template is not supported in F5 ACI ServiceCenter**

If **bigip-fast-templates/microsoft_exchange** template is used from the Basic sub-tab of **L4-L7 App Services --> Application**, you may receive a 'Null exception' from BIG-IP.

**Workaround:** Create the Microsoft Exchange FAST application from BIG-IP's FAST UI.

------

Dynamic Endpoint Attach Detach
------------------------------


**Error on EPG mapping delete operation**

When a dynamic endpoint mapping is added to an application using **Manage Endpoint Mappings**, the application is created on the BIG-IP. If this mapping is deleted using the **RESET** button on **Manage Endpoint Mappings** form, users may encounter an error "The requested Pool Member (/Partition/App/Pool /NodePartition/NodeIP) was not found."

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

1. If BIG-IP pool members are automatically added by the **Dynamic endpoint discovery** feature, but then a few endpoints are deleted directly from the BIG-IP (i.e. out of band); these endpoints do not get created again when clicking **L4-L7 App Services --> Application Inventory --> Sync EPs** for that application. 

2. Similarly, when a few pool members are added directly to the BIG-IP (i.e. out of band), these extra members are not deleted after clicking **L4-L7 App Services --> Application Inventory --> Sync EPs**

**Workaround:** Manually add/delete the pool members from BIG-IP. 

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/293

------

**Pool members are not synced on AS3 service discovery REST API endpoint for HA devices.**

AS3 Service Discovery REST API endpoint on both HA devices should display the same pool member list for the specified pool path (For. ex. https://BIG-IP/mgmt/shared/service-discovery/task/~Partition~Application~Pool). But AS3 service discovery fails to perform this sync between the HA devices.

**Workaround:** None.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/385

------


Release Notes (Version 2.7)
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

**Export db does not work on APIC version 5.0.1**

The user menu on the top-right corner of the F5 ACI ServiceCenter has an option for exporting F5 ACI ServiceCenter database (**Export/Import DB > Export DB**). This option does not work on APIC versions 5.0.1. This is working as expected on prior versions of the APIC and also on versions 5.0(2e) and higher. 

**Workaround:** Backup the F5 ACI ServiceCenter database using the following steps:
1. Login to the APIC server via SSH.

2. Change directories to F5Networks_F5ACIServiceCenter: **cd /data2/gluster/gv0/F5Networks_F5ACIServiceCenter**.

3. Use scp, winscp or any other preferred tool to copy out the f5.db file from this location. 

------

**Non-default docker0 configuration on APIC may affect the connection to the management IP of Virtual BIG-IP**

The default docker0 bridge IP has the address **172.17.0.1**. If the docker0 bridge IP is updated to a non-default IP followed by APIC cluster reboot, the Virtual BIG-IP login (connection to management IP) will fail from the F5 ACI ServiceCenter.

**Workaround:** After APIC reboots, once again change the docker0 bridge IP to a new value.

------

**Hostname vCMP HA peer login during unassign VLANs does not update the login color to Green/Yellow in the side menu**

On a vCMP Host, if a user clicks **L2-L3 Network Management > vCMP Guest**, selects a vCMP Guest, moves a few VLANs from **Selected** menu to **Available** menu, and then clicks **Submit**, F5 ACI ServiceCenter logs into the vCMP Guest if it is not already logged in. In this case, the side menu does not show the Green/Yellow color indicator correctly. 

**Workaround:** Click the side menu **Refresh BIG-IP List** icon to update the login status of the vCMP Guest.

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

1. Switch tabs from the Visibility tab to one of the other tabs and then switch back. 

2. Select a different entry from the Visibility table drop-downs (either Partition or Table) and switch back to the intended combination.

3. Close and re-open the FASC app UI.

------

**Visibility table status icons render few seconds after data for scale configs.**

**Workaround:** None

------

**BIG-IP v12 displays BIG-IP logs in local timezone.**

**Visibility Dashboard → View Logs** (for both VIP and Node) will display logs in UTC. But for BIG-IP v12, the logs are displayed in local timezone (timezone of the BIG-IP).

**Workaround:** Upgrade BIG-IP to v13 or higher.

------

**Visibility Dashboard filter may display additional logs with interface filter.**

**Visibility Dashboard → BIG-IP Endpoint Details → Interface → View Logs** (for BIG-IP interfaces) displays interface logs. By default it applies the filter of interface name (for example: 1.1 or 1.2); and hence only the logs with interface name in them are displayed. This filtering logic may not work as expected and display additional logs which have interface name as a substring (For example: **1.2** is a substring in the log "Pool /Partition/Application/web_pool member **/Partition/12.14.1.2:8080** monitor status down").

**Workaround:** None.

------

**Pool members added with the name IP%RD are displayed as IP%25RD on the pool member stats window of the Visibility Dashboard.**

**Workaround:** Use a pool member name other than IP%RD.

**Telemetry defect:** https://github.com/F5Networks/f5-telemetry-streaming/issues/108

------

L4-L7 App Services
------------------

**Application services declaration not deleted**

If your AS3 declaration contains “optimisticLockKey” mentioned explicitly, the Application Services configuration may not be deleted completely, even after multiple attempts from the application UI. However, the configuration is removed from the BIG-IP device.

**Workaround**: Upload one more AS3 sample declaration to the app and then perform a :guilabel:`Delete all` operation. (Use :guilabel:`View AS3 Declaration` and click :guilabel:`Delete`.)

-------


Dynamic Endpoint Attach Detach
------------------------------


**Error on EPG mapping delete operation**

When a dynamic endpoint mapping is added to an application using **Manage Endpoint Mappings**, the application is created on the BIG-IP. If this mapping is deleted using the **RESET** button on **Manage Endpoint Mappings** form, users may encounter an error "The requested Pool Member (/Partition/App/Pool /NodePartition/NodeIP) was not found."

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

1. If BIG-IP pool members are automatically added by the **Dynamic endpoint discovery** feature, but then a few endpoints are deleted directly from the BIG-IP (i.e. out of band); these endpoints do not get created again when clicking **L4-L7 App Services --> Application Inventory --> Sync EPs** for that application. 

2. Similarly, when a few pool members are added directly to the BIG-IP (i.e. out of band), these extra members are not deleted after clicking **L4-L7 App Services --> Application Inventory --> Sync EPs**

**Workaround:** Manually add/delete the pool members from BIG-IP. 

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/293

------

**Pool members are not synced on AS3 service discovery REST API endpoint for HA devices.**

AS3 Service Discovery REST API endpoint on both HA devices should display the same pool member list for the specified pool path (For. ex. https://BIG-IP/mgmt/shared/service-discovery/task/~Partition~Application~Pool). But AS3 service discovery fails to perform this sync between the HA devices.

**Workaround:** None.

**AS3 Defect:** https://github.com/F5Networks/f5-appsvcs-extension/issues/385

------

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

On a vCMP Host, if a user clicks **L2-L3 Network Management > vCMP Guest**, selects a vCMP Guest, moves a few VLANs from **Selected** menu to **Available** menu, and then clicks **Submit**, F5 ACI ServiceCenter logs into the vCMP Guest if it is not already logged in. In this case, the side menu does not show the Green/Yellow color indicator correctly. 

**Workaround:** Click the side menu **Refresh BIG-IP List** icon to update the login status of the vCMP Guest.

------

**If a vCMP Guest has been logged in using a hostname, vCMP Guest auto-login during VLAN unassignment may result in an error**

The error message observed is: "<IP_Address> is already added as <Hostname>. To add <IP_Address>, delete BIG-IP device <Hostname> and retry."

The steps that may lead to this error are:

- Login to a vCMP Guest using a hostname.

- Login to the corresponding vCMP Host and click **L2-L3 Network Management > vCMP Guest** tab. 

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

**Application services declaration delete of scaled config may result in an error stating the 'HTTPError' object has no attribute 'message'**

If an AS3 declaration with scale config is deleted using the **L4-L7 App Services > View AS3 Declaration > Delete** button, the F5 ACI ServiceCenter may display an error  stating the 'HTTPError' object has no attribute 'message' instead of the actual error that BIG-IP responds with, which is '503 Server Error'. 

**Workaround**: This 503 error occurs when BIG-IP is in error state or is already in the process of configuring a previous AS3 declaration. Once BIG-IP is in steady state and UI is accessible, the delete operation can be retried to get a successful response for deleting the declaration.

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
