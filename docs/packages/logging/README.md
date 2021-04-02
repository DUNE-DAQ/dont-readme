# logging README
# logging
DUNE DAQ logging package

This package is mainly based on ERS and secondarily based on TRACE.
One link to ERS information can be found [here](https://atlas-tdaq-monitoring.web.cern.ch/OH/refman/ERSHowTo.html).
One link to TRACE information can be found [here](https://cdcvs.fnal.gov/redmine/projects/trace/wiki).
ERS github repo is [here](https://github.com/DUNE-DAQ/ers).

ERS provides:
- Assertion Macros
- Macros for declaring Custom Issues
- 6 logging streams and corresponding methods to work with (i.e. send to) them.
- a mechanism to configure destination(s) for each of 6 loggings streams

ERS also provides Logging Macros, but these will not be used. One of the ERS destinations for 4 of the 6 loggings
streams will be a "TRACE fast path destination."

TRACE provides:
- several macros to implement stream-style logging to different logging levels.
- slow and fast path logging
- a mechanism to configure the slow path logging.

Only two of the TRACE logging macros will be used and TRACE will be configured to use ERS for the slow-path logging.

Users will be able to use the Assertion Macros from ERS. They will also use macros to declare Custom Issues. The issues can be used in logging and exception processing.

For logging, the six ERS "streams" (fatal, error, warning, info, log and debug) will be accessed using
the ers methods or the TRACE macros as follow:



1. ers::fatal( ers::Issue );


2. ers::error( ers::Issue );


3. ers::warning( ers::Issue );


4. ers::info( ers::Issue );


5. TLOG_LOG()       << ers::Issue or basic string/args


6. LOG_DEBUG(lvl)  << ers::Issue or basic string/args

Further, version specific, information can be found at https://github.com/DUNE-DAQ/logging/wiki
