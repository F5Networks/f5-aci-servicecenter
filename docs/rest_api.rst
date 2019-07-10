Introduction
============

This document specifies the REST APIs supported by F5 ACI ServiceCenter application.

REST API Endpoint
-----------------

The REST calls can be made to APIC endpoint

https://<APIC-URL>/appcenter/F5Networks/F5ACIServiceCenter/<REST-API>

.. code-block::
   https://10.107.0.24/appcenter/F5Networks/F5ACIServiceCenter/getbigiplist.json

Request Headers
---------------

For all the F5 ACI ServiceCenter API calls following request header parameters are required:

Header: DevCookie
`````````````````
Can be retrived as follows:

1. POST a request to the following API endpoint

.. code-block:: rst
   https://<APIC-URL>/api/aaaLogin.xml

2. Body for the POST request

.. code-block::
   data: <aaaUser name="apic-username" pwd="apic-password"/>

3. From the result of the POST, save the token returned

4. In the “Headers” section of any further REST API requests, add a key-value pair. Key name is “DevCookie”, and its value should be the token obtained in the previous step

.. code-block::
   Key       Value    
   DevCookie <token value>

Header: Content-Type
````````````````````
.. code-block:: json
   Key           Value    
   Content-Type  application/json
   
Input Parameters
----------------

There are multiple F5 ACI ServiceCenter APIs which require input parameters to be retrieved for the APIC Logical Device. These input parameters can be retrieved from APIC object browser known as visore.html

APIC managed objects can be accessed at https://<APIC_IP>/visore.html.

Below is a table of such parameters and steps on how to retrieve them.
These parameters will be required for L2-L3 Stitching tab.

+-------------+--------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Input Key   | Input Value                                                                                                                    | Input Value Example                                                                                                                                     |
+=============+================================================================================================================================+=========================================================================================================================================================+
| ldev        | 1. Go to APIC GUI → Tenant→ Services→ L4-L7→ Devices→ <Your L4-L7 Device>                                                      |     uni/tn-Sample\_2/lDevVip-f5-gs                                                                                                                      |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 2. Right click on the <Your L4-L7 Device> and click on “Open in Object Store Browser”                                          |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 3. Use the dn property from the object browser for input parameter “ldev”.                                                     |                                                                                                                                                         |
+-------------+--------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| lif         | 1. Go to APIC GUI → Tenant→ Services→ L4-L7→ Devices→ <Your L4-L7 Device> → Cluster Interfaces→ <Your Interface of Interest>   |     uni/tn-Sample\_2/lDevVip-f5-gs/lIf-external                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 2. Right click on the logical interface and click on “Open in Object Store Browser”                                            |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 3. Use the dn property from the object browser for input parameter “lif”                                                       |                                                                                                                                                         |
+-------------+--------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| lIfCtxDn    | - This value is null for PHYSICAL type of ADC devices                                                                          | uni/tn-Demo/GraphInst\_C-[uni/tn-Demo/brc-2ARMVE-34-35]-G-[uni/tn-Demo/AbsGraph-2ARMVE-34\_35]-S-[uni/tn-Demo]/NodeInst-N1/LegVNode-0/EPgDef-consumer   |
|             |                                                                                                                                |                                                                                                                                                         |
|             | - This value can be retrieved from visore for VIRTUAL ADC Devices:                                                             |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 1. Go to APIC GUI → Tenant→ Services→ L4-L7→ Devices→ <Your L4-L7 Device> → Cluster Interfaces→ <Your Interface of Interest>   |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 2. Right click on the logical interface and click on “Open in Object Store Browser”.                                           |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 3. Click on > arrow of the dn property to see it’s children                                                                    |                                                                                                                                                         |
|             |                                                                                                                                |                                                                                                                                                         |
|             | 4. Search for vnsRtEPgDefToLIf, and use the tDn property of that entry for lIfCtxDn                                            |                                                                                                                                                         |
+-------------+--------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+

The other way to retreive the values is to call the getldevinfo.json API and
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

2. /logoutbigip.json
--------------------

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

3. /deletebigip.json
--------------------

+-------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title             | Deletes a BIG-IP device from F5 ACI ServiceCenter Application (Note: The device is soft deleted, and once added back to the app, all data for the device is restored)   |
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

4. /setclustername.json
-----------------------

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
|                    | ]                                                                  |
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
| Notes              |                                                                    |
+--------------------+--------------------------------------------------------------------+

5. /getbigiplist.json
---------------------

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

6. /checkbigipfailoverstate.json
--------------------------------

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

7. /checkbigipsyncstatus.json
-----------------------------

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

8. /checkbigiptimeout.json
--------------------------

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

**L4-L7 App Services APIs**
===========================

9. /dryrunas3declaration.json
-----------------------------

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
| Notes              | As can be seen, the json provided has action "deploy”, and in the application, the json remains the same, except for the action attribute, which is changed to “dry-run” and a POST request is sent to <BIG-IP IP address>/mgmt/shared/appsvcs/declare   |
+--------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

10. /submitas3declaration.json
------------------------------

+--------------------+-----------------------------------------------------------------------------------------------------------------------+
| Title              | Submits AS3 declaration to specified BIG-IP device’s AS3 endpoint                                                     |
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
| Notes              | The json from above dictionary is posted to the BIG IP AS3 endpoint <BIG-IP IP address>/mgmt/shared/appsvcs/declare   |
+--------------------+-----------------------------------------------------------------------------------------------------------------------+

11. /getas3declaration.json
---------------------------

+--------------------+------------------------------------------------------------------------------------------------------------+
| Title              | Get AS3 declaration JSON from given BIG-IP device                                                          |
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
| Notes              | Get AS3 declaration from specified BIG-IP’s AS3 endpoint <BIG-IP IP address>/mgmt/shared/appsvcs/declare   |
+--------------------+------------------------------------------------------------------------------------------------------------+

12. /deleteas3declaration.json
------------------------------

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

13. /getas3data.json
--------------------

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

14. /updateas3data.json
-----------------------

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

15. /deleteas3partition.json
----------------------------

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

16. /deleteas3application.json
------------------------------

+--------------------+-------------------------------------------------------------------------+
| Title              | Deletes an application from BIG-IP AS3 declaration                      |
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

**L2-L3 Stitching APIs**
========================

17. /getldevs.json
------------------

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

18. /getldevinfo.json
---------------------

+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets Logical Device (L4-L7 device) information for specified Logical Device (Distinguished Name of Logical Device required)                                                 |
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
| Notes              | See `*Input Parameters* <https://docs.google.com/document/d/1OMy7rwHbqmm8iyurWdI_5y2JSzAmMVAYiWEAow795cc/edit#heading=h.cnzg26fqotvr>`__ section for ldev input parameter   |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

