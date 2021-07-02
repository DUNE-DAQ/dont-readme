# DUNE DAQ Software Documentation Home

Welcome! The purpose of this website is to provide information on how to use the applications, plugins, base classes, etc. offered by the suite of DUNE DAQ packages. You can learn both how to run the DAQ as well as use various tools to extend its functionality. 

If you're new to DUNE DAQ software, you'll want to start by reading the [daq-buildtools documentation](packages/daq-buildtools/README.md), which covers [how to set up a development environment](packages/daq-buildtools/README.md#Setup_of_daq-buildtools) and [build a package](packages/daq-buildtools/README.md#Cloning_and_building). Once you've done this, you'll likely want to learn about [how to write DAQ modules](packages/appfwk/README.md#Writing_DAQ_modules) in the [appfwk documentation](packages/appfwk/README.md), units of code which
are meant to perform specific tasks and can be combined to define the overall behavior of a running DAQ application. At some point you may also need to learn about how to create a package from scratch by reading the [daq-cmake documentation](packages/daq-cmake/README.md); this documentation is also very useful for understanding how to get new source code files you've added to compile.  

There are four DUNE DAQ software packages which are used to aid
developers in creating packages designed for the DAQ itself:

To learn how to build an existing software package, read the [daq-buildtools documentation](packages/daq-buildtools/README.md)

To learn how to create a new package or modify the build of an existing one, read the [daq-cmake documentation](packages/daq-cmake/README.md)

To learn about the standard development workflow, read the [daq-release documentation](packages/daq-release/README.md), in particular [this page](https://dune-daq-sw.readthedocs.io/en/latest/packages/daq-release/development_workflow_gitflow/)

To learn about the C++ coding guidelines which DUNE DAQ package developers should follow, read [the styleguide](packages/styleguide/README.md)

--------------

For the other packages, please click on one of the links below. To learn how to edit a package's documentation, click [here](editing_package_documentation.md). Packages marked with an asterix don't yet have any official documentation; please see their Issues page to remedy this. 

### Core

[appfwk](packages/appfwk/README.md) _home of_ daq_application _and tools for writing DAQModules_

[cmdlib](packages/cmdlib/README.md) _interfaces for commanded objects_

[ers](packages/ers/README.md) _fork of the ATLAS Error Reporting System_

[logging](packages/logging/README.md) _contains the functions DUNE DAQ packages use to output text_

### Readout

[dataformats](packages/dataformats/README.md) _raw data reinterpretation utilities_

[flxlibs](packages/flxlibs/README.md) _DAQModules, utilities, and scripts for Upstream FELIX Readout Software_

[readout](packages/readout/README.md) _upstream DAQ readout, DAQModules, CCM interface implementations_

### Control

[minidaqapp](packages/minidaqapp/README.md) _application to read out Felix data and store it in HDF5 files on disk_

[nanorc](packages/nanorc/README.md) _Not ANOther Run Control_

[* rcif](packages/rcif/README.md) _run control related_

[restcmd](packages/restcmd/README.md) _HTTP REST backend based CommandFacility_

### Dataflow (logical)

[dfmessages](packages/dfmessages/README.md) _dataflow messages_

[dfmodules](packages/dfmodules/README.md) _dataflow applications_

[timing](packages/timing/README.md) _C++ interface to the timing firmware_

[timinglibs](packages/timinglibs/README.md) _timing control and monitoring_

[trigemu](packages/trigemu/README.md) _trigger decision emulator for readout application tests_

[trigger](packages/trigger/README.md) _modules that make up the DUNE FD DAQ trigger system_

### Dataflow (physical)

[ipm](packages/ipm/README.md) _message passing between processes_

[nwqueueadapters](packages/nwqueueadapters/README.md) _DAQModules that connect appfwk queues to IPM network connections_

[serialization](packages/serialization/README.md) _utilities for C++ object serialization/deserialization_

### Monitoring

[erses](packages/erses/README.md) _insert ERS messages into a searchable database_

[influxopmon](packages/influxopmon/README.md) _Influx database based plugin for operational monitoring_

[opmonlib](packages/opmonlib/README.md) _operational monitoring library_



### Educational

[listrev](packages/listrev/README.md) _educational example of DAQModules for new developers_

------

_Mar-11-2021: For software coordinators only:_ [how to make edits to this webpage](how_to_make_edits.md)

