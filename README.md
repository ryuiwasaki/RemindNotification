RemindNotification
==================
# Remind User to Launch Application
This class remind user to launch application.
Call notification to user for each time was specified. 

#How to Use
## Message set in 'initWithMessages:intervalSecond:' or 'initWithMessages:intervalDay:' method
Messages is NSArray class.
Messages indicate Story of Remind user with the passage of time.

## Call 'Request' method
'Request' method enter scheduleLocalNotification for each time of number of story.

## Cancel is 'reset'