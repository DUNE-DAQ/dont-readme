
_JCF, Jul-1-2021: The following is currently intended just for members of the Software Coordination group_

# How the official documentation works

The official documentation is housed in the [docs repo](https://github.com/DUNE-DAQ/docs). It includes 
a [homepage located in a README.md file](README.md) as well as documentation for each package. It displays at `https://dune-daq-sw.readthedocs.io/en/latest/`.

## Per-package documentation

Documentation for each package is copied over from each package's
repo, into a directory called `docs/packages/<package name>`. The
copying can (and should) be done by a script in the docs repo called
`bin/the_final_markdown.sh`. What it does is loop over a predetermined
set of packages (roughly, the packages in daq-buildtools' build order
list + daq-release and the style guide). For all packages, the develop
branch is used by default.

`bin/the_final_markdown.sh` looks
to see if the package has its own `docs/` subdirectory which contains markdown
files. If so, it'll copy the contents of that subdirectory into
`docs/packages/<package name>`. 

## If you want to make edits

If you want to make edits to a particular package, add and edit Markdown files in a `docs/` subdirectory. You can preview your work if you do this directly on the package's GitHub homepage.  

If you want to make edits to the docs repo itself, you could just edit
`docs/README.md`. If you want to add a new page entirely to the docs repo, you'll want
to not just physically add it but also figure out an appropriate link to it from `docs/README.md`. 

In the event that you'd want to make changes to the `mkdocs.yml` file used by the MkDocs documentation generator, then edit `bin/mkdocs_skeleton.yml`. This file is called as such because `bin/the_final_markdown.sh` will copy it into a `mkdocs.yml` file with the full list of Markdown files from all the packages, which MkDocs will actually use. 

On that note: if you run `bin/the_final_markdown.sh`, make sure to blow away the entire `docs/packages` directory and `mkdocs.yml` first, since `bin/the_final_markdown.sh` will create them. It'll remind you if you don't. 

Once you've got all the edits in place, make a commit. Assuming you're on the `develop` branch of the docs repo, when you push your commit to the central repo, it'll trigger a build under the dune-daq-docs account on the readthedocs website (ask JCF for the password). After a couple of minutes, unless there was a syntax error, you'll be able to see your handiwork at https://dune-daq-sw.readthedocs.io/en/latest/. 

## Seeing your edits without committing

### Perform your edits on a GitHub homepage

And hit "preview", as described above

### Getting your hands on mkdocs

You can use Python's pip to install mkdocs as described on MkDocs' main page, `https://www.mkdocs.org`. What I (JCF) did was set up a DUNE-DAQ work area, and then use "pip install mkdocs", so that whenever I `dbt-setup-build-environment` that area I get mkdocs.

### Running mkdocs at the commandline

Assuming you've got mkdocs as described above:
```
cd <your docs repo which you've edited>
mkdocs serve
```
It'll let you know if it can't parse the edits. Assuming it did, however, in another terminal open up `http://127.0.0.1:8000/` with your favorite browser, e.g. `firefox http://127.0.0.1:8000/ &`. You'll see what `https://dune-daq-sw.readthedocs.io/en/latest/` hypothetically would look like with your changes. Note that as you edit your copy of the docs repo, your edits will actually appear in your browser in real time. 


