# logging
DUNE DAQ logging package

This package is mainly based on ERS and secondarily based on TRACE.
The primary user documentation starting point for the DUNE fork of ERS is found on the official DUNE DAQ software website [here](https://dune-daq-sw.readthedocs.io/en/latest/packages/ers/).
One link to TRACE information can be found [here](https://cdcvs.fnal.gov/redmine/projects/trace/wiki).

ERS provides:
- Assertion Macros
- Macros for declaring Custom Issues
- 6 logging streams and corresponding methods to work with (i.e. send to) them.
- a mechanism to configure destination(s) for each of 6 loggings streams

ERS also provides Logging Macros, but these have been removed in the DUNE DAQ fork.

TRACE provides:
- several macros to implement stream-style logging to different logging levels.
- slow and fast-path logging
- a mechanism to configure the slow-path logging, i.e to use ERS as the slow-path logging.

<details><summary>One of the ERS *destinations* for first 4 of the 6 loggings
*streams* will be a "TRACE fast path destination."</summary>
The Logging package setup function will ensure that the environment variables DUNEDAQ_ERS_{FATAL,ERROR,WARNING,INFO} (used to configure the stream destinations) will contain the "TRACE fast path destination." It is expected/required that all applications will call the Logging package setup function.</details>

Only two of the TRACE logging macros (TLOG() and TLOG_DEBUG()) will be used and TRACE will be configured to use ERS for the slow-path logging.

Users will be able to use the Assertion Macros from ERS. They will also use macros to declare Custom Issues. The issues can be used in logging and exception processing.

For logging, the six ERS "streams" (fatal, error, warning, info, log and debug) will be accessed using
the ers methods for the first 4 and TRACE macros for the last 2 as follow:

1. ers::fatal( ers::Issue );
2. ers::error( ers::Issue );
3. ers::warning( ers::Issue );
4. ers::info( ers::Issue );
5. TLOG()       << ers::Issue or basic string/args
6. TLOG_DEBUG(lvl)  << ers::Issue or basic string/args

Conventions and best practices for ERS issues in the DUNE DAQ software can be found [here](ers-conventions.md).

The above referenced conventions and best practices does not cover the use of the TRACE macros.

The TLOG() macro should used in cases similar to ers::info with the following 2 distinctions: 1) unstructed (non-ers::Issue) messages can be used and 2) logging will remain local, i.e. stdout only and not to a central/network logging facility.

The TLOG_DEBUG(lvl) is to be used for messages which will be selectively enabled or disabled for debugging purposes. The lvl can be an arbitrary integer between 0 and 55.

The TLOG_DEBUG(lvl) macro accepts an optional "name" parameter which defaults to the basename of the compilation file minus the extension. The level and name combination is ultimately used to enable and disable specific TLOG_DEBUG statements.

# ERS/Slow-path configuration

By default, all ERS severities are configured to have at least standard out or standard error as a destination.
This means that all fatal, error, warning, info and log messages will go to "the console" (standard out or standard error).


# Controlling the DEBUG macros

As stated above, the TRACE TLOG_DEBUG(lvl) macro can be used for slow and fast path logging where the slow path is ERS to stdout and the fast path is TRACE to a circular memory buffer/file.

## Slow-path debug messages

Since "debug" messages (via `TLOG_DEBUG(dbglvl) << <Issue_or_message>`) are controlled by TRACE, they ultimately have to be enabled by TRACE. TRACE will only give these messages to ERS if the trace debug message is enabled. THEN, ERS will only send the debug messages to the standard out stream if the debug level (normally set via the environment variable DUNEDAQ_ERS_DEBUG_LEVEL) is less than or equal to the configured "debug level" (the default is zero).  Because this double enabling can be confusing, all applications should call the `dunedaq::logging::Logging::setup()` function, which will make sure the DUNEDAQ_ERS_DEBUG_LEVEL value is set appropriately.

The environment variable TRACE_LVLS can be used to enable/disable all DEBUG statements to the slow-path at particular levels. One common use is to enable all message to the slow path with the value of -1 (i.e. `export TRACE_LVLS=-1`).

NOTE: TRACE allows individual levels to be enabled/disabled via the setting or clearing of bits in a 64-bit mask. TRACE has the concept of "system levels" and "debug levels." "debug levels" are a subset of "system levels." "System levels" 8-63 correspond to "debug levels" 0 through 55. So ultimately, TLOG_DEBUG(<dbg_lvl>) supports dbg_lvl from 0 to 55. This should not be overly restrictive because there are 56 controllable levels per TRACE NAME (which normally corresponds to a file).

## Fast-path debug messages

