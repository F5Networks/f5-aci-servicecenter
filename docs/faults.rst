View Faults (Supported in v2.4+)
===============================================

View App Faults
---------------

1. Traverse to top-right corner menu.

2. Click :guilabel:`App Faults`.

3. This displays a datagrid with the last 100 errors/warnings that occurred in the application’s background tasks and also displays resolution, if any.

.. note::
    - This specifically displays the faults in websocket and subscriptions for dynamic endpoint attach detach feature. 
    - On click, each row of the datagrid will display a detailed view for the fault.
    - To see older errors/warnings, please ssh to APIC server and check log files present in /data2/logs/F5Networks_F5ACIServiceCenter/faults/app.log

View BIG-IP Faults
------------------

1. Login to the BIG-IP.

2. Click on any one of the feature tabs i.e. :guilabel:`Visibility` OR :guilabel:`L2-L3 Network Management` OR :guilabel:`L4-L7 App Services`.

3. Click on the :guilabel:`View Faults` icon.

4. This displays a datagrid with the last 100 errors/warnings that occured on this BIG-IP.

.. note::
    - The datagrid also displays the type of error (Visibility, L2-L3 Network Management OR L4-L7 App Services. It is possible to filter the errors by type)
    - On click, each row of the datagrid will display a detailed view for the fault.
    - To see older errors/warnings, please ssh to APIC server and check log files present in /data2/logs/F5Networks_F5ACIServiceCenter/faults/<BIG-IP IP>.log
