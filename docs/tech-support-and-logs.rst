Tech Support Policies and Logs
==============================

The application logs reside on the APIC server under ``/data2/logs/F5ACIServiceCenter/``. You can create a Logs export policy on APIC to include this App log. 
   
Create TechSupport policy
-------------------------

To create a Tech-Support policy, complete the following steps.

1. Login to APIC UI and navigate to :guilabel:`Admin ->` :guilabel:`Import/Export ->` :guilabel:`Export policies ->` :guilabel:`On-Demand Tech Support`.

2. Right-click and create a new policy. Provide a name, select :guilabel:`Export To Controller` and the :guilabel:`For App` checkbox. 

3. From the list, select the F5ACIServiceCenter app and click :guilabel:`Submit`.

Download logs
-------------

To collect and download tech-support containing app logs, complete the following steps.

1. Log in to the APIC UI and navigate to :guilabel:`Admin ->` :guilabel:`Import/Export ->` :guilabel:`Export policies ->` :guilabel:`On-Demand Tech Support`.

2. Right-click the policy and select :guilabel:`Collect TechSupport`.

3. Click the policy in the right pane and click the Operational tab. 

The tech support logs are available to download.
