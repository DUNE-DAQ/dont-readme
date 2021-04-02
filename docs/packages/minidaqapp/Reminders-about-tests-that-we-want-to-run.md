# Reminders about tests that we want to run
## Tests required for dunedaq-v2.4.0
### Minidaqapp

* Generate a configuration using the python module minidaqapp.fake_app_confgen (default params) and test the following:


1. Application runs through all states and supports also stop/start scrap/conf;


1. The tests of dunedaq-v2.2.0 pass successfully.


* Generate a configuration using python module minidaqapp/daq_app_confgen (_it's for now in branch gym/flxconfig and needs updating!_) and test the following:


1. Application runs through all states and supports also stop/start scrap/conf;


1. The tests of dunedaq-v2.2.0 pass successfully.

### Minidaqapp++

* Generate a configuration for 2 applications (trigger emulator + rest of minidaqapp), still with fake data generation, and test the following:


1. Application runs through all states and supports also stop/start scrap/conf;


1. The tests of dunedaq-v2.2.0 pass successfully.


* Generate a configuration for 2 applications (trigger emulator + rest of minidaqapp) with real FLX and test the following:


1. Application runs through all states and supports also stop/start scrap/conf;


1. The tests of dunedaq-v2.2.0 pass successfully.


* Generate a configuration using python module timing.app_confgen (_doesn't exist yet!_) and test all commands

### Common to both Minidaqapp and Minidaqapp++


1. The data inside the generated HDF5 files looks correct. The HDF5 utility `h5dump` can be used to inspect the contents of the raw data files, as can our custom `hdf5_dump.py` script.


1. Output files are limited in size to the value specified in the max_file_size_bytes configuration parameter, and the 2nd, 3d, etc. files have the _file index_ field in the filename incremented.


1. The system reliably drains all data that is "in flight" when a run stop is requested.  (This test may require some special conditions to generate a backlog of data, such as running on a slow computer and requesting a high trigger rate, or artificially extending the time that is needed to write out a TriggerRecord.)


1. The token-based system of preventing TriggerDecisions from being generated when the Dataflow and Readout parts of the system are already full works reliably.  (This may also require some special conditions to generate more triggers and/or data than a given minidaqapp instance can handle.  Note that the `initial_token_count` configuration parameter controls how many TriggerDecisions are allowed to be "in flight" at any one time.)


1. When an invalid directory path is specified for the output data files, an error is reported at run start time.


1. A failure in the writing of a TriggerRecord to an output file does not crash the application.  (This may take some work to set up the special conditions needed to test this.)


1. The disabling and prescaling of data writing works correctly.  The former is often controlled by a command-line argument to a confgen.py script (e.g `--disable-data-storage`), the latter is controlled by the `data_storage_prescale` configuration parameter.

## Tests required for dunedaq-v2.3.0


* Generate a configuration using the python listrev.app_confgen module using default settings and changing command line options. :heavy_check_mark:(Florian)

* Start the daq_application and run it through all commands using the stdin command facility. :heavy_check_mark:(Florian)

* Start the daq_application and run it through all commands using the rest command facility. :heavy_check_mark:(Florian)

* Send invalid commands (wrong names and correct commands but in the wrong state) and check that the application behaves as expected. ❗  
    * *Bug reported by Florian (March 3rd):* if the command "hello" is sent before "init" the application complains (as expected the first command must be init) but then remains busy and doesn't accept any other command anymore. 
    * 🐰 Fixed in appfwk -> glm/155_bug_fix: since this bug does not affect normal working, a new tag will be applied for dunedaq-v2.4.0.

* Change DUNEDAQ_ERS debug levels and DUNEDAQ_OPMON variables and validate the applications behaviour.:heavy_check_mark:(Florian)

## Tests required for first version of MiniDAQApp (dunedaq-v2.2.0)


* Configure the TriggerDecisionEmulator to generate TriggerDecisions that have request windows that are far off the actual time being processed by the Readout components and verify that the system gracefully reports that data is missing in the output to disk.  (Phil will do this.)


* requests in the future
    * test by Kurt:  I modified the `"trigger_delay_ticks" : std.floor( 12* CLOCK_SPEED_HZ/DATA_RATE_SLOWDOWN_FACTOR),` line in the TriggerDecisionEmulator part of the minidaq-app-fake-readout.jsonnet/json file (`12*` instead of `2*`) and ran with the _readout_ code on its _develop_ branch.  That produced empty Fragments.  I then updated the _readout_ code to its _roland-sipos/requeue-oob-request_ branch and tried to run.  In both of two tests, the system crashed on the second event because there were Fragments with duplicate link numbers in the second TriggerRecord.  I'm not sure if my test conditions were reasonable; I was trying to put the request window 12 seconds in the future.


* Increase progressively number of links and check how many can be handled. First tests on `epdtdifogkv04` at CERN indicate that with 10 links, we're able to keep up with the full 2 MHz data rate (Done by Giovanna) :heavy_check_mark:


* With the maximum number of links that can be handled in input, progressively increase the trigger rate and try to reach the disc throughput limit. (Done by Eric) ✔️ 
  * I was able to run a test with 10 links, slowdown factor of 2, trigger rate of 8 Hz and window scale of 800x. This resulted in a steady state of trigger inhibits and ~650 MB/s to disk. Based on a rough calculation from the DataWriter "Processing trigger number" message, I was actually getting about 2 Hz.


* Include a varied number of links into the trigger decision. (Done by Giovanna) :heavy_check_mark:


* Have variable readout windows for different trigger decision  (Done by Kurt)  :heavy_check_mark:
    * I set the min/max_readout_window_ticks in the configuration file to 900 and 1500.  I ran with 5 links at 1 Hz for ~30 seconds.  I saw the readout width reported in the FragmentHeader vary between 900 (0x384) and 1500 (0x5dc).  The Fragment sizes were quantized at 22344 and 27912 bytes, with approximately 50% of them having the smaller value and 50% having the larger value (presumably for readout windows between 900 and 1199 ticks and between 1200 and 1499 ticks, respectively).  The readout width and corresponding Fragment size was variable among the five fragments in each TriggerRecord, as expected.


* Make overlapping trigger requests and check that the readout code produces the correct output. We'll start this by just duplicating trigger decisions, so they're totally overlapping (but with the trigger number different)  (Done by Kurt; see results below) :heavy_check_mark:


* Check that Inhibits are generated when the disk rate can't support the data rate :heavy_check_mark:
    * As a simple test of this, I (Kurt) added a temporary 1.5 second sleep to the DataWriter code (this sleep happened every time a TriggerRecord was written).  With a 2-link system with a slowdown factor on 10, running on lxplus, I saw the expected initial rate of ~1.0 Hz for the first 10 events, and then inhibits started.  For the rest of the run, the overall rate was limited to ~0.67 Hz, as we would expect.  (Recall that the current threshold for generating an Inhibit is 5 TriggerRecords being processed by the Dataflow and Readout subsystems.)
    * See also results from test above, where due to a disk write rate limit of 650 MB/s, inhibits were used to downscale an 8 Hz requested trigger rate to ~2 Hz


* Verify that the size of the Fragments are what is expected, given the requested readout window.
  * Modulo the notes below, the large trigger window test had a trigger window width of 960,000 ticks and Fragment size of 17,823,240 bytes, which is the expected size from the trigger window plus 5568 bytes for 12 extra WIB frames

## Tests to wait until after the first version of the MiniDAQApp


* Be able to send `stop` command and then `start` command to the same job. This will have to wait until we understand how to correctly stop and flush the queues


* Be able to send `scrap` command and then `conf` to the same job. The full sequence of commands would be `init -> conf -> start -> stop -> scrap -> conf -> start -> stop` so unfortunately this also depends on the stop/start test above

## Sample test results

<details><summary>Results of a test of overlapping triggers</summary>
To test this, I temporarily modified the minidaq-app-fake-readout.jsonnet file to set the repeat_trigger_count in the TriggerDecisionEmulator to 2 (and then re-ran `moo compile` to re-generate the associated JSON file)

```
(dbt-pyvenv) [biery@lxplus797 schema]$ git diff minidaq-app-fake-readout.jsonnet
diff --git a/schema/minidaq-app-fake-readout.jsonnet b/schema/minidaq-app-fake-readout.jsonnet
index f93f388..d99033b 100644
--- a/schema/minidaq-app-fake-readout.jsonnet
+++ b/schema/minidaq-app-fake-readout.jsonnet
@@ -90,7 +90,8 @@ local qspec_list = [
         // emitted per (wall-clock) second, rather than being
         // spaced out further
         "trigger_interval_ticks" : std.floor( 3* CLOCK_SPEED_HZ/DATA_RATE_SLOWDOWN_FACTOR),
-        "clock_frequency_hz" : CLOCK_SPEED_HZ/DATA_RATE_SLOWDOWN_FACTOR
+        "clock_frequency_hz" : CLOCK_SPEED_HZ/DATA_RATE_SLOWDOWN_FACTOR,
+        "repeat_trigger_count": 2
       }),
     cmd.mcmd("rqg",
                 {
```

I then ran the system with the debug printout of the first 400 bytes from each Fragment going to the TRACE buffer.  Here is the printout of the TRACE buffer that captures the partial contents of the two Fragments in last two events in the run (reverse time order).  Close inspection shows that the Fragments only differ by the trigger number, so I consider this a successful test.

```
  idx                us_tod     pid     tid cpu                  trcname lvl msg                     
-----      ---------------- ------- ------- --- ------------------------ --- ------------------------
    0 01-14 17:00:47.126827   10320   10361   6      TriggerInhibitAgent D10 do_work: datawriter::TriggerInhibitAgent: Popped the TriggerDecision for trigger number 42 off the input queue
    1 01-14 17:00:47.126742   10320   10366   3 TriggerDecisionForwarder D10 do_work: rqg::TriggerDecisionForwarder: Pushing the TriggerDecision for trigger number 42 onto the output queue.
    2 01-14 17:00:47.090774   10320   10362   7            HDF5DataStore DBG write: data_store: Writing data with run number 333 and trigger number 41 and detector type FELIX and apa/link number 0 / 0
    3 01-14 17:00:47.090758   10320   10362   7            HDF5DataStore DBG openFileIfNeeded: data_store: Pointer file to  ./fake_minidaqapp_run000333_file0000.hdf5 was already opened with openFlags 17
    4 01-14 17:00:47.090746   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 95: 0xb7fa9394 0x3f932338 0xb3e9baa3 0xd8863b97 0x419ea339
    5 01-14 17:00:47.090744   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 90: 0x893c48f3 0xd803a299 0x64178a3c 0x898fa849 0x69493a1e
    6 01-14 17:00:47.090743   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 85: 0x33b89beb 0xb1be3b96 0x449a1379 0xc843e8dd 0xa0fb933e
    7 01-14 17:00:47.090741   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 80: 0x00000000 0xaaaaaaaa 0xc9093a67 0x6f898a91 0x3a905329
    8 01-14 17:00:47.090740   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 75: 0xd94357a8 0xbf7e8d37 0x918e6968 0x5fbc0000 0xc8bc6e23
    9 01-14 17:00:47.090738   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 70: 0xacfe3892 0x3e987308 0x99b37482 0x92778e37 0x8d396963
    10 01-14 17:00:47.090737   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 65: 0x968d9969 0xa858b9e5 0xacbf9b8d 0x388e73f8 0x13699d14
    11 01-14 17:00:47.090736   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 60: 0xb9c39c94 0xdc8f9637 0x8e376873 0x9813f791 0x34508d39
    12 01-14 17:00:47.090734   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 55: 0xbf3a938d 0x3d9123a9 0x8389e82d 0xe4703c97 0x40a563d9
    13 01-14 17:00:47.090733   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 50: 0x35710000 0xc8bcca1f 0x00000000 0xaaaaaaaa 0xb969063f
    14 01-14 17:00:47.090731   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 45: 0xcf97993a 0x8a3a08f3 0x9863b7ba 0xa1368d3a 0x928f2899
    15 01-14 17:00:47.090729   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 40: 0x3a922358 0x7309a22b 0xbe283c91 0x3e97e359 0x094361b9
    16 01-14 17:00:47.090694   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 35: 0x38f39161 0x4a698d38 0x938a89f8 0xf829e06a 0xacff8f94
    17 01-14 17:00:47.090692   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 30: 0xf6153d9b 0x419eb3f9 0xd993508e 0x26848b39 0x8e365903
    18 01-14 17:00:47.090690   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 25: 0xaaaa2a2a 0xa888d65c 0xaabb898c 0x3a8c13c8 0xc328a9d1
    19 01-14 17:00:47.090689   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 20: 0x794cee70 0x011b5c79 0x9b400000 0xc8bc201a 0x00000000
    20 01-14 17:00:47.090687   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 15: 0x00000000 0x00000000 0x00000000 0x00042100 0x00000000
    21 01-14 17:00:47.090686   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 10: 0x000004b0 0x00000000 0x0000014d 0x00000000 0x00000000
    22 01-14 17:00:47.090684   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset  5: 0x00000000 0x794cf340 0x011b5c79 0x000003e8 0x00000000
    23 01-14 17:00:47.090682   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset  0: 0x11112222 0x00000001 0x00006d08 0x00000000 0x00000029
    24 01-14 17:00:47.090675   10320   10362   7               DataWriter D17 do_work: datawriter: Partial(?) contents of the Fragment from link 0
    25 01-14 17:00:47.090455   10320   10362   7            HDF5DataStore DBG write: data_store: Writing data with run number 333 and trigger number 41 and detector type FELIX and apa/link number 0 / 1
    26 01-14 17:00:47.090449   10320   10362   7            HDF5DataStore DBG openFileIfNeeded: data_store: Pointer file to  ./fake_minidaqapp_run000333_file0000.hdf5 was already opened with openFlags 17
    27 01-14 17:00:47.090435   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 95: 0xb7fa9394 0x3f932338 0xb3e9baa3 0xd8863b97 0x419ea339
    28 01-14 17:00:47.090433   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 90: 0x893c48f3 0xd803a299 0x64178a3c 0x898fa849 0x69493a1e
    29 01-14 17:00:47.090416   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 85: 0x33b89beb 0xb1be3b96 0x449a1379 0xc843e8dd 0xa0fb933e
    30 01-14 17:00:47.090414   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 80: 0x00000000 0xaaaaaaaa 0xc9093a67 0x6f898a91 0x3a905329
    31 01-14 17:00:47.090413   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 75: 0xd94357a8 0xbf7e8d37 0x918e6968 0x5fbc0000 0xc8bc6e23
    32 01-14 17:00:47.090411   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 70: 0xacfe3892 0x3e987308 0x99b37482 0x92778e37 0x8d396963
    33 01-14 17:00:47.090410   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 65: 0x968d9969 0xa858b9e5 0xacbf9b8d 0x388e73f8 0x13699d14
    34 01-14 17:00:47.090408   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 60: 0xb9c39c94 0xdc8f9637 0x8e376873 0x9813f791 0x34508d39
    35 01-14 17:00:47.090407   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 55: 0xbf3a938d 0x3d9123a9 0x8389e82d 0xe4703c97 0x40a563d9
    36 01-14 17:00:47.090405   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 50: 0x35710000 0xc8bcca1f 0x00000000 0xaaaaaaaa 0xb969063f
    37 01-14 17:00:47.090404   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 45: 0xcf97993a 0x8a3a08f3 0x9863b7ba 0xa1368d3a 0x928f2899
    38 01-14 17:00:47.090402   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 40: 0x3a922358 0x7309a22b 0xbe283c91 0x3e97e359 0x094361b9
    39 01-14 17:00:47.090401   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 35: 0x38f39161 0x4a698d38 0x938a89f8 0xf829e06a 0xacff8f94
    40 01-14 17:00:47.090399   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 30: 0xf6153d9b 0x419eb3f9 0xd993508e 0x26848b39 0x8e365903
    41 01-14 17:00:47.090398   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 25: 0xaaaa2a2a 0xa888d65c 0xaabb898c 0x3a8c13c8 0xc328a9d1
    42 01-14 17:00:47.090375   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 20: 0x794cee70 0x011b5c79 0x9b400000 0xc8bc201a 0x00000000
    43 01-14 17:00:47.090373   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 15: 0x00000000 0x00000000 0x00000000 0x00042100 0x00000000
    44 01-14 17:00:47.090371   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 10: 0x000004b0 0x00000000 0x0000014d 0x00000000 0x00000001
    45 01-14 17:00:47.090369   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset  5: 0x00000000 0x794cf340 0x011b5c79 0x000003e8 0x00000000
    46 01-14 17:00:47.090366   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset  0: 0x11112222 0x00000001 0x00006d08 0x00000000 0x00000029
    47 01-14 17:00:47.090357   10320   10362   7               DataWriter D17 do_work: datawriter: Partial(?) contents of the Fragment from link 1
    48 01-14 17:00:47.090039   10320   10362   7            HDF5DataStore DBG write: data_store: Writing data with run number 333 and trigger number 41 and detector type TriggerRecordHeader and apa/link number 1 / 1
    49 01-14 17:00:47.090034   10320   10362   7            HDF5DataStore DBG openFileIfNeeded: data_store: Pointer file to  ./fake_minidaqapp_run000333_file0000.hdf5 was already opened with openFlags 17
    50 01-14 17:00:47.089983   10320   10362   7               DataWriter D10 do_work: datawriter: Popped the TriggerRecord for trigger number 41 off the input queue
    51 01-14 17:00:47.072362   10320   10362   7            HDF5DataStore DBG write: data_store: Writing data with run number 333 and trigger number 42 and detector type FELIX and apa/link number 0 / 1
    52 01-14 17:00:47.072357   10320   10362   7            HDF5DataStore DBG openFileIfNeeded: data_store: Pointer file to  ./fake_minidaqapp_run000333_file0000.hdf5 was already opened with openFlags 17
    53 01-14 17:00:47.072337   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 95: 0xb7fa9394 0x3f932338 0xb3e9baa3 0xd8863b97 0x419ea339
    54 01-14 17:00:47.072335   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 90: 0x893c48f3 0xd803a299 0x64178a3c 0x898fa849 0x69493a1e
    55 01-14 17:00:47.072319   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 85: 0x33b89beb 0xb1be3b96 0x449a1379 0xc843e8dd 0xa0fb933e
    56 01-14 17:00:47.072318   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 80: 0x00000000 0xaaaaaaaa 0xc9093a67 0x6f898a91 0x3a905329
    57 01-14 17:00:47.072316   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 75: 0xd94357a8 0xbf7e8d37 0x918e6968 0x5fbc0000 0xc8bc6e23
    58 01-14 17:00:47.072315   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 70: 0xacfe3892 0x3e987308 0x99b37482 0x92778e37 0x8d396963
    59 01-14 17:00:47.072313   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 65: 0x968d9969 0xa858b9e5 0xacbf9b8d 0x388e73f8 0x13699d14
    60 01-14 17:00:47.072312   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 60: 0xb9c39c94 0xdc8f9637 0x8e376873 0x9813f791 0x34508d39
    61 01-14 17:00:47.072311   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 55: 0xbf3a938d 0x3d9123a9 0x8389e82d 0xe4703c97 0x40a563d9
    62 01-14 17:00:47.072309   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 50: 0x35710000 0xc8bcca1f 0x00000000 0xaaaaaaaa 0xb969063f
    63 01-14 17:00:47.072308   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 45: 0xcf97993a 0x8a3a08f3 0x9863b7ba 0xa1368d3a 0x928f2899
    64 01-14 17:00:47.072306   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 40: 0x3a922358 0x7309a22b 0xbe283c91 0x3e97e359 0x094361b9
    65 01-14 17:00:47.072304   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 35: 0x38f39161 0x4a698d38 0x938a89f8 0xf829e06a 0xacff8f94
    66 01-14 17:00:47.072303   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 30: 0xf6153d9b 0x419eb3f9 0xd993508e 0x26848b39 0x8e365903
    67 01-14 17:00:47.072285   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 25: 0xaaaa2a2a 0xa888d65c 0xaabb898c 0x3a8c13c8 0xc328a9d1
    68 01-14 17:00:47.072283   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 20: 0x794cee70 0x011b5c79 0x9b400000 0xc8bc201a 0x00000000
    69 01-14 17:00:47.072281   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 15: 0x00000000 0x00000000 0x00000000 0x00042100 0x00000000
    70 01-14 17:00:47.072280   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 10: 0x000004b0 0x00000000 0x0000014d 0x00000000 0x00000001
    71 01-14 17:00:47.072278   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset  5: 0x00000000 0x794cf340 0x011b5c79 0x000003e8 0x00000000
    72 01-14 17:00:47.072275   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset  0: 0x11112222 0x00000001 0x00006d08 0x00000000 0x0000002a
    73 01-14 17:00:47.072267   10320   10362   7               DataWriter D17 do_work: datawriter: Partial(?) contents of the Fragment from link 1
    74 01-14 17:00:47.071952   10320   10362   7            HDF5DataStore DBG write: data_store: Writing data with run number 333 and trigger number 42 and detector type FELIX and apa/link number 0 / 0
    75 01-14 17:00:47.071944   10320   10362   7            HDF5DataStore DBG openFileIfNeeded: data_store: Pointer file to  ./fake_minidaqapp_run000333_file0000.hdf5 was already opened with openFlags 17
    76 01-14 17:00:47.071925   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 95: 0xb7fa9394 0x3f932338 0xb3e9baa3 0xd8863b97 0x419ea339
    77 01-14 17:00:47.071924   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 90: 0x893c48f3 0xd803a299 0x64178a3c 0x898fa849 0x69493a1e
    78 01-14 17:00:47.071923   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 85: 0x33b89beb 0xb1be3b96 0x449a1379 0xc843e8dd 0xa0fb933e
    79 01-14 17:00:47.071921   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 80: 0x00000000 0xaaaaaaaa 0xc9093a67 0x6f898a91 0x3a905329
    80 01-14 17:00:47.071907   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 75: 0xd94357a8 0xbf7e8d37 0x918e6968 0x5fbc0000 0xc8bc6e23
    81 01-14 17:00:47.071906   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 70: 0xacfe3892 0x3e987308 0x99b37482 0x92778e37 0x8d396963
    82 01-14 17:00:47.071904   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 65: 0x968d9969 0xa858b9e5 0xacbf9b8d 0x388e73f8 0x13699d14
    83 01-14 17:00:47.071903   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 60: 0xb9c39c94 0xdc8f9637 0x8e376873 0x9813f791 0x34508d39
    84 01-14 17:00:47.071901   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 55: 0xbf3a938d 0x3d9123a9 0x8389e82d 0xe4703c97 0x40a563d9
    85 01-14 17:00:47.071900   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 50: 0x35710000 0xc8bcca1f 0x00000000 0xaaaaaaaa 0xb969063f
    86 01-14 17:00:47.071898   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 45: 0xcf97993a 0x8a3a08f3 0x9863b7ba 0xa1368d3a 0x928f2899
    87 01-14 17:00:47.071897   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 40: 0x3a922358 0x7309a22b 0xbe283c91 0x3e97e359 0x094361b9
    88 01-14 17:00:47.071895   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 35: 0x38f39161 0x4a698d38 0x938a89f8 0xf829e06a 0xacff8f94
    89 01-14 17:00:47.071894   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 30: 0xf6153d9b 0x419eb3f9 0xd993508e 0x26848b39 0x8e365903
    90 01-14 17:00:47.071892   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 25: 0xaaaa2a2a 0xa888d65c 0xaabb898c 0x3a8c13c8 0xc328a9d1
    91 01-14 17:00:47.071891   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 20: 0x794cee70 0x011b5c79 0x9b400000 0xc8bc201a 0x00000000
    92 01-14 17:00:47.071889   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 15: 0x00000000 0x00000000 0x00000000 0x00042100 0x00000000
    93 01-14 17:00:47.071827   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset 10: 0x000004b0 0x00000000 0x0000014d 0x00000000 0x00000000
    94 01-14 17:00:47.071826   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset  5: 0x00000000 0x794cf340 0x011b5c79 0x000003e8 0x00000000
    95 01-14 17:00:47.071822   10320   10362   7               DataWriter D17 do_work: datawriter: 32-bit offset  0: 0x11112222 0x00000001 0x00006d08 0x00000000 0x0000002a
    96 01-14 17:00:47.071810   10320   10362   7               DataWriter D17 do_work: datawriter: Partial(?) contents of the Fragment from link 0
    97 01-14 17:00:47.071356   10320   10362   7            HDF5DataStore DBG write: data_store: Writing data with run number 333 and trigger number 42 and detector type TriggerRecordHeader and apa/link number 1 / 1
    98 01-14 17:00:47.071345   10320   10362   7            HDF5DataStore DBG openFileIfNeeded: data_store: Pointer file to  ./fake_minidaqapp_run000333_file0000.hdf5 was already opened with openFlags 17
    99 01-14 17:00:47.071284   10320   10362   7               DataWriter D10 do_work: datawriter: Popped the TriggerRecord for trigger number 42 off the input queue
  100 01-14 17:00:47.071219   10320   10365   3         FragmentReceiver D10 do_work: Trigger decision 41/333 status: 1 / 2 Fragments
  101 01-14 17:00:47.071175   10320   10365   3         FragmentReceiver D10 do_work: Trigger decision 42/333 status: 1 / 2 Fragments
  102 01-14 17:00:47.071173   10320   10365   3         FragmentReceiver D10 do_work: Trigger decision 41/333 status: 1 / 2 Fragments
  103 01-14 17:00:47.071148   10320   10365   3         FragmentReceiver D10 do_work: Trigger decision 41/333 status: 1 / 2 Fragments
  104 01-14 17:00:47.070791   10320   10367   0         RequestGenerator D10 do_work: rqg: Pushing the DataRequest from trigger number 42 onto output queue :data_requests_1
  105 01-14 17:00:47.070789   10320   10367   0         RequestGenerator D10 do_work: rqg: apa_number 0: link_number 1: window_offset 1000: window_width 1200
  106 01-14 17:00:47.070770   10320   10367   0         RequestGenerator D10 do_work: rqg: trig_number 42: run_number 333: trig_timestamp 79759095205000000
  107 01-14 17:00:47.070769   10320   10367   0         RequestGenerator D10 do_work: rqg: trigDecision.components.size :2
  108 01-14 17:00:47.070768   10320   10367   0         RequestGenerator D10 do_work: rqg: Pushing the DataRequest from trigger number 42 onto output queue :data_requests_0
  109 01-14 17:00:47.070766   10320   10367   0         RequestGenerator D10 do_work: rqg: apa_number 0: link_number 0: window_offset 1000: window_width 1200
  110 01-14 17:00:47.070765   10320   10367   0         RequestGenerator D10 do_work: rqg: trig_number 42: run_number 333: trig_timestamp 79759095205000000
  111 01-14 17:00:47.070764   10320   10367   0         RequestGenerator D10 do_work: rqg: trigDecision.components.size :2
  112 01-14 17:00:47.070760   10320   10367   0         RequestGenerator D10 do_work: rqg: Pushing the TriggerDecision for trigger number 42 onto the output queue
  113 01-14 17:00:47.070760   10320   10367   0         RequestGenerator D10 do_work: rqg: Popped the TriggerDecision for trigger number 42 off the input queue
  114 01-14 17:00:47.070739   10320   10367   0         RequestGenerator D10 do_work: rqg: Pushing the DataRequest from trigger number 41 onto output queue :data_requests_1
  115 01-14 17:00:47.070737   10320   10367   0         RequestGenerator D10 do_work: rqg: apa_number 0: link_number 1: window_offset 1000: window_width 1200
  116 01-14 17:00:47.070736   10320   10367   0         RequestGenerator D10 do_work: rqg: trig_number 41: run_number 333: trig_timestamp 79759095205000000
  117 01-14 17:00:47.070735   10320   10367   0         RequestGenerator D10 do_work: rqg: trigDecision.components.size :2
  118 01-14 17:00:47.070729   10320   10367   0         RequestGenerator D10 do_work: rqg: Pushing the DataRequest from trigger number 41 onto output queue :data_requests_0
  119 01-14 17:00:47.070670   10320   10367   0         RequestGenerator D10 do_work: rqg: apa_number 0: link_number 0: window_offset 1000: window_width 1200
  120 01-14 17:00:47.070668   10320   10367   0         RequestGenerator D10 do_work: rqg: trig_number 41: run_number 333: trig_timestamp 79759095205000000
  121 01-14 17:00:47.070667   10320   10367   0         RequestGenerator D10 do_work: rqg: trigDecision.components.size :2
  122 01-14 17:00:47.070650   10320   10367   0         RequestGenerator D10 do_work: rqg: Pushing the TriggerDecision for trigger number 41 onto the output queue
  123 01-14 17:00:47.070624   10320   10367   0         RequestGenerator D10 do_work: rqg: Popped the TriggerDecision for trigger number 41 off the input queue
 
```

</details>
<details><summary>Calculating Expected Fragment size</summary>

From #np04-daq-integration slack:
```
One WIB frame has size W=464 bytes
There are C=25 ticks of the 50 MHz clock per TPC digitization
So the size of TPC data on one link for a trigger window of T ticks is (T/C)*W = 18.56*T bytes
(There's a further wrinkle in that each item on the readout buffer contains 12 frames, so the number of frames returned is rounded up(?) to the nearest 12. So T should be divisible by 25*12=300 in order to get exactly the number of bytes you expect)
FragHeader size = 72B
```

This results in an expected Fragment payload size of 22,272 bytes for 1200 tick trigger windows. However, currently one extra item is included in each Fragment (12 WIB frames), leading to a total Fragment size of 27,912 bytes.

See https://github.com/DUNE-DAQ/readout/issues/15 for details on this issue.
</details>