19. /getinterfaces.json
-----------------------

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

20. /getportlockdown.json
-------------------------

+--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets port lockdown options from BIG-IP device                                                                                                                                                   |
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

21. /gettrafficgroups.json
--------------------------

+--------------------+-----------------------------------------------------------------------+
| Title              | Gets available traffic groups from BIG-IP device                      |
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

22. /createbigipvlans.json
--------------------------

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
| Notes                        | See `*Input Parameters* <https://docs.google.com/document/d/1OMy7rwHbqmm8iyurWdI_5y2JSzAmMVAYiWEAow795cc/edit#heading=h.cnzg26fqotvr>`__ section for ldev, lif, lICtxDn input parameters   |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

23. /deletebigipselfips.json
----------------------------

+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title                        | Deletes Self IPs from BIG-IP device                                                                                                                                                        |
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
| Notes                        | See `*Input Parameters* <https://docs.google.com/document/d/1OMy7rwHbqmm8iyurWdI_5y2JSzAmMVAYiWEAow795cc/edit#heading=h.cnzg26fqotvr>`__ section for ldev, lif, lICtxDn input parameters   |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

24. /deletebigipvlans.json
--------------------------

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
| Notes                        | See `*Input Parameters* <https://docs.google.com/document/d/1OMy7rwHbqmm8iyurWdI_5y2JSzAmMVAYiWEAow795cc/edit#heading=h.cnzg26fqotvr>`__ section for ldev, lif, lICtxDn input parameters   |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

25. /vlansynctobigip.json
-------------------------

+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title                        | Synchronizes vlan information for specific vlan from F5 ACI ServiceCenter database to BIG-IP Device                                                                                        |
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
| Notes                        | See `*Input Parameters* <https://docs.google.com/document/d/1OMy7rwHbqmm8iyurWdI_5y2JSzAmMVAYiWEAow795cc/edit#heading=h.cnzg26fqotvr>`__ section for ldev, lif, lICtxDn input parameters   |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

26. /vlansynctodb.json
----------------------

+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title                        | Synchronizes vlan information for specific vlan from BIG-IP Device to F5 ACI ServiceCenter database                                                                                        |
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
| Notes                        | See `*Input Parameters* <https://docs.google.com/document/d/1OMy7rwHbqmm8iyurWdI_5y2JSzAmMVAYiWEAow795cc/edit#heading=h.cnzg26fqotvr>`__ section for ldev, lif, lICtxDn input parameters   |
+------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

27. /getrouteinfo.json
----------------------

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

28. /createbigiproutes.json
---------------------------

+--------------------+-----------------------------------------------------------------------------------------------------------------------------+
| Title              | Creates default gateway on BIG-IP device                                                                                    |
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

29. /deletebigiproutes.json
---------------------------

+--------------------+--------------------------------------------------------------------------------------------------------------------------------+
| Title              | Deletes default gateway from BIG-IP device                                                                                     |
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

30. /routesynctodb.json
-----------------------

+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Synchronizes default gateway information from BIG-IP device to F5 ACI ServiceCenter database                                                            |
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
| Notes              | Currently this API only supports default gateway synchronization, and cannot be used for synchronizing any other route information from BIG-IP device   |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+

31. /routesynctobigip.json
--------------------------

+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Synchronizes default gateway information from F5 ACI ServiceCenter database to BIG-IP device                                                            |
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
| Notes              | Currently this API only supports default gateway synchronization, and cannot be used for synchronizing any other route information from BIG-IP device   |
+--------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------+

