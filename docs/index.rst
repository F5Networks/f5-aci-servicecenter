F5 ACI ServiceCenter User and Deployment Guide
==============================================

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

For support for the F5 ACI ServiceCenter app, `file an issue on Github <https://github.com/F5Networks/f5-aci-servicecenter/issues>`_.

To download the F5 ACI ServiceCenter app, go to `Cisco DC App Center <https://dcappcenter.cisco.com/f5-aci-servicecenter.html>`_.

For details on supported versions, see :doc:`Support <support>`.

:fonticon:`fa fa-download` :download:`Attributions.pdf <./Attributions.pdf>`

|

|
	
.. toctree::
   :caption: F5 ACI Service Center
   :glob:
   :maxdepth: 2
   :hidden:

   pre-req.rst
   install.rst
   navigate.rst
   l2-l3.rst
   l4-l7.rst
   dynamic-ep.rst
   faults.rst
   background-services.rst
   teem.rst
   searchip.rst
   tech-support-and-logs.rst
   faq.rst
   release-notes.rst
   support.rst
   rest_api.rst
