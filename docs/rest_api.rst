REST API
========

This section contains the specifics of the REST APIs supported by F5 ACI ServiceCenter application.

The REST calls can be made to the following APIC endpoint

.. code-block:: json

   https://<APIC-URL>/appcenter/F5Networks/F5ACIServiceCenter/<REST-API>

   Example:

   https://10.107.0.24/appcenter/F5Networks/F5ACIServiceCenter/getbigiplist.json

`Download the API POSTMAN collection <https://github.com/F5Networks/f5-aci-servicecenter/tree/master/api_collection>`_.

Request Headers
---------------

For all the F5 ACI ServiceCenter API calls, the following request header parameters are required:


Header: DevCookie
`````````````````
Can be retrieved as follows:

1. POST a request to the following API endpoint

.. code-block:: json 

   https://<APIC-URL>/api/aaaLogin.xml

2. Body for the POST request

.. code-block:: json

   <aaaUser name="apic-username" pwd="apic-password"/>

3. From the result of the POST, save the token returned

4. In the **Headers** section of any further REST API requests, add a key-value pair. Key name is **DevCookie**, and its value should be the token obtained in the previous step

.. code-block:: json
   
   Key         Value        
   DevCookie : < token value > 
   

Header: Content-Type
````````````````````
.. code-block:: json
   
   Key           Value           
   Content-Type: application/json
   
Input Parameters
----------------

There are multiple F5 ACI ServiceCenter APIs which require input parameters to be retrieved for the APIC Logical Device. These input parameters can be retrieved from the APIC object browser known as visore.html

APIC managed objects can be accessed at https://<APIC_IP>/visore.html.

Below is a table of such parameters and steps on how to retrieve them.
These parameters will be required for the L2-L3 Stitching tab.

+-------------+--------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Input Key   | Input Value                                                                                                                    | Input Value Example                                                                                                                                     |
+=============+================================================================================================================================+=========================================================================================================================================================+
| ldev        | 1. Go to APIC GUI → Tenant→ Services→ L4-L7→ Devices→ <Your L4-L7 Device>                                                      |     uni/tn-Sample\_2/lDevVip-f5-gs                                                                                                                      |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 2. Right click the <Your L4-L7 Device> and click **Open in Object Store Browser**                                              |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 3. Use the dn property from the object browser for the input parameter **ldev**.                                               |                                                                                                                                                         |
+-------------+--------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| lif         | 1. Go to APIC GUI → Tenant→ Services→ L4-L7→ Devices→ <Your L4-L7 Device> → Cluster Interfaces→ <Your Interface of Interest>   |     uni/tn-Sample\_2/lDevVip-f5-gs/lIf-external                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 2. Right click the logical interface and click **Open in Object Store Browser**                                                |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 3. Use the dn property from the object browser for input parameter “lif”                                                       |                                                                                                                                                         |
+-------------+--------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| lIfCtxDn    | - This value is null for PHYSICAL type of ADC devices                                                                          | uni/tn-Demo/GraphInst\_C-[uni/tn-Demo/brc-2ARMVE-34-35]-G-[uni/tn-Demo/AbsGraph-2ARMVE-34\_35]-S-[uni/tn-Demo]/NodeInst-N1/LegVNode-0/EPgDef-consumer   |
|             |                                                                                                                                |                                                                                                                                                         |
|             | - This value can be retrieved from visore for VIRTUAL ADC Devices:                                                             |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 1. Go to APIC GUI → Tenant→ Services→ L4-L7→ Devices→ <Your L4-L7 Device> → Cluster Interfaces→ <Your Interface of Interest>   |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 2. Right click the logical interface and click **Open in Object Store Browser**                                                |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 3. Click the > arrow of the dn property to see its children                                                                    |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 4. Search for vnsRtEPgDefToLIf, and use the tDn property of that entry for lIfCtxDn                                            |                                                                                                                                                         |
+-------------+--------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+

The other way to retrieve the values is to call the getldevinfo.json API and
use the returned values for lif, lIfCtxDn, ldev and use them as input
parameters in the L2-L3 Stitching APIs. 

Login, Status and Miscellaneous APIs
------------------------------------

loginbigip.json
```````````````

+--------------------+------------------------------------------------------------------------+
| Title              | Adds a BIG-IP device on F5 ACI ServiceCenter application               |
+====================+========================================================================+
| URL                | /loginbigip.json                                                       |
+--------------------+------------------------------------------------------------------------+
| Method             | POST                                                                   |
+--------------------+------------------------------------------------------------------------+
| Request Body       | {                                                                      |
|                    |                                                                        |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",   |
|                    |                                                                        |
|                    | "user": "<Username>",                                                  |
|                    |                                                                        |
|                    | "password": "<Password>"                                               |
|                    |                                                                        |
|                    | }                                                                      |
+--------------------+------------------------------------------------------------------------+
| Example Request    | {                                                                      |
|                    |                                                                        |
|                    | "url": "10.107.0.22:443",                                              |
|                    |                                                                        |
|                    | "user": "admin",                                                       |
|                    |                                                                        |
|                    | "password": "admin"                                                    |
|                    |                                                                        |
|                    | }                                                                      |
+--------------------+------------------------------------------------------------------------+
| Success Response   | Code: 200                                                              |
+--------------------+------------------------------------------------------------------------+
| Example Response   | {                                                                      |
|                    |                                                                        |
|                    | "code": 200,                                                           |
|                    |                                                                        |
|                    | "message": {                                                           |
|                    |                                                                        |
|                    | "clustername": "none",                                                 |
|                    |                                                                        |
|                    | "packageVersionJson": {                                                |
|                    |                                                                        |
|                    | "installRequired": false,                                              |
|                    |                                                                        |
|                    | "message": "Current version of f5-appscvs package is 3.7.0",           |
|                    |                                                                        |
|                    | "role": "admin"                                                        |
|                    |                                                                        |
|                    | },                                                                     |
|                    |                                                                        |
|                    | "urls": [                                                              |
|                    |                                                                        |
|                    | "10.107.0.22:443"                                                      |
|                    |                                                                        |
|                    | ]                                                                      |
|                    |                                                                        |
|                    | }                                                                      |
|                    |                                                                        |
|                    | }                                                                      |
+--------------------+------------------------------------------------------------------------+
| Error Response     | Code: 400                                                              |
|                    |                                                                        |
|                    | Content: {error: Bad request}                                          |
+--------------------+------------------------------------------------------------------------+
| Notes              |                                                                        |
+--------------------+------------------------------------------------------------------------+

logoutbigip.json
````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Logs out from a BIG-IP device                                         |
+====================+=======================================================================+
| URL                | /logoutbigip.json                                                     |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.22:443"                                              |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | Content: Logged out successfully from <BIG-IP URL>                    |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | {                                                                     |
|                    |                                                                       |
|                    | "code": 200,                                                          |
|                    |                                                                       |
|                    | "message": "Logged out successfully from 10.107.0.22:443"             |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

deletebigip.json
````````````````

+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title             | Deletes a BIG-IP device from the F5 ACI ServiceCenter Application (Note: The device is soft deleted, and once added back to the app, all the data for it is restored)   |
+===================+=========================================================================================================================================================================+
| URL               | /deletebigip.json                                                                                                                                                       |
+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method            | POST                                                                                                                                                                    |
+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body      | {                                                                                                                                                                       |
|                   |                                                                                                                                                                         |
|                   | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"                                                                                                     |
|                   |                                                                                                                                                                         |
|                   | }                                                                                                                                                                       |
+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request   | {                                                                                                                                                                       |
|                   |                                                                                                                                                                         |
|                   | "url": "10.107.0.22:443"                                                                                                                                                |
|                   |                                                                                                                                                                         |
|                   | }                                                                                                                                                                       |
+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Response          | {                                                                                                                                                                       |
|                   |                                                                                                                                                                         |
|                   | "code": 200,                                                                                                                                                            |
|                   |                                                                                                                                                                         |
|                   | "message": "Deleted BIG-IP 10.107.0.22:443 successfully"                                                                                                                |
|                   |                                                                                                                                                                         |
|                   | }                                                                                                                                                                       |
+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response    | Code: 400                                                                                                                                                               |
|                   |                                                                                                                                                                         |
|                   | Content: {error: Bad request}                                                                                                                                           |
+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes             |                                                                                                                                                                         |
+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

setclustername.json
```````````````````

+--------------------+--------------------------------------------------------------------+
| Title              | Sets cluster name for a high availability pair of BIG-IP devices   |
+====================+====================================================================+
| URL                | /setclustername.json                                               |
+--------------------+--------------------------------------------------------------------+
| Method             | POST                                                               |
+--------------------+--------------------------------------------------------------------+
| Example Request    | {                                                                  |
|                    |                                                                    |
|                    | "clustername": "cluster20\_21",                                    |
|                    |                                                                    |
|                    | "urls": [                                                          |
|                    |                                                                    |
|                    | "10.107.0.20:443",                                                 |
|                    |                                                                    |
|                    | "10.107.0.21"                                                      |
|                    |                                                                    |
|                    | ],                                                                 |
|                    |                                                                    |
|                    | "peerhostname": "bigip21",                                         |
|                    |                                                                    |
|                    | "peerusername": "admin",                                           |
|                    |                                                                    |
|                    | "peerpassword": "admin"                                            |
|                    |                                                                    |
|                    | }                                                                  |
+--------------------+--------------------------------------------------------------------+
| Success Response   | Code: 200                                                          |
+--------------------+--------------------------------------------------------------------+
| Example Response   | null                                                               |
+--------------------+--------------------------------------------------------------------+
| Error Response     | Code: 400                                                          |
|                    |                                                                    |
|                    | Content: {error: Bad request}                                      |
+--------------------+--------------------------------------------------------------------+
| Notes              | peerhostname, peerusername and peerpassword request parameters     |
|                    | are required only for hostname HA clusters.                        |
+--------------------+--------------------------------------------------------------------+

getbigiplist.json
`````````````````

+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets list of BIG-IP devices which are added to the F5 ACI ServiceCenter. Also returns user and login status for each BIG-IP.   |
+====================+================================================================================================================================+
| URL                | /getbigiplist.json                                                                                                             |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Method             | GET                                                                                                                            |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                      |
|                    |                                                                                                                                |
|                    | Content:                                                                                                                       |
|                    |                                                                                                                                |
|                    | [                                                                                                                              |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "clustername": "<cluster\_name>",                                                                                              |
|                    |                                                                                                                                |
|                    | "urls": [                                                                                                                      |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                           |
|                    |                                                                                                                                |
|                    | "login": "<boolean\_value>",                                                                                                   |
|                    |                                                                                                                                |
|                    | "user": "<string>"                                                                                                             |
|                    |                                                                                                                                |
|                    | },                                                                                                                             |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                           |
|                    |                                                                                                                                |
|                    | "login": "<boolean\_value>",                                                                                                   |
|                    |                                                                                                                                |
|                    | "user": "<string>"                                                                                                             |
|                    |                                                                                                                                |
|                    | }                                                                                                                              |
|                    |                                                                                                                                |
|                    | ]                                                                                                                              |
|                    |                                                                                                                                |
|                    | }                                                                                                                              |
|                    |                                                                                                                                |
|                    | ]                                                                                                                              |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Example Response   | [                                                                                                                              |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "clustername": "none",                                                                                                         |
|                    |                                                                                                                                |
|                    | "urls": [                                                                                                                      |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "url": "10.107.0.22:443",                                                                                                      |
|                    |                                                                                                                                |
|                    | "login": true,                                                                                                                 |
|                    |                                                                                                                                |
|                    | "user": "admin"                                                                                                                |
|                    |                                                                                                                                |
|                    | },                                                                                                                             |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "url": "10.107.0.151:443",                                                                                                     |
|                    |                                                                                                                                |
|                    | "login": true,                                                                                                                 |
|                    |                                                                                                                                |
|                    | "user": "admin"                                                                                                                |
|                    |                                                                                                                                |
|                    | }                                                                                                                              |
|                    |                                                                                                                                |
|                    | ]                                                                                                                              |
|                    |                                                                                                                                |
|                    | },                                                                                                                             |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "clustername": "cluster20\_21",                                                                                                |
|                    |                                                                                                                                |
|                    | "urls": [                                                                                                                      |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "url": "10.107.0.20:443",                                                                                                      |
|                    |                                                                                                                                |
|                    | "login": false,                                                                                                                |
|                    |                                                                                                                                |
|                    | "user": null                                                                                                                   |
|                    |                                                                                                                                |
|                    | },                                                                                                                             |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "url": "10.107.0.21",                                                                                                          |
|                    |                                                                                                                                |
|                    | "login": false,                                                                                                                |
|                    |                                                                                                                                |
|                    | "user": null                                                                                                                   |
|                    |                                                                                                                                |
|                    | }                                                                                                                              |
|                    |                                                                                                                                |
|                    | ]                                                                                                                              |
|                    |                                                                                                                                |
|                    | }                                                                                                                              |
|                    |                                                                                                                                |
|                    | ]                                                                                                                              |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                                      |
|                    |                                                                                                                                |
|                    | Content: {error: Bad request}                                                                                                  |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Notes              |                                                                                                                                |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+

getlldpneighbors.json
`````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Discover F5 BIG-IP devices attached to the ACI Fabric                 |
+====================+=======================================================================+
| URL                | /getlldpneighbors.json                                                |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or Hostname. Field is optional>",                  |
|                    |                                                                       |
|                    | "topology": true,                                                     |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.21:443",                                             |
|                    |                                                                       |
|                    | "topology": true,                                                     |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | "code": 200,                                                          |
|                    |                                                                       |
|                    | "content"                                                             |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "links": [                                                            |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "aciInfo": {"allowedVlans": "",                                       |
|                    |                                                                       |
|                    | "operMode": "trunk",                                                  |
|                    |                                                                       |
|                    | "operSpeed": "10G",                                                   |
|                    |                                                                       |
|                    | "operSt": "up",                                                       |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "aciPort": "eth1/25",                                                 |
|                    |                                                                       |
|                    | "bigipPort": "1.1",                                                   |
|                    |                                                                       |
|                    | "bigipPort": "1.1",                                                   |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ],                                                                    |
|                    |                                                                       |
|                    | "mgmtIp": "10.107.0.40",                                              |
|                    |                                                                       |
|                    | "present": true                                                       |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              | Does not discover BIG-IP VE and BIG-IP vCMP Guests                    |
+--------------------+-----------------------------------------------------------------------+


checkbigipfailoverstate.json
````````````````````````````

+--------------------+---------------------------------------------------------------------------------+
| Title              | Check whether currently logged in BIG-IP device is in active or standby mode.   |
+====================+=================================================================================+
| URL                | /checkbigipfailoverstate.json                                                   |
+--------------------+---------------------------------------------------------------------------------+
| Method             | POST                                                                            |
+--------------------+---------------------------------------------------------------------------------+
| Request Body       | {                                                                               |
|                    |                                                                                 |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"             |
|                    |                                                                                 |
|                    | }                                                                               |
+--------------------+---------------------------------------------------------------------------------+
| Example Request    | {                                                                               |
|                    |                                                                                 |
|                    | "url": "10.107.0.22:443"                                                        |
|                    |                                                                                 |
|                    | }                                                                               |
+--------------------+---------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                       |
+--------------------+---------------------------------------------------------------------------------+
| Example Response   | {                                                                               |
|                    |                                                                                 |
|                    | "code": 200,                                                                    |
|                    |                                                                                 |
|                    | "message": {                                                                    |
|                    |                                                                                 |
|                    | "color": "green",                                                               |
|                    |                                                                                 |
|                    | "status": "ACTIVE"                                                              |
|                    |                                                                                 |
|                    | }                                                                               |
|                    |                                                                                 |
|                    | }                                                                               |
+--------------------+---------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                       |
|                    |                                                                                 |
|                    | Content: {error: Bad request}                                                   |
+--------------------+---------------------------------------------------------------------------------+
| Notes              |                                                                                 |
+--------------------+---------------------------------------------------------------------------------+

checkbigipsyncstatus.json
`````````````````````````

+--------------------+----------------------------------------------------------------------------------------+
| Title              | Check current BIG-IP’s sync status (For example: Standalone, In sync, Awaiting Sync)   |
+====================+========================================================================================+
| URL                | /checkbigipsyncstatus.json                                                             |
+--------------------+----------------------------------------------------------------------------------------+
| Method             | POST                                                                                   |
+--------------------+----------------------------------------------------------------------------------------+
| Request Body       | {                                                                                      |
|                    |                                                                                        |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"                    |
|                    |                                                                                        |
|                    | }                                                                                      |
+--------------------+----------------------------------------------------------------------------------------+
| Example Request    | {                                                                                      |
|                    |                                                                                        |
|                    | "url": "10.107.0.22:443"                                                               |
|                    |                                                                                        |
|                    | }                                                                                      |
+--------------------+----------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                              |
+--------------------+----------------------------------------------------------------------------------------+
| Example Response   | {                                                                                      |
|                    |                                                                                        |
|                    | "code": 200,                                                                           |
|                    |                                                                                        |
|                    | "message": {                                                                           |
|                    |                                                                                        |
|                    | "color": "green",                                                                      |
|                    |                                                                                        |
|                    | "details": [                                                                           |
|                    |                                                                                        |
|                    | "Optional action: Add a device to the trust domain"                                    |
|                    |                                                                                        |
|                    | ],                                                                                     |
|                    |                                                                                        |
|                    | "mode": "standalone",                                                                  |
|                    |                                                                                        |
|                    | "status": "Standalone"                                                                 |
|                    |                                                                                        |
|                    | }                                                                                      |
|                    |                                                                                        |
|                    | }                                                                                      |
+--------------------+----------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                              |
|                    |                                                                                        |
|                    | Content: {error: Bad request}                                                          |
+--------------------+----------------------------------------------------------------------------------------+
| Notes              |                                                                                        |
+--------------------+----------------------------------------------------------------------------------------+

checkbigiptimeout.json
``````````````````````

+--------------------+-------------------------------------------------------------------------------------------------------------------------------+
| Title              | Checks if F5 ACI ServiceCenter application backend’s BIG-IP session has timed out for a specific BIG-IP device                |
+====================+===============================================================================================================================+
| URL                | /checkbigiptimeout.json                                                                                                       |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                          |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                                             |
|                    |                                                                                                                               |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"                                                           |
|                    |                                                                                                                               |
|                    | }                                                                                                                             |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                             |
|                    |                                                                                                                               |
|                    | "url": "10.107.0.22:443"                                                                                                      |
|                    |                                                                                                                               |
|                    | }                                                                                                                             |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                     |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                                             |
|                    |                                                                                                                               |
|                    | "code": 200,                                                                                                                  |
|                    |                                                                                                                               |
|                    | "message": {                                                                                                                  |
|                    |                                                                                                                               |
|                    | "installRequired": false,                                                                                                     |
|                    |                                                                                                                               |
|                    | "message": "Current version of f5-appscvs package is 3.7.0",                                                                  |
|                    |                                                                                                                               |
|                    | "role": "admin",                                                                                                              |
|                    |                                                                                                                               |
|                    | "user": "admin"                                                                                                               |
|                    |                                                                                                                               |
|                    | }                                                                                                                             |
|                    |                                                                                                                               |
|                    | }                                                                                                                             |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 408                                                                                                                     |
|                    |                                                                                                                               |
|                    | Content :                                                                                                                     |
|                    |                                                                                                                               |
|                    | { F5AppSessionTimeout("There is no active session for BIG-IP <BIG-IP IP>. Please login to the BIG-IP before continuing.") }   |
|                    |                                                                                                                               |
|                    | OR                                                                                                                            |
|                    |                                                                                                                               |
|                    | Content : { F5AppSessionTimeout( "BIG-IP session timed out. Please login again.") }                                           |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------+
| Notes              |                                                                                                                               |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------+

