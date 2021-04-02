# Notes from meetings and discussions
## 25-Jan-2021, Kurt's notes from DF scope discussion for dunedaq-v2.4.0

We used [these slides](https://github.com/DUNE-DAQ/minidaqapp/files/5870842/Thoughts.on.next.dunedaq.release.GLM.notes.with.DF.mods.pptx) to guide and document the discussion.  In particular, see slide 4.


**Dataflow response to various proposed changes for dunedaq-v2.4.0**

Consolidation

* Yes:
    * Coding style (already in progress); python configuration schema [week0]
    * stop/start; scrap/conf [weeks1-2]
    * Error handling [weeks1-2]

* If time permits:
    * interruptible waits

Infrastructure (appfwk and CCM)

* Qualified Yes - assumes availability on 01-Mar:
    * logging, opmon, runcontrol

Application code development

* Yes:
    * Disk writing operational improvements (disable, avoiding overwrites) [weeks1-2]
    * Inhibit improvements (actually, the scheme will likely change) [week2]
    * File size and duration limits [weeks2-3]
    * File metadata for FTS [week4]

* If time permits:
    * IPM and serialization [weeks1-TBD]
    * Alternative data merging for high-rate, small-size fragments
    * API documentation, unit testing, test-driven bug fixing

appfwk

* To be considered
    * style guide updates (will likely affect interface) [weeks1-2]
    * error handling infrastructure changes [weeks1-2]
    * changes related to stop/start and scrap/conf [we do not expect any changes to appfwk to be needed]


**Topics to ask other Working Groups about**


* Support for Doxygen documentation

* Plans for documentation that spans multiple repos, or sits outside of a single repo

* Ability to have multiple source code libraries per repo




## 19-Jan-2021

* Is dunedaq-v2.1.0 released?  Yes.

* Action items?
    * merge and tag _dfmodules_?  Adam has tested the branch in the PR.
    * merge and tag _minidaqapp_; Kurt
    * review and test 'Simple Instructions'; Kurt, others?

* what else needs to be done for dunedaq-v2.2.0?
    * dunedaq-v2.1.0 does not yet have the latest _moo_ (2.2.0 will have the latest)
    * the latest _moo_ is needed for the latest _minidaqapp_ changes
    * dunedaq-v2.1.0 has support for Python configurations

## 15-Jan-2021

* How we track issues that we notice (independent of when we work on them)?
    * Roland suggests GitHub Projects for larger issues; GitHub Issues for bugs
    * each package should create a Project to capture the larger issues

* Requeueing: Giovanna has checked that all TRs appear in the data file, with non-empty Fragments

* requests that arrive after the data - Roland is working on a fix for that.

* Roland is also adding a check on the request window size

* for packages that are not undergoing changes, _develop_ should be frozen so that we can pass the baton to the release manager

* dfmodules will get the fix for not crashing on duplicate fragment (Adam will validate)

* minidaqapp package - still on branch - waiting for new _moo_ version
    * expect to control trigger rate, link speed, and number of links

* for now, h5py should be installed locally in order to use the data-dump utility (Adam)

* Alessandro: release 2.1 final touches in progress.  The release with mdapp will be 2.2.  For repos where development is ready, _develop_ will contain all of the changes.  local package tags are independent of the release tag.  e.g. dfmodules v1.0.0  (releases have dune-daq in the tag name)

* first round of tags based on v2.0, apply patches to run with v2.1, then second round of tags.
    * (Alessandro has done an initial successful test of a build with v2.1)

* discussion of command order

* Phil: [common patterns that we should incorporate in appfwk?] state machine integration in the appfwk; sleeps and condition variables; pushing and popping from Queues; command distribution and order; flushing of Queues; connecting sinks and sources at Init time; utility functions (e.g system clock, name of current thread; pin-ning tasks to certain cores, etc)

* next steps: TBD (e.g. in upstream DAQ realm: real FELIX vs. emulated Trigger Primitives)
    * main users of mdapp v1 is daq working group people

## 14-Jan-2021

* Are the branches listed on the Simple Instructions page the right ones?
    * yes, as of the current time

* What changes are still in the pipeline?
    * out of bound request changes are on a _readout_ branch.  These may still need to be tested
    * clang-format in dfmodules
    * dfmodules and minidaqapp should be able to be merged to _develop_ soon after the meeting
    * avoiding sleeps (sample available)  Wholesale changes in this regard will wait until after the tag.
    * Roland would like to add latency buffer extraction limits (hopefully implemented and tested in next 24 hours)

* What tests remain to be done?
    * see the tests page
    * Phil or Roland will provide a sample calculation of Fragment data size expected as a function of readout window size

* What steps should we use for tagging, etc.
    * we can tag the packages ourselves with non-official tags and then pass the baton to sw coordination folks (kurt will check with Alessandro)
    * our dependencies will need to change once the patch release of build-tools is available (dfmodules daq-cmake update)
    * getting HighFive into official _products_

* h5py for the data-dumper utility (Adam): how to make this available?  Adam will check with Alessandro.  FragmentHeader is now available.  (A more direct connection to the C++ class definitions will come later.)

* Phil thinking about stop/start.

* Marco asked about user documentation and where to store it.  A focus on possible configuration changes might be appropriate for users.
    * minidaqapp Wiki page with one paragraph on each module (Phil will start)

## 13-Jan-2021

Questions:

* is there anything to be done with the producer threads 'settling down'?
    * not really, OS-related
    * help can be found by starting things a little differently
    * start_trigger & stop_trigger?  or, be paused at startup, and resume actually starts things (this choice)
    * Giovanna has tuned/organized the configuration parameters to help make things more stable (also a readout bug fix yesterday)
    * command-line options to 'moo compile' or some other tool to specify the down-select or other param value ??

* lots of messages and compile warnings from the readout package.  Phil will check with Roland.  (I'd like this to be done today; I can help)

* readout package _develop_ branch has the contributions from all of the work branches; Roland is looking at a possible config change that is needed; Roland is adding re-queue; readout is not linking against any FELIX-related library at this time (no longer need one of the "dev" products (udaq))

* dfmodules needs to merge to _develop_; others?  trigemu has a couple of changes that can be merged soon

* best to delete feature branches when they are merged to _develop_

* Adam: HDF5 performance (questions about test conditions, including the presence of the disk cache)
    * data dump utility in Python (dfmodules/scripts)  [discussion aobut C++, too]

* someone will look at PR in minidaqapp (KAB)

* communicating via Slack and Github issues, as appropriate

* Phil has modified readout code to make the stopping transition quicker

* discussed the tests on the Tests page

* activity diagram of start and stop

* Eric will look into creating an example of a condition/watch variable

* interruptible thread (jthread) in c++20

* Goal for tomorrow's meeting?
    * decide on tags?

* features to be included vs. deferred in minidaqapp v1
    * included: silent running, scrap command, 10 links at full rate, inhibits when there is 'back-pressure'
    * deferred: stop/start, scrap/conf, no FELIX, IPM to allow for multiple processes, configuration with python

## 12-Jan-2021

Topic: preparing for "a release": 

* list of packages on Phil's page (minus filecmd).

* branches: _develop_ is where new changes changes go, _master_ has code that is part of a release

* what externals are needed:  HighFive, hdf5, and udaq_readout_deps (currently these are in products_dev) [trying to keep FELIX out of this release...]

* there is a dune-daq patch release coming in the next week...  Alessandro would like the minidaqapp release to follow that one.

* to-do: add instructions for how to modify a configuration

* tag a set of mininidaqapp packages by the end of the week (on the _master_ branch) [develop is merged into master, and that is the tag point; all of the branches that we have now are merged into _develop_]

* future (post-v1) steps:  real FELIX, IPM to allow for multiple processes, configuration with python

Round table:

* dfmessages: ready (needs _develop_ branch)

* dataformats: ready (needs _develop_ branch)

* trigemu: ready (any logging cleanup? ERS_INFO->ERS_LOG on state transitions)

* readout: still work to be done

* dfmodules: need some logging cleanup; otherwise ready; clang-format and linter would be nice; Adam will look into why TRH is listed last in _h5dump_ outputs

* minidaqapp: needs the latest config

_scrap_ command implementation (reverse of conf)
    * init, conf, start, stop, scrap 
    * pause and resume for TDE ; pause/resume/pause/resume...
    * start/stop/start/stop?  not a requirement at this time
    * we need to address overall (inter-module) stop issues later

non-zero run number is expected/desired.

is there an error bit set in the Fragment header when an empty fragment is created?  to be checked...
DataWriter can log a warning about these
TriggerRecordHeader error bit also?  To be discussed.

Adam is testing the performance of HDF5 writing.

We need to work on HDF5 reading, too.  Adam says that there is code to do this; to be confirmed that it works.
It would be nice to have an 'event dump' utility.  To be created in dfmodules...
h5 tools - to be investigate.

Notes to start:

* changes in trigemu and dataformats (same branches as before, backward-compatible changes)

* synchronization issue
    * TDE gets TimeSync messages from Readout; TDE is sending triggers for "now"; data may not be in the readout latency buffer for "now"
    * one option is to have the readout module wait for a little bit of time...
    * another option is to add an artificial delay in the TDE trigger time; this doesn't seem to always fix the issue
    * could a requested time window that ends with "now" work?
    * Roland prefers a model in which the readout code pushes "too early" requests back onto the internal request queue (not the Queue from the RequestGenerator)  [is this something that we want by the end of the week? yes]

* removing compiler warnings in progress? [hopefully soon; others can help?]

* what are good machines to use for testing?
    * these are part of a CERN testbed; at Fermilab, we can use the mu2edaq cluster
    * it would be nice to provide a single-link configuration that can be run anywhere

* if there is time to update to the new Style Guide recommendations, those would be great.

## 07-Jan-2021

Integration work session, 07-Jan-2021

* Eric has created a couple of tags in the dataformats repo, one for the 05-Jan state and one for 06-Jan.
And, a pending Pull Request is to make TriggerRecordHeader more like Fragment (it will have the components inside it).

* Carlos is working on adding the map of APA+Link to DataLinkHandler.

* Marco mentioned that the run number doesn’t seem to be in the TriggerDecision, it would be great to add it.
    * Phil is adding this...

* Marco has made the switch to the MPMC queue input to the FragmentReceiver.

* We talked about the configuration for the mapping of APA+Link to Queue for the RequestGenerator.

* Question for Roland: does he want one or N requests per DLH.
    * each DLH handles one line, so it makes sense that each link gets its own DataRequest

* Another question: where should we set the APA number in the components list?
    * at the moment, the TDE sets the APA number to zero, and we will leave this like it is, for now.  (config param at some point?)  We will treat links as a simple list 0..9 (a la 0..1499 in the future), for now.

* Phil reported that he has successfully connected a DataLinkHandler producing TimeSync messages to the TriggerDecisionEmulator (without removing the FakeDataProducers).

08:45 CT: Phil will work with Roland to incorporate the DataLinkHandlers in a system, replacing the FakeDataProducers.  Giovanna will work on the config to support multiple DLHs.  Adam will look at the dataformats PR for TriggerRecordHeader changes.  Marco will test the switch to a single MPMC queue between the data producers and the FragmentReceiver.  Carlos will continue looking at the link-to-queue map.  We'll reconvene in ~2 hours.

Updates:

* Adam and I worked together to get the _NestedGroups_ branch in the _dfmodules_ repo merged into its _main_ branch.  This should be transparent to everything else that is going on.

* So far, Dataflow folks (and others?) have been sticking with slightly older dataformats code (_snapshot_before_changes_06Jan2021_ tag)

* Giovanna has committed changes to the readout repo to create multiple links from the Fake Card Source to the DataLinkHandler(s).

* Phil has connected a DLH instance to the FakeFragRec
    * he is seeing a crash in the DataWriter - unable to create the dataset for Link xyz

* Roland added empty Fragment responses to the DLH.  Added request window matching to the data in the latency buffer. 

* We should add error handling to the DataWriter to not crash the application when a duplicate entry/Fragment is requested to be written. 

Steps:

* today:
    * single DLH without crash
        * Eric has found an issue in the pushing of the Fragment onto the output queue; this is being worked on
    * multiple DLH
    * real data
    * new Fragment Receiver
        * there was a problem with sending the 2nd, 3rd, etc TriggerRecords to the DataWriter, but there now is a fix for that.
    * something new: I noticed that the Link number is appearing twice in the HDF5 file internal layout (both a Group and a Dataset); a GitHub Issue has been filed and assigned to Adam

* tomorrow:
    * new RequestGenerator
    * new dataformats??  we'll do this work on branches
    * test stop/start
    * test inhibit
    * test long runs

For discussion:

* Initialization of Fragment and TriggerRecord header fields to default or null/zero values.

## 16-Dec-2020

### Notes from MiniDAQApp meeting/discussion, Kurt's notes



1. starting to use the “MiniDAQApp” name - no objections


1. Style Guide updates.  A general proposal was to import Google recommendations on variable names.  I'm not sure if that is consistent with the specific choices that we discussed, but here are the specific choices:
    1. local variables have lower-case letters and underscores ("my_value")
    1. class data members have lower-case letters, underscores, and a trailing underscore ("my_data_member_")
    1. static data members: capitals or "s_"?  I think that the consensus was all upper-case letters with underscores, but I could be wrong.
    1. typedefs: preference is for lower case letters, underscores, and a trailing "_t" ("my_favorite_type_t")
    1. class and structure names: mixed case, no underscores, with the first letter capitalized (e.g. "MyFavoriteClass")
    1. among the following options for method names, I believe that there was a slight preference for f+g.  (b+c was the runner-up).
      1. GetMyValue()
      1. getMyValue
      1. doSomething()
      1. myvalue() ; myvalue(int)
      1. my_value(); my_value(int)
      1. get_my_value()
      1. do_something()


1. Messages and data structures
    * Eric reported that he has updated variable names based on emails in recent days
    * the desired pattern is for the Fragment to have everything in contiguous memory
    * the TriggerRecord could/should support both models (scattered memory is fine, for now; serialized/contiguous can come later)
    * We talked about the use of typedefs for our DAQ raw data structures.  A consensus was not reached.
    * Component lists - we agreed that "actual" components can be determine from the data Fragments present in the TriggerRecord.  For the list of requested components that we store in the TriggerRecordHeader, it would be nice to use an old-school representation (i.e. not an std::vector) so that an extra serialization step will not be needed.
    * operator<< is desirable.  There was some discussion about whether this could/should include the raw data.  TBD.
    * there were other topics that were discussed, and Eric will incorporate those


1. Repositories
    * it was proposed to rename _daq-rawdata_ to _dataformats_ **and** add the DAQ raw data format classes/structures that Eric and Phil have been working on to this repo.  So, this repo will have raw data decoders and DAQ data structures.
    * Alessandro will create a new repo named minidaqapp which we will use to store the overall application configuration (jsonnet and json).  And, if you are reading this, you realize that I will also be using this repo as a convenient place to provide notes, etc. on the overall application.
    * Adam and Alessandro will work out what the “dataflow” repo should be called.


1. We looked at the configurations that we have so far for the TriggerDecisionEmulator test environment and the FakeMiniDAQApp sample environment in the _ddpdemo_ repo.
    * There was a question from Roland about what type of configuration information is available to DAQModules at the INIT transition - only information about the Queues.  Module-specific configuration should be provided in the CONF step.


1. Updates from the sub-groups:
    * we had already discussed the messages and data structures...
    * Phil described the configuration parameters that are currently available in the TriggerDecisionEmulator and how those can be used to specify the different TriggerDecisions (e.g. ones with varying readout windows)
    * For the Dataflow scope, we described the skeleton application and our current work assignments:  Carlos: RequestGeneator, Marco: FragmentReceiver, Adam: DataWriter
    * I've copied the update from Roland on the Readout part below


1. Updates to diagrams - I'll work on those


1. Next meeting: January 5th or 6th.  The goal is to have a working meeting in which we are integrating the various parts together.  Of course, we will be starting such integration as soon as we can.

### Notes from Roland

Please find below the status of Readout Modules and software libraries:

- We discussed with Giovanna few weeks ago, that due to the possiblity that the readout will need to deal with more than just 3 (WIB/PD/TP) kind of raw data, a generic  templated Readout functional elements could help a lot on the long-run. 
- I had a look and followed the discussion about the templated DAQModules and network queues, and had a discussion with Phil about this. I got inspired by the implementation, as it's very similar that I would like to solve in the readout.
 I adapted the mechanisms and came up with the attached design for the functional elements. (The RequestHandler is not on it, but it's already implemented on a similar fashion.)

- The Readout package consists of 2 kinds of DAQModules:
 +Source modules (FelixCard, FakeCard, any module that does not have input queues, as they generate data and push FE raw data pointers to output appfwk queues.
   -> FelixCardReader : 80% done, I have some issues with unfinished configuration and a missing lib in the UPS product...
   -> FakeCardReader : Done. I can simulate WIB links (with an adjustable ratelimiter) to create WIB Frames (from a small ProtoDUNE FELIX link dump file). (It also configured to !fake! the timestamp, to increment them by 25 ticks, simulating a proper stream. I'm planning to add configurable, or triggerable ways to inject malformed, error frames.) 

 + Handler module:
   -> Contains a templated "context"/"ReadoutModel" that acts as a glue to instantiate FE raw type specific raw-processor pipeline, latency buffer, and request handler implementations.
   -> I have a full chain working for the WIB (12 x WIB frame char array) raw type, up to the point that I'm removing the old, non-requested data. (Included timestampt continuity check and ways to extend the raw-checker pipeline.
   -> I'm ready to implement the "Requested Data" domain's last remaining feature: the extraction and pushing the Fragment to the output queues.
   -> As soon as I see the "dataformats" package expanded with the DataRequest  and the Fragment, I'll finish the remaining parts. (I'll also add a "fake-self-trigger" module, as an integrity/performance tester module for spike-, ramp-, and other test schenarios. 

Example running can be found under:
https://urldefense.proofpoint.com/v2/url?u=https-3A__github.com_DUNE-2DDAQ_readout&d=DwIF-g&c=gRgGjJ3BkIsb5y6s49QqsA&r=lfJn8IlK95ZGuafYS9SD4g&m=hRRO0KMScbznLyC7vvguWBc4-XrSugGUiosHE6lQPl0&s=92q3NDIGuqis7r1hHCP1YTH-qIJKhH0obciEMTaPh6w&e= 
(I'll extend the README with a link to a small ProtoDUNE dump file that contains 10 superchunks, and I'm using for testing.)

We will have 2 source Modules per physicial FELIX card (with configurable output queue types), and individual instances of Handler modules per logical link. (10 for WIB links, 2 for TPs, X for PDs.)

### Notes from the DFWG meeting

Phil gave a [nice presentation on our work on the MiniDAQApp](https://indico.fnal.gov/event/46960/).  A couple of suggestions came out of the ensuing discussion:


1. It would be nice to have a list of the repositories that contain the various code pieces.  (To help with this, I started a list on the _minidaqapp_ repo Wiki page.)


1. We should remember to run tests in which the TriggerDecision asks for data that is no longer in the Upstream DAQ buffers, to verify tha this situation is gracefully handled.  This came out of a discussion about how the different time values in the TimeSync message are used.
