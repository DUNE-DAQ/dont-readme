# Coordination notes for v2.3.0 and v2.4.0
18-Feb-2021, KAB: notes on developments that need to be coordinated as we approach the dunedaq-v2.3.0 and v2.4.0 releases.



1. Changes that are local to a small number of repositories, and *aren't* waiting on anything

    1. local _dfmodules_ changes
    1. local _readout_ changes
    1. moving the raw data decoders to the correct repo
    1. adding a message that will be used to provide information from the Timing System HW
        * Roland comment:  "This was never the goal for the Timing System software for the v.2.4 release. 
For v2.4., the timing modules will be able to do operations on a Timing partition. (Init/conf/start/stop, working on a backward compatible fashion. E.g.: actual hardware in ProtoDUNE.)"



1. Changes that are local to a small number of repositories, and *are* waiting on something

    1. The change to the inhibit scheme (moving to tokens) [waiting on additional discussion of the model that should be used]
        * when the time comes, the merges should be done in the following order:  dfmessages, then trigemu, then dfmodules
    1. The outstanding issues with external library provisioning for _flxlibs_ and _timing_ [waiting for the issues to be resilved between UDAQ and build tools folks]



1. Changes that are fairly global, don't need to be coordinated, and *aren't* waiting on anything

    1. improving the handling of errors (exceptions, ERS messages)



1. Changes that are fairly global, don't need to be coordinated, and *are* waiting on something

    1. converting to the use of the _logging_ package [waiting on `TLOG() << ers::Issue` investigation)
    1. adding the use of the operational monitoring (_opmon_) package [waiting on _daq-cmake_ change and _opmon_ availability]
    1. starting to use Run Control tools from the CCM WG [waiting on those tools to become available]



1. Changes that are fairly global and need to be coordinated

    1. Style Guide change - remove the "m_" prefix from struct field names [Eric has candidate changes on branches]
    1. Timestamp changes
      1. convert the readout window times to absolute values (detector time)
        * proposal for names:  readout_window_begin, readout_window_end
      1. adding an "offset" field so that trigger_time, readout_window_begin, and readout_window_end can be converted to reasonable wall clock times in test environments
    1. Addition of a map from Fragment type to HDF5 Group 'detector' name
    1. Integration tests of real FELIX electronics without Timing System HW
    1. Integration tests of real FELIX electronics with Timing System HW


***

Questions:


* Do we need to talk about Start command parameters?

* Should we write up a reminder of how we plan to handle problems in our do_work() methods?


***

Ideas for the future?


* how to deliver network parameters (e.g. hosts and ports) to daq apps

* long-window readout as a step on the path to streaming debug data?
