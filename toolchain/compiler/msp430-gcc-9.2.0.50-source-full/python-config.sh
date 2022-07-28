#!/usr/bin/env bash

# This script sets up arguments required by the GDB build process for Windows
# hosts, when python support is enabled.

if [ -z "$PYTHON_WIN" ]; then
  echo "ERROR: Environment variable PYTHON_WIN must be defined to the full path \
to the extracted contents of python-2.7*.msi"
  exit 1
fi

while [ "$1" != "" ]; do
  case $1 in
    --prefix | --exec-prefix)
      echo "$PYTHON_WIN"
      ;;
    --includes )
      echo "-I$PYTHON_WIN"
      ;;
    --cflags)
      echo "-I$PYTHON_WIN $CFLAGS"
      ;;
    --libs | --ldflags)
      echo "-L$PYTHON_WIN -lpython27"
      ;;
    * )
      ;;
  esac
  shift
done

exit 0
