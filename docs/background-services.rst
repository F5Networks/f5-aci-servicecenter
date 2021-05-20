App background services
=======================

F5 ACI ServiceCenter has a few background services and tasks running which ensure proper functioning of certain features such as Dynamic Endpoint Discovery. 

View app background services status
```````````````````````````````````
1. Click the user menu in the top-right corner.

2. Click **Settings > Status**.

3. This displays a table named **Services** with the status of all the background services. The services displayed in this table are celeryd, celerybeat and redis. Check details of these services below.


+--------------+-----------------------+--------------------------------------------------------------------------------------------------------------+
| Service Name | Description           | Purpose                                                                                                      |
+--------------+-----------------------+--------------------------------------------------------------------------------------------------------------+
| celeryd      | Task scheduler        | This service is responsible for Dynamic endpoint discovery processing and TEEM reports sent to F5.           |
+--------------+-----------------------+--------------------------------------------------------------------------------------------------------------+
| celerybeat   | Task manager daemon   | This service is responsible for scheduling the Dynamic endpoint discovery and TEEM related background tasks. |
+--------------+-----------------------+--------------------------------------------------------------------------------------------------------------+
| redis        | Task messaging server | This server is used as a message broker by celeryd and celerybeat services.                                  |
+--------------+-----------------------+--------------------------------------------------------------------------------------------------------------+

Restart app background services
```````````````````````````````
1. Click the user menu in the top-right corner.

2. Click **Settings > Status**.

3. This displays a table named **Services** with the status of all the background services.

4. If any of the listed services are **Down**, click the :guilabel:`Restart` button to restart these services.

.. note::

   - If the services do not show the status as **Up**, try disabling and re-enabling the app. 
 
 
View app background tasks status
````````````````````````````````
1. Click the user menu in the top-right corner.

2. Click **Settings > Status**.

3. Scroll down to see a table named **Background Tasks** with the status of all background tasks. The tasks displayed in this table are websocket-monitor, fvIp-subscription-refresh, fvStIp-subscription-refresh and websocket-<Number>. Check details of these tasks below.

+-----------------------------+-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| Service Name                | Description                 | Purpose                                                                                                                                                            |
+-----------------------------+-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| websocket-monitor           | Websocket monitor           | This thread ensures that the backend websockets are up and running.                                                                                                |
+-----------------------------+-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| fvIp-subscription-refresh   | Dynamic endpoint subscriber | This is a subscription thread responsible for refreshing the subscription between the App and APIC in order to receive endpoint discovery notifications from APIC. |
+-----------------------------+-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+ 
| fvStIp-subscription-refresh | Dynamic endpoint subscriber | This is a subscription thread responsible for refreshing the subscription between the App and APIC in order to receive endpoint discovery notifications from APIC. |
+-----------------------------+-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| websocket-<X>               | APIC websocket connection   | This thread is responsible for receiving the newly discovered or deleted endpoints from APIC.                                                                      | 
+-----------------------------+-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::
   
   - This table also displays a **Resolution** column. If any of the threads are not running, the resolution suggests disabling and re-enabling the F5 ACI ServiceCenter app. Disabling and re-enabling the app does not cause any data loss.

BIG-IP Version Display and FASC Application Controller Information
``````````````````````````````````````````````````````````````````
F5 ACI Service Center supports BIG-IP version display and FASC application running controller information.

BIG-IP version Display
------------------------
To view the BIG-IP version in F5 ACI Service Center, hover over the BIG-IP IP address displayed in the header of the logged in device.

FASC Application Controller Information
-------------------------------------------
FASC Application controller information is a troubleshooting tool used to get information and the IP of the APIC controller on which the F5 ACI Service Center application container is running. This APIC controller can be accessed (via SSH) to view and retrieve  F5 ACI Service Center logs and for other debugging purposes.

1. Click the **admin** menu on the top right corner of FASC.

2. Select **Settings** from the drop down menu.

3. Click the **Status** selection on the side bar.

4. APIC controller information and IP address is displayed in the card named **APIC Controller**
