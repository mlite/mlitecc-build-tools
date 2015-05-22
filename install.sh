#!/bin/bash
PACKAGE_DIR=`pwd`
INSTALL_DIR=/usr/local

success=1
check_installation() {
   ret=$?
   if [ $ret -ne 0 ]; then
      echo "$ret install \"$1\" failed, please fix this problem and install this package manually" >> $PACKAGE_DIR/install.err
      success=0
   fi
}

delete_folders () {
  if [ $success -eq 1 ]; then
    echo ""
    echo ""
    echo "Installation Succeeds"
    echo ""
    echo "Add $INSTALL_DIR/bin to your PATH"
    echo "Add $PACKAGE_DIR/qc--20090627/bin to your PATH"
  else
    echo ""
    echo ""
    echo "Installation Fails"
    echo ""
    echo "Some packages are not installed correctly, "
    echo "please check install.err and manually install thest packages."
  fi
}
# install ocaml
install_ocaml()
{
    gzip -dc $PACKAGE_DIR/ocaml-3.09.3.tar.gz | tar xvf -
    cd ocaml-3.09.3
    ./configure -prefix $INSTALL_DIR
    make world
    make opt
    make install
    check_installation ocaml ocaml
    cd ..
    # set up the path for ocamlc which will 
    # be used by findlib installation
    export PATH=$INSTALL_DIR/bin:$PATH
}



# install findlib
install_findlib()
{
    gzip -dc $PACKAGE_DIR/findlib-1.2.4.tar.gz | tar xvf -
    cd findlib-1.2.4
    ./configure -bindir $INSTALL_DIR/bin -mandir $INSTALL_DIR/man -sitelib $INSTALL_DIR/lib/ocaml -config $INSTALL_DIR/etc/findlib.conf 
    make all
    make opt
    make install
    check_installation findlib ocamlfind
    cd ..
}

# install zlib
install_zlib()
{
    gzip -dc $PACKAGE_DIR/zlib-1.2.3.tar.gz | tar xvf -
    cd zlib-1.2.3
    ./configure --prefix=$INSTALL_DIR 
    make
    make install
    check_installation zlib
    cd ../
}

# install camlzip
install_camlzip()
{
    gzip -dc $PACKAGE_DIR/camlzip-1.04.tar.gz | tar xvf -
    cd camlzip-1.04
    ./configure --with-mlite-build-tools=$INSTALL_DIR
    make all 
    make allopt
    make install
    check_installation camlzip
    cd ../
}

# install gmp
install_gmp()
{
    gzip -dc $PACKAGE_DIR/gmp-4.3.2.tar.gz | tar xvf -
    cd gmp-4.3.2
    check_installation gmp
    make
    make install
    ./configure --prefix=$INSTALL_DIR
    cd ../
}

# install mpfr
install_mpfr()
{
    gzip -dc $PACKAGE_DIR/mpfr-2.4.2.tar.gz | tar xvf -
    cd mpfr-2.4.2
    ./configure --prefix=$INSTALL_DIR CPPFLAGS="-I$INSTALL_DIR/include" LDFLAGS="-L$INSTALL_DIR/lib"
    make
    make install
    check_installation mpfr
    cd ../
}

# install noweb
install_noweb()
{
    gzip -dc $PACKAGE_DIR/noweb-2.11b.tar.gz | tar xvf -
    cd noweb-2.11b/src
    make 
    mkdir $INSTALL_DIR/tex
    mkdir $INSTALL_DIR/tex/inputs
    make INSTALL_DIR=$INSTALL_DIR install
    check_installation noweb
    cd ../../
}

# install ocaml-tools
install_ocaml_makefile()
{
    gzip -dc ocaml_makefile.tar.gz | tar xvf -
    mv ocaml_makefile $INSTALL_DIR
}

# install readline
install_readline()
{
    gzip -dc $PACKAGE_DIR/readline-6.1.tar.gz | tar xvf -
    cd readline-6.1
    ./configure --prefix=$INSTALL_DIR
    make
    make install
    check_installation readline
    cd ../
}

# install lua
install_lua()
{
    gzip -dc $PACKAGE_DIR/lua-4.0.tar.gz | tar xvf -
    cd lua
    make INSTALL_ROOT=$INSTALL_DIR 
    make INSTALL_ROOT=$INSTALL_DIR install
    check_installation lua
    cd ../
}


install_mk()
{
    gzip -dc $PACKAGE_DIR/mk-20090627.tar.gz | tar xvf -
    cd mk-1.6
    make PREFIX=$INSTALL_DIR install
    check_installation mk
    cd ../
}

install_qcmm()
{
    gzip -dc $PACKAGE_DIR/qc--20090627.tar.gz | tar xvf - 
    cd qc--20090627
    ./configure 
    mk timestamps
    mk qc--
    mk qc--.opt
    mk install
    check_installation "qc--" 
    cd ..
}

if test "$1" == ""; then
    echo "Usage $0 <installation_path>"
    echo "<installation_path> must be an absolute path"
    exit 
else
    INSTALL_DIR=$1
fi


if [ -d $INSTALL_DIR ]; then
    rm -rf $INSTALL_DIR
fi
mkdir $INSTALL_DIR
export PATH=$INSTALL_DIR/bin:$PATH
rm -f install.err
install_ocaml
install_findlib
install_zlib
install_camlzip
install_gmp
install_mpfr
install_noweb
install_readline
install_lua
install_mk
install_qcmm
delete_folders
