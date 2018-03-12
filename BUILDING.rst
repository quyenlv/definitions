The GNU "make" program and Python are used to build the 
NeXus documentation.  The default build assembles
the HTML version.  You have the choice to 
build the documentation in two places:

* in the source tree
* out of the source tree

.. TODO: documentation how to build PDF version

In-Tree documentation
=====================

To build the NeXus documentation within the
source tree, go to the root directory
(the directory where this README file is located),
and type::

    make clean
    make

The HTML documentation is located in this folder::

    ./manual/build/html/


Building PDF document
---------------------

In order to build pdf file, you have to install LaTex in your build
server [1]_. But the LaTex packages in Linux is not sufficient enough.
The best way is to use the texlive_ offical installatioin tool to
install the full packages for texlive. It will take arround 4.5GB.

First, remove existing texlive packages if they are installed::

    yum erase texlive texlive*

Then download the install-tl.zip_ installation package from its website.

And execute the installation tools in the decompressed package::

    ./install-tl

It will download and install the packages/tools for texlive.

After it is done, set the path in your ~/.bashrc or a global
location accordingly::

    export PATH=/usr/local/texlive/2017/bin/i386-linux/:$PATH

Here, ``/usr/local/texlive/`` is the path you chose to install texlive.
If you choose another location, you can replace it with the one you used.
You can find this path in the installation report log::

    Welcome to TeX Live!


    See /usr/local/texlive/2017/index.html for links to documentation.
    The TeX Live web site (http://tug.org/texlive/) contains any updates and
    corrections. TeX Live is a joint project of the TeX user groups around the
    world; please consider supporting it by joining the group best for you. The
    list of groups is available on the web at http://tug.org/usergroups.html.


    Add /usr/local/texlive/2017/texmf-dist/doc/man to MANPATH.
    Add /usr/local/texlive/2017/texmf-dist/doc/info to INFOPATH.
    Most importantly, add /usr/local/texlive/2017/bin/i386-linux
    to your PATH for current and future sessions.

    Logfile: /usr/local/texlive/2017/install-tl.log

Next, we have to install the Latexmk, a ``make`` tool for building latext
documents. It is in the TeXLive package which we installed above. Just make
a symlink for ``latexmk`` command to the ``latexmk.pl`` script::

    ln -sf /usr/local/bin/latexmk /usr/local/texlive/2017/texmf-dist/scripts/latexmk/latexmk.pl

Make sure ``latexmk`` is executable, e.g., by using chmod suitably.

Finally, you can generate the pdf document by this command::

    make pdfdoc

The output file can be found in ``manual/build/latex``.


.. _install-tl.zip: http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
.. _texlive: https://www.tug.org/

Out-of-Tree documentation
=========================

There are two ways to build out-of-source.

Outside the source tree
-----------------------

To build the NeXus documentation outside the
source tree, 

#. create the target directory for the documentation to be built::

    mkdir /some/where/else

#. note the definitions source directory 
   (the directory where this README file is located)::

    export SOURCE_DIR=/path/to/nexus/definitions

#. copy the source to the target using this NeXus Python tool::

    cd /some/where/else
    python $(SOURCE_DIR)/utils/build_preparation.py $(SOURCE_DIR)

#. build the documentation::

    make clean
    make

The HTML documentation is located in this folder::

    /some/where/else/manual/build/html/


Inside the source tree, in a temporary directory
------------------------------------------------

Alternatively, as is a common practice with `cmake <https://cmake.org/>`_,
you can build *out-of-source* (sort of) in a temporary
``$(SOURCE_DIR)/build`` directory.  For this, the *Makefile*
has the *builddir* rule::

    export SOURCE_DIR=/path/to/nexus/definitions
    cd $(SOURCE_DIR)
    make builddir
    cd build
    make clean
    make

This is all done with one make command::

    export SOURCE_DIR=/path/to/nexus/definitions
    cd $(SOURCE_DIR)
    make makebuilddir

The HTML documentation is located in this folder::

    $(SOURCE_DIR)/build/manual/build/html/


Windows
=======

Windows development needs more instructions.
Use the *cmd.exe* shell to build the documentation, not 
the Windows powershell or there will be Python problems.

Python errors
-------------

On Windows, if the following error is output to the console 
after typing ``make html`` in the ``$(SOURCE_DIR)/manual`` directory:

  'python' is not recognized as an internal or external command,
  operable program or batch file.

it may be necessary to add Python to the ``PATH`` environment 
variable, such as one of these lines::

	set PATH=C:\Python27;%PATH%
	set PATH=D:\Apps\Anaconda;%PATH%

Try to avoid installing Python on a directory path that has 
embedded spaces.  Long series of tedious problems with that.


Reference
=========
.. [1] https://www.systutorials.com/qa/2339/how-to-install-tex-live-on-centos-7-linux
