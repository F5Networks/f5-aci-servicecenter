The first time you boot BIG-IP VE, you must connect to the instance and create a strong admin password. You will use the admin account and password to access the BIG-IP Configuration utility.

This management interface may be accessible to the Internet, so ensure the password is secure.

1. Connect to BIG-IP VE.

   - At the command prompt, navigate to the folder where you saved your ssh key and type: ``ssh -i <private_key_file.pem> admin@<bigip_public_ip_address>``

   - If you prefer, you can open PuTTy and in the :guilabel:`Host Name (or IP address)` field, enter the external IP address, for example:

     .. figure:: ../_static/images/admin_password1.png

     In the Category pane on the left, click :menuselection:`Connection ->  SSH -> Auth`.
   
     In the :guilabel:`Private key file for authentication` field, choose your .ppk file.

     .. figure:: ../_static/images/admin_password2.png

     Click :guilabel:`Open`.

     If a host key warning appears, click :guilabel:`OK`.

     The terminal screen displays: ``login as:``.

     Type ``admin`` and press Enter.

2. To change to the ``tmsh`` prompt, type:

   .. code-block:: console

      tmsh

3. Modify the admin password:

   .. code-block:: console

      modify auth password admin

   The terminal screen displays the message:

   .. code-block:: console

      changing password for admin
      new password:

4. Type the new password and press Enter.

   The terminal screen displays the message:

   .. code-block:: console

      confirm password

5. Re-type the new password and press Enter.
6. Ensure that the system retains the password change and press Enter.

   .. code-block:: console

      save sys config

   The terminal screen displays the message:

   .. code-block:: console

      Saving Ethernet mapping...done