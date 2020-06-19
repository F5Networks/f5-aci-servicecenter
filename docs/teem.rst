TEEM – F5 ACI ServiceCenter data usage collection
=================================================

The purpose of this feature is to provide anonymous usage analytics to F5 by using the F5 TEEM infrastructure. As a part of this feature, usage data is collected once per day regarding F5 ACI ServiceCenter usage, and a report is sent to the TEEM data collection servers, where the usage data is further analyzed.

.. IMPORTANT::

  This does not include any customer specific data such as BIG-IP device IPs or hostnames.

View TEEM Schedule
``````````````````

1. Click the user menu in the top-right corner.

2. Click **Settings > TEEM Settings**

3. This displays **TEEM Schedule**: :guilabel:`Time` (time of the day) and :guilabel:`Time zone`. This corresponds to the time/timezone when the TEEM report is built and sent daily to the TEEM server. 


Update TEEM Schedule
````````````````````

1. Click the user menu in the top-right corner.

2. Click **Settings > TEEM Settings**

3. This displays **TEEM Schedule**: :guilabel:`Time` (time of the day) and :guilabel:`Time zone`. This corresponds to the time/timezone when the TEEM report is built and sent daily to the TEEM server. 

4. Change the :guilabel:`Time` (HH:MM AM/PM) and :guilabel:`Time zone` to suitable values (for e.g. set the values to a time when the setup is not busy)


Disable TEEM 
`````````````

1. Click the user menu in the top-right corner.

2. Click **Settings > TEEM Settings**

3. This displays **TEEM Schedule**. The TEEM schedule display also has a toggle switch named :guilabel:`Disable` <--> :guilabel:`Enable`. To opt-out of data collection for usage analytics, set it to :guilabel:`Disable` (Gray). Once disabled, TEEM reports will not be sent.

Note: To re-enable TEEM, set it to :guilabel:`Enable` (Green).
