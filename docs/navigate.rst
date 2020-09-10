Navigate the F5 ACI ServiceCenter
=================================

In the F5 ACI ServiceCenter :guilabel:`Partition` list, :guilabel:`Common Partition` is selected by default. If any other partition is selected, for example the :guilabel:`Sample Partition`, the selected table shows entries that belong to both the sample partition and common partition.

View VLAN table
---------------

1. Click the Visibility tab 

   In the :guilabel:`Table` list, the VLAN table is selected by default.

2. From the :guilabel:`Partition` list, select the partition you’re interested in.

   The table shows all the VLANs (vlan encaps) from the BIG-IP device that have a corresponding **Logical Device|Tenant** entry on the APIC.
   
   The table shows all the VLANs (vlan encaps) from the BIG-IP device that have a corresponding **Endpoint Group|Application Profile|Tenant** entry on the APIC. These correspond to the **Static Port VLANs** and **Static Leaf VLANs** under the aforementioned **Endpoint Group**.

   The table does not show VLANs from BIG-IPs that don't have corresponding APIC entries.
   

View VIP table
---------------

1. Click the Visibility tab, and then from the :guilabel:`Table` list, click the :guilabel:`VIP` table.

2. From the :guilabel:`Partition` list, click the partition you're interested in.

   This table shows all the VIPs (virtual servers) from the BIG-IP device. It also shows the pool and nodes for this VIP. For each node, it displays the corresponding Tenant, Application, and End Point
   Group entries from APIC.
   
   If you check the APIC GUI for the Tenant, Application, or End Point Group, you will see these node IPs under the Operational tab.

   -  If a node is not operational on the APIC, it is not displayed in the VIP table.
   -  If a pool is empty and does not have any nodes, a pool entry is not displayed in the VIP table.
   -  If a VIP does not have an assigned default pool, the VIP is not displayed in the VIP table.
   -  If any of the node members have an associated FQDN, it will be displayed in the FQDN column (Supported in v2.4+).
   -  Route domain entries are supported by VIP table. Nodes on the BIG-IP of the form **IP%RD** will be displayed in the VIP table (Supported in v2.6+). 


View Node table
---------------

1. Click the Visibility tab, and then click the :guilabel:`Node` table from the Table list.

2. From the :guilabel:`Partition` list, click the partition.

   This table shows all the Nodes from this BIG-IP device, provided they have a corresponding Tenant Application and EPG entry on the APIC. It also displays the pools that the node belongs to. For each pool, it
   shows the corresponding VIPs (virtual servers).

   If you check the APIC GUI for the specified Tenant, Application, or End Point Group, you will see these node IPs under the Operational tab.

   -  If a specific node is not operational on the APIC, it isn't displayed in the Node table.
   -  If a pool does not have any nodes, the pool is not displayed in any of the entries in the Node table.
   -  If a VIP does not have an assigned default pool, the VIP is not displayed in any of the entries in the Node table.
   -  If any of the nodes have an associated FQDN, it will be displayed in the FQDN column (Supported in v2.4+).
   -  Route domain entries are supported by Node table. Nodes on the BIG-IP of the form **IP%RD** will be displayed in the Node table (Supported in v2.6+).

   

Download report
---------------

1. Click the table you're interested in: VLAN, VIP, or Node.

2. In the top right of the Visibility tab, click :guilabel:`Download`.

A report, in the form of an Excel sheet, is downloaded.

.. note::

   - The report download is also supported using REST API calls to visibility table REST API endpoints. More details can be found here: https://clouddocs.f5.com/f5-aci-servicecenter/latest/rest_api.html


Refresh Visibility tab
----------------------

1. Select the table you're interested in: VLAN, VIP, or Node.

2. In the top right of the Visibility tab, click :guilabel:`Refresh`.

The contents of the visibility table are refreshed.
