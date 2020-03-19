Dynamic Endpoint Attach Detach
==============================

This feature is supported in F5 ACI ServiceCenter version 2.3 onwards. The recommended AS3 plugin version is 3.16 or higher which is available for download at https://github.com/F5Networks/f5-appsvcs-extension/releases

This feature adds support to dynamically update endpoints on BIG-IP pools whenever endpoints get attached or detached from APIC EPGs (Endpoint Groups). The F5 ACI ServiceCenter application provides a way to create a mapping between the APIC EPG and BIG-IP AS3 Application.


Dynamic Endpoint Attach Detach Configuration Tasks
--------------------------------------------------


Adding OR Updating a mapping between APIC Endpoint Group and BIG-IP pool
````````````````````````````````````````````````````````````````````````
1. Go to L4-L7 App Services → Application → Basic/Advanced tab

2. Follow the workflows for creating/updating application

3. Click on :guilabel:`Manage Endpoint Mappings`. This will open a dialog box and a card per pool of the application. Select the Tenant|Application Profile|Endpoint Group from the given drop-downs corresponding to the APIC EPG you want to associate with this application pool. 

4. Click on the :guilabel:`Save` button. This will record the response in UI.

5. Click on :guilabel:`Submit` to actually create the application and also the dynamic endpoint mapping to the BIG-IP.

Henceforth whenever a new endpoint gets attached or detached from the selected APIC Endpoint Group, the update should get reflected on the Application’s pool members on BIG-IP, and the pool should have the same list of endpoints as the EPG.  


Deleting a mapping between APIC Endpoint Group and BIG-IP pool
``````````````````````````````````````````````````````````````

1. Go to L4-L7 App Services → Application → Basic/Advanced tab

2. Click on :guilabel:`Manage Endpoint Mappings`. This will open a dialog box and a card per pool of the application. 

3. Click on :guilabel:`RESET` button to reset the mapping. 

4. Click on the :guilabel:`Save` button. This will record the response in UI.

5. Click on :guilabel:`Submit` to actually delete the dynamic endpoint mapping from BIG-IP.

This will delete the existing dynamic pool members from BIG-IP which were added due to this mapping.


Manual sync of endpoints from APIC Endpoint Group to BIG-IP pool
``````````````````````````````````````````````````````````````

1. Follow the steps to Add dynamic endpoint mapping mentioned previously.

2. Go to L4-L7 App Services → Application Inventory → Action column and click on the Sync icon of the desired AS3 application.

3. All the operational endpoints from the mapped Tenant|App|EPG will be synced to the BIG-IP pool of the AS3 application.
