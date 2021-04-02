# ipm README
# ipm
Inter-Process Messaging

PAR 2021-01-26: To build the HEAD of `develop`, you'll need to make the following modifications to `dbt-settings`:


1. Add `/cvmfs/dune.opensciencegrid.org/dunedaq/DUNE/products`


2. Change the `zmq` line to `"zmq v4_3_1c e19:prof"`


3. Add the `cppzmq` product: `"cppzmq v4_3_0 e19:prof"`
See https://github.com/DUNE-DAQ/appfwk/wiki/Compiling-and-running-under-v2.2.0#adding-extra-ups-products-and-product-pools for more about this.

The IPM library provides the low-level library for for sending messages between DUNE DAQ processes. IPM deals with messages consisting of arrays of bytes: higher-level concepts such as object serialization/deserialization will be handled by other libraries and processes building on IPM.

IPM provides two communication patterns:



1. `Sender`/`Receiver`, a pattern in which one sender talks to one receiver


2. `Publisher`/`Subscriber`, a pattern in which one sender talks to zero or more receivers. Each message goes to all subscribers

Users should interact with IPM via the interfaces `dunedaq::ipm::Sender`, `dunedaq::ipm::Receiver` and `dunedaq::ipm::Subscriber`, which are created using the factory functions `dunedaq::ipm::makeIPM(Sender|Receiver|Subscriber)`, which each take a string argument giving the implementation type. The currently-available implementation types all use ZeroMQ, and are:


* `ZmqSender` implementing `dunedaq::ipm::Sender` in the sender/receiver pattern

* `ZmqReceiver` implementing `dunedaq::ipm::Receiver`

* `ZmqPublisher` implementing `dunedaq::ipm::Sender` in the publisher/subscriber pattern

* `ZmqSubscriber` implementing `dunedaq::ipm::Subscriber`

Basic example of the sender/receiver pattern:

```c++
// Sender side
std::shared_ptr<dunedaq::ipm::Sender> sender=dunedaq::ipm::makeIPMSender("ZmqSender");
sender->connect_for_sends({ {"connection_string", "tcp://127.0.0.1:12345"} });
void* message= ... ;
// Last arg is send timeout
sender->send(message, message_size, std::chrono::milliseconds(10));

// Receiver side
std::shared_ptr<dunedaq::ipm::Receiver> receiver=dunedaq::ipm::makeIPMReceiver("ZmqReceiver");
receiver->connect_for_receives({ {"connection_string", "tcp://127.0.0.1:12345"} });
// Arg is receive timeout
Receiver::Response response=receiver->receive(std::chrono::milliseconds(10));
// ... do something with response.data or response.metadata
```

Basic example of the publisher/subscriber pattern:

```c++
// Publisher side
std::shared_ptr<dunedaq::ipm::Sender> publisher=dunedaq::ipm::makeIPMSender("ZmqPublisher");
publisher->connect_for_sends({ {"connection_string", "tcp://127.0.0.1:12345"} });
void* message= ... ;
// Third arg is send timeout; last arg is topic for subscribers to subscribe to
publisher->send(message, message_size, std::chrono::milliseconds(10), "topic");

// Subscriber side
std::shared_ptr<dunedaq::ipm::Subscriber> subscriber=dunedaq::ipm::makeIPMReceiver("ZmqSubscriber");
subscriber->connect_for_receives({ {"connection_string", "tcp://127.0.0.1:12345"} });
subscriber->subscribe("topic");
// Arg is receive timeout
Receiver::Response response=subscriber->receive(std::chrono::milliseconds(10));
// ... do something with response.data or response.metadata
```

More complete examples can be found in the `test/plugins` directory.

## Developer Testing

The simplest set of tests to run are, of course, the unit tests; assuming you've got the ipm repo in your development area, performing the unit tests is done in the standard manner as described in the "Compiling and Running" instructions linked to at the top of the document. 

For integration tests, the simplest thing is to make sure that you can send data between processes on the same host. This can be checked with the `sourcecode/ipm/schema/ipm-zmqsender-job.json` and `sourcecode/ipm/schema/ipm-zmqreceiver-job.json` scripts which can be passed to `daq_application`. Note that these script make use of appfwk's `FakeDataProducerDAQModule` and `FakeDataConsumerDAQModule` DAQ modules; as these modules are in appfwk's test area and consequently not installed, you'll need to put the appfwk repo in your source area rather than relying on it in its installed form. 