The environment variable TRACE_LVLM does the same for the fast path.


## Slow/Fast-path debug messages

The TRACE_NAMLVLSET environment varibale can be used to enable/disable specific TLOG_DEBUG statements by setting the value to lines with the format "name,lvlSmsk,lvlMmsk".



Alternatively, the TRACE_FILE environment can be used to specific the name a memory buffer and control file. The control structure contained in this file can be used to enable/disable specific TLOG_DEBUG statements in a non-volatile manor.

The recommended location for a trace buffer and control file is in the /tmp/ directory. For example: `export TRACE_FILE=/tmp/trace_buffer_$USER`

Once the TRACE_FILE environment variable is set in the application's environment,
the same value can be set in an interactive session on the same node to dynamically enable/disable application TLOG_DEBUG statements via TRACE command line functions.  Note the same TRACE_FILE can be used for all applications running on a particular node.


When the non-volatile (memory mapped trace file) configuration is active, several TRACE command-line functions can be used:
* `tlvls` -- this command outputs a list of all the TRACE names that are currently known, and which levels are enabled for each name
* `tonSg <level>` enables the specified level for *all* TRACE names (the "S" means Slow Path and the "g" means global in this context)
* `tonS -n <TRACE NAME> <level>` enables the specified level for the specified TRACE name
* `toffSg <level>` disables the specified level for *all* TRACE names
* `toffS -n <TRACE NAME> <level>` disables the specified level for the specified TRACE name


All the TLOG_DEBUG statements for all the applications using the same TRACE_FILE can be enabled via:
```
tonMg debug-debug+55  # "M" for fast/Memory
tonMg debug-debug+55  # "S" for Slow/Stdout
```

## Enabling/Disabling Slow Path (ERS) DEBUG messages dynamically

Assuming non-volatile tracing is enabled as described above. The enabling and disabling of debug messages can be done dynamically while the application is running if the trace functions mentioned above are run from a different command window on the same system if the TRACE_FILE environment variable is set to the same value.



## Showing TRACE/debug memory "live" in another terminal window with color

```
export TRACE_SHOW='%H%x%T %P %i %C %e %O%.3L %m%o'   # remove index, add linenumber and add color to output
tshow -F | PAGER= TRACE_TIME_FMT='%Y-%b-%d %H:%M:%S,%%06d' tdelta -ct 0 -d 0 -i
```
The NFO lines below should/will be green with an actual show...
```
/home/ron/work/DUNEPrj/AD2021-02-10_minidaq_develop/MyTopDir/sourcecode/readout
(dbt-pyvenv) ron@mu2edaq13 :^) tshow -F | PAGER= TRACE_TIME_FMT='%Y-%b-%d %H:%M:%S,%%06d' tdelta -ct 0 -d 0 -i
                     us_tod       delta     pid     tid cpu                                  trcname:ln# lvl msg                     
           ---------------- ----------- ------- ------- --- -------------------------------------------- --- ------------------------
2021-Feb-12 07:41:05,307233           0  193161  193290  23                         FragmentReceiver:286 D05 do_work: ffr: Exiting do_work() method
2021-Feb-12 07:41:05,307302          69  193161  193205  21                         FragmentReceiver:135 LOG do_stop: ffr successfully stopped
2021-Feb-12 07:41:05,307324          22  193161  193205  21                         FragmentReceiver:136 D05 do_stop: ffr: Exiting do_stop() method
2021-Feb-12 07:41:05,307378          54  193161  193205  21                               DataWriter:136 D05 do_stop: datawriter: Entering do_stop() method
2021-Feb-12 07:41:05,307408          30  193161  193205  21                       TriggerInhibitAgent:54 D05 stop_checking: datawriter::TriggerInhibitAgent: Entering stop_checking() method
2021-Feb-12 07:41:05,407599      100191  193161  193288  11                      TriggerInhibitAgent:171 D05 do_work: datawriter::TriggerInhibitAgent: Exiting do_work() method
2021-Feb-12 07:41:05,407781         182  193161  193205  21                       TriggerInhibitAgent:57 D05 stop_checking: datawriter::TriggerInhibitAgent: Exiting stop_checking() method
2021-Feb-12 07:41:05,411199        3418  193161  193289  11                               DataWriter:279 D05 do_work: datawriter: Exiting do_work() method
2021-Feb-12 07:41:05,411334         135  193161  193205  21                               DataWriter:149 D05 do_stop: datawriter: Exiting do_stop() method
2021-Feb-12 07:41:05,411360          26  193161  193205  21                      restCommandFacility:100 NFO completion_callback: Need to add HTTP reply with result: OK

```




