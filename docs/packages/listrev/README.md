# listrev

The listrev package allows to excercise the basic functioning of DAQ applications, through three simple DAQ Modules that operate on lists of numbers.

In order to run it, setup the runtime environment for hte DAQ version you are using.

To generate a valid configuration file you can issue the following command:
`python -m listrev.app_confgen`

A json file, called *listrev-app.json* will be created in you working directory.

To run the application issue the following command:
`daq_application -n pippo -c stdin://listrev-app.json`

You can now send run control commands to the application, as indicated in the prompt.



-----

<font size="1">
_Last git commit to the markdown source of this page:_


_Author: glehmannmiotto_

_Date: Tue Apr 13 16:42:06 2021 +0200_

_If you see a problem with the documentation on this page, please file an Issue at [https://github.com/DUNE-DAQ/listrev/issues](https://github.com/DUNE-DAQ/listrev/issues)_
</font>
