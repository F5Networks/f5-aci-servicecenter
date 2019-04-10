F5 ACI ServiceCenter
====================

The F5 ACI ServiceCenter enables visibility, L2-L3 stitching, and L4-L7 app services between BIG-IP and Cisco Application Centric Infrastructure (ACI).

By using the F5 ACI ServiceCenter app, you can add, manage, and log in to multiple BIG-IP systems.

===================== ============================================================================================================================================================
Feature               Capability                                                         
===================== ============================================================================================================================================================
Visibility            View BIG-IP network elements like VLANs, VIPs, and nodes, and correlate them with APIC information like Tenant | App | EPG.

L2-L3 Stitching       Facilitates L2-L3 stitching between APIC logical devices and BIG-IP (CRUD operations for VLAN, self IP, and default gateway).                                                

L4-L7 App Services    Create custom application definitions, with the ability to **Dry-run** and **Submit** the declaration.        
                                                                                       
                      It has two sub-tasks:                                             
                                                                                      
                      1) BIG-IP: Enables creation of BIG-IP AS3 declaration by:          
                                                                   
                         a) Writing the declaration JSON in provided text box or            
                                                                                         
                         b) Uploading AS3 declaration file                                  
                                                                                         
                                                                                         
                      2) Application: Enables AS3 application management with features   
                                                                                         
                         a) Create/delete a partition on BIG-IP                             
                                                                                         
                         b) Create/update/delete application on BIG-IP                      
===================== ============================================================================================================================================================

|

	
.. toctree::
   :caption: F5 ACI Service Center
   :glob:
   :maxdepth: 2
   :hidden:

   pre_req.rst
   login_logout_workflows.rst
   l4_l7_workflows.rst
   l2_l3_workflows.rst
   visibility_workflows.rst
   other_workflows.rst
   faq.rst
   release_notes.rst
