You must enter license information before you can use BIG-IP VE.

1. Open a web browser and log in to the BIG-IP Configuration utility by using ``https`` with the external IP address and port 8443, for example: ``https://<external-ip-address>:8443``.
   The username is ``admin`` and the password is the one you set previously.

2. On the Setup Utility Welcome page, click :guilabel:`Next`.
3. On the General Properties page, click :guilabel:`Activate`.
4. In the :guilabel:`Base Registration key` field, enter the case-sensitive registration key from F5.

   For :guilabel:`Activation Method`, if you have a production or Eval license, choose :guilabel:`Automatic` and click :guilabel:`Next`.

   If you chose :guilabel:`Manual`, complete these steps:

   A. In the :guilabel:`Step 1: Dossier` field, copy all of the text and then click :guilabel:`Click here to access F5 Licensing Server`.

      .. figure:: ../_static/images/license1.png

      A separate web page opens.

   B. On the new page, click :guilabel:`Activate License`.
   C. In the :guilabel:`Enter your dossier` field, paste the text and click :guilabel:`Next`.

      .. figure:: ../_static/images/license2.png

   D. Accept the agreement and click :guilabel:`Next`.
   E. On the Activate F5 Product page, copy the license text in the box. Now go back to the BIG-IP Configuration utility and paste the text into the :guilabel:`Step 3: License` field.

      .. figure:: ../_static/images/license3.png

   F. Click :guilabel:`Next`.

The BIG-IP VE system registers the license and logs you out. When the configuration change is successful, click :guilabel:`Continue` to provision BIG-IP VE.