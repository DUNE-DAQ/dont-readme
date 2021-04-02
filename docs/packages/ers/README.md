# ers README
# Error Reporting Service (ERS)

The Error Reporting System (ERS) software package provides a common API for error reporting
in the ATLAS TDAQ system. ERS offers several macro that can be used for reporting pre-defined 
errors if some conditions are violated at the level of C++ code. ERS also provides tools for 
defining custom classes that can be used for reporting high-level issues.


The Error Reporting System (ERS) software package provides a common API for error reporting
in the ATLAS TDAQ system.
ERS offers several macro that can be used for reporting pre-defined errors if some
conditions are violated at the level of C++ code. ERS also provides tools for defining
custom classes that can be used for reporting high-level issues.

## Header File
In order to use ERS functionality an application has to include a single header file **ers/ers.h**

## Assertion Macro
ERS provides several convenience macro for checking conditions in a C++ code. If a certain condition
is violated a corresponding macro creates a new instance of **ers::Assertion** class and sends it to
the **ers::fatal** stream. Further processing depends on the **ers::fatal** stream configuration.
By default the issue is printed to the standard error stream.

Here is a list of available macro:
 * **ERS_ASSERT( expression )** generic macro that checks whether a given expression is valid.
 * **ERS_PRECONDITION( expression )** the same as ERS_ASSERT but uses a message that is adopted
for reporting an invalid input parameter for a function.
 * **ERS_RANGE_CHECK( min, val, max )** is a special type of pre-condition, which checks that a value
is in a range between min and max values. 
 * **ERS_STRICT_RANGE_CHECK( min, val, max )** is similar to the ERS_RANGE_CHECK
but does not allow the checked value to be equal to either min or max values. 

> **Note:** These macro are defined to empty statements if **ERS_NO_DEBUG** macro is defined at compilation time.

The amount of information, which is printed for an issue depends on the actual ERS verbosity level,
which can be controlled via the **DUNEDAQ_ERS_VERBOSITY_LEVEL** macro. Default verbosity level is zero.
In this case the following information is reported for any issue:
 * severity (DEBUG, LOG, INFO, WARNING, ERROR, FATAL)
 * the time of the issue occurrence
 * the issue's context, which includes package name, file name, function name and line number
 * the issue's message

One can control the current verbosity level via the **DUNEDAQ_ERS_VERBOSITY_LEVEL** macro:

~~~
export DUNEDAQ_ERS_VERBOSITY_LEVEL=N
~~~

where N must be an integer number.

 * For N > 0 the issue attributes names and values are reported in addition to 0-level data
 * For N > 1 the following information is added to the issue:
        * host name
        * user name
        * process id
        * process current working directory
 * For N > 2 a stack trace is added to each issue if the code was compiled without **ERS_NO_DEBUG** macro.

## Using Custom Issue Classes
ERS assumes that user functions should throw exceptions in case of errors. If such exceptions
are instances of classes, which inherit the **ers::Issue** one, ERS offers a number of advantages with 
respect to their handling:
 * ERS issues can be reported to any ERS stream
 * One can create chains of issues to preserve the original cause of the problem as well as the error handling sequence
 * ERS issues can be printed to a standard C++ output stream using the output operator provided by ERS

In order to define a custom issue one has to do the following steps:
 * Declare a class, which inherits **ers::Issue**
 * Implement 3 pure virtual functions, declared in the ers:Issue class
 * Register new class using the **ers::IssueFactory::register_issue** function

ERS defines two helper macro, which implement all these steps. The macro are called ERS_DECLARE_ISSUE
and ERS_DECLARE_ISSUE_BASE. The first one should be used to declare an issue class that inherits
from the **ers::Issue** as it is shown on the following example:

~~~cpp
ERS_DECLARE_ISSUE(
ers,                                                              // namespace
    Assertion,                                                    // issue name
    "Assertion (" << condition << ") failed because " << reason,  // message
    ((const char *)condition )                                    // first attribute
    ((const char *)reason )                                       // second attribute
)
~~~

Note that attribute names may appear in the message expression. Also note a special
syntax of the attributes declaration, which must always be declared using a list of 

**((attribute_type)attribute_name)** tokens.
All the brackets in this expression are essential. Do not use commas to separate attributes.
The only requirement for the type of an issue attribute is that for this type must be defined the output
operator to the standard C++ output stream and the input operator from the standard C++ input
stream. It is important to note that these operators must unambiguously match each other, i.e.
the input operator must be able to unambiguously restore the state of the attribute from a stream,
which had been used to save the object's state with the output operator. Evidently all the
built-in C++ types satisfy this criteria.
The result of the **ERS_DECLARE_ISSUE** macro expansion would look like:

~~~cpp
namespace ers {
    class Assertion : public ers::Issue {
        template <class> friend class ers::IssueRegistrator;
        Assertion() { ; }
        
