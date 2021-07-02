#!/bin/bash

here=$(cd $(dirname $(readlink -f ${BASH_SOURCE})) && pwd)

# Reverse alphabetical order so the packages in the drop-down menu will appear in regular alphabetical order

# ...alphabetical, with the exception of the packages which are used
# for package development themselves

package_list="trigger trigemu timinglibs timing serialization restcmd readout rcif opmonlib nwqueueadapters nanorc minidaqapp logging listrev ipm influxopmon flxlibs erses ers dfmodules dfmessages dataformats cmdlib appfwk styleguide daq-release daq-cmake daq-buildtools"

mkdocs_yml="$here/../mkdocs.yml"

if [[ -e $mkdocs_yml ]]; then
    echo "You need to delete the existing $mkdocs_yml file before running this script, " >&2
    echo "since it will (re)construct $mkdocs_yml" >&2
    exit 4
fi

packages_dir="$here/../docs/packages"
docs_dir="$here/../docs"

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

    # JCF, Mar-5-2021

    # What I've discovered is that GitHub wiki pages recognize
    # indentations of three characters as implying a sublevel in a ToC,
    # but MkDocs doesn't. Furthermore, if a line starts with a bullet (*),
    # MkDocs won't interpret it as a bullet unless there's an empty line
    # above it.

    sed -r -i 's/^(\*.*)$/\n\1/;s/^ {2,4}(\*.*)/    \1/;s/^ {5,}(\*.*)/        \1/' $markdown_file
    sed -r -i 's/^([0-9]+\..*)/\n\1/' $markdown_file
    sed -r -i 's/^([0-9]+\..*)/\n\1/;s/^ {2,4}([0-9]+\.*)/    \1/;' $markdown_file

    # JCF, Mar-25-2021
    # Convert wiki syntax of the form [[link name][other_markdown_page.md]] to [link name](other_markdown_page.md)
    
    sed -r -i 's/\[\[(.+)\|([^#]+).*\]\]/[\1](\2.md)/' $markdown_file 

}

function add_trailer() {
    
    package=$1
    packagefile=$2

    echo >> $packagefile
    echo >> $packagefile
    echo "-----" >> $packagefile
    echo >> $packagefile
    echo "<font size=\"1\">" >> $packagefile
    echo "_Last git commit to the markdown source of this page:_" >> $packagefile
    echo >> $packagefile
    echo >> $packagefile
    echo "_"$(git log -1 $packagefile | sed -r -n 's/^(Author.*)\s+\S+@.*/\1/p' )"_" >> $packagefile
    echo >> $packagefile
    echo "_"$(git log -1 $packagefile | grep Date )"_" >> $packagefile
    echo >> $packagefile
    echo "_If you see a problem with the documentation on this page, please file an Issue at [https://github.com/DUNE-DAQ/$package/issues](https://github.com/DUNE-DAQ/$package/issues)_" >> $packagefile
    echo "</font>" >> $packagefile
    
}

for package in $package_list ; do
    
    cd $tmpdir
    cmd="git clone https://github.com/DUNE-DAQ/$package"
    $cmd
    
    if [[ "$?" != "0" ]]; then
	echo "Error calling \"$cmd\"; exiting..." >&2
	exit 1
    fi

    # The master branch of nanorc has been used for development instead of the develop branch
    cd $tmpdir/$package
    if ! [[ "$package" =~ "logging" ]]; then
	git checkout develop
    else
	git checkout kbiery/SmallDocChange
    fi
    echo $tmpdir/$package

    if [[ -d $tmpdir/$package/docs/ && -n $(find $tmpdir/$package/docs -name "*.md" )  ]]; then
	mkdir -p $packages_dir/$package
    else
	echo "No docs/ subdirectory containing Markdown files found for $package; no documentation will be generated" >&2
	continue
    fi

    # Add provenance of each markdown file

    for packagefile in $( find . -name "*.md" ); do
	add_trailer $package $packagefile
    done

    if [[ -d $tmpdir/$package/docs/ && -n $(find $tmpdir/$package/docs -name "*.md" ) ]]; then
	echo "Found a docs/ subdirectory in repo $package containing Markdown files"

	cp -rp $tmpdir/$package/docs/* $packages_dir/$package 

	if [[ "$?" != 0 ]]; then
	    echo "There was a problem copying the contents of $tmpdir/$package/docs into $packages_dir/$package ; exiting..." >&2
	    exit 2
	fi

	mdfilelist=""
	if [[ -n $( find  $packages_dir/$package -name "README.md" ) ]]; then
	    mdfilelist="$packages_dir/$package/README.md"
	fi
	mdfilelist=$( find $packages_dir/$package -name "*.md" -not -name "README.md" | sort --reverse --ignore-case )" $mdfilelist"

	for mdfile in $mdfilelist; do
	    massage $mdfile
	    
	    mdfile_relative=$( echo $mdfile | sed -r 's!^.*/docs/(.*)!\1!' )
	    pagename=$( echo $mdfile | sed -r 's!^.*/(.*).md$!\1!' )
	    if [ x"${pagename}" == "xREADME" ]; then
		pagename=$( echo About ${package} )
		echo "+===+++ ${package} ===== ${mdfile} ==== $pagename"
		if [[ -z $( sed -r -n '/^\s*-\s*'$package'\s*:.*/p' $here/../mkdocs.yml ) ]]; then
		    echo "Error: package \"$package\" is meant to be handled by this script but isn't found in $here/../mkdocs.yml" >&2
		    exit 3
		fi
		sed -r -i '/^\s*-\s*'$package'\s*:.*/a \             - '"$pagename"': '$mdfile_relative $here/../mkdocs.yml
	    else
		sed -r -i '/^\s*-\s*'$package'\s*:.*/a \             - '$mdfile_relative $here/../mkdocs.yml
	    fi

	done
    fi

done

if [[ -d $tmpdir && "$tmpdir" =~ ^/tmp/.*$ ]]; then
    rm -rf $tmpdir
fi

