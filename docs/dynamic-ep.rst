Dynamic Endpoint Attach Detach
==============================

This feature is supported in F5 ACI ServiceCenter version 2.3 and above. The minimum AS3 plugin version required is 3.19.1. The AS3 plugin is available for download at https://github.com/F5Networks/f5-appsvcs-extension/releases

This feature adds support to dynamically update endpoints on BIG-IP pools whenever endpoints get attached or detached from APIC EPGs (Endpoint Groups). The F5 ACI ServiceCenter application provides a way to create a mapping between the APIC EPG and BIG-IP AS3 Application.


Dynamic Endpoint Attach Detach Configuration Tasks
--------------------------------------------------


Adding OR Updating a mapping between APIC Endpoint Group and BIG-IP pool
````````````````````````````````````````````````````````````````````````
1. Go to L4-L7 App Services → Application → Basic/Advanced tab

2. Follow the workflows for creating/updating application

3. Click :guilabel:`Manage Endpoint Mappings`. This will open a dialog box and a card per pool of the application. Select the Tenant|Application Profile|Endpoint Group from the given drop-downs corresponding to the APIC EPG you want to associate with this application pool. 

4. Click :guilabel:`Save`. This will record the response in UI.

5. Click :guilabel:`Submit` to create the application and the dynamic endpoint mapping on the BIG-IP.

Henceforth, whenever a new endpoint gets attached or detached from the selected APIC Endpoint Group, the update should get reflected in the Application’s pool members on BIG-IP, and the pool should have the same list of endpoints as the EPG.  

**Note**

If using Basic tab, the **server_port** template field will have to be entered but it will not take effect during dynamic endpoint creation. The **port** field from the :guilabel:`Manage Endpoint Mappings` form will be used for creation of dynamic endpoint creation on BIG-IP.


Deleting a mapping between APIC Endpoint Group and BIG-IP pool
``````````````````````````````````````````````````````````````

1. Go to L4-L7 App Services → Application → Basic/Advanced tab

2. Click :guilabel:`Manage Endpoint Mappings`. This will open a dialog box and a card per pool of the application. 

3. Click :guilabel:`RESET` to reset the mapping. 

4. Click :guilabel:`Save`. This will record the response in UI.

5. Click :guilabel:`Submit` to delete the dynamic endpoint mapping from BIG-IP.

This will delete the existing dynamic pool members from BIG-IP which got added due to this endpoint mapping.


Manual sync of endpoints from APIC Endpoint Group to BIG-IP pool
````````````````````````````````````````````````````````````````

1. Follow the steps to Add dynamic endpoint mapping mentioned previously.

2. Go to L4-L7 App Services → Application Inventory → Action column and click the **Sync** icon of the desired AS3 application.

3. All the operational endpoints from the mapped Tenant|App|EPG will be synced to the BIG-IP pool of the AS3 application.

------

Frequently Asked Questions (FAQ)
--------------------------------

**Q. When new dynamic endpoints get added on APIC, why aren’t  the nodes getting updated on BIG-IP devices?**

There is a websocket connection between the F5 ACI ServiceCenter and APIC to listen to new endpoint creation/deletion. If there is an issue with the websocket or the endpoint notification subscriptions, those errors are logged in the log files on APIC. Check the files for more details about end point attach detach.

You may observe the error "Unrecoverable error occurred while creating APIC websocket…." on the UI or in the websocket error log file: /data2/logs/F5Networks_F5ACIServiceCenter/f5_apic_websocket.log 

OR

You may observe the error: "Failed to get a new subscription. Subscription Refresh Thread stopped for APIC for…" on the UI or in the subscription errors log file: data2/logs/F5Networks_F5ACIServiceCenter/f5_apic_subscription.log

**Workaround:** For any of these errors in log files, disable and re-enable the F5 ACI ServiceCenter application to fix the dynamic endpoint attach detach functionality. This will not affect the state of the F5 ACI ServiceCenter and all the data and configuration will still be intact after the disable and re-enable steps.

------
