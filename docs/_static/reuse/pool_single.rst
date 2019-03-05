Traffic goes through BIG-IP VE to a pool. Your application servers should be members of this pool.

1. Open a web browser and go to the BIG-IP Configuration utility, for example: ``https://<external-ip-address>:8443``.
2. On the Main tab, click :menuselection:`Local Traffic -> Pools`.
3. Click :guilabel:`Create`.
4. In the :guilabel:`Name` field, type ``web_pool``.
   Names must begin with a letter, be fewer than 63 characters, and can contain only letters, numbers, and the underscore (_) character.
5. For Health Monitors, move ``https`` from the :guilabel:`Available` to the :guilabel:`Active` list.
6. Choose the load balancing method or retain the default setting.
7. In the New Members section, in the :guilabel:`Address` field, type the IP address of the application server.
8. In the :guilabel:`Service Port` field, type a service port, for example, ``443``.
9. Click :guilabel:`Add`.

   The list now contains the member.

10. Add additional pool members as needed and click :guilabel:`Finished`.