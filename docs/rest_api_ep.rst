REST API Dynamic Endpoint Attach Detach
=======================================

This section will go over the specifics of the REST APIs supported by F5 ACI ServiceCenter application for dynamic endpoint attach detach feature.

The REST calls can be made to the following APIC endpoint

.. code-block:: json

   https://<APIC-URL>/appcenter/F5Networks/F5ACIServiceCenter/<REST-API>

   Example:

   https://10.107.0.24/appcenter/F5Networks/F5ACIServiceCenter/getbigiplist.json

`Download the API POSTMAN collection <https://github.com/F5Networks/f5-aci-servicecenter/tree/master/api_collection>`_.

Request Headers
---------------

For all the F5 ACI ServiceCenter API calls following request header parameters are required:

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

4. In the “Headers” section of any further REST API requests, add a key-value pair. Key name is “DevCookie”, and its value should be the token obtained in the previous step

.. code-block:: json
   
   Key         Value        
   DevCookie : < token value > 
   

Header: Content-Type
````````````````````
.. code-block:: json
   
   Key           Value           
   Content-Type: application/json


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

