PlumberJack
===========

A demo app to display the appointments of a person which is fetched as a JSON from the web.

Main functionalities:
1) Checking appointments for a given day.
2) Adding appointments for a given day.


Features that can be incorporated in future.
1) Handling appointment changes happening at the last moment from the backend (considering that the backend providing the json is handled by another person).
      
      This is possible via two ways, Background fetch and Remote notifications. However, ours being a critical case which cannot wait for iOS to decide polling intervals for data changes, Background fetch is not a feasible option. So with Remote notification having a great use-case for pushing important content immediately, we choose this implementation.

      A remote notification is just a normal push notification but with the content-available flag set. In our case it will also make sense for us to send a push with an alert message with this data as it will have a better chance at being noticed by the user as chances of him noticing his phone regularly while attending hourly chores is quite improbable. While the alert is being shown to the user that there is some change in the appointment schedule, we also update the UI in the background to contain the changed content.

		There needs to be a mechanism at the backend which will trigger a remote notification via APNS whenever the person at the backend makes a change to his appointments in this case. Without getting into deeper details I would say a polling mechanism monitoring an item in the JSON containing the timestamp of last_updated for the JSON served might be a good way to handle it.


2) If the person wants alerts on his next appointment.

   If we consider that the person's appointments will be fully packed for a week, then we could use the NSLocalNotification to set the alerts hourly(or rather few minutes before each hour considering that each appointment is considered to be hourly). This could either be done in the code when the app is opened for the first time (and handled later to do hourly using repeatInterval) or done when the app goes to background mode as it can perform tasks for finite time before it gets suspended.

	Another approach to consider for this task would be via the remoteNotifications as discussed in the above question. This however will require a backend to perform the triggering of the APNS with content-available flag set to send the details of the notification as an alert, on an hourly basis a few minutes before every hour so that the alert serves its purpose.


3) If the default view should always be the current day.
     
    This implementation can be done as follows:

    The assumption in this approach is that at any point of time the JSON being fetched will contain items for only one week. This assumption is quite valid as keys are supposed to be unique in a dictionary and hence days across weeks cannot be supported.

   Here, we instantiate an object of the NSDateFormatter class and then set the format to @"EEEE" to get the the present day of the week as a string. This string is searched for in the weekArray that I have set in the code and its respective index is deduced. This index is set as the value for the selectedRow NSInteger as mentioned in the code. From here onward, the rest of the logic is handled in the code.

    Having the current implementation as the reference, we would have to shift the first view controller(PJViewcontroller) after the second view controller(PJTableViewController) in the storyboard and setup the segues appropriately and embed the PJTableViewController to the NavigationController. 

	The following is brief description of how this will be done:
		a) From the logic mentioned above, the present day of the week is deduced based on the date we get from NSDate with NSDateFormatter. For this day we get choose the mapped value in the mappedDictionary and make it the key to search in the appointDaysDictionary (Skipping the explanation for the intermediate appointDictionary here, as it is explained in the code and does not change)

		b) Using the appointments array that we obtain in the previous step, we populate the table view and the PJdetailsViewController remains the same.

		c) We also have a select day button in this case in the editButton position of the tableView which will perform a segue to the UIPickerView that we had repositioned. Here we can manually select the day and then trigger back a segue to the table view via a UIButton passing the day name along which will be processed in the table view controller and the table view will be repopulated. The PJdetailsViewController will remain the same in this flow too.