        static const char * get_uid() { return "ers::Assertion"; }
        
        virtual void raise() const throw( std::exception ) { throw *this; }
        virtual const char * get_class_name() const { return get_uid(); }
        virtual ers::Issue * clone() const { return new ers::Assertion( *this ); }
        
    public:
        Assertion( const ers::Context & context , const char * condition , const char * reason )
            : ers::Issue( context ) {
            set_value( "condition", condition );
            set_value( "reason", reason );
            std::ostringstream out;
            out << "Assertion (" << condition << ") failed because " << reason;
            set_message( out.str() );
        }
        
        Assertion( const ers::Context & context, const std::string & msg , const char * condition , const char * reason )
            : ers::Issue( context, msg ) {
            set_value( "condition", condition );
            set_value( "reason", reason );
        }
        
        Assertion( const ers::Context & context , const char * condition , const char * reason , const std::exception & cause )
            : ers::Issue( context, cause ) {
            set_value( "condition", condition );
            set_value( "reason", reason );
            std::ostringstream out;
            out << "Assertion (" << condition << ") failed because " << reason;
            set_message( out.str() );
        }
        
        const char * get_condition () {
            const char * val;
            get_value( "condition", val );
            return val;
        }
        
        const char * get_reason () {
            const char * val;
            get_value( "reason", val );
            return val;
        }
    };
}
~~~


The macro **ERS_DECLARE_ISSUE_BASE** has to be used if one wants to declare a new issue class,
which inherits from one of the other custom ERS issue classes. For example, the following class
inherits from the **ers::Assertion** class defined above:

~~~cpp
ERS_DECLARE_ISSUE_BASE(ers,                                          // namespace name
      Precondition,                                                  // issue name
      ers::Assertion,                                                // base issue name
      "Precondition (" << condition << ") located in " << location
    << " failed because " << reason,                                 // message
      ((const char *)condition ) ((const char *)reason ),            // base class attributes
       ((const char *)location )                                     // this class attributes
)
~~~

The result of the **ERS_DECLARE_ISSUE_BASE** macro expansion looks like:

~~~cpp
namespace ers {
    class Precondition : public ers::Assertion {
        template <class> friend class ers::IssueRegistrator;
        Precondition() { ; }
        
        static const bool registered = ers::IssueRegistrator< ers::Precondition >::instance.done;
        static const char * get_uid() { return "ers::Precondition"; }
        
        virtual void raise() const throw( std::exception ) { throw *this; }
        virtual const char * get_class_name() const { return get_uid(); }
        virtual ers::Issue * clone() const { return new ers::Precondition( *this ); }
        
    public:
        Precondition( const ers::Context & context , const char * condition , const char * reason, const char * location )
            : ers::Assertion( context, condition, reason ) {
                set_value( "location", location );
            std::ostringstream out;
            out << "Precondition (" << condition << ") located in " << location << ") failed because " << reason;
            set_message( out.str() );
        }
        
        Precondition( const ers::Context & context, const std::string & msg , const char * condition , const char * reason, const char * location )
            : ers::Assertion( context, msg, condition, reason ) {
            set_value( "location", location );
        }
        
        Precondition( const ers::Context & context , const char * condition , const char * reason , const char * location, const std::exception & cause )
            : ers::Assertion( context, condition, reason, cause ) {
            set_value( "location", location );
            std::ostringstream out;
            out << "Precondition (" << condition << ") located in " << location << ") failed because " << reason;
            set_message( out.str() );
        }
        
        const char * get_location () {
            const char * val;
            get_value( "location", val );
            return val;
        }
    };
}
~~~

## ERS_HERE macro
The macro ERS_HERE is a convenience macro that is used to add the context information, like the file name,
the line number and the signature of the function where the issue was constructed, to the new issue object.
This means that when a new issue is created one shall always use ERS_HERE macro as the first parameter of the
issue constructor.

## Exception Handling
Functions, which can throw exceptions must be invoked inside **try...catch** statement.
The following example shows a typical use case of handling ERS exceptions.

~~~cpp
#include <ers/SampleIssues.hpp>

    try {
        foo( );
    }
    catch ( ers::PermissionDenied & ex ) {
        ers::CantOpenFile issue( ERS_HERE, ex.get_file_name(), ex );
        ers::warning( issue );
    }
    catch ( ers::FileDoesNotExist & ex ) {
        ers::CantOpenFile issue( ERS_HERE, ex.get_file_name(), ex );
        ers::warning( issue );
    }
    catch ( ers::Issue & ex ) {
        ERS_DEBUG( 0, "Unknown issue caught: " << ex )
        ers::error( ex );
    }
    catch ( std::exception & ex ) {
        ers::CantOpenFile issue( ERS_HERE, "unknown", ex );
        ers::warning( issue );
    }
~~~