In two separate terminals, log in to the same node twice, and set yourself up for compiling and running as described in the instructions. The variable which will define the socket over which the two processes will communicate is called `connection_string` so, e.g., 
```
grep connection_string sourcecode/ipm/schema/ipm-zmqsender-job.json
```
yields
```
"connection_string": "tcp://127.0.0.1:29870"
```
and similarly for `ipm-zmqreceiver-job.json`. This means that the socket will be on the localhost at port 29870. Of course, make sure that port isn't being used, i.e., that
```
netstat -tlpn | grep 29870
```
doesn't list that port as already being listened on. If it _is_ in use, then you'll want to use a different port, and of course mentally substitute that port for the 29870 used here. 

Then, in terminal one, we'll launch a process which will send out vectors via TCP:
```
daq_application -c stdin://sourcecode/ipm/schema/ipm-zmqsender-job.json
```
and take the job up through the "conf" transition. Since the receiving process isn't receiving (and in fact doesn't exist) if you try to go through the "start" transition an error will occur. In the second terminal, if you type `netstat -tlpn | grep 29870` you'll see that the port is now in use, something along the lines of:
```
tcp        0      0 127.0.0.1:29870         0.0.0.0:*               LISTEN      38624/daq_applicati
```
Now let's launch the receiving process in the second terminal:
```
daq_application -c stdin://sourcecode/ipm/schema/ipm-zmqreceiver-job.json
```
and take it through the "start" transition. You should see something like:
```
2020-Dec-30 15:00:12,241 INFO [dunedaq::appfwk::FakeDataConsumerDAQModule::do_work(...) at /home/jcfree/daqbuild_v2.0.0_instructions/sourcecode/appfwk/test/plugins/FakeDataConsumerDAQModule.cpp:96] FDC: do_work
```
Then go back to the first terminal, and issue the "start" transition to the sending process. Data should begin flowing. In particular, the sending process should look like:
```
2020-Dec-30 15:01:24,907 DEBUG_0 [dunedaq::appfwk::FakeDataProducerDAQModule::do_work(...) at /home/jcfree/daqbuild_v2.0.0_instructions/sourcecode/appfwk/test/plugins/FakeDataProducerDAQModule.cpp:118] Produced vector 2 with contents {-3, -2, -1, 0, 1, 2, 3, 4, 5, 6} and size 10 DAQModule: fdp
2020-Dec-30 15:01:24,907 INFO [dunedaq::appfwk::FakeDataProducerDAQModule::do_work(...) at /home/jcfree/daqbuild_v2.0.0_instructions/sourcecode/appfwk/test/plugins/FakeDataProducerDAQModule.cpp:122] FDP "fdp" push 2
12-30 15:01:25.907032 ZmqSender     INFO send_(...): Starting send of 40 bytes
12-30 15:01:25.907060 ZmqSender     INFO send_(...): Completed send of 40 bytes
2020-Dec-30 15:01:25,907 INFO [dunedaq::ipm::VectorIntIPMSenderDAQModule::do_work(...) at /home/jcfree/daqbuild_v2.0.0_instructions/sourcecode/ipm/test/plugins/VectorIntIPMSenderDAQModule.cpp:107] : Sent 3 vectors DAQModule: viis
```
and the receiving process should look like:
```
2020-Dec-30 15:01:31,909 INFO [dunedaq::ipm::VectorIntIPMReceiverDAQModule::do_work(...) at /home/jcfree/daqbuild_v2.0.0_instructions/sourcecode/ipm/test/plugins/VectorIntIPMReceiverDAQModule.cpp:106] : Received vector 8 with size 10 DAQModule: viir
2020-Dec-30 15:01:32,252 INFO [dunedaq::appfwk::FakeDataConsumerDAQModule::do_work(...) at /home/jcfree/daqbuild_v2.0.0_instructions/sourcecode/appfwk/test/plugins/FakeDataConsumerDAQModule.cpp:108] FDC "fdc" pop 8
2020-Dec-30 15:01:32,252 DEBUG_0 [dunedaq::appfwk::FakeDataConsumerDAQModule::do_work(...) at /home/jcfree/daqbuild_v2.0.0_instructions/sourcecode/appfwk/test/plugins/FakeDataConsumerDAQModule.cpp:122] Received vector 8: {0, 1, 2, 3, 4, 5, 6, 7, 8, 9} DAQModule: fdc
```
Once you're satisfied with the result, you can terminate `daq_application` as you normally would. 
