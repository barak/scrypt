#!/bin/sh

VERSION=$1
if [ -z $VERSION ]; then
	echo "Please specify the version number"
	exit 1
fi
DESTDIR=scrypt-${VERSION}
RELEASEDATE=$(date "+%B %d, %Y")

# Copy bits in
mkdir ${DESTDIR} ${DESTDIR}/autotools
cp scrypt_platform.h main.c FORMAT COPYRIGHT ${DESTDIR}
cp Makefile.am configure.ac .autom4te.cfg ${DESTDIR}
cp Makefile.am configure.ac ${DESTDIR}/autotools
cp -R lib libcperciva tests ${DESTDIR}
# Copy with substitution
sed -e "s/@DATE@/$RELEASEDATE/" < scrypt.1.in > scrypt.1
cp scrypt.1.in scrypt.1 ${DESTDIR}

# Generate autotools files
( cd ${DESTDIR}
autoreconf -i
rm .autom4te.cfg Makefile.am aclocal.m4 configure.ac )

# Create tarball
tar -czf ${DESTDIR}.tgz ${DESTDIR}
rm -r ${DESTDIR}
