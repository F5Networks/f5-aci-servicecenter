Before You Install the F5 ACI ServiceCenter
===========================================

To enable and use the L4-L7 Configuration tab, use the BIG-IP Configuration utility to install the f5-appsvcs package version 3.7.0 or later on BIG-IP.

Notes:

- For each BIG-IP device added to the ACI ServiceCenter, only one BIG-IP user can log in at a time.
- Multiple APIC admin users will see the same view of the app (the same list of BIG-IP devices with the same application data).
- You cannnot use APIC configuration to add a logical device for BIG-IP. The F5 ACI ServiceCenter does not provide this functionality.
- When you create a TechSupport policy for the app:

  1. Log in to the APIC UI and navigate to :menuselection:`Admin -> Import/Export -> Export policies -> On-Demand Tech Support`.

  2. Right-click and create a new policy. Provide a name, select :guilabel:`Export To Controller` and the :guilabel:`For App` checkbox. From the list, select the F5 app and click :guilabel:`Submit`.