checkbigipstatus.json
``````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Check failover state, sync status and also check whether F5 BIG-IP    |
|                    | license has expired.                                                  |
+====================+=======================================================================+
| URL                | /checkbigipstatus.json                                                |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.47:443"                                              |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | "code": 200,                                                          |
|                    |                                                                       |
|                    | "content"                                                             |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "failoverstate": {                                                    |
|                    |                                                                       |
|                    | "color": "green",                                                     |
|                    |                                                                       |
|                    | "status": "ACTIVE"                                                    |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "syncstatus": {                                                       |
|                    |                                                                       |
|                    | "color": "green",                                                     |
|                    |                                                                       |
|                    | "details": [                                                          |
|                    |                                                                       |
|                    | "bigip46.localdomain.com: connected",                                 |
|                    |                                                                       |
|                    | "deviceGroup1 (In Sync): All devices in the device group are in sync",|                                         
|                    |                                                                       |
|                    | "device_trust_group (In Sync): All devices in the device group are    |
|                    | in sync"                                                              |  
|                    |                                                                       |
|                    | ],                                                                    |
|                    |                                                                       |
|                    | "mode": "high-availability",                                          |
|                    |                                                                       |
|                    | "status": "In Sync"                                                   |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

exportdb.json
```````````````````

+--------------------+--------------------------------------------------------------------+
| Title              | Export/Download f5.db database file.                               |
+====================+====================================================================+
| URL                | /exportdbdb.json                                                   |
+--------------------+--------------------------------------------------------------------+
| Method             | GET                                                                |
+--------------------+--------------------------------------------------------------------+
| Success Response   | {                                                                  |
|                    |                                                                    |
|                    | "Code": 200                                                        |
|                    |                                                                    |
|                    | "Content": <f5.db  file contents>                                  |
|                    |                                                                    |
|                    | }                                                                  |
+--------------------+--------------------------------------------------------------------+
| Error Response     | Code: 400                                                          |
|                    |                                                                    |
|                    | Content: {error: Bad request}                                      |
+--------------------+--------------------------------------------------------------------+
| Notes              |                                                                    |
+--------------------+--------------------------------------------------------------------+

importdb.json
```````````````````

+--------------------+--------------------------------------------------------------------+
| Title              | Import/Upload .db database file and migrate a database             |
+====================+====================================================================+
| URL                | /importdb.json                                                     |
+--------------------+--------------------------------------------------------------------+
| Method             | POST                                                               |
+--------------------+--------------------------------------------------------------------+
| Request Body       | {                                                                  |
|                    |                                                                    |
|                    | "file": "<Upload .db file>"                                        |
|                    |                                                                    |
|                    | }                                                                  |
+--------------------+--------------------------------------------------------------------+
| Request Body       | {                                                                  |
|                    |                                                                    |
|                    | "file": "f5.db"                                                    |
|                    |                                                                    |
|                    | }                                                                  |
+--------------------+--------------------------------------------------------------------+
| Success Response   | {                                                                  |
|                    |                                                                    |
|                    | "Code": 200                                                        |
|                    |                                                                    |
|                    | "Content": “f5.db file imported successfully.”                     |
|                    |                                                                    |
|                    | }                                                                  |
+--------------------+--------------------------------------------------------------------+
| Error Response     | Code: 400                                                          |
|                    |                                                                    |
|                    | Content: {error: Bad request}                                      |
+--------------------+--------------------------------------------------------------------+
| Notes              | Content-Type will be application/x-sqlite3                         |
+--------------------+--------------------------------------------------------------------+


getappfaults.json
``````````````````

+--------------------+--------------------------------------------------------------------+
| Title              | Get last 100 faults for F5 ACI ServiceCenter background tasks      |
+====================+====================================================================+
| URL                | /getappfaults.json                                                 | 
+--------------------+--------------------------------------------------------------------+
| Method             | GET                                                                |
+--------------------+--------------------------------------------------------------------+
| Example Response   | {                                                                  |
|                    |                                                                    |
|                    | [                                                                  |
|                    |                                                                    |
|                    |     {                                                              |
|                    |                                                                    |
|                    |         "time": "2020-04-20 09:27:39,276",                         |
|                    |                                                                    |
|                    |         "level": "ERROR",                                          |
|                    |                                                                    |
|                    |         "tab": "",                                                 |
|                    |                                                                    |
|                    |         "resolution": "Disable Re-enable the app",                 |
|                    |                                                                    |
|                    |         "message": "APIC Websocket connection error"               |
|                    |                                                                    |
|                    |     }                                                              |
|                    |                                                                    |
|                    | ]                                                                  |
|                    |                                                                    |
|                    | "Code": 200                                                        |
|                    |                                                                    |
|                    | "Content": <list of JSON dictionaries>                             |
|                    |                                                                    |
|                    | }                                                                  |
|                    |                                                                    |
+--------------------+--------------------------------------------------------------------+
| Error Response     | Code: 400                                                          |
|                    |                                                                    |
|                    | Content: {error: Bad request}                                      |
+--------------------+--------------------------------------------------------------------+
| Notes              | Only the last 100 errors/warnings will be displayed                |
+--------------------+--------------------------------------------------------------------+


getbigipfaults.json
````````````````````

+--------------------+--------------------------------------------------------------------+
| Title              | Get last 100 faults for a BIG-IP                                   |
+====================+====================================================================+
| URL                | /getbigipfaults.json                                               |
+--------------------+--------------------------------------------------------------------+
| Method             | POST                                                               |
+--------------------+--------------------------------------------------------------------+
| Request Body       | {                                                                  |
|                    |                                                                    |
|                    | "url": "<BIGIP IP or IP:Port or Hostname or Hostname:Port>"        |
|                    |                                                                    |
|                    | }                                                                  |
+--------------------+--------------------------------------------------------------------+
| Request Body       | {                                                                  |
|                    |                                                                    |
|                    | "url": "10.107.0.22"                                               |
|                    |                                                                    |
|                    | }                                                                  |
+--------------------+--------------------------------------------------------------------+
| Example Response   | {                                                                  |
|                    |                                                                    |
|                    | [                                                                  |
|                    |                                                                    |
|                    |     {                                                              |
|                    |                                                                    |
|                    |         "time": "2020-04-20 09:27:39,276",                         |
|                    |                                                                    |
|                    |         "level": "ERROR",                                          |
|                    |                                                                    |
|                    |         "tab": "L4-L7 App Services",                               |
|                    |                                                                    |
|                    |         "resolution": "",                                          |
|                    |                                                                    |
|                    |         "message": "Error message"                                 |
|                    |                                                                    |
|                    |     }                                                              |
|                    |                                                                    |
|                    | ]                                                                  |
|                    |                                                                    |
|                    | "Code": 200                                                        |
|                    |                                                                    |
|                    | "Content": <list of JSON dictionaries>                             |
|                    |                                                                    |
|                    | }                                                                  |
|                    |                                                                    |
+--------------------+--------------------------------------------------------------------+
| Error Response     | Code: 400                                                          |
|                    |                                                                    |
|                    | Content: {error: Bad request}                                      |
+--------------------+--------------------------------------------------------------------+
| Notes              | Only the last 100 errors/warnings will be displayed                |
+--------------------+--------------------------------------------------------------------+


L4-L7 App Services APIs
-----------------------

dryrunas3declaration.json
`````````````````````````

+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Submits AS3 declaration to BIG-IP with changed action “dry-run”. This ensures that the declaration is validated by BIG-IP but does not actually create the resources.                                                                                    |
+====================+==========================================================================================================================================================================================================================================================+
| URL                | /dryrunas3declaration.json                                                                                                                                                                                                                               |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                                                                                                                     |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | "url": "10.107.0.22:443",                                                                                                                                                                                                                                |
|                    |                                                                                                                                                                                                                                                          |
|                    | "as3Declaration": {                                                                                                                                                                                                                                      |
|                    |                                                                                                                                                                                                                                                          |
|                    | "class": "AS3",                                                                                                                                                                                                                                          |
|                    |                                                                                                                                                                                                                                                          |
|                    | "action": "deploy",                                                                                                                                                                                                                                      |
|                    |                                                                                                                                                                                                                                                          |
|                    | "persist": true,                                                                                                                                                                                                                                         |
|                    |                                                                                                                                                                                                                                                          |
|                    | "declaration": {                                                                                                                                                                                                                                         |
|                    |                                                                                                                                                                                                                                                          |
|                    | "class": "ADC",                                                                                                                                                                                                                                          |
|                    |                                                                                                                                                                                                                                                          |
|                    | "schemaVersion": "3.0.0",                                                                                                                                                                                                                                |
|                    |                                                                                                                                                                                                                                                          |
|                    | "id": "urn:uuid:33045210-3ab8-4636-9b2a-c98d22ab915d",                                                                                                                                                                                                   |
|                    |                                                                                                                                                                                                                                                          |
|                    | "label": "Sample 122",                                                                                                                                                                                                                                   |
|                    |                                                                                                                                                                                                                                                          |
|                    | "remark": "Simple HTTP application with RR pool",                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | "Sample\_01": {                                                                                                                                                                                                                                          |
|                    |                                                                                                                                                                                                                                                          |
|                    | "class": "Tenant",                                                                                                                                                                                                                                       |
|                    |                                                                                                                                                                                                                                                          |
|                    | "A1": {                                                                                                                                                                                                                                                  |
|                    |                                                                                                                                                                                                                                                          |
|                    | "class": "Application",                                                                                                                                                                                                                                  |
|                    |                                                                                                                                                                                                                                                          |
|                    | "template": "http",                                                                                                                                                                                                                                      |
|                    |                                                                                                                                                                                                                                                          |
|                    | "serviceMain": {                                                                                                                                                                                                                                         |
|                    |                                                                                                                                                                                                                                                          |
|                    | "class": "Service\_HTTP",                                                                                                                                                                                                                                |
|                    |                                                                                                                                                                                                                                                          |
|                    | "virtualAddresses": [                                                                                                                                                                                                                                    |
|                    |                                                                                                                                                                                                                                                          |
|                    | "10.0.1.10"                                                                                                                                                                                                                                              |
|                    |                                                                                                                                                                                                                                                          |
|                    | ],                                                                                                                                                                                                                                                       |
|                    |                                                                                                                                                                                                                                                          |
|                    | "pool": "web\_pool"                                                                                                                                                                                                                                      |
|                    |                                                                                                                                                                                                                                                          |
|                    | },                                                                                                                                                                                                                                                       |
|                    |                                                                                                                                                                                                                                                          |
|                    | "web\_pool": {                                                                                                                                                                                                                                           |
|                    |                                                                                                                                                                                                                                                          |
|                    | "class": "Pool",                                                                                                                                                                                                                                         |
|                    |                                                                                                                                                                                                                                                          |
|                    | "monitors": [                                                                                                                                                                                                                                            |
|                    |                                                                                                                                                                                                                                                          |
|                    | "http"                                                                                                                                                                                                                                                   |
|                    |                                                                                                                                                                                                                                                          |
|                    | ],                                                                                                                                                                                                                                                       |
|                    |                                                                                                                                                                                                                                                          |
|                    | "members": [                                                                                                                                                                                                                                             |
|                    |                                                                                                                                                                                                                                                          |
|                    | {                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | "servicePort": 80,                                                                                                                                                                                                                                       |
|                    |                                                                                                                                                                                                                                                          |
|                    | "serverAddresses": [                                                                                                                                                                                                                                     |
|                    |                                                                                                                                                                                                                                                          |
|                    | "192.0.1.10",                                                                                                                                                                                                                                            |
|                    |                                                                                                                                                                                                                                                          |
|                    | "192.0.1.11"                                                                                                                                                                                                                                             |
|                    |                                                                                                                                                                                                                                                          |
|                    | ]                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | }                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | ]                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | }                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | }                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | }                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | }                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | }                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | }                                                                                                                                                                                                                                                        |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | {                                                                                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                                                                          |
|                    | "code": 200,                                                                                                                                                                                                                                             |
|                    |                                                                                                                                                                                                                                                          |
|                    | "message": "AS3 declaration dry-run successful"                                                                                                                                                                                                          |
|                    |                                                                                                                                                                                                                                                          |
|                    | }                                                                                                                                                                                                                                                        |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                                                                                                                                                                |
|                    |                                                                                                                                                                                                                                                          |
|                    | Content: {error: Bad request}                                                                                                                                                                                                                            |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes              | The JSON provided has an action of **deploy**, and in the application, the JDON remains the same, except for the action attribute, which is changed to **dry-run** and a POST request is sent to <BIG-IP IP address>/mgmt/shared/appsvcs/declare         |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

submitas3declaration.json
`````````````````````````

+--------------------+-----------------------------------------------------------------------------------------------------------------------+
| Title              | Submits the AS3 declaration to specified BIG-IP device’s AS3 endpoint                                                 |
+====================+=======================================================================================================================+
| URL                | /submitas3declaration.json                                                                                            |
+--------------------+-----------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                  |
+--------------------+-----------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                     |
|                    |                                                                                                                       |
|                    | "url": "10.107.0.22:443",                                                                                             |
|                    |                                                                                                                       |
|                    | "as3Declaration": {                                                                                                   |
|                    |                                                                                                                       |
|                    | "class": "AS3",                                                                                                       |
|                    |                                                                                                                       |
|                    | "action": "deploy",                                                                                                   |
|                    |                                                                                                                       |
|                    | "persist": true,                                                                                                      |
|                    |                                                                                                                       |
|                    | "declaration": {                                                                                                      |
|                    |                                                                                                                       |
|                    | "class": "ADC",                                                                                                       |
|                    |                                                                                                                       |
|                    | "schemaVersion": "3.0.0",                                                                                             |
|                    |                                                                                                                       |
|                    | "id": "urn:uuid:33045210-3ab8-4636-9b2a-c98d22ab915d",                                                                |
|                    |                                                                                                                       |
|                    | "label": "Sample 122",                                                                                                |
|                    |                                                                                                                       |
|                    | "remark": "Simple HTTP application with RR pool",                                                                     |
|                    |                                                                                                                       |
|                    | "Sample\_01": {                                                                                                       |
|                    |                                                                                                                       |
|                    | "class": "Tenant",                                                                                                    |
|                    |                                                                                                                       |
|                    | "A1": {                                                                                                               |
|                    |                                                                                                                       |
|                    | "class": "Application",                                                                                               |
|                    |                                                                                                                       |
|                    | "template": "http",                                                                                                   |
|                    |                                                                                                                       |
|                    | "serviceMain": {                                                                                                      |
|                    |                                                                                                                       |
|                    | "class": "Service\_HTTP",                                                                                             |
|                    |                                                                                                                       |
|                    | "virtualAddresses": [                                                                                                 |
|                    |                                                                                                                       |
|                    | "10.0.1.10"                                                                                                           |
|                    |                                                                                                                       |
|                    | ],                                                                                                                    |
|                    |                                                                                                                       |
|                    | "pool": "web\_pool"                                                                                                   |
|                    |                                                                                                                       |
|                    | },                                                                                                                    |
|                    |                                                                                                                       |
|                    | "web\_pool": {                                                                                                        |
|                    |                                                                                                                       |
|                    | "class": "Pool",                                                                                                      |
|                    |                                                                                                                       |
|                    | "monitors": [                                                                                                         |
|                    |                                                                                                                       |
|                    | "http"                                                                                                                |
|                    |                                                                                                                       |
|                    | ],                                                                                                                    |
|                    |                                                                                                                       |
|                    | "members": [                                                                                                          |
|                    |                                                                                                                       |
|                    | {                                                                                                                     |
|                    |                                                                                                                       |
|                    | "servicePort": 80,                                                                                                    |
|                    |                                                                                                                       |
|                    | "serverAddresses": [                                                                                                  |
|                    |                                                                                                                       |
|                    | "192.0.1.10",                                                                                                         |
|                    |                                                                                                                       |
|                    | "192.0.1.11"                                                                                                          |
|                    |                                                                                                                       |
|                    | ]                                                                                                                     |
|                    |                                                                                                                       |
|                    | }                                                                                                                     |
|                    |                                                                                                                       |
|                    | ]                                                                                                                     |
|                    |                                                                                                                       |
|                    | }                                                                                                                     |
|                    |                                                                                                                       |
|                    | }                                                                                                                     |
|                    |                                                                                                                       |
|                    | }                                                                                                                     |
|                    |                                                                                                                       |
|                    | }                                                                                                                     |
|                    |                                                                                                                       |
|                    | }                                                                                                                     |
|                    |                                                                                                                       |
|                    | }                                                                                                                     |
+--------------------+-----------------------------------------------------------------------------------------------------------------------+
| Success Response   | {                                                                                                                     |
|                    |                                                                                                                       |
|                    | "code": 200,                                                                                                          |
|                    |                                                                                                                       |
|                    | "message": "AS3 declaration submitted successfully"                                                                   |
|                    |                                                                                                                       |
|                    | }                                                                                                                     |
+--------------------+-----------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                             |
|                    |                                                                                                                       |
|                    | Content: {error: Bad request}                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------+
| Notes              | The JSON from the dictionary above is posted to the AS3 endpoint <BIG-IP IP address>/mgmt/shared/appsvcs/declare      |
+--------------------+-----------------------------------------------------------------------------------------------------------------------+

getas3declaration.json
``````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Get the AS3 declaration JSON from the given BIG-IP device                                                  |
+====================+============================================================================================================+
| URL                | /getas3declaration.json                                                                                    |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"                                        |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "10.107.0.22:443"                                                                                   |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | Content: <AS3 declaration JSON>                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                          |
|                    |                                                                                                            |
|                    | "updateMode": "selective",                                                                                 |
|                    |                                                                                                            |
|                    | "testTenant": {                                                                                            |
|                    |                                                                                                            |
|                    | "optimisticLockKey": "3K53Nr51QNrBSwzCpYFJUSYfTaxu+KqJ1S83Js9DNDo=",                                       |
|                    |                                                                                                            |
|                    | "A10": {                                                                                                   |
|                    |                                                                                                            |
|                    | "web\_pool": {                                                                                             |
|                    |                                                                                                            |
|                    | "class": "Pool",                                                                                           |
|                    |                                                                                                            |
|                    | "members": [                                                                                               |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "serverAddresses": [                                                                                       |
|                    |                                                                                                            |
|                    | "102.3.3.2",                                                                                               |
|                    |                                                                                                            |
|                    | "10.2.3.1"                                                                                                 |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "servicePort": 80                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "monitors": [                                                                                              |
|                    |                                                                                                            |
|                    | "http"                                                                                                     |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "class": "Application",                                                                                    |
|                    |                                                                                                            |
|                    | "template": "http",                                                                                        |
|                    |                                                                                                            |
|                    | "serviceMain": {                                                                                           |
|                    |                                                                                                            |
|                    | "class": "Service\_HTTP",                                                                                  |
|                    |                                                                                                            |
|                    | "pool": "web\_pool",                                                                                       |
|                    |                                                                                                            |
|                    | "virtualAddresses": [                                                                                      |
|                    |                                                                                                            |
|                    | "10.2.3.2"                                                                                                 |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "class": "Tenant"                                                                                          |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "Sample\_01": {                                                                                            |
|                    |                                                                                                            |
|                    | "A1": {                                                                                                    |
|                    |                                                                                                            |
|                    | "web\_pool": {                                                                                             |
|                    |                                                                                                            |
|                    | "class": "Pool",                                                                                           |
|                    |                                                                                                            |
|                    | "members": [                                                                                               |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "serverAddresses": [                                                                                       |
|                    |                                                                                                            |
|                    | "192.0.1.10",                                                                                              |
|                    |                                                                                                            |
|                    | "192.0.1.11"                                                                                               |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "servicePort": 80                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "monitors": [                                                                                              |
|                    |                                                                                                            |
|                    | "http"                                                                                                     |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "class": "Application",                                                                                    |
|                    |                                                                                                            |
|                    | "template": "http",                                                                                        |
|                    |                                                                                                            |
|                    | "serviceMain": {                                                                                           |
|                    |                                                                                                            |
|                    | "class": "Service\_HTTP",                                                                                  |
|                    |                                                                                                            |
|                    | "pool": "web\_pool",                                                                                       |
|                    |                                                                                                            |
|                    | "virtualAddresses": [                                                                                      |
|                    |                                                                                                            |
|                    | "10.0.1.10"                                                                                                |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "optimisticLockKey": "FTeF77jLZ5WXRgv7ISNbnxqOYG/jOV1VccRnQ32Qp44=",                                       |
|                    |                                                                                                            |
|                    | "class": "Tenant"                                                                                          |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "controls": {                                                                                              |
|                    |                                                                                                            |
|                    | "archiveTimestamp": "2019-07-04T12:33:41.049Z"                                                             |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "class": "ADC",                                                                                            |
|                    |                                                                                                            |
|                    | "schemaVersion": "3.0.0",                                                                                  |
|                    |                                                                                                            |
|                    | "id": "1562243620455"                                                                                      |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              | Gets the AS3 declaration from the AS3 endpoint <BIG-IP IP address>/mgmt/shared/appsvcs/declare             |
+--------------------+------------------------------------------------------------------------------------------------------------+

deleteas3declaration.json
`````````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Deletes the entire AS3 declaration from a BIG-IP device               |
+====================+=======================================================================+
| URL                | /deleteas3declaration.json                                            |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.22"                                                  |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | {                                                                     |
|                    |                                                                       |
|                    | "code": 200,                                                          |
|                    |                                                                       |
|                    | "message": "AS3 declaration deleted successfully"                     |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

getas3data.json
```````````````

+--------------------+--------------------------------------------------------------------------------------------+
| Title              | Gets AS3 data JSON from BIG-IP device                                                      |
+====================+============================================================================================+
| URL                | /getas3data.json                                                                           |
+--------------------+--------------------------------------------------------------------------------------------+
| Method             | POST                                                                                       |
+--------------------+--------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                          |
|                    |                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"                        |
|                    |                                                                                            |
|                    | }                                                                                          |
+--------------------+--------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                          |
|                    |                                                                                            |
|                    | "url": "10.107.0.22:443"                                                                   |
|                    |                                                                                            |
|                    | }                                                                                          |
+--------------------+--------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                  |
+--------------------+--------------------------------------------------------------------------------------------+
| Example Response   | [                                                                                          |
|                    |                                                                                            |
|                    | {                                                                                          |
|                    |                                                                                            |
|                    | "applications": [                                                                          |
|                    |                                                                                            |
|                    | {                                                                                          |
|                    |                                                                                            |
|                    | "application": "A10",                                                                      |
|                    |                                                                                            |
|                    | "json": {                                                                                  |
|                    |                                                                                            |
|                    | "web\_pool": {                                                                             |
|                    |                                                                                            |
|                    | "class": "Pool",                                                                           |
|                    |                                                                                            |
|                    | "members": [                                                                               |
|                    |                                                                                            |
|                    | {                                                                                          |
|                    |                                                                                            |
|                    | "serverAddresses": [                                                                       |
|                    |                                                                                            |
|                    | "102.3.3.2",                                                                               |
|                    |                                                                                            |
|                    | "10.2.3.1"                                                                                 |
|                    |                                                                                            |
|                    | ],                                                                                         |
|                    |                                                                                            |
|                    | "servicePort": 80                                                                          |
|                    |                                                                                            |
|                    | }                                                                                          |
|                    |                                                                                            |
|                    | ],                                                                                         |
|                    |                                                                                            |
|                    | "monitors": [                                                                              |
|                    |                                                                                            |
|                    | "http"                                                                                     |
|                    |                                                                                            |
|                    | ]                                                                                          |
|                    |                                                                                            |
|                    | },                                                                                         |
|                    |                                                                                            |
|                    | "class": "Application",                                                                    |
|                    |                                                                                            |
|                    | "template": "http",                                                                        |
|                    |                                                                                            |
|                    | "serviceMain": {                                                                           |
|                    |                                                                                            |
|                    | "class": "Service\_HTTP",                                                                  |
|                    |                                                                                            |
|                    | "pool": "web\_pool",                                                                       |
|                    |                                                                                            |
|                    | "virtualAddresses": [                                                                      |
|                    |                                                                                            |
|                    | "10.2.3.2"                                                                                 |
|                    |                                                                                            |
|                    | ]                                                                                          |
|                    |                                                                                            |
|                    | }                                                                                          |
|                    |                                                                                            |
|                    | }                                                                                          |
|                    |                                                                                            |
|                    | }                                                                                          |
|                    |                                                                                            |
|                    | ],                                                                                         |
|                    |                                                                                            |
|                    | "partition": "testTenant"                                                                  |
|                    |                                                                                            |
|                    | },                                                                                         |
|                    |                                                                                            |
|                    | {                                                                                          |
|                    |                                                                                            |
|                    | "applications": [                                                                          |
|                    |                                                                                            |
|                    | {                                                                                          |
|                    |                                                                                            |
|                    | "application": "A1",                                                                       |
|                    |                                                                                            |
|                    | "json": {                                                                                  |
|                    |                                                                                            |
|                    | "web\_pool": {                                                                             |
|                    |                                                                                            |
|                    | "class": "Pool",                                                                           |
|                    |                                                                                            |
|                    | "members": [                                                                               |
|                    |                                                                                            |
|                    | {                                                                                          |
|                    |                                                                                            |
|                    | "serverAddresses": [                                                                       |
|                    |                                                                                            |
|                    | "192.0.1.10",                                                                              |
|                    |                                                                                            |
|                    | "192.0.1.11"                                                                               |
|                    |                                                                                            |
|                    | ],                                                                                         |
|                    |                                                                                            |
|                    | "servicePort": 80                                                                          |
|                    |                                                                                            |
|                    | }                                                                                          |
|                    |                                                                                            |
|                    | ],                                                                                         |
|                    |                                                                                            |
|                    | "monitors": [                                                                              |
|                    |                                                                                            |
|                    | "http"                                                                                     |
|                    |                                                                                            |
|                    | ]                                                                                          |
|                    |                                                                                            |
|                    | },                                                                                         |
|                    |                                                                                            |
|                    | "class": "Application",                                                                    |
|                    |                                                                                            |
|                    | "template": "http",                                                                        |
|                    |                                                                                            |
|                    | "serviceMain": {                                                                           |
|                    |                                                                                            |
|                    | "class": "Service\_HTTP",                                                                  |
|                    |                                                                                            |
|                    | "pool": "web\_pool",                                                                       |
|                    |                                                                                            |
|                    | "virtualAddresses": [                                                                      |
|                    |                                                                                            |
|                    | "10.0.1.10"                                                                                |
|                    |                                                                                            |
|                    | ]                                                                                          |
|                    |                                                                                            |
|                    | }                                                                                          |
|                    |                                                                                            |
|                    | }                                                                                          |
|                    |                                                                                            |
|                    | }                                                                                          |
|                    |                                                                                            |
|                    | ],                                                                                         |
|                    |                                                                                            |
|                    | "partition": "Sample\_01"                                                                  |
|                    |                                                                                            |
|                    | }                                                                                          |
|                    |                                                                                            |
|                    | ]                                                                                          |
+--------------------+--------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                  |
|                    |                                                                                            |
|                    | Content: {error: Bad request}                                                              |
+--------------------+--------------------------------------------------------------------------------------------+
| Notes              | Get AS3 data JSON from given BIG-IP AS3 endpoint to load partition, application and json   |
+--------------------+--------------------------------------------------------------------------------------------+

updateas3data.json
``````````````````

+--------------------+--------------------------------------------------------------------------------+
| Title              | Updates AS3 declaration for a BIG-IP device to achieve one of the following:   |
|                    |                                                                                |
|                    | -  Create a new partition                                                      |
|                    |                                                                                |
|                    | -  Create a new application                                                    |
|                    |                                                                                |
|                    | -  Update an Application                                                       |
+====================+================================================================================+
| URL                | /updateas3data.json                                                            |
+--------------------+--------------------------------------------------------------------------------+
| Method             | POST                                                                           |
+--------------------+--------------------------------------------------------------------------------+
| Request Body       | {                                                                              |
|                    |                                                                                |
|                    | "url": " <BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",          |
|                    |                                                                                |
|                    | "partition": "<Partition\_Name>",                                              |
|                    |                                                                                |
|                    | "application": "<Application\_Name>",                                          |
|                    |                                                                                |
|                    | "json": {                                                                      |
|                    |                                                                                |
|                    | "class": "Application",                                                        |
|                    |                                                                                |
|                    | "template": "http",                                                            |
|                    |                                                                                |
|                    | "serviceMain": {                                                               |
|                    |                                                                                |
|                    | "class": "Service\_HTTP",                                                      |
|                    |                                                                                |
|                    | "virtualAddresses": [                                                          |
|                    |                                                                                |
|                    | "<<YOUR\_VIP\_HERE>>"                                                          |
|                    |                                                                                |
|                    | ],                                                                             |
|                    |                                                                                |
|                    | "pool": "<<YOUR\_POOL\_NAME\_HERE>>"                                           |
|                    |                                                                                |
|                    | },                                                                             |
|                    |                                                                                |
|                    | "<<YOUR\_POOL\_NAME\_HERE>>": {                                                |
|                    |                                                                                |
|                    | "class": "Pool",                                                               |
|                    |                                                                                |
|                    | "monitors": [                                                                  |
|                    |                                                                                |
|                    | "http"                                                                         |
|                    |                                                                                |
|                    | ],                                                                             |
|                    |                                                                                |
|                    | "members": [                                                                   |
|                    |                                                                                |
|                    | {                                                                              |
|                    |                                                                                |
|                    | "servicePort": 80,                                                             |
|                    |                                                                                |
|                    | "serverAddresses": [                                                           |
|                    |                                                                                |
|                    | "<<YOUR\_POOL\_MEMBER\_HERE>>",                                                |
|                    |                                                                                |
|                    | "<<YOUR\_POOL\_MEMBER\_HERE>>"                                                 |
|                    |                                                                                |
|                    | ]                                                                              |
|                    |                                                                                |
|                    | }                                                                              |
|                    |                                                                                |
|                    | ]                                                                              |
|                    |                                                                                |
|                    | }                                                                              |
|                    |                                                                                |
|                    | }                                                                              |
|                    |                                                                                |
|                    | }                                                                              |
+--------------------+--------------------------------------------------------------------------------+
| Example Request    | {                                                                              |
|                    |                                                                                |
|                    | "url": "10.107.0.22:443",                                                      |
|                    |                                                                                |
|                    | "partition": "DemoPartition2",                                                 |
|                    |                                                                                |
|                    | "application": "DemoApp21",                                                    |
|                    |                                                                                |
|                    | "json": {                                                                      |
|                    |                                                                                |
|                    | "class": "Application",                                                        |
|                    |                                                                                |
|                    | "template": "http",                                                            |
|                    |                                                                                |
|                    | "serviceMain": {                                                               |
|                    |                                                                                |
|                    | "class": "Service\_HTTP",                                                      |
|                    |                                                                                |
|                    | "virtualAddresses": [                                                          |
|                    |                                                                                |
|                    | "10.30.10.20"                                                                  |
|                    |                                                                                |
|                    | ],                                                                             |
|                    |                                                                                |
|                    | "pool": "web\_pool"                                                            |
|                    |                                                                                |
|                    | },                                                                             |
|                    |                                                                                |
|                    | "web\_pool": {                                                                 |
|                    |                                                                                |
|                    | "class": "Pool",                                                               |
|                    |                                                                                |
|                    | "monitors": [                                                                  |
|                    |                                                                                |
|                    | "http"                                                                         |
|                    |                                                                                |
|                    | ],                                                                             |
|                    |                                                                                |
|                    | "members": [                                                                   |
|                    |                                                                                |
|                    | {                                                                              |
|                    |                                                                                |
|                    | "servicePort": 80,                                                             |
|                    |                                                                                |
|                    | "serverAddresses": [                                                           |
|                    |                                                                                |
|                    | "10.30.10.21"                                                                  |
|                    |                                                                                |
|                    | ]                                                                              |
|                    |                                                                                |
|                    | }                                                                              |
|                    |                                                                                |
|                    | ]                                                                              |
|                    |                                                                                |
|                    | }                                                                              |
|                    |                                                                                |
|                    | }                                                                              |
|                    |                                                                                |
|                    | }                                                                              |
+--------------------+--------------------------------------------------------------------------------+
| Success Response   | {                                                                              |
|                    |                                                                                |
|                    | "code": 200,                                                                   |
|                    |                                                                                |
|                    | "message": "Created partition DemoPartition2 successfully"                     |
|                    |                                                                                |
|                    | }                                                                              |
|                    |                                                                                |
|                    | OR                                                                             |
|                    |                                                                                |
|                    | {                                                                              |
|                    |                                                                                |
|                    | "code": 200,                                                                   |
|                    |                                                                                |
|                    | "message": "Created application DemoApp2 successfully"                         |
|                    |                                                                                |
|                    | }                                                                              |
|                    |                                                                                |
|                    | OR                                                                             |
|                    |                                                                                |
|                    | {                                                                              |
|                    |                                                                                |
|                    | "code": 200,                                                                   |
|                    |                                                                                |
|                    | "message": "Updated application DemoApp2 successfully"                         |
|                    |                                                                                |
|                    | }                                                                              |
+--------------------+--------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                      |
|                    |                                                                                |
|                    | Content: {error: Bad request}                                                  |
+--------------------+--------------------------------------------------------------------------------+
| Notes              |                                                                                |
+--------------------+--------------------------------------------------------------------------------+

deleteas3partition.json
```````````````````````

+--------------------+-------------------------------------------------------------------------+
| Title              | Deletes AS3 partition from a specified BIG-IP Device                    |
+====================+=========================================================================+
| URL                | /deleteas3partition.json                                                |
+--------------------+-------------------------------------------------------------------------+
| Method             | POST                                                                    |
+--------------------+-------------------------------------------------------------------------+
| Request Body       | {                                                                       |
|                    |                                                                         |
|                    | " url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",   |
|                    |                                                                         |
|                    | "partition": "<Partition\_Name>"                                        |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Example Request    | {                                                                       |
|                    |                                                                         |
|                    | "url": "10.107.0.22:443",                                               |
|                    |                                                                         |
|                    | "partition": "DemoPartition2"                                           |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Example Response   | {                                                                       |
|                    |                                                                         |
|                    | "code": 200,                                                            |
|                    |                                                                         |
|                    | "message": "Partition DemoPartition2 deleted successfully"              |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Error Response     | Code: 400                                                               |
|                    |                                                                         |
|                    | Content: {error: Bad request}                                           |
+--------------------+-------------------------------------------------------------------------+
| Notes              |                                                                         |
+--------------------+-------------------------------------------------------------------------+

deleteas3application.json
`````````````````````````

+--------------------+-------------------------------------------------------------------------+
| Title              | Deletes an application from the BIG-IP AS3 declaration                  |
+====================+=========================================================================+
| URL                | /deleteas3application.json                                              |
+--------------------+-------------------------------------------------------------------------+
| Method             | POST                                                                    |
+--------------------+-------------------------------------------------------------------------+
| Request Body       | {                                                                       |
|                    |                                                                         |
|                    | " url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",   |
|                    |                                                                         |
|                    | "partition": "<Partition\_Name>",                                       |
|                    |                                                                         |
|                    | "application": "<Application\_Name>"                                    |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Example Request    | {                                                                       |
|                    |                                                                         |
|                    | "url": "10.107.0.22:443",                                               |
|                    |                                                                         |
|                    | "partition": "DemoPartition1",                                          |
|                    |                                                                         |
|                    | "application": "DemoApp1"                                               |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Example Response   | {                                                                       |
|                    |                                                                         |
|                    | "code": 200,                                                            |
|                    |                                                                         |
|                    | "message": "Application DemoApp1 deleted successfully"                  |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Error Response     | Code: 400                                                               |
|                    |                                                                         |
|                    | Content: {error: Bad request}                                           |
+--------------------+-------------------------------------------------------------------------+
| Notes              |                                                                         |
+--------------------+-------------------------------------------------------------------------+

getas3templates.json  
`````````````````````

+--------------------+-------------------------------------------------------------------------+
| Title              | Get list of AS3 templates from the application database                 |
+====================+=========================================================================+
| URL                | /getas3templates.json                                                   |
+--------------------+-------------------------------------------------------------------------+
| Method             | GET                                                                     |
+--------------------+-------------------------------------------------------------------------+
| Example Response   | [{                                                                      |                                       
|                    | "allowDelete": true,                                                    |
|                    | "mst": "{\"class\": \"AS3\",\"action\": \"deploy\", \"persist\": true,  |
|                    | \"declaration\": {\"class\": \"ADC\", \"schemaVersion\": \"3.0.0\",     |
|                    | \"id\": \"template-simple-http\"\"label\": \"Sample 1\",                |
|                    | \"remark\": \"Basic HTTP with Monitor\",\"{{tenant_name}}\": {\"class\":| 
|                    | \"Tenant\", \"{{application_name}}\": { \"class\": \"Application\",     |
|                    | \"template\": \"http\", \"serviceMain\": { \"class\": \"Service_HTTP\", |
|                    | \"virtualPort\": {{virtual_port::number}},\"virtualAddresses\":         |
|                    | [\"{{virtual_address}}\"], \"pool\": \"web_pool\"}, \"web_pool\":       | 
|                    | { \"class\": \"Pool\", \"monitors\": [ \"http\" ],\"members\":          |
|                    | [{ \"servicePort\": {{server_port::number}}, \"serverAddresses \":      |
|                    | {{server_addresses::array}}} ] }} }}}",                                 |
|                    | "name": "test_template"                                                 | 
|                    | }]                                                                      |
+--------------------+-------------------------------------------------------------------------+
| Error Response     | Code: 400                                                               |
|                    |                                                                         |
|                    | Content: {error: Bad request}                                           |
+--------------------+-------------------------------------------------------------------------+
| Notes              |                                                                         |
+--------------------+-------------------------------------------------------------------------+

createas3template.json
`````````````````````````

+--------------------+-------------------------------------------------------------------------+
| Title              | Create AS3 template                                                     |
+====================+=========================================================================+
| URL                | /createas3template.json                                                 |
+--------------------+-------------------------------------------------------------------------+
| Method             | POST                                                                    |
+--------------------+-------------------------------------------------------------------------+
| Request Body       | {                                                                       |
|                    |                                                                         |
|                    | "name": "<Template Name>",                                              |
|                    |                                                                         |
|                    | "mst": "<AS3 Template>",                                                |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Example Request    | {                                                                       |
|                    | "name": "test_template",                                                |
|                    | "mst": "{\"class\": \"AS3\",\"action\": \"deploy\", \"persist\": true,  |
|                    | \"declaration\": {\"class\": \"ADC\", \"schemaVersion\": \"3.0.0\",     |
|                    | \"id\": \"template-simple-http\"\"label\": \"Sample 1\",                |
|                    | \"remark\": \"Basic HTTP with Monitor\",\"{{tenant_name}}\": {\"class\":| 
|                    | \"Tenant\", \"{{application_name}}\": { \"class\": \"Application\",     |
|                    | \"template\": \"http\", \"serviceMain\": { \"class\": \"Service_HTTP\", |
|                    | \"virtualPort\": {{virtual_port::number}},\"virtualAddresses\":         |
|                    | [\"{{virtual_address}}\"], \"pool\": \"web_pool\"}, \"web_pool\":       | 
|                    | { \"class\": \"Pool\", \"monitors\": [ \"http\" ],\"members\":          |
|                    | [{ \"servicePort\": {{server_port::number}}, \"serverAddresses \":      |
|                    | {{server_addresses::array}}} ] }} }}}"                                  |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Example Response   | {                                                                       |
|                    |                                                                         |
|                    | "code": 200,                                                            |
|                    |                                                                         |
|                    | "message":  “Template test_template created successfully."              |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Error Response     | Code: 400                                                               |
|                    |                                                                         |
|                    | Content: {error: Bad request}                                           |
+--------------------+-------------------------------------------------------------------------+
| Notes              |                                                                         |
+--------------------+-------------------------------------------------------------------------+

deleteas3template.json
`````````````````````````

+--------------------+-------------------------------------------------------------------------+
| Title              | Delete AS3 template                                                     |
+====================+=========================================================================+
| URL                | /deleteas3template.json                                                 |
+--------------------+-------------------------------------------------------------------------+
| Method             | POST                                                                    |
+--------------------+-------------------------------------------------------------------------+
| Request Body       | {                                                                       |
|                    |                                                                         |
|                    | "name": "<Template Name>"                                               |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Example Request    | {                                                                       |
|                    |                                                                         |
|                    | "name": "test_template"                                                 |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Example Response   | {                                                                       |
|                    |                                                                         |
|                    | "code": 200,                                                            |
|                    |                                                                         |
|                    | "message": "test_template template deleted successfully"                |
|                    |                                                                         |
|                    | }                                                                       |
+--------------------+-------------------------------------------------------------------------+
| Error Response     | Code: 400                                                               |
|                    |                                                                         |
|                    | Content: {error: Bad request}                                           |
+--------------------+-------------------------------------------------------------------------+
| Notes              | This API does not permit deletion of default templates.                 |
+--------------------+-------------------------------------------------------------------------+



getasynctaskresponse.json
``````````````````````````

+--------------------+-------------------------------------------------------------------------+
| Title              | Get AS3 async task response                                             |
+====================+=========================================================================+
| URL                | /getasynctaskresponse.json                                              |
+--------------------+-------------------------------------------------------------------------+
| Method             | POST                                                                    |
+--------------------+-------------------------------------------------------------------------+
| Request Body       | {                                                                       |
|                    |                                                                         |
|                    | "taskId": <Task_Id>                                                     |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
+--------------------+-------------------------------------------------------------------------+
| Example Request    | {                                                                       |
|                    |                                                                         |
|                    | "taskId":"dcd1280f-11d8-4a9b-997b-e4c0a69de119"                         |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
+--------------------+-------------------------------------------------------------------------+
| Success Response   | Code: 200                                                               |
|                    |                                                                         |
|                    | "message": {                                                            |
|                    |                                                                         |
|                    | "message": <Response_Message >,                                         |
|                    |                                                                         |
|                    | "statuscode": <Status_Code>,                                            |
|                    |                                                                         |
|                    | "taskId": <Task_Id>                                                     |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
|                    | OR                                                                      |
|                    |                                                                         |
|                    | Code: 200                                                               |
|                    |                                                                         |
|                    | "message": {                                                            |
|                    |                                                                         |
|                    | "message": <Response_Message >,                                         |
|                    |                                                                         |
|                    | "statuscode": <Status_Code>,                                            |
|                    |                                                                         |
|                    | "taskId": <Task_Id>,                                                    |
|                    |                                                                         |
|                    | "as3data": [<as3_data>],                                                |
|                    |                                                                         |
|                    | "as3declaration": <as3_declaration>                                     |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
+--------------------+-------------------------------------------------------------------------+
| Example Response   | Code: 200                                                               |
|                    |                                                                         |
|                    | "message": {                                                            |
|                    |                                                                         |
|                    | "message": "in progress",                                               |
|                    |                                                                         |
|                    | "statuscode": 0,                                                        |
|                    |                                                                         |
|                    | "taskId": "dcd1280f-11d8-4a9b-997b-e4c0a69de119"                        |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
|                    | OR                                                                      |
|                    |                                                                         |
|                    | Code: 200                                                               |
|                    |                                                                         |
|                    | "message": {                                                            |
|                    |                                                                         |
|                    | "message": "AS3 declaration deleted successfully",                      |
|                    |                                                                         |
|                    | "statuscode": 200,                                                      |
|                    |                                                                         |
|                    | "taskId": "dcd1280f-11d8-4a9b-997b-e4c0a69de119"                        |
|                    |                                                                         |
|                    | "as3data": [],                                                          |
|                    |                                                                         |
|                    | "as3declaration": null                                                  |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
+--------------------+-------------------------------------------------------------------------+
| Error Response     | Code: 4XX                                                               |
|                    |                                                                         |
|                    | Content: {error: <Error Message from F5 BIG-IP}                         |
|                    |                                                                         |
+--------------------+-------------------------------------------------------------------------+
| Notes              |                                                                         |
+--------------------+-------------------------------------------------------------------------+

getfasttemplates.json
``````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Retrieve list of FAST BIG-IP templates + custom template "service-discovery"                               |
+====================+============================================================================================================+
| URL                | /getfasttemplates.json                                                                                     |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"                                        |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "10.107.0.23:443"                                                                                   |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | Content: <FAST/AS3 declaration JSON>                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Response   | [                                                                                                          |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "name": "bigip-fast-templates/dns",                                                                        |
|                    |                                                                                                            |
|                    | "present": true                                                                                            |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "name": "bigip-fast-templates/http",                                                                       |
|                    |                                                                                                            |
|                    | "present": true                                                                                            |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "name": "service-discovery/http",                                                                          |
|                    |                                                                                                            |
|                    | "present": true                                                                                            |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              | This is added in the Postman collection.                                                                   |
+--------------------+------------------------------------------------------------------------------------------------------------+

getfasttemplateschema.json
```````````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Retrieve the parameter schema for the specified template                                                   |
+====================+============================================================================================================+
| URL                | /getfasttemplateschema.json                                                                                |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                       |
|                    |                                                                                                            |
|                    | "name":"<FAST template name>"                                                                              |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "10.107.0.22:443",                                                                                  |
|                    |                                                                                                            |
|                    | "name":"bigip-fast-templates/http"                                                                         |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | Content: <FAST/AS3 declaration JSON>                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                          |
|                    |                                                                                                            |
|                    | "properties": {                                                                                            |
|                    |                                                                                                            |
|                    | "testTenant": {                                                                                            |
|                    |                                                                                                            |
|                    | "acceleration_profile_name": {                                                                             |
|                    |                                                                                                            |
|                    | "default": "/Common/webacceleration",                                                                      |
|                    |                                                                                                            |
|                    | "description": "Select an existing BIG-IP web acceleration profile.",                                      |
|                    |                                                                                                            |
|                    | "enum": [                                                                                                  |
|                    |                                                                                                            |
|                    | "/Common/apm-enduser-if-cache",                                                                            |
|                    |                                                                                                            |
|                    | "/Common/optimized-acceleration",                                                                          |
|                    |                                                                                                            |
|                    | "/Common/optimized-caching",                                                                               |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "options": {                                                                                               |
|                    |                                                                                                            |
|                    | "dependencies": {                                                                                          |
|                    |                                                                                                            |
|                    | "enable_acceleration": true,                                                                               |
|                    |                                                                                                            |
|                    | "make_acceleration_profile": false                                                                         |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "propertyOrder": 62,                                                                                       |
|                    |                                                                                                            |
|                    | "title": "Web Acceleration Profile",                                                                       |
|                    |                                                                                                            |
|                    | "type": "string"                                                                                           |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "app_name": {                                                                                              |
|                    |                                                                                                            |
|                    | "default": "",                                                                                             |
|                    |                                                                                                            |
|                    | "description": "The *application* is the low-level grouping in an AS3 declaration. FAST deploys all        |
|                    |  configuration for a given application in a BIG-IP folder.                                                 |
|                    |                                                                                                            |
|                    | "maxLength": 255,                                                                                          |
|                    |                                                                                                            |
|                    | "minLength": 1,                                                                                            |
|                    |                                                                                                            |
|                    | "pattern": "^[A-Za-z][0-9A-Za-z_.-]*$",                                                                    |
|                    |                                                                                                            |
|                    | "propertyOrder": 1,                                                                                        |
|                    |                                                                                                            |
|                    | "title": "Application Name",                                                                               |
|                    |                                                                                                            |
|                    | "type": "string"                                                                                           |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "tenant_name":                                                                                             |
|                    |                                                                                                            |
|                    | "default": "",                                                                                             |
|                    |                                                                                                            |
|                    | "description": "The *tenant* is the high-level grouping in an AS3 declaration. FAST deploys all            |
|                    |  configuration for a given tenant in a BIG-IP partition                                                    |
|                    |                                                                                                            |
|                    | "maxLength": 255,                                                                                          |
|                    |                                                                                                            |
|                    | "minLength": 1,                                                                                            |
|                    |                                                                                                            |
|                    | "pattern": "^[A-Za-z][0-9A-Za-z_.-]*$",                                                                    |
|                    |                                                                                                            |
|                    | "propertyOrder": 0,                                                                                        |
|                    |                                                                                                            |
|                    | "title": "Tenant Name",                                                                                    |
|                    |                                                                                                            |
|                    | "type": "string"                                                                                           |
|                    |                                                                                                            |
|                    | }, ...                                                                                                     |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "required": [                                                                                              |
|                    |                                                                                                            |
|                    | "app_name",                                                                                                |
|                    |                                                                                                            |
|                    | "enable_acceleration",                                                                                     |
|                    |                                                                                                            |
|                    | "enable_compression",                                                                                      |
|                    |                                                                                                            |
|                    | "enable_multiplex",                                                                                        |
|                    |                                                                                                            |
|                    | "enable_pool",                                                                                             |
|                    |                                                                                                            |
|                    | "enable_redirect",                                                                                         |
|                    |                                                                                                            |
|                    | "enable_tls_client",                                                                                       |
|                    |                                                                                                            |
|                    | "endpoint_policy_names",                                                                                   |
|                    |                                                                                                            |
|                    | "irule_names",                                                                                             |
|                    |                                                                                                            |
|                    | "tenant_name",                                                                                             |
|                    |                                                                                                            |
|                    | "virtual_address",                                                                                         |
|                    |                                                                                                            |
|                    | "virtual_port",                                                                                            |
|                    |                                                                                                            |
|                    | "vlans_enable"                                                                                             |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "title": "HTTP Application Template",                                                                      |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "type": "object"                                                                                           |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              | This is added in the Postman collection .                                                                  |
+--------------------+------------------------------------------------------------------------------------------------------------+

updatefastdata.json
````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Create/update FAST applications/partitions                                                                 |
+====================+============================================================================================================+
| URL                | /updatefastdata.json                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                       |
|                    |                                                                                                            |
|                    | "name": "<FAST template name>",                                                                            |
|                    |                                                                                                            |
|                    | "parameters": {"<parameters>" }                                                                            |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "10.107.0.23:443"                                                                                   |
|                    |                                                                                                            |
|                    | "name": "bigip-fast-templates/http",                                                                       |
|                    |                                                                                                            |
|                    | "parameters": {                                                                                            |
|                    |                                                                                                            |
|                    | "acceleration_profile_name": "/Common/webacceleration",                                                    |
|                    |                                                                                                            |
|                    | "app_name": "app23",                                                                                       |
|                    |                                                                                                            |
|                    | "common_tcp_profile": false,                                                                               |
|                    |                                                                                                            |
|                    | "compression_profile_name": "/Common/httpcompression",                                                     |
|                    |                                                                                                            |
|                    | "enable_acceleration": true,                                                                               |
|                    |                                                                                                            |
|                    | "enable_compression": true,                                                                                |
|                    |                                                                                                            |
|                    | "enable_fallback_persistence": true,                                                                       |
|                    |                                                                                                            |
|                    | "enable_monitor": true,                                                                                    |
|                    |                                                                                                            |
|                    | "enable_multiplex": true,                                                                                  |
|                    |                                                                                                            |
|                    | "enable_persistence": true,                                                                                |
|                    |                                                                                                            |
|                    | "enable_pool": true,                                                                                       |
|                    |                                                                                                            |
|                    | "enable_redirect": true,                                                                                   |
|                    |                                                                                                            |
|                    | "enable_snat": true,                                                                                       |
|                    |                                                                                                            |
|                    | "enable_tls_client": false,                                                                                |
|                    |                                                                                                            |
|                    | "enable_tls_server": true,                                                                                 |
|                    |                                                                                                            |
|                    |                                                                                                            |
|                    | "/Common/newnode"                                                                                          |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "fallback_persistence_type": "source-address",                                                             |
|                    |                                                                                                            |
|                    | "http_profile_name": "/Common/http",                                                                       |
|                    |                                                                                                            |
|                    | "irule_names": [                                                                                           |
|                    |                                                                                                            |
|                    | "/Common/VK",                                                                                              |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "load_balancing_mode": "least-connections-member",                                                         |
|                    |                                                                                                            |
|                    | "make_acceleration_profile": true,                                                                         |
|                    |                                                                                                            |
|                    | "make_compression_profile": true,                                                                          |
|                    |                                                                                                            |
|                    | "make_http_profile": true,                                                                                 |
|                    |                                                                                                            |
|                    | "make_monitor": true,                                                                                      |
|                    |                                                                                                            |
|                    | "make_multiplex_profile": true                                                                             |
|                    |                                                                                                            |
|                    | "make_pool": true,                                                                                         |
|                    |                                                                                                            |
|                    | "make_snatpool": true,                                                                                     |
|                    |                                                                                                            |
|                    | "make_tcp_egress_profile": true,                                                                           |
|                    |                                                                                                            |
|                    | "make_tcp_ingress_profile": true,                                                                          |
|                    |                                                                                                            |
|                    | "make_tcp_profile": true,                                                                                  |
|                    |                                                                                                            |
|                    | "make_tls_client_profile": true,                                                                           |
|                    |                                                                                                            |
|                    | "make_tls_server_profile": true,                                                                           |
|                    |                                                                                                            |
|                    | "monitor_credentials": false,                                                                              |
|                    |                                                                                                            |
|                    | "monitor_expected_response": "",                                                                           |
|                    |                                                                                                            |
|                    | "monitor_interval": 30,                                                                                    |
|                    |                                                                                                            |
|                    | "monitor_name": "/Common/https",                                                                           |
|                    |                                                                                                            |
|                    | "monitor_passphrase": "",                                                                                  |
|                    |                                                                                                            |
|                    | "monitor_send_string": "GET / HTTP/1.1\\r\\nHost: example.com\\r\\nConnection: Close\\r\\n\\r\\n",         |
|                    |                                                                                                            |
|                    | "monitor_username": "",                                                                                    |
|                    |                                                                                                            |
|                    | "multiplex_profile_name": "/Common/oneconnect",                                                            |
|                    |                                                                                                            |
|                    | "persistence_type": "cookie",                                                                              |
|                    |                                                                                                            |
|                    | "pool_members": [                                                                                          |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "connectionLimit": 0,                                                                                      |
|                    |                                                                                                            |
|                    | "priorityGroup": 0,                                                                                        |
|                    |                                                                                                            |
|                    | "serverAddresses": [                                                                                       |
|                    |                                                                                                            |
|                    | "10.0.0.1"                                                                                                 |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "servicePort": 80,                                                                                         |
|                    |                                                                                                            |
|                    | "shareNodes": true                                                                                         |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "pool_name": "",                                                                                           |
|                    |                                                                                                            |
|                    | "slow_ramp_time": 300,                                                                                     |
|                    |                                                                                                            |
|                    | "snat_addresses": [                                                                                        |
|                    |                                                                                                            |
|                    | "12.23.4.3"                                                                                                |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "snat_automap": true,                                                                                      |
|                    |                                                                                                            |
|                    | "snatpool_name": "",                                                                                       |
|                    |                                                                                                            |
|                    | "tcp_egress_profile_name": "/Common/f5-tcp-progressive",                                                   |
|                    |                                                                                                            |
|                    | "tcp_egress_topology": "lan",                                                                              |
|                    |                                                                                                            |
|                    | "tcp_ingress_profile_name": "/Common/f5-tcp-progressive",                                                  |
|                    |                                                                                                            |
|                    | "tcp_ingress_topology": "wan",                                                                             |
|                    |                                                                                                            |
|                    | "tcp_profile_name": "/Common/f5-tcp-progressive",                                                          |
|                    |                                                                                                            |
|                    | "tcp_topology": "wan",                                                                                     |
|                    |                                                                                                            |
|                    | "tenant_name": "Tenant1",                                                                                  |
|                    |                                                                                                            |
|                    | "tls_cert_name": "/Common/default.crt",                                                                    |
|                    |                                                                                                            |
|                    | "tls_client_profile_name": "/Common/serverssl",                                                            |
|                    |                                                                                                            |
|                    | "tls_key_name": "/Common/default.key",                                                                     |
|                    |                                                                                                            |
|                    | "tls_server_profile_name": "/Common/clientssl",                                                            |
|                    |                                                                                                            |
|                    | "virtual_address": "198.134.3.3",                                                                          |
|                    |                                                                                                            |
|                    | "virtual_port": 443,                                                                                       |
|                    |                                                                                                            |
|                    | "vlan_names": [],                                                                                          |
|                    |                                                                                                            |
|                    | "vlans_allow": true,                                                                                       |
|                    |                                                                                                            |
|                    | "vlans_enable": false,                                                                                     |
|                    |                                                                                                            |
|                    | "x_forwarded_for": true                                                                                    |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 202                                                                                                  |
|                    |                                                                                                            |
|                    | Content: <FAST/AS3 declaration JSON>                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                          |
|                    |                                                                                                            |
|                    | "code": 202,                                                                                               |
|                    |                                                                                                            |
|                    | "message": {                                                                                               |
|                    |                                                                                                            |
|                    | "message": "BIG-IP is processing the request. Please click 'Pending Tasks' icon to check the status of the |
|                    |  pending request.",                                                                                        |
|                    |                                                                                                            |
|                    | "statuscode": 202,                                                                                         |
|                    |                                                                                                            |
|                    | "taskId": "0ec8ae38-7ea2-4b10-8523-a6c6705765ce"                                                           |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              | This is added in the Postman collection.                                                                   |
+--------------------+------------------------------------------------------------------------------------------------------------+

updatefastdata.json
````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Create/update FAST applications/partitions service-discovery template to support EP attach detach feature  |
+====================+============================================================================================================+
| URL                | /updatefastdata.json                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                       |
|                    |                                                                                                            |
|                    | "name": "<FAST template name>",                                                                            |
|                    |                                                                                                            |
|                    | "parameters": {"<parameters>" }                                                                            |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "10.107.0.23:443"                                                                                   |
|                    |                                                                                                            |
|                    | "name": "service-discovery/http",                                                                          |
|                    |                                                                                                            |
|                    | "parameters": {                                                                                            |
|                    |                                                                                                            |
|                    | "1_apic_service_discovery_tenant": "Demo",                                                                 |
|                    |                                                                                                            |
|                    | "2_apic_service_discovery_ap": "AppProfile",                                                               |
|                    |                                                                                                            |
|                    | "3_apic_service_discovery_epg": EPG-External,                                                              |
|                    |                                                                                                            |
|                    | "4_apic_service_discovery_port": 80,                                                                       |
|                    |                                                                                                            |
|                    | "acceleration_profile_name": "/Common/webacceleration",                                                    |
|                    |                                                                                                            |
|                    | "app_name": "app23",                                                                                       |
|                    |                                                                                                            |
|                    | "common_tcp_profile": false,                                                                               |
|                    |                                                                                                            |
|                    | "compression_profile_name": "/Common/httpcompression",                                                     |
|                    |                                                                                                            |
|                    | "enable_acceleration": true,                                                                               |
|                    |                                                                                                            |
|                    | "enable_compression": true,                                                                                |
|                    |                                                                                                            |
|                    | "enable_fallback_persistence": true,                                                                       |
|                    |                                                                                                            |
|                    | "enable_monitor": true,                                                                                    |
|                    |                                                                                                            |
|                    | "enable_multiplex": true,                                                                                  |
|                    |                                                                                                            |
|                    | "enable_persistence": true,                                                                                |
|                    |                                                                                                            |
|                    | "enable_pool": true,                                                                                       |
|                    |                                                                                                            |
|                    | "enable_redirect": true,                                                                                   |
|                    |                                                                                                            |
|                    | "enable_snat": true,                                                                                       |
|                    |                                                                                                            |
|                    | "enable_tls_client": false,                                                                                |
|                    |                                                                                                            |
|                    | "enable_tls_server": true,                                                                                 |
|                    |                                                                                                            |
|                    | "/Common/newnode"                                                                                          |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "fallback_persistence_type": "source-address",                                                             |
|                    |                                                                                                            |
|                    | "http_profile_name": "/Common/http",                                                                       |
|                    |                                                                                                            |
|                    | "irule_names": [                                                                                           |
|                    |                                                                                                            |
|                    | "/Common/VK",                                                                                              |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "load_balancing_mode": "least-connections-member",                                                         |
|                    |                                                                                                            |
|                    | "make_acceleration_profile": true,                                                                         |
|                    |                                                                                                            |
|                    | "make_compression_profile": true,                                                                          |
|                    |                                                                                                            |
|                    | "make_http_profile": true,                                                                                 |
|                    |                                                                                                            |
|                    | "make_monitor": true,                                                                                      |
|                    |                                                                                                            |
|                    | "make_multiplex_profile": true                                                                             |
|                    |                                                                                                            |
|                    | "make_pool": true,                                                                                         |
|                    |                                                                                                            |
|                    | "make_snatpool": true,                                                                                     |
|                    |                                                                                                            |
|                    | "make_tcp_egress_profile": true,                                                                           |
|                    |                                                                                                            |
|                    | "make_tcp_ingress_profile": true,                                                                          |
|                    |                                                                                                            |
|                    | "make_tcp_profile": true,                                                                                  |
|                    |                                                                                                            |
|                    | "make_tls_client_profile": true,                                                                           |
|                    |                                                                                                            |
|                    | "make_tls_server_profile": true,                                                                           |
|                    |                                                                                                            |
|                    | "monitor_credentials": false,                                                                              |
|                    |                                                                                                            |
|                    | "monitor_expected_response": "",                                                                           |
|                    |                                                                                                            |
|                    | "monitor_interval": 30,                                                                                    |
|                    |                                                                                                            |
|                    | "monitor_name": "/Common/https",                                                                           |
|                    |                                                                                                            |
|                    | "monitor_passphrase": "",                                                                                  |
|                    |                                                                                                            |
|                    | "monitor_send_string": "GET / HTTP/1.1\\r\\nHost: example.com\\r\\nConnection: Close\\r\\n\\r\\n",         |
|                    |                                                                                                            |
|                    | "monitor_username": "",                                                                                    |
|                    |                                                                                                            |
|                    | "multiplex_profile_name": "/Common/oneconnect",                                                            |
|                    |                                                                                                            |
|                    | "persistence_type": "cookie",                                                                              |
|                    |                                                                                                            |
|                    | "pool_members": [                                                                                          |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "connectionLimit": 0,                                                                                      |
|                    |                                                                                                            |
|                    | "priorityGroup": 0,                                                                                        |
|                    |                                                                                                            |
|                    | "serverAddresses": [                                                                                       |
|                    |                                                                                                            |
|                    | "10.0.0.1"                                                                                                 |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "servicePort": 80,                                                                                         |
|                    |                                                                                                            |
|                    | "shareNodes": true                                                                                         |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "pool_name": "",                                                                                           |
|                    |                                                                                                            |
|                    | "slow_ramp_time": 300,                                                                                     |
|                    |                                                                                                            |
|                    | "snat_addresses": [                                                                                        |
|                    |                                                                                                            |
|                    | "12.23.4.3"                                                                                                |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "snat_automap": true,                                                                                      |
|                    |                                                                                                            |
|                    | "snatpool_name": "",                                                                                       |
|                    |                                                                                                            |
|                    | "tcp_egress_profile_name": "/Common/f5-tcp-progressive",                                                   |
|                    |                                                                                                            |
|                    | "tcp_egress_topology": "lan",                                                                              |
|                    |                                                                                                            |
|                    | "tcp_ingress_profile_name": "/Common/f5-tcp-progressive",                                                  |
|                    |                                                                                                            |
|                    | "tcp_ingress_topology": "wan",                                                                             |
|                    |                                                                                                            |
|                    | "tcp_profile_name": "/Common/f5-tcp-progressive",                                                          |
|                    |                                                                                                            |
|                    | "tcp_topology": "wan",                                                                                     |
|                    |                                                                                                            |
|                    | "tenant_name": "Tenant2",                                                                                  |
|                    |                                                                                                            |
|                    | "tls_cert_name": "/Common/default.crt",                                                                    |
|                    |                                                                                                            |
|                    | "tls_client_profile_name": "/Common/serverssl",                                                            |
|                    |                                                                                                            |
|                    | "tls_key_name": "/Common/default.key",                                                                     |
|                    |                                                                                                            |
|                    | "tls_server_profile_name": "/Common/clientssl",                                                            |
|                    |                                                                                                            |
|                    | "virtual_address": "198.135.3.3",                                                                          |
|                    |                                                                                                            |
|                    | "virtual_port": 443,                                                                                       |
|                    |                                                                                                            |
|                    | "vlan_names": [],                                                                                          |
|                    |                                                                                                            |
|                    | "vlans_allow": true,                                                                                       |
|                    |                                                                                                            |
|                    | "vlans_enable": false,                                                                                     |
|                    |                                                                                                            |
|                    | "x_forwarded_for": true                                                                                    |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 202                                                                                                  |
|                    |                                                                                                            |
|                    | Content: <FAST/AS3 declaration JSON>                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                          |
|                    |                                                                                                            |
|                    | "code": 202,                                                                                               |
|                    |                                                                                                            |
|                    | "message": {                                                                                               |
|                    |                                                                                                            |
|                    | "message": "BIG-IP is processing the request. Please click 'Pending Tasks' icon to check the status of the |
|                    |  pending request.",                                                                                        |
|                    |                                                                                                            |
|                    | "statuscode": 202,                                                                                         |
|                    |                                                                                                            |
|                    | "taskId": "0ec8ae38-7ea2-4b10-8523-a6c6705765ce"                                                           |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              | This is added in the Postman collection. It supports Endpoint attach detach feature of the app using FAST. |
+--------------------+------------------------------------------------------------------------------------------------------------+


deletefastapplication.json
```````````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Deletes the specified FAST application from BIG-IP                                                         |
+====================+============================================================================================================+
| URL                | /deletefastapplication.json                                                                                |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                       |
|                    |                                                                                                            |
|                    | "partition": "<Partition Name>",                                                                           |
|                    |                                                                                                            |
|                    | "application": "<Application Name>"                                                                        |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "10.107.0.23:443",                                                                                  |
|                    |                                                                                                            |
|                    | "partition": "Tenant45",                                                                                   |
|                    |                                                                                                            |
|                    | "application": "app23"                                                                                     |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 202                                                                                                  |
|                    |                                                                                                            |
|                    | Content: <FAST/AS3 declaration JSON>                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                          |
|                    |                                                                                                            |
|                    | "code": 202,                                                                                               |
|                    |                                                                                                            |
|                    | "message": {                                                                                               |
|                    |                                                                                                            |
|                    | "message": "BIG-IP is processing the request. Please click 'Pending Tasks' icon to check the status of the |
|                    | pending request.",                                                                                         |
|                    |                                                                                                            |
|                    | "statuscode": 202,                                                                                         |
|                    |                                                                                                            |
|                    | "taskId": "0ec8ae38-7ea2-4b10-8523-a6c6705765ce"                                                           |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              | This is added in the Postman collection.                                                                   |
+--------------------+------------------------------------------------------------------------------------------------------------+

deletefastpartition.json
`````````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Delete FAST partition from BIG-IP                                                                          |
+====================+============================================================================================================+
| URL                | /deletefastpartition.json                                                                                  |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                       |
|                    |                                                                                                            |
|                    | "partition": "<Partition Name>"                                                                            |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "10.107.0.23:443",                                                                                  |
|                    |                                                                                                            |
|                    | "partition": "Tenant45"                                                                                    |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | Content: <FAST/AS3 declaration JSON>                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                          |
|                    |                                                                                                            |
|                    | "code": 200,                                                                                               |
|                    |                                                                                                            |
|                    | "message": {                                                                                               |
|                    |                                                                                                            |
|                    | "as3data": [                                                                                               |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "applications": [                                                                                          |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "application": "Application_1",                                                                            |
|                    |                                                                                                            |
|                    | "epgExistsPoolList": [],                                                                                   |
|                    |                                                                                                            |
|                    | "json": {                                                                                                  |
|                    |                                                                                                            |
|                    | "class": "Application",                                                                                    |
|                    |                                                                                                            |
|                    | "serviceMain": {                                                                                           |
|                    |                                                                                                            |
|                    | "class": "Service_HTTP",                                                                                   |
|                    |                                                                                                            |
|                    | "pool": "web_pool",                                                                                        |
|                    |                                                                                                            |
|                    | "virtualAddresses": [                                                                                      |
|                    |                                                                                                            |
|                    | "10.0.1.10"                                                                                                |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
|                    | },                                                                                                         |
|                    |                                                                                                            |
|                    | "template": "http",                                                                                        |
|                    |                                                                                                            |
|                    | "web_pool": {                                                                                              |
|                    |                                                                                                            |
|                    | "class": "Pool",                                                                                           |
|                    |                                                                                                            |
|                    | "members": [                                                                                               |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "serverAddresses": [                                                                                       |
|                    |                                                                                                            |
|                    | "192.0.1.10",                                                                                              |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "servicePort": 80                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "monitors": [                                                                                              |
|                    |                                                                                                            |
|                    | "http",                                                                                                    |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "partition": "Sample_03"                                                                                   |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ],                                                                                                         |
|                    |                                                                                                            |
|                    | "message": "Partition Tenant1 deleted successfully"                                                        |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              | This is added in the Postman collection.                                                                   |
+--------------------+------------------------------------------------------------------------------------------------------------+

createfasttemplate.json
`````````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Create and install the FAST custom template on the BIG-IP                                                  |
+====================+============================================================================================================+
| URL                | /createfasttemplate.json                                                                                   |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                       |
|                    |                                                                                                            |
|                    | "name": "<Template Name>" ,                                                                                |
|                    |                                                                                                            |
|                    | "file": "<Upload .zip template set file>"                                                                  |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "10.107.0.23:443",                                                                                  |
|                    |                                                                                                            |
|                    | "name": "custom-http-template",                                                                            |
|                    |                                                                                                            |
|                    | "file": "custom-http-template.zip"                                                                         |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | Content: <Success Message>                                                                                 |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                          |
|                    |                                                                                                            |
|                    | "code": 200,                                                                                               |
|                    |                                                                                                            |
|                    | "message": Upload and Install of the bigip-fast-templates-service-discovery template set on BIG-IP         |
|                    | 10.107.0.23 succeeded.                                                                                     |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+


createfasttemplate.json
`````````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Create and install the service-discovery template on the BIG-IP to support the EP attach detach endpoint   |
|                    | feature.                                                                                                   |
+====================+============================================================================================================+
| URL                | /createfasttemplate.json                                                                                   |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                       |
|                    |                                                                                                            |
|                    | "name": "service-discovery"                                                                                |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "10.107.0.23:443",                                                                                  |
|                    |                                                                                                            |
|                    | "name": "service-discovery"                                                                                |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | Content: <Success message>                                                                                 |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                          |
|                    |                                                                                                            |
|                    | "code": 200,                                                                                               |
|                    |                                                                                                            |
|                    | "message": Upload and Install of the service-discovery template set on BIG-IP                              |
|                    | 10.107.0.23 succeeded.                                                                                     |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+


deletefasttemplateset.json
```````````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Deletes FAST custom template set                                                                           |
+====================+============================================================================================================+
| URL                | /deletefasttemplateset.json                                                                                |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                       |
|                    |                                                                                                            |
|                    | "name": "<Template Name>",                                                                                 |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "url": "10.107.0.23:443",                                                                                  |
|                    |                                                                                                            |
|                    | "name": "bigip-fast-templates-service-discovery/http"                                                      |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | Content: <Success message>                                                                                 |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                          |
|                    |                                                                                                            |
|                    | "code": 200,                                                                                               |
|                    |                                                                                                            |
|                    | "message": bigip-fast-templates-service-discovery template set deleted successfully.                       |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+


searchendpoint.json
`````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Searches the Endpoint across logged in BIG-IPs                                                             |
+====================+============================================================================================================+
| URL                | /searchendpoint.json                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "ip": "<IP>"                                                                                               |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "ip": "101.1.1.1"                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | message:{                                                                                                  |
|                    |                                                                                                            |
|                    | [                                                                                                          |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "bigip": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                     |
|                    |                                                                                                            |
|                    | "fullpath": "<fullpath>",                                                                                  |
|                    |                                                                                                            |
|                    | "partition": "<Partition Name>",                                                                           |
|                    |                                                                                                            |
|                    | "type": "<VIP/Node>"                                                                                       |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | message:{                                                                                                  |
|                    |                                                                                                            |
|                    | [                                                                                                          |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "bigip": "10.107.0.23",                                                                                    |
|                    |                                                                                                            |
|                    | "fullpath": "/kctenant45/app23/101.1.1.1:443",                                                             |
|                    |                                                                                                            |
|                    | "partition": "tenant45",                                                                                   |
|                    |                                                                                                            |
|                    | "type": "VIP"                                                                                              |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+


searchendpoint.json
`````````````````````

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Searches the Endpoint for the specified BIG-IP                                                             |
+====================+============================================================================================================+
| URL                | /searchendpoint.json                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                       |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                          |
|                    |                                                                                                            |
|                    | "ip": "<IP>",                                                                                              |
|                    |                                                                                                            |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"                                        |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "ip": "101.1.1.1",                                                                                         |
|                    |                                                                                                            |
|                    | "url": "10.107.0.23"                                                                                       |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | message:{                                                                                                  |
|                    |                                                                                                            |
|                    | [                                                                                                          |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "fullpath": "<fullpath>",                                                                                  |
|                    |                                                                                                            |
|                    | "partition": "<Partition Name>",                                                                           |
|                    |                                                                                                            |
|                    |  "type": "<VIP/Node>"                                                                                      |
|                    |                                                                                                            |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                  |
|                    |                                                                                                            |
|                    | message: {                                                                                                 |
|                    |                                                                                                            |
|                    | [                                                                                                          |
|                    |                                                                                                            |
|                    | {                                                                                                          |
|                    |                                                                                                            |
|                    | "fullpath": "/kctenant45/app23/101.1.1.1:443",                                                             |
|                    |                                                                                                            |
|                    | "partition": "tenant45",                                                                                   |
|                    |                                                                                                            |
|                    |  "type": "VIP"                                                                                             |
|                    | }                                                                                                          |
|                    |                                                                                                            |
|                    | ]                                                                                                          |
|                    |                                                                                                            |
|                    | }                                                                                                          |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                  |
|                    |                                                                                                            |
|                    | Content: {error: Bad request}                                                                              |
+--------------------+------------------------------------------------------------------------------------------------------------+
| Notes              |                                                                                                            |
+--------------------+------------------------------------------------------------------------------------------------------------+


Dynamic Endpoint Attach Detach APIs
-----------------------------------

getepginfo.json
```````````````
+--------------------+-------------------------------------------------------------------------+
| Title              | Get endpoint group or EPG information from APIC                         |
+====================+=========================================================================+
| URL                | /getepginfo.json                                                        |
+--------------------+-------------------------------------------------------------------------+
| Method             | GET                                                                     |
+--------------------+-------------------------------------------------------------------------+
| Success Response   | "code": 200,                                                            |
|                    |                                                                         |
|                    | "content"                                                               |
|                    |                                                                         |
|                    | {                                                                       |
|                    |                                                                         |
|                    | "<tenant name>": {                                                      |
|                    |                                                                         |
|                    | "<Application Profile 1>": [                                            |
|                    |                                                                         |
|                    | {                                                                       |
|                    |                                                                         |
|                    | "dn": "<Dn>",                                                           |
|                    |                                                                         |
|                    | "name": "<Endpoint group name or EPG>"                                  |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
|                    | ],                                                                      |
|                    |                                                                         |
|                    | "<Application Profile 2>": [                                            |
|                    |                                                                         |
|                    | {                                                                       |
|                    |                                                                         |
|                    | "dn": "<Dn>",                                                           |
|                    |                                                                         |
|                    | "name": "<Endpoint group name or EPG>"                                  |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
|                    | ]                                                                       |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
+--------------------+-------------------------------------------------------------------------+
| Success Response   | "code": 200,                                                            |
|                    |                                                                         |
|                    | "content"                                                               |
|                    |                                                                         |
|                    | {                                                                       |
|                    |                                                                         |
|                    | "Demo": {                                                               |
|                    |                                                                         |
|                    | "3-Tier-Arch": [                                                        |
|                    |                                                                         |
|                    | {                                                                       |
|                    |                                                                         |
|                    | "dn": "uni/tn-Demo/ap-3-Tier-Arch/epg-Front-EndUI",                     |
|                    |                                                                         |
|                    | "name": "Front-EndUI"                                                   |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
|                    | ],                                                                      |
|                    |                                                                         |
|                    | "AppProfile": [                                                         |
|                    |                                                                         |
|                    | {                                                                       |
|                    |                                                                         |
|                    | "dn": "uni/tn-Demo/ap-AppProfile/epg-test",                             |
|                    |                                                                         |
|                    | "name": "test"                                                          |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
|                    | ]                                                                       |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
|                    | }                                                                       |
|                    |                                                                         |
+--------------------+-------------------------------------------------------------------------+
| Error Response     | Code: 400                                                               |
|                    |                                                                         |
|                    | Content: {error: Bad request}                                           |
+--------------------+-------------------------------------------------------------------------+
| Notes              |                                                                         |
+--------------------+-------------------------------------------------------------------------+


getbigipendpoints.json
``````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Get Dynamic Endpoints from BIG-IP Service Discovery for an AS3 app    |
+====================+=======================================================================+
| URL                | /getbigipendpoints.json                                               |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",  |
|                    |                                                                       |
|                    | "partition": "<partition_name>",                                      |
|                    |                                                                       |
|                    | "subpath": "<application_name on BIG-IP>",                            |
|                    |                                                                       |
|                    | "pool": "<Pool_Name>"                                                 |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.21:443",                                             |
|                    |                                                                       |
|                    | "partition": "testPart",                                              |
|                    |                                                                       |
|                    | "subpath": "testApp",                                                 |
|                    |                                                                       |
|                    | "pool": "web_pool"                                                    |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | "code": 200,                                                          |
|                    |                                                                       |
|                    | "content"                                                             |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | [                                                                     |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "ip": "10.168.18.100",                                                |
|                    |                                                                       |
|                    | "id": "/partition1/10.168.18.100"                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+



syncepgmappings.json
`````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | EPG mappings sync from APIC to BIG-IP                                 |
+====================+=======================================================================+
| URL                | /syncepgmappings.json                                                 |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",  |
|                    |                                                                       |
|                    | "tenant": "<tenant_name>",                                            |
|                    |                                                                       |
|                    | "application": "<application_profile_name on APIC>",                  |
|                    |                                                                       |
|                    | "epg": "<epg>",                                                       |
|                    |                                                                       |
|                    | "partition": "<partition_name>",                                      |
|                    |                                                                       |
|                    | "subpath": "<application_name on BIG-IP>",                            |
|                    |                                                                       |
|                    | "pool": "<Pool_Name>"                                                 |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.21:443",                                             |
|                    |                                                                       |
|                    | "tenant": "Demo",                                                     |
|                    |                                                                       |
|                    | "application": "AppProfile",                                          |
|                    |                                                                       |
|                    | "epg": "EPG-Internal",                                                |
|                    |                                                                       |
|                    | "partition": "testPart",                                              |
|                    |                                                                       |
|                    | "subpath": "testApp",                                                 |
|                    |                                                                       |
|                    | "pool": "web_pool"                                                    |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | {                                                                     |
|                    |                                                                       |
|                    | "code": 200,                                                          |
|                    |                                                                       |
|                    | "message": "EPG mappings sync from APIC to BIG-IP successful"         |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+


L2-L3 Stitching APIs
--------------------

getldevs.json
`````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Gets list of L4-L7 devices of type ADC (Load balancer) from APIC      |
+====================+=======================================================================+
| URL                | /getldevs.json                                                        |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url":"10.107.0.22:443"                                               |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | Code: 200                                                             |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | [                                                                     |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "dn": "uni/tn-Demo/lDevVip-Demo-LogicalDevice-BIGIP23",               |
|                    |                                                                       |
|                    | "name": "Demo-LogicalDevice-BIGIP23",                                 |
|                    |                                                                       |
|                    | "svcType": "ADC",                                                     |
|                    |                                                                       |
|                    | "parentDn": "uni/tn-Demo",                                            |
|                    |                                                                       |
|                    | "devtype": "PHYSICAL",                                                |
|                    |                                                                       |
|                    | "tenant": "Demo"                                                      |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "dn": "uni/tn-f5-gs/lDevVip-f5-gsldev",                               |
|                    |                                                                       |
|                    | "name": "f5-gsldev",                                                  |
|                    |                                                                       |
|                    | "svcType": "ADC",                                                     |
|                    |                                                                       |
|                    | "parentDn": "uni/tn-f5-gs",                                           |
|                    |                                                                       |
|                    | "devtype": "PHYSICAL",                                                |
|                    |                                                                       |
|                    | "tenant": "f5-gs"                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

getldevinfo.json
````````````````

+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets Logical Device (L4-L7 device) information for the specified Logical Device (Distinguished Name of Logical Device required)                                             |
+====================+=============================================================================================================================================================================+
| URL                | /getldevinfo.json                                                                                                                                                           |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                                        |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "ldev": "<Logical Device Dn>",                                                                                                                                              |
|                    |                                                                                                                                                                             |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"                                                                                                         |
|                    |                                                                                                                                                                             |
|                    | }                                                                                                                                                                           |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "ldev": "uni/tn-f5-gs/lDevVip-f5-gsldev",                                                                                                                                   |
|                    |                                                                                                                                                                             |
|                    | "url":"10.107.0.22:443"                                                                                                                                                     |
|                    |                                                                                                                                                                             |
|                    | }                                                                                                                                                                           |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                                                                   |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "cdevs": [                                                                                                                                                                  |
|                    |                                                                                                                                                                             |
|                    | {                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "interfaces": [                                                                                                                                                             |
|                    |                                                                                                                                                                             |
|                    | {                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "path": "Pod-1/Node-101/eth1/1",                                                                                                                                            |
|                    |                                                                                                                                                                             |
|                    | "name": "internal"                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | },                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | {                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "path": "Pod-1/Node-101/eth1/2",                                                                                                                                            |
|                    |                                                                                                                                                                             |
|                    | "name": "external"                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | }                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | ],                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "vmName": "",                                                                                                                                                               |
|                    |                                                                                                                                                                             |
|                    | "name": "Device1",                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "vcenterName": ""                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | }                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | ],                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "svctype": "ADC",                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "devtype": "PHYSICAL",                                                                                                                                                      |
|                    |                                                                                                                                                                             |
|                    | "vlans": [                                                                                                                                                                  |
|                    |                                                                                                                                                                             |
|                    | {                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "lif": "uni/tn-f5-gs/lDevVip-f5-gsldev/lIf-External",                                                                                                                       |
|                    |                                                                                                                                                                             |
|                    | "disableConfig": {                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "disable": false,                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "ldev": null,                                                                                                                                                               |
|                    |                                                                                                                                                                             |
|                    | "tenant": null                                                                                                                                                              |
|                    |                                                                                                                                                                             |
|                    | },                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "appinfo": {                                                                                                                                                                |
|                    |                                                                                                                                                                             |
|                    | "lif": "uni/tn-f5-gs/lDevVip-f5-gsldev/lIf-External",                                                                                                                       |
|                    |                                                                                                                                                                             |
|                    | "name": "apic-vlan-8ac36350",                                                                                                                                               |
|                    |                                                                                                                                                                             |
|                    | "interfaces": [                                                                                                                                                             |
|                    |                                                                                                                                                                             |
|                    | {                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "tagged": "tagged",                                                                                                                                                         |
|                    |                                                                                                                                                                             |
|                    | "name": "1.1"                                                                                                                                                               |
|                    |                                                                                                                                                                             |
|                    | }                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | ],                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "bigip": "10.107.0.22:443",                                                                                                                                                 |
|                    |                                                                                                                                                                             |
|                    | "tag": 300,                                                                                                                                                                 |
|                    |                                                                                                                                                                             |
|                    | "lIfCtxDn": null,                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "selfips": []                                                                                                                                                               |
|                    |                                                                                                                                                                             |
|                    | },                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "insync": true,                                                                                                                                                             |
|                    |                                                                                                                                                                             |
|                    | "deployed": true,                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "encap": "vlan-300",                                                                                                                                                        |
|                    |                                                                                                                                                                             |
|                    | "lIfCtxDn": null,                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "lifName": "External"                                                                                                                                                       |
|                    |                                                                                                                                                                             |
|                    | },                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | {                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "lif": "uni/tn-f5-gs/lDevVip-f5-gsldev/lIf-Internal",                                                                                                                       |
|                    |                                                                                                                                                                             |
|                    | "disableConfig": {                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "disable": false,                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "ldev": null,                                                                                                                                                               |
|                    |                                                                                                                                                                             |
|                    | "tenant": null                                                                                                                                                              |
|                    |                                                                                                                                                                             |
|                    | },                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "appinfo": {                                                                                                                                                                |
|                    |                                                                                                                                                                             |
|                    | "lif": "uni/tn-f5-gs/lDevVip-f5-gsldev/lIf-Internal",                                                                                                                       |
|                    |                                                                                                                                                                             |
|                    | "name": "apic-vlan-b858de1d",                                                                                                                                               |
|                    |                                                                                                                                                                             |
|                    | "interfaces": [                                                                                                                                                             |
|                    |                                                                                                                                                                             |
|                    | {                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "tagged": "tagged",                                                                                                                                                         |
|                    |                                                                                                                                                                             |
|                    | "name": "1.1"                                                                                                                                                               |
|                    |                                                                                                                                                                             |
|                    | }                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | ],                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "bigip": "10.107.0.22:443",                                                                                                                                                 |
|                    |                                                                                                                                                                             |
|                    | "tag": 301,                                                                                                                                                                 |
|                    |                                                                                                                                                                             |
|                    | "lIfCtxDn": null,                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "selfips": []                                                                                                                                                               |
|                    |                                                                                                                                                                             |
|                    | },                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "insync": true,                                                                                                                                                             |
|                    |                                                                                                                                                                             |
|                    | "deployed": true,                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "encap": "vlan-301",                                                                                                                                                        |
|                    |                                                                                                                                                                             |
|                    | "lIfCtxDn": null,                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | "lifName": "Internal"                                                                                                                                                       |
|                    |                                                                                                                                                                             |
|                    | }                                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | ],                                                                                                                                                                          |
|                    |                                                                                                                                                                             |
|                    | "ldev": "uni/tn-f5-gs/lDevVip-f5-gsldev",                                                                                                                                   |
|                    |                                                                                                                                                                             |
|                    | "tenant": "f5-gs"                                                                                                                                                           |
|                    |                                                                                                                                                                             |
|                    | }                                                                                                                                                                           |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                                                                                   |
|                    |                                                                                                                                                                             |
|                    | Content: {error: Bad request}                                                                                                                                               |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes              | See *Input Parameters* section for ldev input parameter                                                                                                                     |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



getinterfaces.json
``````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Gets available interfaces from a BIG-IP device                        |
+====================+=======================================================================+
| URL                | /getinterfaces.json                                                   |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.22:8443"                                             |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | Content:                                                              |
|                    |                                                                       |
|                    | [                                                                     |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "status": "<status 1>",                                               |
|                    |                                                                       |
|                    | "name": "<name 1>"                                                    |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "status": "<status 2>",                                               |
|                    |                                                                       |
|                    | "name": "<name 2>"                                                    |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | [                                                                     |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "status": "UP",                                                       |
|                    |                                                                       |
|                    | "name": "1.1"                                                         |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "status": "UP",                                                       |
|                    |                                                                       |
|                    | "name": "1.2"                                                         |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "status": "UP",                                                       |
|                    |                                                                       |
|                    | "name": "1.3"                                                         |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

getportlockdown.json
````````````````````

+--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets port lockdown options from a BIG-IP device                                                                                                                                                 |
+====================+=================================================================================================================================================================================================+
| URL                | /getportlockdown.json                                                                                                                                                                           |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                                                            |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                                                                                                               |
|                    |                                                                                                                                                                                                 |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"                                                                                                                             |
|                    |                                                                                                                                                                                                 |
|                    | }                                                                                                                                                                                               |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                                                               |
|                    |                                                                                                                                                                                                 |
|                    | "url":"10.107.0.22:443"                                                                                                                                                                         |
|                    |                                                                                                                                                                                                 |
|                    | }                                                                                                                                                                                               |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                                                                                       |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Response   | {                                                                                                                                                                                               |
|                    |                                                                                                                                                                                                 |
|                    | "specialprotocols": [                                                                                                                                                                           |
|                    |                                                                                                                                                                                                 |
|                    | {                                                                                                                                                                                               |
|                    |                                                                                                                                                                                                 |
|                    | "name": "all",                                                                                                                                                                                  |
|                    |                                                                                                                                                                                                 |
|                    | "desc": "Allow All"                                                                                                                                                                             |
|                    |                                                                                                                                                                                                 |
|                    | },                                                                                                                                                                                              |
|                    |                                                                                                                                                                                                 |
|                    | {                                                                                                                                                                                               |
|                    |                                                                                                                                                                                                 |
|                    | "name": "none",                                                                                                                                                                                 |
|                    |                                                                                                                                                                                                 |
|                    | "desc": "Allow None"                                                                                                                                                                            |
|                    |                                                                                                                                                                                                 |
|                    | },                                                                                                                                                                                              |
|                    |                                                                                                                                                                                                 |
|                    | {                                                                                                                                                                                               |
|                    |                                                                                                                                                                                                 |
|                    | "name": "default",                                                                                                                                                                              |
|                    |                                                                                                                                                                                                 |
|                    | "desc": "Allow Default"                                                                                                                                                                         |
|                    |                                                                                                                                                                                                 |
|                    | }                                                                                                                                                                                               |
|                    |                                                                                                                                                                                                 |
|                    | ],                                                                                                                                                                                              |
|                    |                                                                                                                                                                                                 |
|                    | "ports": [                                                                                                                                                                                      |
|                    |                                                                                                                                                                                                 |
|                    | 1,                                                                                                                                                                                              |
|                    |                                                                                                                                                                                                 |
|                    | 65535                                                                                                                                                                                           |
|                    |                                                                                                                                                                                                 |
|                    | ],                                                                                                                                                                                              |
|                    |                                                                                                                                                                                                 |
|                    | "allowedprotocols": [                                                                                                                                                                           |
|                    |                                                                                                                                                                                                 |
|                    | "eigrp",                                                                                                                                                                                        |
|                    |                                                                                                                                                                                                 |
|                    | "egp",                                                                                                                                                                                          |
|                    |                                                                                                                                                                                                 |
|                    | "gre",                                                                                                                                                                                          |
|                    |                                                                                                                                                                                                 |
|                    | "icmp",                                                                                                                                                                                         |
|                    |                                                                                                                                                                                                 |
|                    | "igmp",                                                                                                                                                                                         |
|                    |                                                                                                                                                                                                 |
|                    | "igp",                                                                                                                                                                                          |
|                    |                                                                                                                                                                                                 |
|                    | "ipip",                                                                                                                                                                                         |
|                    |                                                                                                                                                                                                 |
|                    | "l2tp",                                                                                                                                                                                         |
|                    |                                                                                                                                                                                                 |
|                    | "ospf",                                                                                                                                                                                         |
|                    |                                                                                                                                                                                                 |
|                    | "pim",                                                                                                                                                                                          |
|                    |                                                                                                                                                                                                 |
|                    | "tcp",                                                                                                                                                                                          |
|                    |                                                                                                                                                                                                 |
|                    | "udp"                                                                                                                                                                                           |
|                    |                                                                                                                                                                                                 |
|                    | ]                                                                                                                                                                                               |
|                    |                                                                                                                                                                                                 |
|                    | }                                                                                                                                                                                               |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                                                                                                       |
|                    |                                                                                                                                                                                                 |
|                    | Content: {error: Bad request}                                                                                                                                                                   |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes              | Even though this API is available, the application is using only the special protocols Allow All, Allow None and Allow Default, and other protocols are not supported by F5 ACI ServiceCenter   |
+--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

gettrafficgroups.json
`````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Gets available traffic groups from a BIG-IP device                    |
+====================+=======================================================================+
| URL                | /gettrafficgroups.json                                                |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url":"10.107.0.22:443"                                               |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | Content:                                                              |
|                    |                                                                       |
|                    | [                                                                     |
|                    |                                                                       |
|                    | "<traffic\_group\_name1>",                                            |
|                    |                                                                       |
|                    | "<traffic\_group\_name2>"                                             |
|                    |                                                                       |
|                    | ]                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | [                                                                     |
|                    |                                                                       |
|                    | "traffic-group-1",                                                    |
|                    |                                                                       |
|                    | "traffic-group-local-only"                                            |
|                    |                                                                       |
|                    | ]                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

createbigipvlans.json
`````````````````````

+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title                        | Creates VLANs on a BIG-IP device                                                                                                                                                           |
+==============================+============================================================================================================================================================================================+
| URL                          | /createbigipvlans.json                                                                                                                                                                     |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method                       | POST                                                                                                                                                                                       |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request (PHYSICAL)   | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "10.107.0.22:443",                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "uni/tn-f5-gs/lDevVip-f5-gsldev",                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "PHYSICAL",                                                                                                                                                                     |
|                              |                                                                                                                                                                                            |
|                              | "vlans": [                                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "lif": "uni/tn-f5-gs/lDevVip-f5-gsldev/lIf-External",                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-vlan-8ac36350",                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": null,                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "tag": 300,                                                                                                                                                                                |
|                              |                                                                                                                                                                                            |
|                              | "interfaces": [                                                                                                                                                                            |
|                              |                                                                                                                                                                                            |
|                              | "1.1"                                                                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | ],                                                                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | "selfips": [                                                                                                                                                                               |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "address": "192.198.4.4",                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "netmask": "255.255.255.0",                                                                                                                                                                |
|                              |                                                                                                                                                                                            |
|                              | "traffic\_group": "traffic-group-local-only",                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "allow\_service": "none"                                                                                                                                                                   |
|                              |                                                                                                                                                                                            |
|                              | },                                                                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "address": "192.198.4.9",                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "netmask": "255.255.255.0",                                                                                                                                                                |
|                              |                                                                                                                                                                                            |
|                              | "traffic\_group": "traffic-group-local-only",                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "allow\_service": "all"                                                                                                                                                                    |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | ]                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | ]                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request (VIRTUAL)    | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "10.107.0.151:443",                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "uni/tn-f5-gs/lDevVip-VE-151",                                                                                                                                                     |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "VIRTUAL",                                                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "vlans": [                                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "lif": "uni/tn-f5-gs/lDevVip-VE-151/lIf-Internal",                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | "name": "",                                                                                                                                                                                |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": "uni/tn-f5-gs/GraphInst\_C-[uni/tn-f5-gs/brc-ve151-ctx]-G-[uni/tn-f5-gs/AbsGraph-VE-151]-S-[uni/tn-f5-gs]/NodeInst-N1/LegVNode-0/EPgDef-provider",                             |
|                              |                                                                                                                                                                                            |
|                              | "tag": "375",                                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "interfaces": [                                                                                                                                                                            |
|                              |                                                                                                                                                                                            |
|                              | "1.1"                                                                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | ],                                                                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | "selfips": [                                                                                                                                                                               |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "address": "192.168.14.201",                                                                                                                                                               |
|                              |                                                                                                                                                                                            |
|                              | "netmask": "255.255.255.0",                                                                                                                                                                |
|                              |                                                                                                                                                                                            |
|                              | "traffic\_group": "traffic-group-local-only",                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "allow\_service": "all"                                                                                                                                                                    |
|                              |                                                                                                                                                                                            |
|                              | },                                                                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "address": "192.168.14.202",                                                                                                                                                               |
|                              |                                                                                                                                                                                            |
|                              | "netmask": "255.255.255.0",                                                                                                                                                                |
|                              |                                                                                                                                                                                            |
|                              | "traffic\_group": "traffic-group-local-only",                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "allow\_service": "all"                                                                                                                                                                    |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | ]                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | ]                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response             | Code: 200                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: {message: Created vlans successfully}                                                                                                                                             |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response               | Code: 400                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: {error: Bad request}                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | Code: 4XX                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: {error: <Error Message from F5 BIG-IP>}                                                                                                                                           |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes                        | See *Input Parameters* section for ldev, lif, lICtxDn input parameters                                                                                                                     |                                                                
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

deletebigipselfips.json
```````````````````````

+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title                        | Deletes Self IPs from a BIG-IP device                                                                                                                                                      |
+==============================+============================================================================================================================================================================================+
| URL                          | /deletebigipselfips.json                                                                                                                                                                   |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method                       | POST                                                                                                                                                                                       |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body                 | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                                                                                       |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "<ldev\_dn>",                                                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "<device\_type>",                                                                                                                                                               |
|                              |                                                                                                                                                                                            |
|                              | "vlans": []                                                                                                                                                                                |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request (PHYSICAL)   | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "10.107.0.22:443",                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "uni/tn-f5-gs/lDevVip-f5-gsldev",                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "PHYSICAL",                                                                                                                                                                     |
|                              |                                                                                                                                                                                            |
|                              | "vlans": [                                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "lif": "uni/tn-f5-gs/lDevVip-f5-gsldev/lIf-External",                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-vlan-8ac36350",                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": null,                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "selfips": [                                                                                                                                                                               |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-selfip-192.198.4.8"                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | ]                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | ]                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request (VIRTUAL)    | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "10.107.0.151:443",                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "uni/tn-f5-gs/lDevVip-VE-151",                                                                                                                                                     |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "VIRTUAL",                                                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "vlans": [                                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "lif": "uni/tn-f5-gs/lDevVip-VE-151/lIf-Internal",                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-vlan-f69ac7e0",                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": "uni/tn-f5-gs/GraphInst\_C-[uni/tn-f5-gs/brc-ve151-ctx]-G-[uni/tn-f5-gs/AbsGraph-VE-151]-S-[uni/tn-f5-gs]/NodeInst-N1/LegVNode-0/EPgDef-provider",                             |
|                              |                                                                                                                                                                                            |
|                              | "selfips": [                                                                                                                                                                               |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-selfip-192.168.14.202"                                                                                                                                                       |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | ]                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | ]                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response             | Code: 200                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: "Deleted Self IPs successfully"                                                                                                                                                   |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response               | Code: 400                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: {error: Bad request}                                                                                                                                                              |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes                        | See *Input Parameters* section for ldev, lif, lICtxDn input parameters                                                                                                                     |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

deletebigipvlans.json
`````````````````````

+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title                        | Deletes VLANs from a BIG-IP device                                                                                                                                                         |
+==============================+============================================================================================================================================================================================+
| URL                          | /deletebigipvlans.json                                                                                                                                                                     |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method                       | POST                                                                                                                                                                                       |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request (PHYSICAL)   | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "10.107.0.22:443",                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "uni/tn-Demo/lDevVip-SA-BIGIPPhy-10500-10.107.0.22",                                                                                                                               |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "PHYSICAL",                                                                                                                                                                     |
|                              |                                                                                                                                                                                            |
|                              | "vlans": [                                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "lif": "uni/tn-Demo/lDevVip-SA-BIGIPPhy-10500-10.107.0.22/lIf-External\_123",                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-vlan-e736a66f",                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": null                                                                                                                                                                           |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | ]                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request (VIRTUAL)    | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "10.107.0.151:443",                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "uni/tn-f5-gs/lDevVip-VE-151",                                                                                                                                                     |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "VIRTUAL",                                                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "vlans": [                                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "lif": "uni/tn-f5-gs/lDevVip-VE-151/lIf-Internal",                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-vlan-f69ac7e0",                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": "uni/tn-f5-gs/GraphInst\_C-[uni/tn-f5-gs/brc-ve151-ctx]-G-[uni/tn-f5-gs/AbsGraph-VE-151]-S-[uni/tn-f5-gs]/NodeInst-N1/LegVNode-0/EPgDef-provider"                              |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | ]                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response             | Code : 200                                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | Content : "Deleted VLANs successfully"                                                                                                                                                     |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response               | Code: 400                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: {error: Bad request}                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | Code: 4XX                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: {error: <Error Message from F5 BIG-IP>}                                                                                                                                           |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes                        | See *Input Parameters* section for ldev, lif, lICtxDn input parameters                                                                                                                     |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

vlansynctobigip.json
````````````````````

+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title                        | Synchronizes VLAN information for a specific VLAN from the F5 ACI ServiceCenter database to a BIG-IP Device                                                                                |
+==============================+============================================================================================================================================================================================+
| URL                          | /vlansynctobigip.json                                                                                                                                                                      |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method                       | POST                                                                                                                                                                                       |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body                 | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | " url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "<ldev dn>",                                                                                                                                                                       |
|                              |                                                                                                                                                                                            |
|                              | "lif": "<lif dn>",                                                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | "name": "<name>",                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": null,                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "<device\_type>"                                                                                                                                                                |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request (PHYSICAL)   | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "10.107.0.22:443",                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "uni/tn-f5-gs/lDevVip-f5-gsldev",                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "lif": "uni/tn-f5-gs/lDevVip-f5-gsldev/lIf-External",                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "PHYSICAL",                                                                                                                                                                     |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-vlan-8ac36350",                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": null                                                                                                                                                                           |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request (VIRTUAL)    | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "10.107.0.151:443",                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "uni/tn-f5-gs/lDevVip-VE-151",                                                                                                                                                     |
|                              |                                                                                                                                                                                            |
|                              | "lif": "uni/tn-f5-gs/lDevVip-VE-151/lIf-Internal",                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "VIRTUAL",                                                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-vlan-f69ac7e0",                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": "uni/tn-f5-gs/GraphInst\_C-[uni/tn-f5-gs/brc-ve151-ctx]-G-[uni/tn-f5-gs/AbsGraph-VE-151]-S-[uni/tn-f5-gs]/NodeInst-N1/LegVNode-0/EPgDef-provider"                              |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response             | Code: 200                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: "Vlan sync from App to BIG-IP successful"                                                                                                                                         |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response               | Code: 400                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: {error: Bad request}                                                                                                                                                              |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes                        | See *Input Parameters* section for ldev, lif, lICtxDn input parameters                                                                                                                     |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

vlansynctodb.json
`````````````````

+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title                        | Synchronizes VLAN information for a specific VLAN from a BIG-IP Device to the F5 ACI ServiceCenter database                                                                                |
+==============================+============================================================================================================================================================================================+
| URL                          | /vlansynctodb.json                                                                                                                                                                         |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method                       | POST                                                                                                                                                                                       |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body                 | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                                                                                       |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "<ldev dn>",                                                                                                                                                                       |
|                              |                                                                                                                                                                                            |
|                              | "lif": "<lif dn>",                                                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | "name": "<vlan\_name>",                                                                                                                                                                    |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": null,                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "<device\_type>"                                                                                                                                                                |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request (PHYSICAL)   | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "10.107.0.22:443",                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "uni/tn-f5-gs/lDevVip-f5-gsldev",                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | "lif": "uni/tn-f5-gs/lDevVip-f5-gsldev/lIf-External",                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "PHYSICAL",                                                                                                                                                                     |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-vlan-8ac36350",                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": null                                                                                                                                                                           |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request (VIRTUAL)    | {                                                                                                                                                                                          |
|                              |                                                                                                                                                                                            |
|                              | "url": "10.107.0.151:443",                                                                                                                                                                 |
|                              |                                                                                                                                                                                            |
|                              | "ldev": "uni/tn-f5-gs/lDevVip-VE-151",                                                                                                                                                     |
|                              |                                                                                                                                                                                            |
|                              | "lif": "uni/tn-f5-gs/lDevVip-VE-151/lIf-Internal",                                                                                                                                         |
|                              |                                                                                                                                                                                            |
|                              | "devtype": "VIRTUAL",                                                                                                                                                                      |
|                              |                                                                                                                                                                                            |
|                              | "name": "apic-vlan-f69ac7e0",                                                                                                                                                              |
|                              |                                                                                                                                                                                            |
|                              | "lIfCtxDn": "uni/tn-f5-gs/GraphInst\_C-[uni/tn-f5-gs/brc-ve151-ctx]-G-[uni/tn-f5-gs/AbsGraph-VE-151]-S-[uni/tn-f5-gs]/NodeInst-N1/LegVNode-0/EPgDef-provider"                              |
|                              |                                                                                                                                                                                            |
|                              | }                                                                                                                                                                                          |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response             | Code: 200                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: "Vlan sync from BIG-IP to App successful"                                                                                                                                         |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response               | Code: 400                                                                                                                                                                                  |
|                              |                                                                                                                                                                                            |
|                              | Content: {error: Bad request}                                                                                                                                                              |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes                        | See *Input Parameters* section for ldev, lif, lICtxDn input parameters                                                                                                                     |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

getrouteinfo.json
`````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Gets default gateway information for a BIG-IP Device                  |
+====================+=======================================================================+
| URL                | /getrouteinfo.json                                                    |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url":"10.107.0.22:443"                                               |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | Code: 200                                                             |
+--------------------+-----------------------------------------------------------------------+
| Example response   | [                                                                     |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "bigipinfo": {                                                        |
|                    |                                                                       |
|                    | "destination": "0.0.0.0",                                             |
|                    |                                                                       |
|                    | "netmask": "0.0.0.0",                                                 |
|                    |                                                                       |
|                    | "partition": "Common",                                                |
|                    |                                                                       |
|                    | "name": "apic-default-gateway",                                       |
|                    |                                                                       |
|                    | "gateway": "192.198.4.19"                                             |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "appinfo": {                                                          |
|                    |                                                                       |
|                    | "partition": "Common",                                                |
|                    |                                                                       |
|                    | "name": "apic-default-gateway",                                       |
|                    |                                                                       |
|                    | "destination": "0.0.0.0",                                             |
|                    |                                                                       |
|                    | "netmask": "0.0.0.0",                                                 |
|                    |                                                                       |
|                    | "gateway": "192.198.4.19"                                             |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "insync": true                                                        |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

createbigiproutes.json
``````````````````````

+--------------------+-----------------------------------------------------------------------------------------------------------------------------+
| Title              | Creates a default gateway on a BIG-IP device                                                                                |
+====================+=============================================================================================================================+
| URL                | /createbigiproutes.json                                                                                                     |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                        |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                           |
|                    |                                                                                                                             |
|                    | "url": "10.107.0.22:443",                                                                                                   |
|                    |                                                                                                                             |
|                    | "routes": [                                                                                                                 |
|                    |                                                                                                                             |
|                    | {                                                                                                                           |
|                    |                                                                                                                             |
|                    | "gateway": "192.198.4.19",                                                                                                  |
|                    |                                                                                                                             |
|                    | "netmask": "0.0.0.0",                                                                                                       |
|                    |                                                                                                                             |
|                    | "destination": "0.0.0.0",                                                                                                   |
|                    |                                                                                                                             |
|                    | "name": "apic-default-gateway"                                                                                              |
|                    |                                                                                                                             |
|                    | }                                                                                                                           |
|                    |                                                                                                                             |
|                    | ]                                                                                                                           |
|                    |                                                                                                                             |
|                    | }                                                                                                                           |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                   |
|                    |                                                                                                                             |
|                    | Content: "Created Default Gateway successfully"                                                                             |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                                   |
|                    |                                                                                                                             |
|                    | Content: {error: Bad request}                                                                                               |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------+
| Notes              | Currently this API only supports default gateway creation, and cannot be used to create other routes on the BIG-IP device   |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------+

deletebigiproutes.json
``````````````````````

+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Title              | Deletes the default gateway from a BIG-IP device                                                                               |
+====================+================================================================================================================================+
| URL                | /deletebigiproutes.json                                                                                                        |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                           |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                           |
|                    |                                                                                                                                |
|                    | "routes": [                                                                                                                    |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "name": "<Gateway name>"                                                                                                       |
|                    |                                                                                                                                |
|                    | }                                                                                                                              |
|                    |                                                                                                                                |
|                    | ]                                                                                                                              |
|                    |                                                                                                                                |
|                    | }                                                                                                                              |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "url": "10.107.0.22:443",                                                                                                      |
|                    |                                                                                                                                |
|                    | "routes": [                                                                                                                    |
|                    |                                                                                                                                |
|                    | {                                                                                                                              |
|                    |                                                                                                                                |
|                    | "name": "apic-default-gateway"                                                                                                 |
|                    |                                                                                                                                |
|                    | }                                                                                                                              |
|                    |                                                                                                                                |
|                    | ]                                                                                                                              |
|                    |                                                                                                                                |
|                    | }                                                                                                                              |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                      |
|                    |                                                                                                                                |
|                    | Content: "Deleted Default Gateway successfully"                                                                                |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                                      |
|                    |                                                                                                                                |
|                    | Content: {error: Bad request}                                                                                                  |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Notes              | Currently this API only supports deletion of default gateway, and cannot be used to delete other routes on the BIG-IP device   |
+--------------------+--------------------------------------------------------------------------------------------------------------------------------+

routesynctodb.json
``````````````````

+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Synchronizes default gateway information from a BIG-IP device to the F5 ACI ServiceCenter database                                                      |
+====================+=========================================================================================================================================================+
| URL                | /routesynctodb.json                                                                                                                                     |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                    |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                       |
|                    |                                                                                                                                                         |
|                    | "url": "10.107.0.22:443",                                                                                                                               |
|                    |                                                                                                                                                         |
|                    | "route": {                                                                                                                                              |
|                    |                                                                                                                                                         |
|                    | "name": "apic-default-gateway"                                                                                                                          |
|                    |                                                                                                                                                         |
|                    | }                                                                                                                                                       |
|                    |                                                                                                                                                         |
|                    | }                                                                                                                                                       |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                                               |
|                    |                                                                                                                                                         |
|                    | Content: "Route sync from BIG-IP to DB successful"                                                                                                      |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                                                               |
|                    |                                                                                                                                                         |
|                    | Content: {error: Bad request}                                                                                                                           |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes              | Currently this API only supports default gateway synchronization, and cannot be used for synchronizing any other route information from a BIG-IP device |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+

routesynctobigip.json
``````````````````````

+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Synchronizes default gateway information from the F5 ACI ServiceCenter database to a BIG-IP device                                                      |
+====================+=========================================================================================================================================================+
| URL                | /routesynctobigip.json                                                                                                                                  |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                    |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                       |
|                    |                                                                                                                                                         |
|                    | "url": "10.107.0.22:443",                                                                                                                               |
|                    |                                                                                                                                                         |
|                    | "route": {                                                                                                                                              |
|                    |                                                                                                                                                         |
|                    | "name": "apic-default-gateway"                                                                                                                          |
|                    |                                                                                                                                                         |
|                    | }                                                                                                                                                       |
|                    |                                                                                                                                                         |
|                    | }                                                                                                                                                       |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                                               |
|                    |                                                                                                                                                         |
|                    | Content: " Route sync from DB to BIG-IP successful”                                                                                                     |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 400                                                                                                                                               |
|                    |                                                                                                                                                         |
|                    | Content: {error: Bad request}                                                                                                                           |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes              | Currently this API only supports default gateway synchronization, and cannot be used for synchronizing any other route information from a BIG-IP device |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+

createbigipselfips.json
```````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Create Self IPs on a BIG-IP device with a type of **vCMP Guest**      |
+====================+=======================================================================+
| URL                | /createbigipselfips.json                                              |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",  |
|                    |                                                                       |
|                    | "vlans": [                                                            |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "name": "<Vlan Name>",                                                |
|                    |                                                                       |
|                    | "tag": <Vlan Tag>,                                                    |
|                    |                                                                       |
|                    | "selfips": [                                                          |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "address": "<IP Address>",                                            |
|                    |                                                                       |
|                    | "netmask": "<Netmask>",                                               |
|                    |                                                                       |
|                    | "traffic_group": "<traffic-group-local-only>" OR “<traffic-group-1>”, |
|                    |                                                                       |
|                    | "allow_service": "<all>" OR “<none>” OR  “<default>”                  |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |  
|                    | ]                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.47:443",                                             |
|                    |                                                                       |
|                    | "vlans": [                                                            |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "name": "apic-vlan-9bad6eb5",                                         |
|                    |                                                                       |
|                    | "tag": 25,                                                            |
|                    |                                                                       |
|                    | "selfips": [                                                          |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "address": "10.10.10.35",                                             |
|                    |                                                                       |
|                    | "netmask": "255.255.255.0",                                           |
|                    |                                                                       |
|                    | "traffic_group": "traffic-group-local-only”,                          |
|                    |                                                                       |
|                    | "allow_service": "all”                                                |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |  
|                    | ]                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | "code": 200,                                                          |
|                    |                                                                       |
|                    | "content"                                                             |
|                    |                                                                       |
|                    | {                                                                     |  
|                    |                                                                       | 
|                    | "message": "Created Self IPs successfully" ,                          |
|                    |                                                                       |
|                    | "warning":null                                                        |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              | This API is applicable only for vCMP Guest.                           |
+--------------------+-----------------------------------------------------------------------+

getvcmpguestvlans.json
``````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Get list of vCMP guests and VLANs assigned/available for each, from   |
|                    | a BIG-IP of type vCMP host                                            |
+====================+=======================================================================+
| URL                | /getvcmpguestvlans.json                                               |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.40:443"                                              |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | "code": 200,                                                          |
|                    |                                                                       |
|                    | "content"                                                             |
|                    |                                                                       |
|                    | [                                                                     |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.46",                                                 |
|                    |                                                                       |
|                    | "status": {                                                           |
|                    |                                                                       |
|                    | "state": "deployed",                                                  |
|                    |                                                                       |
|                    | "vmStatus": "running"                                                 |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "login": true,                                                        |
|                    |                                                                       |
|                    | "vlans": [                                                            |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "vlan": "apic-vlan-9bad6eb5",                                         |
|                    |                                                                       |
|                    | "tag": 25,                                                            |
|                    |                                                                       |
|                    | "partition": "Common"                                                 |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ],                                                                    |
|                    |                                                                       |
|                    | "name": "bigip40_46"                                                  |
|                    |                                                                       |
|                    | }                                                                     | 
|                    |                                                                       |
|                    | ]                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              | This API is applicable only for vCMP Host.                            |
+--------------------+-----------------------------------------------------------------------+

getvcmpvlaninfo.json
``````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Get VLAN information from a BIG-IP of type vCMP Guest                 |
+====================+=======================================================================+
| URL                | /getvcmpvlaninfo.json                                                 |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.47:443"                                              |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | "code": 200,                                                          |
|                    |                                                                       |
|                    | "content"                                                             |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "deleteselfips": [],                                                  |
|                    |                                                                       |
|                    | "vlans": [                                                            |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "bigipinfo": {                                                        |
|                    |                                                                       |
|                    | "selfips": [                                                          |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "name": "apic-selfip-10.10.35.36",                                    |
|                    |                                                                       |
|                    | "vlan": "apic-vlan-ac6aeaff",                                         |
|                    |                                                                       |
|                    | "allow_service": "all",                                               |
|                    |                                                                       |
|                    | "netmask": "255.255.255.0",                                           |
|                    |                                                                       |
|                    | "address": "10.10.35.36",                                             |
|                    |                                                                       |
|                    | "traffic_group": "traffic-group-local-only"                           |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "appinfo": {                                                          |
|                    |                                                                       |
|                    | "selfips": []                                                         |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "name": "apic-vlan-ac6aeaff",                                         |
|                    |                                                                       |
|                    | "interfaces": [],                                                     | 
|                    |                                                                       |
|                    | "insync": false,                                                      |
|                    |                                                                       |
|                    | "tag": 500                                                            |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              | This API is applicable only for vCMP Guest.                           |
+--------------------+-----------------------------------------------------------------------+

getbigipvlans.json
```````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Get list of BIG-IP VLANs                                              |
+====================+=======================================================================+
| URL                | /getbigipvlans.json                                                   |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.47:443"                                              |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | "code": 200,                                                          |
|                    |                                                                       |
|                    | "content"                                                             |
|                    |                                                                       |
|                    | [                                                                     |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "vlan": "HA",                                                         |
|                    |                                                                       |
|                    | "tag": 4093,                                                          |
|                    |                                                                       |
|                    | "partition": "Common"                                                 |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "vlan": "HA-40-41",                                                   |
|                    |                                                                       |
|                    | "tag": 4092,                                                          |
|                    |                                                                       |
|                    | "partition": "Common"                                                 |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "vlan": "apic-vlan-3dc1d93a",                                         |
|                    |                                                                       |
|                    | "tag": 25,                                                            |
|                    |                                                                       |
|                    | "partition": "Common"                                                 |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              | Currently being used only by vCMP Guests                              |
+--------------------+-----------------------------------------------------------------------+

assignvcmpguestvlans.json
``````````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Assign selected VLANs from vCMP Host to vCMP Guest F5 BIG-IPs         |
+====================+=======================================================================+
| URL                | /assignvcmpguestvlans.json                                            |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | "guest": {                                                            |
|                    |                                                                       |
|                    | "name": "<vCMP Guest name>",                                          |
|                    |                                                                       |
|                    | "url": "<vCMP Guest  IP or IP:port or hostname or hostname:port>"     |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "deleteGuestVlans": <false or true>,                                  |
|                    |                                                                       |
|                    | "vlans": [                                                            |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "vlan": "<Vlan Name>",                                                |
|                    |                                                                       |
|                    | "tag": <Vlan tag>,                                                    |
|                    |                                                                       |
|                    | "partition": "Common"                                                 |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.40:443"                                              |
|                    |                                                                       |
|                    | "guest": {                                                            |
|                    |                                                                       |
|                    | "name": "bigip40_46",                                                 |
|                    |                                                                       |
|                    | "url": "10.107.0.46"                                                  |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "deleteGuestVlans": false,                                            |
|                    |                                                                       |
|                    | "vlans": [                                                            |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "vlan": "apic-vlan-9bad6eb5",                                         |
|                    |                                                                       |
|                    | "tag": 25,                                                            |
|                    |                                                                       |
|                    | "partition": "Common"                                                 |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | "code": 200,                                                          |
|                    |                                                                       |
|                    | "content"                                                             |
|                    |                                                                       |
|                    | {                                                                     |  
|                    |                                                                       | 
|                    | "message": "Vlan assignment successful." ,                            |
|                    |                                                                       |
|                    | "warning":null                                                        |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              | This is used for assigning and unassigning VLANs. During unassignment | 
|                    | if deleteGuestVlans=true, then it deletes the VLAN from the guest     |
|                    | BIG-IP, otherwise after unassignment it keeps as it is.               |
|                    | This API is applicable only for vCMP Host.                            |
+--------------------+-----------------------------------------------------------------------+

selfipsynctobigip.json
``````````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Sync Self-IP information from DB to F5 BIG-IP (for vCMP Guests)       |
+====================+=======================================================================+
| URL                | /selfipsynctobigip.json                                               |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | "name": "<Vlan Name>"                                                 |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.47:443"                                              |
|                    |                                                                       |
|                    | "name": "apic-vlan-3dc1d93a"                                          |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | "code": 200,                                                          |
|                    |                                                                       |
|                    | "content"                                                             |
|                    |                                                                       |
|                    | {                                                                     |  
|                    |                                                                       | 
|                    | "message": "Self IP sync from App to BIG-IP successful." ,            |
|                    |                                                                       |
|                    | "warning":null                                                        |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |This API is applicable only for vCMP Guest.                            |
+--------------------+-----------------------------------------------------------------------+

selfipsynctodb.json
``````````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Sync Self-IP  information from F5 BIG-IP to DB (for vCMP Guests))     |
+====================+=======================================================================+
| URL                | /selfipsynctobigip.json                                               |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | "name": "<Vlan Name>"                                                 |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.47:443"                                              |
|                    |                                                                       |
|                    | "name": "apic-vlan-3dc1d93a"                                          |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | "code": 200,                                                          |
|                    |                                                                       |
|                    | "content": “Self IP sync from BIG-IP to App successful”               |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |This API is applicable only for vCMP Guest.                            |
+--------------------+-----------------------------------------------------------------------+



Visibility APIs
---------------

getbigippartitions.json
```````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Gets list of partitions for a BIG-IP device                           |
+====================+=======================================================================+
| URL                | /getbigippartitions.json                                              |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "18.215.80.218:8443"                                           |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Success Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | Content: [partition1, partition2, ...]                                |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | [                                                                     |
|                    |                                                                       |
|                    | "Common",                                                             |
|                    |                                                                       |
|                    | "Sample\_1",                                                          |
|                    |                                                                       |
|                    | "Tenant12"                                                            |
|                    |                                                                       |
|                    | ]                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

getvlanstats.json
`````````````````

+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets VLANs from a BIG-IP device and correlates with APIC Tenant/Application Profile/End Point Group information                                           |
+====================+===========================================================================================================================================================+
| URL                | /getvlanstats.json                                                                                                                                        |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                      |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                                                      |
|                    |                                                                                                                                                           |
|                    | "partition": "<Partition Name>",                                                                                                                          |
|                    |                                                                                                                                                           |
|                    | "download": <true/false>                                                                                                                                  |
|                    |                                                                                                                                                           | 
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "10.107.0.22:443",                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "download": false                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                                                 |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Response   | [                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "vlan": "/Common/vlan-40",                                                                                                                                |
|                    |                                                                                                                                                           |
|                    | "ldevs": [                                                                                                                                                |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "ldev": {                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "name": "10.107.0.25_ldev",                                                                                                                               |
|                    |                                                                                                                                                           |
|                    | "dn": "uni/tn-GS3_Tenant/lDevVip-10.107.0.25_ldev"                                                                                                        |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "tenant": {                                                                                                                                               |
|                    |                                                                                                                                                           |
|                    | "name": "GS3_Tenant",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "dn": "uni/tn-GS3_Tenant"                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "exportedTenants": []                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ],                                                                                                                                                        |
|                    | "epgs": [],                                                                                                                                               |
|                    |                                                                                                                                                           |
|                    | "selfips": [                                                                                                                                              |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "traffic_group": "traffic-group-1",                                                                                                                       |
|                    |                                                                                                                                                           |
|                    | "allow_service": "all",                                                                                                                                   |
|                    |                                                                                                                                                           |
|                    | "address": "192.168.1.5/24"                                                                                                                               |
|                    |                                                                                                                                                           |
|                    | "name": "192.168.1.5",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ],                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "interfaces": [                                                                                                                                           |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "name": "1.2",                                                                                                                                            |
|                    |                                                                                                                                                           |
|                    | "tagged": "tagged"                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ]                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |]                                                                                                                                                          |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 4XX                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | Content: {error: <Error Message from F5 BIG-IP}                                                                                                           |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes              | To download an Excel report for a VLAN table, set the 'download' request parameter to true.                                                               |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+

getvipstats.json
````````````````

+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets VIP:port (Virtual server) information from a BIG-IP device and correlates with APIC Tenant/Application Profile/End Point Group information           |
+====================+===========================================================================================================================================================+
| URL                | /getvipstats.json                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                      |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                                                      |
|                    |                                                                                                                                                           |
|                    | "partition": "<Partition\_Name>",                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "download": <true/false>                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "10.107.0.22:443",                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "partition": "Sample\_1",                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "download": false                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                                                 |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Response   | [                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "pool": {                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "name": "pool12",                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "status": "unknown",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "enabled": "enabled",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "fullpath": "/Common/pool12",                                                                                                                             |
|                    |                                                                                                                                                           |
|                    | "monitor": null,                                                                                                                                          |
|                    |                                                                                                                                                           |
|                    | "loadBalancingMode": "round-robin"                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "nodes": [                                                                                                                                                |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "name": "192.168.1.2",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "address": "192.168.1.2",                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "fqdn": null,                                                                                                                                             |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "fullpath": "/Common/192.168.1.2:80",                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "status": "unknown",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "enabled": "enabled"                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ],                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "vip": {                                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | "name": "192.168.1.3",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "address": "192.168.1.3:80",                                                                                                                              |
|                    |                                                                                                                                                           |
|                    | "status": "unknown",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "enabled": "enabled",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "fullpath": "/Common/192.168.1.3:80",                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "vipFullPath": "/Common/192.168.1.3",                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "ipProtocol": "tcp",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "sourceAddressTranslation": {                                                                                                                             |
|                    |                                                                                                                                                           |
|                    | "type": "none"                                                                                                                                            |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "epgs": [                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "tenant": {                                                                                                                                               |
|                    |                                                                                                                                                           |
|                    | "name": "GS3_Tenant",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "dn": "uni/tn-GS3_Tenant"                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "app": {                                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | "name": "Ap1",                                                                                                                                            |
|                    |                                                                                                                                                           |
|                    | "dn": "uni/tn-GS3_Tenant/ap-Ap1"                                                                                                                          |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "epg": {                                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | "name": "EPG11",                                                                                                                                          |
|                    |                                                                                                                                                           |
|                    | "dn": "uni/tn-GS3_Tenant/ap-Ap1/epg-EPG11"                                                                                                                |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ],                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "ldevs": [],                                                                                                                                              |
|                    |                                                                                                                                                           |
|                    | "rules": null                                                                                                                                             |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | ]                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 4XX                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | Content: {error: <Error Message from F5 BIG-IP}                                                                                                           |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes              | To download an Excel report for a VIP table, set the 'download' request parameter to true.                                                                |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+

getnodestats.json
`````````````````

+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets node information from a BIG-IP device and correlates with APIC Tenant/Application Profile/End Point Group information                                |
+====================+===========================================================================================================================================================+
| URL                | /getnodestats.json                                                                                                                                        |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                      |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                                                      |
|                    |                                                                                                                                                           |
|                    | "partition": "<Partition\_Name>",                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "download": <true/false>                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "10.107.0.22:443",                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "partition": "Sample\_1",                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "download": false                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                                                 |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
|Example Response    | [                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "node": {                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "status": "unknown",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "name": "10.0.0.112",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "address": "10.0.0.112",                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | "epgs": [                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "tenant": "gstenant",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "app": "gsApp",                                                                                                                                           |
|                    |                                                                                                                                                           |
|                    | "epg": "consumerEPG",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ],                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "enabled": "enabled"                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "pools": [                                                                                                                                                |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "virtuals": [                                                                                                                                             |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "status": "offline",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "name": "http\_vs",                                                                                                                                       |
|                    |                                                                                                                                                           |
|                    | "address": "10.0.0.156:80",                                                                                                                               |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "enabled": "enabled"                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ],                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "pool": {                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "status": "offline",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "name": "http\_pool",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "enabled": "enabled"                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ]                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "node": {                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "status": "unknown",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "name": "10.0.0.140",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "address": "10.0.0.140",                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "enabled": "enabled"                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "pools": [                                                                                                                                                |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "virtuals": [                                                                                                                                             |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "status": "offline",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "name": "http\_vs",                                                                                                                                       |
|                    |                                                                                                                                                           |
|                    | "address": "10.0.0.156:80",                                                                                                                               |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "enabled": "enabled"                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ],                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "pool": {                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "status": "offline",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "name": "http\_pool",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "enabled": "enabled"                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ]                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ]                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 4XX                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | Content: {error: <Error Message from F5 BIG-IP}                                                                                                           |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes              | To download an Excel report for a Node table, set the 'download' request parameter to true.                                                               |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+


gettelemetryconsumers.json
``````````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Get telemetry stats consumers                                         |
+====================+=======================================================================+
| URL                | gettelemetryconsumers.json                                            |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>"   |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.49:443",                                             |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | "message": {                                                          |
|                    |                                                                       |
|                    | "consumers": ["My_Pull_Consumer"],                                    |
|                    |                                                                       |
|                    | "warning": "null"                                                     |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              | If f5-telemetry package version is lower than 1.17.0, this API will   |
|                    | return a warning and will not display the statistics.                 |
+--------------------+-----------------------------------------------------------------------+

gettelemetrystats.json
```````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Retrieve stats using telemetry stream plugin                          |
+====================+=======================================================================+
| URL                | gettelemetrystats.json                                                |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",  |
|                    |                                                                       |
|                    | "consumer": "<Consumer>"                                              |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.49:443",                                             |
|                    |                                                                       |
|                    | "consumer": "My_Pull_Consumer"                                        |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | "message": {                                                          |
|                    |                                                                       |
|                    | "pools": {                                                            |
|                    |                                                                       |
|                    | "/Common/Pool1": {                                                    |
|                    |                                                                       |
|                    | "availabilityState": "available",                                     |
|                    |                                                                       |
|                    | "enabledState": "enabled",                                            |
|                    |                                                                       |
|                    | "members": {                                                          |
|                    |                                                                       |
|                    | "/Common/192.168.1.1:80": {                                           |
|                    |                                                                       |
|                    | "addr": "192.168.1.1",                                                |
|                    |                                                                       |
|                    | "availabilityState": "offline",                                       |
|                    |                                                                       |
|                    | "enabledState": "enabled",                                            |
|                    |                                                                       |
|                    | "port": 80,                                                           |
|                    |                                                                       |
|                    | "serverside.bitsIn": 0,                                               |
|                    |                                                                       |
|                    | "serverside.bitsOut": 0,                                              |
|                    |                                                                       |
|                    | "serverside.curConns": 0,                                             |
|                    |                                                                       |
|                    | "serverside.maxConns": 0,                                             |
|                    |                                                                       |
|                    | "serverside.pktsIn": 0,                                               |
|                    |                                                                       |
|                    | "serverside.pktsOut": 0,                                              |
|                    |                                                                       |
|                    | "serverside.totConns": 0,                                             |
|                    |                                                                       |
|                    | "totRequests": 0                                                      |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "name": "/Common/Pool1",                                              |
|                    |                                                                       |
|                    | "serverside.bitsIn": 8280,                                            |
|                    |                                                                       |
|                    | "serverside.bitsOut": 13800,                                          |
|                    |                                                                       |
|                    | "serverside.curConns": 0,                                             |
|                    |                                                                       |
|                    | "serverside.maxConns": 2,                                             |
|                    |                                                                       |
|                    | "serverside.pktsIn": 15,                                              |
|                    |                                                                       |
|                    | "serverside.pktsOut": 12,                                             |
|                    |                                                                       |
|                    | "serverside.totConns": 3,                                             |
|                    |                                                                       |
|                    | "tenant": "Common",                                                   |
|                    |                                                                       |
|                    | "totRequests": 3                                                      |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

getsystemconnections.json
``````````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Get System Connections of VIP/Node                                    |
+====================+=======================================================================+
| URL                | getsystemconnections.json                                             |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>" , |
|                    |                                                                       |
|                    | "ip": "<VIP/Node IP>",                                                |
|                    |                                                                       |
|                    | "type": "<vip/node>"                                                  |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.49:443",                                             |
|                    |                                                                       |
|                    | "ip": "192.168.10.100",                                               |
|                    |                                                                       |
|                    | "type": "node"                                                        |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | "message": [                                                          |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "clientDestination": any6.any,                                        |
|                    |                                                                       |
|                    | "clientSource": "any6.any",                                           |
|                    |                                                                       |
|                    | "protocol": "tcp",                                                    |
|                    |                                                                       |
|                    | "serverDestination": "192.168.10.100:80",                             |
|                    |                                                                       |
|                    | "serverSource": "192.168.10.54:48500"                                 |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              | For short lived connections, users may see the value of 'any6.any'    |
|                    | for fields clientSource and clientDestination .                       |
+--------------------+-----------------------------------------------------------------------+

getendpointdetails.json
````````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              |  Get endpoint details of VIP/Node using IP                            |
+====================+=======================================================================+
| URL                | getendpointdetails.json                                               |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",  |
|                    |                                                                       |
|                    | "ip": "<VIP/Node IP>",                                                |
|                    |                                                                       |
|                    | "partition": "<Partition>",                                           |
|                    |                                                                       |
|                    | "type": "<vip/node>"                                                  |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.49:443",                                             |
|                    |                                                                       |
|                    | "ip": "192.168.11.23",                                                |
|                    |                                                                       |
|                    | "partition": "Common",                                                |
|                    |                                                                       |
|                    | "type": "vip"                                                         |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | "message": {                                                          |
|                    |                                                                       |
|                    | "apic": [                                                             |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "encap": "vlan-320",                                                  |
|                    |                                                                       |
|                    | "epg": "Traffic_flow/LDevInst-                                        |
|                    |         [uni/tn-Traffic_flow/lDevVip-BIGIP23]-ctx-vrf1/               |
|                    |         G-BIGIP23ctxvrf1-N-BD-external-C-External",                   |
|                    |                                                                       |
|                    | "interfaces": [                                                       |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "adminSt": "Up",                                                      |
|                    |                                                                       |
|                    | "children": [],                                                       |
|                    |                                                                       |
|                    | "name": "eth1/24",                                                    |
|                    |                                                                       |
|                    | "node": "Pod-1/Node-101",                                             |
|                    |                                                                       |
|                    | "operSt": "Up",                                                       |
|                    |                                                                       |
|                    | "type": "Not Aggregated"                                              |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ],                                                                    |
|                    |                                                                       |
|                    | "mac": "00:23:E9:E8:02:85"                                            |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ],                                                                    |
|                    |                                                                       |
|                    | "bigip": [                                                            |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "interfaces": [                                                       |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "children": [],                                                       |
|                    |                                                                       |
|                    | "interface": "1.2",                                                   |
|                    |                                                                       |
|                    | "status": "UP"                                                        |
|                    |                                                                       |
|                    | }                                                                     |
|                    | ],                                                                    |
|                    |                                                                       |
|                    | "isMasquerade": false,                                                |
|                    |                                                                       |
|                    | "mac": "00:23:E9:E8:02:85",                                           |
|                    |                                                                       |
|                    | "selfips": [                                                          |
|                    |                                                                       |
|                    | {                                                                     |
|                    | "selfip": "192.168.11.59/24"                                          |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ],                                                                    |
|                    | "vlan": "320"                                                         |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    | ]                                                                     |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

getbigiplogs.json
``````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Gets logs for a VIP or Node from BIG-IP LTM module                    |
+====================+=======================================================================+
| URL                | getbigiplogs.json                                                     |
+--------------------+-----------------------------------------------------------------------+
| Method             | POST                                                                  |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",  |
|                    |                                                                       |
|                    | "from": "<From Date/Time in UTC format>",                             |
|                    |                                                                       |
|                    | "to": "<To Date/Time in UTC format>",                                 |
|                    |                                                                       |
|                    | "filters": "<Filters>"                                                |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "url": "10.107.0.159:443",                                            |
|                    |                                                                       |
|                    | "from": "null",                                                       |
|                    |                                                                       |
|                    | "to": "null",                                                         |
|                    |                                                                       |
|                    | "filters": "[]"                                                       |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | "message": {                                                          |
|                    |                                                                       |
|                    | "logs":                                                               |
|                    |                                                                       |
|                    | "ltm 2021-01-04T04:26:38Z err ve159-bigip.lab tmsh[504]: 01420006:3:  |
|                    |                                                                       |
|                    | 01020036:3: The requested pool(/BIG_IPendpoint/Test2/svc_pool) was    |
|                    |                                                                       |
|                    | not found.\n",                                                        |
|                    |                                                                       |
|                    | "warning": "From and To timestamps not found. Hence only the last     | 
|                    |                                                                       |
|                    | 10K logs scanned."                                                    |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              | If users provide  from/to date/time and filters, API will respond with|
|                    | logs from the specified date range and specified filter.              |
|                    |                                                                       |
+--------------------+-----------------------------------------------------------------------+

TEEM Settings APIs
-------------------

/settings/teem.json
````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Get/Update TEEM Settings data                                         |
+====================+=======================================================================+
| URL                | /settings/teem.json                                                   |
+--------------------+-----------------------------------------------------------------------+
| Method             | GET/POST                                                              |
+--------------------+-----------------------------------------------------------------------+
| Request Body       | {                                                                     |
|                    |                                                                       |
|                    | "hour": "<Hour>",                                                     |
|                    |                                                                       |
|                    | "minute": "<Minute>",                                                 |
|                    |                                                                       |
|                    | "timezone": "<Timezone>"                                              |
|                    |                                                                       |
|                    | "optout": <true/false>                                                |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Request    | {                                                                     |
|                    |                                                                       |
|                    | "hour": "3",                                                          |
|                    |                                                                       |
|                    | "minute": "15",                                                       |
|                    |                                                                       |
|                    | "timezone": "UTC",                                                    |
|                    |                                                                       |
|                    | "optout": false                                                       |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | "message": {                                                          |
|                    |                                                                       |
|                    | "hour": "3",                                                          |
|                    |                                                                       |
|                    | "minute": "15",                                                       |
|                    |                                                                       |
|                    | "timezone": "UTC",                                                    |
|                    |                                                                       |
|                    | "optout": false                                                       |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+


Background Service APIs
-------------------------

/async/tasks/status.json
`````````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Get background threads status                                         |
+====================+=======================================================================+
| URL                | /async/tasks/status.json                                              |
+--------------------+-----------------------------------------------------------------------+
| Method             | GET                                                                   |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | "message": [                                                          |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "description": "Websocket monitor",                                   |
|                    |                                                                       |
|                    | "name": "websocket-monitor",                                          |
|                    |                                                                       |
|                    | "resolution": "",                                                     |
|                    |                                                                       |
|                    | status": "up"                                                         |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "description": "APIC websocket connection",                           |
|                    |                                                                       |
|                    | "name": "websocket-1",                                                |
|                    |                                                                       |
|                    | "resolution": "",                                                     |
|                    |                                                                       |
|                    | status": completed"                                                   |
|                    |                                                                       |
|                    | }                                                                     |
|                    |                                                                       |
|                    |                                                                       |
|                    | ]                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

/async/services/restart.json
```````````````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Restart async services                                                |
+====================+=======================================================================+
| URL                | /async/services/restart.json                                          |
+--------------------+-----------------------------------------------------------------------+
| Method             | GET                                                                   |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | "message": {                                                          |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "celerybeat": {                                                       |
|                    |                                                                       |
|                    | "description": "Task scheduler",                                      |
|                    |                                                                       |
|                    | "status": "up"                                                        |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "celeryd": {                                                          |
|                    |                                                                       |
|                    | "description": "Task manager daemon",                                 |
|                    |                                                                       |
|                    | "status": "up"                                                        |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "redis": {                                                            |
|                    |                                                                       |
|                    | "description": "Task messaging server"                                |
|                    |                                                                       |
|                    | "status": "up"                                                        |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+

/async/services/status.json
`````````````````````````````

+--------------------+-----------------------------------------------------------------------+
| Title              | Get async services status                                             |
+====================+=======================================================================+
| URL                | /async/services/status.json                                           |
+--------------------+-----------------------------------------------------------------------+
| Method             | GET                                                                   |
+--------------------+-----------------------------------------------------------------------+
| Example Response   | Code: 200                                                             |
|                    |                                                                       |
|                    | "message": {                                                          |
|                    |                                                                       |
|                    | {                                                                     |
|                    |                                                                       |
|                    | "celerybeat": {                                                       |
|                    |                                                                       |
|                    | "description": "Task scheduler",                                      |
|                    |                                                                       |
|                    | "status": "up"                                                        |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "celeryd": {                                                          |
|                    |                                                                       |
|                    | "description": "Task manager daemon",                                 |
|                    |                                                                       |
|                    | "status": "up"                                                        |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | "redis": {                                                            |
|                    |                                                                       |
|                    | "description": "Task messaging server"                                |
|                    |                                                                       |
|                    | "status": "up"                                                        |
|                    |                                                                       |
|                    | },                                                                    |
|                    |                                                                       |
|                    | }                                                                     |
+--------------------+-----------------------------------------------------------------------+
| Error Response     | Code: 400                                                             |
|                    |                                                                       |
|                    | Content: {error: Bad request}                                         |
+--------------------+-----------------------------------------------------------------------+
| Notes              |                                                                       |
+--------------------+-----------------------------------------------------------------------+
