dnl initialize autoconf
AC_INIT(amik, 0.0.1,
   http://dangerouslyinc.com,
   amik)

dnl initialize automake
AM_INIT_AUTOMAKE

dnl authors
AC_SUBST_FILE(AUTHORS)
AUTHORS=$srcdir/AUTHORS

dnl AM_MAINTAINER_MODE only provides the option to configure to enable it
AM_MAINTAINER_MODE

dnl check for python
AM_PATH_PYTHON(2.4)

dnl check for where to install our python stuff
dnl PYTHONLIBDIR=`$PYTHON -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"`
PYVER=[`$PYTHON -c "import sys ; print sys.version[:3]"`]
PYTHONLIBDIR=${prefix}/share/amik/python/
AC_MSG_NOTICE(Installing python code in $PYTHONLIBDIR)
AC_SUBST(PYTHONLIBDIR)

DATADIR=${prefix}/share/amik/
AC_SUBST(DATADIR)

dnl output stuff
AC_CONFIG_FILES([
Makefile
amik.spec
bin/Makefile
bin/amik
data/Makefile
amik/Makefile
amik/util/Makefile
amik/util/config.py
],
[chmod +x bin/amik]
)

AC_OUTPUT()
