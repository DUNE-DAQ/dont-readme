# Instructions for setting up a v2.4.0 development environment
### Instructions for setting up a v2.3.0 software area for v2.4.0 development
08-Mar-2021

&#x1F53A;Note&#x1F53A; that there is a script available that takes care of steps 2-4.  That script is [here](https://raw.githubusercontent.com/DUNE-DAQ/minidaqapp/feature/SampleSetupScript/scripts/setup_mdapp_env_for_2.4.sh) (it's in the _minidaqapp_ repo, on the _feature/SampleSetupScript_ branch, in the _scripts_ subdir). 

To run it, please **source** it (e.g. `source <filename>`) and do this from the top level of your new software area (i.e. `MyTopDir`).

&#x1F53A;Note:&#x1F53A; For now the configuration of OPMON is managed through environment variables: DUNEDAQ_OPMON_INTERVAL sets the interval in seconds between calling get_info (0 means disabled!), DUNEDAQ_OPMON_LEVEL allows to set the level for get_info. Note that get_info is called on the DAQ modules only in states CONFIGURED/RUNNING.



1. create a new software area using the [instructions for dunedaq-v2.3.0](https://github.com/DUNE-DAQ/appfwk/wiki/Compiling-and-running-under-v2.3.0) (very roughly: `source daq-buildtools/dbt-setup-env.sh`, `cd <work_dir>`, `dbt-create.sh dunedaq-v2.3.0`  )
    * &#x1F53A;Please Note&#x1F53A; that you should update the version of your existing daq-buildtools cloned area to tag v2.2.1.


1. add the following repositories to the /sourcecode area:
    * `cd sourcecode`
    * `git clone https://github.com/DUNE-DAQ/dataformats.git -b v2.0.0`
    * `git clone https://github.com/DUNE-DAQ/dfmessages.git -b v2.0.0`
    * `git clone https://github.com/DUNE-DAQ/dfmodules.git -b v2.0.0`
    * `git clone https://github.com/DUNE-DAQ/flxlibs.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/ipm.git -b v2.0.0`
    * `git clone https://github.com/DUNE-DAQ/nwqueueadapters.git -b v1.1.0`
    * `git clone https://github.com/DUNE-DAQ/readout.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/restcmd.git -b develop` # (optional)
    * `git clone https://github.com/DUNE-DAQ/serialization.git -b v1.1.0`
    * `git clone https://github.com/DUNE-DAQ/trigemu.git -b v2.0.0`
    * `git clone https://github.com/DUNE-DAQ/minidaqapp.git -b v1.4.0`
    * `cd ..`


1. Update `dbt-settings`:
    1. Uncomment lines of `#/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products` and `#/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products_dev`;
    1. Add line `"felix v1_1_0 e19:prof"`


1. Update `sourcecode/dbt-build-order.cmake` to:
```
set(build_order "daq-cmake" "ers" "logging" "cmdlib" "rcif" "restcmd" "opmonlib" "appfwk" "listrev" "daqdemos" "ipm" "serialization" "nwqueueadapters" "dataformats" "dfmessages" "dfmodules" "readout" "flxlibs" "trigemu" "minidaqapp")
```


5. `dbt-setup-build-environment`


1. `dbt-build.sh --install`


1. `dbt-setup-runtime-environment`


1. download a raw data file ([CERNBox link](https://cernbox.cern.ch/index.php/s/VAqNtn7bwuQtff3/download)) and put it into ./ (if you put the data anywhere else you'll need to modify the json file accordingly).


1. `python -m minidaqapp.fake_app_confgen -d ./frames.bin -o '.' my_minidaq_config.json`


1. `daq_application --name mdapp_test -c stdin://./my_minidaq_config.json`
    * &#x1F538;Please Note&#x1F538; Triggers will not be generated until after a `resume` command is issued (no pause is necessary, so the order of commands to issue is: init, conf, start, resume)
    * &#x1F538;Please Note&#x1F538; this configuration should generate trigger records with 2 links each, at 1 Hz.
    * we can also use a different configuration that uses fake data sources
        * `python -m dfmodules.testapp_noreadout_confgen -d ./frames.bin -o '.' ./testapp_noreadout_config.json`
        * `daq_application --name mdapp_test -c stdin://./testapp_noreadout_config.json`


<!--


1. add the following repositories to the /sourcecode area:
    * `cd sourcecode`
    * `git clone https://github.com/DUNE-DAQ/daq-cmake.git -b v1.3.1`
    * `git clone https://github.com/DUNE-DAQ/ers.git -b v1.1.0`
    * `git clone https://github.com/DUNE-DAQ/logging.git -b v1.0.0`
    * `git clone https://github.com/DUNE-DAQ/cmdlib.git -b v1.1.1`
    * `git clone https://github.com/DUNE-DAQ/rcif.git -b v1.0.1`
    * `git clone https://github.com/DUNE-DAQ/appfwk.git -b v2.2.0`
    * `git clone https://github.com/DUNE-DAQ/listrev.git -b v2.1.1` #(optional)
    * `git clone https://github.com/DUNE-DAQ/dataformats.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/dfmessages.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/dfmodules.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/flxlibs.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/ipm.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/nwqueueadapters.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/opmonlib.git -b v1.0.0`
    * `git clone https://github.com/DUNE-DAQ/readout.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/restcmd.git -b develop` # (optional)
    * `git clone https://github.com/DUNE-DAQ/serialization.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/trigemu.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/minidaqapp.git -b develop`
    * `cd ..`


1. Update `dbt-settings`:
    1. Uncomment `products` and `products_dev` lines
    1. Replace zmq line with `"zmq v4_3_1c e19:prof"`
    1. Add line `"cppzmq v4_3_0 e19:prof"`
    1. Add line `"msgpack_c v3_3_0 e19:prof"`
    1. Add line `"felix v1_1_0 e19:prof"`


1. Update `sourcecode/dbt-build-order.cmake` to:
```
set(build_order "daq-cmake" "ers" "logging" "cmdlib" "rcif" "restcmd" "opmonlib" "appfwk" "listrev" "daqdemos" "ipm" "serialization" "nwqueueadapters" "dataformats" "dfmessages" "dfmodules" "readout" "flxlibs" "trigemu" "minidaqapp")
```


5. Update the version of `moo` in your environment
    1. `dbt-setup-build-environment`
    1. `pip uninstall moo && pip install https://github.com/brettviren/moo/archive/0.5.5.tar.gz`
        * This will prompt you to confirm that you really want to do this, so you need to reply "y"...


1. `dbt-setup-build-environment`


1. `dbt-build.sh --install`


1. `dbt-setup-runtime-environment`


1. download a raw data file ([CERNBox link](https://cernbox.cern.ch/index.php/s/VAqNtn7bwuQtff3/download)) and put it into ./ (if you put the data anywhere else you'll need to modify the json file accordingly).


1. `python -m minidaqapp.fake_app_confgen -d ./frames.bin -o '.' my_minidaq_config.json`


1. `daq_application --name mdapp_test -c stdin://./my_minidaq_config.json`
    * &#x1F538;Please Note&#x1F538; Triggers will not be generated until after a `resume` command is issued (no pause is necessary, so the order of commands to issue is: init, conf, start, resume)
    * &#x1F538;Please Note&#x1F538; this configuration should generate trigger records with 2 links each, at 1 Hz.
    * we can also use a different configuration that uses fake data sources
        * `python -m dfmodules.testapp_noreadout_confgen -d ./frames.bin -o '.' ./testapp_noreadout_config.json`
        * `daq_application --name mdapp_test -c stdin://./testapp_noreadout_config.json`
-->

<!--
### Draft instructions for setting up a v2.3.0 software area for v2.4.0 development



1. create a new software area using the [instructions for dunedaq-v2.3.0](https://github.com/DUNE-DAQ/appfwk/wiki/Compiling-and-running-under-v2.3.0) (very roughly: `source daq-buildtools/dbt-setup-env.sh`, `cd <work_dir>`, `dbt-create.sh dunedaq-v2.3.0`  )
    * &#x1F53A;Please Note&#x1F53A; that you should update the version of your existing daq-buildtools cloned area to tag v2.2.1.


1. add the following repositories to the /sourcecode area:
    * `cd sourcecode`
    * `git clone https://github.com/DUNE-DAQ/dataformats.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/dfmessages.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/dfmodules.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/flxlibs.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/ipm.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/nwqueueadapters.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/readout.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/restcmd.git -b develop` # (optional)
    * `git clone https://github.com/DUNE-DAQ/serialization.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/trigemu.git -b develop`
    * `git clone https://github.com/DUNE-DAQ/minidaqapp.git -b develop`
    * `cd ..`


1. Update `dbt-settings`:
    1. Uncomment lines of `#/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products` and `#/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products_dev`;
    1. Add line `"felix v1_1_0 e19:prof"`


1. Update `sourcecode/dbt-build-order.cmake` to:
```
set(build_order "daq-cmake" "ers" "logging" "cmdlib" "rcif" "restcmd" "opmonlib" "appfwk" "listrev" "daqdemos" "ipm" "serialization" "nwqueueadapters" "dataformats" "dfmessages" "dfmodules" "readout" "flxlibs" "trigemu" "minidaqapp")
```


1. `dbt-setup-build-environment`


1. `dbt-build.sh --install`


1. `dbt-setup-runtime-environment`


1. continue as described above...

-->

<!-- 



1. If you wish to change rate in the course of a run, this is best done using the REST command interface for command distribution. To do this you should have built the restcmd package, together with the rest of the software.
    * Open 2 terminals (let's assume on the same host); 
    * In one terminal run: `daq_application -c rest://localhost:12345`;
    * In the other terminal run: `send-restcmd.py --interactive --file ./minidaq-app-fake-readout.json`;
    * give the run control commands in the second terminal and start the run;
    * Ctrl-c the python application, change the trigger rate using the instructions of the next section.
    * run again: `send-restcmd.py --interactive --file ./minidaq-app-fake-readout.json`;
    * send the *pause* and then the *resume* commands.

### Suggestions for modifying the configuration

The configuration jsonnet file has been prepared in a way that it allows to easily change the parameters that users will want to change often. Those are: the run number, the number of data links, the trigger rate, the downscaling in clock frequency (to run on slow/shared hosts).

In order to generate a new configuration file you can issue this command, from your work area:

`moo -M ./install/minidaqapp/share/schema/minidaqapp -A TRIGGER_RATE_HZ=1.0 -A RUN_NUMBER=333 -A NUMBER_OF_DATA_PRODUCERS=2 -A DATA_RATE_SLOWDOWN_FACTOR=10 compile minidaq-app-fake-readout.jsonnet > minidaq-app-fake-readout.json`

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
Install the h5py python module on your local machine, `sudo pip3 install h5py`, or in your _dunedaq_ development environment, `setup_build_environment; pip3 install h5py`.

The tool can be used to parse both TriggerRecordHeaders and FragmentHeaders. There is also a sample HDF5 output file in the `dfmodules/scripts` repository.
To run the script:

* For TriggerRecordHeaders:  `python3 hdf5_dump.py -f sample.hdf5 -TRH`

* For FragmentHeaders:  `python3 hdf5_dump.py -f sample.hdf5 -H`(dbt-pyvenv) [biery@mu2edaq13 minidaqapp.wiki]$ 
-->