This example demonstrates the main features of the ERS API:
 * An issue does not have severity by itself. Severity of the issue is defined by the stream to which this issue is reported.
 * An issue can be send to one of the existing ERS streams using one of the following functions:
ers::debug, ers::info, ers::warning, ers::error, ers::fatal
 * Any ERS issue has a constructor, which accepts another issue as its last parameter. If this
constructor is used the new issue will hold the copy of the original one and will report it as its cause.
 * Any ERS issue has a constructor, which accepts std::exception issue as its last parameter.
    If it is used the new issue will hold the copy of the given std::exception one and will report it as its cause.

## Configuring ERS Streams
The ERS system provides multiple instances of the stream API, one per severity level, to report issues.
The issues which are sent to different streams may be forwarded to different destinations depending on a
particular stream configuration. By default the ERS streams are configured in the following way:
 * ers::debug - "lstdout" - prints issues to the standard C++ output stream
 * ers::log - "lstdout" - prints issues to the standard C++ output stream
 * ers::info - "throttle,lstdout" - prints throttled issues to the standard C++ output stream
 * ers::warning - "throttle,lstderr" - prints throttled issues to the standard C++ error stream
 * ers::error - "throttle,lstderr" - prints throttled issues to the standard C++ error stream
 * ers::fatal - "lstderr" - prints issues to the standard C++ error stream

> **Note:** the letter "l" at the beginning of "lstdout" and "lstderr" names indicates that these stream
> implementations are thread-safe and can be safely used in multi-threaded applications so that
> issues reported from different threads will not be mixed up in the output.

In order to change the default configuration for an ERS stream one should use
the **DUNEDAQ_ERS_<SEVERITY>** environment variable. For example the following command:

~~~
export DUNEDAQ_ERS_ERROR="lstderr,throw" 
~~~

will cause all the issues, which are sent to the ers::error stream, been printed to 
the standard C++ error stream and then been thrown using the C++ throw operator.

A filter stream can also be associated with any severity level. For example:

~~~ 
export DUNEDAQ_ERS_ERROR="lstderr,filter(ipc),throw" 
~~~

The difference with the previous configuration is that only errors, which have "ipc" qualifier
will be passed to the "throw" stream. Users can add any qualifiers to their specific issues
by using the **Issue::add_qualifier** function. By default every issue has one qualifier associated
with it - the name of the TDAQ software package, which builds the binary (a library or an application)
where the issue object is constructed.

One can also define complex and reversed filters like in the following example:

~~~
> export DUNEDAQ_ERS_ERROR="lstderr,filter(!ipc,!is),throw"
~~~

This configuration will throw all the errors, which come neither from "ipc" nor from "is" TDAQ packages.

### Existing Stream Implementations
ERS provides several stream implementations which can be used in any combination in ERS streams configurations.
Here is the list of available stream implementations:
 * "stdout" - prints issues to the standard C++ output stream. It is not thread-safe.
 * "stderr" - prints issues to the standard C++ error stream. It is not thread-safe.
 * "lstdout" - prints issues to the standard C++ output stream. It is thread-safe.
 * "lstderr" - prints issues to the standard C++ error stream. It is thread-safe.
 * "lock" - locks a global mutex for the duration of reporting an issue to the next streams in the given configuration.
This stream can be used for adding thread-safety to an arbitrary non-thread-safe stream implementation. For example
"lock,stdout" configuration is equivalent to "lstdout".
 * "null" - silently drop any reported issue.
 * "throw" - apply the C++ throw operator to the reported issue
 * "abort" - calls abort() function for any issue reported
 * "exit" - calls exit() function for any issue reported
 * "filter(A,B,!C,...)" - pass through only issues, which have either A or B and don't have C qualifier
 * "rfilter(RA,RB,!RC,...)" - the same as "filter" stream but treats all the given parameters as regular expressions.
 * "throttle(initial_threshold, time_interval)" - rejects the same issues reported within the **time_interval** after
passing through the **initial_threshold** number of them.

## Custom Stream Implementation
While ERS provides a set of basic stream implementations one can also implement a custom one if this is required.
Custom streams can be plugged into any existing application which is using ERS without recompiling this application.

### Implementing a Custom Stream
In order to provide a new custom stream implementation one has to declare a sub-class of the ers::OutputStream
class and implement its pure virtual method called **write**. Here is an example of how this is done by the 
FilterStream stream implementation:

~~~cpp
void
ers::FilterStream::write( const ers::Issue & issue )
{
    if ( is_accepted( issue ) ) {
        chained().write( issue );
    }
}
~~~

An implementation of the **ers::OutputStream::write** function must decide whether to pass the given
issue to the next stream in the chain or not. If a custom stream does not provide any filtering
functionality then it shall always pass the input message to the next stream by using the

**chained().write( issue )** code.

