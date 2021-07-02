
# Editing the documentation for a specific package

One of the main purposes of the official DUNE DAQ documentation is to
provide info about each package for its users. The webpages for each
package are generated off [Markdown
files](https://www.markdownguide.org/basic-syntax/) which need to be 
located in a `docs/` subdirectory in that package's repo. The one file
which must exist is `docs/README.md`; this serves as the homepage for
the package's documentation. It may provide links to other Markdown
files, or to other webpages, where necessary. Note that in this model,
it's possible to edit the documentation within a package's GitHub
page, making it easy to check for Markdown syntax errors before
committing. 

A few points need to be made:

- The documentation should be directed to a package's users, not its
  developers. Note that "a package's users" encompasses both those who
  use the applications in a package as well as those who use parts of
  the package's code (e.g., the base classes in the
  package). Documentation for a package's developers should be located
  in the package's GitHub wiki; examples of this would be discussion
  of a utility class's implementation, or instructions on how to run
  integration tests.

- On a technical level, it's good form to begin a given Markdown page with a top-level header that uniquely describes what the page covers (`# Introduction`, e.g., is too vague). This enables readers to better navigate between pages, as the website uses the top level header to refer to the pages in its table of contents. For pages more than a paragraph or so, individual sections should be used, introduced with second-level headers (i.e., headers beginning with a double hash mark, `##`).

- The documentation on a given branch in the package's git repo should
  reflect the behavior of the code on that branch.

- A corollary of this previous point is that if the code on a feature
  branch will alter the package in a way the user needs to be aware
  of, the documentation on the feature branch needs to be altered
  accordingly, and part of the review process for the merge into
  develop should be to ensure the new documentation is correct.

- Any `README.md` files in the base of a repo should either be moved into a
  `docs/` subdirectory of the repo, or deleted if obsolete

- Existing content on a package's GitHub Wiki pages can be copied into `docs/`. It's possible to grab the Markdown files corresponding to a GitHub Wiki with the command `git clone http://github.com/DUNE-DAQ/<package name>.wiki.git`, and then it's just a matter of copying the files into `docs/` and `git add`ing them. 

