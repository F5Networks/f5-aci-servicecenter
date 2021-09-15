Visibility
==========

In the F5 ACI ServiceCenter :guilabel:`Partition` list, :guilabel:`Common Partition` is selected by default. If any other partition is selected, for example the :guilabel:`Sample Partition`, the selected table shows entries that belong to both the sample partition and common partition.

View VLAN table
---------------

1. Click the Visibility tab 

   In the :guilabel:`Table` list, the VLAN table is selected by default.

2. From the :guilabel:`Partition` list, select the partition you’re interested in. The **All partition** option is supported for the VLAN table in v2.9 and later.

   The table shows all the VLANs (vlan encaps) from the BIG-IP device that have a corresponding **Logical Device|Tenant** entry on the APIC.
   
   The table shows all the VLANs (vlan encaps), Self IP, Interfaces from the BIG-IP device that have a corresponding **Endpoint Group|Application Profile|Tenant** entry on the APIC. These correspond to the **Static Port VLANs** and **Static Leaf VLANs** under the aforementioned **Endpoint Group**. Users are able to view information related to Self IPs and interfaces by clicking the dropdown icon in the Self IP and Interface columns respectively.

   The table does not show VLANs from BIG-IPs that don't have corresponding APIC entries.
   

View VIP table
---------------

1. Click the Visibility tab, and then from the :guilabel:`Table` list, click the :guilabel:`VIP` table.

2. From the :guilabel:`Partition` list, click the partition you're interested in. The **All partition** option is supported for the VIP table in v2.9 and later.

   This table shows all the VIPs (virtual servers) from the BIG-IP device. It also shows the pool and nodes for this VIP. For each node, it displays the corresponding Tenant, Application, and End Point
   Group entries from APIC.
   
   If you check the APIC GUI for the Tenant, Application, or End Point Group, you will see these node IPs under the Operational tab.

   -  If a node is not operational on the APIC, it is not displayed in the VIP table.
   -  If a pool is empty and does not have any nodes, a pool entry is not displayed in the VIP table.
   -  If a VIP does not have an assigned default pool, the VIP is not displayed in the VIP table.
   -  If any of the node members have an associated FQDN, it will be displayed in the FQDN column (Supported in v2.4+).
   -  Route domain entries are supported by the VIP table. Nodes on the BIG-IP of the form **IP%RD** will be displayed in the VIP table (Supported in v2.6+). 


View Node table
---------------

1. Click the Visibility tab, and then click the :guilabel:`Node` table from the Table list.

2. From the :guilabel:`Partition` list, click the partition. The **All partition** option is supported for the Node table in v2.9 and later.

   This table shows all the Nodes from this BIG-IP device, provided they have a corresponding Tenant Application and EPG entry on the APIC. It also displays the pools that the node belongs to. For each pool, it
   shows the corresponding VIPs (virtual servers).

   If you check the APIC GUI for the specified Tenant, Application, or End Point Group, you will see these node IPs under the Operational tab.

   -  If a specific node is not operational on the APIC, it isn't displayed in the Node table.
   -  If a pool does not have any nodes, the pool is not displayed in any of the entries in the Node table.
   -  If a VIP does not have an assigned default pool, the VIP is not displayed in any of the entries in the Node table.
   -  If any of the nodes have an associated FQDN, it will be displayed in the FQDN column (Supported in v2.4+).
   -  Route domain entries are supported by the Node table. Nodes on the BIG-IP of the form **IP%RD** will be displayed in the Node table (Supported in v2.6+).

   

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



Configure Telemetry
-------------------

1. To view the Virtual Server statistics on the Visibility VIP Dashboard, you must install the Telemetry Streaming plugin version 1.17 or higher on the BIG-IP device.

2. Follow the installation steps from https://clouddocs.f5.com/products/extensions/f5-telemetry-streaming/latest/installation.html

3. Configure a default pull consumer. For example: https://clouddocs.f5.com/products/extensions/f5-telemetry-streaming/latest/pull-consumers.html#pull

