# Documentation Using sphinx

## Steps to install

- add the following to the requirments file:

```
# documentation with sphinx
# sphinx
sphinx
sphinx-rtd-theme
sphinxcontrib-ansibleautodoc
sphinxcontrib-websupport
myst-parser
```
- Install the package:

```
source venvjobsapp/bin/activate
pip install -r requirments
```

## Create documentation structure and chapters.
```
mkdir documentation
```

- run sphinx-quickstart in the folder documentation

```
(venvjobsapp) #jobs_app/documentation$ *sphinx-quickstart
Welcome to the Sphinx 5.2.3 quickstart utility.

Please enter values for the following settings (just press Enter to
accept a default value, if one is given in brackets).

Selected root path: .


You have two options for placing the build directory for Sphinx output.
Either, you use a directory "_build" within the root path, or you separate
"source" and "build" directories within the root path.
> Separate source and build directories (y/n) [n]: *y

The project name will occur in several places in the built documentation.
> Project name: *jobsapp
> Author name(s): *Menno de Gier
> Project release []: *1.0

If the documents are to be written in a language other than English,
you can select a language here by its language code. Sphinx will then
translate text that it generates into that language.

For a list of supported codes, see
https://www.sphinx-doc.org/en/master/usage/configuration.html#confval-language.
> Project language [en]:

Creating file ../fastapi/jobs_app/documentation/source/conf.py.
Creating file ../fastapi/jobs_app/documentation/source/index.rst.
Creating file ../fastapi/jobs_app/documentation/Makefile.
Creating file ../fastapi/jobs_app/documentation/make.bat.

Finished: An initial directory structure has been created.

You should now populate your master file ../fastapi/jobs_app/documentation/source/index.rst and create other documentation
source files. Use the Makefile to build the docs, like so:

   make builder

where "builder" is one of the supported builders, e.g. html, latex or linkcheck.

(venvjobsapp) #jobs_app/documentation$
```

- Change documentation template in conf.py

Edit the config.py file, which is located in the documentation folder 'source'
```
(venvjobsapp) /documentation$ vi source/conf.py
```

In here, change the template :
```
#html_theme = 'alabaster'
html_theme = 'sphinx_rtd_theme'
# to support md and rst add:
extensions = ['myst_parser']
source_suffix = {
    '.rst': 'restructuredtext',
    '.txt': 'markdown',
    '.md': 'markdown'
}
```

- update the index.rst to point to all the seperate documentation files.

## create the html documentation
Remake the html code, first run a clean to delete all old stuff.
```
make clean; make html
```
Look on the following link how your page looks like:

file:///<path to your project>/jobs_app/documentation/build/html/index.html


