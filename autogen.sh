#!/bin/sh
set -x

# autopoint || exit 1
aclocal || exit 1
# libtoolize --force || exit 1
# autoheader || exit 1
automake --add-missing --foreign || exit 1
autoconf || exit 1
./configure --enable-maintainer-mode $@