4. Recommended pull consumer configuration: For a scaled environment, we strongly recommend you retrieve just the Pool and Virtual Server stats from the BIG-IP. One way to filter the VIP and Pool statistics is to create a default pull consumer configuration via  a POST request to: https://<BIG_IP>/mgmt/shared/telemetry/declare

      {
          "class": "Telemetry",
          "My_Poller": {
              "class": "Telemetry_System_Poller",
              "interval": 0,
              "actions": [
                  {
                      "includeData": {},
                      "locations": {
                          "virtualServers": {
                              ".*": {}
                          },
                          "pool": {".*":{}}
                      }
                  }
              ]
          },
          "My_System": {
              "class": "Telemetry_System",
              "enable": "true",
              "systemPoller": ["My_Poller"]
          },
          "My_Pull_Consumer": {
              "class": "Telemetry_Pull_Consumer",
              "type": "default",
              "systemPoller": ["My_Poller"]
          }
      }

5. If further customization is required to filter only specific virtual servers and pools, refer to this link: https://clouddocs.f5.com/products/extensions/f5-telemetry-streaming/latest/data-modification.html
 
View VIP Dashboard
-------------------

1. Click the Visibility tab, and then from the Table list, click the VIP table.

2. From the Partition list, click the appropriate partition.

3. The VIP table for this BIG-IP and partition will be displayed.

4. Click the VIP for which the dashboard is to be displayed. This redirects to the Visibility Dashboard sub-tab. 
   
   .. note::
   
      - It is possible to directly click the **Visibility Dashboard** sub-tab and then select the VIP, instead of a redirect from **Visibility Table**.
      
5. F5 ACI ServiceCenter supports MAC masquerade MAC display under BIG-IP endpoint details on the VIP visibility dashboard. MAC address type details (such as MAC masquerade or normal MAC) are displayed when you hover over the Information icon in the MAC column of the BIG-IP endpoint details table.

6. Visibility Dashboard displays the information for the selected VIP including VIP name, service port, protocol, SNAT, route domain, iRules, default pool (and pool information such as load balancing and pool monitor)
         
   a. The dashboard displays a **Telemetry Consumer** drop-down list. Select the appropriate consumer from which the statistics need to be obtained. The Virtual pool statistics will be displayed on the dashboard including Bits, Packets, Connections and Requests. 
         
      .. note::
         
         - The Telemetry Streaming plugin needs to be installed on the BIG-IP to be able to view the Telemetry consumer list and stats from the telemetry consumer. Check the **Configure Telemetry** section for installation and configuration.
            
         - If there is only a single Telemetry pull consumer configured, then FASC will directly query that consumer and display the stats.
            
   b. **View Stats** - The dashboard displays a **View Stats** link beside the default pool. It displays the total pool member count and the availability and enabled state of the pool  members using a pie chart.
         
   c. **View Logs** - The dashboard displays a **View Logs** link beside the VIP, which, when clicked opens a popup window and displays all the logs for the selected Virtual Server. 
         
      .. note::

        - It is also possible to view all logs instead of the filtered logs.
            
        - It is possible to specify a UTC from and to Date/Time for the logs to be retrieved. The From/To time should be specified in UTC timezone. The response too will be in UTC.

   d. **View Connections** - The dashboard displays a **View Connections** link, which, when clicked displays all the active connections to that VIP.
         
   e. **APIC Endpoint Details** - The Visibility dashboard displays APIC details for the VIP: - 1. MAC 2. EPG 3. Node 4. Interface 5. VLAN Encap
                                        
   f. **BIG-IP Endpoint Details** - The Visibility dashboard displays BIG-IP details for the VIP: - 1. MAC 2. VLAN 3. Interfaces (There is a **View Logs** link besides interfaces to view the interface logs) 4. Self IPs


View Node Dashboard
-------------------

1. Click the Visibility tab, and then from the Table list, click the Node table.

2. From the Partition list, click the appropriate partition.

3. The Node table for this BIG-IP and partition will be displayed.

4. Click the Node for which the dashboard is to be displayed. This redirects to the Visibility Dashboard sub-tab. 

   .. note::
   
      - It is possible to directly click the **Visibility Dashboard** sub-tab and then select the Node, instead of a redirect from **Visibility Table**.
      
5. The Visibility Dashboard displays the information for the selected VIP including Node name, route domain and monitor.

   a. **View Logs** - The dashboard displays a **View Logs** link beside the Node, which, when clicked opens a popup and all the logs for the selected Node.

      .. note::

         - It is also possible to view all logs instead of the filtered logs.
            
         - It is possible to specify a UTC from and to Date/Time for the logs to be retrieved. The From/To time should be specified in UTC timezone. The response too will be in UTC.

   b. **View Connections** - The dashboard displays a **View Connections** link which, when clicked displays all the active connections to that Node.

   c. **APIC Endpoint Details** - The Visibility dashboard displays APIC details for the Node: - 1. MAC 2. EPG 3. Node 4. Interface 5. VLAN Encap 
                                        
   d. **BIG-IP Endpoint Details** - The Visibility dashboard displays BIG-IP details for the Node: - 1. MAC 2. VLAN 3. Interfaces (There is a **View Logs** link beside interfaces to view the interface logs) 4. Self IPs
   
