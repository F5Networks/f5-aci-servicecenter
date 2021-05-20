Endpoint Search by IP
======================

F5 ACI Service Center supports searching endpoint IPs. Users can search endpoints on the BIG-IP using the following useful tools:

1. Local Endpoint Search: Present on a single BIG-IP

2. Global Endpoint Search: Across BIG-IPs which have been added to the FASC application. 

.. note:: 
  - The endpoint IP being searched should be present on both BIG-IP and APIC. If the endpoint is present on the BIG-IP and not present on the APIC, the search utility will not display that IP. If the endpoint is present on APIC but not present on any of the BIG-IPs, the search utility will not display that IP.
  - For Global Endpoint Search, the utility will search the endpoint IP only across the already logged in BIG-IPs. If any of the BIG-IPs are not logged-in, the search will not be done on those BIG-IP devices.

Local Endpoint Search (Search on a single BIG-IP)
--------------------------------------------------
F5 ACI serviceCenter provides a tool for searching endpoint on a single BIG-IP device.

1. Login to a BIG-IP device.

2. Navigate to the Visibility tab

3. Click the Search Icon on the top right icons bar of the Visibility tab. It will display a search box.

4. Enter the Endpoint IP to be searched.

5. Click the **Search** button.

6. All the VIPs and Nodes with the specified IP are displayed in the search results

7. Click any of the entries to view more details about the VIP or Node. Clicking the entry will redirect the user to the Visibility Dashboard.

.. note::
  - Users need to provide the exact endpoint IP in the search box to view information related to the endpoint. 
  - The endpoint IP being searched should be present on both the BIG-IP and APIC. If the endpoint is present on the BIG-IP and not present on APIC, the search utility will not display that IP. If the endpoint is present on APIC but not present on any of the BIG-IPs, the search utility will not display that IP.

Global Endpoint Search (Across all BIG-IPs)
-------------------------------------------
F5 ACI ServiceCenter provides a tool for searching endpoint across all logged in BIG-IP devices.

1. Click the Search icon on the sidebar of the FASC application.

2. Enter the Endpoint IP to be searched.

3. Click the **Search** button.

4. All the VIPs and Nodes with specified IP are displayed in the search results.

5. Click any of the entries to view more details about the VIP or Node. Clicking the entry will redirect the user to the Visibility Dashboard.

.. note::
  - Users need to provide the exact endpoint IP in the search box to view information related to the endpoint.
  - The endpoint IP being searched should be present on both the BIG-IP and APIC. If the endpoint is present on the BIG-IP and not present on APIC, the search utility will not display that IP. If the endpoint is present on APIC but not present on any of the BIG-IPs, the search utility will not display that IP.
