#!/bin/bash

here=$(cd $(dirname $(readlink -f ${BASH_SOURCE})) && pwd)

# Reverse alphabetical order so the packages in the drop-down menu will appear in regular alphabetical order

# ...alphabetical, with the exception of the packages which are used
# for package development themselves

package_list="trigemu serialization restcmd readout rcif opmonlib nwqueueadapters minidaqapp logging listrev ipm ers dfmodules dfmessages dataformats cmdlib appfwk styleguide daq-release daq-cmake daq-buildtools"

mkdocs_yml="$here/../mkdocs.yml"

if [[ -e $mkdocs_yml ]]; then
    echo "You need to delete the existing $mkdocs_yml file before running this script, " >&2
    echo "since it will (re)construct $mkdocs_yml" >&2
    exit 4
fi

packages_dir="$here/../docs/packages"

if [[ -d $packages_dir ]]; then
    echo "You need to delete the existing $packages_dir directory before running this script, " >&2
    echo "since it will (re)construct the $packages_dir directory" >&2
    exit 5
fi

cp $here/mkdocs_skeleton.yml $mkdocs_yml

mkdir $packages_dir

tmpdir=$(mktemp -d)

if [[ -d $tmpdir ]]; then
    cd $tmpdir
else
    echo "Unable to create temporary directory $tmpdir; exiting..." >&2
    exit 3
fi

# JCF, Mar-5-2021

# What I've discovered is that GitHub wiki pages recognize
# indentations of three characters as implying a sublevel in a ToC,
# but MkDocs doesn't. Furthermore, if a line starts with a bullet (*),
# MkDocs won't interpret it as a bullet unless there's an empty line
# above it.

function massage() {

    markdown_file=$1

    if ! [[ "$markdown_file" =~ .*README.md$ ]]; then
	header=$( echo $markdown_file | sed -r 's!.*/(.*)!\1!;s/\-/ /g;s/\.md$//' )
    else
	package=$( echo $markdown_file | sed -r 's!.*/([^/]+)/README.md!\1!' )
	header="$package README"
    fi

    # Translation of the snippet below: "If the first non-empty,
    # non-italics-statement line in the file doesn't begin with a
    # single #, i.e., isn't a main title, then add one manually"

    if [[ -n $( sed -r -n '0,/^\s*\#[^\#]/{/^\s*\#[^\#]/d;/^\s*_/d;/^\s*$/d;p}' $markdown_file ) ]]; then
	sed -r -i "1s/^/# $header\n/"  $markdown_file 
    fi


    sed -r -i 's/^(\*.*)$/\n\1/;s/^ {3,4}(\*.*)/    \1/;s/^ {5,}(\*.*)/        \1/' $markdown_file
    sed -r -i 's/^([0-9]+\..*)/\n\1/' $markdown_file
    sed -r -i 's/^([0-9]+\..*)/\n\1/;s/^ {3,4}([0-9]+\.*)/    \1/;' $markdown_file

}

for package in $package_list ; do
    
    cd $tmpdir
    cmd="git clone https://github.com/DUNE-DAQ/$package"
    $cmd
    
    if [[ "$?" != "0" ]]; then
	echo "Error calling \"$cmd\"; exiting..." >&2
	exit 1
    fi

    cd $tmpdir/$package
    git checkout johnfreeman/dont-readme 2>/dev/null  # OK if this fails, just trying to see if the branch is available for developer purposes
    echo $tmpdir/$package

    if [[ -d $tmpdir/$package/docs/ || -e $tmpdir/$package/README.md ]]; then
	sed -r -i '/^\s*-\s*Packages\s*:.*/a \       - '$package':' $here/../mkdocs.yml
	mkdir -p $packages_dir/$package
    else
	echo "No docs/ subdirectory or README.md found for $package; no documentation will be generated" >&2
	continue
    fi

    # Add provenance of each markdown file

    for packagefile in $( find . -name "*.md" ); do
	echo >> $packagefile
	echo "-----" >> $packagefile
	echo >> $packagefile
	echo "_Last git commit to the markdown source of this page:_" >> $packagefile
	echo >> $packagefile
	echo >> $packagefile
	echo "_"$(git log -1 $packagefile | sed -r -n 's/^(Author.*)\s+\S+@.*/\1/p' )"_" >> $packagefile
	echo >> $packagefile
	echo "_"$(git log -1 $packagefile | grep Date )"_" >> $packagefile
	
    done

    if [[ -d $tmpdir/$package/docs/ && -n $(find $tmpdir/$package/docs -name "*.md" ) ]]; then
	echo "Found a docs/ subdirectory in repo $package, ignoring any README.md in the base of the repo"

	cp -rp $tmpdir/$package/docs/* $packages_dir/$package 

	if [[ "$?" != 0 ]]; then
	    echo "There was a problem copying the contents of $tmpdir/$package/docs into $packages_dir/$package ; exiting..." >&2
	    exit 2
	fi

	mdfilelist=""
	if [[ -n $( find  $packages_dir/$package -name "README.md" ) ]]; then
	    mdfilelist="$packages_dir/$package/README.md"
	fi
	mdfilelist=$( find $packages_dir/$package -name "*.md" -not -name "README.md" | sort --reverse )" $mdfilelist"

	for mdfile in $mdfilelist; do
	    massage $mdfile
	    
	    pagename=$( echo $mdfile | sed -r 's!^.*/(.*).md$!\1!' )
	    mdfile_relative=$( echo $mdfile | sed -r 's!^.*/docs/(.*)!\1!' )
	    sed -r -i '/^\s*-\s*'$package'\s*:.*/a \          - '$pagename': '$mdfile_relative $here/../mkdocs.yml

	done

    else # No docs/ directory with markdown files found
	if [[ -e $tmpdir/$package/README.md ]]; then
	    cp -p $tmpdir/$package/README.md $packages_dir/$package
	    mdfile=$packages_dir/$package/README.md 
	    massage $mdfile
	    mdfile_relative=$( echo $mdfile | sed -r 's!^.*/docs/(.*)!\1!' )
	    sed -r -i 's!^(\s*)-(\s*)'$package'(\s*):!\1-\2'$package'\3: '$mdfile_relative'!' $here/../mkdocs.yml
	fi
    fi

done

if [[ -d $tmpdir && "$tmpdir" =~ ^/tmp/.*$ ]]; then
    rm -rf $tmpdir
fi
