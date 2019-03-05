A virtual server listens for packets destined for the external IP address. You must create a virtual server that points to the pool you created.

1. In the BIG-IP Configuration utility, on the Main tab, click :menuselection:`Local Traffic -> Virtual Servers`.
2. Click :guilabel:`Create` and populate the following fields.

   ====================================== =================================
   Field                                  Value
   ====================================== =================================
   :guilabel:`Name`                       A unique name
   :guilabel:`Destination Address/Mask`   BIG-IP VE's private IP address
   :guilabel:`Service Port`               ``443``
   :guilabel:`HTTP Profile`               http
   :guilabel:`SSL Profile (Client)`       clientssl
   :guilabel:`SSL Profile (Server)`       serverssl
   :guilabel:`Source Address Translation` Auto Map
   :guilabel:`Default Pool`               ``web_pool``
   ====================================== =================================

   \

   **Note:** These settings are for demonstration only. For details about securing a web application with SSL, see the product documentation at |askf5|.

3. Click :guilabel:`Finished`.

Traffic to the BIG-IP VE external IP address will now go to the pool members. To test in a browser, type: ``https://<external-IP-address>``.

.. |askf5| raw:: html

   <a href="http://askf5.com" target="_blank">askf5.com</a>
