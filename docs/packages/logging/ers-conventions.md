# Conventions for ERS issues

This document describes conventions and best practices for using ERS issues in the DUNE DAQ software. You can find more information about how ERS works in the [ERS documentation](https://dune-daq-sw.readthedocs.io/en/latest/packages/ers/).

## Issue naming

Each ERS issue is an instance of a class, with different information carried by different classes. The classname should not be vague, but specific and meaningful. An example of a too-vague issue name is `ConfigurationError`. A more useful name might be `CannotOpenFile`, especially if the attributes give more details.

The issue name should indicate the action that caused the issue, eg `CannotAllocateBuffer`, `CannotOpenFile`, `CannotOpenSocket`, `StartOfRun`, `EndOfRun`, `TimestampMismatch`, `CorruptFragment`. Avoid putting "error" or "warning" in the issue name; the severity of the issue depends on the context, and this is indicated by the stream it is reported on.

In some cases you may want to have a higher level issue for grouping a set of failure causes. To do this, chain the underlying reason into the issue. For example, 
`CannotCompleteCommand` was caused by `CannotOpenFile` was caused by `FileDoesNotExist`.

Issue chaining with a throw:

```cpp
try {
     open(“pippo.txt”);
}
catch (ers::Issue & open_issue) { 
     throw CannotCompleteCommand(ERS_HERE,“conf”, open_issue);
     //                                           ^^^^^^^^^^
     //        This argument causes the issues to be chained
     //        "CannotCompleteCommand was caused by [description of open_issue]"
}
```

```cpp
try {
    frag->decode();
    do_something(frag);
}
catch (ers::Issue &decode_issue) {
    ers::warning(CorruptFragment(ERS_HERE, decode_issue));
    //                                     ^^^^^^^^^^^^
    // "CorruptFragment was caused by [description of decode_issue]"
}
```

Chaining issues is a powerful mechanism to enrich the information for whatever or whoever will need to handle it. Each software layer can add information to provide additional context to the problem.

## Throwing vs reporting

ERS Issues can be thrown with the regular C++ `throw` statement, or reported using ERS-specific mechanisms. 

When to throw: in library code, throw when the requested action cannot be completed. It's then the caller's responsibility to deal with the exception. It's also OK to throw in command-handling methods of `DAQModule` (eg, in `do_configure` if configuration is impossible).

When to report: Don't throw if the issue cannot be caught: e.g. if you spawn a thread and throw in its run loop, your process will crash making any type of reaction (as well as diagnosing) impossible. Don't assume that your thread has the "right" to destroy the whole application. In this case report the issue using `ers::warning`, `ers::error`, or `ers::fatal` depending on the severity of the problem. 

## Issue inheritance

It is possible to define a base class for a set of issues (all issues derive from `ers::Issue`). Inheritance is particularly relevant for the catching/handling part. For example, we can have a 
general `CorruptFragment` issue with a more specialized `WrongTimestamp` derived issue:

```cpp
ERS_DECLARE_ISSUE(
  dunedaq,                                                       // namespace
  CorruptFragment,                                               // issue name
  "Received corrupt fragment for trigger request ID << trig_num, // message
  ((const uint64_t trig_num))                                    // attribute
)

// Derived issue
ERS_DECLARE_ISSUE_BASE(
  dunedaq,                                               // namespace
  WrongTimestamp,                                        // issue name
  dunedaq::CorruptFragment,                              // base issue name
  "Timestamp of fragment for trigger request ID "        // message
  << trig_num << " is " << wrong_ts << " instead of "
  << right_ts,
  ((const uint64_t trig_num)),                           // base class attributes
  ((const uint64_t wrong_ts) (const uint64_t right_ts)), // derived class attributes
)
```

These could be used in a `try..catch` block like so:

```cpp
try {
  frag->decode();
  do_something(frag);
}
catch (WrongTimestamp &ex) {
  do_something_special();
}
catch (CorruptFragment &ex) {
  // This block catches CorruptFragment and any derived issues apart from WrongTimestamp
  do_something_else();
}
catch (ers::Issue &ex) {
  // This block catches any ERS issues that don't derive from CorruptFragment
  ers::warning(FragmentDropped(ERS_HERE, ex));
}
```

## Severities

Severities are chosen based on the impact to the application:

### Information
Report something that needs to be known but is not indicative of any problem (e.g. `ChangedTriggerPrescales`).

### Warning
Report a specific anomaly that is not affecting the functioning of the application, but needs attention (e.g. `EmptyFragmentReceived`, `DuplicateFragmentReceived`)

### Error
Report an anomaly that is persistent and will likely not be solved without external intervention (e.g. `NoDataFromLink`, `DiskAlmostFull`)

### Fatal
Report a major problem that does not allow the application to continue working (e.g. `DiskFull`, `NoMemoryLeft`). Note that issuing an `ers::fatal` does not necessarily terminate the application.
