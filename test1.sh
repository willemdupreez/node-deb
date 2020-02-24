#!/bin/bash
set -e

myFunction () {
  : ${1?"forgot to supply an argument ${FUNCNAME[0]}() Usage:  ${FUNCNAME[0]} some_integer"}

  cat "$1"

}

myFunction 