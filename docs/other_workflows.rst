Tech Support Policies and Logs
==============================

The application logs reside on the APIC server under /data2/logs/<App Name>/. You can create a Logs export policy on APIC to include this App log. 
   
Create TechSupport policy
-------------------------

To create a Tech-Support policy, complete the following steps.

1. Login to APIC UI and navigate to :menuselection:`Admin -> Import/Export -> Export policies -> On-Demand Tech Support`.

2. Right-click and create a new policy. Provide a name, select :guilabel:`Export To Controller` and the :guilabel:`For App` checkbox. 

3. From the list, select the F5 app and click :guilabel:`Submit`.

.. note::
   In APIC 3.2 release if there is an issue creating the policy then use the REST API post to APIC to create the tech-support policy and    use it to collect tech-support. One time effort to create policy.
   
   Login to apic using following post
   
   - Endpoint URL : "https://<APIC IP>/api/aaaLogin.xml"
   - Payload : <aaaUser name="<<apic-admin-name>>" pwd="<<password>>"/>
	  
   Create the Tech-Support policy using following

   - Endpoint URL: "https://<APIC IP>/api/mo/uni/fabric.json"
   - Payload to create policy named "F5-App-Tech-Support"
   
   .. code-block:: json
		
      {
	    "fabricInst": {
		  "attributes": {
		    "dn": "uni/fabric",
			"status": "modified"
		  },
		  "children": [{
		    "fabricFuncP": {
			  "attributes": {
				"dn": "uni/fabric/funcprof",
				"status": "modified"
			  },
			    "children": [{
				  "fabricCtrlrPGrp": {
				    "attributes": {
					  "dn": "uni/fabric/funcprof/ctrlrgrp-default",
					  "status": "modified"
					},
					  "children": [{
					    "fabricRsApplTechSupOnD": {
					      "attributes": {
						    "tnDbgexpTechSupOnDName": "F5-App-Tech-Support"
						  }
					    }
					  }]
					}
				 }]
			  }
			},
			{
			   "dbgexpTechSupOnD": {
			     "attributes": {
				   "dn": "uni/fabric/tsod-F5-App-Tech-Support",
				     "name": "F5-App-Tech-Support",
					 "exportToController": "true",
				     "vendorName": "F5Networks",
				     "appName": "F5ACIServiceCenter"
				  }
				}
			 }
		 ]}
      }

Download logs
-------------

To collect and download tech-support containing app logs, complete the following steps.

1. Log in to the APIC UI and navigate to :menuselection:`Admin -> Import/Export -> Export policies -> On-Demand Tech Support`.

2. Right-click the policy and select :guilabel:`Collect TechSupport`.

3. Click the policy in the right pane and click the Operational tab. 

The tech support logs are available to download.
