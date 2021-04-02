# listrev README
# listrev

The listrev package allows to excercise the basic functioning of DAQ applications, through three simple DAQ Modules that operate on lists of numbers.

In order to run it, setup the runtime environment for hte DAQ version you are using.

To generate a valid configuration file you can issue the following command:
`python -m listrev/app_confgen`

A json file, called *listrev-app.json* will be created in you working directory.

To run the application issue the following command:
`daq_application -n pippo -c stdin://listrev-app.json`

You can now send run control commands to the application, as indicated in the prompt.

