View Faults (Supported in v2.4+)
===============================================

View App Faults
---------------

1. From the top-right corner menu, click :guilabel:`App Faults`.

3. This displays a datagrid with the last 100 errors/warnings that occurred in the application’s background tasks and also displays resolution, if any.

.. note::
    - This specifically displays the faults in websocket and subscriptions for the dynamic endpoint attach detach feature. 
    - On click, each row of the datagrid will display a detailed view for the fault.
    - To see older errors/warnings, SSH to the APIC server and check the log files in /data2/logs/F5Networks_F5ACIServiceCenter/faults/app.log
    - The F5 ACI ServiceCenter currently displays the logs in UTC timezone which is the default timezone of this app.


View BIG-IP Faults
------------------

1. Login to the BIG-IP.

2. Click any one of the feature tabs i.e. :guilabel:`Visibility` OR :guilabel:`L2-L3 Network Management` OR :guilabel:`L4-L7 App Services`.

3. Click the :guilabel:`View Faults` icon.

4. This displays a datagrid with the last 100 errors/warnings that occured on this BIG-IP.

.. note::
    - The datagrid also displays the type of error (Visibility, L2-L3 Network Management OR L4-L7 App Services. It is possible to filter the errors by type)
    - On click, each row of the datagrid will display a detailed view for the fault.
    - To see older errors/warnings, SSH to the APIC server and check the log files in /data2/logs/F5Networks_F5ACIServiceCenter/faults/<BIG-IP IP>.log
    - The F5 ACI ServiceCenter currently displays the logs in UTC timezone which is the default timezone of this app.
