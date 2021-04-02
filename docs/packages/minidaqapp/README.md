# minidaqapp README
# Home
Welcome to the minidaqapp wiki!

[MiniDAQApp Diagrams](MiniDAQApp-Diagrams.md)

### Repository Notes

To help people understand/remember where the various pieces of the MiniDAQApp are located, here is a list of the repositories that contribute modules or libraries (valid as of 16-Dec-2020):


* [_minidaqapp_](https://github.com/DUNE-DAQ/dataformats) - (this repository) is currently envisioned to simply have configuration elements for the overall MiniDAQApp process. The DAQModules and supporting code are expected to be drawn from other repositories.


* [_dataformats_](https://github.com/DUNE-DAQ/dataformats) - has the code for raw data structures.  Currently, this includes both data that is produced by the detector electronics and data that is produced by the DAQ system (that becomes part of the raw data). 


* [_dfmessages_](https://github.com/DUNE-DAQ/dfmessages) - has the messages that are passed between DAQModules in the MiniDAQApp.  (These messages are data structures that are only used inside the DAQ.)


* [_readout_](https://github.com/DUNE-DAQ/readout) - this repository has the DAQModules and supporting code for the Readout/Upstream DAQ part of the MiniDAQApp.


* [_dfmodules_](https://github.com/DUNE-DAQ/dfmodules) - has the code for the Dataflow part of the MiniDAQApp (e.g. gathering Fragments into TriggerRecords, writing TriggerRecords into HDF5 files)


* [_trigemu_](https://github.com/DUNE-DAQ/trigemu) - has the code for the Trigger Decision Emulator

### Developer Notes


* [Simple instructions for running the app](Simple-instructions-for-running-the-app.md) (v1.0)


* [Instructions for setting up a v2.4.0 development environment](Instructions-for-setting-up-a-v2.4.0-development-environment.md)


* [Coordination notes for v2.3.0 and v2.4.0](Coordination-notes-for-v2.3.0-and-v2.4.0.md)


* [Notes from meetings and discussions](Notes-from-meetings-and-discussions.md)


* [Reminders about tests that we want to run](Reminders-about-tests-that-we-want-to-run.md)