### Registering a Custom Stream
In order to register and use a custom ERS stream implementation one can use a dedicated macro called

**ERS_REGISTER_STREAM** in the following way:

~~~
ERS_REGISTER_OUTPUT_STREAM( ers::FilterStream, "filter", format )
~~~

The first parameter of this macro is the name of the class which implements the new stream; the second one
gives a new stream name to be used in ERS stream configurations (this is the name which one can put to the

**DUNEDAQ_ERS_<SEVERITY>** environment variables); and the last parameter is a placeholder for the stream class
constructor parameters. If the constructor of the new custom stream does not require parameters then last
field of this macro should be left empty.

### Using Custom Stream
In order to use a custom stream one has to build a new shared library from the class that implements this stream
and pass this library to ERS by setting its name to the **DUNEDAQ_ERS_STREAM_LIBS** environment variable.
For example if this macro is set to the following value:

~~~
export  DUNEDAQ_ERS_STREAM_LIBS=MyCustomFilter
~~~

then ERS will be looking for the libMyCustomFilter.so library in all the directories which appear in the 

**LD_LIBRARY_PATH** environment variable.

## Error Reporting in Multi-threaded Applications
ERS can be used for error reporting in multi-threaded applications. As C++ language does not provide a way of
passing exceptions across thread boundaries, ERS provides the **ers::set_issue_catcher** function to overcome this
limitation.
When one of the threads of a software application catches an issue it can send it to one of the the ERS
streams using **ers::error,** **ers::fatal** or **ers::warning** functions. If no error catcher thread is installed
in this application the new issue will be forwarded to the respective ERS stream implementations according to the
stream configuration. Otherwise if a custom issue catcher is installed the issue will be passed to the dedicated
thread which will call the custom error catcher function.

### Setting up an Error Catcher
An error catcher should be installed by calling the **ers::set_issue_catcher** function and passing
it a function object as parameter. This function object will be executed in the context of a dedicated
thread (created by the **ers::set_issue_catcher** function) for every issue which is reported by the current
application to ers::fatal, ers::error and ers::warning streams.
The parameter of the ers::set_issue_catcher is of the **std::function<void** ( const ers::Issue & )> type
which allows to use plain C-style functions as well as C++ member functions for implementing a custom error
catcher. For example one can define an error catcher as a member function of a certain class:

~~~cpp
struct IssueCatcher {
   void handler( const ers::Issue & issue ) {
      std::cout << "IssueCatcher has been called: " << issue << std::endl;
   }
};
~~~

This error catcher can be registered with ERS in the following way:

~~~cpp
IssueCatcher * catcher = new IssueCatcher();
ers::IssueCatcherHandler * handler;
try {
    handler = ers::set_issue_catcher( std::bind( &IssueCatcher::handler, catcher, std::placeholders::_1 ) );
}
catch(ers::IssueCatcherAlreadySet & ex){
    ...
}
~~~

Note that the error handling catcher can be set only once for the lifetime of an application. 
An attempt to set it again will fail and the **ers::IssueCatcherAlreadySet** exception will be thrown.

To unregister a previously installed issue catcher one need to destroy the handler that is returned by
the **ers::set_issue_catcher** function using **delete** operator:

~~~cpp
delete handler;
~~~

##Receiving Issues Across Application Boundaries
There is a specific implementation of ERS input and output streams which allows to exchange issue
across application boundaries, i.e. one process may receive ERS issues produces by another processes.
The following example shows how to do that:

~~~cpp
#include <ers/InputStream.hpp>
#include <ers/ers.hpp>

struct MyIssueReceiver : public ers::IssueReceiver {
    void receive( const ers::Issue & issue ) {
        std::cout << issue << std::endl;
    }
};

MyIssueReceiver * receiver = new MyIssueReceiver;
try {
    ers::StreamManager::instance().add_receiver( "mts", "*", receiver );
}
catch( ers::Issue & ex ) {
    ers::fatal( ex );
}
~~~

The MyIssueReceiver instance will be getting all messages, which are sent to the "mts" stream implementation
by all applications working in the current TDAQ partition whose name will be taken from the **DUNEDAQ_PARTITION** 
environment variable. Alternatively one may pass partition name explicitly via the "mts" stream parameters list:

~~~cpp
MyIssueReceiver * receiver = new MyIssueReceiver;
try {
    ers::StreamManager::instance().add_receiver( "mts", {"my partition name", "*"}, receiver );
}
catch( ers::Issue & ex ) {
    ers::fatal( ex );
}
~~~

To cancel a previously made subscription one should use the **ers::StreamManager::remove_receiver** function 
and giving it a pointer to the corresponding receiver object, e.g.:

~~~cpp
try {
    ers::StreamManager::instance().remove_receiver( receiver );
}
catch( ers::Issue & ex ) {
    ers::error( ex );
}
~~~

