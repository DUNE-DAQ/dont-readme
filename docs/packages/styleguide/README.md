# styleguide README

# C++ Style Guide (based on Google's C++ Style Guide)

###### tags: `Software Management` `DAQ` `DUNE`

-------
  * Table of Contents
        * [Background](#background)
        * [1.  C++ Version](#1--c-version)
        * [2. Naming Conventions](#2-naming-conventions)
        * [2.1 General Naming Rules](#21-general-naming-rules)
        * [2.2 File Names](#22-file-names)
        * [2.3 Type Names](#23-type-names)
        * [2.4 Variable Names](#24-variable-names)
        * [2.5 Function Names](#25-function-names)
        * [2.6 Namespace Names](#26-namespace-names)
        * [2.7 Enumerator Names](#27-enumerator-names)
        * [2.8 Macro Names](#28-macro-names)
        * [3.  Header Files](#3--header-files)
        * [3.1  Self-contained Headers](#31--self-contained-headers)
        * [3.2  The #define Guard](#32--the-define-guard)
        * [3.3  Forward Declarations [DUNE VERSION]](#33--forward-declarations-dune-version)
        * [3.4  Inline Functions](#34--inline-functions)
        * [3.5  Names and Order of Includes](#35--names-and-order-of-includes)
        * [3.6 Quotes vs. Angle Brackets for includes](#36-quotes-vs-angle-brackets-for-includes)
        * [4.  Scoping](#4--scoping)
        * [4.1  Namespaces](#41--namespaces)
        * [4.2  Unnamed Namespaces and Static Variables](#42--unnamed-namespaces-and-static-variables)
        * [4.3  Nonmember, Static Member, and Global Functions](#43--nonmember-static-member-and-global-functions)
        * [4.4  Local Variables](#44--local-variables)
        * [4.5  Static and Global Variables](#45--static-and-global-variables)
        * [5.  Classes](#5--classes)
        * [5.1  Doing Work in Constructors](#51--doing-work-in-constructors)
        * [5.2  Implicit Conversions](#52--implicit-conversions)
        * [5.3  Copyable and Movable Types](#53--copyable-and-movable-types)
        * [5.4  Structs vs. Classes](#54--structs-vs-classes)
        * [5.5  Structs vs. Pairs and Tuples](#55--structs-vs-pairs-and-tuples)
        * [5.6  Inheritance](#56--inheritance)
        * [5.7  Operator Overloading](#57--operator-overloading)
        * [5.8  Access Control](#58--access-control)
        * [5.9  Declaration Order](#59--declaration-order)
        * [6.  Functions](#6--functions)
        * [6.1  General guidelines for writing a function](#61--general-guidelines-for-writing-a-function)
        * [6.2  Output Parameters](#62--output-parameters)
        * [6.3  Write Short Functions](#63--write-short-functions)
        * [6.4  Reference Arguments](#64--reference-arguments)
        * [6.5  Function Overloading](#65--function-overloading)
        * [6.6  Default Arguments](#66--default-arguments)
        * [6.7  Trailing Return Type Syntax](#67--trailing-return-type-syntax)
        * [6.8  Ownership and Smart Pointers](#68--ownership-and-smart-pointers)
        * [7.  Other C++ Features](#7--other-c-features)
        * [7.1  Rvalue References](#71--rvalue-references)
        * [7.2  Friends](#72--friends)
        * [7.3  Exceptions](#73--exceptions)
        * [7.4  noexcept](#74--noexcept)
        * [7.5  Run-Time Type Information (RTTI)](#75--run-time-type-information-rtti)
        * [7.6  Casting](#76--casting)
        * [7.7  alias declarations and typedefs](#77--alias-declarations-and-typedefs)
        * [7.8  Streams](#78--streams)
        * [7.9  Printing Messages](#79--printing-messages)
        * [7.10  Increment and Decrement](#710--increment-and-decrement)
        * [7.11  Use of const](#711--use-of-const)
        * [7.12  Use of constexpr](#712--use-of-constexpr)
        * [7.13  Integer Types](#713--integer-types)
        * [7.14  Preprocessor Macros](#714--preprocessor-macros)
        * [7.15  0 and nullptr/NULL](#715--0-and-nullptrnull)
        * [7.16  sizeof](#716--sizeof)
        * [7.17  Type deduction](#717--type-deduction)
        * [8.  Comments](#8--comments)
        * [8.1  Intro](#81--intro)
        * [8.2  Comment Style](#82--comment-style)
        * [8.3  File Comments](#83--file-comments)
        * [8.3.1  Legal Notice and Author Line](#831--legal-notice-and-author-line)
        * [8.3.2  File Contents](#832--file-contents)
        * [8.4  Class Comments](#84--class-comments)
        * [8.5  Function Comments](#85--function-comments)
        * [8.5.1  Function Declarations](#851--function-declarations)
        * [8.5.2  Function Definitions](#852--function-definitions)
        * [8.6  Variable Comments](#86--variable-comments)
        * [8.6.1  Class Data Members](#861--class-data-members)
        * [8.6.2  Global Variables](#862--global-variables)
        * [8.7  Implementation Comments](#87--implementation-comments)
        * [8.8  Punctuation, Spelling, and Grammar](#88--punctuation-spelling-and-grammar)
        * [8.9  TODO Comments](#89--todo-comments)
        * [9.  Formatting](#9--formatting)
        * [10.  Exceptions to the Rules](#10--exceptions-to-the-rules)
-------

## Background 

C++ is the main development language of DUNE's DAQ software
processes. It is an unusually complex language, which can make code
more bug-prone and harder to read and maintain.

The goal of this guide is to manage this complexity by describing in
detail the dos and don'ts of writing C++ code for the DUNE data acquisition system. These rules exist to
keep the code base manageable while still allowing coders to use C++
language features productively. While it will take a certain amount of
time to learn these rules and adhering to them may mean that creating
a piece of code that "just works" might take a little longer than it
otherwise would, the payoff in terms of reduced debugging time and
increased readability will be well worth it.

Two further points to close out this intro:


* This guide is not a C++ tutorial: we assume that the reader is
familiar with the language.


* The DUNE DAQ C++ Style Guide is a modified fork of the Google C++ Style Guide https://google.github.io/styleguide/cppguide.html. Most of the modification involves loosening/simplifying Google's coding rules, as well as removing a lot of the justification for the rules in the interests of keeping this document (relatively) brief. If it's unclear why a given DAQ C++ guideline is in place, it's quite likely there's a relevant discussion on the topic in the Google Style Guide. 

## 1.  C++ Version 

Currently, code should target C++17, i.e., should not use C++2x
features.

## 2. Naming Conventions

The most important consistency rules are those that govern
naming. The style of a name immediately informs us what sort of
thing the named entity is: a type, a variable, a function, a
constant, etc., without requiring us to search for the
declaration of that entity. The pattern-matching engine in our
brains relies a great deal on these naming rules.

Naming rules are pretty arbitrary, but
 we feel that
consistency is more important than individual preferences in this
area, so regardless of whether you find them sensible or not,
the rules are the rules.

### 2.1 General Naming Rules

Optimize for readability using names that would be clear
even to people on a different team.

Use names that describe the purpose or intent of the object.
Do not worry about saving horizontal space as it is far
more important to make your code immediately
understandable by a new reader. Minimize the use of
abbreviations that would likely be unknown to someone outside
your project (especially acronyms and initialisms). Do not
abbreviate by deleting letters within a word unless it's obvious what's meant (e.g. "msg", "num", "max") or you define the full meaning of the abbreviation in a comment. Generally speaking, descriptiveness should be
proportional to the name's scope of visibility. For example,
`n` may be a fine name within a 5-line function,
but within the scope of a class, it's likely too vague. Here's an example of well-chosen names:

```c++
class MyClass {
 
public:
  
  int count_foo_errors(const std::vector<Foo>& foos) {
      int n = 0;  // Clear meaning given limited scope and context
      for (const auto& foo : foos) {
        ...
        ++n;
      }
    return n;
  }
  
  void do_something_important() {
    std::string daq_meltdown = ...;  // Pretty clear what "daq" abbreviation is!
  }
 
private:
  const int m_max_allowed_connections = ...;  // Clear meaning within context
};
```

And here's an example of poorly-chosen names:
```c++
class MyClass {

public:

  int count_foo_errors(const std::vector<Foo>& foos) {
    
    int total_number_of_foo_errors = 0;  // Overly verbose; "n" or even "num_errors" would be simpler
    
    for (int foo_index = 0; foo_index < foos.size(); ++foo_index) {  // "i" or even "i_f" would be simpler
      ...
      ++total_number_of_foo_errors;
    }
    return total_number_of_foo_errors;
  }

  void do_something_important() {
    int cstmr_id = ...;  // What on earth is a cstmr?? Abbreviation hurts here.
  }

private:
  const int m_num = ...;  // Unclear meaning within broad scope. Few names for an int could be worse than "num"
};
```

Note that certain universally-known abbreviations are OK, such as
`i` for an iteration variable and `T` for a
template parameter.

For the purposes of the naming rules below, a "word" is anything that you
would write in English without internal spaces. This includes abbreviations,
such as acronyms (e.g. "DAQ", "CERN"). Two naming conventions you need to be aware of for the discussion below are:


* *Pascal case*: Capitals used to distinguish words, with first letter capitalized: ThisIsInPascalCase

* *Snake case*: Underscores used to distinguish words, with all letters lowercase except optionally for acronyms

In Pascal case, it's preferred that you treat acronyms like other words, e.g., `StartRpc()` rather than
`StartRPC()`.

Template parameters should follow the naming style for their
category: type template parameters should follow the rules for
type names, and non-type template
parameters should follow the rules for variable names.

For DUNE DAQ software, if a variable name begins with a single letter followed by an underscore, that's meant to convey something about the variable's type (details below). For that reason, don't use this convention for any other purpose (e.g., use `num_widgets` instead of `n_widgets`).

### 2.2 File Names 

Files ending in `*.hpp`, `*.cpp` and `*.hxx` should use Pascal case (`MyClass.hpp`). Files ending in `*.cxx` should use snake case (`my_application.cxx`). The meaning of these extensions is described later in this document. 

### 2.3 Type Names 

The names of all types — classes, structs, type aliases,
enums, and type template parameters — use Pascal case. 

When making a type alias, however, additionally add a `_t` to the end. So, e.g.,
```
template<typename T>
using MyAllocList_t = std::list<T, MyAlloc<T>>;
```

### 2.4 Variable Names

The names of local variables, function parameters and struct data members should use snake case.  
E.g. `cool_local_variable`, `MyStruct.data_member`.

Non-static data members of classes should be prefixed with `m_`.  
For instance: `MyClass.m_data_member`.

If a variable is a static data member in a class it should be preceded with an `s_`.  
E.g., `MyClass.s_total_instances_of_this_class`. Static struct data members are discouraged.

If a variable is (unfortunately) a global, it should be preceded with a `g_`.  
E.g., `g_total_warning_messages`.

### 2.5 Function Names 

Both standalone functions and class member functions should use snake case (as is the situation with, e.g., the STL `<algorithm>` library).

Getters and setters should begin with `get_` or `set_`. E.g., `MessageSender::get_num_messages_sent()`. 

### 2.6 Namespace Names 

Namespace names are all lower-case, with words separated by underscores.

The top-level namespace of the DUNE DAQ codebase is `dunedaq`. For a given package, the next level namespace should have the same name as the DUNE DAQ package. So, e.g., the code for the appfwk package should be placed in the `dunedaq::appfwk` namespace.
. 

Avoid nested namespaces that match well-known top-level
namespaces. Collisions between namespace names can lead to surprising
build breaks because of name lookup rules. In particular, do not
create any nested `std` namespaces. 

### 2.7 Enumerator Names 

Enumerators should be in Pascal case, except prefaced with a `k`. E.g., 

```c++
enum class UrlTableError {
  kOk = 0,
  kOutOfMemory,
  kMalformedInput,
};
```

### 2.8 Macro Names 

You're not really going to
define a macro, are you? If you do, they're like this:
`MY_MACRO_THAT_SCARES_SMALL_CHILDREN_AND_ADULTS_ALIKE`.

Please see the description
of macros; in general macros should _not_ be used.
However, if they are absolutely needed, then they should be
named with all capitals and underscores.

```c++
#define UNAVOIDABLY_USEFUL_PLUGIN_LOADER(x) ...
```

## 3.  Header Files 

Header files should have an `.hpp` extension. They fall into one of two
categories: public header files (those meant to be included by code
using a library) and private header files (those only included by
library implementation files). Public header files shall be placed in
the `include/package_name` directory (where `package_name` is a
stand-in for the name of the package). Private headers typically are kept with
source files in the same directory.

In general, every `.cpp` file should have an associated `.hpp` file. There
are some common exceptions, such as unittests. Files which contain a `main()` function don't need a corresponding `.hpp` file, and end in `.cxx` rather than `.cpp`. 


### 3.1  Self-contained Headers 

Header files should be self-contained (compile on their own) and end in
`.hpp`. Non-header files that are meant for inclusion should end in `.inc`
and be used very rarely, with an exception which will be mentioned in a moment. 
Users and refactoring tools
should not have to adhere to special conditions to include the header.
Specifically, a header should have [header guards](#The__define_Guard)
and include all other headers it needs.

Prefer placing the definitions for inline and template functions in the
same file as their declarations. If the definitions are lengthy, you can accomplish this de-facto by putting them in a file with an `.hxx` extension in a subdirectory of the include directory called "detail" and including it after the declaration. E.g., if in Foo.hpp, we could have:
```c++
template <typename T>
class Foo {
public:
  void print_value(const T& val) const;      
};

// Foo.hxx has the definition of PrintValue
#include "detail/Foo.hxx"

```

The definitions of inline and template functions must be included into
every `.cpp` file that uses them, or the program may fail to link in
some build configurations. If declarations and definitions are in
different files, including the former should transitively include the
latter, as in the `.hxx` example. 

As an exception, a template that is explicitly instantiated for all
relevant sets of template arguments, or that is a private implementation
detail of a class, is allowed to be defined in the one and only `.cpp`
file that instantiates the template.


<a name="The__define_Guard"></a>
### 3.2  The \#define Guard 

All header files should have `#define` guards to prevent multiple
inclusion. The format of the symbol name should be
`<PROJECT>_<PATH>_<FILE>_HPP_`. The symbol should appear three times, like so:
```c++
#ifndef APP_FRAMEWORK_INCLUDE_APP_FRAMEWORK_DAQ_PROCESS_HPP_
#define APP_FRAMEWORK_INCLUDE_APP_FRAMEWORK_DAQ_PROCESS_HPP_
... 
#endif // APP_FRAMEWORK_INCLUDE_APP_FRAMEWORK_DAQ_PROCESS_HPP_
```

<a name="Forward_Declarations"></a>

### 3.3  Forward Declarations [DUNE VERSION]
[We're not going to forbid forward declarations, since while there are costs as described in the google style manual, the benefits of faster compilation outweigh these costs]

<a name="Inline_Functions"></a>

### 3.4  Inline Functions 

Define functions inline only when they are small, say, 10 lines or
fewer. Feel free to inline getters and setters, and other short,
performance-critical functions. Don't inline functions with loops or
switch statements (unless, in the common case, the loop or switch
statement is never executed).

<a name="Names_and_Order_of_Includes"></a>

### 3.5  Names and Order of Includes 

In *any* file which performs an include, if the included header is the
"related header" - meaning, you're editing foo.cpp and the header is
foo.hpp - put it before all the other headers.

Then, in order:

 - private headers
 - public headers from current package
 - public headers from other packages in project
 - public headers from external dependencies
 - standard library headers

All of a project's header files should be listed without use of UNIX directory aliases `.`
(the current directory) or `..` (the parent directory). For example, a private header
`awesomedaqproject/src/base/GetAllSupernovaData.hpp` should be included as:

```c++
#include "base/GetAllSupernovaData.hpp"
```

As of dunedaq-v2.0.0, include directories which are automatically picked up by your package are:

- `include/<package>` (for public headers)
- `src/` (private headers for files used in the package's main library and plugins)
- `test/src/` (private headers for files used in test applications/plugins)

You should include all the headers that define the symbols you rely
upon, except in the case of forward declarations. Note that the order of header
declarations described above helps enforce this rule. If you rely on
symbols from `Bar.hpp`, don't count on the fact that you included
`Foo.hpp` which (currently) includes `Bar.hpp`: include `Bar.hpp` yourself,
unless `Foo.hpp` explicitly demonstrates its intent to provide you the
symbols of `Bar.hpp`.

### 3.6 Quotes vs. Angle Brackets for includes

If a header comes from the C++ Standard Library (e.g., `<vector>`, `<cstdlib>`) it should be enclosed in angle brackets. All other headers should be enclosed in quotes. 

## 4.  Scoping


### 4.1  Namespaces 

With few exceptions, place code in a namespace. Avoid putting *using-directives* (e.g. `using namespace foo`) in header files, as any files which include them may risk name collisions and, worse, unexpected behavior when the "wrong" function/class is picked up by the compiler. They're less damaging when employed in source files and can reduce code clutter, but make sure to only use them *after* including all your headers, and be aware of their risks. 

Also in the vein of reducing code clutter, using-declarations (e.g., `using heavily::nested:namespace::foo::FooClass`) can be useful for improving readability. For unnamed namespaces, see [Unnamed Namespaces and Static
Variables](#Unnamed_Namespaces_and_Static_Variables).

When creating nonmember functions which work with a class, keep in mind that these functions are part of the class's interface and therefore should be in the same namespace as the class, though not necessarily the same files. 

Namespaces should be used as follows:

  - Terminate namespaces with comments as shown in the given examples.

  - Namespaces wrap the entire source file after includes,
    definitions/declarations
    and forward declarations of classes from other namespaces.
    
 ```c++
     // In the .hpp file
     namespace mynamespace {
     
     // All declarations are within the namespace scope.
     // Notice the indentation of four spaces

     class MyClass {
     public:
       ...
       void foo();
     };
     
     }  // namespace mynamespace
 
     // In the .cpp file
     namespace mynamespace {
     
     // Definition of functions is within scope of the namespace.
     void MyClass::foo() {
       ...
     }
     
     }  // namespace mynamespace
```

More complex `.cpp` files might have additional details, like using-declarations.
  
``` c++
    #include "AHeader.hpp"
    
    namespace mynamespace {
    
    using ::foo::Bar;
    
    ...code for mynamespace... 
    
    }  // namespace mynamespace
```


  - Do not declare anything in namespace `std`, including forward
    declarations of standard library classes. Declaring entities in
    namespace `std` is undefined behavior, i.e., not portable. To
    declare entities from the standard library, include the appropriate
    header file.
   

  - Do not use *Namespace aliases* at namespace scope in header files
    except in explicitly marked internal-only namespaces, because
    anything imported into a namespace in a header file becomes part of
    the public API exported by that file.
    
    The following are examples of proper use of a namespace alias:

  ``` c++  
        // Shorten access to some commonly used names in .cc files.
        namespace baz = ::foo::bar::baz;
    
        // Shorten access to some commonly used names (in a .hpp file).
        namespace librarian {
        namespace impl {  // Internal, not part of the API.
        namespace sidetable = ::pipeline_diagnostics::sidetable;
        }  // namespace impl
        
        inline void my_inline_function() {
          // namespace alias local to a function (or method).
          namespace baz = ::foo::bar::baz;
          ...
        }
        }  // namespace librarian
 ```

<a name="Unnamed_Namespaces_and_Static_Variables"></a>

### 4.2  Unnamed Namespaces and Static Variables 

When definitions in a `.cpp` file do not need to be referenced outside
that file, place them in an unnamed namespace or declare them `static`.
Do not use either of these constructs in `.hpp` files.

Format unnamed namespaces like named namespaces. In the terminating
comment, use a pair of double quotes in place of the (nonexistent) namespace name

Use unnamed namespaces/static variables for when it makes sense to maintain file scope (as opposed to local or global scope) for that variable. An example might be 

```c++
    namespace {
 
    void utility_function_only_meaningful_to_this_file() {
      ...
    }   

    }  // namespace ""
```

### 4.3  Nonmember, Static Member, and Global Functions 

 - Use completely global functions rarely, and only if there's a compelling reason

 - If a nonmember function can accomplish what a member function can, prefer a nonmember function. This is because the less code a class's data is exposed to, the less opportunity there is for bugs.

 - Nonmember functions should always be in a namespace, and unless there's a compelling reason to violate this rule, to go in the same namespace as the class it works with

 - Static methods of a class should generally be closely related to
instances of the class or the class's static data.


### 4.4  Local Variables

Declare local variables in as local a scope as possible, and as close to the
first use as possible. Always initialize variables in their declaration. 

There is one caveat: if the variable is an object, its constructor is
invoked every time it enters scope and is created, and its destructor is
invoked every time it goes out of scope.

``` c++
// Inefficient implementation:
for (int i = 0; i < 1000000; ++i) {
  Foo f;  // My constructor and destructor get called 1000000 times each!
  f.do_something(i);
}
```

For pointer variables, this would translate to initializing the pointer to nullptr:
``` c++

// Assume we don't yet know the Foo instance fptr will point to...
std::unique_ptr<Foo> fptr = nullptr;

if (able_to_read_data) {
  fptr.reset( new Foo() ); 
  // fill the Foo instance with the data
}
if (fptr != nullptr) {
  // send data
}
```


### 4.5  Static and Global Variables

The less complex the constructors and destructors of classes that are
used as static and global variables anywhere in the code, the
better. In particular, keep in mind there's no guarantee on the order
of construction of these variables, and hence code should never rely
on an assumed order.

Global variables are discouraged. When used, they should be `const` or, if possible, `constexpr`. 

## 5.  Classes 


### 5.1  Doing Work in Constructors 

 - Don't call any of a class's virtual functions in its constructor. This will not result in the correct invocation of subclass implementations of those virtual functions.

 - If an error occurs that will prevent the class from being constructed, have it throw an exception. As its destructor won't execute in this scenario, make sure you clean up any resources the constructor allocated before throwing.

 - Initialize a class's member in the constructor's member initialization list rather than assign to it in the constructor's body. An exception to this might be if the member class's default constructor is much faster than its other constructors/assignment operator, but it's not guaranteed that it'll even need to be assigned to. 


<a name="Implicit_Conversions"></a>

### 5.2  Implicit Conversions 

Type conversion operators, and constructors that are callable with a
single argument, should be marked `explicit` in the class definition
to avoid having them used to perform an implicit conversion in user
code. As an exception, copy and move constructors should not be
`explicit`, since they do not perform type conversion. Also, implicit
conversions can sometimes be necessary and appropriate for types that
are designed to transparently wrap other types; in this case an
exception to the rule is allowed.

Constructors that cannot be called with a single argument may omit
`explicit` since the C++ language does not consider multi-argument or
argument-free constructors for implicit conversions.


### 5.3  Copyable and Movable Types

If a class contains member data, each of its copy constructor, copy
 assignment operator, move constructor and move assignment operators
 must be either defined or explicitly deleted. "Defined" could be
 as simple as making explicit the use of the "default" keyword.


<a name="Structs_vs._Classes"></a>

### 5.4  Structs vs. Classes 

Always use a `class` rather than `struct` unless you're creating:

 - A passive object only meant to carry data
 - A small callable with an `operator()` defined

If using a struct to carry data, all fields must be public, and accessed directly rather than
through getter/setter methods. Any functions must not provide behavior
but should only be used to set up the data members, e.g., constructor,
destructor, `initialize()`, `reset()`.


### 5.5  Structs vs. Pairs and Tuples 

Prefer to use a `struct` instead of a pair or a tuple whenever the
elements can have meaningful names.

Exception: Pairs and tuples may be appropriate in generic code where
there are not specific meanings for the elements of the pair or
tuple. Their use may also be required in order to interoperate with
existing code or APIs.


<span id="Multiple_Inheritance"></span>

### 5.6  Inheritance 

When class B inherits from class A, it should almost always be public
inheritance ("inheritance of interface"). Protected and private
inheritance is known as "inheritance of implementation" and results in
less encapsulation than, say, having class B contain a member of class
A and use its functionality ("composition"). Multiple inheritance of implementation is *especially* bad. 

Explicitly annotate overrides of virtual functions or virtual
destructors with exactly one of an `override` or `final` specifier. Do
not use the keyword `virtual` in this case as this is already denoted
by one of those two specifiers.


### 5.7  Operator Overloading 

There's a limited set of circumstances in which it's OK to overload operators:

 - For copying, `operator=`. 
 - For type conversions, `operator()`. More in [implicit conversions](#Implicit_Conversions).
 - When defining comparison operators for a user-defined type
 - Outputting a type's value where it makes sense, by streaming with `operator<<`. Note this should be a nonmember function, not a member function of the type.


<a name="Access_Control"></a>

### 5.8  Access Control

In the interests of encapsulation, keep the access level of a class's
member functions only as generous as necessary. I.e., prefer private
functions over protected functions, protected functions over public
functions. Of course, use common sense: if you're writing an abstract
base class, your functions will be public!

In a class, never declare data as protected or public. Use accessor
functions if you must. 

### 5.9  Declaration Order

A class definition should start with a `public:` section,
followed by `protected:`, then `private:`. Omit sections that would be
empty.

Within each section, generally prefer grouping similar kinds of
declarations together, and generally prefer the following order: 

 - types (including alias declarations/`typedef`s, `using`, and nested structs and classes)
 - constants 
 - basic constructors (non-copy, non-move)
 - normal functions
 - copy constructor
 - copy assignment 
 - move constructor
 - move assignment
 - destructor
 - data members.

Do not put large method definitions inline in the class definition. See [Inline Functions](#Inline_Functions) for
more details.

## 6.  Functions

### 6.1  General guidelines for writing a function 

 - Have it do one thing, rather than many things (the "Swiss army knife" trap)
 - If it starts getting long (say, beyond 40 lines) think about ways it could be broken up into other functions
 - Prefer names that describe, to an appropriate level of precision, what the function does

### 6.2  Output Parameters 

If your function creates a single value and you don't anticipate it ever
needing to return more than a single value, have it return
it. Otherwise, use pass-by-reference in the argument list. These
output arguments should appear after the input arguments. Parameters
which serve both as input *and* output should be placed in-between.


### 6.3  Write Short Functions 
[Section eliminated, material covered in "general guidelines"]


### 6.4  Reference Arguments 
[Section eliminated for DUNE]


<a name="Function_Overloading"></a>

### 6.5  Function Overloading 

If a function is overloaded by the argument types alone, make sure its
behavior is very similar across the types, especially if the types are
themselves similar (e.g., std::string vs. const char*)

If the behavior is noticeably different, prefer different function names.

### 6.6  Default Arguments 

Default arguments are allowed on non-virtual functions when the
default is guaranteed to always have the same value. Always define the
value of the argument in the header, as it's part of the function's
interface.

### 6.7  Trailing Return Type Syntax

The only time it's OK to use a trailing return type (when the return type is listed after the function name and the argument list in the declaration; C++11) is when specifying
the return type of a lambda expression. In some
cases the compiler is able to deduce a lambda's return type, but not
in all cases.


### 6.8  Ownership and Smart Pointers

 - You should find yourself using `std::unique_ptr` more often than `std::shared_ptr`

 - Use of raw pointers should be very rare. One of the few times it's OK is when you want to point to an object where you don't want to change anything about its ownership.  

 - A corollary is that you should (almost) never use delete on a raw
pointer because we expect that the use of raw pointers in DUNE DAQ
will be limited to low-overhead access to pre-existing memory
buffers, in which the user does not have ownership of the memory
that is pointed to.

 - When using raw pointers, prefer `void*` to point to generic memory over a pointer to a specific type (such as char); this is because you can use a `static_cast` instead of a `reinterpret_cast` on `void*` to cast it to a pointer to the desired type. Of course, use of generic memory should be rare and only in low-level code where knowledge of the type really is absent. 


## 7.  Other C++ Features

### 7.1  Rvalue References

Use rvalue references to:

  - Define move constructors and move assignment operators. You should
    always have these defined when you've created a new type and
    there's the possibility that its copy operations may be
    significantly slower.

  - Support perfect forwarding in generic code

  - Define pairs of overloads, one taking `Foo&&` and the other taking
`const Foo&`, when this might improve performance

### 7.2  Friends 

Use friend classes and functions when alternatives result in less
encapsulation. An example of this would be if there's only one
nonmember function which you could imagine would ever need a given
member of a class - in this case, while you could make that given
member public, it would result in less encapsulation than use of a
friend function.

An appropriate use of a friend function is if you're overloading the streaming operator, `operator<<`, and want to print a type's private data.

You should typically define your friend function in the same file as the class it's a friend of, and almost always in the same namespace as the class. 

### 7.3  Exceptions 

Throw an exception if your code's encountered a problem it can't
recover from on its own. Don't throw if you can implement a local
recovery, and definitely don't throw exceptions as form of flow
control in the absence of any problems. 
 
Before you throw an exception, try to clean up as much as possible -
release resources, etc. RAII is your friend here. 

Like the parameters a function takes and a function's return value,
the types of exception a function throws are part of the interface it
presents to the caller. For this reason, think carefully when adding
an exception throw to a function other callers are already using. Will
they be able to handle the new exception? If not, can they at least
release resources correctly?

Never throw exceptions out of a destructor

Only use `catch(...)` directly inside of `main()`, and then only to clean up
resources before terminating the program

Catch by const reference, unless you plan to add info to the exception
before rethrowing it, in which case you should a non-const reference.

When you catch, print as much info about the exception as would be
useful to users of the program

Thrown exceptions should be declared ERS Issues. Prefer using already-defined
Issues over creating new ones. If creating a new ERS Issue, try to make it
as general as possible while still covering the specific issue encountered.
For example, prefer `CommandNotRegistered` over `StopCommandNotFound` as the
former can be used for any non-registered command.


### 7.4  `noexcept` 

If you've designed a type, strive to make its move and copy functions
noexcept. This is because compilers can perform optimizations when it
comes to STL functionality if noexcept is specified. 

Otherwise, use noexcept judiciously. Keep in mind you can't take it
back later, and that it's very hard to make this guarantee if you're
writing generic code. For this reason, intelligently choose your
conditionals inside of noexcept()

### 7.5  Run-Time Type Information (RTTI) 

The only time Run Time Type Information (RTTI) can be used is in code
meant to test other code.

### 7.6  Casting 

Do not use C-style casts (e.g., "(float)3.5" or "float(3.5)")

Use `reinterpret_cast` only for low level code, and only if you're sure
there's no safer approach

`const_cast` should almost never be used. Its use is often indicative
of a deeper problem in the design of the code.

### 7.7  alias declarations and `typedef`s 

Use alias declarations and `typedef`s to clarify the meaning of a type
in a given context. Prefer use of alias declarations; in particular,
use them when giving a templatized type a more-meaningful name, as
there's not a simple way to do this with `typedef`s. E.g.

```
template<typename T>
using MyAllocList_t = std::list<T, MyAlloc<T>>;

MyAllocList<Foo> foos;
```

### 7.8  Streams 
[Deleted; folded into the new "printing messages" section]


### 7.9  Printing Messages 

Use ERS for output. Never use alternatives (this includes printf, cout, etc.)

See the guidelines in the Exceptions section for declaring new ERS Issues.

Include as much information useful for debugging in warning/error
messages. E.g., rather than "Data found corrupt", go with "Data found
corrupt in data packet ID #8294 with timestamp 0x3527378 (55735160
decimal) in run 34872"

TRACE may be used for internal code tracing. Only levels 4 (TLVL_TRACE) and higher
should be used for this purpose.

Overload `<<` for streaming only for types representing values, and write only
the user-visible value, not any implementation details.

Take care that a given print statement not swamp other the output of
other equally-or-even-more-important messages

[Re: TRACE levels. Perhaps we should come up with a formal system for what levels for what time of messages? E.g., benchmark messages in trace levels 10-14, intermediate variable value messages in levels 15-19, etc.]

### 7.10  Increment and Decrement 

Unless in a loop construct, an increment (`++`) or decrement (`--`) of a
variable should exist on its own line. In particular, it should not be
used in an if statement.


### 7.11  Use of const 

Particularly since DUNE processes will involve many threads, intelligent use of `const` is important. 

Use `const` on variables whose values can't be known at compile time but nonetheless aren't to be changed after they're initialized. The exception is if you need to pass this type of variable to a (poorly-designed) API
which doesn't change the variable's value but doesn't declare it `const`
in its function signatures. While it's more common for developers to underuse rather than overuse `const`, a risk of overusing it is that it's a decision that's hard to reverse. If it turns out that `const` needs to be removed from a variable, realize that his decision will likely break other people's code which may have relied on its `const`-ness. If you make the decision to use `const`, realize it should be a permanent one. 

If a class method alters the class instance's physical state but not its logical
state, declare it const and use "mutable" so the compiler allows the physical changes.

`constexpr` is even better than `const`; use it when you can. constexpr is described [below](#Constexpr) .


<a name="Constexpr"></a>

### 7.12  Use of constexpr 

If a variable or function's return value is fixed at compile time and
you don't see this ever changing, declare it constexpr.  I say "don't
see this ever changing" since similar to "const" or "noexcept", changing this later will likely break other people's code.


### 7.13  Integer Types 

Unless you have a good reason not to, use `int`. An obvious good
reason would be that you need 64 bits to represent a value, e.g., a timestamp. Another would be that the variable represents a discrete quantity, in which case `size_t` would clarify its semantics. 

When you want a specific size in bytes, don't use C integer types
besides `int`: no `short`, `long`, etc. Use `intN_t`, N being the
number of bits.

You should not use the unsigned integer types such as `uint32_t`, unless
there is a valid reason such as representing a bit pattern rather than a
number, or you need defined overflow modulo 2^N. In particular, do not
use unsigned types to say a number will never be negative. Instead, use
assertions for this.

If your code is a container that returns a size, be sure to use a type
that will accommodate any possible usage of your container. When in
doubt, use a larger type rather than a smaller type.

Use care when converting integer types. Integer conversions and
promotions can cause undefined behavior, leading to security bugs and
other problems.

Code should be 64-bit friendly. [does it need to be 32-bit friendly?]


### 7.14  Preprocessor Macros 

While not explicitly forbidden, macros come with the very heavy price of the code you see not being the code the compiler sees, a problem compounded by their de-facto global scope. Avoid them if at all possible, using inline functions,
enums, `const` variables, and putting repeated code inside of functions. 

If you *must* write a macro, this will avoid many of their problems:

  - Don't define macros in a header file.
  - USE_ALL_CAPS_IN_YOUR_MACRO_NAME
  - `#define` macros right before you use them, and `#undef` them right
    after.
  - Do not just `#undef` an existing macro before replacing it with your
    own; instead, pick a name that's likely to be unique.
  - Try not to use macros that expand to unbalanced C++ constructs, or
    at least document that behavior well.
  - Have the variable names in your macro be very unlikely to be used elsewhere in unrelated code
  - Prefer not using `##` to generate function/class/variable names.


### 7.15  0 and nullptr/NULL 

Use `nullptr` for pointers, and `'\0'` for the null character. Don't use NULL, and definitely don't use the number "0" in this context. 

### 7.16  sizeof 

Prefer `sizeof(varname)` to `sizeof(type)`, unless you really do mean that you want the size of a particular type, and not a variable which happens to have the type in question. 


### 7.17  Type deduction 

The `auto` and `decltype` keywords save a lot of hassle for the

*writer* of a piece of code, but not necessarily for the

*reader*. Keep in mind the reader might be you in 18 months. Use your
best judgement as to when the benefits of these keywords (reduced code
clutter) outweigh the costs (the reader has trouble figuring out
the type of a variable).

While a function template can deduce the type of the argument, making
this explicit will typically make it clearer to both the code's reader
and to the compiler what it is you're trying to do.


## 8.  Comments

### 8.1  Intro 

Comments are absolutely vital to keeping our code readable. But
remember: while comments are very important, the best code is
self-documenting. Give sensible names to types and variables, and
don't make code "clever" unless it creates clear performance
improvements in bottleneck regions. If it's obvious what a function
does, don't clutter the code with a comment. E.g., don't do something
like this:

```
// "sqrt" calculates the square root of a variable
double sqrt(double); 
```

### 8.2  Comment Style

Use the `//` syntax instead of the old C-style `/* */` syntax. An exception is if you're developing a function which doesn't (yet?) use its arguments but you want to avoid an unused parameter warning, e.g.:

```
void foo(int /* appropriate name for the integer */) {
  // Code under development which doesn't (yet) use the integer
}
```

While the new C++17 attribute `[[maybe_unused]]` could also prevent
unused parameter warnings, save this for situations where you've
declared a variable and it really depends on the control flow of the
code whether or not it ends up being used. 

### 8.3  File Comments

Always include the brief license info described below under [Legal Notice](#Legal_Notice).

File comments describe the contents of a file. If a file declares,
implements, or tests exactly one abstraction that is documented by a
comment at the point of declaration, file comments are not required. All
other files must have file comments.

The comment at the top of a header file should never describe
implementation details the user of a class doesn't need to worry
about. Save those either for the source file, or for just above the
definition of an inline function if it's in the header file.

Comments are always in danger of growing stale as code changes. This
danger is greatest when it comes to the comment at the top of the
file. Be aware of this when you modify code, and update the comments
if necessary.


<a name="Legal_Notice"></a>
#### 8.3.1  Legal Notice and Author Line 

The following License stanza should be included in your Doxygen @file section:

```

* This is part of the DUNE DAQ Application Framework, copyright 2020.

* Licensing/copyright details are in the COPYING file that you should have received with this code.
```

[JCF, Mar-27-2020: The details of what license would be in the COPYING file are TBD, and should probably involve Giovanna]

#### 8.3.2  File Contents 

If a `.hpp` declares multiple abstractions, the file-level comment should
broadly describe the contents of the file, and how the abstractions are
related. A 1 or 2 sentence file-level comment may be sufficient. The
detailed documentation about individual abstractions belongs with those
abstractions, not at the file level.

Do not duplicate comments in both the `.hpp` and the `.cpp`. Duplicated
comments diverge.

### 8.4  Class Comments 

Every non-obvious class declaration should have an accompanying comment
that describes what it is for and how it should be used.

The class comment should provide the reader with enough information to
know how and when to use the class, as well as any additional
considerations necessary to correctly use the class. Document the
synchronization assumptions the class makes, if any. If an instance of
the class can be accessed by multiple threads, take extra care to
document the rules and invariants surrounding multithreaded use.


### 8.5  Function Comments 


Declaration comments describe use of the function (when it is
non-obvious); comments at the definition of a function describe
operation.

#### 8.5.1  Function Declarations 

Function declaration should have comments immediately
preceding it that describe what the function does and how to use it *unless* the function is simple and obvious. 

Types of things to mention in comments at the function declaration:

  - What the inputs and outputs are, if not obvious
  - For class member functions: whether the object remembers reference
    arguments beyond the duration of the method call, and whether it
    will free them or not.
  - Any non-obvious preconditions and postconditions. E.g., can a
    pointer argument be null? 
  - If there are any performance implications of how a function is used.
  - If the function is re-entrant. What are its synchronization
    assumptions?

When documenting function overrides, focus on the specifics of the
override itself, rather than repeating the comment from the overridden
function. In many of these cases, the override needs no additional
documentation and thus no comment is required.

When commenting constructors and destructors, remember that the person
reading your code knows what constructors and destructors are for, so
comments that just say something like "destroys this object" are not
useful. Document what constructors do with their arguments (for example,
if they take ownership of pointers), and what cleanup the destructor
does. If this is trivial, just skip the comment. It is quite common for
destructors not to have a header comment.


#### 8.5.2  Function Definitions 

If there is anything tricky about how a function does its job, the
function definition should have an explanatory comment. For example, in
the definition comment you might describe any coding tricks you use,
give an overview of the steps you go through, or explain why you chose
to implement the function in the way you did rather than using a viable
alternative. For instance, you might mention why it must acquire a lock
for the first half of the function but why it is not needed for the
second half.

Note you should *not* just repeat the comments given with the function
declaration, in the `.hpp` file or wherever. It's okay to recapitulate
briefly what the function does, but the focus of the comments should be
on how it does it.


### 8.6  Variable Comments 

In general the actual name of the variable should be descriptive enough
to give a good idea of what the variable is used for. 

#### 8.6.1  Class Data Members

If there are any invariants (special values, relationships between
members, lifetime requirements) not clearly expressed by the type and
name, they must be commented.

In particular, add comments to describe the existence and meaning of
sentinel values, such as nullptr or -1, when they are not obvious. 

#### 8.6.2  Global Variables

Along with the usual rules, a global variable should have a comment as
to why it needs to be global unless it's completely clear. 

[An idea: should people have to stick some easily-searchable token,
like DUNE_GLOBAL_VAR, in the comment, so it'll be easy to find global
variables?]

### 8.7  Implementation Comments 

In your implementation you should have comments in tricky,
non-obvious, interesting, or important parts of your code. Of course,
tricky and non-obvious code should be avoided unless absolutely
necessary.


### 8.8  Punctuation, Spelling, and Grammar

Pay attention to punctuation, spelling, and grammar; it is easier to
read well-written comments than badly written ones. In particular, a
spelling mistake can make it hard to grep for a comment in the future.

In general, comments should be in English. An exception might be if
you know the only people working on your code will be the fellow
speakers of your language, especially if they're not fluent in
English. Since this is a C++ style guide and not an English style
guide, it's understandable if English written by a non-native speaker
is less than perfect; however, don't hesitate to have a native English
speaker look over your comment if you feel it would help.

Generally, complete sentences are more readable than sentence
fragments. Shorter comments, such as comments at the end of a line of
code, can sometimes be less formal.

### 8.9  TODO Comments 

Use `TODO` comments for code that is temporary, a short-term solution,
or good-enough but not perfect. If possible provide a time estimate
(even if just something like "next few weeks") as to when you expect
something should be done.

`TODO`s should include the string `TODO` in all caps, followed by the
name, date, e-mail address, bug ID, or other identifier of the person or issue
with the best context about the problem referenced by the `TODO`. 

```
// TODO: John Freeman (jcfree@fnal.gov), Apr-14-2020

// In the next month, determine whether we can declare this function
// noexcept and consequently benefit from compiler optimizations.
```

Stale `TODO` comments should be reviewed. If they're no longer relevant,
they should be deleted. If they're still relevant, a message should be
sent to the person whose e-mail is given in the comment. When in
doubt, send an e-mail.


## 9.  Formatting 

 - Indentation should involve two spaces. Tabs should NOT be used.
 - Lines should (almost) always be less than 120 characters
 - Send your code through clang-format before committing, using the clang format file found in the configs/ subdirectory of daq-buildtools. Among other things, this file will enforce the indentation and line-length rules just described. 

## 10.  Exceptions to the Rules 

For new code, deviations from this guide should be quite rare. However: to the extent
that we reuse already-existing code in the DUNE DAQ codebase, the
already-existing code won't adhere to directives in this guide. If the
code is never going to be touched again, then this won't be a big
issue. If we plan on altering it in the future, it may be worth at
least getting it to be *somewhat* more conformant to the rules,
especially if the changes are relatively non-invasive (e.g., running
it through clang-format, as opposed to breaking up a long but
well-tested function). If anything about the style in existing code
may be confusing to future developers, it may be worth adding comments on
how the style deviates from the standard. 

-----
