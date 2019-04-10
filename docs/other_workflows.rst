Other Workflows
===============

The application logs reside on the APIC server under /data2/logs/<App Name>/. You can create a Logs export policy on APIC to include this App log. 
   
To create a Tech-Support policy, complete the following steps.

Create TechSupport policy
-------------------------

1. Login to APIC UI and navigate to :menuselection:`Admin -> Import/Export -> Export policies -> On-Demand Tech Support`.

2. Right-click and create a new policy. Provide a name, select :guilabel:`Export To Controller` and the :guilabel:`For App` checkbox. From the list, select the F5 app and click :guilabel:`Submit`.

Download logs
-------------

To collect and download tech-support containing app logs, complete the following steps.

1. Log in to the APIC UI and navigate to :menuselection:`Admin -> Import/Export -> Export policies -> On-Demand Tech Support`.

2. Right-click the policy and select :guilabel:`Collect TechSupport`.

3. Click the policy in the right pane and click the Operational tab. 

The tech support logs are available to download.