**Visibility APIs**
===================

32. /getbigippartitions.json
----------------------------

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

33. /getvlanstats.json
----------------------

+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets VLANs from BIG-IP device and correlates with APIC Tenant/Application Profile/End Point Group information                                             |
+====================+===========================================================================================================================================================+
| URL                | /getvlanstats.json                                                                                                                                        |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                      |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                                                      |
|                    |                                                                                                                                                           |
|                    | "partition": "<Partition Name>"                                                                                                                           |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "10.107.0.22:443",                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "partition": "Common"                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                                                 |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Response   | [                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "vlans": [                                                                                                                                                |
|                    |                                                                                                                                                           |
|                    | "/Common/vlan-22",                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "/Common/vlan-21"                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ],                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "exportedTenants": [],                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "ldev": {                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "dn": "uni/tn-Demo/lDevVip-Demo-LogicalDevice",                                                                                                           |
|                    |                                                                                                                                                           |
|                    | "name": "Demo-LogicalDevice"                                                                                                                              |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "tenant": {                                                                                                                                               |
|                    |                                                                                                                                                           |
|                    | "dn": "uni/tn-Demo",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "name": "Demo"                                                                                                                                            |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "vlans": [                                                                                                                                                |
|                    |                                                                                                                                                           |
|                    | "/Common/vlan-300"                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | ],                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "exportedTenants": [],                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "ldev": {                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "dn": "uni/tn-Student3/lDevVip-Student3-LogicalDevice",                                                                                                   |
|                    |                                                                                                                                                           |
|                    | "name": "Student3-LogicalDevice"                                                                                                                          |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "tenant": {                                                                                                                                               |
|                    |                                                                                                                                                           |
|                    | "dn": "uni/tn-Student3",                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | "name": "Student3"                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | ]                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 4XX                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | Content: {error: <Error Message from F5 BIG-IP}                                                                                                           |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes              | If Partition other than Common is selected, for example Sample\_1, the API will return information for both partitions Sample\_1 and Common partitions.   |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+

34. /getvipstats.json
---------------------

+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets VIP:port (Virtual server) information from BIG-IP device and correlates with APIC Tenant/Application Profile/End Point Group information             |
+====================+===========================================================================================================================================================+
| URL                | /getvipstats.json                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                      |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                                                      |
|                    |                                                                                                                                                           |
|                    | "partition": "<Partition\_Name>"                                                                                                                          |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "10.107.0.22:443",                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "partition": "Sample\_1"                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                                                 |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Response   | [                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "vip": {                                                                                                                                                  |
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
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | "nodes": [                                                                                                                                                |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "status": "offline",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "name": "10.0.0.112:80",                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | "address": "10.0.0.112",                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | "tenant": "gstenant",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "app": "gsApp",                                                                                                                                           |
|                    |                                                                                                                                                           |
|                    | "epg": "consumerEPG",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "partition": "Common",                                                                                                                                    |
|                    |                                                                                                                                                           |
|                    | "enabled": "enabled"                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | },                                                                                                                                                        |
|                    |                                                                                                                                                           |
|                    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "status": "offline",                                                                                                                                      |
|                    |                                                                                                                                                           |
|                    | "name": "10.0.0.140:80",                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | "address": "10.0.0.140",                                                                                                                                  |
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
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Error Response     | Code: 4XX                                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | Content: {error: <Error Message from F5 BIG-IP}                                                                                                           |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Notes              | If Partition other than Common is selected, for example Sample\_1, the API will return information for both partitions Sample\_1 and Common partitions.   |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+

35. /getnodestats.json
----------------------

+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Title              | Gets node information from BIG-IP device and correlates with APIC Tenant/Application Profile/End Point Group information                                  |
+====================+===========================================================================================================================================================+
| URL                | /getnodestats.json                                                                                                                                        |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Method             | POST                                                                                                                                                      |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Request Body       | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "<BIG-IP IP or BIG-IP IP:Port or Hostname or Hostname:Port>",                                                                                      |
|                    |                                                                                                                                                           |
|                    | "partition": "<Partition\_Name>"                                                                                                                          |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Request    | {                                                                                                                                                         |
|                    |                                                                                                                                                           |
|                    | "url": "10.107.0.22:443",                                                                                                                                 |
|                    |                                                                                                                                                           |
|                    | "partition": "Sample\_1"                                                                                                                                  |
|                    |                                                                                                                                                           |
|                    | }                                                                                                                                                         |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Success Response   | Code: 200                                                                                                                                                 |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
| Example Response   | [                                                                                                                                                         |
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
|                    | "tenant": "gstenant",                                                                                                                                     |
|                    |                                                                                                                                                           |
|                    | "app": "gsApp",                                                                                                                                           |
|                    |                                                                                                                                                           |
|                    | "epg": "consumerEPG",                                                                                                                                     |
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
| Notes              | If Partition other than Common is selected, for example Sample\_1, the API will return information for both partitions Sample\_1 and Common partitions.   |
+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------+
