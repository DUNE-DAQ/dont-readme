# Simple instructions for running the app
For reference, here is a presentation by Phil Rodrigues that describe the characteristics of the first version of the MiniDAQApp:  [https://indico.fnal.gov/event/47339/](https://indico.fnal.gov/event/47339/contributions/206365/attachments/139034/174369/minidaqapp-update-2021-01-20.pdf)

### Quick-start instructions
```
git clone https://github.com/DUNE-DAQ/daq-buildtools.git -b v2.0.1 # Just once
source daq-buildtools/dbt-setup-env.sh
```
NOTE: 
All you want to know and more about setting up work areas is available here: [instructions for dunedaq-v2.2.0](https://github.com/DUNE-DAQ/appfwk/wiki/Compiling-and-running-under-v2.2.0)
```
mkdir work
cd work
dbt-create.sh dunedaq-v2.2.0
dbt-setup-runtime-environment
curl https://cernbox.cern.ch/index.php/s/VAqNtn7bwuQtff3/download -o frames.bin
python -m minidaqapp.fake_app_confgen -d ./frames.bin -o '.' my_minidaq_config.json
daq_application -c stdin://./my_minidaq_config.json
```
a sample command sequence would be: `init`, `conf`, `start`, `resume`, `stop`, `scrap`. Use `<ctrl-c>` to exit the app.

### Preparing to run the application for the first time

The minimal set of instructions for running the app using pre-built software:


1. create a new software area using the [instructions for dunedaq-v2.2.0](https://github.com/DUNE-DAQ/appfwk/wiki/Compiling-and-running-under-v2.2.0)


1. cd into your work area


1. `dbt-setup-runtime-environment`


1. download and rename the raw data file ([CERNBox link](https://cernbox.cern.ch/index.php/s/VAqNtn7bwuQtff3/download)) and put it into ./ (if you put the data anywhere else or with a different filename you'll need to specify that location and filename when you create your configuration file in the next step)


1. generate your configuration: 
    * `python -m minidaqapp.fake_app_confgen -d ./frames.bin -o '.' my_minidaq_config.json`
    * (the full set of available options can be seen using `python -m minidaqapp.fake_app_confgen --help`)


1. `daq_application -c stdin://./my_minidaq_config.json`
    * a sample command sequence would be: `init, conf, start, resume, stop, scrap`.  Use &lt;ctrl-c&gt; to exit the app.
    * &#x1F538;Please Note&#x1F538; that you will need to delete the HDF5 file that is created in ./ (or wherever directory you have configured for the data file writing) after every time that you run this command since the current DataWriter does not allow existing files to be over-written.
    * &#x1F538;Please Note&#x1F538; Triggers will not be generated until after a `resume` command is issued (no pause is necessary, so the order of commands to issue is: init, conf, start, resume)
    * &#x1F538;Please Note&#x1F538; the default configuration will generate trigger records with 2 links each, at 1 Hz.  These parameters can be modified, however, by re-generating the configuration with suitable arguments to `python -m minidaqapp.fake_app_confgen`.

To take the next step of making changes to the code, these additional steps can be used:


1. cd into your work area


1. `cd sourcecode`


1. clone the repository(ies) that you are interested in
    * e.g. `git clone https://github.com/DUNE-DAQ/dfmodules.git`


1. `cd ..`


1. `dbt-setup-build-environment`


1. `dbt-build.sh --install`


1. use the steps above to setup the runtime environment, re-generate the configuration, and run the app

### Changing the trigger rate dynamically



1. In order to generate a new configuration file you can issue this command:
    * `python -m minidaqapp.fake_app_confgen -d ./frames.bin -o '.' -t <trigger_rate_hz> my_minidaq_config.json`


1. If you wish to change rate in the course of a run, this is best done using the REST command interface for command distribution.
    * Open 2 terminals (let's assume on the same host) and go into your work area (remember to setup the runtime environment!); 
    * In one terminal run: `daq_application -c rest://localhost:12345`;
    * In the other terminal run: `python `which send-restcmd.py` --interactive --file ./my_minidaq_config.json`;
    * give the run control commands in the second terminal and start the run;
    * Ctrl-c the python application, change the trigger rate.
    * run again: ```send-restcmd.py --interactive --file ./my_minidaq_config.json```;
    * send the *pause* and then the *resume* commands.

### Steps to enable and view ERS and TRACE debug messages 

In the code, we have added ERS and TRACE statements to provide additional debugging information beyond what is output with ERS_LOG and ERS_INFO.  

To enable ERS debug messages, use `export TDAQ_ERS_DEBUG_LEVEL=N` to display messages up to and including N.  These messages are printed to the console.

Here are suggested steps for enabling TRACE debug statements:

* `export TRACE_FILE=<MyTopDir>/log/<MyUserName>_dunedaq.trace`
    * for example, `export TRACE_FILE=/afs/cern.ch/work/b/biery/public/dunedaq/current/log/biery_dunedaq.trace`

* run the application using the `daq_application` command above
    * this populates the list of already-enabled TRACE levels so that you can view them in the next step

* run `tlvls`
    * this command outputs a list of all the TRACE names that are currently known, and which levels are enabled for each name

* enable levels with `tonM -n <TRACE NAME> <level>`
    * for example, `tonM -n DataWriter DEBUG+17`

* re-run `tlvls` to confirm that the expected level is now set

* re-run the application

* view the TRACE messages using `tshow | tdelta -ct 1 | more`
    * note that the messages are displayed in reverse time order

A couple of additional notes:

* For user-defined TRACE debug messages, the "level" that is displayed in the 7th column of the `tshow` output is relative to TLVL_DEBUG.  If we use the TLVL_DEBUG offset when specifying levels in our code, then it should be easy to translate between what we see in the code and what we see from `tshow`.  Otherwise, please be aware of the offset.  And, of course, when we look at the enabled levels with `tlvls`, we will need to remember to take into account the offset (which appears to be 8).

* There are many other TRACE 'commands' that allow you to enable and disable messages.  For example,
    * `tonMg <level>` enables the specified level for *all* TRACE names (the "g" means global in this context)
    * `toffM -n <TRACE NAME> <level>` disables the specified level for the specified TRACE name
    * `toffMg <level>` disables the specified level for *all* TRACE names
    * `tlvlM -n <TRACE name> <mask>` enables all of the levels specified in the bitmask

### Instructions to use the `hdf5_dump.py` tool
The tool can be used to parse both TriggerRecordHeaders and FragmentHeaders. There is also a sample HDF5 output file in the `dfmodules/scripts` repository.
To run the script:

* For TriggerRecordHeaders:  `python3 $DFMODULES_FQ_DIR/dfmodules/bin/hdf5dump/hdf5_dump.py -TRH -f <filename>`

* For FragmentHeaders:  `python3 $DFMODULES_FQ_DIR/dfmodules/bin/hdf5dump/hdf5_dump.py -H -f <filename>`

* (To see the full list of available options:  `python3 $DFMODULES_FQ_DIR/dfmodules/bin/hdf5dump/hdf5_dump.py --help`)