6. F5 ACI ServiceCenter supports VXLAN tunnel interfaces along with individual, Port channel, and Virtual port channel interfaces on the Node table visibility dashboard.
   
   To view details of the VXLAN tunnel interfaces, click Node IP in the Node information table, and then scroll down to the APIC Endpoint details table. All interfaces associated with the node, such as VPC, PC, Individual, and Tunnel, are displayed in the interface column. When you click the interface, additional information related to these interfaces displays in the side panel.



------

Frequently Asked Questions (FAQ)
--------------------------------

**Q. Why do VLANs from the F5 ACI ServiceCenter application visibility table vanish if I destroy and re-create service graph template of my VIRTUAL Logical Device on Cisco APIC?**

For virtual ADC logical devices, if you performed the following steps: 

-  Take snapshot 

-  Delete service graph template 

-  Revert to snapshot config

The VLAN encap values associated with logical interfaces of the LDEV change and do not remain the same. The application detects this change and shows a warning on the L2-L3 stitching LDEV info page that displays VLANs. You can click the warning to update the VLAN tag. 

After a VLAN tag is updated on the BIG-IP, the visibility VLAN table starts showing the VLANs again.

------

**Q. Why don't I see all the VLANs/VIPs/Nodes from the BIG-IP in the visibility tables?**

Visibility tables display only those entries from the BIG-IP which have corresponding constructs on APIC. For example, a VLAN from the BIG-IP will only be displayed if that VLAN also belongs to some 'Tenant/App Profile/EPG' or 'Tenant/LDEV' on APIC. Similarly, a node will only be displayed if it exists as an operational endpoint in one or more of the EPGs on APIC. 

------

**Q. In Visibility tables, why don't I see Common partition entries in VLAN/VIP/Node table when I select a different partition?**

The F5 ACI ServiceCenter Visibility tables have an option to select the **Partition**. The VLAN/VIP/Node tables will only display entries from the selected partition and will not include Common partition entries (although the BIG-IP UI does provide this feature where any partition selected will also show entries from the Common partition). 

Note: This is a new behavior in FASC v2.6 and above. The previous versions do show Common partition entries along with the selected partition entries.


Visibility Dashboard
--------------------

**Q. On the Visibility Dashboard in v2.7+, why is the BIG-IP Endpoint Details section blank?**

The BIG-IP Endpoint Details section on the Visibility Dashboard may not display information due to the MAC address table getting flushed on the BIG-IP.

Workaround: Send an ARP request to the host or check the connectivity with the host using the **ping** command.

------

**Q. On the Visibility Dashboard in v2.7+, why is the 'Interface' column blank in the BIG-IP endpoint details section?**

The **Interface** column in the BIG-IP Endpoint Details section on the Visibility Dashboard will be blank for vCMP guests since the behavior of the vCMP Guest BIG-IP also is the same; i.e. no interface information for VLANs.

------

**Q. Why are the pool members displayed on Visibility VIP table, and the pool members displayed on the Visibility VIP dashboard not the same?**

The Visibility VIP table displays the pool members from a BIG-IP VIP, only if they are also present on the APIC. However, the Visibility dashboard shows all the pool members (and associated stats) that are present on the BIG-IP even if they may or may not be present on the APIC. Hence both the outputs may be different.

------

**Q. What does the field 'Route Domain' on the Visibility Dashboard indicate?**

It displays the **default route domain** for the partition to which the Virtual Server (VIP) or Node belongs.

------

**Q. Why don't I see the scrollbar for the 'View Logs' window on the Visibility Dashboard?**

If you encounter this issue, use the 'zoom out' option on your web browser. For example, on Windows, hold the **Ctrl** key, and then click **-** (the dash/minus key).

------

**Q. VIP MAC masquerade address might display an old MAC on the visibility dashboard**

Due to the APIC endpoint learning and retention behavior, it takes 10-15 minutes for the updated MAC details to be available on the APIC endpoint tracker. Until APIC updates the MAC address, the FASC visibility dashboard displays the old MAC address. Refer this link for recommended actions:  https://support.f5.com/csp/article/K44023455

------
